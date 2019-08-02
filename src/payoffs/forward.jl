"""
Class for Dispatching Forward Payoff

		forward=Forward(T::num) where {num<:Number}
	
Where:\n
		T	=	Time to maturity of the Forward.
"""
struct Forward{num<:Number}<:EuropeanPayoff
	T::num
	function Forward(T::num) where {num<:Number}
        if T <= 0.0
            error("Time to Maturity must be positive")
        else
            return new{num}(T)
        end
    end
end

export Forward;


function payoff(S::AbstractMatrix{num},optionData::Forward,spotData::equitySpotData,T1::num2=optionData.T) where{num <: Number,num2 <: Number}
	r=spotData.r;
	T=optionData.T;
	(Nsim,NStep)=size(S)
	NStep-=1;
	index1=round(Int,T/T1 * NStep)+1;
	ST=S[:,index1];
	
	return ST*exp(-r*T);
end
