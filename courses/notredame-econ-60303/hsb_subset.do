* this data set contains information for 10 students from;
* each of 489 high schools from the high school and beyond (HS&B);
* data set.  HS&B is a longitudinal data set that follows the high school;
* class of 1982 from their sophmore year in 1980 thorugh early adulthood;
* i have taken data about test scores, the student and the school;
* for this example.  The data set is much larger than I am using for this;
* problem but I have randomly selected just 10 students from each school;
* to construct "balanced" panel;
* outcome variable;
*	soph_scr;
* variables that vary by school:
*	west, south, midwest, cath_sch, urban, rural;
* school id variable;
*	schoolid;
* variable that vary across students;
*	age, female, siblings, black, hispanic, both_parents;
*	parent_ed1-parent_ed4, family_inc1-family_inc6;


# delimit;
set more 1;
set matsize 100;
set memory 40m;

log using hsb_subset.log,replace;

*read in stata data file;
use hsb_subset;

desc;

* run ols model of test score on only school characteristics;
* this is a model similar to the one discussed in Kloeck, econometrica, 1981;
reg soph_scr west south midwest urban rural cath_sch;

* now run a random effects model.  two things to notice.  First, the;
* estimate rho is the fraction of the variance explained in the error;
* explained by the school effects and this is an estimate of the ICC;
* note that rho=0.14 and therefore the OLS variance is overstated by;
* bias=1-rho(m-1) where in this case, m=10 so bias=2.26.  Stdnard errors;
* are biased by sqrt(2.26) or 1.5.  Notice that the standard errors;
* in the are random effect model are all 1.5 times the standard errors;
* in the OLS model;
xtreg soph_scr west south midwest urban rural cath_sch, i(schoolid) re;

* run OLS, Random effect and OLS with clustered standard errors;
* in this case, add in the variables that vary by individual;

*ols;
reg soph_scr age female siblings both_parents parent_ed0-parent_ed3
family_inc0-family_inc6 west south midwest urban rural cath_sch;

*random effects;
xtreg soph_scr age female siblings both_parents parent_ed0-parent_ed3
family_inc0-family_inc6 west south midwest urban rural cath_sch, re i(schoolid);

* ols with standard errros clustered on the school;
reg soph_scr age female siblings both_parents parent_ed0-parent_ed3
family_inc0-family_inc6 west south midwest urban rural cath_sch, cluster(schoolid);


log close;
