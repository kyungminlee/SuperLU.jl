# SuperLU

| **Documentation** | **Build Status** | **Code Coverage** |
|:-----------------:|:----------------:|:-----------------:|
| [![**STABLE**][docs-stable-img]][docs-stable-url] [![**DEV**][docs-dev-img]][docs-dev-url] | [![Build Status][githubaction-img]][githubaction-url] [![Build Status dev][githubaction-img-dev]][githubaction-url] | [![Code Coverage][codecov-img]][codecov-url] [![Code Coverage dev][codecov-img-dev]][codecov-url] |

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

## License

SuperLU.jl is released under [MIT License](https://github.com/kyungminlee/SuperLU.jl/LICENSE).

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: http://kyungminlee.org/SuperLU.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: http://kyungminlee.org/SuperLU.jl/dev

[codecov-img]: https://codecov.io/gh/kyungminlee/SuperLU.jl/branch/main/graph/badge.svg
[codecov-img-dev]: https://codecov.io/gh/kyungminlee/SuperLU.jl/branch/dev/graph/badge.svg
[codecov-url]: https://codecov.io/gh/kyungminlee/SuperLU.jl

[githubaction-img]: https://github.com/kyungminlee/SuperLU.jl/workflows/Build/badge.svg
[githubaction-img-dev]: https://github.com/kyungminlee/SuperLU.jl/workflows/Build/badge.svg?branch=dev
[githubaction-url]: https://github.com/kyungminlee/SuperLU.jl/actions
