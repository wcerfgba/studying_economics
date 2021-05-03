%% this subroutine calculates the gradient
%% of the poisson log likelikood
%% inputs are y,x,beta and the function
%% returns a (kx1) vector of 1st derivatives
function [grad]=calcgrad(y,x,beta)
lambda=exp(x*beta);
yml=y-lambda;
gradt=yml'*x;
grad=gradt';
end