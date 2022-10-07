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
        
**----------------------------------------------------------------------
** PART 3: Creating necessary variables: Predictors, Outcomes and Confounders
**----------------------------------------------------------------------

** PREDICTORS**
    ** Distance Ratio - Continous
         drop DistanceRatio
         gen DistanceRatio= Distance_Unhealthy / Distance_Healthy

    ** Distance Ratio- Binary (0 = "bad" , 1="good")
        drop DistanceRatio_Bi
        gen DistanceRatio_Bi=.
        replace DistanceRatio_Bi = 0 if DistanceRatio <1 // unhealthy outlets are closer than healthy - BAD
        replace DistanceRatio_Bi = 1 if DistanceRatio >=1 & DistanceRatio <. // unhealthy outlets are further away than healthy - GOOD

** OUTCOMES
    **Adequate Fruit and Veg
        gen fv5_adequate = .
        replace fv5_adequate = 1 if servings >=5 & servings <.
        replace fv5_adequate = 0 if servings < 5
        label variable fv5 "adequate fruit and veg consumption"
        label define fv5 1 "adequate fruit and veg" 0 "inadequate fruit and veg"

    ** BMI Calculation
        gen height_meters = height/100
        gen BMI = weight / (height_meters^2)

** CONFOUNDERS
    ** Car
        gen car = .
        replace car = 1 if transport==1
        replace car = 0 if transport==2 | transport==3 | transport==4
    
    ** Sex
        label define sex 1 "Female" 0 "Male", replace
        recode sex 2=0

    ** Education

    ** Age

**--------------------------------------------------------------
** PART 4: REGRESSION ANALYSES
**---------------------------------------------------------------


** 1KM BUFFER - HEALTHY FOOD OUTLETS

** Adequate Fruit and Veg
logistic fv5_adequate HealthyOutlets_1km

logistic fv5_adequate HealthyOutlets_1km car
logistic fv5_adequate HealthyOutlets_1km sex
logistic fv5_adequate HealthyOutlets_1km i.educ

logistic fv5_adequate HealthyOutlets_1km car sex
logistic fv5_adequate HealthyOutlets_1km car i.educ
logistic fv5_adequate HealthyOutlets_1km sex i.educ

logistic fv5_adequate HealthyOutlets_1km car sex i.educ


** Total fruit and veg serving
regress servings HealthyOutlets_1km 

regress servings HealthyOutlets_1km car
regress servings HealthyOutlets_1km sex
regress servings HealthyOutlets_1km i.educ

regress servings HealthyOutlets_1km car sex
regress servings HealthyOutlets_1km car i.educ
regress servings HealthyOutlets_1km sex i.educ

regress servings HealthyOutlets_1km car sex i.educ


** BMI

regress BMI HealthyOutlets_1km 

regress BMI HealthyOutlets_1km car
regress BMI HealthyOutlets_1km sex
regress BMI HealthyOutlets_1km i.educ

regress BMI HealthyOutlets_1km car sex
regress BMI HealthyOutlets_1km car i.educ
regress BMI HealthyOutlets_1km sex i.educ

regress BMI HealthyOutlets_1km car sex i.educ

**-----------------------------------------------------------------------

** 3km BUFFER - HEALTHY OUTLETS

** Adequate Fruit and Veg
logistic fv5_adequate HealthyOutlets_3km

logistic fv5_adequate HealthyOutlets_3km car
logistic fv5_adequate HealthyOutlets_3km sex
logistic fv5_adequate HealthyOutlets_3km i.educ

logistic fv5_adequate HealthyOutlets_3km car sex
logistic fv5_adequate HealthyOutlets_3km car i.educ
logistic fv5_adequate HealthyOutlets_3km sex i.educ

logistic fv5_adequate HealthyOutlets_3km car sex i.educ


** Total fruit and veg serving
regress servings HealthyOutlets_3km 

regress servings HealthyOutlets_3km car
regress servings HealthyOutlets_3km sex
regress servings HealthyOutlets_3km i.educ

regress servings HealthyOutlets_3km car sex
regress servings HealthyOutlets_3km car i.educ
regress servings HealthyOutlets_3km sex i.educ

regress servings HealthyOutlets_3km car sex i.educ


** BMI

regress BMI HealthyOutlets_3km 

regress BMI HealthyOutlets_3km car
regress BMI HealthyOutlets_3km sex
regress BMI HealthyOutlets_3km i.educ

regress BMI HealthyOutlets_3km car sex
regress BMI HealthyOutlets_3km car i.educ
regress BMI HealthyOutlets_3km sex i.educ

