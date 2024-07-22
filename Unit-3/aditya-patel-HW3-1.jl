## MNIST classification using Kernel machines
using MLDatasets
using LinearAlgebra

train_x, train_y = MNIST(split=:train)[:]
test_x,  test_y  = MNIST(split=:test)[:]
## There are 60,000 training images and 10,000 test images
# we are going to get only a subset of them:
# 5,000 training images and 500 test images
using Random
Random.seed!(0)
subset_train = randperm(length(train_y))[1:5000]
subset_test = randperm(length(test_y))[1:500]
train_x = train_x[:,:,subset_train]
test_x = test_x[:,:,subset_test]
train_y = train_y[subset_train]
test_y = test_y[subset_test]
println("Subset defined")

m = size(train_x, 1)
n_train = size(train_x, 3)
n_test = size(test_x, 3)

train_X = Float64.(reshape(train_x, m*m, n_train))

## Set rank for svd
k = 80
U, S, V = svd(train_X)
x_approx = U[:,1:k]*Diagonal(S[1:k])*V[:,1:k]'
train_x = reshape(x_approx, 28, 28, 5000)
println("train_x converted to SVD Rank 80")

## Project test images to SVD Rank 80
test_X = reshape(test_x, m*m, n_test)
A = U[:, 1:k]
A_inv = inv(A' * A)
test_proj_x = A * A_inv * A' * test_X

test_x = reshape(test_proj_x, m, m, n_test)
println("test_x converted to SVD rank 80")


## see how to use a Kernel machine, which involve solving a sym. pos. def linear system
target = 6
y = 2.0.*(train_y .== target) .- 1.0 # get a -1, 1 vector for target / not target

## Work through an example with Kernel machines
# Goal, train a 9 or not classifier based on a RBF Kernel
using LinearAlgebra
function build_kernel(train_x, sigma)
  N = size(train_x)[end]
  K = zeros(N,N)
  for i=1:N
    for j=1:N
      x = @view train_x[:,:,i]
      y = @view train_x[:,:,j]
      K[i,j] = exp(-norm(x-y)^2/(2*sigma))
    end
  end
  return K
end

sigma = 1.1
K = build_kernel(train_x, 1.0)
println("Kernel built")
##
a = K\y
## Compute the prediction
function predict(x,a,sigma,train_x)
  N = size(train_x)[end]
  k = zeros(N)
  for i=1:N
    k[i] = exp(-norm(x-train_x[:,:,i])^2/(2*sigma))
  end
  return k'*a
end

using Plots
anim=  @animate for i=1:50
  yhat = predict(test_x[:,:,i],a,sigma,train_x)
  ytrue = test_y[i]
  color = reverse(cgrad(:Greys))
  if (ytrue == target) != (yhat .>= 0)
    color=(reverse(cgrad(:Reds)))
  end
  heatmap(Float64.(test_x[:,:,i]'),yflip=true,framestyle=:none,
    colorbar=false,color=color)
  plot!(size=(300,300),dpi=300)
  title!("Predicted $(target) = $(yhat .>= 0)")
end
gif(anim, "mnist-kernel_svd.gif", fps=1)
println("gif generated")

## Give the number of errors
ntest = size(test_x)[end]
yhat = zeros(Bool, ntest)
for i=1:ntest
  yhat[i] = predict(test_x[:,:,i],a,sigma,train_x) .>= 0
end
## Show the confusion matrix
tp = sum( (yhat .== true) .& (test_y .== target) )
tn = sum( (yhat .== false) .& (test_y .!= target) )
fp = sum( (yhat .== true) .& (test_y .!= target) )
fn = sum( (yhat .== false) .& (test_y .== target) )
C = [tp tn ; fp fn]
accuracy = (tp+tn)/(sum(C))


## Look at accuracy across values of sigma
function accuracy_of_sigma(target, sigma)
  K = build_kernel(train_x, sigma)
  y = 2.0.*(train_y .== target) .- 1.0 # get a -1, 1 vector for target / not target
  a = K\y

  ntest = size(test_x)[end]
  yhat = zeros(Bool, ntest)
  for i=1:ntest
    yhat[i] = predict(test_x[:,:,i],a,sigma,train_x) .>= 0
  end

  tp = sum( (yhat .== true) .& (test_y .== target) )
  tn = sum( (yhat .== false) .& (test_y .!= target) )
  fp = sum( (yhat .== true) .& (test_y .!= target) )
  fn = sum( (yhat .== false) .& (test_y .== target) )
  C = [tp tn ; fp fn]
  accuracy = (tp+tn)/(sum(C))
  return accuracy, C
end

@time accuracy_of_sigma(6, 1.1)