
function rho_macro(model_type)
	@eval begin
		"""
		General Interface for Pricing

				Rho=rho(mcProcess,spotData,mcBaseData,payoff_)
			
		Where:\n
				mcProcess          = Process to be simulated.
				spotData  = Datas of the Spot.
				mcBaseData = Basic properties of MonteCarlo simulation
				payoff_ = Payoff(s) to be priced
				

				Rho     = Rho of the derivative

		"""	
		function rho(mcProcess::$model_type,spotData::ZeroRateCurve,mcConfig::MonteCarloConfiguration,abstractPayoff::AbstractPayoff,dr::Real=1e-7)

			Price=pricer(mcProcess,spotData,mcConfig,abstractPayoff);
			spotData_1=ZeroRateCurve(spotData.S0,spotData.r+dr,spotData.d);
			PriceUp=pricer(mcProcess,spotData_1,mcConfig,abstractPayoff);
			rho=(PriceUp-Price)/dr;

			return rho;
		end
	end
end

rho_macro(BaseProcess)

function rho_macro_array(model_type)
	@eval function rho(mcProcess::$model_type,spotData::ZeroRateCurve,mcConfig::MonteCarloConfiguration,abstractPayoffs::Array{AbstractPayoff},dr::Real=1e-7)
			Prices=pricer(mcProcess,spotData,mcConfig,abstractPayoffs);
			spotData_1=ZeroRateCurve(spotData.S0,spotData.r+dr,spotData.d);
			PricesUp=pricer(mcProcess,spotData_1,mcConfig,abstractPayoffs);
			rho=(PricesUp.-Prices)./dr;
		
		return rho;
	end
end

rho_macro_array(BaseProcess)