regress BMI HealthyOutlets_3km car sex i.educ

**--------------------------------------------------------------------------------

** BUFFER 1KM - UNHEALTHY OUTLETS

** Adequate Fruit and Veg
logistic fv5_adequate UnhealthyOutlets_1km

logistic fv5_adequate UnhealthyOutlets_1km car
logistic fv5_adequate UnhealthyOutlets_1km sex
logistic fv5_adequate UnhealthyOutlets_1km i.educ

logistic fv5_adequate UnhealthyOutlets_1km car sex
logistic fv5_adequate UnhealthyOutlets_1km car i.educ
logistic fv5_adequate UnhealthyOutlets_1km sex i.educ

logistic fv5_adequate UnhealthyOutlets_1km car sex i.educ


** Total fruit and veg serving
regress servings UnhealthyOutlets_1km 

regress servings UnhealthyOutlets_1km car
regress servings UnhealthyOutlets_1km sex
regress servings UnhealthyOutlets_1km i.educ

regress servings UnhealthyOutlets_1km car sex
regress servings UnhealthyOutlets_1km car i.educ
regress servings UnhealthyOutlets_1km sex i.educ

regress servings UnhealthyOutlets_1km car sex i.educ


** BMI

regress BMI UnhealthyOutlets_1km 

regress BMI UnhealthyOutlets_1km car
regress BMI UnhealthyOutlets_1km sex
regress BMI UnhealthyOutlets_1km i.educ

regress BMI UnhealthyOutlets_1km car sex
regress BMI UnhealthyOutlets_1km car i.educ
regress BMI UnhealthyOutlets_1km sex i.educ

regress BMI UnhealthyOutlets_1km car sex i.educ

**----------------------------------------------------------------------------------
** BUFFER 3KM - UNHEALTHY OUTLETS

** Adequate Fruit and Veg
logistic fv5_adequate UnhealthyOutlets_3km

logistic fv5_adequate UnhealthyOutlets_3km car
logistic fv5_adequate UnhealthyOutlets_3km sex
logistic fv5_adequate UnhealthyOutlets_3km i.educ

logistic fv5_adequate UnhealthyOutlets_3km car sex
logistic fv5_adequate UnhealthyOutlets_3km car i.educ
logistic fv5_adequate UnhealthyOutlets_3km sex i.educ

logistic fv5_adequate UnhealthyOutlets_3km car sex i.educ


** Total fruit and veg serving
regress servings UnhealthyOutlets_3km 

regress servings UnhealthyOutlets_3km car
regress servings UnhealthyOutlets_3km sex
regress servings UnhealthyOutlets_3km i.educ

regress servings UnhealthyOutlets_3km car sex
regress servings UnhealthyOutlets_3km car i.educ
regress servings UnhealthyOutlets_3km sex i.educ

regress servings UnhealthyOutlets_3km car sex i.educ


** BMI

regress BMI UnhealthyOutlets_3km 

regress BMI UnhealthyOutlets_3km car
regress BMI UnhealthyOutlets_3km sex
regress BMI UnhealthyOutlets_3km i.educ

regress BMI UnhealthyOutlets_3km car sex
regress BMI UnhealthyOutlets_3km car i.educ
regress BMI UnhealthyOutlets_3km sex i.educ

regress BMI UnhealthyOutlets_3km car sex i.educ

**------------------------------------------------------------------------------------
** DISTANCE TO HEALTHY

*ADEQUATE FRUIT AND VEG INTAKE
logistic fv5_adequate Distance_Healthy

logistic fv5_adequate Distance_Healthy car
logistic fv5_adequate Distance_Healthy sex
logistic fv5_adequate Distance_Healthy i.educ 

logistic fv5_adequate Distance_Healthy car sex
logistic fv5_adequate Distance_Healthy car i.educ
logistic fv5_adequate Distance_Healthy sex i.educ

logistic fv5_adequate Distance_Healthy car sex i.edu

* TOTAL FRUIT AND VEG SERVINGS

regress servings Distance_Healthy

regress servings Distance_Healthy car
regress servings Distance_Healthy sex
regress servings Distance_Healthy i.educ

regress servings Distance_Healthy car sex
regress servings Distance_Healthy car i.educ
regress servings Distance_Healthy sex i.educ

regress servings Distance_Healthy car sex i.educ


*BMI
regress BMI Distance_Healthy

regress BMI Distance_Healthy car
regress BMI Distance_Healthy sex
regress BMI Distance_Healthy i.educ

