#delimit ;
set memory 100m;
set more off;
* read in data for problem;
use problemset7;

* open log file;
log using problemset7, replace;





tempfile main repsave;
set seed 365476247 ;
global bootreps = 100;

postfile bskeep b2_ols t2_ols b2_iv t2_iv b2_te t2_te rho using problemset7_rho1, replace;

qui save `main' , replace ;

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;
use `main', replace ;

gen sigma1=1;
gen sigma2=22;
gen rho=-0.5;
gen l11=sigma1;
gen l22=sigma2*sqrt(1-rho*rho);
gen l21=rho*sigma2;
gen z1=rnormal();
gen z2=rnormal();
gen e1=l11*z1;
gen e2=l21*z1+l22*z2;
gen x2star=-1.6 + 0.04*x1+0.18*z+e1;
gen x2=x2star>=0;
gen y=-3+x1-6*x2+e2;

*************************;
* get ols estimates;
*************************;
qui reg y x1 x2;
local b2_ols=_b[x2];              * save b2_ols;
local t2_ols = _b[x2] / _se[x2];  * save t on x2;

*************************;
* get 2sls estimates;
*************************;
qui reg y x1 x2 (x1 z);
local b2_iv=_b[x2];             * save b2_ols;
local t2_iv = _b[x2] / _se[x2];  * save t on x2;


*************************;
* get mismeasured treatment;
*************************;
qui treatreg y x1, treat(x2=x1 z);
local b2_te=_b[x2];             * save b2_treatment effect;
local t2_te = _b[x2] / _se[x2];  * save t on x2;
local rho=e(rho);
post bskeep (`b2_ols') (`t2_ols') (`b2_iv') (`t2_iv') (`b2_te') (`t2_te') (`rho');
};

postclose bskeep;
clear;
use problemset7_rho1;
sum;
clear;



use problemset7;

tempfile main repsave;
set seed 365476247 ;
global bootreps = 100;

postfile bskeep b2_ols t2_ols b2_iv t2_iv b2_te t2_te rho using problemset7_rho2, replace;

qui save `main' , replace ;

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;
use `main', replace ;

gen sigma1=1;
gen sigma2=22;
gen rho=-0.25;
gen l11=sigma1;
gen l22=sigma2*sqrt(1-rho*rho);
gen l21=rho*sigma2;
gen z1=rnormal();
gen z2=rnormal();
gen e1=l11*z1;
gen e2=l21*z1+l22*z2;
gen x2star=-1.6 + 0.04*x1+0.18*z+e1;
gen x2=x2star>=0;
gen y=-3+x1-6*x2+e2;

*************************;
* get ols estimates;
*************************;
qui reg y x1 x2;
local b2_ols=_b[x2];              * save b2_ols;
local t2_ols = _b[x2] / _se[x2];  * save t on x2;

*************************;
* get 2sls estimates;
*************************;
qui reg y x1 x2 (x1 z);
local b2_iv=_b[x2];             * save b2_ols;
local t2_iv = _b[x2] / _se[x2];  * save t on x2;


*************************;
* get mismeasured treatment;
*************************;
qui treatreg y x1, treat(x2=x1 z);
local b2_te=_b[x2];             * save b2_treatment effect;
local t2_te = _b[x2] / _se[x2];  * save t on x2;
local rho=e(rho);
post bskeep (`b2_ols') (`t2_ols') (`b2_iv') (`t2_iv') (`b2_te') (`t2_te') (`rho');
};

postclose bskeep;
clear;
use problemset7_rho2;
sum;
clear;


use problemset7;

tempfile main repsave;
set seed 365476247 ;
global bootreps = 100;

postfile bskeep b2_ols t2_ols b2_iv t2_iv b2_te t2_te rho using problemset7_rho3, replace;

qui save `main' , replace ;

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;
use `main', replace ;

gen sigma1=1;
gen sigma2=22;
gen rho=0;
gen l11=sigma1;
gen l22=sigma2*sqrt(1-rho*rho);
gen l21=rho*sigma2;
gen z1=rnormal();
gen z2=rnormal();
gen e1=l11*z1;
gen e2=l21*z1+l22*z2;
gen x2star=-1.6 + 0.04*x1+0.18*z+e1;
gen x2=x2star>=0;
gen y=-3+x1-6*x2+e2;

