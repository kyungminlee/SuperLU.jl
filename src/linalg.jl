
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
