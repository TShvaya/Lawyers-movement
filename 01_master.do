	/***************************************************************************
	Project:		Lawyer Movement
	Name: 			Master file
	Authors: 		Aleksandra Snegureva
	Last edited on: 21/07/2022
	Last edited by: Aleksandra Snegureva

    ** OUTLINE:      PART 0: Standardize settings and install packages
                     PART 1: Set globals for dynamic file paths
                     PART 2: Set globals for constants and varlist
                             used across the project. Install all user-contributed
                             commands needed.
                     PART 3: Call the task-specific master do-files 
                             that call all dofiles needed for that 
                             task. Do not include Part 0-2 in a task-
                             specific master do-file


    ** ID VARIABLES: case_id firm_id party_roles            

    ** NOTES:

	***************************************************************************/

	/*****************************Part 0: Settings*****************************/

	clear all
	set more off
	set trace off
	set varabbrev off
	set logtype text
	capture log close 
	*Standardize settings accross users
    //ieboilstart, version(12.1)          //Set the version number to the oldest version 

	version 14.2
	pause on
	
	
	/************************Part 1: Setting globals/pathnames*****************/

   global projectfolder "\\Mac\Home\Desktop\law2"


   global dofiles       "$projectfolder\Do" 
   
   global data          "$projectfolder\Data" 

   /*All output files will be saved in this folder. This folder will have 
   subfolders for intermediate outputs and final outputs, files to be edited. */
   global outputfiles		"$projectfolder\Output"
   
   /* Subfolders under the output folder, the intermediate output files used for
   data cleaning are stored here*/
   global outputtemp 		"$outputfiles\temp" 
   //to save intermediate files that need to be edited for translations etc.
   global outputgraphs 		"$outputfiles\graphs" 
  //graphs are stored here
 
    
   /**********************Part 2. Installing commands *************************/
	*ssc install ftools
   	local user_commands 
	//Add as many commands to the previous line as required
	
	
	foreach command of local user_commands {
       cap which `command'
       if _rc == 111 {
           ssc install `command'
       }
   }


   /************************Part 3: Running do files **************************/




