** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataAnalysis_SES_01
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	03-August-2022
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
    log using "`logpath'\DataAnalysis_SES_01", replace

** ----------------------------------------------------------------------------------
** PART 1 : Importing combined dataset
** ----------------------------------------------------------------------------------

    use "`datapath'\Combined_EDs_01.dta"

** -----------------------------------------------------------------------------------------
** PART 2 : Exploring the relationship between Food Deserts and Swamps with SES variables
**        : Outcome variables --> Deserts and Swamps ( buffers, mRFEI, proximity)
**        : Predictir variables --> SES variables (income, unemployment, vehicle ownership)
** ------------------------------------------------------------------------------------------

** Outcome variable: Food Desert at 1km buffer

logistic Tfd1 t_income_median
logistic Tfd1 per_t_income_0_49
logistic Tfd1 per_t_high_income
logistic Tfd1 per_vehicle_presence
logistic Tfd1 per_t_unemployment
logistic Tfd1 per_t_education_less_secondary



** Outcome variable: Food Desert at 1.5km buffer 

