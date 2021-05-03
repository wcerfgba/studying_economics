#delimit ;
* read in data for cps87;
use psid1;

* open log file;
*log using ps1_q8.do, replace;


tempfile main bootsave ;
set seed 365476247 ;
global bootreps = 999;

gen wage=laborinc/hours;
gen wagel=log(wage);
* label variables;
label var wagel "log hourly wage rate";
gen tenure2=tenure*tenure;
gen age2=age*age;

*********************************************;
* part a;
*********************************************;
xtset id;
xtreg wagel age age2 tenure tenure2 union, fe;

*********************************************;
* part b;
********************************************;

sort id;
by id: egen wagelm=mean(wagel);
by id: egen unionm=mean(union);
by id: egen agem=mean(age);
by id: egen age2m=mean(age2);
by id: egen tenurem=mean(tenure);
by id: egen tenure2m=mean(tenure2);

gen dwagel=wagel-wagelm;
gen dunion=union-unionm;
gen dage=age-agem;
gen dage2=age2-age2m;
gen dtenure=tenure-tenurem;
gen dtenure2=tenure2-tenure2m;

sum dwagel dage dage2 dtenure dtenure2 dunion;

reg dwagel dage dage2 dtenure dtenure2 dunion, noc;

*********************************************;
* part c;
********************************************;
xtreg wagel union, fe;

*********************************************;
* part d;
********************************************;
gen nochange_union=(unionm==1|unionm==0);
xtreg wagel union if nochange_union==0, fe ;

*********************************************;
* part e;
********************************************;
xtreg wagel age age2 tenure tenure2 union if nochange_union==0, fe;

log close;

