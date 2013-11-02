module SVMTP

using Gadfly
using Ipopt

include("quadprog.jl")
include("svm.jl")
include("visualization.jl")
include("hardMargin.jl")

export train, SVM, decision, process, print_2Ddecision

end # module
