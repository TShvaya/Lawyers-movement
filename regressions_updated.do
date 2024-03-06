//Main regression file - prepare data using 02_Cleaning, use 2002-2008 data and 1st cleaning option (see comments in 02_Cleaning)

set scheme s1mono

cd "$outputfiles"

global controls SR TotalPolledVotes RegistredVoters

preserve

replace PMLN = 0 if missing(PMLN)
replace PML = 0 if missing(PML)
replace MQM = 0 if missing(MQM)
replace PPPP = 0 if missing(PPPP)

egen Constituency = group(PAConstituency)

//Generation of dummy for planned visits.
gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

//Treatment dummy: district_visited * post-2008
gen temp_dummy = 1 if Year == 2008
replace temp_dummy = 0 if Year != 2008
gen dummy_treatment = treat_fact_cj * temp_dummy
drop temp_dummy

keep if Year == 2002 | Year == 2008

eststo clear
estimates clear

reghdfe PMLN  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a Year)
capture drop check
gen check = e(sample)

eststo: reghdfe  PMLN dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store model1
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PMLN dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store model2
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PML  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a Year)
capture drop check
gen check = e(sample)

eststo: reghdfe  PML dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store model3
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PML dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store model4
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PPPP  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a Year)
capture drop check
gen check = e(sample)

eststo: reghdfe PPPP dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store model5
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PPPP dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store model6
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

drop if not_inc_sample_cj==1

reghdfe PMLN  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a Year)
capture drop check
gen check = e(sample)

eststo: reghdfe  PMLN dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store submodel1
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean  
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PMLN dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store submodel2
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PML  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a Year)
capture drop check
gen check = e(sample)

eststo: reghdfe  PML dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store submodel3
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PML dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store submodel4
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PPPP  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a Year)
capture drop check
gen check = e(sample)

eststo: reghdfe PPPP dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store submodel5
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PPPP dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a Year)
estimates store submodel6
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

estfe model*

local title `"Different parties votes share with District Level Clustering, 2 years data"'

esttab model*  using "Table1.tex",  replace b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Visits",) keep(dummy_treatment)  stats(fe_year fe_el_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "Electoral District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))  title(`title') nonotes   postfoot(\hline) prehead(\begin{table}[htbp]\centering \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \caption{Impact of Chief Justice Visits on Vote Shares} \begin{tabular}{l*{6}{c}} \hline\hline &\multicolumn{6}{c}{Vote Share \%} \\ \hline &\multicolumn{2}{c}{Pro-Lawyers Movement}                    &\multicolumn{2}{c}{Anti-Lawyers Movement}        &\multicolumn{2}{c}{Mixed-Lawyers Movement}             \\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7} &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn {1}{c}{(5)}&\multicolumn{1}{c}{(6)}\\ \hline \multicolumn{6}{l}{\textit{Panel A. All visits}}\\\cmidrule(lr){2-7}) nonum collabels(none) mlabels(none)


local notes `"Standard errors are clustered at the electoral districts level and are shown in parentheses. The dependent variable is the vote share of the party in the electoral distrcit (constituency). Pro-Lawyers Movement Vote Share is represented by Votes for Pakistan Muslim League - Nawaz (PMLN) Vote Share, Anti-Lawyers Movement Vote Share is represented by Votes for Pakistan Muslim League (PML) Vote Share, Mixed-Lawyers Movement Vote Share is represented by Votes for Pakistan Peoples Party Parliamentarians (PPPP) Vote Share. Data before pre-CJ Visits election in 2002 and post-CJ Visits election in 2008 is utilized in this analysis. "CJ Visits" is a dummy treatment variable switches to 1 if Chief Justice of Pakistan (Iftikhar Muhammad Chaudhry) visited the district during the pre-election period in 2008, "CJ Incidental Visits" switches to 1 if Iftikhar Muhammad Chaudhry incidentally visited the district during the pre-election period in 2008 (the visit was not planned, he stopped there on the way to his planned destination). A controls for the share of rejected votes, total polled votes and total registered voters are added in columns (2)-(4)-(6). \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)"'


esttab submodel*  using "Table1.tex", append mlabels(none) collabels(none) b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Incidental Visits",) keep(dummy_treatment)  stats(fe_year fe_el_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "Electoral District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))   nonotes postfoot(\hline\hline \end{tabular} \medskip \caption*{\footnotesize Notes: `notes'}\end{table}) tex prehead(" \multicolumn{6}{l}{\textit{Panel B. Incidental visits only}} \\\cmidrule(lr){2-7}")  nonumbers

