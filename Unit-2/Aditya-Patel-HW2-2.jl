##
using Printf
using LinearAlgebra

## Define functions for the three solution methods
function quadraticFormula(a, b, c)
    if b^2 > 4*a*c
        return (-b + sqrt(b^2 - 4*a*c)) / (2*a), (-b - sqrt(b^2 - 4*a*c)) / (2*a)
    end
end

function completeTheSquare(a, b, c)
    ## Normalize all terms:
    c = c/a
    b = b/a
    a = a/a

    ## Constant term to right side:
    c = -c

    ## Add/Subtract b to make the perfect trinomial
    b_half_sqr = (b/2)^2 

    ## Squared Binomial
    rhs = c + b_half_sqr

    ## Solve for X
    if rhs > 0
        ## Real Roots
        roots = -b/2 + (sqrt(rhs)), -b/2 - (sqrt(rhs))
        return roots
    end
end

function NewtonRaphsonMethod(a, b, c, itr, guess)
    ## Define f(x) and f'(x)
    f(x, a, b, c) = a*x^2 + b*x + c
    f_prime(x, a, b) = 2*a*x + b

    x = guess
    for n in 1:itr
        f_x = f(x, a, b, c)
        f_xp = f_prime(x, a, b)
        if abs(f_xp) < 1e-10
            return x
        end
        x_new = x - f_x/f_xp
        if abs(x_new - x) < 1e-10
            return x_new
        end
        x = x_new
    end
    return x
end

## Execute with Float16 values for a, b, c, and x_guess

for i in -10:10
    for j in -10:10
        for k in -10:10
            local a = Float64(i)
            local b = Float64(j)
            local c = Float64(k)
            local x_guess = Float64((sum([i, j, k])/3))

            quadRoot = quadraticFormula(a, b, c)
            ctsRoot = completeTheSquare(a, b, c)
            newtonRoot = NewtonRaphsonMethod(a, b, c, 1000, x_guess)

            if  !isnothing(quadRoot) && !isnothing(ctsRoot) ## Only take real zeros
                if quadRoot[1] != ctsRoot[1] != newtonRoot != quadRoot[1] ## Check for where they are not equal
                    println("Root 1 with a=$i, b=$j, c=$k:\t", quadRoot[1], "\t\t\t", ctsRoot[1], "\t\t\t", newtonRoot)
                end
            end
        end
    end
end