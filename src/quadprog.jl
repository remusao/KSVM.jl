
function quadprog(H::Matrix,
                  f::Vector,
                  A::Vector,
                  Beq::Vector,
                  LB::Vector,
                  UB::Vector)

    # Number of variables
    n = size(H, 1)
    # Variable lower bounds
    x_L = LB
    # Variable upper bounds
    x_U = UB

    # Number of constraints
    m = 1
    # Constraint lower bounds
    g_L = [zero(Float64)]
    # Constraint lower bounds
    g_U = [zero(Float64)]

    # Number of non-zeros in Jacobian
    nele_jac = n
    # Number of non-zeros in Hessian
    nele_hess = int((n * n) / 2)


    # Callback: objective function
    function eval_f(x::Vector{Float64})
        (0.5 * x' * H * x + f' * x)[1]
    end


    # Callback: constraint evaluation
    function eval_g(x::Vector{Float64}, g::Vector{Float64})
        g[1] = (A'* x)[1]
    end


    # Callback: objective function gradient
    function eval_grad_f(x::Vector{Float64}, grad_f::Vector{Float64})
        res = x' * (H + H') - 1
        for i = 1:size(x, 1)
            grad_f[i] = res[i]
        end
    end


    # Callback: Jacobian evaluation
    function eval_jac_g(
        x::Vector{Float64},         # Current solution
        mode,                       # Either :Structure or :Values
        rows::Vector{Int32},        # Sparsity structure - row indices
        cols::Vector{Int32},        # Sparsity structure - column indices
        values::Vector{Float64})    # The values of the Hessian

        if mode == :Structure
            for i = 1:size(x, 1)
                cols[i] = i
                rows[i] = 1
            end
        else
            # Sparse
            # Jac(i) = yi (label i)
            for i = 1:size(x, 1)
                values[i] = A[i]
            end
        end
    end

    prob = createProblem(
        n,              # Number of variables
        x_L,            # Variable lower bounds
        x_U,            # Variable upper bounds
        m,              # Number of constraints
        g_L,            # Constraint lower bounds
        g_U,            # Constraint upper bounds
        nele_jac,       # Number of non-zeros in Jacobian
        nele_hess,      # Number of non-zeros in Hessian
        eval_f,         # Callback: objective function
        eval_g,         # Callback: constraint evaluation
        eval_grad_f,    # Callback: objective function gradient
        eval_jac_g)     # Callback: Jacobian evaluation

    prob.x = zeros(Float64, n)

    # We do not provide a Hessian
    addOption(prob, "hessian_approximation", "limited-memory")

    # Solve problem
    status = solveProblem(prob)

    # Return optimal alpha
    prob.x
end
