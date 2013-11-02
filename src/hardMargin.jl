
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


function train(data, labels)

    n = size(labels, 1)

    # G(i, j) = <xi, xj>
    computeG(x::Matrix) = x' * x

    # H(i, j) = yi * yj * <xi, xj>
    computeH(g::Matrix, label::Vector) = (label * label') .* g

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
    svm = SVM(size(data, 1), alpha, w, b)

    # Print result on a random sample
    print_2Ddecision(svm, data)
    print_2Ddecision(svm, rand(2, 1000) * 4 - 2)
    print_supportVectors(svm, data)

    # Return trained svm
    svm
end
