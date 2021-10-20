using AugmentorAddons
using Documenter

DocMeta.setdocmeta!(AugmentorAddons, :DocTestSetup, :(using AugmentorAddons); recursive=true)

makedocs(;
    modules=[AugmentorAddons],
    authors="Arnold",
    repo="https://github.com/a-r-n-o-l-d/AugmentorAddons.jl/blob/{commit}{path}#{line}",
    sitename="AugmentorAddons.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://a-r-n-o-l-d.github.io/AugmentorAddons.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/a-r-n-o-l-d/AugmentorAddons.jl",
    devbranch="main",
)
