%% this subroutine calculates the hessian
%% of the poisson log likelikood
%% inputs are y,x,beta,n,k and the function
%% returns a (kxk) matrix of 2nd derivatives
function [hess]=calchess(y,x,beta,n,k)
lambda=exp(x*beta);
hess=zeros(k,k);
for i=1:n;
xi=x(i,:);
li=lambda(i,:);
hess=hess-li*xi'*xi;
end;
end
