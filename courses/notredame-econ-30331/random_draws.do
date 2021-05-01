
* read in stata data set cps87.dta 
use cps87

gen y=ln(weekly_earn)
gen x=years_educ
preserve

forvalues i = 1/20 {
sample 0.1
reg y x
restore
preserve
}