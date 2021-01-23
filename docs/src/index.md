```@meta
Author = "Kyungmin Lee"
```

# SuperLU.jl

SuperLU.jl is Julia interface to [SuperLU](https://portal.nersc.gov/project/sparse/superlu/)

## Installation

```julia
julia> ]add SuperLU
```

## Usage

```julia
julia> using SuperLU, SparseArrays
julia> A = sparse([1.0 2.0; 3.0 4.0])
julia> lu = splu(A)
```