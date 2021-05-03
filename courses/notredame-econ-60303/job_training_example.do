
* this example is attributed to jeff smith from;
* the economics department at michigan. the data;
* set contains a sample of 1500 females who;
* participated in the job training partnership act program;
* each respondent could have received one of 4 job training;
* services.  1=classroom training.  2=on the job training;
* 3= job search assistance, 4=other;
 


* set end of line marker;
# delimit;
set more off;

* increase memory;
set memory 20m;

* write results to file;
log using c:\bill\jpsm\job_training_example.log,replace;

* load up sas data set;
use c:\bill\jpsm\job_training_example;

* get contents of data file;
desc;

* get summary statistics;
sum;

* get frequency of choice variable;

tab choice;

* run multinomial logit.  omitted groups are;
* whites, those with > 12 years of ed, those w/ work experience;
* base(#) tells STATA what category should be the reference option;
* base(4) is using other as the reference group;
 
mlogit choice age black hisp nvrwrk lths hsgrad, base(4);


* get marginal effects for the 4 options, on the job training;
mfx compute, predict(outcome(1));
mfx compute, predict(outcome(2));
mfx compute, predict(outcome(3));
mfx compute, predict(outcome(4));


* test for IIA using the Hausam test;
* the program eliminates one choice at ;
* a time then compares the unrestricted;
* estimates to the restricted ones;
mlogtest, hausman;
log close;