
SuperLUValueTypes = Union{Float32, Float64, ComplexF32, ComplexF64}

mutable struct LUDecomposition{Tv<:SuperLUValueTypes, Ti<:Union{SuperLUInt}} <: LinearAlgebra.Factorization{Tv}
    size::Tuple{Int, Int}
    _perm_r::Vector{Ti}
    _perm_c::Vector{Ti}
    _L::SuperMatrix
    _U::SuperMatrix
    _stat::SuperLUStat_t
end

struct LUStatistics
    panel_histo::Vector{Int}
    utime::Vector{Float64}
    ops::Vector{Float64}
    TinyPivots::Int
    RefineSteps::Int
    expansions::Int
end

Base.size(x::LUDecomposition) = x.size
Base.size(x::LUDecomposition, i::Integer) = x.size[i]
Base.length(x::LUDecomposition) = x.size[1] * x.size[2]


Base.transpose(f::LUDecomposition) = Transpose(f)
Base.adjoint(f::LUDecomposition) = Adjoint(f)

# Base.eltype(::Type{LUDecomposition{Tv, Ti}}) where {Tv, Ti} = Tv
# Base.size(s::Transpose{Tv, LUDecomposition{Tv, Ti}}) where {Tv, Ti} = reverse(size(s.parent))
# Base.size(s::Transpose{Tv, LUDecomposition{Tv, Ti}}) where {Tv, Ti} = reverse(size(s.parent))



@inline function Base.getproperty(lu::LUDecomposition, d::Symbol)
    if d == :L
        return extract_L(lu)
    elseif d == :U
        return extract_U(lu)
    elseif d == :perm_r
        return map((x::SuperLUInt) -> Int(x) + 1, lu._perm_r)
    elseif d == :perm_c
        return map((x::SuperLUInt) -> Int(x) + 1, lu._perm_c)
    elseif d == :stat
        return extract_stat(lu._stat)
    else
        getfield(lu, d)
    end
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

    # Lval = Tv[]
    # Lrow = Int[]
    # Lcol = Int[]

    # copy values
    let lastl = 0
        Lcol[1] = BASE
        # push!(Lcol, BASE)
        for k in BASE:Lstore.nsuper+BASE
            fsupc = unsafe_load(Lstore.sup_to_col, k) + BASE
            istart = unsafe_load(Lstore.rowind_colptr, fsupc)
            nsupr = unsafe_load(Lstore.rowind_colptr, fsupc+1) - istart
            upper = 1
            for j in fsupc:unsafe_load(Lstore.sup_to_col, k+1)
                SNptr_offset = unsafe_load(Lstore.nzval_colptr, j)
                lastl += 1
                Lval[lastl] = one(Tv)
                Lrow[lastl] = unsafe_load(Lstore.rowind, istart + upper) + BASE
                # push!(Lval, one(Float64))
                # push!(Lrow, unsafe_load(Lstore.rowind, istart + upper) + BASE)
                for i in upper+1:nsupr
                    v = unsafe_load(Ptr{Tv}(Lstore.nzval), SNptr_offset+i)
                    if !iszero(v)
                        lastl += 1
                        Lval[lastl] = v
                        Lrow[lastl] = unsafe_load(Lstore.rowind, istart + i) + BASE
                        # push!(Lval, v)
                        # push!(Lrow, unsafe_load(Lstore.rowind, istart + i) + BASE)
                    end
                end
                Lcol[j+1] = lastl + 1
                # push!(Lcol, lastl + 1)
                upper += 1
            end
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
    # Uval = Tv[]
    # Urow = Int[]
    # Ucol = Int[]

    # copy values
    let lastu = 0
        Ucol[1] = BASE
        # push!(Ucol, BASE)
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
                        # push!(Uval, v)
                        # push!(Urow, unsafe_load(Ustore.rowind, i))
                    end
                end
                for i in 1:upper
                    v = unsafe_load(Ptr{Tv}(Lstore.nzval), SNptr_offset + i)
                    if !iszero(v)
                        lastu += 1
                        Uval[lastu] = v
                        Urow[lastu] = unsafe_load(Lstore.rowind, istart + i) + BASE
                        # push!(Uval, v)
                        # push!(Urow, unsafe_load(Lstore.rowind, istart + i) + BASE)
                    end
                end
                Ucol[j+1] = lastu + 1
                # push!(Ucol, lastu + 1)
                upper += 1
            end
        end
    end
    return SparseMatrixCSC{Tv, Int}(m, n, Ucol, Urow, Uval)
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

    # ops_tuple = eval(
    #     Expr(
    #         :tuple,
    #         [
    #             :($x=($ops)[Int($x)+1])
    #             for x in [
    #                 :COLPERM, :ROWPERM, :RELAX,
    #                 :ETREE, :EQUIL, :SYMBFAC,
    #                 :DIST, :FACT,
    #                 :COMM, :COMM_DIAG, :COMM_RIGHT, :COMM_DOWN,
    #                 :SOL_COMM, :SOL_GEMM, :SOL_TRSM, :SOL_TOT,
    #                 :RCOND, :SOLVE, :REFINE, :TRSV, :GEMV, :FERR,
    #             ]
    #         ]...
    #     )
    # )

    # utime_tuple = eval(
    #     Expr(
    #         :tuple,
    #         [
    #             :($x=($utime)[Int($x)+1])
    #             for x in [
    #                 :COLPERM, :ROWPERM, :RELAX,
    #                 :ETREE, :EQUIL, :SYMBFAC,
    #                 :DIST, :FACT,
    #                 :COMM, :COMM_DIAG, :COMM_RIGHT, :COMM_DOWN,
    #                 :SOL_COMM, :SOL_GEMM, :SOL_TRSM, :SOL_TOT,
    #                 :RCOND, :SOLVE, :REFINE, :TRSV, :GEMV, :FERR,
    #             ]
    #         ]...
    #     )
    # )

    # @show ops_tuple
    # @show utime_tuple
    return LUStatistics(
        panel_histo,
        utime,
        ops,
        stat.TinyPivots,
        stat.RefineSteps,
        stat.expansions
    )
end
