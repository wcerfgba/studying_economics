* this program replicates results from acemoglou and angrist;
* jpe, 2001.  The paper examined the impact of Americans;
* for Disability act on employment and earnings with a simple;
* difference in difference model.  The data in this program;
* are males aged 21-39 from the 1988-1997 March CPS.  The data;
* was downloaded from the IPUMS web page.  This sample is ;
* pretty close in size to the one used by the authors;  

* The March CPS surveys people in year t about work in year t-1;
* Therefore, year is survey year, yearw is work year (year-1);
* the ADA goes into effect in July of 1992 so it is in effect for;
* work year 1992 and on;


# delimit;
set more 1;
set memory 80m;

* increase maximum variables;
set matsize 60;

*define log;
log using ada_jpe.log,replace;

*read in stata data file;
use ada_jpe;

* construct new variables and reduce the sample;

* delete people with business income (self employed);
drop if incbus~=0;
gen yearw=year-1;
gen white=race==100;
gen black=race==200;
gen hispanic=((100<=hispan)&(hispan<500));
gen lths=educrec<6;
gen hsgrad=educrec==7;
gen somecol=educrec==8;
gen disabled=disabwrk==2;
gen ada=yearw>=1992;
gen weekly_earn=incwage/wkswork1;
gen treatment=ada*disabled;
gen disabled_state=100*disabled+statefip;

label var yearw "year of work";
label var white "d.v., =1 if white";
label var black "d.v., =1 if black";
label var hispanic "d.v., =1 if hispanic";
label var lths "d.v., =1 if have less than high school educ";
label var hsgrad "d.v., =1 if high school graduate";
label var somecol "d.v., =1 if have some college";
label var ada "d.v., =1 in 1992 and beyond";
label var disabled "d.v., =1 if have work disability";
label var treatment "d.v., disabled in post ADA period";
label var disabled_state "unique ID for disability status and state";

* get work year and region fixed effects;
xi i.yearw i.region i.age;


* the authors interact the disabled dummy with all year effect;
* and include all interactions in the model.  if the d-in-d;
* assumptions are correct, the interactions prior to 1992 should;
* all be zero;

gen d_y88=_Iyearw_1988*disabled;
gen d_y89=_Iyearw_1989*disabled;
gen d_y90=_Iyearw_1990*disabled;
gen d_y91=_Iyearw_1991*disabled;
gen d_y92=_Iyearw_1992*disabled;
gen d_y93=_Iyearw_1993*disabled;
gen d_y94=_Iyearw_1994*disabled;
gen d_y95=_Iyearw_1995*disabled;
gen d_y96=_Iyearw_1996*disabled;

compress;

* run basic diff-in-diff model, column 2, table 3;
* do not control for covariates;
reg wkswork1 _Iy* disabled d_y*;


* run basic diff-in-diff model, column 2, table 3;
* do not control for covariates;
* have only one treatment variable;
reg wkswork1 _Iy* disabled treatment;

* run basic diff-in-diff model, column 3, table 3;
* control for covariates;
reg wkswork1 _Ia* _Iy* _Ir* white black hispanic lths hsgrad somecol disabled d_y*;


* run basic diff-in-diff model, column 3, table 3;
* control for covariates;
* have only 1 treatment variable;
reg wkswork1 _Ia* _Iy* _Ir* white black hispanic lths hsgrad somecol disabled treatment;

* cluster errors on state;
reg wkswork1 _Ia* _Iy* _Ir* white black hispanic lths hsgrad somecol disabled treatment, 
cluster(statefip);

* cluster errors on the state/disability status;
reg wkswork1 _Ia* _Iy* _Ir* white black hispanic lths hsgrad somecol disabled treatment, 
cluster(disabled_state);


log close;