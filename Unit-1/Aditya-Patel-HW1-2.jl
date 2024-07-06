using MatrixNetworks
using SparseArrays
using LinearAlgebra

## define iterable list and ordering list
a_iter = 0:0.0001:0.9999
orderings_man = Set{Vector{Int}}()
orderings_pkg = Set{Vector{Int}}()

## Define the adjacency matrix A 
A = [0 1 1 0 0 0 0 0 1 0; ## AI
     1 0 1 1 0 0 0 0 0 0; ## Statistics
     1 1 0 1 0 1 1 0 0 1; ## Data Science
     0 0 0 0 1 0 0 0 0 0; ## Data Mining
     0 0 0 0 0 1 0 0 0 0; ## Data Engineering
     0 0 0 0 0 0 1 0 0 0; ## Data Visualization
     0 0 0 0 0 0 0 1 0 1; ## Programming
     0 0 0 0 0 0 1 0 0 0; ## Parallel Computing
     1 0 0 0 0 0 0 0 0 0; ## Machine Learning
     0 0 0 0 0 0 0 0 1 0]## Julia
    
sparse_A = sparse(A)

## define the pageRank function
function pageRank(adj_mat::Matrix, alpha::Float64)
    n = size(adj_mat, 1)

    ## Create diagonal matrix
    d_mat = Diagonal(sum(adj_mat, dims=1)[:])
    d_inv = Diagonal(1 ./ diag(d_mat))

    ## Create I - alpha*D^-1*A'
    lhs_mat = I - alpha * adj_mat' * d_inv
    
    ## Define the right-hand side vector
    rhs_vec =  (1- alpha) / n * ones(n)

    ## Solve the equation
    x = lhs_mat \ rhs_vec

    return x
end

## Calculate pageRank manually and through MatrixNetworks
for a in a_iter
    p = sortperm(pageRank(A, a), rev=true)
    push!(orderings_man, p)
    p = sortperm(pagerank(sparse_A, a), rev=true)
    push!(orderings_pkg, p)
end

# Print results
for ordering in orderings_pkg
    @printf("Ordering: %s\n", join(ordering, ", "))
end
@printf("MatrixNetworks Ranking Count: %.0f\n\n", length(orderings_pkg))

for ordering in orderings_man
    @printf("Ordering: %s\n", join(ordering, ", "))
end
@printf("Manual Calculation Ranking Count: %.0f\n", length(orderings_man))


