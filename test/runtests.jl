using AugmentorAddons
using Test
using ImageIO
using ImageFiltering
using Augmentor

@testset "AugmentorAddons.jl" begin
    ref = testpattern() |> size
    lo = (50, 50)
    hi = (10, 10)
    
    sz = augment(RCutOut(100, 100)) |> size
    @test (@. sz == ref) |> all

    sz = augment(PadBorders(RGB(0, 0, 0), lo)) |> size
    @test (@. sz == (ref + 2 * lo)) |> all

    sz = augment(PadBorders(:reflect, lo...)) |> size
    @test (@. sz == (ref + 2 * lo)) |> all

    sz = augment(PadBorders(RGB(0, 0, 0), lo, hi)) |> size
    @test (@. sz == (ref + lo + hi)) |> all

    x = rand(32, 32, 3, 4)
    ref = size(x)
    lo = (50, 50, 0, 0)
    hi = (10, 10, 0, 0)
    sz = augment(x, PadBorders(0, lo, hi)) |> size
    @test (@. sz == (ref + lo + hi)) |> all
end
