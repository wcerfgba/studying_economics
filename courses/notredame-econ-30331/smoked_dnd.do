log using ps7_q3.log, replace

use state_cig_data


* generate real taxes
gen real_tax=(state_tax+federal_tax)/cpi

label var real_tax "state+federal real tax on cigs, cents/pack"


* construct new variables
* real per capita income
gen rpcil=ln(pci/cpi)
label var rpcil "ln of real per capita income"

* real per capita consumption
gen packs_pc_l=ln(packs_pc)

xi i.state i.year 

* run regression with tax, real income
reg packs_pc_l rpcil real_tax

* add state effects
reg packs_pc_l rpcil real_tax _Is*

* add year effects
reg packs_pc_l rpcil real_tax _Is* _Iy*

log close