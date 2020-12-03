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

        b1() = DTYPE[
            1 0 0;
            0 1 0;
            0 0 0;
            0 0 1;
            0 0 0
        ]
        b2() = DTYPE[0, 0, 1, 0, 0]

        b3() = let bx = DTYPE[
                1 0 0 1;
                0 1 0 1;
                0 0 0 1;
                0 0 1 1;
                0 0 0 1
                1 1 1 1
            ]
            view(bx, 1:5, 1:3)
        end

        for trans in [identity, transpose, adjoint], b in [b1, b2, b3]
            b0 = b()

            s0 = trans(lu(A))
            y0 = s0 \ b()
            @test !iszero(y0)

            s1 = splu(trans(A))
            s2 = trans(splu(A))

            y1 = s1 \ b()
            y2 = s2 \ b()
            @test isapprox(y1, y0)
            @test isapprox(y2, y0)

            w1 = zero(b())
            w2 = zero(b())
            ldiv!(w1, s1, b())
            ldiv!(w2, s2, b())
            @test isapprox(w1, y0)
            @test isapprox(w2, y0)

            z1 = b()
            z2 = b()
            ldiv!(s1, z1)
            ldiv!(s2, z2)
            @test isapprox(z1, y0)
            @test isapprox(z2, y0)

            bp0 = trans(A) * y0
            bp1 = trans(A) * y1
            bp2 = trans(A) * y2
            @test isapprox(bp0, b0)
            @test isapprox(bp1, b0)
            @test isapprox(bp2, b0)
        end
    end

end
