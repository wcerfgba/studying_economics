%% load in the data from drvisits.xlsx
%% column 1 is the dependent variable while
%% columns 2-(k+1) are independent variables
%% column 2 contains the constant
[w,varlist]=xlsread('drvisits.xlsx');

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

%% take the log of the max of 1 or y to generate
%% generate starting values

yl=log(max(1,y));

%% extract x which is in columns 2 through k
x=w(:,2:(k+1));
xpxi=inv(x'*x);
beta_start=xpxi*x'*yl

%% compare analytic and numeric derivatives
%% grada is the analytic derivative
%% gradn is the numeric derivative

%% get analytic derivative
grada=calcgrad(y,x,beta_start);

%% get numeric derivatives

%% establish size of epsilon, 0.001*abs(beta) is reasonably small
epsilon=0.001*abs(beta_start);

%% set a vector of zeros of lenth k
gradn=zeros(k,1);

%% betap is the positive step in beta;
%% betan is the negative step in beta;


for i=1:k;
  betap=beta_start;
  betan=beta_start;
  epsilonk=epsilon(i,:);
  betap(i,:)=beta_start(i,:)+epsilonk;
  betan(i,:)=beta_start(i,:)-epsilonk;
  gradn(i,:)=gradn(i,:)+(calcloglike(y,x,betap)-calcloglike(y,x,betan))/(2*epsilonk);
end;

%% print out results

file1=fopen('poisson_check.txt','w');
c1='Covariate'; c2='beta_start'; c3='epsilon'; c4='grada'; c5='gradn';
fprintf(file1,'--------------------------------------------------------------\n');
fprintf(file1,'%12s %12s %12s %12s %12s \n', c1,c2,c3,c4,c5);
fprintf(file1,'--------------------------------------------------------------\n');
for i=1:k;
    rowname=varlist{1,i+1};
    fprintf(file1,'%12s %12.6f %12.6f %12.6f %12.6f \n', rowname,beta_start(i,:), epsilon(i,:), grada(i,1),gradn(i,1));
    end;
fprintf(file1,'--------------------------------------------------------------\n');


%% compare analytic second derivatives along main diagonal with
%% numeric estimates of same derivatives

%% hessda is diagonal of analytic hessian 
%% hessdn is the diagonal of the numeric hessian
hessda=diag(calchess(y,x,beta_start,n,k));


%% set a vector of zeros of lenth k
hessdn=zeros(k,1);

%% betap is the positive step in beta;
%% betan is the negative step in beta;

%% get baseline loglike -- needed for second derivative;
ll=calcloglike(y,x,beta_start);

for i=1:k;
  betap=beta_start;
  betan=beta_start;
  epsilonk=epsilon(i,:);
  betap(i,:)=beta_start(i,:)+epsilonk;
  betan(i,:)=beta_start(i,:)-epsilonk;
  hessdn(i,:)=hessdn(i,:)+(calcloglike(y,x,betap)+calcloglike(y,x,betan)-2*ll)/(epsilonk*epsilonk);
end;

%% print out results
c1='Covariate'; c2='beta_start'; c3='epsilon'; c4='hessda'; c5='hessdn';
fprintf(file1,'--------------------------------------------------------------\n');
fprintf(file1,'%12s %12s %12s %12s %12s \n', c1,c2,c3,c4,c5);
fprintf(file1,'--------------------------------------------------------------\n');
for i=1:k;
    rowname=varlist{1,i+1};
    fprintf(file1,'%12s %12.6f %12.6f %12.6f %12.6f \n', rowname,beta_start(i,:), epsilon(i,:),hessda(i,:),hessdn(i,:));
    end;
fprintf(file1,'--------------------------------------------------------------\n');
fclose(file1);