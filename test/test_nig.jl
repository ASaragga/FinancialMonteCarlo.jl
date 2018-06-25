using Base.Test, MonteCarlo;
@show "NormalInverseGaussianProcess"
S0=100.0;
K=100.0;
r=0.02;
T=1.0;
d=0.01;
D=90.0;

Nsim=10000;
Nstep=30;
sigma=0.2; 
theta1=0.01; 
k1=0.03; 
mc=MonteCarloConfiguration(Nsim,Nstep);
toll=0.8;

spotData1=equitySpotData(S0,r,d);

FwdData=Forward(T)
EUData=EuropeanOption(T,K)
AMData=AmericanOption(T,K)
BarrierData=BarrierOptionDownOut(T,K,D)
AsianData=AsianFloatingStrikeOption(T)
Model=NormalInverseGaussianProcess(sigma,theta1,k1);

@show FwdPrice=pricer(Model,spotData1,mc,FwdData);						
@show EuPrice=pricer(Model,spotData1,mc,EUData);
@show AmPrice=pricer(Model,spotData1,mc,AMData);
@show BarrierPrice=pricer(Model,spotData1,mc,BarrierData);
@show AsianPrice=pricer(Model,spotData1,mc,AsianData);

@test abs(FwdPrice-97.95852227697686)<toll
@test abs(EuPrice-7.738298817933206)<toll
@test abs(BarrierPrice-6.886023820038332)<toll
@test abs(AsianPrice-4.414948846776423)<toll




@show FwdPrice=pricer(Model,spotData1,mc,FwdData,MonteCarlo.antithetic);						
@show EuPrice=pricer(Model,spotData1,mc,EUData,MonteCarlo.antithetic);
@show AmPrice=pricer(Model,spotData1,mc,AMData,MonteCarlo.antithetic);
@show BarrierPrice=pricer(Model,spotData1,mc,BarrierData,MonteCarlo.antithetic);
@show AsianPrice=pricer(Model,spotData1,mc,AsianData,MonteCarlo.antithetic);
tollanti=0.8;
@test abs(FwdPrice-97.95852227697686)<tollanti
@test abs(EuPrice-7.738298817933206)<tollanti
@test abs(BarrierPrice-6.886023820038332)<tollanti
@test abs(AsianPrice-4.414948846776423)<tollanti