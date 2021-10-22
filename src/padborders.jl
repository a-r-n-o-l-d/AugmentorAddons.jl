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

See also [`Pad`](https://juliaimages.org/ImageFiltering.jl/stable/function_reference/#ImageFiltering.Pad).
See also [`Fill`](https://juliaimages.org/ImageFiltering.jl/stable/function_reference/#ImageFiltering.Fill).
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
