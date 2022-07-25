* HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    FoodDeserts_Buffers.do
    //  project:				    Foodscapes - Food deserts
    //  analysts:				    Ian HAMBLETON, STEPHANIE WHITEMAN
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
	*capture log close
	*log using "`logpath'\FoodDeserts_Buffers, replace
** HEADER -----------------------------------------------------


** ------------------------------------------------------------------------------------
** PART 1.  Create Food Desert Classification for the BRB EDs
**          Have saved data files after running - so commented out to speed up DO file
** ------------------------------------------------------------------------------------
** NOTE:    UNIQUE ID NUMBER VARIABLE NAMES VARY BETWEEN FILES - check why this happens  
**          ANOTHER POSSIBLE REASON WHY BUFFERS DIFFERED in original graphic
** ------------------------------------------------------------------------------------

tempfile all Tfd1 Tfd2 Tfd3 Tfd4 Tfd5 Tfd6 Tfd7 Tfd8 Tfd9 Tfd10

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
 gen out2 = 0
 replace oid = 200000 if oid==33463 & ed==232 
keep oid out2
 save `Tfd2', replace
 
  
/// ** 2km buffer
import excel using "`datapath'\buildings_in_2kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out3 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out3
save `Tfd3', replace


/// ** 2.5km buffer
import excel using "`datapath'\buildings_in_2_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out4 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out4
save `Tfd4', replace


/// ** 3km buffer
import excel using "`datapath'\buildings_in_3kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out5 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out5 
save `Tfd5', replace

/// ** 3.5km buffer
import excel using "`datapath'\buildings_in_3_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out6 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out6
save `Tfd6', replace

/// ** 4km buffer
import excel using "`datapath'\buildings_in_4kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out7 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out7
save `Tfd7', replace


/// ** 4.5km buffer
import excel using "`datapath'\buildings_in_4_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out8 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out8
save `Tfd8', replace


/// ** 5km buffer
import excel using "`datapath'\buildings_in_5kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out9 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out9
save `Tfd9', replace


/// ** 10km buffer
import excel using "`datapath'\buildings_in_10kmBuffer.xlsx" , first clear
rename OBJECTID_1 oid 
rename ENUM_NO1 ed
gen out10 = 0
replace oid = 200000 if oid==33463 & ed==232 
keep oid out10 
save `Tfd10', replace



/// 
/// ** Merge Buffers with denominator file
/// ** And save a dataset to file - we can then comment out the section
use `all', clear
merge 1:1 oid using `Tfd1'
drop _merge
merge 1:1 oid using `Tfd2'
drop _merge
merge 1:1 oid using `Tfd3'
drop _merge
merge 1:1 oid using `Tfd4'
drop _merge
merge 1:1 oid using `Tfd5'
drop _merge
merge 1:1 oid using `Tfd6'
drop _merge
merge 1:1 oid using `Tfd7'
drop _merge
merge 1:1 oid using `Tfd8'
drop _merge
merge 1:1 oid using `Tfd9'
drop _merge
merge 1:1 oid using `Tfd10'
drop _merge


save "`datapath'\merged_buffers" , replace



** ***************************************************
** PART 2. Calculate the food desert indicators
** ***************************************************
use  "`datapath'\merged_buffers" , replace
gen denom = 1
** -Tfd- variables. 0=within-buffer. 1=outside-buffer
forval x=1(1)10 {
    replace out`x' = 1 if out`x'==. 
    }
collapse (sum) denom out1 out2 out3 out4 out5 out6 out7 out8 out9 out10 , by(ed) 
forval x=1(1)10 {
    gen pout`x'= (out`x'/denom) * 100
    gen Tfd`x' = 0
    replace Tfd`x' = 1 if pout`x' > 33.333
    }
save "`datapath'\FoodDesert_buffers" , replace


** ***************************************************
** PART 3. Prepare MAP files
** ***************************************************
** Load the Barbados ED shapefile and convert to Stata formats
** Then load our converted shapefile
** ***************************************************
spshape2dta "`shapepath'\ED_Barbados.shp", replace saving(FD_buffers_EDs)
use FD_buffers_EDs_shp, clear

** Merge with attributes file
merge m:1 _ID using FD_buffers_EDs 
drop _merge 
keep _ID _X _Y rec_header shape_order 
save FD_buffers_EDs_shp.dta, replace

** Merge the dataset with Food-Desert characteristics file  
** We will add in the Desert classifications to this dataset
use FD_buffers_EDs, clear
rename ENUM_NO1 ed
merge 1:1 ed using "`datapath'\FoodDesert_buffers"
keep if _merge==3
drop _merge 
drop Buff* k Inside* Outside* Food* out*

label variable Tfd1 "Desert_1km"
label variable Tfd2 "Desert_1.5km"
label variable Tfd1 "Deserts - 1km buffer"
label variable Tfd2 "Deserts - 1.5km buffer"
label variable Tfd3 "Deserts - 2km buffer"
label variable Tfd4 "Deserts - 2.5km buffer"
label variable Tfd5 "Deserts - 3km buffer"
label variable Tfd6 "Deserts - 3.5km buffer"
label variable Tfd7 "Deserts - 4km buffer"
label variable Tfd8 "Deserts - 4.5km buffer"
label variable Tfd9 "Deserts - 5km buffer"
label variable Tfd10 "Deserts - 10km buffer"
label variable pout1 "Percent Outside 1km buffer"
label variable pout2 "Percent Outside 1.5km buffer"
label variable pout3 "Percent Outside 2km buffer"
label variable pout4 "Percent Outside 2.5km buffer"
label variable pout5 "Percent Outside 3km buffer"
label variable pout6 "Percent Outside 3.5km buffer"
label variable pout7 "Percent Outside 4km buffer"
label variable pout8 "Percent Outside 4.5km buffer"
label variable pout9 "Percent Outside 5km buffer"
label variable pout10 "Percent Outside 10km buffer"

rename ed ENUM_NO1

save "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\ArcGIS\Paper1_ Deserts_Swamps\FD_buffers_EDs.dta"




** generate a local for the ColorBrewer color scheme
/*colorpalette Spectral, n(11) nograph
local list r(p) 
local desert `r(p2)'
local nondesert `r(p10)'


** ***************************************************
** BARBADOS ED LAYER. FOOD DESERT MAPS
** Maps at 1km, 2km, 3km buffers
** ***************************************************
/*forval x = 1(1)10 {
    #delimit ; 
    spmap Tfd`x' using FD_buffers_EDs_shp, replace
        ,
        
        id(_ID)
        ocolor(gs14 ..) fcolor("`nondesert'*0.75" "`desert'*0.75" ) osize(0.04 ..)  
        legend(pos(2) size(*1.5) 
            label(3 "Low Access (Food desert)")
            label(2 "Higher access")
            ) 
        legstyle(0) 
        name(brb_fd`x')
       saving("`outputpath'/FoodDesert_buffers`x'", replace)
        ;
    #delimit cr
    //graph export "`outputpath'/FoodDesert_buffers`x'.png", replace width(1500)
}

/*
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
