

function label(x::Integer)
    if x == -1
        return "Class 1"
    elseif x == 0
        return "Support Vector"
    else
        return "Class 2"
    end
end


function print_supportVectors(svm::SVM)

    @assert (svm.dim == 2) "data must be 2D"

    y = reshape(svm.data[1, :], svm.n)
    x = reshape(svm.data[2, :], svm.n)

    println(plot(x = x, y = y, kind = :scatter))
end


function print_2Ddecision(svm::SVM, data::Matrix)

    # Check that we work in 2 dimensions
    @assert (svm.dim == 2) "data must be 2D"

    dim, n = size(data)

    #
    # Get class of each data point
    #
    color = process(svm, data)

    #
    # Output result
    #

    y = reshape(data[1, :], n)
    x = reshape(data[2, :], n)

    println(plot(x = x, y = y, group = map(label, color), kind = :scatter))
end

