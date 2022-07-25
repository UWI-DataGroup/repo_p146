clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		NEMS Stores
**  Project:      	NEMS
**	Date Created:	04/01/2022
**  Algorithm Task: Preliminary Analysis of NEMS Stores - Inter-rater Reliability


** DO-FILE SET UP COMMANDS
version 17
clear all
macro drop _all
set more 1
set linesize 150



* Current OS 
local datapath "C:\Users\steph\OneDrive\Documents\NEMS"

*Load dataset
use "C:\Users\steph\OneDrive\Documents\NEMS\NEMS_Stores.dta"


**------------------------------------------------------------------------**
** SECTION 1: PREPARING THE DATA SET
**------------------------------------------------------------------------**
encode storeid, gen(StoreID)
encode datacollector , gen(DataCollector)

codebook DataCollector
gen Rater=.
replace Rater=1 if DataCollector==1
replace Rater=2 if DataCollector==2
replace Rater=2 if DataCollector==3
replace Rater=2 if DataCollector==4
replace Rater=3 if DataCollector==5
replace Rater=4 if DataCollector==6
replace Rater=5 if DataCollector==7
replace Rater=5 if DataCollector==8
replace Rater=6 if DataCollector==9
label define Rater 1 "Rater 1" 2 "Rater 2" 3 "Rater 3" 4 "Rater 4" 5 "Rater 5" 6 "Rater 6"
label values Rater Rater

**-----------------------------------------------------------------------**
** SECTION 2: CONDENSING DATA SET
**-----------------------------------------------------------------------**
preserve

keep Rater DataCollector StoreID store_type cash_registers a_fruits variety_fruits a_vegetables variety_veg a_roots_tubers variety_rootsandtubers a_milk variety_milk a_cereal varieties_cereal a_rice varieties_rice a_pasta variety_pasta a_flour varieties_flour a_canveg var_canbeans var_lscanbeans varieties_cannedveg a_canfruit varieties_canfruit a_oil varieties_oils a_chips varieties_chips a_bread variety_bread a_bakedgoods variety_bakedgoods a_beverages variety_beverages a_meat varieties_chickenbreast a_mincedbeef variety_minedmeat a_hotdogs variety_hotdog a_frozenmeals variety_frozenmeals start_time endtime

order StoreID DataCollector Rater start_time endtime


**-------------------------------------------------------------------------**
** SECTION 3: Reshaping Data set
**--------------------------------------------------------------------------**
drop if Rater==. // rater had in one missing observation

drop DataCollector // duplicate of Rater

reshape wide start_time endtime store_type cash_registers a_fruits variety_fruits a_vegetables variety_veg a_roots_tubers variety_rootsandtubers a_milk variety_milk a_cereal varieties_cereal a_rice varieties_rice a_pasta variety_pasta a_flour varieties_flour a_canveg var_canbeans var_lscanbeans varieties_cannedveg a_canfruit varieties_canfruit a_oil varieties_oils a_chips varieties_chips a_bread a_bakedgoods variety_bread variety_bakedgoods a_beverages variety_beverages a_meat varieties_chickenbreast a_mincedbeef variety_minedmeat a_hotdogs variety_hotdog a_frozenmeals variety_frozenmeals, i(StoreID) j(Rater)



**-------------------------------------------------------------------
** SECTION 4: Inter-rater reliability using Cohen's Kappa

** RATER PAIRS : Malik & Rashaad, Eden & Stephanie, Shamika & Tinika
**			   : Rater 2 & Rater 3, Rater 1 & Rater 5, Rater 4 & Rater 6
**-------------------------------------------------------------------


** Kappa for Raters 2 & 3

** Store descriptors
kap store_type2 store_type3 // 95.24%
kap cash_registers2 cash_registers3 //100%


** availability of food items

kap a_fruits2 a_fruits3 // 100%
kap a_vegetables2 a_vegetables3 // 90.38%
kap a_roots_tubers2 a_roots_tubers3 // 100%
kap a_milk2 a_milk3 // 100%
kap a_cereal2 a_cereal3 // 100%
kap a_rice2 a_rice3 // 100%
kap a_pasta2 a_pasta3 // 100%
kap a_flour2 a_flour3 //100%
kap a_canveg2 a_canveg3 //100%
kap a_canfruit2 a_canfruit3 // 100%
kap a_oil2 a_oil3 // 100%
kap a_chips2 a_chips3 // 95.24%
kap a_bread2 a_bread3 //100%
kap a_bakedgoods2 a_bakedgoods3 // 100%
kap a_meat2 a_meat3 // 100%
kap a_mincedbeef2 a_mincedbeef //100%
kap a_hotdogs2 a_hotdogs3 // 100%
kap a_frozenmeals2 a_frozenmeals3 // 90%


/* variety of food items

kap variety_fruits2 variety_fruits3 // 93.33%
kap variety_veg2 variety_veg3 // 76.47%
kap variety_rootsandtubers2 variety_rootsandtubers3 // 81.25%
kap variety_milk2 variety_milk3 // 60%
kap varieties_cereal2 varieties_cereal3 //72.22%
kap varieties_rice2 varieties_rice3 //85%
kap variety_pasta2 variety_pasta3 // 80%
kap varieties_flour2 varieties_flour3 //72.22%
kap var_canbeans2 var_canbeans3 //85.71%
kap varieties_cannedveg2 varieties_cannedveg3 // 85.71%
kap varieties_canfruit2 varieties_canfruit3 // 58.33%
kap varieties_oils2 varieties_oils3 // 70%
kap varieties_chips2 varieties_chips3 //66.67%
kap variety_bread2 variety_bread3 //73.68%
kap variety_bakedgoods2 variety_bakedgoods3 //81.82%
kap variety_beverages2 variety_beverages3 // 66.67%
kap variety_minedmeat2 variety_minedmeat3 // 88.89%
kap variety_hotdog2 variety_hotdog3 // 83.33%
*/


** Kappa for Raters 1 & 5

** Store descriptors
kap store_type1 store_type5 // 100%
kap cash_registers1 cash_registers5 // 100%

** availability of food items
kap a_fruits1 a_fruits5 // 100%
kap a_vegetables1 a_vegetables5 //100%
kap a_roots_tubers1 a_roots_tubers5 // 100%
kap a_cereal1 a_cereal5 //100%
kap a_rice1 a_rice5 // 100%
kap a_canveg1 a_canveg5 // 100%
kap a_canfruit1 a_canfruit5 //100%
kap a_chips1 a_chips5 //100%
kap a_bread1 a_bread5 //100%
kap a_meat1 a_meat5 //100%
kap a_mincedbeef1 a_mincedbeef5 //100%
ap a_hotdogs1 a_hotdogs5 //100%

/*
** variety of food items
kap variety_pasta1 variety_pasta5 // 100%
kap varieties_flour1 varieties_flour5 //100%
kap varieties_oils1 varieties_oils5 //100%
kap variety_minedmeat1 variety_minedmeat5 //50%
*/

** Kappa for Raters 4 & 6

** Store descriptors
kap store_type4 store_type6 // 100%

** availability of food items
kap a_fruits4 a_fruits6 //100%

/*
** variety of food items
kap variety_veg4 variety_veg6 // 50%
*/


restore








