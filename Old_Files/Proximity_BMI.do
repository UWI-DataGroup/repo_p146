* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    Proximity_BMI.do
    //  project:				    Foodscapes - IDB data
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	14-July-2022
    
			    

    ** General algorithm set-up
    version 16
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export

    ** DATASETS to encrypted SharePoint folder
    local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\ArcGIS\Paper1_ Deserts_Swamps"

    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\2-working\Logfiles"

    ** REPORTS and Other outputs
    local outputpath "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p146\05_Outputs"



    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\Proximity_BMI.smcl", replace
	
	

** ------------------------------------------------------------------------------------
** PART 1.  Importing Proximity dataset
** ------------------------------------------------------------------------------------


use "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\ArcGIS\Paper1_ Deserts_Swamps\DistancetoFoodOutlets.dta"


**-------------------------------------------------------------------------------------
** PART 2. Merging proximity dataset to BMI data per ED
**-------------------------------------------------------------------------------------

merge 1:1 ENUM_NO1 using "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\IDB\BMI_ED.dta"

**--------------------------------------------------------------------------------------
** PART 3. Categorizing distances
** ---------------------------------------------------------------------------------

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

**----------------------------------------------------------------------------------------
** PART 4. Examining the relationship for between distance from the nearest healthy and unhealthy food outlet and BMI
**-----------------------------------------------------------------------------------------




regress meanBMI i.UH_Dis_Cat
regress medBMI i.UH_Dis_Cat

regress meanBMI i.H_Dis_Cat
regress medBMI i.H_Dis_Cat

regress meanBMI Distance_Healthy
regress medBMI Distance_Healthy

regress meanBMI Distance_Unhealthy
regress medBMI Distance_Unhealthy


// there may be confounders... need to add in mean age and mean income to the dataset.