_get_dtype(::Type{Float32}) = SLU_S
_get_dtype(::Type{Float64}) = SLU_D
_get_dtype(::Type{ComplexF32}) = SLU_C
_get_dtype(::Type{ComplexF64}) = SLU_Z

_get_matrix_size(b::StridedVector) = (length(b), 1)
_get_matrix_size(b::StridedMatrix) = size(b)
_get_matrix_strides(b::StridedVector) = (stride(b, 1), length(b))
_get_matrix_strides(b::StridedMatrix) = strides(b)


function splu(s::SparseMatrixCSC{Tv, <:Integer}) where {Tv<:SuperLUValueTypes}
    options_arr = Vector{superlu_options_t}(undef, 1)
    set_default_options(options_arr)
    options = options_arr[1]
    lu = _splu(s, options)
    return lu
end

function splu(s::Transpose{Tv, SparseMatrixCSC{Tv, Ti}}) where {Tv<:SuperLUValueTypes, Ti}
    options_arr = Vector{superlu_options_t}(undef, 1)
    set_default_options(options_arr)
    options = options_arr[1]
    lu = _splu(s.parent, options)
    # return Transpose{Tv, typeof(lu)}(lu)
    return Transpose(lu)
end

function _splu(
    s::SparseMatrixCSC{Tv, Ti},
    options::superlu_options_t;
    panel_size::SuperLUInt = sp_ienv(1),
    relax::SuperLUInt = sp_ienv(2)
) where {Tv<:SuperLUValueTypes, Ti<:Integer}
    dtype = _get_dtype(Tv)

    m::SuperLUInt, n::SuperLUInt = size(s)
    nnz::SuperLUInt = length(s.nzval)

    nzval::Vector{Tv} = s.nzval
    rowind::Vector{SuperLUInt} = [SuperLUInt(y-1) for y in s.rowval]
    colptr::Vector{SuperLUInt} = [SuperLUInt(y-1) for y in s.colptr]
    Astore = Ref(NCformat(nnz, pointer(nzval), pointer(rowind), pointer(colptr)))
    A = Ref(SuperMatrix(SLU_NC, dtype, SLU_GE, m, n, Base.unsafe_convert(Ptr{Cvoid}, Astore)))

    etree = zeros(SuperLUInt, n)
    perm_r = collect(SuperLUInt, 0:n-1)
    perm_c = collect(SuperLUInt, 0:n-1)

    stat_arr = Vector{SuperLUStat_t}(undef, 1)
    L_arr = Vector{SuperMatrix}(undef, 1)
    U_arr = Vector{SuperMatrix}(undef, 1)
    Glu_arr = Vector{GlobalLU_t}(undef, 1)
    info_arr = Vector{SuperLUInt}(undef, 1)

    get_perm_c(options.ColPerm, A, pointer(perm_c))

    StatInit(stat_arr)
    GC.@preserve nzval rowind colptr A Astore begin
        Ac_arr = Vector{SuperMatrix}(undef, 1)
        sp_preorder(Ref(options), A, perm_c, etree, Ac_arr)
        gstrf(
            Tv,
            Ref(options), Ac_arr, relax, panel_size, etree,
            C_NULL, zero(SuperLUInt),
            perm_c, perm_r, L_arr, U_arr,
            Glu_arr, stat_arr, info_arr
        )
        Destroy_CompCol_Permuted(Ac_arr)
    end

    if info_arr[1] != 0
        if info_arr[1] < 0
            throw(ArgumentError("gstrf called with invalid argument at $(-info_arr[1])"))
        elseif info_arr[1] <= n
            throw(LinearAlgebra.SingularException(info_arr[1]))
        else
            throw(OutOfMemoryError())
        end
    end
    L = L_arr[1]
    U = U_arr[1]
    stat = stat_arr[1]
    lu = LUDecomposition{Tv, SuperLUInt}((m, n), perm_r, perm_c, L, U, stat) #, options, stat)
    finalizer(lu) do lu
        Destroy_SuperNode_Matrix(Ref(lu._L))
        Destroy_CompCol_Matrix(Ref(lu._U))
        StatFree(Ref(lu._stat))
    end
    return lu
end



function solve!(a::LUDecomposition{Tv, SuperLUInt}, b::StridedVecOrMat{Tv}, trans::trans_t=NOTRANS) where {Tv}
    dtype = _get_dtype(Tv)

    s_lda, s_ldb = _get_matrix_strides(b)
    mb, nb = _get_matrix_size(b)

    if !isone(s_lda)
        throw(ArgumentError("in and output vectors must have unit strides"))
    end

    ma, na = a.size
    if na != mb
        throw(ArgumentError("shapes do not match"))
    end
    Bstore = Ref(DNformat(s_ldb, pointer(b)))
    B = Ref(SuperMatrix(SLU_DN, dtype, SLU_GE, mb, nb, Base.unsafe_convert(Ptr{Cvoid}, Bstore)))

    GC.@preserve Bstore B begin
        info_arr = Vector{SuperLUInt}(undef, 1)
        gstrs(Tv, trans, Ref(a._L), Ref(a._U), a._perm_c, a._perm_r, B, Ref(a._stat), info_arr)
        if info_arr[1] != 0
            throw(ArgumentError("gstrs called with invalid argument at $(-info_arr[1])"))
        end
        return b
    end
end
