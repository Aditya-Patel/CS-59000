using Graphs
using SparseArrays
using DelimitedFiles
using LinearAlgebra
using Statistics

edgefile = pwd() * "/Unit-4/wiki-cats.edges"

## read in data from edge file
ei, ej =  copy.(eachcol(Int.(readdlm(edgefile))))
n = size(readdlm(pwd() * "/Unit-4/wiki-cats.xy"), 1)

## Create base adjacency matrix 
A = sparse(ei,ej,1,n,n) # we only store half the edges here
A = max.(A,A')
dropzeros!(A)
println("Loaded sparse matrix A from $edgefile")

function mv_prod(B, operation, A, x)
    ## We consider that if non-edges are 2 and edges are 3, split this into 2 arrays, 
    ## Where the second array is the sparse adjacency matrix A
    ## e.g., for one row: [2 2 2 2 2 2 2 ...] .+ [ 0 0 0 1 1 0 1 ...] = [2 2 2 3 3 2 3 ...] = M
    ## therefore taking the matrix-vector product M * x, we can say in the general case,
    ## where B is the matrix of the integer offset of size nxn, and A is the original sparse matrix
    ## (B .+/- A) * x = (B * x) .+/- (A * x) = (B * sum(x)) .+/- (A * x)

    if operation == "+"
        return (B * sum(x)) .+ (A*x)
    elseif operation == "-"
        return (B * sum(x)) .- (A*x)
    end
end

function power_method(M, max_iter=10000, tol=10e-4)
    ## Power method using Von Mises algorithm and Rayleigh quotient to finding the largest eigenvalue of M
    ## Create random vector and normalize
    x = sparse(rand(size(M,2)))
    x_k = x / norm(x)
    λ_p = 0.0
    
    for iter in 1:max_iter        
        ## Calculate matrix vector product for offset of 2 .+ A
        x_k_1 = mv_prod(2, "+", M, x_k)
        x_k_1 /= norm(x_k_1)

        ## Calculate Rayleigh quotient
        λ = dot(x_k_1, x_k') / dot(x_k', x_k)

        ## Check tolerance
        e_res = norm(x_k_1 .- λ*x_k)
        # Δλ = λ - λ_p ## Check difference between previous eigenvalue and current eigenvalue
        # println("Iter: $iter \tresidual: $e_res\t| Δλ = $Δλ") ## Display output to check convergence over iterations
        if e_res < tol
            return λ, iter, x_k_1
        end

        ## Normalize and update
        λ_p = λ
        x_k = x_k_1
    end
    
    error("convergence was not reached within $max_iter iterations for tolerance level $tol")
end

iters_to_coverge = []
λ_values = []
evector = []
tol = 10e-4
max_iters = 10000
tests = 10

for t in 1:tests
    local eigenvector
    eigenvalue, iterations, eigenvector = power_method(A, max_iters, tol)
    println("Test $t: \tConverged to $eigenvalue in $iterations iterations")
    push!(iters_to_coverge, iterations)
    push!(λ_values, eigenvalue)
    push!(evector, eigenvector)
end

avg_iters = ceil(mean(iters_to_coverge))
avg_λ = mean(λ_values)
avg_evec = mean(evector)

println("\nAverage Results over $tests tests based on tolerance of $tol")
println("Average largest eigenvalue: $avg_λ")
println("Average iterations to converge: $avg_iters")