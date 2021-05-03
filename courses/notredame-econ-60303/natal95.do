* this data set is a small .005 % random sample;
* of observations from the 1995 natality detail;
* data.  we will examine the impack of smoking:
* on birth weight. two large states, NY and CA, do not;
* record mothers smoking status.  therefore, of the ;
* 4 million births in the US, only 3 million have all;
* the necessary data so there should be 3 million*.005;
* or roughly 15,000 obs;  

* set semi colon as the end of line;
# delimit;

* ask it NOT to pause;
set more off;


* open log file;
log using c:\bill\jpsm\natal95.log,replace;

* use the natality detail data set;
use c:\bill\jpsm\natal95;

* print out variable labels;
desc;

* construct indicator for low birth weight;
gen lowbw=birthw<=2500;
label variable lowbw "dummy variable, =1 ifBW<2500 grams";

* get frequencies;
tab lowbw smoked, col row cell;

* run a logit model;
xi: logit lowbw smoked age married i.educ5 i.race4;

* get marginal effects;
mfx compute;

* run a logit but report the odds ratios instead;
xi: logistic lowbw smoked age married i.educ5 i.race4;
log close;