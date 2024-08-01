using Plots

## Define error term function for part a
function ϵ_a(x, h)
    return h + 0*x 
end

## Define error term function for part c
function ϵ_c(x, h)
    return 0*x + 0*h
end

## Define ranges for x and h
x_range = 1:10
h_range = 0.1:0.01:1.0

## Compute error at each combination of x and h_range
err_a = [ϵ_a(x, h) for x in x_range, h in h_range]
err_c = [ϵ_c(x, h) for x in x_range, h in h_range]

## Plot log-log heatmap
display(heatmap(x_range, h_range, err_a, xlabel="log(x)", ylabel="log(h)",
        title="Log-Log Heatmap of Error\nf'(x)=1/2h * (f(x+h) - f(x-h))",
        xscale=:log10, yscale=:log10, color=reverse(cgrad(:reds))))

display(heatmap(x_range, h_range, err_c, xlabel="log(x)", ylabel="log(h)",
        title="Log-Log Heatmap of Error\nf'(x)=1/2h * (f(x+h) - f(x-h))",
        xscale=:log10, yscale=:log10, color=reverse(cgrad(:reds))))
