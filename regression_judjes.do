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
	
global controls transf_th

preserve

//Clustering and FEs are based on districts (not electoral!).
egen District = group(district_a)

//Generation of dummy for planned visits.
gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

//Treatment dummy: district_visited * post-2008
gen temp_dummy = 1 if Year >= 2008
replace temp_dummy = 0 if Year < 2008
gen dummy_treatment = treat_group_cj * temp_dummy
drop temp_dummy

eststo clear
estimates clear

reghdfe Institution_total dummy_treatment $controls, a(i.Year i.District) vce(cluster district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  Institution_total dummy_treatment if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store model1
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Institution_total if Institution_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  Institution_total dummy_treatment $controls if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store model2
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Disposal_total if Disposal_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe Disposal_total dummy_treatment $controls, a(i.Year i.District) vce(cluster district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  Disposal_total dummy_treatment if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store model3
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Institution_total if Institution_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  Disposal_total dummy_treatment $controls if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store model4
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Disposal_total if Disposal_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

drop if not_inc_sample_cj==1


reghdfe Institution_total dummy_treatment $controls, a(i.Year i.District) vce(cluster district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  Institution_total dummy_treatment if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store submodel1
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Institution_total if Institution_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  Institution_total dummy_treatment $controls if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store submodel2
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Disposal_total if Disposal_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe Disposal_total dummy_treatment $controls, a(i.Year i.District) vce(cluster district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  Disposal_total dummy_treatment if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store submodel3
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Institution_total if Institution_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  Disposal_total dummy_treatment $controls if check == 1, a(i.Year i.District) vce(cluster district_a)
estimates store submodel4
estadd local fe_year Yes
estadd local fe_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Disposal_total if Disposal_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'


estfe model*

local title `"CJ visits on Institution_total and Disposal_total"'

esttab model*  using "Table1j.tex",  replace b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Visits",) keep(dummy_treatment)  stats(fe_year fe_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))  title(`title') nonotes   postfoot(\hline) prehead(\begin{table}[htbp]\centering \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \caption{Impact of Chief Justice Visits on Institution and Disposal} \begin{tabular}{l*{4}{c}} \hline\\ \hline &\multicolumn{2}{c}{Institution}                    &\multicolumn{2}{c}{Disposal}         \\\cmidrule(lr){2-3}\cmidrule(lr){4-5} &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}\\ \hline \multicolumn{4}{l}{\textit{Panel A. All visits}}\\\cmidrule(lr){2-5}) nonum collabels(none) mlabels(none)


local notes `"Standard errors are clustered at the districts level and are shown in parentheses. The dependent variable is number of Case Institutions and number of Case Disposal in distrcit. Data for years 2006-2022 is utilized in this analysis. "CJ Visits" is a dummy treatment variable switches to 1 if Chief Justice of Pakistan (Iftikhar Muhammad Chaudhry) visited the district during the pre-election period in 2008, "CJ Incidental Visits" switches to 1 if Iftikhar Muhammad Chaudhry incidentally visited the district during the pre-election period in 2008 (the visit was not planned, he stopped there on the way to his planned destination). A control for the share of transfered cases is added in columns (2)-(4). \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)"'


esttab submodel*  using "Table1j.tex", append mlabels(none) collabels(none) b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Incidental Visits",) keep(dummy_treatment)  stats(fe_year fe_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))   nonotes postfoot(\hline\hline \end{tabular} \medskip \caption*{\footnotesize Notes: `notes'}\end{table}) tex prehead(" \multicolumn{4}{l}{\textit{Panel B. Incidental visits only}} \\\cmidrule(lr){2-5}")  nonumbers

restore


*****************

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
	
global controls transf_th

preserve

egen District = group(district_a)

gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

eststo clear
estimates clear

reghdfe judges_working treat_group_cj $controls, a(i.Year) vce(cluster district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  judges_working treat_group_cj if check == 1, a(i.Year) vce(cluster district_a)
estimates store model1
estadd local fe_year Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Institution_total if Institution_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  judges_working treat_group_cj $controls if check == 1, a(i.Year) vce(cluster district_a)
estimates store model2
estadd local fe_year Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Disposal_total if Disposal_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

drop if not_inc_sample_cj==1


reghdfe judges_working treat_group_cj $controls, a(i.Year) vce(cluster district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  judges_working treat_group_cj if check == 1, a(i.Year) vce(cluster district_a)
estimates store submodel1
estadd local fe_year Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Institution_total if Institution_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  judges_working treat_group_cj $controls if check == 1, a(i.Year) vce(cluster district_a)
estimates store submodel2
estadd local fe_year Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su Disposal_total if Disposal_total != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

estfe model*

local title `"CJ visits on Institution_total and Disposal_total"'

esttab model*  using "Table2j.tex",  replace b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) varlabels(treat_group_cj "CJ Visits",) keep(treat_group_cj)  stats(fe_year  sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))  title(`title') nonotes   postfoot(\hline) prehead(\begin{table}[htbp]\centering \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \caption{Impact of Chief Justice Visits on Number of judjes working in distrcit} \begin{tabular}{l*{2}{c}} \hline\\ \hline &\multicolumn{2}{c}{Judjes}                   \\\cmidrule(lr){2-3} &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}\\ \hline \multicolumn{2}{l}{\textit{Panel A. All visits}}\\\cmidrule(lr){2-3}) nonum collabels(none) mlabels(none)


local notes `"Standard errors are clustered at the districts level and are shown in parentheses. The dependent variable is number of  Judjes working in distrcit. Data for years 2009-2022 is utilized in this analysis. "CJ Visits" is a dummy treatment variable switches to 1 if Chief Justice of Pakistan (Iftikhar Muhammad Chaudhry) visited the district during the pre-election period in 2008, "CJ Incidental Visits" switches to 1 if Iftikhar Muhammad Chaudhry incidentally visited the district during the pre-election period in 2008 (the visit was not planned, he stopped there on the way to his planned destination). A control for the share of transfered cases is added in column (2). \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)"'


esttab submodel*  using "Table2j.tex", append mlabels(none) collabels(none) b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) varlabels(treat_group_cj "CJ Incidental Visits",) keep(treat_group_cj)  stats(fe_year sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))   nonotes postfoot(\hline\hline \end{tabular} \medskip \caption*{\footnotesize Notes: `notes'}\end{table}) tex prehead(" \multicolumn{2}{l}{\textit{Panel B. Incidental visits only}} \\\cmidrule(lr){2-3}")  nonumbers

restore