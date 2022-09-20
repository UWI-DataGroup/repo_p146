** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataAnalysis_Access_01
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	20-August-2022
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
  //  capture log close
    //log using "`logpath'\DataAnalysis_SES_01", replace

** ----------------------------------------------------------------------------------
** PART 1 : Importing combined dataset
** ----------------------------------------------------------------------------------

    use "`datapath'\Combined_EDs_01.dta"

** -----------------------------------------------------------------------------------
** PART 2: Creating ratios for each ED on the distance to healthy vs unhealthy
**------------------------------------------------------------------------------------

    gen DistanceRatio= Distance_Unhealthy / Distance_Healthy

    