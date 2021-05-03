
* this data for this example are adults, 18-64;
* who answered the cancer control supplement to;
* the 1994 national health interview survey;
* the key outcome is self reported health status;
* coded 1-5, poor, fair, good, very good, excellent;
* a ke covariate is current smoking status and whether;
* one smoked 5 years ago;

# delimit;
set memory 20m;
set matsize 200;
set more off;
log using c:\bill\jpsm\sr_health_status.log,replace;

* load up sas data set;
use c:\bill\jpsm\sr_health_status;

* get contents of data file;
desc;

* get summary statistics;
sum;

* get tabulation of sr_health;
tab sr_health;


* run OLS models, just to look at the raw correlations in data;
reg sr_health male age educ famincl black othrace smoke smoke5;

* do ordered probit, self reported health status;
oprobit sr_health male age educ famincl black othrace smoke smoke5;

* get marginal effects, evaluated at y=5 (excellent);
mfx compute, predict(outcome(5));

* get marginal effects, evaluated at y=3 (good);
mfx compute, predict(outcome(3));

* use prchange, evaluate marginal effects for;
* 40 year old white female with a college degree;
* never smoked with average log income;
prchange, x(age=40 black=0 othrace=0 smoke=0 smoke5=0 educ=16);
log close; 