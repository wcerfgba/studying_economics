#delimit ;
* read in data for cps87;
use psid1;

* open log file;
log using psid_iv_comparison.log, replace;


gen wage=laborinc/hours;
gen wagel=log(wage);
* label variables;
label var wagel "log hourly wage rate";

**************************************;
* get fixed effects estimates;
**************************************;

areg wagel union tenure, absorb(id);

**************************************;
* generate within panel means in tenure;
**************************************;
sort id;
by id: egen tenurem=mean(tenure);
by id: egen unionm=mean(union);
gen tenured=tenure-tenurem;
gen uniond=union-unionm;
**************************************;
* check that within panel means have zero mean;
**************************************;
sum uniond tenured;

**************************************;
* show tenure first stage;
**************************************;
reg tenure tenured uniond;
reg union tenured uniond;

**************************************;
* run 2sls;
**************************************;

reg wagel union tenure (uniond tenured);
log close;