restore


**4 year study, new visits data. Not used now.
preserve 

replace PMLN = 0 if missing(PMLN)
replace PML = 0 if missing(PML)
replace MQM = 0 if missing(MQM)
replace PPPP = 0 if missing(PPPP)

egen Constituency = group(PAConstituency)

gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
**following string for added 2013 treatment only
replace not_inc_sample_cj = 1 if treat_fact_after_el_cj == 1 & inc_sample_after_el_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

gen temp_dummy = 1 if Year >= 2008
replace temp_dummy = 0 if Year < 2008
gen dummy_treatment = treat_fact_at_all_cj * temp_dummy
drop temp_dummy

**following string for added 2013 treatment only
replace dummy_treatment = 1 if treat_fact_after_el_cj == 1 & Year == 2013

eststo clear
estimates clear

reghdfe PMLN  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PMLN dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model1
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PMLN dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model2
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PML  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PML dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model3
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PML dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model4
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PPPP  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe PPPP dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model5
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PPPP dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model6
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

drop if not_inc_sample_cj==1

reghdfe PMLN  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PMLN dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel1
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PMLN dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel2
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PML  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PML dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel3
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PML dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel4
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PPPP  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe PPPP dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel5
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PPPP dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel6
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

estfe model*

local title `"Different parties votes share with District Level Clustering, 4 years data"'

esttab model*  using "Table2.tex",  replace b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Visits",) keep(dummy_treatment)  stats(fe_year fe_el_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "Electoral District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))  title(`title') nonotes   postfoot(\hline) prehead(\begin{table}[htbp]\centering \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \caption{Impact of Chief Justice Visits on Vote Shares} \begin{tabular}{l*{6}{c}} \hline\hline &\multicolumn{6}{c}{Vote Share \%} \\ \hline &\multicolumn{2}{c}{Pro-Lawyers Movement}                    &\multicolumn{2}{c}{Anti-Lawyers Movement}        &\multicolumn{2}{c}{Mixed-Lawyers Movement}             \\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7} &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn {1}{c}{(5)}&\multicolumn{1}{c}{(6)}\\ \hline \multicolumn{6}{l}{\textit{Panel A. All visits}}\\\cmidrule(lr){2-7}) nonum collabels(none) mlabels(none)

local notes `"Standard errors are clustered at the electoral districts level and are shown in parentheses. The dependent variable is the vote share of the party in the electoral distrcit (constituency). Pro-Lawyers Movement Vote Share is represented by Votes for Pakistan Muslim League - Nawaz (PMLN) Vote Share, Anti-Lawyers Movement Vote Share is represented by Votes for Pakistan Muslim League (PML) Vote Share, Mixed-Lawyers Movement Vote Share is represented by Votes for Pakistan Peoples Party Parliamentarians (PPPP) Vote Share. Data before pre-CJ Visits election in 1997,2002 and post-CJ Visits elections in 2008,2013 is utilized in this analysis. "CJ Visits" is a dummy treatment variable switches to 1 if Chief Justice of Pakistan (Iftikhar Muhammad Chaudhry) visited the district during the pre-election period in 2008 or 2013, "CJ Incidental Visits" switches to 1 if Iftikhar Muhammad Chaudhry incidentally visited the district during the pre-election period in 2008 or 2013 (the visit was not planned, he stopped there on the way to his planned destination). A controls for the share of rejected votes, total polled votes and total registered voters are added in columns (2)-(4)-(6). \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)"'

esttab submodel*  using "Table2.tex", append mlabels(none) collabels(none) b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Incidental Visits",) keep(dummy_treatment)  stats(fe_year fe_el_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "Electoral District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))   nonotes postfoot(\hline\hline \end{tabular} \medskip \caption*{\footnotesize Notes: `notes'}\end{table}) tex prehead(" \multicolumn{6}{l}{\textit{Panel B. Incidental visits only}} \\\cmidrule(lr){2-7}")  nonumbers

restore


**placebo. Use 1997-2002 data with 2nd cleaning option (now set as default).
preserve 

replace PMLN = 0 if missing(PMLN)
replace PML = 0 if missing(PML)
replace MQM = 0 if missing(MQM)
replace PPPP = 0 if missing(PPPP)

egen Constituency = group(PAConstituency)

gen not_inc_sample_cj = 1 if treat_group_before_el_cj == 1 & inc_sample_cj == 0
replace not_inc_sample_cj = 0 if not_inc_sample_cj ==.

