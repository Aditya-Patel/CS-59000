## MNIST classification using Kernel machines
using MLDatasets
using LinearAlgebra
using NMF

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
@time println("Subset defined")

## Set rank for nmf
k = 80

## Create input for NMF
m = size(train_x,1)*size(train_x,2)
train_n = size(train_x,3)
train_X = Float64.(reshape(train_x, m, train_n)) ## Reshape to 784x5000 matrix
test_n = size(test_x,3)
test_X = Float64.(reshape(test_x, m, test_n)) ## Reshape to 784x500 matrix
@time println("Inputs for NMF are defined")

## Convert train images to NMF Rank 80
W, H = NMF.nndsvd(train_X', k; variant= :ar)
# println(size(W), " ", size(H)) --> Train_X 784x5000, H = 80x784, W=5000x80
alginst = NMF.ALSPGrad{Float64}(maxiter=100)
r = NMF.solve!(alginst, train_X', W, H)
@time println("Obtained r for train set")

## reconstruct training set
approx_x_train = (r.W * r.H)'
x_train = reshape(approx_x_train, 28, 28, train_n)
@time println("train_x converted to NMF rank 80")

## Project test images into Rank 80 basis
A = r.H'
A_inv = inv(A' * A)
approx_test_x = A * A_inv * A' * test_X
test_x = reshape(approx_test_x, 28, 28, test_n)
@time println("test_x projected onto nmf rank 80")

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
gif(anim, "mnist-kernel_nmf.gif", fps=1)
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