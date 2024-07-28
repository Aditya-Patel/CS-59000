using LinearAlgebra

# Define the kernel function
function kernel(x, y)
    return dot(x, y)
end

# Function to compute the new kernel matrix K' given K
function update_kernel_matrix(K, x_new1, x_new2, x_old)
    N = size(K, 1)
    K_prime = copy(K)

    # Compute new kernel values involving the new points
    for i in 1:N
        if i > 2
            K_prime[1, i] = kernel(x_new1, x_old[i, :])
            K_prime[2, i] = kernel(x_new2, x_old[i, :])
            K_prime[i, 1] = kernel(x_old[i, :], x_new1)
            K_prime[i, 2] = kernel(x_old[i, :], x_new2)
        end
    end

    # Compute new kernel values for the updated points
    K_prime[1, 1] = kernel(x_new1, x_new1)
    K_prime[1, 2] = kernel(x_new1, x_new2)
    K_prime[2, 1] = kernel(x_new2, x_new1)
    K_prime[2, 2] = kernel(x_new2, x_new2)
    
    return K_prime
end

# Example usage
# Assume K is the original kernel matrix and x_old is the matrix with original points
K = [1.0 0.5 0.2; 0.5 1.0 0.4; 0.2 0.4 1.0]  # Example kernel matrix
x_old = [1.0 2.0; 2.0 3.0; 3.0 4.0]  # Example points
x_new1 = [5.0 6.0]  # New point x'_1
x_new2 = [7.0 8.0]  # New point x'_2

K_prime = update_kernel_matrix(K, x_new1, x_new2, x_old)
println(K_prime)
