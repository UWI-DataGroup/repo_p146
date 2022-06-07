* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    choropleth_SW_tester.do
    //  project:				    WHO Global Health Estimates
    //  analysts:				    Ian HAMBLETON, STEPHANIE WHITEMAN
    // 	date last modified	    	07-June-2022
    //  algorithm task			    

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
    local logpath "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p146\04_TechDocs"

    ** REPORTS and Other outputs
    local outputpath "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p146\05_Outputs"

    ** SHAPEFILES
    local shapepath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\Shapefiles"

    ** Close any open log file and open a new log file
	capture log close
	log using "`logpath'\choropleth_SW_tester", replace
** HEADER -----------------------------------------------------


** ------------------------------------------------------------------------------------
** PART 1.  Create Food Desert Classification for the BRB EDs
**          Have saved data files after running - so commented out to speed up DO file
** ------------------------------------------------------------------------------------
** NOTE:    UNIQUE ID NUMBER VARIABLE NAMES VARY BETWEEN FILES - check why this happens  
**          ANOTHER POSSIBLE REASON WHY BUFFERS DIFFERED in original graphic
** ------------------------------------------------------------------------------------

tempfile all Tfd1 Tfd15 Tfd2 Tfd25 Tfd3 Tfd35 Tfd4 Tfd45 Tfd5 Tdf10

import excel using "`datapath'\buildingcentroids_withED_TableToExcel.xlsx" , first clear
rename OBJECTID oid 
rename ENUM_NO1 ed
rename PARISHNAM1 parish
keep oid ed parish 
///     ** OID 33463 = duplicate (check this). Temporary fix
 bysort oid : gen dups = _n
 replace oid = 200000 if oid==33463 & ed==232 & dups == 2
drop dups
save `all', replace



/// ** 1km buffer
import excel using "`datapath'\buildings_in_1kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
 rename ENUM_NO1 ed
 gen out1 = 0
 replace oid = 200000 if oid==33463 & ed==232 
keep oid out1 
 save `Tfd1', replace

 
 // ** 1.5km buffer
 import excel using "`datapath'\buildings_in_1_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
 rename ENUM_NO1 ed
 gen out1 = 0
 replace oid = 200000 if oid==33463 & ed==232 
keep oid out1 
 save `Tfd15', replace
 
  
/// ** 2km buffer
import excel using "`datapath'\buildings_in_2kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out2 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out2 
save `Tfd2', replace


/// ** 2.5km buffer
import excel using "`datapath'\buildings_in_2_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out2 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out2 
save `Tfd25', replace


/// ** 3km buffer
import excel using "`datapath'\buildings_in_3kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out3 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out3 
save `Tfd3', replace

/// ** 3.5km buffer
import excel using "`datapath'\buildings_in_3_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out3 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out3 
save `Tfd35', replace

/// ** 4km buffer
import excel using "`datapath'\buildings_in_4kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out3 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out3 
save `Tfd4', replace


/// ** 4.5km buffer
import excel using "`datapath'\buildings_in_4_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out3 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out3 
save `Tfd45', replace


/// ** 5km buffer
import excel using "`datapath'\buildings_in_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out3 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out3 
save `Tfd5', replace


/// ** 10km buffer
import excel using "`datapath'\buildings_in_10kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out3 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out3 
save `Tfd10', replace



/// 
/// ** Merge Buffers with denominator file
/// ** And save a dataset to file - we can then comment out the section
use `all', clear
merge 1:1 oid using `Tfd1'
drop _merge
merge 1:1 oid using `Tfd15'
drop _merge
merge 1:1 oid using `Tfd2'
drop _merge
merge 1:1 oid using `Tfd25'
drop _merge
merge 1:1 oid using `Tfd3'
drop _merge
merge 1:1 oid using `Tfd35'
drop _merge
merge 1:1 oid using `Tfd4'
drop _merge
merge 1:1 oid using `Tfd45'
drop _merge
merge 1:1 oid using `Tfd5'
drop _merge
merge 1:1 oid using `Tfd10'
drop _merge


