using Sobol, StatsFuns


function simulate(mcProcess::SubordinatedBrownianMotion,mcBaseData::MonteCarloConfiguration{type1,type2,type3,SerialMode,type5},T::numb) where {numb <: Number, type1 <: Number, type2<: Number, type3 <: SobolMode, type5 <: Random.AbstractRNG}
	Nsim=mcBaseData.Nsim;
	Nstep=mcBaseData.Nstep;
	drift=mcProcess.drift;
	sigma=mcProcess.sigma;
	@assert T>0
	type_sub=typeof(quantile(mcProcess.subordinator_,0.5));
	isDualZero=drift*zero(type_sub)*0;
	X=Matrix{typeof(isDualZero)}(undef,Nsim,Nstep+1);
	@views X[:,1].=isDualZero;
	seq=SobolSeq(Nstep);
	skip(seq,Nstep*Nsim)
	@inbounds for i=1:Nsim
		vec=norminvcdf.(next!(seq))
		@inbounds for j=1:Nstep
			dt_s=rand(mcBaseData.rng,mcProcess.subordinator_);
			@views X[i,j+1].=X[i,j].+drift.*dt_s.+sigma.*sqrt.(dt_s).*vec[j];
		end
	end

	return X;
	
end


function simulate(mcProcess::SubordinatedBrownianMotionVec,mcBaseData::MonteCarloConfiguration{type1,type2,type3,SerialMode,type5},T::numb) where {numb <: Number, type1 <: Number, type2<: Number, type3 <: SobolMode, type5 <: Random.AbstractRNG}
	Nsim=mcBaseData.Nsim;
	Nstep=mcBaseData.Nstep;
	drift=mcProcess.drift;
	sigma=mcProcess.sigma;
	@assert T>0
	type_sub=typeof(quantile(mcProcess.subordinator_,0.5));
	zero_drift=drift(zero(type_sub),zero(type_sub)+dt)*0;
	isDualZero=zero_drift*zero(type_sub)*0;
	X=Matrix{typeof(isDualZero)}(undef,Nsim,Nstep+1);
	@views X[:,1].=isDualZero;
	seq=SobolSeq(Nstep);
	skip(seq,Nstep*Nsim)
	@inbounds for i=1:Nsim
		t_s=zero(type_sub);
		vec=norminvcdf.(next!(seq))
		@inbounds for j=1:Nstep
			dt_s=rand(mcBaseData.rng,mcProcess.subordinator_);
			tmp_drift=drift(t_s,dt_s);
			t_s+=dt_s;
			@views X[i,j+1]=X[i,j]+tmp_drift+sigma*sqrt(dt_s)*vec[j];
		end
	end

	return X;
	
end