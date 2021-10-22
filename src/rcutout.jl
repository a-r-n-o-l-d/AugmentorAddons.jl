"""
    RCutOut(m; rng = GLOBAL_RNG)
    RCutOut(m...; rng = GLOBAL_RNG)

This operation applies a mask of zeros to a random location within images. `m` 
is a tuple or integers defining the mask size.

# Example
```julia
julia> augment(RCutOut((100, 100))) |> plot

julia> augment(RCutOut(100, 100)) |> plot
```
"""-
struct RCutOut{N, I <: Tuple, R <: AbstractRNG} <: ImageOperation
    msze::I
    rng::R
end

RCutOut{N}(m::T, rng::R = GLOBAL_RNG) where {N, T <: NTuple{N, <:Integer}, R} =
    RCutOut{N, typeof(m), R}(m, rng)

RCutOut(m; rng = GLOBAL_RNG) = RCutOut{length(m)}(m, rng)

RCutOut(m::Integer...; rng = GLOBAL_RNG) = RCutOut{length(m)}(m, rng)

@inline supports_eager(::Type{<:RCutOut}) = false

@inline supports_affineview(::Type{<:RCutOut}) = false

@inline supports_view(::Type{<:RCutOut}) = false

@inline supports_stepview(::Type{<:RCutOut}) = true

applystepview(op::RCutOut, img::AbstractArray, pr) = applyeager(op, img, pr)

function applyeager(op::RCutOut{N}, img::AbstractArray, pr) where N
    st = rand.(Ref(op.rng), UnitRange.(1, size(img)[1:N] .- op.msze))
    ct = UnitRange.(st, st .+ op.msze .- 1)
    idx = repeat(Any[Colon()], ndims(img))
    for (i, c) in enumerate(ct)
        if !isempty(c)
            idx[i] = c
        end
    end
    nim = copy(img)
    z = img |> eltype |> zero
    nim[idx...] .= fill(z, op.msze)
    nim
end