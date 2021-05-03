# delimit ;
set more off ;

* fix seed for replication purposes and;
* set the number of bootstrap replications;
set seed 365;
global bootreps = 1000;


tempfile main bootsave ;

use data_for_ps3;

* sort by groupid;
sort groupid;
xtset groupid;

qui save `main' , replace ;

* output the t-statistics for real_tax to a file;
postfile bskeep t_400_o t_100_o t_75_o t_50_o t_25_o t_10_o
t_400_c t_100_c t_75_c t_50_c t_25_c t_10_c
t_400_r t_100_r t_75_r t_50_r t_25_r t_10_r using bs_resultsa, replace;


* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;


use `main', replace ;

* with 50% probability constuct dummy;
qui by groupid: gen temp = uniform() ;
qui by groupid: gen dummylaw = (temp[1] < .5) ;


* now regress y on placebo variable;
qui reg y1 dummylaw;
 
* generate the t-stat for ols;
local tt_400_o = _b[dummylaw] / _se[dummylaw] ;


* generate the t-stat clustered;
qui reg y1 dummylaw, cluster(groupid);
local tt_400_c = _b[dummylaw] / _se[dummylaw] ;


qui xtreg y1 dummylaw, re;
local tt_400_r = _b[dummylaw] / _se[dummylaw] ;

qui keep if groupid<=100;

* now regress y on placebo variable;
qui reg y1 dummylaw;
 
* generate the t-stat for ols;
local tt_100_o = _b[dummylaw] / _se[dummylaw] ;


* generate the t-stat clustered;
qui reg y1 dummylaw, cluster(groupid);
local tt_100_c = _b[dummylaw] / _se[dummylaw] ;


qui xtreg y1 dummylaw, re;
local tt_100_r = _b[dummylaw] / _se[dummylaw] ;

qui keep if groupid<=75;

* now regress y on placebo variable;
qui reg y1 dummylaw;
 
* generate the t-stat for ols;
local tt_75_o = _b[dummylaw] / _se[dummylaw] ;


* generate the t-stat clustered;
qui reg y1 dummylaw, cluster(groupid);
local tt_75_c = _b[dummylaw] / _se[dummylaw] ;


qui xtreg y1 dummylaw, re;
local tt_75_r = _b[dummylaw] / _se[dummylaw] ;


qui keep if groupid<=50;

* now regress y on placebo variable;
qui reg y1 dummylaw;
 
* generate the t-stat for ols;
local tt_50_o = _b[dummylaw] / _se[dummylaw] ;


* generate the t-stat clustered;
qui reg y1 dummylaw, cluster(groupid);
local tt_50_c = _b[dummylaw] / _se[dummylaw] ;


qui xtreg y1 dummylaw, re;
local tt_50_r = _b[dummylaw] / _se[dummylaw] ;

qui keep if groupid<=25;

* now regress y on placebo variable;
qui reg y1 dummylaw;
 
* generate the t-stat for ols;
local tt_25_o = _b[dummylaw] / _se[dummylaw] ;


* generate the t-stat clustered;
qui reg y1 dummylaw, cluster(groupid);
local tt_25_c = _b[dummylaw] / _se[dummylaw] ;


qui xtreg y1 dummylaw, re;
local tt_25_r = _b[dummylaw] / _se[dummylaw] ;

qui keep if groupid<=10;

* now regress y on placebo variable;
qui reg y1 dummylaw;
 
* generate the t-stat for ols;
local tt_10_o = _b[dummylaw] / _se[dummylaw] ;


* generate the t-stat clustered;
qui reg y1 dummylaw, cluster(groupid);
local tt_10_c = _b[dummylaw] / _se[dummylaw] ;


qui xtreg y1 dummylaw, re;
local tt_10_r = _b[dummylaw] / _se[dummylaw] ;



* add to the bottom of the post file;
post bskeep (`tt_400_o') (`tt_100_o') (`tt_75_o') (`tt_50_o') (`tt_25_o') (`tt_10_o')
(`tt_400_c') (`tt_100_c') (`tt_75_c') (`tt_50_c') (`tt_25_c') (`tt_10_c')
(`tt_400_r') (`tt_100_r') (`tt_75_r') (`tt_50_r') (`tt_25_r') (`tt_10_r');

} ;

/* end of bootstrap reps */

* save the post file;
postclose bskeep;

* clear the current data set;

clear;

* load up the t-stats;
use bs_resultsa;

* figure out where the main-t is in the;
* synthetic distribution;

gen crit400=invttail(3998,0.025);
gen crit100=invttail(998,0.025);
gen crit75=invttail(748,0.025);
gen crit50=invttail(498,0.025);
gen crit25=invttail(248,0.025);
gen crit10=invttail(98,0.025);

gen r400o=abs(t_400_o)>=crit400;
gen r100o=abs(t_100_o)>=crit100;
gen r75o=abs(t_75_o)>=crit75;
gen r50o=abs(t_50_o)>=crit50;
gen r25o=abs(t_25_o)>=crit25;
gen r10o=abs(t_10_o)>=crit10;

gen r400c=abs(t_400_c)>=crit400;
gen r100c=abs(t_100_c)>=crit100;
gen r75c=abs(t_75_c)>=crit75;
gen r50c=abs(t_50_c)>=crit50;
gen r25c=abs(t_25_c)>=crit25;
gen r10c=abs(t_10_c)>=crit10;

gen r400r=abs(t_400_r)>=1.96;
gen r100r=abs(t_100_r)>=1.96;
gen r75r=abs(t_75_r)>=1.96;
gen r50r=abs(t_50_r)>=1.96;
gen r25r=abs(t_25_r)>=1.96;
gen r10r=abs(t_10_r)>=1.96;

sum r*;

