module SuperLU

using SparseArrays
using LinearAlgebra
using CEnum

export splu

const SuperLUInt = Cint

include("superlu_common.jl")
include("superlu_api.jl")
include("superlu_util.jl")

SuperLUValueTypes = Union{Float32, Float64, ComplexF32, ComplexF64}

mutable struct LUDecomposition{Tv<:SuperLUValueTypes, Ti<:Union{SuperLUInt}}
    size::Tuple{Int, Int}
    _perm_r::Vector{Ti}
    _perm_c::Vector{Ti}
    _L::SuperMatrix
    _U::SuperMatrix
    # options::superlu_options_t
    # stat::SuperLUStat_t
end

mutable struct LUStatistics
    panel_histo::Vector{Int}
    utime::Vector{Float64}
    ops::Vector{Float64}
    TinyPivots::Int
    RefineSteps::Int
    expansions::Int
end

function extract_stat(stat::SuperLUStat_t)
    panel_size = sp_ienv(1)
    relax = sp_ienv(2)
    w = max(panel_size, relax)
    n_phases = Int(NPHASES)
    panel_histo = Vector{Int}(undef, w+1)
    utime = Vector{Float64}(undef, n_phases)
    ops = Vector{Float64}(undef, n_phases)

    panel_histo[:] .= unsafe_wrap(Array, stat.panel_histo, w+1)
    utime[:] .= unsafe_wrap(Array, stat.utime, n_phases)
    ops[:] .= unsafe_wrap(Array, stat.ops, n_phases)

    return LUStatistics(
        panel_histo,
        utime,
        ops,
        stat.TinyPivots,
        stat.RefineSteps,
        stat.expansions
    )
end



Base.size(x::LUDecomposition) = x.size
Base.size(x::LUDecomposition, i::Integer) = x.size[i]
Base.length(x::LUDecomposition) = x.size[1] * x.size[2]

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
    lu, stat = _splu(s, options)
    return lu, stat
end

# function splu(s::Transpose{Tv, SparseMatrixCSC{Tv, Ti}}) where {Tv<:SuperLUValueTypes, Ti<:Integer}
#     options_arr = Vector{superlu_options_t}(undef, 1)
#     set_default_options(options_arr)
#     options = options_arr[1]
#     return Transpose(_splu(s.parent, options))
# end

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
    stat_obj = extract_stat(stat_arr[1])
    StatFree(stat_arr)
    lu = LUDecomposition{Tv, SuperLUInt}((m, n), perm_r, perm_c, L, U) #, options, stat)
    finalizer(lu) do lu
        Destroy_SuperNode_Matrix(Ref(lu._L))
        Destroy_CompCol_Matrix(Ref(lu._U))
    end
    return (lu, stat_obj)
end




function LinearAlgebra.ldiv!(y::StridedVecOrMat{Tv}, a::LUDecomposition{Tv, SuperLUInt}, b::StridedVecOrMat{Tv}) where {Tv}
    copy!(y, b)
    ldiv!(a, y)
    return y
end

function LinearAlgebra.ldiv!(a::LUDecomposition{Tv, SuperLUInt}, b::StridedVecOrMat{Tv}) where {Tv}
    solve!(a, b)
    return b
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
        stat_arr = Vector{SuperLUStat_t}(undef, 1)
        StatInit(stat_arr)
        info_arr = Vector{SuperLUInt}(undef, 1)
        gstrs(Tv, trans, Ref(a._L), Ref(a._U), a._perm_c, a._perm_r, B, stat_arr, info_arr)

        StatFree(stat_arr)
        if info_arr[1] != 0
            throw(ArgumentError("gstrs called with invalid argument at $(-info_arr[1])"))
        end
    end
    return b
end



function extract_L(A::LUDecomposition{Tv, Ti}) where {Tv, Ti}
    BASE = 1
    dtype = _get_dtype(Tv)
    L = A._L
    @assert L.Stype == SLU_SC
    @assert L.Dtype == dtype
    @assert L.Mtype == SLU_TRLU

    m::Int, n::Int = L.nrow, L.ncol

    Lstore = unsafe_load(Ptr{SCformat}(L.Store))
    sup_to_col = unsafe_wrap(Array, Lstore.sup_to_col, Lstore.nsuper+1)
    nnzL = let lastl = 0
        for k in BASE:Lstore.nsuper+BASE
            fsupc = unsafe_load(Lstore.sup_to_col, k) + BASE
            istart = unsafe_load(Lstore.rowind_colptr, fsupc)
            nsupr = unsafe_load(Lstore.rowind_colptr, fsupc+1) - istart
            upper = 1
            for j in fsupc:unsafe_load(Lstore.sup_to_col, k+1)
                SNptr_offset = unsafe_load(Lstore.nzval_colptr, j)
                lastl += 1
                for i in upper+1:nsupr
                    v = unsafe_load(Ptr{Tv}(Lstore.nzval), SNptr_offset+i)
                    !iszero(v) && (lastl += 1)
                end
                upper += 1
            end
        end
        lastl
    end

    Lval = Vector{Tv}(undef, nnzL)
    Lrow = Vector{Int}(undef, nnzL)
    Lcol = Vector{Int}(undef, m+1)

    Lcol[1] = BASE

    # copy values
    lastl = 0
    for k in BASE:Lstore.nsuper+BASE
        fsupc = unsafe_load(Lstore.sup_to_col, k) + BASE
        istart = unsafe_load(Lstore.rowind_colptr, fsupc)
        nsupr = unsafe_load(Lstore.rowind_colptr, fsupc+1) - istart
        upper = 1
        for j in fsupc:unsafe_load(Lstore.sup_to_col, k+1)
            SNptr_offset = unsafe_load(Lstore.nzval_colptr, j)
            lastl += 1
            Lval[lastl] = one(Float64)
            Lrow[lastl] = unsafe_load(Lstore.rowind, istart + upper) + BASE
            for i in upper+1:nsupr
                v = unsafe_load(Ptr{Tv}(Lstore.nzval), SNptr_offset+i)
                if !iszero(v)
                    lastl += 1
                    Lval[lastl] = v
                    Lrow[lastl] = unsafe_load(Lstore.rowind, istart + i) + BASE
                end
            end
            Lcol[j+1] = lastl + 1
            upper += 1
        end
    end

    return SparseMatrixCSC{Tv, Int}(m, n, Lcol, Lrow, Lval)
