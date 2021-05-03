

* set end of line marker;
# delimit;
set more off;

* increase memory;
set memory 20m;

* write results to file;
log using c:\bill\jpsm\travel_choice_example.log,replace;

* load up sas data set;
use c:\bill\jpsm\travel_choice_example;

* get contents of data file;
desc;

* get summary statistics;
sum;

* get freqency of options;
tab choice;

* construct dummy variables for intercepts;
* with j choices, need j-1 options;
gen air=mode==1;
gen train=mode==2;
gen bus=mode==3;
gen car=mode==4;

* interact hhinc and group size with choice dummies;
gen hhinc_air=air*hhinc;
gen hhinc_train=train*hhinc;
gen hhinc_bus=bus*hhinc;

* if mode of transportation is a car, costs are costs;
* if mode is bus/train/air, costs are grp_size x costs;

gen group_costs=car*costs+(1-car)*groupsize*costs; 


* get means by choices;
sum time group_costs if mode==1;
sum time group_costs if mode==2;
sum time group_costs if mode==3;
sum time group_costs if mode==4;


* run mcfaddens choice model.  for covariates add;
* a) j-1 option dummies;
* c) variables that vary by choice;

clogit choice air train bus time group_costs, group(hhid);

* run another model but add;
* c) income and interacted w/ choice dummies;
clogit choice air train bus time group_costs hhinc_*, group(hhid);

* print out odds ratios;
listcoef;



* in this section we simulate the change in the;
* choices if we increase the travel time;
* by car by 30 minutes;

* get the predicted probabilities given original;
* values of Xs;

predict pred0;

* for mode=4, add 30 minutes;
replace time=time+30 if mode==4;

* get new predicted probabilities with new time;
predict pred30;

* change in probabilities;
gen change_p=pred30-pred0;

* get means of change in probs;

sum change_p if mode==1;
sum change_p if mode==2;
sum change_p if mode==3;
sum change_p if mode==4;

* before you forget, change time back to;
* original value;
replace time=time-30 if mode==4;

log close;





