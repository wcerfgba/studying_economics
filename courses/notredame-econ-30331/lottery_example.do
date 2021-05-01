set more off

* print out results to a log file
log using lottery_example.log, replace

* read in data
use lottery_example

* describe data
desc

* construct new variables
gen k12_earmark_pupil=k12_share*lottery_profit_pupil
gen not_earmark_pupil=(1-k12_share)*lottery_profit_pupil

* run unrestricted model
reg exp_pupil inc_pupil k12_earmark_pupil not_earmark_pupil time

* test for question b using f-test
test k12_earmark_pupil=1

* test for question c
test k12_earmark_pupil=inc_pupil

* test for question d
test k12_earmark_pupil=not_earmark_pupil

log close
* see ya
