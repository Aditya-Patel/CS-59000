using LinearAlgebra
using Printf

function count_darts(N::Int, k::Int)
  num_inside = 0
  for i=1:N
    p = rand(k)
    num_inside += sum(abs.(p)) <= 1
  end
  return num_inside
end


##
N = 10000000
println("dim\t->\tcount\t|\t% volume")
println("---------------------------------------------")
for k=2:20
  n = count_darts(N, k)
  println(k, "\t->\t", n, "\t|", (n/N*100), "%")
end
##

