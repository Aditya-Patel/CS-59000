## import packages
using Random
using LinearAlgebra
using DelimitedFiles

## Function to create a square matrix of fractions
function ijmat(n::Integer)
    A = zeros(n,n) 
    for j=1:n 
        for i=1:n 
            A[i,j] = 1/(i+j-1) 
        end 
    end 
    return A
end

## Function to generate a vector of random values
function randVec(n::Integer)
    b = zeros(n,1)
    for i=1:n
        b[i, 1] = randn()
    end
    return b
end

## Write b to a files
writedlm("b-matrix.csv", b, ",")

## solve linear system
A = ijmat(10)
b = randVec(10)

x = A \ b
for val in x
    println(val)
end
