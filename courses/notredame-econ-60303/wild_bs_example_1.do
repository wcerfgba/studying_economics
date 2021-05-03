#delimit ;

* open log file;
log using wild_bs_example_1.log , replace ;

* set stata parameters;
set mem 5m ;
set more off ;

* fix seed for replication purposes and;
* set the number of bootstrap replications;
set seed 365476247 ;
global bootreps = 999;


tempfile main bootsave ;

use carton_sales_taxes;
drop if year<2004;
/* 	the data contains monthly market share of
        cigarette sales by carton (compared to pack)
        for 29 states over the 2001-2006 period so there
        are 29*12*6 = 2088 observations.  I regress the market
        share on real taxes (state+federal in dollars/pack) 
        and add state, year and month dummies.  Because
        taxes are at the state level, you clustrer at the
        state level.  The parameter we will generate bootstrap
        p-values for is on real_tax and the null hypothesis we
        will impose is ho: beta(real_tax)=0
*/


* means of key covariates;
sum carton_market_share real_tax;

* construct the dummies used in analysis;
xi i.state i.month i.year;

di ;
* run ols without clustered std errors, just for comparison;
reg carton_market_share _I* real_tax;

* now run ols and cluster at the state level;
reg carton_market_share _I* real_tax, cluster(state);
* save t-test as a global variable;
global maint = _b[real_tax] / _se[real_tax] ;

* now run OLS and impose null that real_tax=0;
reg carton_market_share _I*;

* output residuals;
predict epshat , resid;
predict yhat , xb ;

* sort by state and temp save data;
sort state;
qui save `main' , replace ;

* get the number of states;
qui by state: keep if _n == 1 ;
qui summ ;
global numstates = r(N) ;


* output the t-statistics for real_tax to a file;
postfile bskeep t_wild using bs_results, replace;


* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;

/* wild bootstrap */
use `main', replace ;

* with 50% probability constuct dummy;
* that adds or substracts Radamaker error;
qui by state: gen temp = uniform() ;
qui by state: gen pos = (temp[1] < .5) ;
gen wildresid = epshat * (2*pos - 1) ;

* now construct y;
gen wildy = yhat + wildresid ;

* now regress y on all x variables;
qui reg wildy _I* real_tax, cluster(state); 
* generate the t-stat;
local bst_wild = _b[real_tax] / _se[real_tax] ;

* add to the bottom of the post file;
post bskeep (`bst_wild') ;
} ; 

/* end of bootstrap reps */

* save the post file;
postclose bskeep ;

* clear the current data set;
clear;

* load up the wild t-stats;
use bs_results;

* figure out where the main-t is in the;
* synthetic distribution;
gen positive=$maint>0;
gen pos=t_wild>$maint;
gen neg=t_wild<$maint;
gen reject=positive*pos + (1-positive)*neg;
sum reject;
local sumreject=r(sum);
local p_value_wild=2*`sumreject'/$bootreps;
local p_value_main=2*(ttail(($numstates-1),abs($maint)));


di "Number BS reps                         = $bootreps";
di "P-value from clustered standard errors = `p_value_main'";
di "P-value from wild boostrap             = `p_value_wild'";
log close ;
