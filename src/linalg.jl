
function LinearAlgebra.ldiv!(a::LUDecomposition{Tv, SuperLUInt}, b::StridedVecOrMat{Tv}) where {Tv}
    solve!(a, b)
    return b
end

function LinearAlgebra.ldiv!(a::Transpose{Tv, LUDecomposition{Tv, SuperLUInt}}, b::StridedVecOrMat{Tv}) where {Tv}
    solve!(a.parent, b, TRANS)
    return b
end

function LinearAlgebra.ldiv!(a::Adjoint{Tv, LUDecomposition{Tv, SuperLUInt}}, b::StridedVecOrMat{Tv}) where {Tv}
    solve!(a.parent, b, CONJ)
    return b
end

# not sure why Julia only implements \ for NoTrans and Adjoint.
function \(tF::Transpose{Tv,LUDecomposition{Tv, Ti}}, B::AbstractVecOrMat) where {Tv, Ti}
    require_one_based_indexing(B)
    F = tF.parent
    TFB = typeof(oneunit(eltype(B)) / oneunit(eltype(F)))
    BB = similar(B, TFB, size(B))
    copyto!(BB, B)
    ldiv!(tF, BB)
end
