* extract2.sas - follows read2.sas, 2012 march cps, ages 24-64;
options linesize = 130 nocenter;

libname cps '/var/tmp/';
libname here '.';


data here.cps2012;
set cps.extract2012;

if (24<=age<=64);


title1 'ages 24-64 ONLY';

psupwgt=psupwgt/160924;  /*mean of 1 */

if imm=1 then gen2=0;
 else if (momcob>100) or (dadcob>100) then gen2=1;
 else gen2=0;

poor=(povstat=1);

workly=(annhrs>0);

if alloc_v=1 or alloc_e=1 then alloc_ws=1; else alloc_ws=0;

wage=earnhr;

twage=wage;
trim=0;
if wage=. then trim=.;

if wage ne . then do;
 if wage<4 then do;
    trim=1;
    twage=4;
    end;
 else if wage >400 then do;
    trim=2;
    twage=400;
    end;
end;

trimmed=(trim>0);

logwage=log(twage);

female=(sex=2);

exp=age-educ-5;
if exp<0 then exp=0;
exp2=exp*exp;
exp3=exp2*exp;

famearn=famwagesal;


length fedwkr statewkr localwkr selfemp cbsa1-cbsa6 3;

fedwkr=(classly=2);
statewkr=(classly=3);
localwkr=(classly=4);
selfemp=(classly in (5,6));

cbsa1=(cbsa_size=2);
cbsa2=(cbsa_size=3);
cbsa3=(cbsa_size=4);
cbsa4=(cbsa_size=5);
cbsa5=(cbsa_size=6);
cbsa6=(cbsa_size=7);


if hispanic=0 and white=1 then rgroup=1;
else if hispanic=0 and black=1 then rgroup=2;
else if hispanic=0 and asian=1 then rgroup=4;
else if hispanic=1 then rgroup=3;
else rgroup=5;



keep female wagesal annhrs wage twage logwage alloc_ws trim trimmed
    famkind relhead hhdfxm numjobs weeksu
    wage_ogr wkpay earnwk fedwkr statewkr localwkr selfemp collplus maplus phd
    educ higrad age exp exp2 exp3 rgroup imm
    imm gen2 cbsa_size cbsa1-cbsa6
    psupwgt race ethnic weeksly hrswkly classly numjobs
    occ1ly ind1ly mover selfinc farminc health division 
    state workly famearn cbsa_size state hhnum famnum ownkidsu6 ownkidsu18 ogrflag;
	


proc freq;
tables rgroup*female female*famkind*relhead
     female*workly hispanic*imm educ*female classly*female
        numjobs*female occ1ly*female ind1ly*female 
        mover health*female
	ownkidsu6*ownkidsu18 ogrflag;


proc means;
where (female=0);
title2 'men';

proc means;
where (female=0 and famkind=1 and relhead in (1,3) );
title2 'men, in dual-head families, husband of pair';


proc means;
title2 'women';
where (female=1);

proc means;
where (female=1 and famkind=1 and relhead in (1,4) );
title2 'women, in dual-head families, wife of pair';



data husbands;
set here.cps2012 (where=(female=0 and famkind=1 and relhead in (1,3)) ) ;
himm=imm;
hgen2=gen2;
heduc=educ;
htwage=twage;
hannhrs=annhrs;
hfamearn=famearn;
h_age=age;  
hrace=race;
hwagesal=wagesal;
hwage_ogr=wage_ogr;
hselfinc=selfinc;
hfarminc=farminc;
hclassly=classly;
hhealth=health;
hweeksly=weeksly;
hhrswkly=hrswkly;
hogrflag=ogrflag;
hrgroup=rgroup;
keep hhnum famnum heduc htwage hannhrs hfamearn h_age hrace hwagesal hwage_ogr
     hselfinc hfarminc hclassly himm hgen2 hhealth hweeksly hhrswkly hogrflag
     hrgroup state cbsa_size;

proc means;
title2 'husbands' ;

proc freq;
tables hclassly heduc hhealth hogrflag/ missing;



