* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    Proximity.do
    //  project:				    Foodscapes
    //  analysts:				    STEPHANIE WHITEMAN, IAN HAMBLETON
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
    log using "`logpath'\Proximity", replace
** HEADER -----------------------------------------------------

** ***************************************************
** PART 1. Import dataset containing restaurants and food stores
** ***************************************************
import excel "`datapath'\FoodOutletswithEDs_TableToExcel.xlsx", sheet("FoodOutletswithEDs_TableToExcel") firstrow clear

drop Healthy

encode Category , gen (OUTLET_Cat)
replace OUTLET_Cat=5 if OUTLET_Cat==10 

gen Healthy=0
replace Healthy=1 if OUTLET_Cat == 2 | OUTLET_Cat == 6 | OUTLET_Cat == 7
label variable Healthy "Healthy"

** save table to export to ArcGIS
export delimited using "FoodOutletswithEDs_clean", replace // export this to ArcGIS to determine distance from Healthy and Unhealty




******************************************************************************
** PART 3. Distance from center of each ED to the nearest Unhealthy food outlet
// imported from ArcGIS
******************************************************************************

import excel "`datapath'\EDsToUnhealthy.xlsx", sheet("EDsToUnhealthy") firstrow clear

encode PARISHNAM1, gen (PARISH)


drop ENUM_NO1_1 ENUM_NO1_1 Buff1 Buff2 Buff3 k InsideBuff OutsideBuf InsideBu_1 OutsideB_1 InsideBu_2 OutsideB_2 FoodDesert FoodDese_1 FoodDese_2 ENUM_NO1_2 Buff1_1 Buff2_1 Buff3_1 k_1 InsideBu_3 OutsideB_3 InsideBu_4 OutsideB_4 InsideBu_5 OutsideB_5 FoodDese_3 FoodDese_4 FoodDese_5

label variable NEAR_DIST "Distance_Unhealthy"
rename NEAR_DIST Distance_Unhealthy

save "`datapath'\DistanceUnhealthy.dta", replace



******************************************************************************
** PART 4. Distance from center of each ED to the nearest Healthy food outlet
// imported from ArcGIS
******************************************************************************
import excel "`datapath'\EDsToHealthy.xlsx", sheet("EDsToHealthy") firstrow clear
drop ENUM_NO1_1 ENUM_NO1_1 Buff1 Buff2 Buff3 k InsideBuff OutsideBuf InsideBu_1 OutsideB_1 InsideBu_2 OutsideB_2 FoodDesert FoodDese_1 FoodDese_2 ENUM_NO1_2 Buff1_1 Buff2_1 Buff3_1 k_1 InsideBu_3 OutsideB_3 InsideBu_4 OutsideB_4 InsideBu_5 OutsideB_5 FoodDese_3 FoodDese_4 FoodDese_5
encode PARISHNAM1, gen (PARISH)
label variable NEAR_DIST "Distance_Healthy"
rename NEAR_DIST Distance_Healthy
save "`datapath'\DistanceHealthy.dta", replace


************************************************************************************
** PART 5. Merging datasets with distances to Healthy and Unhealthy food outlets per ED
****************************************************************************************
merge 1:1 ENUM_NO1 using "`datapath'\DistanceUnhealthy.dta"
drop OBJECTID_1 _merge
save "`datapath'\DistancetoFoodOutlets.dta", replace

