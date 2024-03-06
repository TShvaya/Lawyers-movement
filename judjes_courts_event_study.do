//Data preparation - merging courts data with treatment, generating main treatment variables.

use "$data\data_courts.dta", replace

rename Dist_name district_a

drop if district_a == ""

merge m:m district_a using "$data\01_data.dta"

	foreach x in num_visits_cj num_visits_cj_before_el num_visits_ali num_visits_ali_before_el num_visits_itzaz num_visits_itzaz_before_el{
	replace `x'=0 if `x'>99999
	}

	
	//Create new variables that sum up the number of visits made by any of the three lawyers (cj, ali, and itzaz).
	gen num_visits_any=num_visits_cj+num_visits_ali+num_visits_itzaz
	gen num_visits_any_before_el=num_visits_cj_before_el+num_visits_ali_before_el+num_visits_itzaz_before_el


	// Create new variables indicating if the number of visits is greater than 0
	foreach x in cj ali itzaz any{
		gen treat_group_`x'=(num_visits_`x'!=0)
		gen treat_group_before_el_`x'=(num_visits_`x'_before_el!=0)
		gen treat_fact_`x'=(num_visits_`x'_before_el>0 & Year>=2008)
		gen treat_fact_at_all_`x'=(num_visits_`x'_before_el>0)
	}

	//Create new variables which identify the incidental/planned status of the visits
	foreach x in cj ali itzaz{
	replace inc_sample_`x'=1 if inc_sample_`x'>99999
	}
	gen inc_sample_any=(inc_sample_cj==1&inc_sample_ali==1&inc_sample_itzaz==1)
	
global controls

//Clustering and FEs are based on districts (not electoral!).
egen District = group(district_a)

//Generation of dummy for planned visits.
gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

eststo clear
estimates clear

//event-study
tab Year, gen(d_)

forval i=1/17 {
	gen inter_`i'X = d_`i'*treat_group_cj
}

#d ;
global eventstudy "inter_1X inter_3X inter_4X inter_5X inter_6X inter_7X inter_8X
inter_9X inter_10X inter_11X inter_12X inter_13X inter_14X inter_15X inter_16X inter_17X inter_2X";
#d cr

preserve

estimates clear
reghdfe Institution_total $eventstudy, a(i.Year i.District) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest_judjes.dta", replace)

*graph1

use "Parmest_judjes.dta", clear 

replace parm = "inter_2X" if parm == "o.inter_2X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "2006" 1 "2007" 2 "2008" 3 "2009" 4 "2010"  5 "2011"  6 "2012"  7 "2013"  8 "2014"  9 "2015"  10 "2016"  11 "2017"  12 "2018"  13 "2019"  14 "2020"  15 "2021"  16 "2022"
replace time = time - 1
label val time years

capture graph drop graph1j

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 16, msize(zero) color(black)), xlabel(0(2)16, val) graphr(c(white)) ytitle("") title("Panel : Institution_total on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph1j")

graph save "graph1j.gph", replace

restore

estimates clear
reghdfe Disposal_total $eventstudy, a(i.Year i.District) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest_judjes2.dta", replace)


*graph1

use "Parmest_judjes2.dta", clear 

replace parm = "inter_2X" if parm == "o.inter_2X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "2006" 1 "2007" 2 "2008" 3 "2009" 4 "2010"  5 "2011"  6 "2012"  7 "2013"  8 "2014"  9 "2015"  10 "2016"  11 "2017"  12 "2018"  13 "2019"  14 "2020"  15 "2021"  16 "2022"
replace time = time - 1
label val time years

capture graph drop graph2j

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 16, msize(zero) color(black)), xlabel(0(2)16, val) graphr(c(white)) ytitle("") title("Panel : Disposal_total on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph2j")

graph save "graph2j.gph", replace



//Event-study for judjes
use "$data\data_judjes.dta", replace

rename district_name district_a

drop if district_a == ""

merge m:m district_a using "$data\01_data.dta"

	foreach x in num_visits_cj num_visits_cj_before_el num_visits_ali num_visits_ali_before_el num_visits_itzaz num_visits_itzaz_before_el{
	replace `x'=0 if `x'>99999
	}

	
	//Create new variables that sum up the number of visits made by any of the three lawyers (cj, ali, and itzaz).
	gen num_visits_any=num_visits_cj+num_visits_ali+num_visits_itzaz
	gen num_visits_any_before_el=num_visits_cj_before_el+num_visits_ali_before_el+num_visits_itzaz_before_el


	// Create new variables indicating if the number of visits is greater than 0
	foreach x in cj ali itzaz any{
		gen treat_group_`x'=(num_visits_`x'!=0)
		gen treat_group_before_el_`x'=(num_visits_`x'_before_el!=0)
		gen treat_fact_`x'=(num_visits_`x'_before_el>0 & Year>=2008)
		gen treat_fact_at_all_`x'=(num_visits_`x'_before_el>0)
	}

	//Create new variables which identify the incidental/planned status of the visits
	foreach x in cj ali itzaz{
	replace inc_sample_`x'=1 if inc_sample_`x'>99999
	}
	gen inc_sample_any=(inc_sample_cj==1&inc_sample_ali==1&inc_sample_itzaz==1)
	

preserve

egen District = group(district_a)

gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

eststo clear
estimates clear


tab Year, gen(d_)

forval i=1/14 {
	gen inter_`i'X = d_`i'*treat_group_cj
}

#d ;
global eventstudy "inter_2X inter_3X inter_4X inter_5X inter_6X inter_7X inter_8X
inter_9X inter_10X inter_11X inter_12X inter_13X inter_14X inter_1X";
#d cr


estimates clear
reghdfe judges_working $eventstudy, a(i.Year i.District) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest_judjes3.dta", replace)



*graph1

use "Parmest_judjes3.dta", clear 

replace parm = "inter_1X" if parm == "o.inter_1X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "2009" 1 "2010"  2 "2011"  3 "2012"  4 "2013"  5 "2014"  6 "2015"  7 "2016"  8 "2017"  9 "2018"  10 "2019"  11 "2020"  12 "2021"  13 "2022"
replace time = time - 1
label val time years

capture graph drop graph3j

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 13, msize(zero) color(black)), xlabel(0(2)13, val) graphr(c(white)) ytitle("") title("Panel : Number of judjes on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph3j")

graph save "graph3j.gph", replace