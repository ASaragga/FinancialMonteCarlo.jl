function runnerMonteCarlo(Model::AbstractMonteCarloProcess,mc::MonteCarloBaseData)
	@show Model
	S0=100.0;
	K=100.0;
	r=0.02;
	T=1.0;
	
	d=0.01;
	
	D=90.0;
	spotData1=equitySpotData(S0,r,d);

	FwdData=ForwardData(T)
	EUData=EUOptionData(T,K)
	BarrierData=BarrierOptionData(T,K,D)
	AsianData=AsianFloatingStrikeOptionData(T)

	FwdPrice=pricer(Model,spotData1,mc,FwdData,Forward());
	EuPrice=pricer(Model,spotData1,mc,EUData,EuropeanOption());
	BarrierPrice=pricer(Model,spotData1,mc,BarrierData,BarrierOption());
	AsianPrice=pricer(Model,spotData1,mc,AsianData,AsianFloatingStrikeOption());

	@show FwdPrice
	@show EuPrice
	@show BarrierPrice
	@show AsianPrice

end

using DualNumbers;

function runnerMonteCarloDual(Model::AbstractMonteCarloProcess,mc::MonteCarloBaseData)
	@show Model
	S0=dual(100.0,1.0);
	K=100.0;
	r=0.02;
	T=1.0;
	
	d=0.01;
	
	D=90.0;
	spotData1=equitySpotData(S0,r,d);

	FwdData=ForwardData(T)
	EUData=EUOptionData(T,K)
	BarrierData=BarrierOptionData(T,K,D)
	AsianData=AsianFloatingStrikeOptionData(T)

	FwdPrice=pricer(Model,spotData1,mc,FwdData,Forward());
	EuPrice=pricer(Model,spotData1,mc,EUData,EuropeanOption());
	BarrierPrice=pricer(Model,spotData1,mc,BarrierData,BarrierOption());
	AsianPrice=pricer(Model,spotData1,mc,AsianData,AsianFloatingStrikeOption());

	@show FwdPrice
	@show EuPrice
	@show BarrierPrice
	@show AsianPrice

end