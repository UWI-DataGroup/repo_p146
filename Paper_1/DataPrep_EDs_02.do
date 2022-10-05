** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataPrep_EDs_02
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	28-September-2022
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
    log using "`logpath'\DataPrep_EDs_02", replace


** ----------------------------------------------------------------------------------
** PART 1 : Importing and saving datasets
** ----------------------------------------------------------------------------------


**Number of Food Outlets in 1km buffer
import excel "`datapath'\Outletsin1km.xlsx", sheet("Outletsin1km") firstrow
collapse (sum) Join_Count, by (ENUM_NO1)
save "`datapath'\Outlets_1kmBuffer_perED.dta", replace
clear

** Number of Food Outlets in 3km buffer
import excel "`datapath'\Outletsin3km.xlsx", sheet("Outletsin3km") firstrow
collapse (sum) Join_Count, by (ENUM_NO1)
label variable Join_Count "3km_buffer_outlets"
rename Join_Count Outlets_3km
save "`datapath'\Outlets_3kmBuffer_perED.dta", replace

** Merging Number of Food outlets in 1km and 3km buffers into one dataset
merge 1:1 ENUM_NO1 using "`datapath'\Outlets_1kmBuffer_perED.dta"
label variable Join_Count "1km_buffer_outlets"
rename Join_Count Outlets_1km
label variable ENUM_NO1 "ED"
rename ENUM_NO1 ed
drop _merge
save "`datapath'\Outlets_1km_3km_perED.dta"

** Merging Number of Food outlets in each buffer to main dataset
merge 1:1 ed using "`datapath'\Combined_EDs_01.dta"
drop _merge


** Generating density variable at the 1km buffer and 3km buffer
gen density1km = Outlets_1km / 3.141593
gen density3km = Outlets_3km / 28.274334
save "`datapath'\Combined_EDs_02.dta"
clear


** Number of Healthy Food outlets in 1km buffer
import excel "`datapath'\HealthyOutletsin1km.xlsx", sheet("HealthyOutletsin1km") firstrow
collapse (sum) Join_Count, by (ENUM_NO1)
rename Join_Count HealthyOutlets_1km
rename ENUM_NO1 ed
save "`datapath'\HealthyOutlets_1kmBuffer_perED.dta"

clear

import excel "`datapath'\UnhealthyOutletsin3km.xlsx", sheet("UnhealthyOutletsin3km") firstrow clear
collapse (sum) Join_Count, by (ENUM_NO1)
rename Join_Count UnhealthyOutlets_3km
rename ENUM_NO1 ed
save "`datapath'\UnhealthyOutlets_3kmBuffer_perED.dta"

clear

import excel "`datapath'\HealthyOutletsin3km.xlsx", sheet("HealthyOutletsin3km") firstrow
collapse (sum) Join_Count, by (ENUM_NO1)
rename Join_Count HealthyOutlets_3km
rename ENUM_NO1 ed
save "`datapath'\HealthyOutlets_3kmBuffer_perED.dta"

clear

use "`datapath'\Combined_EDs_02.dta"
merge 1:1 ed using "`datapath'\UnhealthyOutlets_1kmBuffer_perED.dta"
drop _merge

merge 1:1 ed using "`datapath'\UnhealthyOutlets_3kmBuffer_perED.dta"
drop _merge

merge 1:1 ed using "`datapath'\HealthyOutlets_1kmBuffer_perED.dta"
drop _merge

merge 1:1 ed using "`datapath'\HealthyOutlets_3kmBuffer_perED.dta"
drop _merge

gen density_H_1km = HealthyOutlets_1km / 3.141593
gen density_H_3km = HealthyOutlets_3km / 28.274334
gen density_UH_1km = UnhealthyOutlets_1km / 3.141593
gen density_UH_3km = UnhealthyOutlets_3km / 28.274334

save "`datapath'\Combined_EDs_02.dta", replace

clear

import excel "`datapath'\ED_Barbados_Centroids_Buffer.xlsx", sheet("ED_Barbados_Centroids_Buffer") firstrow
keep ENUM_NO1 Area PopulationDensity
rename ENUM_NO1 ed

save "`datapath'\ED_Area.dta"'

clear


use "`datapath'\Combined_EDs_02.dta"
merge 1:1 ed using "`datapath'\ED_Area.dta"
drop _merge

order Outlets_3km Outlets_1km, after (SES)

gen density_H_ED = Healthy / Area
gen density_UH_ED = Unhealthy / Area

save "`datapath'\Combined_EDs_02.dta", replace

export excel using "`datapath'\Combined_EDs_02.xls", firstrow(variables)

clear



use "`datapath'\Combined_EDs_02.dta"
label variable ed "Enumeration District"
recast float ed
save "`datapath'\Combined_EDs_02.dta", replace

merge m:1 ed using "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\HoTN\hotn_v41_sw.dta"
drop _merge

save "`datapath'\Combined_EDs_03.dta"


