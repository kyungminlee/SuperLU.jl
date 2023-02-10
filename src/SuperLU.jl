module SuperLU

using SparseArrays
using LinearAlgebra

const AdjointFact = isdefined(LinearAlgebra, :AdjointFactorization) ?
    LinearAlgebra.AdjointFactorization :
    Adjoint
const TransposeFact = isdefined(LinearAlgebra, :TransposeFactorization) ?
    LinearAlgebra.TransposeFactorization :
    Transpose

export splu

include("libsuperlu_api.jl")
include("types.jl")
include("splu.jl")
include("linalg.jl")

end
