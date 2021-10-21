module AugmentorAddons

using ImageFiltering
using Augmentor
using Augmentor: ImageOperation

import Augmentor.supports_eager
import Augmentor.supports_affineview
import Augmentor.supports_view
import Augmentor.supports_stepview
import Augmentor.applystepview
import Augmentor.applyeager

export PadDims

include("paddims.jl")

end
