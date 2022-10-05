** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataAnalysis_Access_01
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	05-Oct-2022
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
    log using "`logpath'\DataAnalysis_Regression_01", replace

    ** PART 1: Importing dataset **

    use "`datapath'\Combined_EDs_03.dta"

   /* ** PART 2: Poisson Regression

    ** Univariate analysis
    poisson fv5 HealthyOutlets_1km
    poisson fv5 HealthyOutlets_3km
    poisson fv5 UnhealthyOutlets_1km
    poisson fv5 UnhealthyOutlets_3km

    poisson fv5 Distance_Healthy
    poisson fv5 Distance_Unhealthy

    poisson fruitserv_wk HealthyOutlets_1km
    poisson fruitserv_wk HealthyOutlets_3km
    poisson fruitserv_wk UnhealthyOutlets_1km
    poisson fruitserv_wk UnhealthyOutlets_3km

    poisson fruitserv_wk Distance_Healthy
    poisson fruitserv_wk Distance_Unhealthy

    poisson vegserv_wk HealthyOutlets_1km
    poisson vegserv_wk HealthyOutlets_3km
    poisson vegserv_wk UnhealthyOutlets_1km
    poisson vegserv_wk UnhealthyOutlets_3km

    poisson vegserv_wk Distance_Healthy
    poisson vegserv_wk Distance_Unhealthy

    ** Adding Confounder
    gen car = .
    replace car = 1 if transport==1
    replace car = 0 if transport==2 | transport==3 | transport==4

    ** Multivariable Analysis with one confounder

    poisson fv5 HealthyOutlets_1km car
    poisson fv5 HealthyOutlets_3km car
    poisson fv5 UnhealthyOutlets_1km car
    poisson fv5 UnhealthyOutlets_3km car

    poisson fv5 Distance_Healthy car
    poisson fv5 Distance_Unhealthy car


    poisson fruitserv_wk HealthyOutlets_1km car
    poisson fruitserv_wk HealthyOutlets_3km car
    poisson fruitserv_wk UnhealthyOutlets_1km car
    poisson fruitserv_wk UnhealthyOutlets_3km car

    poisson fruitserv_wk Distance_Healthy car
    poisson fruitserv_wk Distance_Unhealthy car

    poisson vegserv_wk HealthyOutlets_1km car
    poisson vegserv_wk HealthyOutlets_3km car
    poisson vegserv_wk UnhealthyOutlets_1km car
    poisson vegserv_wk UnhealthyOutlets_3km car

    poisson vegserv_wk Distance_Healthy car
    poisson vegserv_wk Distance_Unhealthy car */
        
** PART 3

** BMI Calculation
gen height_meters = height/100
gen BMI = weight / (height_meters^2)


** Distance Ratio - Continous
gen DistanceRatio= Distance_Unhealthy / Distance_Healthy

** Distance Ratio- Binary (0 = "bad" , 1="good")

gen DistanceRatio_Bi=.
replace DistanceRatio_Bi = 0 if DistanceRatio <1 // unhealthy outlets are closer than healthy - BAD
replace DistanceRatio_Bi = 1 if DistanceRatio >=1 & DistanceRatio <. // unhealthy outlets are further away than healthy - GOOD

** PART 4 **
logistic fv5_adequate DistanceRatio_Bi
logistic fv5_adequate DistanceRatio_Bi car
logistic servings DistanceRatio_Bi
logistic servings DistanceRatio_Bi car
regress servings DistanceRatio_Bi
regress servings DistanceRatio_Bi car
regress BMI DistanceRatio_Bi
regress BMI DistanceRatio_Bi car