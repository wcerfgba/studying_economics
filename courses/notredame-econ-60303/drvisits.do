* drvisits.do;
* this program estimates a poisson and negative binomial;
* count data model.  teh data inclused people aged 65+;
* from the 1987 nmes data set.  dr visits are annual;

* this line defines the semicolon as the line delimiter;
# delimit ;

* set memork for 10 meg;
set memory 10m;

* open output file;
log using c:\bill\jpsm\drvisits.log,replace;

* open stata data set;
use c:\bill\jpsm\drvisits;

* generate new variables;
gen incomel=ln(income);

* get distribution of dr visits;
tabulate drvisits;

* get descriptive statistics;
sum;


* run poisson regression;
poisson drvisits age65 age70 age75 age80 chronic excel good fair female
black hispanic hs_drop hs_grad mcaid incomel;


* run neg binomial regression;
nbreg drvisits age65 age70 age75 age80 chronic excel good fair female
black hispanic hs_drop hs_grad mcaid incomel, dispersion(constant);

log close;



