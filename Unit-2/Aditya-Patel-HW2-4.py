## Import statements
import numpy as np
import scipy as sp

## Function to create the n-by-n A matrix
def ijmat(n:int):
    a = np.zeros((n, n))
    for j in range(0, n):
        for i in range(0, n):
            a[i][j] = 1/(i+j+1) 
    return a

## Read Matrix from files
b = np.loadtxt("b-matrix.csv", delimiter=',')

a = ijmat(10)

## Solve Linear System of Equations
x = np.linalg.solve(a,b)

print("{}x{} Matrix[{}]".format(x.shape[0], 1, type(x[0])))
for val in x:
    print("{}".format(val))