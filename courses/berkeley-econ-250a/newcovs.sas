options ls=130 nocenter nofmterr;

libname here '.';


* set up to put out residual covariances of indicators and single y outcome;
* Plus the var-cov matrix of the residual covariances;

* main output = rescov2.dat ( 36 row vector of residual covariances (LTR format) ;
*               vrescov2.dat = 36*36 matrix output in vec format (1 column) ; 



data one;
set here.newwagedata;


*** next 2 lines change for males n=22124;

%let n=22124;


array cexp (*) exp1-exp8;
array cexpsq (*) expsq1-expsq8;
array cexpcu (*) expcu1-expcu8;


do i=1 to 8;
cexpsq(i)=cexp(i)**2;
cexpcu(i)=cexp(i)**3;
end;

proc means;
var w1-w9 exp1-exp8 expsq1-expsq8 expcu1-expcu8 meaneduc ;

*step 1 = get residuals from indicators and y var (last in list);



proc reg;
model w1=meaneduc exp1 expsq1 expcu1 ;
output out=new
 r=r1;

proc reg;
model w2=meaneduc exp2 expsq2 expcu2 ;
output out=new
 r=r2;

proc reg;
model w3=meaneduc exp3 expsq3 expcu3 ;
output out=new
 r=r3;

proc reg;
model w4=meaneduc exp4 expsq4 expcu4 ;
output out=new
 r=r4;

proc reg;
model w5=meaneduc exp5 expsq5 expcu5 ;
output out=new
 r=r5;

proc reg;
model w6=meaneduc exp6 expsq6 expcu6 ;
output out=new
 r=r6;

proc reg;
model w7=meaneduc exp7 expsq7 expcu7 ;
output out=new
 r=r7;

proc reg;
model w8=meaneduc exp8 expsq8 expcu8 ;
output out=new
 r=r8;


proc corr cov;
var r1-r8;

*step 2: construct m = ltr format  residual covariance elements;

data covs;
set new (keep=r1-r8);
array res (*) r1-r8;
array m (*) m1-m36;

index=1;
do j=1 to 8;
do k=1 to j;
 m(index)=res(k)*res(j);
 index=index+1;
end;
end;

proc means n mean stderr;
var m1-m36;
output out=m2
mean=;

data m2b;
set m2;
keep m1-m36;

proc transpose data=m2b out=m2t;
proc print data=m2t;
var col1;  /*this is now a row vector of the LTR mean residual covariances*/


*step 3: construct outer product  Sum { m(i) m(i)'} / N  = var-cov of m;



proc corr cov nocorr nosimple data=covs outp=m4;
var m1-m36;

data m4b;
set m4;
if _type_="COV";
id=_n_;
keep id m1-m36;

data check;
set m4b;
array m (*) m1-m36;

se=sqrt( m(id)/&n. );
keep id  se;

*check of calculations - note df = N;
proc print data=check; 


*step 4: output the res-covs and their var-cov matrix;

data o1;
set m2t;
file '~/rescov2.dat';
put col1 12.9;

data o2;
set m4b;
file '~/vrescov2.dat';
array m (*) m1-m36;
do j=1 to 36;
 y=m(j)/&n. ;
 put y 12.9;
end;


