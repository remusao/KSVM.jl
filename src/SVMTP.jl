module SVMTP

using Vega
using Ipopt

include("quadprog.jl")
include("svm.jl")
include("hardMargin.jl")

export train, SVM, decision, process, print_2Ddecision

end # module
