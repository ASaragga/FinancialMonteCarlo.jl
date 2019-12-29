"""
Struct for Merton Process

		mertonProcess=MertonProcess(σ::num1,λ::num2,μJ::num3,σJ::num4) where {num1,num2,num3,num4<: Number}
	
Where:\n
		σ  =	volatility of the process.
		λ  = 	jumps intensity.
		μJ =	jumps mean.
		σJ =	jumps variance.
"""
mutable struct MertonProcess{num <: Number, num1 <: Number,num2 <: Number,num3<:Number, nums0 <: Number, numd <: Number}<:FiniteActivityProcess
	σ::num
	λ::num1
	μJ::num2
	σJ::num3
	underlying::Underlying{nums0,numd}
	function MertonProcess(σ::num,λ::num1,μJ::num2,σJ::num3,underlying::Underlying{nums0,numd}) where {num <: Number, num1 <: Number,num2 <: Number,num3 <: Number, nums0 <: Number, numd <: Number}
        if σ<=0.0
			error("volatility must be positive");
		elseif λ<=0.0
			error("jump intensity must be positive");
		elseif σJ<=0.0
			error("positive λ must be positive");
		else
            return new{num,num1,num2,num3,nums0,numd}(σ,λ,μJ,σJ,underlying)
        end
    end
end

export MertonProcess;
compute_jump_size(mcProcess::MertonProcess,mcBaseData::MonteCarloConfiguration)=mcProcess.μ+mcProcess.σ1*randn(mcBaseData.rng);
compute_drift(mcProcess::MertonProcess)=-(-(mcProcess.σ^2)/2-mcProcess.λ*(exp(mcProcess.μ+mcProcess.σ1^2/2.0)-1.0))