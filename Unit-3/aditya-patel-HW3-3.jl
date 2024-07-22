function solve_lower_triangular_fs(L, b)
    # define constants    
    n = size(L, 1) ## Get number of rows in the n x n matrix L
    x = zeros(n) ## Initialize the solution vector x

    for i in 1:n ## Row traversal
        if L[i, i] == 0 ## Verify that L is invertible
            ## Raise error if not invertible
            error("L is not invertible. No solution for the linear system.") 
        end

        ## Solve for x
        x[i] = b[i]
        println("x[$i]:", x[i])

        for j in 1:i-1
            x[i] = x[i] - (L[i,j] * x[j])
        end
    
        x[i] = (1 ./ L)[i,i]*x[i]
    end
    
    return x

end

## Test
L = [2 0 0;
     4 -2 0;
     -5 1 3]

b = [6; 10; 1]

solve_lower_triangular_fs(L, b)