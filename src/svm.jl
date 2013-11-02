
immutable SVM
    dim::Int
    alpha::Vector{Float64}
    w::Vector{Float64}
    b::Float64
end


# Take a decision
decision(svm::SVM, x::Vector) = sign((svm.w' * x + svm.b)[1])


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


