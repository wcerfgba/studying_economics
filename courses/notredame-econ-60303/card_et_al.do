* Regression Discontinuity sample;
* This program uses data from the 1998-2001 NHIS;
* that replicates the results in Card, Dobkin and Maestos;
* NBER working paper number 10365.  The authors use data;
* for people aged 55-74 and examine the jump in insurance;
* coverage at age 65 due to Medicare coverage;

* this line defines the semicolon as the line delimiter;
# delimit ;


* there are lots of variables constructed for this program so use lots of memory;
* set memork for 40 meg;
set memory 40m;


* write results to a log file;
log using card_et_al.log,replace;

*read in raw data;
use card_et_al;

* get list of variables;
describe;

* get tables of self reported health status;
tab phstat;

* generate some new variables;
gen good_health=phstat<4;
label var good_health "=1 if report,good,vgood,excel health";

* eligible for Medicare after quarter 259;
gen age65=age_qtr>259;

* scale the age in quarters index so that it equals 0;
* in the month you become eligible for Medicare;
gen index=age_qtr-260;
gen index2=index*index;
gen index3=index*index*index;
gen index4=index2*index2;
gen index_age65=index*age65;
gen index2_age65=index2*age65;
gen index3_age65=index3*age65;
gen index4_age65=index4*age65;


xi i.educ_r1 i.year i.age_qtr;


* 1st stage results. Impact of Medicare on insurance coverage;
* basic results in the paper.  quadratic in age interacted with;
* age65;
reg insured male white black hispanic _Ie* _Iyear* index index2 index_age65 index2_age65 age65, cluster(index);


* estimate same model but do not cluster on index. notice the drop in the std errors on ag65;
reg insured male white black hispanic _Ie* _Iyear* index index2 index_age65 index2_age65 age65;

* run unrestricted model that has dummies for all quarters instead of polynomial;
* use for test in card/lee, equation (3);
reg insured male white black hispanic _Ie* _Iyear* _Iage*;


* Reduced form results.  Impact of Medicare coverage on health outcomes;
* Outcomes are good_health, delayed_med, not_get_med, hosp_12m;
* Note that age65 is small and stat insign in all except the hospitalization equation;
* implying that although Medicare has increased insurance coverage it has not changed outcomes much;

reg good_health male white black hispanic _Ie* _Iyear* index index2 index_age65 index2_age65 age65, cluster(index);
reg delayed_med male white black hispanic _Ie* _Iyear* index index2 index_age65 index2_age65 age65, cluster(index);
reg not_get_med male white black hispanic _Ie* _Iyear* index index2 index_age65 index2_age65 age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index index2 index_age65 index2_age65 age65, cluster(index);


* examine the sensitivity of the results to the order of the polynomial in the index;

* linear index;
reg insured male white black hispanic _Ie* _Iyear* index age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index age65, cluster(index);



* linear index interacted with age65;
reg insured male white black hispanic _Ie* _Iyear* index index_age65 age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index index_age65 age65, cluster(index);

* second order index;
reg insured male white black hispanic _Ie* _Iyear* index index2 age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index index2 age65, cluster(index);


* third order index;
reg insured male white black hispanic _Ie* _Iyear* index index2 index3 age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index index2 index3 age65, cluster(index);


* third order index interacted with age;
reg insured male white black hispanic _Ie* _Iyear* index index2 index3 
index_age65 index2_age65 index3_age65 age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index index2 index3 
index_age65 index2_age65 index3_age65 age65, cluster(index);



* fourth order index;
reg insured male white black hispanic _Ie* _Iyear* index index2 index3 index4 age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index index2 index3 index4 age65, cluster(index);

* fourth order index interacted with age;
reg insured male white black hispanic _Ie* _Iyear* index index2 index3 index4
index_age65 index2_age65 index3_age65 index4_age65 age65, cluster(index);
reg hosp_12m male white black hispanic _Ie* _Iyear* index index2 index3 index4
index_age65 index2_age65 index3_age65 index4_age65 age65, cluster(index);

log close;