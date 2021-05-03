* set the memory to 2 meg
set memory 2m


* write results to a log file

log using boostrap_example.log,replace

* read in raw data from comma delimited data
use cps87

* describe what is in the data set
describe

* generate new variab;es
gen age2=age*age
gen ln_weekly_earn=ln(weekly_earn)
gen union=union_status==1
gen nonwhite=race>1

label var age2 "age squared"
label var ln_weekly_earn "log earnings per week"
label var union "1=in union, 0 otherwise"
label var nonwhite "=1 if nonwhite, =0 otherwise"



*run simple regression
reg ln_weekly_earn age age2 years_educ nonwhite union

* now boostrap the data.  takes N obs with replacement
* save results in stata file bs-results.dta

bootstrap, saving(bs-results.dta, replace) rep(999) : regress ln_weekly_earn age age2 years_educ union
log close