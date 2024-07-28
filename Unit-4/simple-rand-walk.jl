using Plots

function simple_random_walk(n_steps)
    steps = rand([-1, 1], n_steps)
    position = cumsum(steps)
    return position
end

# Simulate a random walk with 10 steps
n_steps = 10
random_walk = simple_random_walk(n_steps)

# Plot the random walk
plot(random_walk, label="Random Walk", title="1D Simple Random Walk", xlabel="Step", ylabel="Position")