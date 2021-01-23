module SuperLU

using SparseArrays
using LinearAlgebra

export splu

include("libsuperlu_api.jl")
include("types.jl")
include("splu.jl")
include("linalg.jl")

end
