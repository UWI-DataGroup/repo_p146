** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataPrep_EDs_01
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	25-July-2022
    //  algorithm task			    

    ** General algorithm set-up
    version 16
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export

    ** DATASETS to encrypted SharePoint folder
    local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\ArcGIS\Paper1_ Deserts_Swamps"

    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\2-working\Logfiles"

    ** REPORTS and Other outputs
    local outputpath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\3-output"

    ** SHAPEFILES
    local shapepath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\Shapefiles"

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\DataPrep_EDs_01", replace

** ----------------------------------------------------------------------------------
** PART 1 : Importing dataset - starting with the food deserts dataset
** ----------------------------------------------------------------------------------

use "`datapath'\FD_buffers_EDs.dta"
drop ENUM_NO1_1 ENUM_NO1_2 k_1
** ----------------------------------------------------------------------------------
** PART 2: Merging the foodswamps data 
** ----------------------------------------------------------------------------------

merge 1:1 ENUM_NO1 using "`datapath'\RFEI_mRFEI_EDs.dta"
drop _merge

** ----------------------------------------------------------------------------------
** PART 3: Merging Proximity Data
** ----------------------------------------------------------------------------------
merge 1:1 ENUM_NO1 using "`datapath'\DistancetoFoodOutlets.dta"
drop _merge


** ----------------------------------------------------------------------------------
** PART 4: Adding necessary labels to variables
**-----------------------------------------------------------------------------------
order Distance_Unhealthy, after (Distance_Healthy)
label variable mRFEI "Modified Retail Food Enviornment Index"
label variable mRFEI100 "mRFEI Percentage"
label variable Distance_Healthy "Distance to nearest Healthy"
label variable Distance_Unhealthy "Distance to nearest Unhealthy"
label variable PARISH "Parish"


** ----------------------------------------------------------------------------------
** PART 5: Categorizing the distances to the nearest healthy and unhealthy food outlets 
**-----------------------------------------------------------------------------------

** Unhealthy
gen UH_Dis_Cat=.
replace UH_Dis_Cat= 1 if Distance_Unhealthy <=200
replace UH_Dis_Cat= 2 if Distance_Unhealthy >200 & Distance_Unhealthy<=500
replace UH_Dis_Cat= 3 if Distance_Unhealthy >500 & Distance_Unhealthy<=1000
replace UH_Dis_Cat = 4 if Distance_Unhealthy >1000 & Distance_Unhealthy<.
replace UH_Dis_Cat=. if Distance_Unhealthy==. 

label variable UH_Dis_Cat "Distance to Unhealthy"
label define distance_cat 1 "<= 200" 2 ">200 & <=500" 3 ">500 & <=1000" 4 ">1000"
label values UH_Dis_Cat distance_cat


** Healthy
gen H_Dis_Cat=.
replace H_Dis_Cat= 1 if Distance_Healthy <=200
replace H_Dis_Cat= 2 if Distance_Healthy >200 & Distance_Healthy<=500
replace H_Dis_Cat= 3 if Distance_Healthy >500 & Distance_Healthy<=1000
replace H_Dis_Cat = 4 if Distance_Healthy >1000 & Distance_Healthy<.
replace H_Dis_Cat=. if Distance_Healthy==. 

label variable H_Dis_Cat "Distance to Healthy"
label values H_Dis_Cat distance_cat




** ----------------------------------------------------------------------------------
** PART 6: Merging SES data
** ----------------------------------------------------------------------------------
merge 1:1 ENUM_NO1 using "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\BSS\SES\SES_index_Stephanie.dta"
drop _merge


**-----------------------------------------------------------------------------------------
** PART 7: Saving new dataset - This new dataset contains all relevant data at the ED level
** -----------------------------------------------------------------------------------------
save "`datapath'\Combined_EDs_01.dta", replace

