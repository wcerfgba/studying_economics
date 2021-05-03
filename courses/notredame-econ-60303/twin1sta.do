# delimit;
set more off;
set memory 20m;


*define log;
log using twin1sta.log,replace;

*read in stata data file;
use twin1sta;


* generate endo RHS variable;
gen second=kids>1;
* generate some race variables;
gen white=race==1;
gen black=race==2;
gen other_race=race==3;
gen agefst1=agefst<=20;
gen agefst2=((agefst>20) & (agefst<=24));
gen agefst3=(agefst>24);
*tab agefst1 agefst1 agefst3;
gen agefst1_t=twin1st*agefst1;
gen agefst2_t=twin1st*agefst2;
gen agefst3_t=twin1st*agefst3;
gen worked1=weeks>0;




* question 1;
tab worked1;
sum weeks;




***********question 2;
* ols estimates of structural model;
reg weeks second;

* components of wald estimate;
* reduced form;
reg weeks twin1st;
* first stage;
reg second twin1st;
* wald estimate;
reg weeks second (twin1st);

**************repeat exercise with worked;
* ols estimates of structural model;
reg worked second;

* components of wald estimate;
* reduced form;
reg worked1 twin1st;
* first stage;
**** same as above;
* wald estimate;
reg worked1 second (twin1st);


************question 3;
* difference in means across those;
* without and without twins;
reg educ twin1st;
reg agefst twin1st;
reg agem twin1st;
reg white twin1st;
reg black twin1st;
reg other_race twin1st;



***********question 4;

* run ols model add in covariates;
reg weeks agefst agem educ other_race black second;
reg worked1 agefst agem educ other_race black second;

* ru 1st stage;
reg second agefst agem educ other_race black twin1st;
test twin1st;

* run 2sls model add in covariates;
reg weeks agefst agem educ other_race black second (agefst agem educ other_race black twin1st); 
reg worked1 agefst agem educ other_race black second (agefst agem educ other_race black twin1st); 


***********question 5;
corr second twin1st;


*************question 6;
* 1st stage with twin x age first interactions;
reg second agefst agem educ other_race black agefst1_t agefst2_t agefst3_t;
test agefst1_t agefst2_t agefst3_t;

* 2sls model;
* run 2sls model that is overidentified;
ivreg2 weeks agefst agem educ other_race black (second=agefst1_t agefst2_t agefst3_t), first; 
ivreg2 worked agefst agem educ other_race black (second=agefst1_t agefst2_t agefst3_t), first; 

* to demonstrate why the test of overid fails, run 2sls models with the instruments one at a time;
reg worked agefst agem educ other_race black second (agefst agem educ other_race black agefst1_t); 
reg worked agefst agem educ other_race black second (agefst agem educ other_race black agefst2_t); 
reg worked agefst agem educ other_race black second (agefst agem educ other_race black agefst3_t); 
log close;



