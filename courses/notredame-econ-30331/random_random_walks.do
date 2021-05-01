clear
********************************************
* this next line is the only line you should alter
* in this program
********************************************
set seed 2222             
* set the random number seed to the last 4 digits of your SSN


* this program generates k random walks of 500 observations
* the model is yj(t)=yj(t-1)+ej(t) for j=1 to 5. The program draws a series
* of random shocks from a standard normal distribution then
* sums the shocks.  yj(1)=ej(1), yj(2)=yj(1)+ej(2), y(3)=y(2)+e(3), etc
* the output is a stata data set with five series (y1-y5) and a time index
* t in the data file random_series.  You should load up that file
* to answer the rest of the problem
         

* set space bar pause off 
set more off              

* the data set will have 500 observations 
global n=500
set obs $n

* the time series is defined by the observation count 
gen t=_n                  

* set the number of variables as a global variable 
global k=5                
                          
* do loop to generate k variables called e1, e2, ...ek 
forvalues i=1/$k {        

* draw the random error from a standard normal error 
gen e`i'=rnormal(0,1)     
}  

 * in this do loop, we gen(erate) k new variables
forvalues i=1/$k { 	  

* y1 y2 ... yk.  next, we set the 1st observation  
gen y`i'=.                

* in the series equal to the error from that series 
replace y`i'=e`i' in 1    
}                         


* loop over k variable and n observations. for each
forvalues i=1/$k {      
* y we add the error for this observation and the previous sum    
forvalues j=2/$n {     
* lag of y 
quietly replace y`i'=e`i'+y`i'[`j'-1] in `j'    
} 
} 
keep t y1-y5
desc
sum
save random_series, replace 
