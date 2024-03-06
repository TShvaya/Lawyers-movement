/***************************************************************************
Project:		Lawyer Movement
	
Last edited on: 06/03/2024

    ** OUTLINE:      PART 1: Clean and Create Political variables 
                     PART 2: Move to panel
                     PART 3: Uploading treatment data


***********************************************************************************
  // Part 1: Clean and Create Political variables
***********************************************************************************/

// Load the dataset and replace the current dataset
	use "$data\00_data.dta", replace
	keep Year ElectionType good_name_constituencyPA district_a PAConstituency CandidateIDbyConstituency Vote_Share ContestingCandidates ActualCandidateVote TotalPolledVotes RegistredVoters Rejectedvotes PartyInitials FullNameofParty Winner_Name 
// Keep only the data for the specified years (2002 and 2008 / 1997 and 2002 for placebo, 1993-2008 for event-study)
	*keep if Year==2002|Year==2008 
	keep if Year==2002|Year==1997
	*keep if Year==2002|Year==2008 | Year==1997 | Year==1993
	
	//No Balochistan
	*drop if district_a=="Nasirabad"|district_a=="Kalat"|district_a=="Zhob"|district_a=="Quetta"|district_a=="Sibi"
	
// Drop observations where ElectionType is "BE"
	drop if ElectionType=="BE"

// Rename the variable "good_name_constituencyPA" to "const_name"
	rename good_name_constituencyPA const_name

// Split "PAConstituency" into two parts using "-" as a separator and generate "PACConst_2ndpart1" variable
	split PAConstituency, parse("-") generate(PACConst_2ndpart) limit(1)
	replace PACConst_2ndpart1 ="pf" if PACConst_2ndpart1=="pk"
	rename PACConst_2ndpart1 PA
	
// Drop constituencies with incomplete data (i.e., "na-42tribalarea-vii" and "pp-141lahore-v")
	drop if PAConstituency=="na-42tribalarea-vii"|PAConstituency=="pp-141lahore-v"

// Create group identifiers for each PA (Political Assembly) and const_name (constituency name)
	egen id_PA_name=group(PA const_name)
	egen id_const=group(const_name)
	
// Recode "Party_Type" based on "PartyInitials"
	gen Party_Type="PMLN" if PartyInitials == "PML-N"
	replace Party_Type="PML" if PartyInitials == "PML"|PartyInitials=="PML-Jinnah"
	replace Party_Type="MQM" if PartyInitials == "MQM"	
	replace Party_Type="IND" if PartyInitials == "IND"
	replace Party_Type="PPPP" if PartyInitials == "PPPP"|PartyInitials == "PPP"
	replace Party_Type="MMA" if PartyInitials=="MMA"
	replace Party_Type="Other" if Party_Type!="IND"&Party_Type!="PML"&Party_Type!="PMLN"&Party_Type!="PPPP"&Party_Type!="MQM"&Party_Type!="MMA"

// Create a binary variable "wins" to indicate if the candidate won (Winner_Name == ContestingCandidates)
	gen wins=(Winner_Name == ContestingCandidates)

// Calculate the total number of wins per combination of "id_PA_name" and "Year"
	egen help3=total(wins), by(id_PA_name Year)
	summ help3
	
// Drop observations where the number of wins is not equal to 1 (keeping only winners)
	drop if help3!=1

/***********************************************************************************
  // Part 2: Move to panel
***********************************************************************************/

// Create panel identifiers using "id_PA_name" and "Party_Type"
	sort id_PA_name Year Party_Type

// Calculate the mean of "Vote_Share" for each combination of "id_PA_name," "Year," and "Party_Type"
	egen Party_av_Vote=mean(Vote_Share), by (id_PA_name Year Party_Type)
	
// Calculate the total number of candidates per combination of "id_PA_name," "Year," and "Party_Type"
	gen x=1 
	egen Party_n_Candidates=total(x),by(id_PA_name Year Party_Type)
	
// Calculate the total number of wins per combination of "id_PA_name," "Year," and "Party_Type"
	egen Party_wins=total(wins),by ( id_PA_name Year Party_Type) 
	
// Remove the unnecessary variables from the dataset (to prevent duplicates in other variables).
	
	drop x help3 wins CandidateIDbyConstituency ContestingCandidates ActualCandidateVote Vote_Share PartyInitials FullNameofParty

// Drop duplicate observations ()	
	duplicates drop
	
// Create panel identifiers using "id_PA_name" and "Party_Type"
	gen x=1
	egen id_panel=group(id_PA_name Party_Type)
// Drop observations where the number of occurrences is not equal to 1 (keeping only unique "id_panel"). id_PA_name 839 625 had repeated valuse.
	egen help3=total(x), by(id_panel Year)
	sort help3 id_panel Year
	drop if help3!=1
	drop help3
	
// Set the data as panel data using "id_panel" as the panel identifier and "Year" as the time variable
	xtset id_panel Year


// Drop Party_Type-Constituency observations that are only present in one year, either 2002 or 2008.
//Data-filtering. 1st filter used for baseline regression, 2nd for placebo, 3rd for event-study.

	*egen help_y=total(Year) if Year==2002|Year==2008, by(id_panel) 
	*drop if help_y==2002|help_y==2008
	
	egen help_y=total(Year) if Year==2002|Year==1997, by(id_panel) 
	drop if help_y==2002|help_y==1997
	
	*egen help_y=total(Year) if Year==2002|Year==1997|Year==1993|Year==2008, by(id_panel) 
	*drop if help_y==2002|help_y==1997|help_y==1993|help_y==2008

// Final clean

	sort district_a PAConstituency
	drop if district_a==""	
	destring Rejectedvotes TotalPolledVotes, replace 

***************************************************************************/
**# Part 3: Uploading treatment data
***************************************************************************/	
	
	// Upload and prepare the data on electoral oucomes and merge it with treatment data

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
		gen treat_fact_`x'=(num_visits_`x'_before_el>0 & Year==2008)
		gen treat_fact_at_all_`x'=(num_visits_`x'_before_el>0)
	}

	//Create new variables which identify the incidental/planned status of the visits
	foreach x in cj ali itzaz{
	replace inc_sample_`x'=1 if inc_sample_`x'>99999
	}
	gen inc_sample_any=(inc_sample_cj==1&inc_sample_ali==1&inc_sample_itzaz==1)
	
	
	
	// Create variables to store average vote for each party separately
	foreach X in PMLN PML MQM PPPP  {
		gen `X'= Party_av_Vote if Party_Type=="`X'"
	}


	// Create control variable 
	rename Rejectedvotes RV 
	gen SR=RV/TotalPolledVotes
	label variable SR "Share of Rejected Votes"
	
	//New treatment data - now not used
	*drop _merge
	*merge m:m district_a using "$data\01_data_update.dta"
	
	*foreach x in cj ali itzaz {
	*	gen treat_fact_after_el_`x'=(new_num_visits_`x'>0  & Year==2013) 
	*	gen inc_sample_after_el_`x'= new_inc_sample_cj
	*}