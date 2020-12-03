module SuperLU

using SparseArrays
using LinearAlgebra


include("cSuperLU.jl")
# using .cSuperLU

include("types.jl")

export splu
include("splu.jl")

include("linalg.jl")

end
