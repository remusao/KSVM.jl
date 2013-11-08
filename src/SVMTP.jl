module SVMTP

using Vega
using Ipopt

include("quadprog.jl")
include("kernel.jl")
include("svm.jl")
include("visualization.jl")

# SVM functions
export train, SVM, decision, process, print_2Ddecision

# Kernels
export linear, polynomial, laplacian, rbf

end # module
