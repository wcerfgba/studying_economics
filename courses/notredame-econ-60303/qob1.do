* this program replicates some results from;
* angrist and krueger, qje using;
* data set for men, born 1930-39;
* from the 1980 5% PUMS;

# delimit;
set more 1;
* increase maximum variables;
set matsize 200;

* increase memory use to 40meg;
set memory 200m;

log using qob1.log,replace;

*read in sata data file;
use qob1;

* construct qob 1 dummy variables;
gen qob1=qob==1;


* get reduced-forms for wald estimate;
* compare to table III, panel B;
reg educ qob1;
reg earnwkl qob1;

* get wald estimate;
* notice the t-stat on the wald nearly the same;
* as the t-stat on the reduced-form;
ivregress 2sls earnwkl (educ=qob1);

*run ols, one variable;
reg earnwkl educ;


* get correlation coefficient for;
* educ and qob1;
corr educ qob1;


* get dummies needed for the models;
xi i.yob*i.qob; 
compress;

* run ols controlling for yob effects;
* compare to column (1), table V;
reg earnwkl educ _Iyob_*;


* get 2sls controlling for yob effects;
* use xi command to get year effects;
ivregress 2sls earnwkl _Iyob_* (educ=qob1);




* run 2sls, qob times yob interactions as instruments;
* compare to column (2), table V;
ivregress 2sls earnwkl _Iyob_* (educ=_Iqob* _IyobX*);
estat overid;
estat firststage;
* get predicted values;
predict res1, re;

log close;



