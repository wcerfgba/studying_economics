***wagekids.do, used in dummy variables lecture
***use wage1.dta

gen kids=0
replace kids=1 if numdep>0
sum kids

gen malekids=0
replace malekids=1 if (female==0 & kids==1)
gen malenokids=0
replace malenokids=1 if (female==0 & kids==0)
gen femkids=0
replace femkids=1 if (female==1 & kids==1)
gen femnokids=0
replace femnokids=1 if (female==1 & kids==0)
