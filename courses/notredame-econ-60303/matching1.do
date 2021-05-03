* this data for this program are a random sample;
* of 10k observations from the data used in;
* evans, farrelly and montgomery, aer, 1999;
* the data are indoor workers in the 1991 and 1993;
* national health interview survey.  the survey;
* identifies whether the worker smoked and whether;
* the worker faces a workplace smoking ban;

* set semi colon as the end of line;
# delimit;

* ask it NOT to pause;
set more off;


* open log file;
log using matching1.log,replace;

* use the workplace data set;
use workplace1;

* print out variable labels;
desc;

* get summary statistics;
sum;


* run the propensity score;
probit worka age incomel male black hispanic hsgrad somecol college;
predict pscore, pr;

* trim the sample to have common support;
* the span of the propensity scores is the same for;
* treatment=1 and treatment=0;
gen ps_y1=pscore;
replace ps_y1=. if worka==0;
gen ps_y0=pscore;
replace ps_y0=. if worka==1;

egen ps1max=max(ps_y1);
egen ps1min=min(ps_y1);
egen ps0max=max(ps_y0);
egen ps0min=min(ps_y0);
drop if pscore<max(ps1min,ps0min);
drop if pscore>min(ps1max,ps0max);


* generate weights;
* ipw1 is the original weight;
gen ipw1=1;
replace ipw1=(1-worka)*pscore/(1-pscore) if worka==0;

* now construct ipw2 -- re-weight so that the;
* new weights sum to the number of observations;
* in the comparison sample;
egen ipw1s=sum(ipw1) if worka==0;
egen nobs_y0=sum(1-worka) if worka==0;
gen ipw2=ipw1;
replace ipw2=nobs_y0*ipw1/ipw1s if worka==0;
sort worka;
by worka: sum ipw1 ipw2;

*  check whether covariates are balanced;
* use ipw2 as the weight
by worka: sum age incomel male black hispanic hsgrad somecol college [aw=ipw];
reg age worka [aw=ipw2], robust;
reg incomel worka [aw=ipw2], robust;
reg male worka [aw=ipw2], robust;
reg black worka [aw=ipw2], robust;
reg hispanic worka [aw=ipw2], robust;
reg hsgrad worka [aw=ipw2], robust;
reg somecol worka [aw=ipw2], robust;
reg college worka [aw=ipw2], robust;

* run propensity score by ipw1, ask for robust std errors;
reg smoker worka [aw=ipw1], robust;

* run propensity score by ipw1, ask for robust std errors;
reg smoker worka [aw=ipw2], robust;

* just for fun, compare to the OLS estimates;
reg smoker worka  age incomel male black hispanic hsgrad somecol college, robust;

log close;