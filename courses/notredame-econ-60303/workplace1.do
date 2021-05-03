* this data for this program are a random sample;
* of 10k observations from the data used in;
* evans, farrelly and montgomery, aer, 1999;
* the data are indoor workers in the 1991 and 1993;
* national health interview survey.  the survey;
* identifies whether the worker smoked and whether;
* the worker faces a workplace smoking ban;

* set semi colon as the end of line;
# delimit;

* ask it NOT to pause;
set more off;


* open log file;
log using workplace1.log,replace;

* use the workplace data set;
use workplace1;

* print out variable labels;
desc;

* get summary statistics;
sum;


* run a linear probability model for comparison purposes;
* estimate white standard errors to control for heteroskedasticity;
reg smoker age incomel male black hispanic 
hsgrad somecol college worka, robust;

* run probit model;
probit smoker age incomel male black hispanic 
hsgrad somecol college worka;

* ask for marginal effects/treatment effects;
mfx compute;


* the same type of variables can be produced with;
* prchange.  this command is however more flexible;
* in that you can change the reference individual;
prchange, help;

* get marginal effect/treatment effects for specific person;
* male, age 40, college educ, white, without workplace smoking ban;
* if a variable is not specified, its value is assumed to be;
* the sample mean.  in this case, the only variable i am not;
* listing is mean log income;
prchange, x(male=1 age=40 black=0 hispanic=0 hsgrad=0 somecol=0 worka=0); 


* get marginal effects using dprobit;
dprobit smoker age incomel male black hispanic 
hsgrad somecol college worka;


*predict probability of smoking;
predict pred_prob_smoke;
* get detailed descriptive data about predicted prob;
sum pred_prob, detail;

* predict binary outcome with 50% cutoff;
gen pred_smoke1=pred_prob_smoke>=.5;
label variable pred_smoke1 "predicted smoking, 50% cutoff";

* compare actual values;
tab smoker pred_smoke1, row col cell;


* using a wald test, test the null hypothesis that;
* all the education coefficients are zero;
test hsgrad somecol college;


* how to run the same tets with a -2 log like test;

* estimate the unresticted model and save the estimates ;
* in urmodel;
probit smoker age incomel male black hispanic 
hsgrad somecol college worka;
estimates store urmodel;

* estimate the restricted model.  save results in rmodel;
probit smoker age incomel male black hispanic 
worka;
estimates store rmodel;

lrtest urmodel rmodel;


* run logit model;
logit smoker age incomel male black hispanic 
hsgrad somecol college worka;

* ask for marginal effects/treatment effects;
* logit model;
mfx compute;


* run dprobit model;
dprobit smoker worka age incomel male black hispanic 
hsgrad somecol college;

* run probit model;
probit smoker worka age incomel male black hispanic 
hsgrad somecol college;

* this subroutine generates the marginal effects for a probit model;
* the notation follows greene so beta is (k x 1) and xbar is (k x 1);
* so beta1`xbar is a scalar;

probit smoker worka age incomel male black hispanic  hsgrad somecol college;
matrix betat=e(b);    * get beta from probit (1 x k);
matrix beta=betat';
matrix covp=e(V);     * get v/c matric from probit (k x k);


* get means of x -- call it xbar (k x 1);
* must be the same order as in the probit statement;
matrix accum zz = worka age incomel male black hispanic  hsgrad somecol college, means(xbart);
matrix xbar=xbart';                 * transpose beta; 
matrix xbeta=beta'*xbar;            * get xbeta (scalar);
matrix pdf=normalden(xbeta[1,1]);   * evaluate std normal pdf at xbarbeta;
matrix k=rowsof(beta);              * get number of covariates;
matrix Ik=I(k[1,1]);                * construct I(k);
matrix G=Ik-xbeta*beta*xbar';       * construct G;
matrix v_c=(pdf*pdf)*G*covp*G';      * get v-c matrix of marginal effects;
matrix me= beta*pdf;                * get marginal effects;
matrix se_me1=cholesky(diag(vecdiag(v_c)));  * get square root of main diag;
matrix se_me=vecdiag(se_me1)';      *take diagonal values;
matrix z_score=vecdiag(diag(me)*inv(diag(se_me)))';  * get z score;
matrix results=me,se_me,z_score;    *  construct results matrix;
matrix colnames results=marg_eff std_err z_score;     * define column names;
matrix list results;                * list results;


* this is an example of a marginal effect for a dichotomous outcome;
* in this case, set the 1st variable worka as 1 or 0;
matrix x1=xbar;
matrix x1[1,1]=1;
matrix x0=xbar;
matrix x0[1,1]=0;
matrix xbeta1=beta'*x1;
matrix xbeta0=beta'*x0;
matrix prob1=normal(xbeta1[1,1]);
matrix prob0=normal(xbeta0[1,1]);
matrix me_1=prob1-prob0;
matrix pdf1=normalden(xbeta1[1,1]);
matrix pdf0=normalden(xbeta0[1,1]);
matrix G1=pdf1*x1 - pdf0*x0;
matrix v_c1=G1'*covp*G1;
matrix se_me_1=sqrt(v_c1[1,1]);
* marginal effect of workplace bans;
matrix list me_1;
* standard error of workplace a;
matrix list se_me_1;





log close;