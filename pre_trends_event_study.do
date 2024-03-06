//Data preparation made using 02_Cleaning file. Data for 1993-2008 is needed, 3rd cleaning option (see comments in 02_Cleaning)

global controls SR TotalPolledVotes RegistredVoters

preserve

replace PMLN = 0 if missing(PMLN)
replace PML = 0 if missing(PML)
replace MQM = 0 if missing(MQM)
replace PPPP = 0 if missing(PPPP)

egen Constituency = group(PAConstituency)

tab Year, gen(d_)

forval i=1/4 {
	gen inter_`i'X = d_`i'*treat_fact_at_all_cj
}

#d ;
global eventstudy "inter_1X inter_2X inter_4X inter_3X";
#d cr

estimates clear
reghdfe PMLN $eventstudy $controls, a(i.Year i.Constituency) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest1.dta", replace)

estimates clear
reghdfe PML $eventstudy $controls, a(i.Year i.Constituency) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest2.dta", replace)

estimates clear
reghdfe PPPP $eventstudy $controls, a(i.Year i.Constituency) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest3.dta", replace)

gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

drop if not_inc_sample_cj==1

estimates clear
reghdfe PMLN $eventstudy $controls, a(i.Year i.Constituency) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest1inc.dta", replace)

estimates clear
reghdfe PML $eventstudy $controls, a(i.Year i.Constituency) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest2inc.dta", replace)

estimates clear
reghdfe PPPP $eventstudy $controls, a(i.Year i.Constituency) vce(cl district_a)

parmest, label format(p %8.1e) stars(0.05 0.01 0.001 0.0001) list(parm label estimate min95 max95 p stars, clean noobs) saving("Parmest3inc.dta", replace)


*graph1

use "Parmest1.dta", clear 

replace parm = "inter_3X" if parm == "o.inter_3X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "1993" 1 "1997" 2 "2002" 3 "2008"
replace time = time - 1
label val time years

capture graph drop graph1

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 4, msize(zero) color(black)), xlabel(0(1)3, val) graphr(c(white)) ytitle("") title("Panel : PMLN vote share on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph1")

graph save "graph1.gph", replace


*graph2

use "Parmest2.dta", clear 

replace parm = "inter_3X" if parm == "o.inter_3X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "1993" 1 "1997" 2 "2002" 3 "2008"
replace time = time - 1
label val time years

capture graph drop graph2

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 4, msize(zero) color(black)), xlabel(0(1)3, val) graphr(c(white)) ytitle("") title("Panel : PML vote share on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph2")

graph save "graph2.gph", replace

*graph3

use "Parmest3.dta", clear 

replace parm = "inter_3X" if parm == "o.inter_3X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "1993" 1 "1997" 2 "2002" 3 "2008"
replace time = time - 1
label val time years

capture graph drop graph3

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 4, msize(zero) color(black)), xlabel(0(1)3, val) graphr(c(white)) ytitle("") title("Panel : PPPP vote share on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph3")

graph save "graph3.gph", replace

*graph1

use "Parmest1inc.dta", clear 

replace parm = "inter_3X" if parm == "o.inter_3X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "1993" 1 "1997" 2 "2002" 3 "2008"
replace time = time - 1
label val time years

capture graph drop graph1inc

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 4, msize(zero) color(black)), xlabel(0(1)3, val) graphr(c(white)) ytitle("") title("Panel : PMLN vote share on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph1inc")

graph save "graph1inc.gph", replace


*graph2

use "Parmest2inc.dta", clear 

replace parm = "inter_3X" if parm == "o.inter_3X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "1993" 1 "1997" 2 "2002" 3 "2008"
replace time = time - 1
label val time years

capture graph drop graph2inc

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 4, msize(zero) color(black)), xlabel(0(1)3, val) graphr(c(white)) ytitle("") title("Panel : PML vote share on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph2inc")

graph save "graph2inc.gph", replace

*graph3

use "Parmest3inc.dta", clear 

replace parm = "inter_3X" if parm == "o.inter_3X"
keep if substr(parm, 1, 6) == "inter_" 

replace parm = subinstr(parm,"inter_","",.)
replace parm = subinstr(parm,"X","",.)

destring parm, gen(time) force
sort time

label define years 0 "1993" 1 "1997" 2 "2002" 3 "2008"
replace time = time - 1
label val time years

capture graph drop graph3inc

twoway  (line estimate time, cmiss(n) lw(medthick) lc(black)) (rline max95 min95 time, lpattern(shortdash) cmiss(n) lc(gs10)) (pcarrowi 0 0 0 4, msize(zero) color(black)), xlabel(0(1)3, val) graphr(c(white)) ytitle("") title("Panel : PPPP vote share on treat_fact_at_all_cj*Year") xline(36, lw(thick) lc(black) noex) legend(order(1 2) rows(2) cols(1) lab(1 "(CJ Visited)X(Year)") lab(2 "95% confidence interval") pos(6)) name("graph3inc")

graph save "graph3inc.gph", replace