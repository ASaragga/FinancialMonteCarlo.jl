"""
Struct for Brownian Motion

		bmProcess=BrownianMotion(σ::num1,μ::num2) where {num1,num2 <: Number}
	
Where:\n
		σ	=	volatility of the process.
		μ	=	drift of the process.
"""
mutable struct BrownianMotion{num <: Number, num1 <: Number, numtype <: Number} <: AbstractMonteCarloEngine{numtype}
	σ::num
	μ::num1
	function BrownianMotion(σ::num,μ::num1) where {num <: Number, num1 <: Number}
        if σ <= 0
            error("Volatility must be positive")
        else
			zero_typed=zero(num)+zero(num1);
            return new{num,num1,typeof(zero_typed)}(σ,μ)
        end
    end
end

export BrownianMotion;

function simulate!(X,mcProcess::BrownianMotion,mcBaseData::MonteCarloConfiguration{type1,type2,type3,SerialMode,type5},T::numb) where {numb <: Number, type1 <: Integer, type2<: Integer, type3 <: StandardMC, type5 <: Random.AbstractRNG}
	Nsim=mcBaseData.Nsim;
	Nstep=mcBaseData.Nstep;
	σ=mcProcess.σ;
	μ=mcProcess.μ;
	@assert T>0
	dt=T/Nstep
	mean_bm=μ*dt
	stddev_bm=σ*sqrt(dt)
	isDualZero=mean_bm*stddev_bm*0;
	view(X,:,1).=isDualZero;
	zero_typed=predict_output_type_zero_(σ,μ);
	Z=Array{typeof(get_rng_type(zero_typed))}(undef,Nsim);
	@inbounds for j=1:Nstep
		randn!(mcBaseData.rng,Z);
		@. @views X[:,j+1].=X[:,j]+mean_bm+stddev_bm*Z
	end

	nothing;

end

function simulate!(X,mcProcess::BrownianMotion,mcBaseData::MonteCarloConfiguration{type1,type2,type3,SerialMode,type5},T::numb) where {numb <: Number, type1 <: Integer, type2<: Integer, type3 <: AntitheticMC, type5 <: Random.AbstractRNG}
	Nsim=mcBaseData.Nsim;
	Nstep=mcBaseData.Nstep;
	σ=mcProcess.σ;
	μ=mcProcess.μ;
	@assert T>0
	dt=T/Nstep
	mean_bm=μ*dt
	stddev_bm=σ*sqrt(dt)
	isDualZero=mean_bm*stddev_bm*0;
	view(X,:,1).=isDualZero;
	Nsim_2=div(Nsim,2)
	zero_typed=predict_output_type_zero_(σ,μ);
	Z=Array{typeof(get_rng_type(zero_typed))}(undef,Nsim_2);
	Xp=@views X[1:Nsim_2,:]
	Xm=@views X[(Nsim_2+1):end,:]
	@inbounds for j=1:Nstep
		randn!(mcBaseData.rng,Z);
		@. @views Xp[:,j+1].=Xp[:,j]+mean_bm+stddev_bm*Z
		@. @views Xm[:,j+1].=Xm[:,j]+mean_bm-stddev_bm*Z
	end

	nothing;

end