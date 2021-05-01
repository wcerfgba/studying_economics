* read in data for 
use twin1st

* open log file
log using twin1st.log, replace

* generate variables
gen second=kids>1
gen black=race==2
gen other_race=race==3




************* part a
sum worked weeks
sum lincome, detail


************* part b
* run OLS of weeks on second
reg weeks second


************ part c
* run the first stage, does having
* a twin (z) increase the kids in the home (x)?
reg second twin1st

* run the reduced form, impact of twins (z)
* on weeks worked (y)
reg weeks twin1st


* run the 2sls model (Wald estimate)
* ivregress 2sls y (x=z)
ivregress 2sls weeks (second=twin1st)


************* part e
* run OLS of weeks worked model with other covariates
reg weeks second agem agefst black other_race educm married


************* part f
* run the 2sls with additional covariates in the model
ivregress 2sls weeks agem agefst black other_race educm married (second=twin1st)
log close