#augment(RCutOut(50, 50)) |> plot

struct RCutOut{N, I <: Tuple, R <: AbstractRNG} <: ImageOperation
    msze::I
    rng::R
end

RCutOut{N}(m::NTuple{N,<:Integer}, rng::R = GLOBAL_RNG) where {N,R} = 
RCutOut{N, typeof(m), R}(m, rng)

RCutOut(m::Integer...; rng = GLOBAL_RNG) = RCutOut{length(m)}(m, rng)

@inline supports_eager(::Type{<:RCutOut})      = false
@inline supports_affineview(::Type{<:RCutOut}) = false
@inline supports_view(::Type{<:RCutOut})       = false
@inline supports_stepview(::Type{<:RCutOut})   = true

applystepview(op::RCutOut, img::AbstractArray, pr) = applyeager(op, img, pr)

function applyeager(op::RCutOut{N}, img::AbstractArray, pr) where N
    st = rand.(Ref(op.rng), UnitRange.(1, size(img)[1:N] .- op.msze))
    sz = rand.(Ref(op.rng), UnitRange.(1, op.msze))
    ct = UnitRange.(st, st .+ sz .- 1)
    idx = repeat(Any[Colon()], ndims(img))
    for (i, c) in enumerate(ct)
        if !isempty(c)
            idx[i] = c
        end
    end
    nim = copy(img)
    z = img |> eltype |> zero
    nim[idx...] .= fill(z, sz)
    nim
end