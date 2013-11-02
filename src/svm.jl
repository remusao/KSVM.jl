
immutable SVM
    dim::Int
    alpha::Vector{Float64}
    w::Vector{Float64}
    b::Float64
end


function decision(svm::SVM, x::Vector)

    # Check dimension
    @assert (size(x, 1) == svm.dim) "Data dimension must match"

    sign((svm.w' * x + svm.b)[1])
end


function process(svm, data::Matrix)
    dim, n = size(data)

    # Check dimension
    @assert (dim == svm.dim) "Data dimension must match"

    res = Array(Int, size(data, 2))
    for i = 1:n
        res[i] = decision(svm, data[:, i])
    end

    res
end


