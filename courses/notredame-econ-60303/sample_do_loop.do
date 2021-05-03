#delimit ;
use data_yx;

* open log file;
log using sample_do_loop.log, replace;



* estimate regression of y on x1-x3;
* compare these estimates and std errors;
* the the ones with measurement error in y below;
reg y x1 x2 x3;

* this command lists a temporary stata data file name (bskeep) that will contain;
* the new variables (the next 8 names).  The permanent file name is;
* error_in_y;
postfile bskeep ystarm ystarsd beta_x1 se_b1
beta_b2 se_b2 beta_x3 se_b3 using error_in_y, replace;


**************************************;
* in this part, we draw a random error, add to;
* y then regress the y with measurement error (ystar);
* on x1 x2 x3.  save the estimates and std;
* errors for each parameter;
**************************************;

tempfile main bootsave ;       * set up a temporary stata data file;
set seed 365476247 ;           * set the seed to start the random number generator;
global bootreps = 1000;         * how many replications in the simulation;

qui save `main' , replace ;    * save the data to the tempfile bootsave;

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;              * start the do loop;
use `main', replace ;                      * call the temporary file bootsave;

qui gen error=3*invnorm(uniform());        * draw normal rv from n(0,2^2);
qui gen ystar=y+error;                     * construct mismeasured y;
qui summ ystar;                            * get summary stats of ystar;
local ystarm=r(mean);                      * save the means and std dev;
local ystarsd=r(sd);                       * of ystar;     
qui reg ystar x1 x2 x3;                    * ols regression of y on x1-x3;
local beta_x1=_b[x1];                      * save betas and std errors;
local beta_x2=_b[x2];
local beta_x3=_b[x3];
local se_x1=_se[x1];
local se_x2=_se[x2];
local se_x3=_se[x3];

* output the results just saved in this iteration to the temporary file;
* bskeep;
post bskeep (`ystarm') (`ystarsd') (`beta_x1') (`se_x1') 
(`beta_x2') (`se_x2') (`beta_x3') (`se_x3') ;
};                                          * end the do loop;

* close the do temporary file after iterations;
postclose bskeep ;

clear;
use error_in_y;                             * read in the results and get summary stats;
sum;
