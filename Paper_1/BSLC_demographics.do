* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    BSLC_demographics.do
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
    local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\IDB\Barbados Survey of Living Conditions_2016\Data"

    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\2-working\Logfiles"

    ** REPORTS and Other outputs
    local outputpath "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p146\05_Outputs"



    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\BSLC_demographics.smcl", replace
	
	

** ------------------------------------------------------------------------------------
** PART 1.  Importing demographics dataset
** ------------------------------------------------------------------------------------
 use "`datapath'\RT002_Public.dta"
 

destring hhid, replace // Household ID was in string form

rename psu ENUM_NO1

gen Uniqueid = _n //Unique ID for each individual was created as the dataset only had in a unique household id. 
label variable Uniqueid "Unique ID"
order Uniqueid, after(hhid)

** Keeping Key Variables
keep hhid Uniqueid weight psu stratum psus_N id ENUM_NO1 q1_03 q1_04 q1_05 q1_06 q3_22 q5_01p q5_01o q5_02 q5_06a q5_06b q10_02a q10_02b

**----------------------------------------------------------------------------------------
** PART 2. Calculating BMI for each adult
**----------------------------------------------------------------------------------------

** Covert weight in pounds to kilograms

gen weight1=. // pounds to Kg
replace weight1 = q5_01p * 0.45359237 

gen weight2=. // ounces to Kg
replace weight2 = q5_01o * 0.028349523

gen weightKG=. // total weight in Kg
replace weightKG = weight1 + weight2
replace weightKG = weight1 if weight2==.

** convert height to meters

gen heightM= . // cm to m

replace heightM= q5_02 / 100


** Calculating BMI (kg/m^2)
gen BMI = . 
replace BMI = weightKG / heightM^2


** Calculating BMI Categories

	// Underweight - BMI under 18.5 kg/m^2
	// Normal weight - BMI greater than or equal to 18.5 to 24.9 kg/m^2
	// Overweight – BMI greater than or equal to 25 to 29.9 kg/m^2
	// Obesity class I – BMI 30 to 34.9 kg/m^2
	// Obesity class II – BMI 35 to 39.9 kg/m^2
	// Obesity class III – BMI greater than or equal to 40

gen BMI_cat =.
replace BMI_cat=1 if BMI< 18.5
replace BMI_cat=2 if BMI>=18.5 & BMI<25
replace BMI_cat=3 if BMI>=25 & BMI<30
replace BMI_cat=4 if BMI>=30 & BMI<35
replace BMI_cat=5 if BMI>=35 & BMI<40
replace BMI_cat=6 if BMI>=40 & BMI <. 
replace BMI_cat=. if BMI==.

label define bmi_cat 1"underweight" 2"normal" 3"overweight" 4"obesity1" 5"obesity2" 6"obesity3"
label values BMI_cat bmi_cat



merge m:m ENUM_NO1 using "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\ArcGIS\Paper1_ Deserts_Swamps\RFEI_mRFEI_EDs.dta"

**----------------------------------------------------------------------------------------
** PART 3. Generating the mean and median BMI per ED
**---------------------------------------------------------------------------------------

**collapse (mean) meanBMI=BMI (median) medBMI=BMI (count) count=BMI (sum), by (ENUM_NO1)
**save "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\IDB\BMI_ED_individuals.dta", replace








