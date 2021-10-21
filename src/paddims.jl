struct PadDims{N, I <: Tuple} <: ImageOperation
    padder
end

function PadDims{N}(border::Symbol, lower::T, upper::T) where {N, T <: NTuple{N, <:Integer}}
    p = Pad(border, lower, upper)
    PadDims{N, typeof(lower)}(p)
end

function PadDims{N}(value, lower::T, upper::T) where {N, T <: NTuple{N, <:Integer}}
    p = Fill(value, lower, upper)
    PadDims{N, typeof(lower)}(p)
end

PadDims(b, l, u) = PadDims{length(l)}(b, l, u)
PadDims(b, p) = PadDims{length(p)}(b, p, p)

@inline supports_eager(::Type{<:PadDims})      = false
@inline supports_affineview(::Type{<:PadDims}) = false
@inline supports_view(::Type{<:PadDims})       = false
@inline supports_stepview(::Type{<:PadDims})   = true

applystepview(op::PadDims, img::AbstractArray, param) = applyeager(op, img, param)

function applyeager(op::PadDims{N}, img::AbstractArray, param) where N
    padarray(img, op.padder)s
end