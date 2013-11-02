module SVMTP

using Ipopt

include("quadprog.jl")
include("hardMargin.jl")

export train

end # module