*************************;
* get ols estimates;
*************************;
qui reg y x1 x2;
local b2_ols=_b[x2];              * save b2_ols;
local t2_ols = _b[x2] / _se[x2];  * save t on x2;

*************************;
* get 2sls estimates;
*************************;
qui reg y x1 x2 (x1 z);
local b2_iv=_b[x2];             * save b2_ols;
local t2_iv = _b[x2] / _se[x2];  * save t on x2;


*************************;
* get mismeasured treatment;
*************************;
qui treatreg y x1, treat(x2=x1 z);
local b2_te=_b[x2];             * save b2_treatment effect;
local t2_te = _b[x2] / _se[x2];  * save t on x2;
local rho=e(rho);
post bskeep (`b2_ols') (`t2_ols') (`b2_iv') (`t2_iv') (`b2_te') (`t2_te') (`rho');
};

postclose bskeep;
clear;
use problemset7_rho3;
sum;
clear;


use problemset7;

tempfile main repsave;
set seed 365476247 ;
global bootreps = 100;

postfile bskeep b2_ols t2_ols b2_iv t2_iv b2_te t2_te rho using problemset7_rho4, replace;

qui save `main' , replace ;

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;
use `main', replace ;

gen sigma1=1;
gen sigma2=22;
gen rho=0.25;
gen l11=sigma1;
gen l22=sigma2*sqrt(1-rho*rho);
gen l21=rho*sigma2;
gen z1=rnormal();
gen z2=rnormal();
gen e1=l11*z1;
gen e2=l21*z1+l22*z2;
gen x2star=-1.6 + 0.04*x1+0.18*z+e1;
gen x2=x2star>=0;
gen y=-3+x1-6*x2+e2;

*************************;
* get ols estimates;
*************************;
qui reg y x1 x2;
local b2_ols=_b[x2];              * save b2_ols;
local t2_ols = _b[x2] / _se[x2];  * save t on x2;

*************************;
* get 2sls estimates;
*************************;
qui reg y x1 x2 (x1 z);
local b2_iv=_b[x2];             * save b2_ols;
local t2_iv = _b[x2] / _se[x2];  * save t on x2;


*************************;
* get mismeasured treatment;
*************************;
qui treatreg y x1, treat(x2=x1 z);
local b2_te=_b[x2];             * save b2_treatment effect;
local t2_te = _b[x2] / _se[x2];  * save t on x2;
local rho=e(rho);
post bskeep (`b2_ols') (`t2_ols') (`b2_iv') (`t2_iv') (`b2_te') (`t2_te') (`rho');
};

postclose bskeep;
clear;
use problemset7_rho4;
sum;
clear;



use problemset7;

tempfile main repsave;
set seed 365476247 ;
global bootreps = 100;

postfile bskeep b2_ols t2_ols b2_iv t2_iv b2_te t2_te rho using problemset7_rho5, replace;

qui save `main' , replace ;

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;
use `main', replace ;

gen sigma1=1;
gen sigma2=22;
gen rho=0.5;
gen l11=sigma1;
gen l22=sigma2*sqrt(1-rho*rho);
gen l21=rho*sigma2;
gen z1=rnormal();
gen z2=rnormal();
gen e1=l11*z1;
gen e2=l21*z1+l22*z2;
gen x2star=-1.6 + 0.04*x1+0.18*z+e1;
gen x2=x2star>=0;
gen y=-3+x1-6*x2+e2;

*************************;
* get ols estimates;
*************************;
qui reg y x1 x2;
local b2_ols=_b[x2];              * save b2_ols;
local t2_ols = _b[x2] / _se[x2];  * save t on x2;

*************************;
* get 2sls estimates;
*************************;
qui reg y x1 x2 (x1 z);
local b2_iv=_b[x2];             * save b2_ols;
local t2_iv = _b[x2] / _se[x2];  * save t on x2;


*************************;
* get mismeasured treatment;
*************************;
qui treatreg y x1, treat(x2=x1 z);
local b2_te=_b[x2];             * save b2_treatment effect;
local t2_te = _b[x2] / _se[x2];  * save t on x2;
local rho=e(rho);
post bskeep (`b2_ols') (`t2_ols') (`b2_iv') (`t2_iv') (`b2_te') (`t2_te') (`rho');
};

postclose bskeep;
clear;
use problemset7_rho5;
sum;
clear;



















