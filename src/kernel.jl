
linear(x, y) = x' * y
polynomial(x, y, d) = (x' * y + 1) ^ d
laplacian(x, y, s) = exp(-norm(x - y) / sigma ^ 2)
rbf(x, y, s) = exp(-norm(x - y, 1) / sigma ^ 2)
