

# G(i, j) = <xi, xj>
computeG(x::Matrix) = x' * x

# H(i, j) = yi * yj * <xi, xj>
computeH(g::Matrix, label::Vector) = (label * label') .* g


# min 0.5 * x' * H * x + F' * x
# A * x <= b
# Aeq * x = beq
# LB <= x <= UB
# quadprog(H, F, A, b, Aeq, Beq, LB, UB)



function decision(alpha, dataTrain, data)
end


function process(alpha, dataTrain, data)
end


function print_2Ddecision(alpha, dataTrain)
end


function train(x, labels)

    n = size(labels, 1)

    alpha = quadprog(
        computeH(computeG(x), labels),  # H
        -ones(Float64, n),              # f
        labels,                         # Aeq
        zeros(Float64, n),              # Beq
        zeros(Float64, n),              # LowerBound x
        fill(Inf, n))                   # UpperBound x

    #
    # Find W (hyperplane)
    #

    w = Array(Float64, size(x, 1))
    for i = 1:n
        w = w + x[:, i] * alpha[i] * labels[i]
    end
    println("w is:\n$(w)")


    #
    # Find support vectors
    #
    indexsv = findn(alpha)
    println("Nsv: $(size(indexsv, 1))")


    #
    # Compute b
    #
    Nsv = size(indexsv, 2)
    b = 0

    for i = 1:Nsv
        b = b + (labels[indexsv[i]] - w' * x[:, indexsv[i]])
    end
    b /= float(Nsv)
    println("b: $(b)")


    #
    # Checking results
    #

    f(x) = (w' * x + b)[1]
    for i = 1:n
        println("$(i) => class $(labels[i]) => $(labels[i] == sign(f(x[:, i])))")
    end
end
