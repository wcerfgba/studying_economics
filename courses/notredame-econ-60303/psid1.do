* this line defines the semicolon as the line delimiter;
# delimit ;

* set memork for 10 meg;
set memory 10m;

log using psid1.log, replace;

*read in state data;
use psid1;

* generate new variables;
gen exp=age-educ-5;
gen exp2=exp*exp;
gen wage=laborinc/hours;
gen wagel=log(wage);
gen tenure2=tenure*tenure;
* label variables;
label var exp "potential experience";
label var exp2 "experience squared";
label var wage "hourly wage rate (earn/hours)";
label var wagel "log hourly wage rate";
label var tenure2 "tenure squared";

* get descriptive statistics;
sum;

* get OLS estimates;
reg wagel exp exp2 tenure tenure2 union educ black;

* define the dimensions of the effects;
iis id;

* get fixed-effect estimate by absorbing data by id;
* treats data as deviations from means to reduce number;
* of parameters to be estimated;
areg wagel exp exp2 tenure tenure2 union, absorb(id);

* get the same fixed-effect estimates by using xtreg;
xtreg wagel exp exp2 tenure tenure2 union black educ, fe;

* store thefixed-effect estimates;
estimates store fixed;


* get the random effects estimator;
xtreg wagel exp exp2 tenure tenure2 union black educ, re;

* get hausman test statistic;
hausman fixed .;

* for completeness, get between group estimates;
xtreg wagel exp exp2 tenure tenure2 union black educ, be;

