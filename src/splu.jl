_get_dtype(::Type{Float32}) = SLU_S
_get_dtype(::Type{Float64}) = SLU_D
_get_dtype(::Type{ComplexF32}) = SLU_C
_get_dtype(::Type{ComplexF64}) = SLU_Z

_get_matrix_size(b::StridedVector) = (length(b), 1)
_get_matrix_size(b::StridedMatrix) = size(b)
_get_matrix_strides(b::StridedVector) = (stride(b, 1), length(b))
_get_matrix_strides(b::StridedMatrix) = strides(b)


"""
    splu(a::SparseMatrixCSC{Tv, Ti})

Compute the LU factorization using SuperLU.
"""
function splu(s::SparseMatrixCSC{Tv, Ti}) where {Tv<:SuperLUValueTypes, Ti}
    options = Ref{superlu_options_t}()
    set_default_options(options)
    lu = _splu(s, options[])
    return lu
end

function splu(s::Transpose{Tv, SparseMatrixCSC{Tv, Ti}}) where {Tv<:SuperLUValueTypes, Ti}
    options = Ref{superlu_options_t}()
    set_default_options(options)
    lu = _splu(s.parent, options[])
    return transpose(lu)
end

function splu(s::Adjoint{Tv, SparseMatrixCSC{Tv, Ti}}) where {Tv<:SuperLUValueTypes, Ti}
    options = Ref{superlu_options_t}()
    set_default_options(options)
    lu = _splu(s.parent, options[])
    return adjoint(lu)
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
    Astore = Ref(NCformat{Tv}(nnz, pointer(nzval), pointer(rowind), pointer(colptr)))
    A = Ref(SuperMatrix{Tv,NCformat{Tv}}(SLU_NC, dtype, SLU_GE, m, n, pointer_from_objref(Astore)))

    etree = zeros(SuperLUInt, n)
    perm_r = collect(SuperLUInt, 0:n-1)
    perm_c = collect(SuperLUInt, 0:n-1)

    stat = Ref{SuperLUStat_t}()
    L = Ref{SuperMatrix{Tv, SCformat{Tv}}}()
    U = Ref{SuperMatrix{Tv, NCformat{Tv}}}()
    Glu = Ref{GlobalLU_t}()
    info = Ref{SuperLUInt}()

    get_perm_c(options.ColPerm, A, pointer(perm_c))

    StatInit(stat)
    GC.@preserve nzval rowind colptr A Astore begin
        Ac = Ref{SuperMatrix{Tv, NCPformat{Tv}}}()
        sp_preorder(Ref(options), A, perm_c, etree, Ac)
        gstrf(
            Ref(options), Ac, relax, panel_size, etree,
            C_NULL, zero(SuperLUInt),
            perm_c, perm_r, L, U,
            Glu, stat, info
        )
        Destroy_CompCol_Permuted(Ac)
    end

    if info[] != 0
        if info[] < 0
            throw(ArgumentError("gstrf called with invalid argument at $(-info[])"))
        elseif info[] <= n
            throw(LinearAlgebra.SingularException(info[]))
        else
            throw(OutOfMemoryError())
        end
    end
    lu = LUDecomposition{Tv, SuperLUInt}(perm_r, perm_c, L[], U[], stat[])
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

    ma, na = size(a)
    if na != mb
        throw(ArgumentError("shapes do not match"))
    end
    Bstore = Ref(DNformat{Tv}(s_ldb, pointer(b)))
    B = Ref(SuperMatrix{Tv, DNformat{Tv}}(SLU_DN, dtype, SLU_GE, mb, nb, pointer_from_objref(Bstore)))

    GC.@preserve Bstore B begin
        info = Ref{SuperLUInt}()
        gstrs(trans, Ref(a._L), Ref(a._U), a._perm_c, a._perm_r, B, Ref(a._stat), info)
        if info[] != 0
            throw(ArgumentError("gstrs called with invalid argument at $(-info[])"))
        end
        return b
    end
end
