* open log file
log using aps3_q3.log, replace

* open stata data set
use law_school_1985

* generate necessary variables
gen lcost=ln(cost)
gen lsalary=ln(salary)

* run basic regression
reg lsalary lcost lsat rank age

* output residuals
predict res1, residual

* output predicted y
predict pred, xb

* generate correlation coefficient variables
corr res1 lsat lcost

* corr coef between pred y and actual y
corr lsalary pred

* run model deleting lsat from basic model
reg lsalary lcost lsat age

* get correlation coefficient between lsat/rank
corr lsat rank

log close
* see ya