using Test
using SuperLU

using LinearAlgebra
using SparseArrays
using SuiteSparse

@testset "SuperLU" begin
    for DTYPE in [Float32, Float64, ComplexF32, ComplexF64]
        A = SparseMatrixCSC(
            5, 5,
            [1, 4, 7, 9, 11, 13],
            [1, 2, 5, 2, 3, 5, 1, 3, 1, 4, 4, 5],
            DTYPE[19.00, 12.00, 12.00, 21.00, 12.00, 12.00, 21.00, 16.00, 21.00, 5.00, 21.00, 18.00],
        )
        Adense = Matrix(A)
        b1 = DTYPE[
            1 0 0;
            0 1 0;
            0 0 0;
            0 0 1;
            0 0 0
        ]
        b2 = DTYPE[0, 0, 1, 0, 0]
        for trans in [identity, transpose, adjoint], b in [b1, b2]
            s0 = trans(lu(A))
            s1 = splu(trans(A))
            s2 = trans(splu(A))

            y0 = s0 \ b
            y1 = s1 \ b
            y2 = s2 \ b
            @test !iszero(y0)
            @test isapprox(y1, y0)
            @test isapprox(y2, y0)

            bp0 = trans(A) * y0
            bp1 = trans(A) * y1
            bp2 = trans(A) * y2
            @test isapprox(bp0, b)
            @test isapprox(bp1, b)
            @test isapprox(bp2, b)
        end
    end

end