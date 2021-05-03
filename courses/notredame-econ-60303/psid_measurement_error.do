#delimit ;
* read in data for cps87;
use psid1;

* open log file;
log using psid_measurement_error.log, replace;


tempfile main bootsave ;
set seed 365476247 ;
global bootreps = 1000;

gen wage=laborinc/hours;
gen wagel=log(wage);
* label variables;
label var wagel "log hourly wage rate";

* output the t-statistics for real_tax to a file;
postfile bskeep v2_m v2_sd beta_ols beta_fe using psid_measurementerror_results, replace;


**************************************;
* part a --- get the variance of tenure;
**************************************;
sum wagel tenure;


**************************************;
* part h --- lag tenure, regress tenure;
* on lag to see how correlated tenure;
* is over time;
**************************************;

sort id year;
by id: gen tenure_1=tenure[_n-1];
reg tenure tenure_1;


**************************************;
* part b --- get OLS and FE estimates;
**************************************;
* regression of ln(wagel) on tenure;
reg wagel tenure;

* regression of ln(wagel) on tenure;
areg wagel tenure, absorb(id);

qui save `main' , replace ;


**************************************;
* part c --- draw v;
**************************************;
* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;
use `main', replace ;

qui gen v=2*invnorm(uniform());            * draw v;
qui gen tenure2=tenure+v;                  * construct tenure2;
qui summ v;                                * get summary stats of v;
local vm=r(mean);                          * save the means and std dev;
local vsd=r(sd);                            
qui reg wagel tenure2;                     * ols regression of y on tenure2;
local bols_tenure=_b[tenure2];             * save beta;
qui areg wagel tenure2, absorb(id);        * fixed-effect regression of y on tenure2;
local bfe_tenure=_b[tenure2];              * save beta;
post bskeep (`vm') (`vsd') (`bols_tenure') (`bfe_tenure');
};
postclose bskeep ;

clear;
use psid_measurementerror_results;
sum;
