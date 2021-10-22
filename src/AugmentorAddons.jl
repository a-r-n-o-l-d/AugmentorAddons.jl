module AugmentorAddons

using Augmentor
using Augmentor: ImageOperation
using ImageFiltering
using Random: AbstractRNG, GLOBAL_RNG

import Augmentor.supports_eager
import Augmentor.supports_affineview
import Augmentor.supports_view
import Augmentor.supports_stepview
import Augmentor.applystepview
import Augmentor.applyeager

export PadBorders, RCutOut

include("padborders.jl")
include("rcutout.jl")

end
