* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    FoodSwamps.do
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
	log using "`logpath'\FoodSwamps", replace
** HEADER -----------------------------------------------------

** ***************************************************
** PART 1. Import dataset containing restaurants and food stores
** ***************************************************
import excel "`datapath'\EDswithFoodOutlets_TableToExcel.xlsx", sheet("EDswithFoodOutlets_TableToExcel") firstrow

** ***************************************************
** PART 2. Cleaning data set
** ***************************************************
drop Field13 Field14 Field15 Field16 Field17 Field18 Field19 Field20 Field21 Field22 Field23 Field24 Field25 Field26 Field27 Field28 Field29 Field30 Field31 Field32 Healthy

encode PARISHNAM1, gen (PARISH)
encode Category , gen (OUTLET_Cat)
replace OUTLET_Cat=5 if OUTLET_Cat==10



** ***************************************************
** PART 3. Preparing data set to Calculate the Retail Foood Environment Index (RFEI) and the Modified Retail Food Environment Index (mRFEI) by ED and by Parish

		** Unhealthy = Fast Food / Limited Service + Mini Marts
		** Healthy = Supermarkets / Grocery
*****************************************************

gen Unhealthy=0
replace Unhealthy=1 if OUTLET_Cat == 4 | OUTLET_Cat == 5 | OUTLET_Cat == 8
label variable Unhealthy "Unhealthy - mRFEI"

gen Healthy=0
replace Healthy=1 if OUTLET_Cat == 2 | OUTLET_Cat == 6 | OUTLET_Cat == 7
label variable Healthy "Healthy - mRFEI"




*********************************************************************
** Calculating mRFEI per ED

collapse (sum) Unhealthy Healthy, by (ENUM_NO1)

	** RFEI per ED
	**gen RFEI = Unhealthy1 / Healthy1
	

	** mRFEI per ED

	gen mRFEI = Healthy / (Healthy + Unhealthy)

	gen mRFEI100 = mRFEI * 100 // percentage
	
	
	gen mRFEICat=1 if mRFEI100==.
	replace mRFEICat=2 if mRFEI100==0  // food deserts
	replace mRFEICat=3 if mRFEI100 >0 & mRFEI100 <= 37.6 // food swamps
	replace mRFEICat=4 if mRFEI100 > 37.6 & mRFEI100 <.
	

	label variable mRFEICat "mRFEI Categories"
	label define mRFEI_Categories 1 "No Healthy or Unhealthy Food Outlets" 2 "Food Deserts" 3 "Food Swamps" 4 "Adequate availability of Healthy Food Outlets"
	label values mRFEICat mRFEI_Categories

	
	** Export Dataset
	save "`datapath'\RFEI_mRFEI_EDs.dta", replace
	*export delimited using "`datapath'\RFEI_mRFEI_EDs.csv", replace


**************************************************************************

/** Calculation per Parish
collapse (sum) Unhealthy Healthy, by (PARISH)

	** RFEI per Parish
**	gen RFEI = Unhealthy / Healthy
	
	** mRFEI per Parish

	gen mRFEI = Healthy / (Healthy + Unhealthy)

	gen mRFEI100 = mRFEI * 100 // percentage

	gen mRFEICat=1 if mRFEI100==.
	replace mRFEICat=2 if mRFEI100==0
	replace mRFEICat=3 if mRFEI100 >0 & mRFEI100 <= 37.6
	replace mRFEICat=4 if mRFEI100 > 37.6 & mRFEI100 <.
	
	
	** Export Dataset
export delimited using "`datapath'\\RFEI_mRFEI_Parish.csv", replace*/


*****************************************************************************
** PART 4. Preparing Map Files
*****************************************************************************
	
/** Load the Barbados ED shapefile and convert to Stata formats
spshape2dta "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\Shapefiles\ED_Barbados.shp", replace saving(brb_ed_swamps)
use brb_ed_swamps_shp, clear

** Merge with attributes file
merge m:1 _ID using brb_ed_swamps
drop _merge
keep _ID _X _Y rec_header shape_order
save brb_shp_swamps.dta, replace

** Merge the dataset with Food Swamps characteristics file  
use brb_ed_swamps, clear
merge 1:1 ENUM_NO1 using "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\ArcGIS\Paper1_ Deserts_Swamps\RFEI_mRFEI_EDs"
keep if _merge==3
drop _merge
drop Buff* k Inside* Outside* Food*
drop ENUM_NO1_1 ENUM_NO1_2 k_1
save brb_ed_swamps, replace

********************************************************************************
** PART 5. Food Swamps Maps
********************************************************************************
** generate a local for the ColorBrewer color scheme
colorpalette Spectral, n(11) nograph
local list r(p) 
local swamp `r(p2)'
local NoOutlets `r(p4)'
local NoHealthy `r(p8)'
local nonswamp `r(p10)'

** Map of Food Swamps using mREI Categories (1,2,3,4)
#delimit
grmap mRFEICat ,
	clmethod(custom) clbreaks(0 1 2 3 4)
	title("Modified Retail Food Environment Index" "by Enumeration District")
			legend(on order(2 "No Food Outlets" 3 "No Healthy Food Outlets" 
						4 "Food Swamps" 5 "Greater Availability of Healthy Food Stores") 
			region(lcolor(black)) title(Key, size(small)) position(2))
	legtitle(Legend) legorder(lohi) legstyle(1)
	fcolor(gs15 red yellow green)
;
#delimit cr








