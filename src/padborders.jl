#=
struct PadImg{N, I<:Tuple} <: Augmentor.ImageOperation
    borders::I
    function PadImg{N}(borders::NTuple{N,<:Integer}) where N
        new{N,typeof(borders)}(borders)
    end
end
PadImg(borders::Integer...) = PadImg{length(borders)}(borders)

@inline Augmentor.supports_eager(::Type{<:PadImg})      = false
@inline Augmentor.supports_affineview(::Type{<:PadImg}) = false
@inline Augmentor.supports_view(::Type{<:PadImg})       = false
@inline Augmentor.supports_stepview(::Type{<:PadImg})   = true

Augmentor.applystepview(op::PadImg, img::AbstractArray, param) = Augmentor.applyeager(op, img, param)
function Augmentor.applyeager(op::PadImg{N}, img::AbstractArray, param) where N
    PaddedView(Gray(0.0), img, size(img) .+ 2 .* op.borders, op.borders .+ 1)
end

let o = augment(CIFAR10.convert2image(CIFAR10.traintensor(2)), PadImg(4, 4) |> RCropSize(32))
    Base.display(o)
end
=#

"""
    PadBorders(border, lo, up)
    PadBorders(border, bo)
    PadBorders(border, bo...)

The argument `border` is a symbol or value:
* `:replicate` repeat edge values to infinity
* `:circular` image edges "wrap around"
* `:symmetric` the image reflects relative to a position between pixels
* `:reflect` the image reflects relative to the edge itself
* a numeric or color type value: for example RGB(0, 0, 0) will pad a RGB image
  with black

`lo` and `up` are tuples:
* `lo` number to extend by on the lower edge for each dimension
* `up` number to extend by on the upper edge for each dimension

If a single tuple (or an integer serie) is supplied, the padding is symmetric.

If `PadBorders` is used to process an image batch, you must define `lo` and `hi`
as tuples with the batch dimension set to 0.

# Example
```julia
# Pad the testpattern from Augmentor with black
julia> augment(PadBorders(RGB(0, 0, 0), (50, 100))) |> plot

# Pad the testpattern from Augmentor with circular borders
julia> augment(PadBorders(:circular, 50, 50)) |> plot

# Pad a fake image batch with 0
julia> augment(rand(32, 32, 3, 16), PadBorders(0, 8, 8, 0, 0))[:,:,1,1] |> heatmap
```
See also [`Pad`](https://juliaimages.org/ImageFiltering.jl/stable/function_reference/#ImageFiltering.Pad),
and [`Fill`](https://juliaimages.org/ImageFiltering.jl/stable/function_reference/#ImageFiltering.Fill).
"""
struct PadBorders{N, I <: Tuple} <: ImageOperation
    pad
end

PadBorders{N}(border::Symbol, lo::T, up::T) where {N, T <: NTuple{N, <:Integer}} =
    PadBorders{N, typeof(lo)}(Pad(border, lo, up))

PadBorders{N}(border, lo::T, up::T) where {N, T <: NTuple{N, <:Integer}} =
    PadBorders{N, typeof(lo)}(Fill(border, lo, up))

PadBorders(border, lo::T, up::T) where {N, T <: NTuple{N, <:Integer}} =
    PadBorders{length(lo)}(border, lo, up)

PadBorders(border, bo::T) where {N, T <: NTuple{N, <:Integer}} =
    PadBorders{length(bo)}(border, bo, bo)

PadBorders(border, bo::Integer...) = PadBorders(border, bo)

@inline supports_eager(::Type{<:PadBorders}) = false

@inline supports_affineview(::Type{<:PadBorders}) = false

@inline supports_view(::Type{<:PadBorders}) = false

@inline supports_stepview(::Type{<:PadBorders}) = true

applystepview(op::PadBorders,
              img::AbstractArray, param) = applyeager(op, img, param)

applyeager(op::PadBorders{N},
           img::AbstractArray, param) where N = padarray(img, op.pad)
