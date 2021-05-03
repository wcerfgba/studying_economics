/* this program estimates a treatment effect
model with data from the JTPA.  The setup is 
that individuals interested in getting job 
training were randomly assigned a Job Training
Partnership Act (JTPA) training program or not.
However, participation is not mandatory so lots
of people assigned JTPA did not actually enroll.  
Also, some people who were NOT assigned treatment
enrolled in a job training course anyway.
There, treatment is the endogenous RHS variable
and assignment is the instrument*/

# delimit ;
set more off;

set memory 10m;
use jtpa_treatment;                    * read in data;
log using jtpa_training.log, replace;  * open log file;


* get some measure of partial compliance;
tab treatment assignment, row column;


* define the exogenous covariates in the regressions;
local xlist hsorged black hispanic age* 
wkless13 married;

* get OLS estimates of the impact of job training;
reg earnings `xlist' treatment;


* use assignment as instrument for treatment;
* estimates 2sls model -- ignores DGP for treatment;
reg earnings `xlist' treatment (`xlist' assignment);

* show first stage probit for treatment effect;
probit treatment `xlist' assignment;

* the mismeasured treatment effect model;
* the syntax is treatreg y x, treat(t=x z) where y is the outcome;
* x is the list of exogenous factrors, t is the treatment variable;
* and z are the instruments;
treatreg earnings `xlist', treat(treatment=`xlist' assignment);


* now estimate a model that is identified solely based on the;
* non-linearities in the model;
treatreg earnings `xlist', treat(treatment=`xlist');

log close;








 
  