

function label(x::Integer)
    if x == -1
        return "Class 1"
    elseif x == 0
        return "Support Vector"
    else
        return "Class 2"
    end
end


function print_supportVectors(svm::SVM, data::Matrix)

    @assert (svm.dim == 2) "data must be 2D"
    @assert (size(svm.alpha, 1) == size(data, 2))

    n = size(data, 2)
    indexsv = findn(svm.alpha)
    color = process(svm, data)
    color[indexsv] = 0

    y = reshape(data[1, :], n)
    x = reshape(data[2, :], n)

    p = plot(x = x, y = y, color = map(label, color), Geom.point)
    draw(PNG("supportVectors.png", 6inch, 3inch), p)
end


function print_2Ddecision(svm::SVM, data::Matrix)

    # Check that we work in 2 dimensions
    @assert (svm.dim == 2) "data must be 2D"

    #
    # Get class of each data point
    #
    n = size(data, 2)
    color = process(svm, data)

    #
    # Output result
    #

    y = reshape(data[1, :], n)
    x = reshape(data[2, :], n)

    p = plot(x = x, y = y, color = map(label, color), Geom.point)
    draw(PNG("2Ddecision.png", 6inch, 3inch), p)
end

