*mroz2 - looks at married couples in march 2012 cps;

#delimit ;
set mem 100m;
set more off;

log using mroz2.log, replace;
use mroz;

summ;
tab state;
tab cbsa_size;

corr weduc heduc w_age h_age wtwage htwage;

*from now on drop if wife is under 25 or over 55;
drop if w_age<25;
drop if w_age>55;
table w_age , c (n weduc  mean h_age mean weduc ); 

*some H-W diffs;

tab wifework husbandwork, row col;

gen agegap=h_age-w_age;
gen edgap=heduc-weduc;
gen paygap=hwagesal-wwagesal;
gen wagegap=htwage-wtwage;
gen hrsgap=hannhrs-wannhrs;

sum agegap edgap paygap hrsgap wagegap;
corr agegap edgap paygap hrsgap wagegap;

*age profiles;

table w_age, c( n wifework mean wifework mean wannhrs mean ownkidsu6 
mean ownkidsu18);
table w_age if wifework==1, c( n wifework mean wannhrs mean wtwage mean wlogwage);
 

*some new vars;
gen wcollege=(weduc>=16);
gen hcollege=(heduc>=16);

tab wrgroup hrgroup, row col;
tab wblack hblack , row col;
tab whispanic hhispanic, row col;
tab wcollege hcollege , row col;


gen wexp=w_age-weduc-6;
replace wexp=0 if wexp<0;

gen wexp2=wexp*wexp/100;
gen wexp3=wexp*wexp*wexp/1000;

drop wlogwage_ogr;

replace wwage_ogr=4 if wwage_ogr>0 & wwage_ogr<4;
replace wwage_ogr=400 if wwage_ogr>400;
gen wlogwage_ogr=log(wwage_ogr);


gen work_and_wage=0;
replace work_and_wage=1 if wifework==1 & wife_wage_ogr==1;


sum wwage_ogr wlogwage_ogr wlogwage wannhrs hwagesal wtwage weduc if wifework==1;
sum wwage_ogr wlogwage_ogr wlogwage wannhrs hwagesal wtwage weduc if work_and_wage==1;
sum wwage_ogr wlogwage_ogr wlogwage wannhrs hwagesal wtwage weduc if wifework==1 & wife_wage_ogr==0;


*probit model of work+validOGR wage;


probit work_and_wage weduc wcollege wexp wexp2 wexp3 wblack whispanic wimm
       wgen2 ownkidsu6 any_under6 hwagesal heduc hcollege himm hgen2 h_age;

predict pwork1;
gen lambda1 = normalden(invnormal(pwork1))/pwork1;
sum lambda1 if work_and_wage==0;
sum lambda1 if work_and_wage==1;
corr work_and_wage pwork1 lambda1;


reg wlogwage weduc wcollege wexp wexp2 wexp3 wblack whispanic wimm
    ownkidsu6 any_under6 ;

reg wlogwage weduc wcollege wexp wexp2 wexp3 wblack whispanic wimm
    ownkidsu6 any_under6 if work_and_wage==1;

reg wlogwage weduc wcollege wexp wexp2 wexp3 wblack whispanic wimm
    ownkidsu6 any_under6 lambda1 if work_and_wage==1;

reg wlogwage_ogr weduc wcollege wexp wexp2 wexp3 wblack whispanic wimm
    ownkidsu6 any_under6 if work_and_wage==1;

reg wlogwage_ogr weduc wcollege wexp wexp2 wexp3 wblack whispanic wimm
    ownkidsu6 any_under6 lambda1 if work_and_wage==1;


reg wannhrs wlogwage hwagesal if work_and_wage==1;
reg wannhrs wlogwage hwagesal lambda1 if work_and_wage==1;

reg wannhrs wlogwage_ogr hwagesal if work_and_wage==1;
reg wannhrs wlogwage_ogr hwagesal lambda1 if work_and_wage==1;

reg wannhrs wlogwage_ogr hwagesal weduc if work_and_wage==1;
reg wannhrs wlogwage_ogr hwagesal weduc lambda1 if work_and_wage==1;


