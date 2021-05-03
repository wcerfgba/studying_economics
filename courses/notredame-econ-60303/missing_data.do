* this data set is randomly genertated sample with missing;
* observations.  the equation of interest is a log weekly;
* earnings regression with two covariates, education and age.
* the equation without missing data should produce an estimate;
* close to wearnl=4.49 + 0.08*educ + 0.012*age + e, where e;
* data is missing for wearnl if zstar<0 where;
* zstar=-1.5+0.15*educ+0.01*age+0.15*z+v;
* e and z are drawn from a bivariate normal with;
* mean_e=mean_v=0, stddev_v=1, stddev_e=0.46 and;
* rho=0.25.  there are 10000 obs, of which 5344 values of;
* wearn are reported; 

* missing data for wearnl is set equal to . (a period);

* wearnl_all is the untruncated weekly wage variable;
# delimit;

log using missing_data.log, replace;

use missing_data;

* get frequency of missing data;
tab missing;

* run ols model with real data;
reg wearnl_all educ age;


* run ols model with reported data;
* this is the model with missing data;
* deleted;
reg wearnl educ age;
* notice that ols estimatrs of educ and age;
* are biased down;

* generate data, nonmissing;
gen nonmissing=1-missing;
label var nonmissing "=1 if data for wearnl is reported";

* run probit, why data is reported;
probit nonmissing educ age z;

* run heckman sample selection correction;
heckman wearnl educ age, select(educ age z);

* run heckman sample selection correction;
* but use functional form to identify the model;
heckman wearnl educ age, select(educ age);



log close;

