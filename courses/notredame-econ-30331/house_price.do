* open log file
log using aps3_q4.log, replace

* open stata data set
use house_price

* run model 1
reg price bedrooms bathrooms otherrooms age

* run model 2
reg price bedrooms bathrooms otherrooms age sq_feet

* run model 3
reg price age sq_feet

corr sq_feet bedrooms bathrooms otherrooms 

log close
* see ya