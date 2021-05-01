log using ps7_q2.log, replace

use michigan_tax_hike

* generate dummies
gen after=year==3
gen treatment=michigan*after
label var michigan "dummy =1 if michigan, =0 otherwise"
label var after "dummy =1 after tax hike, =0 otherwise"
label var treatment "dummy =1 in michigan after the tax hike, =0 otherwise"

* sort data by michigan and after
sort michigan after

* get means of smoked for 2 x 2 table
by michigan after:  sum smoked


* run the regression
reg smoked michigan after treatment

* check the pre treatment trends
gen after2=year>=2
gen treatment2=after2*michigan
reg smoked michigan after2 treatment2 if year<=2

log close