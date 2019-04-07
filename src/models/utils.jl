quantile_exp(lam::Number,rand1::Number)::Number=-log(1-rand1)/lam;

#import Distributions.quantile
#
#function quantile(d::Distribution{Distributions.Univariate,Distributions.Continuous},perc::Number)
#	percval=value(perc);
#	yval=quantile(d,percval);
#	der1=1.0/(pdf(d,yval));
#	y=Dual(yval,der1);
#	return y;
#end

import Base.Float32
Float32(p::Dual{Float64})=dual(Float32(p.value),Float32(p.epsilon))