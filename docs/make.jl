using Documenter, SuperLU

makedocs(
    modules=[SuperLU],
    format=Documenter.HTML(),
    clean=false,
    sitename="SuperLU.jl",
    pages=Any[
        "Home" => "index.md",
    ],
)

deploydocs(
    repo="github.com/kyungminlee/SuperLU.jl.git",
    devbranch="dev"
)