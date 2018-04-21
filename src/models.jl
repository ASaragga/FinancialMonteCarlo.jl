abstract type AbstractMonteCarloProcess end

abstract type ItoProcess<:AbstractMonteCarloProcess end

abstract type FiniteActivityProcess<:AbstractMonteCarloProcess end

abstract type InfiniteActivityProcess<:AbstractMonteCarloProcess end

export AbstractMonteCarloProcess
export ItoProcess
export FiniteActivityProcess
export InfiniteActivityProcess

using Distributions;

function simulate(mcProcess::AbstractMonteCarloProcess,spotData::equitySpotData,mcBaseData::MonteCarloBaseData,T::Float64)
	error("This is a Virtual function")
end

include("models/brownian_motion.jl")
include("models/geometric_brownian_motion.jl")
include("models/black_scholes.jl")
include("models/kou.jl")
include("models/merton.jl")
include("models/subordinated_brownian_motion.jl")
include("models/variance_gamma.jl")
include("models/normal_inverse_gaussian.jl")
include("models/heston.jl")