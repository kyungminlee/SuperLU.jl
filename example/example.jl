using Test
using SuperLU

using LinearAlgebra
using SparseArrays
using SuiteSparse

DTYPE = Float64

A = SparseMatrixCSC(
    5, 5,
    [1, 4, 7, 9, 11, 13],
    [1, 2, 5, 2, 3, 5, 1, 3, 1, 4, 4, 5],
    DTYPE[19.00, 12.00, 12.00, 21.00, 12.00, 12.00, 21.00, 16.00, 21.00, 5.00, 21.00, 18.00],
)

bx = DTYPE[
    1 0 0 1;
    0 1 0 1;
    0 0 0 1;
    0 0 1 1;
    0 0 0 1
    1 1 1 1
]

b3 = view(bx, 1:5, 1:3)

@show typeof(b3)
@show strides(b3)
