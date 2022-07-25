** CHANGE THIS FOR RE-RUN ON NEW COMPUTER	
    cd "C:\Users\steph\The University of the West Indies\DataGroup - repo_data\data_p146\version01\ArcGIS\Paper1_ Deserts_Swamps"

** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
	capture log close
	log using "Paper1_Deserts.smcl", replace

**  GENERAL DO-FILE COMMENTS
//  project:      PhD - Paper 1 - Food Deserts and Food Swamps
//  author:       WHITEMAN \ 30-APR-2022
//  description:  Data Analysis for determining food deserts in Barbados

** DO-FILE SECTION 01 (Cleaning dataset obtained from ArcGIS)
use "C:\Users\steph\The University of the West Indies\DataGroup - repo_data\data_p146\version01\ArcGIS\Paper1_ Deserts_Swamps\AllBuildingsbyED.dta"

encode PARISHNAM1, generate (PARISH)
order PARISH, after (PARISHNAM1)

encode Healthy_vs_Unhealthy_Food_store, generate (FOODSTORE_HEALTHY)
order FOODSTORE_HEALTHY, after ( Healthy_vs_Unhealthy_Food_store)
label variable FOODSTORE_HEALTHY "Healthy vs Unhealthy Food store"

encode Category, generate (FOODSTORE_TYPE)
order FOODSTORE_TYPE, after (Category)
replace FOODSTORE_TYPE=3 if FOODSTORE_TYPE==8
label variable FOODSTORE_TYPE "Type of Food Store"

encode Parish, generate (STORE_PARISH)
order STORE_PARISH, after (Parish)


** DO-FILE SECTION 02 (Identifying buffers for Healthy food stores)
generate HEALTHY_STORE_BUFFER=.
replace HEALTHY_STORE_BUFFER = 1 if FOODSTORE_HEALTHY==1 & FID_Food_stores_buffer !=.
label variable HEALTHY_STORE_BUFFER "Buildings that fall within the 1000m buffer of a healthy food store"

** DO-FILE SECTION 03 (Identifying buildings that fall outside the Healthy food store buffer)

generate OUTSIDE_Buffer=.
replace OUTSIDE_Buffer=1 if HEALTHY_STORE_BUFFER !=1
label variable OUTSIDE_Buffer "Buildings that fall outside the 1000m buffer"

preserve

** DO-FILE SECTION 04 (Calculating the sum of buildings inside and outside the buffer of healthy food stores)
gen k=1
bysort OBJECTID: egen denom=sum(k)
collapse (sum) HEALTHY_STORE_BUFFER OUTSIDE_Buffer k, by(OBJECTID)

** DO-FILE SECTION 05 (Identifying food deserts by ED based on USDA definition of at least 33% of the population living outside of the healthy food store buffer)

gen PercentOutside = OUTSIDE_Buffer/ k *100 // percentage of building that fall outside of the buffer

gen FoodDesert=.
replace FoodDesert = 1 if PercentOutside >=33.0 
replace FoodDesert = 0 if PercentOutside <33.0
codebook FoodDesert // 394 Food Deserts identified. 

restore