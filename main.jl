### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ c7b76b10-5059-11eb-1fd3-eff019f62e11
begin #dependencies: slow, possibly several minutes to precompile everything
	using GaussianProcesses
	using Random
	using Plots
end

# ╔═╡ a396df50-5058-11eb-2f43-a1622da4a533
md"Code shamelessly copied from [this tutorial](https://stor-i.github.io/GaussianProcesses.jl/latest/Regression/)
which is a walkthrough of [this library](https://github.com/STOR-i/GaussianProcesses.jl).

A lot of the appeal of going with Julia for this is actually [Stheno](https://github.com/willtebbutt/Stheno.jl), although python fans note there is also python version of this package! (The Julia version is supposed to enjoy a speed advantage and more importantly can interact with Soss and optim.jl, but on the other hand the python one is in python). I'm still too much of a beginner for the Stheno tools quite yet, but I think might be useful to try to head in that direction for possible future questions like 'can we infer things about the human kernel'
"

# ╔═╡ 60c4ceb0-50dc-11eb-3421-519bfc87777b
#using Pkg
#Pkg.status() #get info for binder Project.toml (in console, not notebook)

# ╔═╡ b42c1d00-50d8-11eb-1e8b-090170ad069f
md"## World setup"

# ╔═╡ d4f60080-50d5-11eb-35b1-fdff2d46911d
d=2 #number of dimensions

# ╔═╡ f08c59e0-50d8-11eb-0ddf-e3c4c3f848e9
n= 50 #number of observations

# ╔═╡ 54cea940-50d8-11eb-30b8-c56ad5646c56
x = 2π * rand(d, n); #Observations at these locations

# ╔═╡ 5b68b980-50d8-11eb-2054-7b3e4a525b2c
y = vec(sin.(x[1,:]).*sin.(x[2,:])) + 0.05*rand(n);#Values observed

# ╔═╡ 6bd48ff0-50d9-11eb-1819-9937373f4d69
md"## Hard thinking bit happens here: Set up a hypothesis space"

# ╔═╡ 5cf15550-50d8-11eb-13f2-57779f2b00b6
mZero = MeanZero(); # Zero mean function, not so controvertial

# ╔═╡ 65d618e0-50d8-11eb-3dff-f7e9a5f7244f
#choice of kernel on the other hand is doing a *lot* of the heavy lifting. These are the tutorial defaults.
kern = Matern(5/2,[0.0,0.0],0.0) + SE(0.0,0.0);    # Sum kernel with Matern 5/2 ARD kernel 
                                               # with parameters [log(ℓ₁), log(ℓ₂)] = [0,0] and log(σ) = 0
                                               # and Squared Exponential Iso kernel with
                                               # parameters log(ℓ) = 0 and log(σ) = 0

# ╔═╡ f1b94bb0-50d9-11eb-2718-db3fac5608a2
md"## Crank the handle"

# ╔═╡ 734398e0-50d8-11eb-1f25-cb3fcf6730b9
gp = GP(x,y,mZero,kern,-2.0);          # Fit the GP!

# ╔═╡ 85f472c0-50d8-11eb-0294-f99d6ec955be
optimize!(gp);# Hyperparameter tuning

# ╔═╡ 9105da52-50d8-11eb-02e5-4d0ad0983b3a
plot(contour(gp) ,heatmap(gp); fmt=:png) #Woohoo! This thing is analogous to the line of best fit: not sure how to add a confidence ribbon in the 2d case, but could maybe draw a bunch of samples from the posterior and view them as an animation?

# ╔═╡ Cell order:
# ╟─a396df50-5058-11eb-2f43-a1622da4a533
# ╠═c7b76b10-5059-11eb-1fd3-eff019f62e11
# ╟─60c4ceb0-50dc-11eb-3421-519bfc87777b
# ╟─b42c1d00-50d8-11eb-1e8b-090170ad069f
# ╠═d4f60080-50d5-11eb-35b1-fdff2d46911d
# ╠═f08c59e0-50d8-11eb-0ddf-e3c4c3f848e9
# ╠═54cea940-50d8-11eb-30b8-c56ad5646c56
# ╠═5b68b980-50d8-11eb-2054-7b3e4a525b2c
# ╟─6bd48ff0-50d9-11eb-1819-9937373f4d69
# ╠═5cf15550-50d8-11eb-13f2-57779f2b00b6
# ╠═65d618e0-50d8-11eb-3dff-f7e9a5f7244f
# ╟─f1b94bb0-50d9-11eb-2718-db3fac5608a2
# ╠═734398e0-50d8-11eb-1f25-cb3fcf6730b9
# ╠═85f472c0-50d8-11eb-0294-f99d6ec955be
# ╠═9105da52-50d8-11eb-02e5-4d0ad0983b3a
