
function decision(alpha, dataTrain, data)
end


function process(alpha, dataTrain, data)
end

function hyperplan(alpha, data, labels)

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
        b = b + (labels[indexsv[i]] - w' * data[:, indexsv[i]])
    end
    b /= float(Nsv)

    w, b
end


function print_2Ddecision(data, w, b)

    # Decision function
    f(x) = (w' * x + b)[1]

    #
    # Generate data set
    #
    n = size(data, 2)
    color = Array(Int, n)

    for i = 1:n
        color[i] = sign(f(data[:, i]))
    end

    color[color .== -1] = 2

    y = reshape(data[1, :], n)
    x = reshape(data[2, :], n)

    p = plot(x = x, y = y, color = color, Geom.point)
    draw(PNG("myplot.png", 6inch, 3inch), p)
end


function train(data, labels)

    n = size(labels, 1)

    # G(i, j) = <xi, xj>
    computeG(x::Matrix) = x' * x

    # H(i, j) = yi * yj * <xi, xj>
    computeH(g::Matrix, label::Vector) = (label * label') .* g

    alpha = quadprog(
        computeH(computeG(data), labels),  # H
        -ones(Float64, n),              # f
        labels,                         # Aeq
        zeros(Float64, n),              # Beq
        zeros(Float64, n),              # LowerBound x
        fill(Inf, n))                   # UpperBound x

    # Get hyperplan parameters
    w, b = hyperplan(alpha, data, labels)

    # Print result on a random sample
    print_2Ddecision(rand(2, 1000) * 4 - 2, w, b)
end
