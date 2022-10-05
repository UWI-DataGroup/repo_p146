** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataAnalysis_Access_01
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	20-August-2022
    //  algorithm task			    Explorinmg the relationship between Access, proximity and consumption

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
** PART 1 : Merging Health of the Nation Data with the ED combined dataset
** ----------------------------------------------------------------------------------

use "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\HoTN\hotn_v41_sw.dta"
merge m:1 ed using "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\ArcGIS\Paper1_ Deserts_Swamps\Combined_EDs_01.dta"
drop _merge

**------------------------------------------------------------------------------------------
** PART 2: Generating New Variables
**------------------------------------------------------------------------------------------

** Distance Ratio - Continous
gen DistanceRatio= Distance_Unhealthy / Distance_Healthy


** Distance Ratio- Binary (0 = "bad" , 1="good")

gen DistanceRatio_Bi=.
replace DistanceRatio_Bi = 0 if DistanceRatio <1 // unhealthy outlets are closer than healthy - BAD
replace DistanceRatio_Bi = 1 if DistanceRatio >=1 & DistanceRatio <. // unhealthy outlets are further away than healthy - GOOD



** Weekly fruit serving
gen fruitserv_wk = .
replace fruitserv_wk = fruit* fruit_s

** Daily Fruit serving
gen fruitserv_day =.
replace fruitserv_day = fruitserv_wk/7

** Weekly veg serving
gen vegserv_wk = .
replace vegserv_wk = veg* veg_s

** Daily Veg serving
gen vegserv_day =.
replace vegserv_day = vegserv_wk/7

** Combined Daily Fruit and Veg servings
egen servings = rowtotal(fruitserv_day vegserv_day) if vegserv_day !=. & fruitserv_day !=.
label variable servings "combined daily fruit and veg servings"


** Inadequate Fruit and Veg intake
gen fv5 = .
replace fv5 = 0 if servings >=5 & servings <.
replace fv5 = 1 if servings < 5
label variable fv5 "inadequate fruit and veg consumption"
label define fv5 0 "adequate fruit and veg" 1 "inadequate fruit and veg"


**------------------------------------------------------------------------------------------------------------
** PART 3: Exploring the relationship between Fruit and Veg intake and the distance to Healthy and Unhealthy food stores

** Outcome = Fruit and Veg intake
** Predictor = Distance
**--------------------------------------------------------------------------------------------------------------
 
 replace Distance_Healthy = Distance_Healthy/100
 replace Distance_Unhealthy = Distance_Unhealthy/100

logistic fv5 Distance_Healthy // Odds ratio 1.0 | p-value 0.044 | 95% CI 1.0 - 1.0
logistic fv5 Distance_Unhealthy 
logistic fv5 DistanceRatio // Odds ratio 0.74 | p-value 0.033 | 95% CI 0.56 - 0.97

regress servings Distance_Healthy
regress servings Distance_Unhealthy
regress servings DistanceRatio


regress fruitserv_wk Distance_Healthy
regress fruitserv_day Distance_Healthy
regress vegserv_wk Distance_Healthy
regress vegserv_day Distance_Healthy

regress fruitserv_wk Distance_Unhealthy
regress fruitserv_day Distance_Unhealthy
regress vegserv_wk Distance_Unhealthy
regress vegserv_day Distance_Unhealthy

regress fruitserv_wk DistanceRatio
regress fruitserv_day DistanceRatio
regress vegserv_wk DistanceRatio
regress vegserv_day DistanceRatio


logistic fv5 DistanceRatio_Bi // Odds Ratio 1.7 | p-value 0.004 | 95% CI 1.18,2.46
regress fruitserv_wk DistanceRatio_Bi
regress fruitserv_day DistanceRatio_Bi
regress vegserv_wk DistanceRatio_Bi // Odds Ratio -0.84 |p-value 0.041 | 95% CI -1.65, -0.033
regress vegserv_day DistanceRatio_Bi // Odds ratio -0.12 | p-value 0.041 |95% CI -0.23, -0.004
regress servings DistanceRatio_Bi // Odds Ration - 0.28 | p-value 0.019 | 95% CI -0.58, -0.046