end


function extract_U(A::LUDecomposition{Tv, Ti}) where {Tv, Ti}
    dtype = _get_dtype(Tv)
    BASE = 1
    L, U = A._L, A._U

    @assert U.Stype == SLU_NC
    @assert U.Dtype == dtype
    @assert U.Mtype == SLU_TRU

    m::Int, n::Int = L.nrow, L.ncol

    Lstore = unsafe_load(Ptr{SCformat}(L.Store))
    Ustore = unsafe_load(Ptr{NCformat}(U.Store))

    sup_to_col = unsafe_wrap(Array, Lstore.sup_to_col, Lstore.nsuper+1)

    nnzU = let lastu = 0
        for k in BASE:Lstore.nsuper+BASE
            fsupc = unsafe_load(Lstore.sup_to_col, k) + BASE
            istart = unsafe_load(Lstore.rowind_colptr, fsupc)
            nsupr = unsafe_load(Lstore.rowind_colptr, fsupc+1) - istart
            upper = 1
            for j in fsupc:unsafe_load(Lstore.sup_to_col, k+1)
                SNptr_offset = unsafe_load(Lstore.nzval_colptr, j)
                for i in unsafe_load(Ustore.colptr, j)+1:unsafe_load(Ustore.colptr, j+1)
                    v = unsafe_load(Ptr{Tv}(Ustore.nzval), i)
                    !iszero(v) && (lastu += 1)
                end
                for i in 1:upper
                    v = unsafe_load(Ptr{Tv}(Lstore.nzval), SNptr_offset + i)
                    !iszero(v) && (lastu += 1)
                end
                upper += 1
            end
        end
        lastu
    end

    Uval = Vector{Tv}(undef, nnzU)
    Urow = Vector{Int}(undef, nnzU)
    Ucol = Vector{Int}(undef, m+1)

    # copy values
    let lastu = 0
        Ucol[1] = BASE
        for k in BASE:Lstore.nsuper+BASE
            fsupc = unsafe_load(Lstore.sup_to_col, k) + BASE
            istart = unsafe_load(Lstore.rowind_colptr, fsupc)
            nsupr = unsafe_load(Lstore.rowind_colptr, fsupc+1) - istart
            upper = 1
            for j in fsupc:unsafe_load(Lstore.sup_to_col, k+1)
                SNptr_offset = unsafe_load(Lstore.nzval_colptr, j)
                for i in unsafe_load(Ustore.colptr, j)+1:unsafe_load(Ustore.colptr, j+1)
                    v = unsafe_load(Ptr{Tv}(Ustore.nzval), i)
                    if !iszero(v)
                        lastu += 1
                        Uval[lastu] = v
                        Urow[lastu] = unsafe_load(Ustore.rowind, i)
                    end
                end
                for i in 1:upper
                    v = unsafe_load(Ptr{Tv}(Lstore.nzval), SNptr_offset + i)
                    if !iszero(v)
                        lastu += 1
                        Uval[lastu] = v
                        Urow[lastu] = unsafe_load(Lstore.rowind, istart + i) + BASE
                    end
                end
                Ucol[j+1] = lastu + 1
                upper += 1
            end
        end
    end
    return SparseMatrixCSC{Tv, Int}(m, n, Ucol, Urow, Uval)
end

@inline function Base.getproperty(lu::LUDecomposition, d::Symbol)
    if d == :L
        return extract_L(lu)
    elseif d == :U
        return extract_U(lu)
    elseif d == :perm_r
        return map((x::SuperLUInt) -> Int(x) + 1, lu._perm_r)
    elseif d == :perm_c
        return map((x::SuperLUInt) -> Int(x) + 1, lu._perm_c)
    else
        getfield(lu, d)
    end
end

end
