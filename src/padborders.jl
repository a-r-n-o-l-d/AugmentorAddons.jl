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


struct PadBorders{N, I <: Tuple} <: ImageOperation
    pad
end

function PadBorders{N}(style::Symbol,
                       lo::T, up::T) where {N, T <: NTuple{N, <:Integer}}
    p = Pad(style, lo, up)
    PadBorders{N, typeof(lo)}(p)
end

function PadBorders{N}(value,
                       lo::T, up::T) where {N, T <: NTuple{N, <:Integer}}
    p = Fill(value, lo, up)
    PadBorders{N, typeof(lo)}(p)
end

function PadBorders(border, lo::T, up::T) where {N, T <: NTuple{N, <:Integer}}
    PadBorders{length(lo)}(border, lo, up)
end

function PadBorders(border, p::T) where {N, T <: NTuple{N, <:Integer}} 
    PadBorders{length(p)}(border, p, p)
end

@inline supports_eager(::Type{<:PadBorders})      = false
@inline supports_affineview(::Type{<:PadBorders}) = false
@inline supports_view(::Type{<:PadBorders})       = false
@inline supports_stepview(::Type{<:PadBorders})   = true

applystepview(op::PadBorders,
              img::AbstractArray, param) = applyeager(op, img, param)

applyeager(op::PadBorders{N},
           img::AbstractArray, param) where N = padarray(img, op.pad)
