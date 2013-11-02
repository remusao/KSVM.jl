
function print_2Ddecision(svm::SVM, data)

    # Check that we work in 2 dimensions
    @assert (svm.dim == 2) "data must be 2D"

    #
    # Get class of each data point
    #
    n = size(data, 2)
    color = process(svm, data)
    color[color .== -1] = 0

    #
    # Output result
    #

    y = reshape(data[1, :], n)
    x = reshape(data[2, :], n)

    println(plot(x = x, y = y, group = color, kind = :scatter))
end

