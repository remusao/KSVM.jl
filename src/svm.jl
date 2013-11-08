
immutable SVM
    dim::Int
    alpha::Vector{Float64}
    w::Vector{Float64}
    b::Float64
    kernel::Function
end


# Take a decision
function decision(svm::SVM, x::Vector)
    sign((svm.w' * x + svm.b)[1])
end


# Take a decision on each vector in data
function process(svm::SVM, data::Matrix)
    dim, n = size(data)

    # Check dimension
    @assert (dim == svm.dim) "Data dimension must match"

    res = Array(Int, size(data, 2))
    for i = 1:n
        res[i] = decision(svm, data[:, i])
    end

    res
end


function hyperplan(alpha::Vector, data::Matrix, labels::Vector)

    #
    # Compute W
    #
    n = size(data, 2)
    w = Array(Float64, size(data, 1))
    for i = 1:n
        w = w + data[:, i] * alpha[i] * labels[i]
    end

    #
    # Compute b
    #

    # Find support vectors
    indexsv = findn(alpha)
    Nsv = size(indexsv, 2)
    b = 0

    for i = 1:Nsv
        b = b + (labels[indexsv[i]] - w' * data[:, indexsv[i]])[1]
    end
    b /= float(Nsv)


    # Return hyperplan parameters
    w, b
end


#
# Train a hardmargin SVM. Possibility to use a user defined kernel function
#
function train(data::Matrix, labels::Vector, kernel = linear, karg = nothing)

    # Number of examples
    n = size(labels, 1)

    # Defines kernel function
    K(x, y) = kernel(x, y)
    if karg != nothing
        K(x, y) = kernel(x, y, karg...)
    end

    # G(i, j) = <xi, xj>
    computeG(x::Matrix) = K(x, x)

    # H(i, j) = yi * yj * <xi, xj>
    computeH(g::Matrix, label::Vector) = (label * label') .* g

    # Find optimal solution
    alpha = quadprog(
        computeH(computeG(data), labels),   # H
        -ones(Float64, n),                  # f
        labels,                             # Aeq
        zeros(Float64, n),                  # Beq
        zeros(Float64, n),                  # LowerBound x
        fill(Inf, n))                       # UpperBound x

    # Get hyperplan parameters
    w, b = hyperplan(alpha, data, labels)

    # Return trained SVM
    svm = SVM(size(data, 1), alpha, w, b, K)

    # Print result on a random sample
    print_2Ddecision(svm, data)
    print_2Ddecision(svm, rand(2, 1000) * 4 - 2)
    print_supportVectors(svm, data)

    # Return trained svm
    svm
end
