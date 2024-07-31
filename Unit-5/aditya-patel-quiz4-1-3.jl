## Here is the code from unit 1

# This treats everything as a dense matrix :(
A = [0 0 1 0 0
    1 0 0 1 0
    1 0 0 1 0
    0 1 0 0 1
    0 0 1 0 0]
n = 5

## Simple PageRank
function simplepagerank(A,α,v)
 @assert(0 ≤ α < 1, "needs probably α")
 @assert(all(vi -> vi ≥ 0, v), "needs non-negative v")
 v = v ./ sum(v) # we can normalize for them.
 d = vec(sum(A,dims=2)) # compute the degrees
 x = copy(v) # start of with v
 nsteps = 2*ceil(Int,log(eps(1.0))/log(α)) # upper bound on steps
 for i=1:nsteps
   x = α*(A'*(x./d)) .+ (1-α).*v
 end
 return x/sum(x) # renormalize to probability
end

pr = simplepagerank(A, 0.875, ones(n)./n)
