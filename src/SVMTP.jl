module SVMTP

using Gadfly
using Ipopt

include("quadprog.jl")
include("hardMargin.jl")

export train

end # module
