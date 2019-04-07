using BenchmarkTools
using MonteCarlo,CuArrays

S0=100.0;
K=100.0;
r=0.02;
T=1.0;
d=0.01;
D=90.0;

Nsim=10000;
Nstep=30;
sigma=0.2; 
p=0.3; 
lam=5.0; 
lamp=30.0; 
lamm=20.0;
mc=MonteCarloConfiguration(Nsim,Nstep);
toll=0.8;

spotData1=equitySpotData(S0,r,d);

FwdData=Forward(T)
EUData=EuropeanOption(T,K)
AMData=AmericanOption(T,K)
BarrierData=BarrierOptionDownOut(T,K,D)
AsianFloatingStrikeData=AsianFloatingStrikeOption(T)
AsianFixedStrikeData=AsianFixedStrikeOption(T,K)
Model=KouProcess(sigma,lam,p,lamp,lamm);

@btime FwdPrice=pricer(Model,spotData1,mc,FwdData);						
@btime FwdPrice=pricer(Model,spotData1,mc,FwdData,MonteCarlo.standard,MonteCarlo.CudaMode());						
@btime FwdPrice=pricer(Model,spotData1,mc,FwdData,MonteCarlo.standard,MonteCarlo.CudaMode_2());						
@btime EuPrice=pricer(Model,spotData1,mc,EUData);
@btime EuPrice=pricer(Model,spotData1,mc,EUData,MonteCarlo.standard,MonteCarlo.CudaMode());
@btime EuPrice=pricer(Model,spotData1,mc,EUData,MonteCarlo.standard,MonteCarlo.CudaMode_2());
@btime AmPrice=pricer(Model,spotData1,mc,AMData);
@btime AmPrice=pricer(Model,spotData1,mc,AMData,MonteCarlo.standard,MonteCarlo.CudaMode_2());