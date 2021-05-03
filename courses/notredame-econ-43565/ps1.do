* set end of lime as ;
# delimit ;

* turn off pause;
set more off;

* write output to log file;
log using ps1.log, replace;

* read in data;
use nhis_mcod_data;

* answer question 1;
tab diedin5;

* answer question 2;
tab educ diedin5, row column;
tab incomeg diedin5, row column;

* answer question 3;
tab race diedin5, row column;

* answer question 4;
sort educ incomeg;
by educ incomeg: sum diedin5;

* question 5;
xi i.race i.educ i.incomeg ;

reg diedin5 age male married _I*;

gen underweight=bmi<=19;
gen overweight=(bmi>25 & bmi<=30);
gen obese=(bmi>30 & bmi<=35);
gen severeobese=bmi>35;

reg diedin5 age male married _I* 
underweight overweight obese severeobese;

log close;
* see ya