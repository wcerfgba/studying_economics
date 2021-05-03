%% load in the data from cps87.csv
%% column 1 is the dependent variable while
%% columns 2-k are independent variables
%% the constant is not in the data set
[w,varlist]=xlsread('cps_wage_data.xlsx');

dv=varlist{1,1};
%% get dimension of w
nk1=size(w);

% number of observations
n=nk1(1);

% number of independent variables
% k+1 is the no of columns of w.  there are k
% covariates (including the constant)
k=nk1(2)-1;

%% extract y which is in the 1st column of w
y=w(:,1);

%% extract x which is in columns 2 through k
x=w(:,2:(k+1));


xpxi=inv(x'*x);
beta=xpxi*x'*y;
e=y-x*beta;
sse=e'*e;

%% perform analysis of covariance
dof=n-k;
s2=sse/dof;
rmse=sqrt(s2);
ym=sum(y)/n;
sst=(y-ym)'*(y-ym);
ssm=sst-sse;
r2=ssm/sst;

%% ftest all coefficients equal zero
ftest=((sst-sse)/(k-1))/s2;
pvaluef=1-fcdf(ftest,(k-1),dof);
km1=k-1;
%% get variance of beta, t-stat and p-values
stderr=sqrt(diag(s2*xpxi));
tstat=beta./stderr;
pvalue=2*(1-tcdf(abs(tstat),(n-k)));

file1=fopen('ols_program.txt','w');
fprintf(file1,'----------------------------------------------------------------\n');
fprintf(file1,'Ordinary Least Square Estimates     \n');
fprintf(file1,'----------------------------------------------------------------\n');
fprintf(file1,'Dependent variable =  %s \n' ,dv);
fprintf(file1,'Mean of dep variable = %9.4f \n' ,ym);
fprintf(file1,'----------------------------------------------------------------\n');
fprintf(file1,'analysis of covariance              \n');
fprintf(file1,'\n');
fprintf(file1,'observations       = %9.f \n' ,n);
fprintf(file1,'parameters         = %9.f \n' ,k);
fprintf(file1,'degrees of freedom = %9.f \n' ,dof);
fprintf(file1,'sse                = %9.4f \n' ,sse);
fprintf(file1,'ssm                = %9.4f \n' ,ssm);
fprintf(file1,'sst                = %9.4f \n' ,sst);
fprintf(file1,'rsquared           = %9.4f \n' ,r2);
fprintf(file1,'mse                = %9.4f \n' ,s2);
fprintf(file1,'rmse               = %9.4f \n' ,rmse);

fprintf(file1,'F-test Ho: all betas = 0, F(%6.f,%9.f)=%9.4f \n',km1,dof,ftest);
fprintf(file1,'P-value on the f-test =%10.8f \n', pvaluef);
c1='Covariate'; c2='Beta'; c3='Std Error'; c4='T-statistic'; c5='P-value: B=0';
fprintf(file1,'----------------------------------------------------------------\n');
fprintf(file1,'%12s %12s %12s %12s %12s \n', c1,c2,c3,c4,c5);
fprintf(file1,'----------------------------------------------------------------\n');
for i=1:k;
    rowname=varlist{1,i+1};
    fprintf(file1,'%12s %12.6f %12.6f %12.6f %12.6f \n', rowname,beta(i,1),stderr(i,1),tstat(i,1),pvalue(i,1));
    end;
fprintf(file1,'----------------------------------------------------------------\n');

fclose(file1);
