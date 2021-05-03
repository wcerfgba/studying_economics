

* set end of line marker;
# delimit;
set more off;

* increase memory;
set memory 20m;

* write results to file;
log using c:\bill\jpsm\nlms_data.log,replace;

* load up sas data set;
use c:\bill\jpsm\nlms_data;

* get contents of data file;
desc;

* get summary statistics;
sum;

* define the duration data in the analysis;
stset followh, failure(deathh) id(hhid);

* graph the kaplan-meier functions;
* output the graphs to a file;
sts  graph;
graph save c:\bill\jpsm\nlms_graph1.gph, replace;


* graph the hazards;
sts  graph, hazard;
graph save c:\bill\jpsm\nlms_graph2.gph, replace;


* you can draw graphs for various subgroups;
* output the graphs to a file;
sts  graph, by(educ);
graph save c:\bill\jpsm\nlms_graph3.gph, replace;


* graph the hazards;
* output the graphs to a file;
sts  graph, hazard by(educ);
graph save c:\bill\jpsm\nlms_graph4.gph, replace;


* run a duration model where the hazard varies across;
* people.  first, ask stata to print out the raw;
* coefficients (nohr option), then do default;
* show weibull first, then exponential;

* first, construct dummies for the income and;
* education categories.  in the regression statement;
* _Ie star include all variables beginning with _Ie;
* and _Ii star includes all variables starting with;
* _Ii;

xi i.income i.educ;

streg age raceh1 raceh2 _Ie* _Ii*, d(weibull) nohr; 

* now get the hazard ratios where all coefs are raised to;
* exp(b1);

streg age raceh1 raceh2 _Ie* _Ii*, d(weibull); 


* for compairson purposes, look at results from an exponential;
streg age raceh1 raceh2 _Ie* _Ii*, d(exp) nohr; 
streg age raceh1 raceh2 _Ie* _Ii*, d(exp);


* estimate cox proportional hazards model;
stcox age raceh1 raceh2 _Ie* _Ii*;

stsplit bereavement, after(time=followw) at(0);
recode bereavement -1=0 0=1;

stcox age raceh1 raceh2 _Ie* _Ii* bereavement;

log close;

log close; 


