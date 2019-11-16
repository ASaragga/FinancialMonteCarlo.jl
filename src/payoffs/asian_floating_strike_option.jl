"""
Struct for Asian Floating Strike Option

		asOption=AsianFloatingStrikeOption(T::num1,isCall::Bool=true) where {num1<:Number}
	
Where:\n
		T	=	Time to maturity of the Option.
		isCall  = true for CALL, false for PUT.
"""
mutable struct AsianFloatingStrikeOption{num<:Number}<:AsianPayoff
	T::num
	isCall::Bool
	function AsianFloatingStrikeOption(T::num,isCall::Bool=true) where {num<:Number}
        if T <= 0.0
            error("Time to Maturity must be positive")
        else
            return new{num}(T,isCall)
        end
    end
end

export AsianFloatingStrikeOption;


function payoff(S::AbstractMatrix{num},asianFloatingStrikePayoff::AsianFloatingStrikeOption,spotData::ZeroRateCurve,T1::num2=asianFloatingStrikePayoff.T) where{num <: Number,num2 <: Number}
	iscall=asianFloatingStrikePayoff.isCall ? 1 : -1
	r=spotData.r;
	T=asianFloatingStrikePayoff.T;
	(Nsim,NStep)=size(S)
	NStep-=1;
	index1=round(Int,T/T1 * NStep)+1;
	zero_typed=zero(eltype(S));
	@inbounds f(S::abstractArray) where {abstractArray<:AbstractArray{num_}} where {num_<:Number}=max(iscall*(S[end]-mean(S)),zero_typed)
	@inbounds payoff2=[f(view(S,i,1:index1)) for i in 1:Nsim];

	return payoff2*exp(-r*T);
end
