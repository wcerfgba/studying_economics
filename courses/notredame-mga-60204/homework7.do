** Homework Chapter 7

use "gpa2.dta", clear

gen femath=female*athlete
gen male=0
replace male=1 if female==0
gen maleath=male*athlete
gen noath=0
replace noath=1 if athlete==0
gen malenoath=male*noath

** iv) 

reg colgpa hsize hsizesq hsperc sat femath maleath malenoath
reg colgpa hsize hsizesq hsperc sat male athlete maleath

** v)
gen femsat=female*sat
reg colgpa hsize hsizesq hsperc athlete sat female femsat

