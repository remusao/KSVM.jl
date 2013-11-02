module SVMTP

using Vega
using Ipopt

include("quadprog.jl")
include("hardMargin.jl")

export train

end # module
