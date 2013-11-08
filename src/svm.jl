
immutable SVM
    n::Integer
    dim::Integer
    data::Matrix
    labels::Vector
    alpha::Vector
    b::Float64
    kernel::Function
end


# Take a decision
function decision(svm::SVM, x::Vector)
    res = 0
    for i = 1:svm.n
        res += svm.alpha[i] * svm.labels[i] * svm.kernel(svm.data[:, i], x)
    end
    sign(res + svm.b)
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


function getb(alpha::Vector, data::Matrix, labels::Vector, kernel::Function)
    # Number of support vectors
    nsv = size(labels, 1)
    b = 0

    for j = 1:nsv
        tmp = labels[j]
        for i = 1:nsv
            tmp = tmp - alpha[i] * labels[i] * kernel(data[:, i], data[:, j])
        end
        b += tmp
    end
    b /= nsv

    return b
end


#
# Train a hardmargin SVM. Possibility to use a user defined kernel function
#
function train(data::Matrix, labels::Vector, kfun = linear, karg = nothing)

    # Number of examples
    n = size(labels, 1)

    # Defines kernel function
    if karg == nothing
        kernel(x, y) = kfun(x, y)
    else
        kernel(x, y) = kfun(x, y, karg...)
    end

    # G(i, j) = <xi, xj>
    function computeG(x::Matrix)
        g = Array(Float64, n, n)

        for i = 1:n
            for j = 1:n
                g[i, j] = kernel(x[:, i], x[:, j])
            end
        end

        return g
    end

    # H(i, j) = yi * yj * <xi, xj>
    function computeH(g::Matrix, label::Vector)
        return (label * label') .* g
    end

    # Find optimal solution
    alpha = quadprog(
        computeH(computeG(data), labels),   # H
        -ones(Float64, n),                  # f
        labels,                             # Aeq
        zeros(Float64, n),                  # Beq
        zeros(Float64, n),                  # LowerBound x
        fill(Inf, n))                       # UpperBound x

    # Only keep support vectors and their associated labels
    indexsv = findn(alpha)
    data = data[:, indexsv]
    labels = labels[indexsv]
    alpha = alpha[indexsv]

    # Get b parameter
    b = getb(alpha, data, labels, kernel)

    # Return trained SVM
    return SVM(size(data, 2), size(data, 1), data, labels, alpha, b, kernel)
end