save "`datapath'\Testerbrb_out" , replace



** ***************************************************
** PART 2. Calculate the food desert indicators
** ***************************************************
use  "`datapath'\Testerbrb_out" , replace
gen denom = 1
** -Tfd- variables. 0=within-buffer. 1=outside-buffer
forval x=1(1)10 {
    replace out`x' = 1 if out`x'==. 
    }
collapse (sum) denom out1 out15 out2 out25 out3 out35 out4 out45 out5 out10 , by(ed) 
forval x=1(1)10 {
    gen pout`x'= (out`x'/denom) * 100
    gen Tfd`x' = 0
    replace Tfd`x' = 1 if pout`x' > 33.333
    }
save "`datapath'\Testerbrb_fd" , replace


** ***************************************************
** PART 3. Prepare MAP files
** ***************************************************
** Load the Barbados ED shapefile and convert to Stata formats
** Then load our converted shapefile
** ***************************************************
spshape2dta "`shapepath'\ED_Barbados.shp", replace saving(Testerbrb_ed)
use Testerbrb_ed_shp, clear

** Merge with attributes file
merge m:1 _ID using Testerbrb_ed 
drop _merge 
keep _ID _X _Y rec_header shape_order 
save Testerbrb_shp.dta, replace

** Merge the dataset with Food-Desert characteristics file  
** We will add in the Desert classifications to this dataset
use Testerbrb_ed, clear
rename ENUM_NO1 ed
merge 1:1 ed using "`datapath'\Testerbrb_fd"
keep if _merge==10
drop _merge 
drop Buff* k Inside* Outside* Food* out*
save Testerbrb_ed, replace


** generate a local for the ColorBrewer color scheme
colorpalette Spectral, n(11) nograph
local list r(p) 
local desert `r(p2)'
local nondesert `r(p10)'


** ***************************************************
** BARBADOS ED LAYER. FOOD DESERT MAPS
** Maps at 1km, 2km, 3km buffers
** ***************************************************
forval x = 1(1)3 {
    #delimit ; 
    spmap Tfd`x' using Testerbrb_ed_shp
        ,
        fysize(100) 
        id(_ID)
        ocolor(gs14 ..) fcolor("`nondesert'*0.75" "`desert'*0.75" ) osize(0.04 ..)  
        legend(pos(2) size(*1.5) 
            label(3 "Low Access (Food desert)")
            label(2 "Higher access")
            ) 
        legstyle(0) 
        name(brb_fd`x')
        saving("`outputpath'/Testerbrb_fd`x'", replace)
        ;
    #delimit cr
    graph export "`outputpath'/Testerbrb_fd`x'.png", replace width(1500)
}

** Post MAPS to PDF
** ------------------------------------------------------
** PDF REGIONAL REPORT (COUNTS OF CONFIRMED CASES)
** ------------------------------------------------------
    putpdf begin, pagesize(letter) landscape font("Calibri Light", 10) margin(top,0.5cm) margin(bottom,0.25cm) margin(left,0.5cm) margin(right,0.25cm)
    putpdf paragraph ,  font("Calibri Light", 16)
    putpdf text ("Barbados: Food Desert Maps. ") , bold
    putpdf table f1 = (2,3), width(100%) border(all,nil) halign(center)
    putpdf table f1(1,1)=("(A) 1km buffer"), font("Calibri Light", 14)
    putpdf table f1(2,1)=image("`outputpath'/brb_fd1.png")
    putpdf table f1(1,2)=("(B) 2km buffer"), font("Calibri Light", 14)
    putpdf table f1(2,2)=image("`outputpath'/brb_fd2.png")
    putpdf table f1(1,3)=("(C) 3km buffer"), font("Calibri Light", 14)
    putpdf table f1(2,3)=image("`outputpath'/brb_fd3.png")
** Save the PDF
    local c_date = c(current_date)
    local date_string = subinstr("`c_date'", " ", "", .)
    putpdf save "`outputpath'/BRB_food_deserts_`date_string'", replace    
