A = [0 1 1 0 1 1
     1 0 1 1 0 0
     1 1 0 1 0 1
     0 1 1 0 1 0
     1 0 0 1 0 1
     1 0 1 0 1 0]

# Get the number of vertices
num_vertices = size(A, 1)

# Find all edges in the graph
edges = []
for i in 1:num_vertices
    for j in i+1:num_vertices
        if A[i, j] == 1
            push!(edges, (i, j))
        end
    end
end

# Get the number of edges
num_edges = length(edges)

# Initialize the incidence matrix B
B = zeros(Int, num_edges, num_vertices)

# Fill the incidence matrix B
for (k, (i, j)) in enumerate(edges)
    B[k, i] = 1
    B[k, j] = -1
end

# Print the incidence matrix B
print(B)

[1 -1 0 0 0 0; 
1 0 -1 0 0 0; 
1 0 0 0 -1 0; 
1 0 0 0 0 -1; 
0 1 -1 0 0 0; 
0 1 0 -1 0 0; 
0 0 1 -1 0 0; 
0 0 1 0 0 -1; 
0 0 0 1 -1 0; 
0 0 0 0 1 -1]