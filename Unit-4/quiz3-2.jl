function solve_with_svd(U, s, V, b)
    # Compute pseudo inverse of sigma
    s_inv = Diagonal(1 ./ s)

    # Solve for y in U * y = B
    y = U' * b

    # Solve for z in  sigma * z = y
    z = s_inv * y

    # solve for x in V' * x = z
    x = V * z
    
    return x
end