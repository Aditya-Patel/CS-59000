import numpy as np
import cvxpy as cp

## Define variables
a = cp.Variable()
b = cp.Variable()

## Define constraints
con1 = 2*a + b <= 100
con2 = a + 2*b <= 80
constraints = [con1, con2, a >= 0, b >= 0]

## Define objective
objective = cp.Maximize(20*a + 30*b)

## Solve
prob = cp.Problem(objective, constraints)
prob.solve()
print("Status: ",prob.status)
print("Optimal Value: ", np.round(prob.value))
print("a: ", np.round(a.value))
print("b: ", np.round(b.value))