data wives;
set here.cps2012 (where=(female=1 and famkind=1 and relhead in (1,4)) ) ;
wimm=imm;
wgen2=gen2;
weduc=educ;
wtwage=twage;
wannhrs=annhrs;
wfamearn=famearn;
w_age=age;  
wrace=race;
wwagesal=wagesal;
wwage_ogr=wage_ogr;
wselfinc=selfinc;
wfarminc=farminc;
wclassly=classly;
wweeksly=weeksly;
whrswkly=hrswkly;
whealth=health;
wogrflag=ogrflag;
wrgroup=rgroup;
keep hhnum famnum weduc wtwage wannhrs wfamearn w_age wrace wwagesal wwage_ogr
     wselfinc wfarminc wclassly wimm wgen2 wweeksly whrswkly whealth
     ownkidsu6 ownkidsu18 wogrflag wrgroup;

proc means;
title2 'wives' ;

proc freq;
tables wclassly weduc wogrflag / missing;


proc sort data=husbands;
by hhnum famnum;

proc sort data=wives;
by hhnum famnum;

data couples;
merge husbands (in=in1) wives (in=in2);
by hhnum famnum;

if in1 and in2 then mergestat='H and W present';
else if in1 then mergestat='H but no W';
else if in2 then mergestat='W but no H';

wifework=(wweeksly>0);
husbandwork=(hweeksly>0);

age_gap=h_age-w_age;
wagesalgap=hwagesal-wwagesal;
educgap=heduc-weduc;

hlogwage=log(htwage);
wlogwage=log(wtwage);
hexp=h_age-heduc-6;
hexp2=hexp**2/100;
hexp3=hexp**3/1000;

hblack=(hrgroup=2);
wblack=(wrgroup=2);
hhispanic=(hrgroup=3);
whispanic=(wrgroup=3);


proc freq;
title2 'merged H and W';
tables mergestat wogrflag*hogrflag ;



data here.mroz;
set couples;

if wifework=1 or husbandwork=1;
if wwage_ogr>0 or hwage_ogr>0;
if hwagesal ne . ;
if wwagesal ne . ;

wife_wage_ogr=(wwage_ogr>0);
husband_wage_ogr=(hwage_ogr>0);


missing_wwage_ogr=0;

if wifework=1 and wife_wage_ogr=0 then missing_wwage_ogr=1;;

if wwage_ogr>0 then wlogwage_ogr=log(wwage_ogr);

any_under6=(ownkidsu6>0);


title2 'couples, husband or wife working last year and one has wage in OGR ';


proc freq;
tables husbandwork*wifework hrgroup*wrgroup
	wifework*wife_wage_ogr
	whealth*hhealth
	wclassly * hclassly
	wimm*himm
	wgen2 * hgen2
	missing_wwage_ogr*wifework  / missing;

proc means;


proc corr;
var wfamearn hfamearn weduc heduc w_age h_age wannhrs hannhrs ;

proc corr;
var htwage hwage_ogr hwagesal wtwage wwage_ogr wwagesal;

proc corr;
var wlogwage wlogwage_ogr;

proc corr;
var husbandwork wifework weduc heduc w_age h_age ownkidsu6;

proc freq;
tables wclassly*wifework hclassly ownkidsu6*wifework whealth*wifework hhealth*wifework / missing;


proc means;
where (wifework=1);
title3 'working wife';

proc means;
where (wifework=1 and wife_wage_ogr=1);
title3 'working wife but wage in OGR';

proc means;
where (wifework=1 and wife_wage_ogr=0);
title3 'working wife but no wage in OGR';




proc reg;
where (wannhrs>0);
title3 'wife with postive hrs ONLY';
model wannhrs=wlogwage hwagesal ownkidsu6 any_under6 w_age ;

proc reg;
where (wannhrs>0 and wwage_ogr>0);
title3 'wife with postive hrs and wage in OGR ';
model wannhrs=wlogwage hwagesal ownkidsu6 any_under6 w_age ;

proc reg;
where (wannhrs>0);
model wlogwage=wlogwage_ogr hwagesal ownkidsu6 any_under6 w_age;
model  wannhrs=wlogwage_ogr hwagesal ownkidsu6 any_under6 w_age ;

proc syslin 2sls;
where (wannhrs>0);
endogenous wlogwage;
instruments wlogwage_ogr hwagesal ownkidsu6 any_under6 w_age ;
model wannhrs=wlogwage hwagesal ownkidsu6 any_under6 w_age ;



