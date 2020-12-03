module SuperLU

using SparseArrays
using LinearAlgebra

export splu

include("cSuperLU.jl")
include("types.jl")
include("splu.jl")
include("linalg.jl")

end
