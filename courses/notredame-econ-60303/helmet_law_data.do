/*this program examines the conditional poisson and
conditional negative binomial models compared to
straightforward poisson and neg bin models with
state effect.

the data set is state counts of motor cycle fatalities
for riders aged 16-39 from 1991-2004. there are 14 years 
and 51 states for a total of 714 observations.  the key 
covariate is a dummy that indicates whether a state had 
a motor cycle helmet law.  The only other covariates are
the logged real per capita income and log population*/

* set up capacity constraints;

# delimit;
set more 1;
set memory 20m;
set matsize 100;

* read in data;
use helmet_law_data;

*define log;
log using helmet_law_data.log,replace;

* list variables in the data;
desc;

* get the log per capita income and log population;
gen pci_rl=ln(pci_r);
gen pop1630l=ln(pop1630);

* look at distribution of counts;
tab mc_deaths1630;

* generate year and fips effects;
xi i.year i.fips;

* get local list for right hand side variables;
* xlist1 is for the regular models, xlist2 is for;
* the conditional poisson/negative binomial models;
local xlist1 _If* _Iy* pci_rl pop1630l mc_helmet_law;
local xlist2 _Iy* pci_rl pop1630l mc_helmet_law;


* run a fixed-effect poisson model;
* the conditioning variable is stfip;
* fe is the option for fixed effects;
* can also ask for random effects;
xtpoisson mc_deaths1630 `xlist2', i(fips) fe;

* run a negative binomial fixed effects;
* the conditioning variable is stfip;
xtnbreg mc_deaths1630 `xlist2', i(fips) fe;


* compare to a nbreg model with all the fips;
* effects added.  pick the nbreg model with a ;
* constant dispersion factor.  in this case;
* actively add in fips fips;
nbreg mc_deaths1630 `xlist1', dispersion(constant);

* just for completeness, estimate a poisson ;
* with fips and year effects;
poisson mc_deaths1630 `xlist1';

* on shortcoming of the conditional fixed effects and;
* negative binomial models is they canot exploit;
* correlation in observations within a cluster.  for;
* mle models, within group correlation is estimated using a;
* procedure suggested by liang and zeger;
nbreg mc_deaths1630 `xlist1', dispersion(constant) cluster(fips);


log close;

