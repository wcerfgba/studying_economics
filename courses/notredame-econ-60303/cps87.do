* set the memory to 2 meg
set memory 2m

* set it such that the computer does not
* need the operator to hit the return key
* to continue
set more off

* write results to a log file

log using cps87.log,replace

* read in raw data from comma delimited data
insheet using cps87.csv, comma

* label the variables
label var age "age in years"
label var race "=1 if white non-Hisp, =2 if black non-Hisp, =3 if Hispanic"
label var years_educ "years of competed education"
label var union_status "=1 if in union, =2 otherwise"
label var smsa_size "=1 if largest 19 smsa, =2 if other smsa, =3 not in smsa"
label var region "=1 if northeast, =2 if midwest, =3 if south, =4 if west"
label var weekly_earn "usual weekly earnings, up to $999"
* describe what is in the data set
describe


* generate new variables
* lines 1-2 illustrate basic math functoins
* line 3 line illustrates a logical operator
* line 4 illustrate the OR statement
* line 5 illustrates the AND statement

gen age2=age*age
gen ln_weekly_earn=ln(weekly_earn)
gen union=union_status==1
gen nonwhite=((race==2)|(race==3))
gen big_ne=((region==1)&(smsa==1))

label var age2 "age squared"
label var ln_weekly_earn "log earnings per week"
label var union "1=in union, 0 otherwise"
label var nonwhite "1=nonwhite, 0=white" 
label var big_ne "1= live in big smsa from northeast, 0=otherwsie"

* get descriptive statistics for all variables
sum

* get statistics for only a subset of variables
sum age years_educ

* get detailed descriptics for a subset of variables
sum weekly_earn age, detail

* to get means across different subgroups in the
* sample, first sort the data, then generate
* summary statistics by subgroup

sort race
by race: sum weekly_earn

* get weekly earnings for only those with a 
* high school education
sum weekly_earn if years_educ>=12

* get frequencies of discrete variables
tabulate race

* get two-way table of frequencies
tabulate region smsa, row column

* test whether means are the same across two subsamples
ttest weekly_earn, by(union)

*run simple regression
reg ln_weekly_earn age age2 years_educ nonwhite union

* run regression adding smsa, region and race fixed-effects
xi: reg ln_weekly_earn age age2 years_educ union i.race i.region i.smsa

* close log file
log close
* see ya