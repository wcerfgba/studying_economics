%% this subroutine calculates the value
%% of the poisson log likelikood
%% inputs are y,x,beta and the function
%% returns a scaler
%% the log likelihood requires the calculation of factorials
%% which is done with the gamma function.  
%% gamma(x+1)=x!
function [llike]=calcloglike(y,x,beta)
ylfact=log(gamma(y+1));
lambda=exp(x*beta);
llikei=-lambda+(x*beta).*y-ylfact;
llike=sum(llikei);
end