gen temp_dummy = 1 if Year == 2002
replace temp_dummy = 0 if Year != 2002
gen dummy_treatment = treat_group_before_el_cj * temp_dummy
drop temp_dummy

eststo clear
estimates clear

reghdfe PMLN  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PMLN dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model1
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PMLN dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model2
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PML  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PML dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model3
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PML dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model4
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PPPP  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe PPPP dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model5
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PPPP dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store model6
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

drop if not_inc_sample_cj==1

reghdfe PMLN  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PMLN dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel1
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean  
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PMLN dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel2
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PMLN if PMLN != 0, mean  
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PML  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe  PML dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel3
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PML dummy_treatment $controls if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel4
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PML if PML != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

reghdfe PPPP  dummy_treatment $controls, absorb(i.Year i.Constituency) cluster(district_a)
capture drop check
gen check = e(sample)

eststo: reghdfe PPPP dummy_treatment if check == 1 , a(i.Year i.Constituency) vce(cluster district_a)
estimates store submodel5
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls No
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

eststo: reghdfe  PPPP dummy_treatment $controls if check == 1, a(i.Year  i.Constituency) vce(cluster district_a)
estimates store submodel6
estadd local fe_year Yes
estadd local fe_el_district Yes
estadd local sr_controls Yes
estadd local Clusters = round(e(N_clust), 1)
estadd local N_ = round(e(N), 1)
su PPPP if PPPP != 0, mean 
local mymean = round(r(mean), .001)
estadd local mD = `mymean'

estfe model*


local title `"Different parties votes share with District Level Clustering, 4 years data, placebo test"'

esttab model*  using "Table3.tex",  replace b(3) se(3)  label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Visits",) keep(dummy_treatment)  stats(fe_year fe_el_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "Electoral District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))  title(`title') nonotes   postfoot(\hline) prehead(\begin{table}[htbp]\centering \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \caption{Impact of Chief Justice Visits on Vote Shares, placebo test} \begin{tabular}{l*{6}{c}} \hline\hline &\multicolumn{6}{c}{Vote Share \%} \\ \hline &\multicolumn{2}{c}{Pro-Lawyers Movement}                    &\multicolumn{2}{c}{Anti-Lawyers Movement}        &\multicolumn{2}{c}{Mixed-Lawyers Movement}             \\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7} &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn {1}{c}{(5)}&\multicolumn{1}{c}{(6)}\\ \hline \multicolumn{6}{l}{\textit{Panel A. All visits}}\\\cmidrule(lr){2-7}) nonum collabels(none) mlabels(none)

local notes `"Standard errors are clustered at the electoral districts level and are shown in parentheses. The dependent variable is the vote share of the party in the electoral distrcit (constituency). Pro-Lawyers Movement Vote Share is represented by Votes for Pakistan Muslim League - Nawaz (PMLN) Vote Share, Anti-Lawyers Movement Vote Share is represented by Votes for Pakistan Muslim League (PML) Vote Share, Mixed-Lawyers Movement Vote Share is represented by Votes for Pakistan Peoples Party Parliamentarians (PPPP) Vote Share. Data before pre-CJ Visits elections in 1997 and 2002 is utilized in this analysis. This is placebo-test, so "CJ Visits" is a dummy treatment variable switches to 1 for year 2002 if Chief Justice of Pakistan (Iftikhar Muhammad Chaudhry) visited the district during the pre-election period in 2008, "CJ Incidental Visits" switches to 1 if Iftikhar Muhammad Chaudhry incidentally visited the district during the pre-election period in 2008 (the visit was not planned, he stopped there on the way to his planned destination). A controls for the share of rejected votes, total polled votes and total registered voters are added in columns (2)-(4)-(6). \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)"'

esttab submodel*  using "Table3.tex", append mlabels(none) collabels(none) b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) varlabels(dummy_treatment "CJ Incidental Visits",) keep(dummy_treatment)  stats(fe_year fe_el_district sr_controls mD N_ Clusters, fmt(%8.3f %8.0f) labels("Year Fixed Effects" "Electoral District Fixed Effects" Controls "Mean Dep. Var." "Observations" "Number of Districts"))   nonotes postfoot(\hline\hline \end{tabular} \medskip \caption*{\footnotesize Notes: `notes'}\end{table}) tex prehead(" \multicolumn{6}{l}{\textit{Panel B. Incidental visits only}} \\\cmidrule(lr){2-7}")  nonumbers

restore