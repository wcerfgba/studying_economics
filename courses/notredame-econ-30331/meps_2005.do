* open log file
log using meps_2005.log, replace

* open data set
use meps_2005

* generate race dummy variables
gen white=race==1
gen black=race==2
gen other_race=race==3

* generate srhs variables
gen vgood=srhealth==2
gen good=srhealth==3
gen fair=srhealth==4
gen poor=srhealth==5

* generate region dummies
gen midwest=region==2
gen south=region==3
gen west=region==4

* gen ln(income)
gen ln_income=ln(income)

* generate ln expenditures
gen ln_totalexp=ln(totalexp)

* run basic regression with 15 covariates + intercept
reg ln_totalexp age educ ln_income bmi male vgood good fair poor white black other_race midwest south west

* test the hypothesis that the region effects are all zero
test midwest south west

log close






