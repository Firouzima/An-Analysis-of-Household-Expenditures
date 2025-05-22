log using Projectfall0301440203025, append

set more off
clear all
cls

cd "E:\Laptop 3\Desktop\University\Metrics I\Project"

*Section 1:
*a)

use "1398\record1"

keep female relation hhid married activity leduc age

save rec1, replace

*b)

use rec1, clear
egen misscount = rowmiss(_all)
drop if misscount > 0

*c)

gen ceduc = 0
replace ceduc = 1 if (leduc == 8 | leduc == 7 | leduc == 6 | leduc == 5)

*d)

gen ha_income = 0
replace ha_income = 1 if (activity == 1 | activity == 3) 

*e)

gen mar01 = 0
replace mar01 = 1 if (married == 1)
save rec1, replace

*1)

tabulate female married, row col
tabulate female ha_income, row col
tabulate female ceduc, row col

*2)

tabulate relation female if relation == 3, row col

*3)

tabulate relation female if relation == 1, row col

*4)

tabulate relation ceduc if relation == 1, row col

*5)

tabulate relation ceduc if relation == 1 & female == 1, row col
tabulate relation ceduc if relation == 1 & female == 0, row col

*6)

ttest age if relation == 1, unequal by(female)

*Section 2:

clear all

use "1398\tobacco"
collapse (sum) weight (mean) unitvalue ,by (hhid)
save tobacco1, replace
clear all

use "1398\ws"
keep if indiv == 1
collapse (sum) nwsinc_y, by (hhid)
save ws1, replace
clear all

use "1398\record2"
keep hhid own
save own1, replace
clear all

*a)

use "1398\record1"
gen var1 = (relation==3 & age<14)
bysort hhid: egen child_less_14 = max(var1)
drop var1

*b)

sort hhid
drop if relation != 1
merge 1:1 hhid using tobacco1
drop _merge
sort hhid
merge 1:m hhid using ws1
drop _merge
sort hhid
merge 1:m hhid using own1
keep hhid weight unitvalue age female own leduc child_less_14 nwsinc_y
egen misscount = rowmiss(_all)
drop if misscount > 0
drop misscount

*c)

gen ceduc = 0
replace ceduc = 1 if (leduc == 8 | leduc == 7 | leduc == 6 | leduc == 5)

*d)

gen owndummy = 0
replace owndummy = 1 if (own == 1 | own == 2)

*e)

save data1, replace

log close