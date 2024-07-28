using LinearAlgebra
using SparseArrays

## Taking only the first 7 components
A = [0 1 1 1 1 0 1 
     1 0 0 0 0 0 0 
     0 0 0 0 1 1 1 
     1 1 0 0 1 1 0 
     1 1 1 1 0 0 0 
     0 0 1 0 0 0 1 
     0 0 0 0 0 1 0]

## Get the inverse of the diagonal degree matrix
d = vec(sum(A, dims=2))
D_inv = Diagonal(1.0 ./ d)

## Find P
P = Matrix(A' * D_inv)
vals, vecs = eigen(P)
## Find the eigenvector corresponding to the largest eigenvalue
max_val_ind = findmax(abs.(vals))[2]

println("Largest Eigenvector:")
probs = Float64.(vecs[:, max_val_ind]/sum(vecs[:, max_val_ind]))