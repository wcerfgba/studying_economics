* this program generates estimates from;
* angrist and evans, aer, 1998;
* the sample is maried women, aged 21-35;
* with 2+ kids.  from the 1980 census 5% pums;
* the outcome of interest is female labor;
* supply and the covariate is;
* whether a mom had a third kid.  The instruments;
* are measures of the sex composition of the ;
* first 2 children;

# delimit;
set more 1;
set memory 20m;

* increase maximum variables;
set matsize 60;

*define log;
log using pums80.log,replace;

*read in stata data file;
use pums80;

* generate some new variables;
gen twoboys=boy1st*boy2nd;
gen twogirls=(1-boy1st)*(1-boy2nd);

* get descriptive statistics;
* 1980 married women sample;
* these are in column 3, Table 2;
sum;


* get correlation coefficient between;
* instrument and endogenous RHS variable;
corr morekids samesex;
* correlation coefficient is 0.0695;

* OLS of bivariate regression;
reg worked morekids;
* wald estimate;
* using the notation from class, if we have y,x,z,w;
* syntax for ivregress;
* ivregress 2sls y w (x=z);
* in this case, w=null,y=worked, x=morekids, z=samesex; 
ivregress 2sls worked (morekids=samesex);
* notice that ratio of OLS standard error;
* to IV std error on MOREKIDS is 0.0020246/0.0291243;
* which equals 0.0695, the rho(morekids,samesex);  



* 1st stage estimates;
* married women sample;
* these numbers are in Table 6, columns 4-6;

*column (4);
reg morekids samesex agem1 agefstm black hispan othrace;

* column (5);
reg morekids samesex boy1st boy2nd agem1 agefstm black hispan othrace;

* column (6);
* test twoboys=twogirls, the two coefficients are the same;
* test twoboys=twogirls=0, the two coefficients equal zero;
* this second test is the also the 1st stage f-test;
reg morekids twoboys twogirls boy1st agem1 agefstm black hispan othrace;
* output the residual from 1st stage for use later on;
predict res_1st_2zs, re;
test twoboys=twogirls;
test twoboys twogirls;


* demonstrate 1st stage and reduced form results for;
* exactly identified model;
* 1st stage;
reg morekids samesex boy1st boy2nd agem1 agefstm black hispan othrace;

* reduced form;
* look at the t-stat on the same sex variable and compare later on;
* to the t-stat in the 2sls model;
reg worked samesex boy1st boy2nd agem1 agefstm black hispan othrace;


* ols and 2sls results;
* 1980 pums;
* married women sample;
* table 7, columns 4-6;

* ols worked for pay model;
reg workedm morekids boy1st boy2nd agem1 agefstm black hispan othrace;

* 2sls worked for pay model;
* same sex as instrument;
reg workedm morekids boy1st boy2nd agem1 agefstm black hispan othrace
(samesex boy1st boy2nd agem1 agefstm black hispan othrace);

* can also do by ivregress;
* there are 4 variables, y,x,w and z as we have defined them in class.  
* the syntax is ivregress 2sls y w (x=z);
ivregress 2sls workedm boy1st boy2nd agem1 agefstm black hispan othrace
(morekids=samesex);


* 2sls worked for pay model;
* 2boys 2girls as instruments;
ivregress 2sls workedm boy1st agem1 agefstm black hispan othrace
(morekids=twoboys twogirls boy1st agem1 agefstm black hispan othrace);
predict res_2sls_worked, res;

* do test over overid;
estat overid;


* do test of overid by brute force;
reg res_2sls_worked twoboys twogirls boy1st agem1 agefstm black hispan othrace;


* Run Hausmans test of endogeneity, two instrument case;
* add residual from 1st stage regression to OLS of structural model;
reg workedm morekids boy1st agem1 agefstm black hispan othrace res_1st_2zs;
* notice that OLS of this model generates 2SLS estimates of the other;
* variables in the model (morekids, boy1st, etc.);



* ols weeks worked model;
reg weeksm1 morekids boy1st boy2nd agem1 agefstm black hispan othrace;


* 2sls weeks worked model;
* same sex as instrument;
reg weeksm1 morekids boy1st boy2nd agem1 agefstm black hispan othrace
(samesex boy1st boy2nd agem1 agefstm black hispan othrace);

* 2sls weeks worked model;
* 2boys 2girls as instruments;
ivreg weeksm1 boy1st agem1 agefstm black hispan othrace
(morekids=twoboys twogirls boy1st agem1 agefstm black hispan othrace);
overid;
* get test of overid;
predict res_2sls_weeks, res;
reg res_2sls_weeks twoboys twogirls boy1st agem1 agefstm black hispan othrace;


log close;




