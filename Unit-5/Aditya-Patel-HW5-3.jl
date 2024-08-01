using Plots

# # Define the function
# f(x) = -x^2 + 4

# # Generate x values
# x = -3:0.1:3
# y = f.(x)

# # Plot the function
# plot(x, y, label="f(x) = -x^2 + 4", xlabel="x", ylabel="f(x)", title="Global Maximizer of f(x) = -x^2 + 4")
# scatter!([0], [f(0)], label="Global Maximizer", color=:red, markersize=4)

# # Show the plot
# display(plot!())

# Define the function
g(x) = x^4 - 12*x^2 + 2*x

# # Generate x and y values for global function
x = -3:0.1:3
y = g.(x)

# define neighborhoods 
x1 = -3:0.1:0
y1 = g.(x1)

x2 = 0:0.1:3
y2 = g.(x2)

# Identify local minima
loc1 = x1[findmin(y1)[2]]
loc2 = x2[findmin(y2)[2]]

# Show the plot
plot(x, y, label="g(x) = x^4 -x^2 + 4", xlabel="x", ylabel="f(x)", title="Plot of g(x) = x^4 - 12x^2 + 2x")
scatter!([loc1], [g(loc1)], label="Local Minimizer in neighborhood $x1", color=:red, markersize=4)
scatter!([loc2], [g(loc2)], label="Local Minimizer in neighborhood $x2", color=:orange, markersize=4)

display(plot!())