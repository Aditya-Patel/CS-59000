using LinearAlgebra
using MatrixNetworks
using SparseArrays

A = [0 1 1 0 1 1;
     1 0 1 1 0 0;
     1 1 0 1 0 1;
     0 1 1 0 1 0;
     1 0 0 1 0 1;
     1 0 1 0 1 0;]

f2 = fiedler_vector(sparse(A))[1]
f2 .*= sign(f2[1])

D = Diagonal(vec(sum(A, dims=2)))
L = D - A

f2