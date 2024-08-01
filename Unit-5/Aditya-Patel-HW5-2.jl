## Add required packages
using Pkg
# Pkg.add("CSV"); Pkg.add("DataFrames"); Pkg.add("Convex"); Pkg.add("SCS"); Pkg.add("StatsPlots"); Pkg.add("HypothesisTests")
using Statistics, StatsPlots, CSV, DataFrames, Convex, SCS, Random, HypothesisTests

Random.seed!(42)

## Import dataset as a DataFrame
url = "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
wine_df = CSV.read(download(url), DataFrame; delim=';')

## Extract features and target and convert to matrix
X = Matrix{Float64}(wine_df[:, Not("quality")])
y = convert(Vector{Float64}, wine_df[:, "quality"])

## Train-test split
function train_test_split(X, y, train_split=0.7)
    n = size(X, 1)
    idx = Random.shuffle(1:n)
    
    ## Identify the test and train indices
    train_idx = view(idx, 1:floor(Int, train_split*n))
    test_idx = view(idx, floor(Int, train_split*n)+1:n)
    
    X_train = X[train_idx, :]
    X_test = X[test_idx, :]
    y_train = y[train_idx]
    y_test = y[test_idx]
    return X_train, X_test, y_train, y_test
end

train_split = 0.8
X_train, X_test, y_train, y_test = train_test_split(X, y, train_split)

## Define variables
β_nnls = Variable(size(X_train, 2))
β_uls = Variable(size(X_train, 2))

## Define problem
nnls_prob = minimize(sumsquares(X_train*β_nnls - y_train), β_nnls >= 0)
uls_prob = minimize(sumsquares(X_train*β_uls - y_train))

## Solve the problem for training data
nnls_sol = solve!(nnls_prob, SCS.Optimizer, silent=true)
uls_sol = solve!(uls_prob, SCS.Optimizer, silent=true)
β_nnls_val = evaluate(β_nnls)
β_uls_val = evaluate(β_uls)

β_nnls_vals = β_nnls.value
β_uls_vals = β_uls.value

## Evaluate againt test data
y_pred_nnls =(X_test * β_nnls_val)
y_pred_uls = (X_test * β_uls_val)

## Print coefficients and optimal values
println("Non-Negative Least Squares coefficients:", β_nnls_val)
println("Unconstrained Least Squares coefficients:", β_uls_val)
println("Minimized value of |y-X*β|^2 for NNLS: ", nnls_prob.optval)
println("Minimized value of |y-X*β|^2 for ULS: ", uls_prob.optval)

## Compute MSE for both solutions
mse_nnls = mean((y_test - y_pred_nnls).^2)
mse_uls = mean((y_test - y_pred_uls).^2)
println("MSE for NNLS:", mse_nnls)
println("MSE for ULS:", mse_uls)
println()

## Plot results
## Distributions of actual quality vs predictions
display(boxplot(y_test, y_pred_nnls, label="NNLS predictions", xlabel="Actual Quality", ylabel="Predicted Quality", color=:blue))
display(boxplot(y_test, y_pred_uls, label="ULS predictions", xlabel="Actual Quality", ylabel="Predicted Quality", color=:red))

## Significance testing
## H0: mean(NNLS) = mean(ULS)
## H1: mean(NNLS) ≠ mean(ULS)
OneWayANOVATest(y_pred_nnls, y_pred_uls)