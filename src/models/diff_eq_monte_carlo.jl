#function get_initial_u0(mcProcess::MonteCarloProblem)
#	if(typeof(mcProcess.prob)<:JumpProblem)
#		return  mcProcess.prob.prob.u0;
#	else
#		return mcProcess.prob.u0;
#	end
#end



mutable struct MonteCarloDiffEqModel{num <: DiffEqBase.AbstractEnsembleProblem} <: ItoProcess
	model::num
	final_trasform::Function
	underlying::AbstractUnderlying
	function MonteCarloDiffEqModel(model::num,final_trasform::Function,underlying::AbstractUnderlying) where {num <: DiffEqBase.AbstractEnsembleProblem}
        return new{num}(model,final_trasform,underlying)
    end
	function MonteCarloDiffEqModel(model::num,underlying::AbstractUnderlying) where {num <: DiffEqBase.AbstractEnsembleProblem}
		func(x)=identity(x);
        return new{num}(model,func,underlying)
    end
end

function simulate(mcProcess::MonteCarloDiffEqModel,rfCurve::ZeroRate,mcBaseData::MonteCarloConfiguration{type1,type2,type3,type4,type5},T::numb) where {numb <: Number, type1 <: Number, type2<: Number, type3 <: AbstractMonteCarloMethod, type4 <: BaseMode, type5 <: Random.AbstractRNG}
	
	Nsim=mcBaseData.Nsim;
	Nstep=mcBaseData.Nstep;
	Dt=T/Nstep
	@assert T>0.0
	diffeqmodel=mcProcess.model;
	sol = solve(diffeqmodel,SOSRI(),EnsembleThreads(),trajectories=Nsim,dt=Dt,adaptive=false)
	X=[path.u[j] for path in sol.u, j in 1:(Nstep+1)];
	return mcProcess.final_trasform.(X);
end
