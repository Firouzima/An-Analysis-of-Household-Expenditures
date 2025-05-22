set more off
clear all
cls

use data1, clear
rename nwsinc_y income

*1)

summarize unitvalue income weight age

*2)

corr unitvalue income weight age

*3)

graph twoway scatter (weight income), msize(0.75pt) xtitle("Income") ytitle("Weight") xlabel(#4, labsize(vsmall)) xscale(titlegap(2)) yscale(titlegap(2)) graphregion(fcolor(white))

*4)

graph twoway scatter (weight unitvalue), msize(0.75pt) xtitle("Unitvalue") ytitle("Weight") xlabel(#4) xscale(titlegap(2)) yscale(titlegap(2)) graphregion(fcolor(white))

*5)

swilk income unitvalue
histogram income, xscale(titlegap(2)) yscale(titlegap(2)) graphregion(fcolor(white)) xlabel(, labsize(vsmall)) xtitle("Income") ylabel(, labsize(vsmall))

histogram unitvalue, xscale(titlegap(2)) yscale(titlegap(2)) graphregion(fcolor(white)) xlabel(, labsize(vsmall)) xtitle("Unitvalue") ylabel(, labsize(vsmall)) bin(70)

*6)

reg weight income unitvalue age female ceduc own child_less_14

*7)

gen ln_income = ln(income)
gen ln_unitvalue = ln(unitvalue)
save data1, replace
reg weight ln_income ln_unitvalue age female ceduc own child_less_14

*8)

estat ovtest

*9)

use "...\University\Metrics I\Project\Data\health"
sort hhid
keep hhid value
egen missing = rowmiss(_all)
drop if missing > 0
drop missing
collapse (sum) value, by(hhid)
rename value sum_of_value
save health1, replace

use data1, clear
sort hhid 
merge 1:m hhid using health1, update
keep if _merge == 3
drop _merge
save data1, replace

gen ln_sum_of_value = ln(sum_of_value)
reg weight ln_income ln_unitvalue ln_sum_of_value age female ceduc own child_less_14

*10)

predict resid, residuals
swilk resid
histogram resid, xscale(titlegap(2)) yscale(titlegap(2)) graphregion(fcolor(white)) xlabel(, labsize(vsmall)) ylabel(, labsize(vsmall))

*11)

predict y_hat, xb

*12)

test child_less_14 ln_sum_of_value
test ln_income own
test ln_income ceduc

*13)

estat imtest
estat hettest

*14)

reg weight ib1.female##i.ceduc



