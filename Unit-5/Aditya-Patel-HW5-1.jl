using Plots

## Define error term function for part a
function compute_err_a(x, h)
    return h 
end

## Define error term function for part c
function compute_err_c(x, h)
    return 0
end

## Define ranges for x and h
x_range = 1:10
h_range = 0.1:0.01:1.0

## Compute error at each combination of x and h_range
err_a = [compute_err_a(x, h) for x in x_range, h in h_range]
err_c = [compute_err_c(x, h) for x in x_range, h in h_range]

## Plot log-log heatmap
heatmap(x_range, h_range, err_a, xlabel="log(x)", ylabel="log(h)",
        title="Log-Log Heatmap of Error\nf'(x)=1/2h * (f(x+h) - f(x-h))",
        xscale=:log10, yscale=:log10)

heatmap(x_range, h_range, err_c, xlabel="log(x)", ylabel="log(h)",
        title="Log-Log Heatmap of Error\nf'(x)=1/2h * (f(x+h) - f(x-h))",
        xscale=:log10, yscale=:log10, color=:viridis)