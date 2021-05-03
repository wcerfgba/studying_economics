' Loop example for capturing regression coefficients and associated statistics

' We store the results here. 
' 48 horizons. Col 1: point estimate
'	       Col 2: standard error
'	       Col 3: t-ratio
'	       Col 4: R-square 

matrix(48,4) a_regresults   'Creates matrix of zeros

for !h = 1 to 48  ' This is called a loop for horizons !h 1 through 48
   equation eq{!h}.ls(n) q_can(!h)-q_can =c(1) + c(2)*clim_factor
   a_regresults(!h,1) = @coefs(2)
   a_regresults(!h,2) = @stderrs(2)
   a_regresults(!h,3) = @tstats(2)
   a_regresults(!h,4) = @r2
next             ' This closes the loop
