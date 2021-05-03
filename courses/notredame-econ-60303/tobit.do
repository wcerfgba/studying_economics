* this line defines the semicolon as the line delimiter;
# delimit ;

* set memory for 10 meg;
set memory 10m;


* write results to a log file;

log using c:\bill\econ626\stata\tobit.log,replace;

*read in STATA data;
use c:\bill\econ626\stata\tobit;


*describe what is in data set;
desc;


* construct some new variables then label them;
* after you construct new variables, compress the data;
gen age2=age*age;
gen earnwkl=ln(earnwke);
gen union=unionm==1;
gen topcode=earnwke==999;
gen black=race==2;
gen hispanic=race==3;
label var age2 "age squared";
label var earnwkl "log earnings per week";
label var topcode "=1 if earnwkl is topcoded";
label var union "1=in union, 0 otherwise";
label var black "=1 if black, =0 otherwise";
label var hispanic "=1 if hispanic, =0 otherwise";


* get frequencie of topcode;
tabulate topcode;

*run simple regression on topcoded data;
reg earnwkl age age2 educ black hispanic union;

* run tobit model;
* here, ul specifies that the dependent variable is;
* topcoded above (upper censoring);
tobit earnwkl age age2 educ black hispanic union, ul;

* construct quick fix for topcoded wages;
* replace ln(999) with ln(e[y|y>=999]);
* estimate e[y|y>=999] assuming tail of income;
* distribution is pareto. if income above A is;
* pareto and q is the fraction of wages above T;
* then the pareto parameter is ln(q)/(ln(A) - ln(T));
* and e[y|y>=t] = alpha x T/(alpha-1);
* in this case, A=750;

* fraction of people with income>=750 with topcoded;
* wages -- attach mean to all topcoded wages;
egen q=mean(topcode) if earnwke>=750;
gen alpha=ln(q)/(ln(750) - ln(999));
gen ey_y999=999*alpha/(alpha-1);
sum q alpha ey_y999;

gen earnwkl2=earnwkl;
replace earnwkl2=ln(ey_y999) if topcode==1;

* run regression on model with quick fix for top coded wages;
reg earnwkl2 age age2 educ black hispanic union;

* artifically topcode wages at 750;
gen top750=earnwke>=750;
gen earnwkl3=top750*ln(750) + (1-top750)*ln(earnwke);

* run regression on model with artifically topcoded wages;
reg earnwkl3 age age2 educ black hispanic union;

* run tobit model on data artifically topcoded at $750;
tobit earnwkl3 age age2 educ black hispanic union, ul;


* do quick fix.  set A=600, calculate the;
* fraction of people with income>=600 with topcoded;
* wages -- attach mean to all topcoded wages;
egen q1=mean(top750) if earnwke>=600;
gen alpha1=ln(q1)/(ln(600) - ln(750));
gen ey_y750=750*alpha1/(alpha1-1);
sum q1 alpha1 ey_y750;

gen earnwkl4=earnwkl3;
replace earnwkl4=ln(ey_y750) if top750==1;

* run regression on model with quick fix for top coded wages;
reg earnwkl4 age age2 educ black hispanic union;


* close log file;
log close;

