#delimit ;
* read in data for cps87;
use twin1sta;

* open log file;
*log using q1_ps5.lo, replace;


tempfile main bootsave ;
set seed 365476247 ;
global bootreps = 1000;

gen second=kids>1;
gen black=race==2;
gen otherrace=race==3;
* label variables;
label var second "mom has second kid";
label var black "mom is black";
label var otherrace "mom is other race";

* output the t-statistics for real_tax to a file;
postfile bskeep ftest5 ftest10 ftest30 ftest10a biv5 biv10 biv30 biv10a
using twin1st_random_instruments, replace;

sum weeks second agem agefst educm black otherrace twin1st;


* ols of weeks equation;
reg weeks second agem agefst educm black otherrace;
* 2sls of weeks equation using twins as the instrument;
reg weeks second agem agefst educm black otherrace (mysteryz agem agefst educm black otherrace);


qui save `main' , replace ;

* iterate over the bootstrap replications;
forvalues b = 1/$bootreps { ;
use `main', replace ;

qui gen z1=invnorm(uniform());
qui gen z2=invnorm(uniform());
qui gen z3=invnorm(uniform());
qui gen z4=invnorm(uniform());
qui gen z5=invnorm(uniform());
qui gen z6=invnorm(uniform());
qui gen z7=invnorm(uniform());
qui gen z8=invnorm(uniform());
qui gen z9=invnorm(uniform());
qui gen z10=invnorm(uniform());
qui gen z11=invnorm(uniform());
qui gen z12=invnorm(uniform());
qui gen z13=invnorm(uniform());
qui gen z14=invnorm(uniform());
qui gen z15=invnorm(uniform());
qui gen z16=invnorm(uniform());
qui gen z17=invnorm(uniform());
qui gen z18=invnorm(uniform());
qui gen z19=invnorm(uniform());
qui gen z20=invnorm(uniform());
qui gen z21=invnorm(uniform());
qui gen z22=invnorm(uniform());
qui gen z23=invnorm(uniform());
qui gen z24=invnorm(uniform());
qui gen z25=invnorm(uniform());
qui gen z26=invnorm(uniform());
qui gen z27=invnorm(uniform());
qui gen z28=invnorm(uniform());
qui gen z29=invnorm(uniform());
qui gen z30=invnorm(uniform());

qui reg second agem agefst educm black otherrace mysteryz z1 z2 z3 z4 z5;
qui test mysteryz z1 z2 z3 z4 z5;
local ftest5=r(F);

qui reg second agem agefst educm black otherrace mysteryz z1 z2 z3 z4 z5 z6 z7 z8 z9 z10;
qui test mysteryz  z1 z2 z3 z4 z5 z6 z7 z8 z9 z10;
local ftest10=r(F);

qui reg second agem agefst educm black otherrace mysteryz z1 z2 z3 z4 z5 z6 z7 z8 z9 z10
z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 z26 z27 z28 z29 z30;
qui test mysteryz z1 z2 z3 z4 z5 z6 z7 z8 z9 z10
z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 z26 z27 z28 z29 z30;
local ftest30=r(F);

qui reg second agem agefst educm black otherrace mysteryz z1 z2 z3 z4 z5 z6 z7 z8 z9 z10
z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 z26 z27 z28 z29 z30;
qui test mysteryz z1 z2 z3 z4 z5 z6 z7 z8 z9 z10
z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 z26 z27 z28 z29 z30;
local ftest30=r(F);

qui reg second agem agefst educm black otherrace z1 z2 z3 z4 z5 z6 z7 z8 z9 z10;
qui test z1 z2 z3 z4 z5 z6 z7 z8 z9 z10;
local ftest10a=r(F);

qui reg weeks second agem agefst educm black otherrace (agem agefst educm black otherrace mysteryz z1 z2 z3 z4 z5);
local bols_5=_b[second];

qui reg weeks second agem agefst educm black otherrace (agem agefst educm black otherrace mysteryz z1 z2 z3 z4 z5
z6 z7 z8 z9 z10);
local bols_10=_b[second];


qui reg weeks second agem agefst educm black otherrace (agem agefst educm black otherrace mysteryz z1 z2 z3 z4 z5
z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 z26 z27 z28 z29 z30);
local bols_30=_b[second];

qui reg weeks second agem agefst educm black otherrace (agem agefst educm black otherrace z1 z2 z3 z4 z5
z6 z7 z8 z9 z10);
local bols_10a=_b[second];

post bskeep (`ftest5') (`ftest10') (`ftest30') (`ftest10a') 
            (`bols_5') (`bols_10') (`bols_30') (`bols_10a');

};

postclose bskeep ;
clear;

use twin1st_random_instruments;
sum;
