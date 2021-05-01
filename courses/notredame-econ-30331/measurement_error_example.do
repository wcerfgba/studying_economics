* read in data for cps87
use cps87

* open log file
log using measurement_error_example.log, replace


gen ln_weekly_earn=ln(weekly_earn)


* generate variables for parts b, c, d
gen v2=rnormal(0,1)
gen v3=rnormal(0,2)
gen educ2=years_educ+v2
gen educ3=years_educ+v3

* get means of all three education variables
sum years_educ v2 v3 educ2 educ3

* question 1a
* regression of ln(weekly earn) on educ

reg ln_weekly_earn years_educ

* question 1c
* regression of ln(weekly earn) on educ2
reg ln_weekly_earn educ2


* question 1d
* regression of ln(weekly earn) on educ3
reg ln_weekly_earn educ3

* generate results for part e
gen y2=ln_weekly_earn+v2
gen y3=ln_weekly_earn+v3

* regressions for part e
reg y2 years_educ
reg y3 years_educ

sum ln_weekly_earn y2 y3

log close