regress BMI Distance_Healthy car sex
regress BMI Distance_Healthy car i.educ
regress BMI Distance_Healthy sex i.educ

regress BMI Distance_Healthy car sex i.educ


**----------------------------------------------------------------------------------------
** DISTANCE TO UNHEALTHY

*ADEQUATE FRUIT AND VEG INTAKE
logistic fv5_adequate Distance_Unhealthy

logistic fv5_adequate Distance_Unhealthy car
logistic fv5_adequate Distance_Unhealthy sex
logistic fv5_adequate Distance_Unhealthy i.educ 

logistic fv5_adequate Distance_Unhealthy car sex
logistic fv5_adequate Distance_Unhealthy car i.educ
logistic fv5_adequate Distance_Unhealthy sex i.educ

logistic fv5_adequate Distance_Unhealthy car sex i.edu

* TOTAL FRUIT AND VEG SERVINGS

regress servings Distance_Unhealthy

regress servings Distance_Unhealthy car
regress servings Distance_Unhealthy sex
regress servings Distance_Unhealthy i.educ

regress servings Distance_Unhealthy car sex
regress servings Distance_Unhealthy car i.educ
regress servings Distance_Unhealthy sex i.educ

regress servings Distance_Unhealthy car sex i.educ


*BMI
regress BMI Distance_Unhealthy

regress BMI Distance_Unhealthy car
regress BMI Distance_Unhealthy sex
regress BMI Distance_Unhealthy i.educ

regress BMI Distance_Unhealthy car sex
regress BMI Distance_Unhealthy car i.educ
regress BMI Distance_Unhealthy sex i.educ

regress BMI Distance_Unhealthy car sex i.educ

**--------------------------------------------------------------------------------------------------------
** DISTANCE RATIO BINARY 

*ADEQUATE FRUIT AND VEG INTAKE
logistic fv5_adequate DistanceRatio_Bi

logistic fv5_adequate DistanceRatio_Bi car
logistic fv5_adequate DistanceRatio_Bi sex
logistic fv5_adequate DistanceRatio_Bi i.educ 

logistic fv5_adequate DistanceRatio_Bi car sex
logistic fv5_adequate DistanceRatio_Bi car i.educ
logistic fv5_adequate DistanceRatio_Bi sex i.educ

logistic fv5_adequate DistanceRatio_Bi car sex i.edu

* TOTAL FRUIT AND VEG SERVINGS

regress servings DistanceRatio_Bi

regress servings DistanceRatio_Bi car
regress servings DistanceRatio_Bi sex
regress servings DistanceRatio_Bi i.educ

regress servings DistanceRatio_Bi car sex
regress servings DistanceRatio_Bi car i.educ
regress servings DistanceRatio_Bi sex i.educ

regress servings DistanceRatio_Bi car sex i.educ


*BMI
regress BMI DistanceRatio_Bi

regress BMI DistanceRatio_Bi car
regress BMI DistanceRatio_Bi sex
regress BMI DistanceRatio_Bi i.educ

regress BMI DistanceRatio_Bi car sex
regress BMI DistanceRatio_Bi car i.educ
regress BMI DistanceRatio_Bi sex i.educ

regress BMI DistanceRatio_Bi car sex i.educ

** ---------------------------------------------------------------------------------------------
** DISTANCE RATIO

*ADEQUATE FRUIT AND VEG INTAKE
logistic fv5_adequate DistanceRatio

logistic fv5_adequate DistanceRatio car
logistic fv5_adequate DistanceRatio sex
logistic fv5_adequate DistanceRatio i.educ 

logistic fv5_adequate DistanceRatio car sex
logistic fv5_adequate DistanceRatio car i.educ
logistic fv5_adequate DistanceRatio sex i.educ

logistic fv5_adequate DistanceRatio car sex i.edu

* TOTAL FRUIT AND VEG SERVINGS

regress servings DistanceRatio

regress servings DistanceRatio car
regress servings DistanceRatio sex
regress servings DistanceRatio i.educ

regress servings DistanceRatio car sex
regress servings DistanceRatio car i.educ
regress servings DistanceRatio sex i.educ

regress servings DistanceRatio car sex i.educ


*BMI
regress BMI DistanceRatio

regress BMI DistanceRatio car
regress BMI DistanceRatio sex
regress BMI DistanceRatio i.educ

regress BMI DistanceRatio car sex
regress BMI DistanceRatio car i.educ
regress BMI DistanceRatio sex i.educ

regress BMI DistanceRatio car sex i.educ