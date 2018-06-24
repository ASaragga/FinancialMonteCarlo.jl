using MonteCarlo
include("runner.jl")

Nsim=10000;
Nstep=30;
sigma=0.2; 
p=0.3; 
lam=5.0; 
lamp=30.0; 
lamm=20.0; 
mc=MonteCarloBaseData(Nsim,Nstep);
runnerMonteCarlo(KouProcess(sigma,lam,p,lamp,lamm),mc)