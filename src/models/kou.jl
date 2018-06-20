type KouProcess<:FiniteActivityProcess end

export KouProcess;

function simulate(mcProcess::KouProcess,spotData::equitySpotData,mcBaseData::MonteCarloBaseData,T::Float64,monteCarloMode::MonteCarloMode=standard)
	r=spotData.r;
	S0=spotData.S0;
	d=spotData.d;
	Nsim=mcBaseData.Nsim;
	Nstep=mcBaseData.Nstep;
	if(length(mcBaseData.param)!=5)
		error("Kou Model needs 5 parameters")
	end
	sigma=mcBaseData.param["sigma"];
	lambda1=mcBaseData.param["lambda"];
	p=mcBaseData.param["p"];
	lambdap=mcBaseData.param["lambdap"];
	lambdam=mcBaseData.param["lambdam"];
	if T<=0.0
		error("Final time must be positive");
	elseif lambda1<=0.0
		error("jump intensity must be positive");
	elseif lambdap<=0.0
		error("positive lambda must be positive");
	elseif lambdam<=0.0
		error("negative lambda must be positive");
	elseif !(0<=p<=1)
		error("p must be a probability")
	end

	####Simulation
	## Simulate
	# r-d-psi(-i)
	drift_RN=r-d-sigma^2/2-lambda1*(p/(lambdap-1)-(1-p)/(lambdam+1));
	const dict1=Dict{String,Number}("sigma"=>sigma, "drift" => drift_RN)
	brownianMcData=MonteCarloBaseData(dict1,Nsim,Nstep);
	X=simulate(BrownianMotion(),spotData,brownianMcData,T,monteCarloMode)

	t=linspace(0.0,T,Nstep+1);

	PoissonRV=Poisson(lambda1*T);
	NJumps=quantile.(PoissonRV,rand(Nsim));

	for ii in 1:Nsim
		Njumps_=NJumps[ii];
		# Simulate the number of jumps (conditional simulation)
		tjumps=sort(rand(Njumps_)*T);
		for tjump in tjumps
			# Add the jump size
			
			idx1=findfirst(x->x>=tjump,t);
			u=rand(); #simulate Uniform([0,1])
			jump_size=u<p?quantile_exp(lambdap,rand()):-quantile_exp(lambdam,rand())
			X[ii,idx1:end]+=jump_size; #add jump component
			
			#for i in 1:Nstep
			#   if tjump>t[i] && tjump<=t[i+1] #Look for where it is happening the jump
			#	  u=rand(); #simulate Uniform([0,1])
			#	  jump_size=(u<p)?quantile(PosExpRV,rand()):-quantile(NegExpRV,rand()) #Compute jump size
			#	  X[ii,i+1:end]+=jump_size; #add jump component
			#	  break;
			#   end
			#end
			
		end
	end
	## Conclude
	S=S0.*exp.(X);
	return S;

end
