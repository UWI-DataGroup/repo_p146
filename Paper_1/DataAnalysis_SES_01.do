** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataAnalysis_SES_01
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	10-August-2022
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
    log using "`logpath'\DataAnalysis_SES_01", replace

** ----------------------------------------------------------------------------------
** PART 1 : Importing combined dataset
** ----------------------------------------------------------------------------------

    use "`datapath'\Combined_EDs_01.dta"

** -----------------------------------------------------------------------------------------
** PART 2 : Using Tabulate to explore the relationship between Food Deserts and Swamps with SES variables, individually
**        : Outcome variables --> Deserts and Swamps ( buffers, mRFEI100, proximity )
**        : Predictir variables --> SES variables (income, unemployment, vehicle ownership)
** ------------------------------------------------------------------------------------------

** 1km Buffer and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd1==0, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd1==1, stat(p50 p25 p75) col(stat)

** 1.5km Buffer and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd2==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd2==0, stat(p50 p25 p75) col(stat)

** 2km Buffer and SES

tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd3==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd3==0, stat(p50 p25 p75) col(stat)

** 2.5km Buffer and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd4==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd4==0, stat(p50 p25 p75) col(stat)

** 3km Buffer and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd5==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd5==0, stat(p50 p25 p75) col(stat)

** 3.5km Buffer and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd6==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd6==0, stat(p50 p25 p75) col(stat)

** 4km Buffer and SES

tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd7==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd7==0, stat(p50 p25 p75) col(stat)

** 4.5km Buffer and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd8==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd8==0, stat(p50 p25 p75) col(stat)

** 5km Buffer and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd9==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if Tfd9==0, stat(p50 p25 p75) col(stat)

** mRFEI Categories and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if mRFEICat==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if mRFEICat==2, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if mRFEICat==3, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if mRFEICat==4, stat(p50 p25 p75) col(stat)

** Distance to Healthy Food Outlets and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if H_Dis_Cat==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if H_Dis_Cat==2, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if H_Dis_Cat==3, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if H_Dis_Cat==4, stat(p50 p25 p75) col(stat)

** Distance to Unhealth Food Outlets and SES
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if UH_Dis_Cat==1, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if UH_Dis_Cat==2, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if UH_Dis_Cat==3, stat(p50 p25 p75) col(stat)
tabstat t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES if UH_Dis_Cat==4, stat(p50 p25 p75) col(stat)

** -----------------------------------------------------------------------------------------
** PART 3 : Using Logistic regression to explore the relationship between Food Deserts and Swamps with SES variables, individually
**        : Outcome variables --> Deserts and Swamps ( buffers, mRFEI100, proximity )
**        : Predictir variables --> SES variables (income, unemployment, vehicle ownership)
**        //** means the p-value was < 0.05
** ------------------------------------------------------------------------------------------


** Outcome variable: Food Desert at 1km buffer
** Predictor variables : SES variables
logistic Tfd1 t_income_median
logistic Tfd1 t_age_median
logistic Tfd1 hsize_mean
logistic Tfd1 per_t_non_black
logistic Tfd1 per_t_young_age_depend
logistic Tfd1 per_t_old_age_depend
logistic Tfd1 per_htenure_owned // ** Odds ratio :  1.25
logistic Tfd1 per_smother_total // ** Odds ratio : 0.896
logistic Tfd1 per_t_education_tertiary // ** Odds ratio : 1.03
logistic Tfd1 per_t_education_less_secondary // ** Odds ratio : 1.05
logistic Tfd1 per_t_income_0_49
logistic Tfd1 per_t_high_income
logistic Tfd1 per_crime_victim // ** odds ratio : 0.78
logistic Tfd1 per_bathroom_0
logistic Tfd1 per_toilet_presence // ** odds ratio : 0.966  
logistic Tfd1 per_vehicles_0 // ** 
logistic Tfd1 per_electricity
logistic Tfd1 per_amentities_stove
logistic Tfd1 per_amentities_fridge
logistic Tfd1 per_amentities_microwave
logistic Tfd1 per_amentities_wash
logistic Tfd1 per_amentities_tv
logistic Tfd1 per_amentities_radio
logistic Tfd1 per_amentities_computer
logistic Tfd1 per_vehicle_presence // **
logistic Tfd1 per_rooms_less_3 // **
logistic Tfd1 per_bedrooms_less_2
logistic Tfd1 per_renting // **
logistic Tfd1 per_t_unemployment
logistic Tfd1 per_live_5_more
logistic Tfd1 per_t_manage_occupation // **
logistic Tfd1 per_t_prof_occupation // **
logistic Tfd1 per_t_prof_techoccupation // **
logistic Tfd1 per_t_prof_n_techoccupation // **
logistic Tfd1 SES



** Outcome variable: Food Desert at 1.5km buffer 
** Predictor variables : SES variables

logistic Tfd2 t_income_median
logistic Tfd2 t_age_median
logistic Tfd2 hsize_mean //**
logistic Tfd2 per_t_non_black
logistic Tfd2 per_t_young_age_depend
logistic Tfd2 per_t_old_age_depend //** 
logistic Tfd2 per_htenure_owned // ** 
logistic Tfd2 per_smother_total // **
logistic Tfd2 per_t_education_tertiary 
logistic Tfd2 per_t_education_less_secondary // **
logistic Tfd2 per_t_income_0_49
logistic Tfd2 per_t_high_income
logistic Tfd2 per_crime_victim // **
logistic Tfd2 per_bathroom_0
logistic Tfd2 per_toilet_presence // **
logistic Tfd2 per_vehicles_0 // **
logistic Tfd2 per_electricity // **
logistic Tfd2 per_amentities_stove // **
logistic Tfd2 per_amentities_fridge // **
logistic Tfd2 per_amentities_microwave // **
logistic Tfd2 per_amentities_wash
logistic Tfd2 per_amentities_tv // **
logistic Tfd2 per_amentities_radio
logistic Tfd2 per_amentities_computer
logistic Tfd2 per_vehicle_presence 
logistic Tfd2 per_rooms_less_3 // **
logistic Tfd2 per_bedrooms_less_2 // **
logistic Tfd2 per_renting // **
logistic Tfd2 per_t_unemployment
logistic Tfd2 per_live_5_more
logistic Tfd2 per_t_manage_occupation 
logistic Tfd2 per_t_prof_occupation 
logistic Tfd2 per_t_prof_techoccupation // **
logistic Tfd2 per_t_prof_n_techoccupation // **
logistic Tfd2 SES

** Outcome variable: Food Desert at 2km buffer 
** Predictor variables : SES variables

logistic Tfd3 t_income_median
logistic Tfd3 t_age_median
logistic Tfd3 hsize_mean // **
logistic Tfd3 per_t_non_black
logistic Tfd3 per_t_young_age_depend
logistic Tfd3 per_t_old_age_depend 
logistic Tfd3 per_htenure_owned //** 
logistic Tfd3 per_smother_total  // **
logistic Tfd3 per_t_education_tertiary 
logistic Tfd3 per_t_education_less_secondary //**
logistic Tfd3 per_t_income_0_49
logistic Tfd3 per_t_high_income
logistic Tfd3 per_crime_victim //**
logistic Tfd3 per_bathroom_0
logistic Tfd3 per_toilet_presence //**
logistic Tfd3 per_vehicles_0 //**
logistic Tfd3 per_electricity // **
logistic Tfd3 per_amentities_stove //**
logistic Tfd3 per_amentities_fridge // **
logistic Tfd3 per_amentities_microwave //**
logistic Tfd3 per_amentities_wash //**
logistic Tfd3 per_amentities_tv //**
logistic Tfd3 per_amentities_radio
logistic Tfd3 per_amentities_computer // **
logistic Tfd3 per_vehicle_presence 
logistic Tfd3 per_rooms_less_3 //**
logistic Tfd3 per_bedrooms_less_2 // **
logistic Tfd3 per_renting //**
logistic Tfd3 per_t_unemployment
logistic Tfd3 per_live_5_more
logistic Tfd3 per_t_manage_occupation 
logistic Tfd3 per_t_prof_occupation 
logistic Tfd3 per_t_prof_techoccupation //** 
logistic Tfd3 per_t_prof_n_techoccupation //**
logistic Tfd3 SES

** Outcome variable: Food Desert at 2.5km buffer 
** Predictor variables : SES variables

logistic Tfd4 t_income_median
logistic Tfd4 t_age_median
logistic Tfd4 hsize_mean // **
logistic Tfd4 per_t_non_black
logistic Tfd4 per_t_young_age_depend
logistic Tfd4 per_t_old_age_depend //** 
logistic Tfd4 per_htenure_owned //**
logistic Tfd4 per_smother_total //** 
logistic Tfd4 per_t_education_tertiary 
logistic Tfd4 per_t_education_less_secondary //**
logistic Tfd4 per_t_income_0_49
logistic Tfd4 per_t_high_income // **
logistic Tfd4 per_crime_victim //**
logistic Tfd4 per_bathroom_0
logistic Tfd4 per_toilet_presence //**
logistic Tfd4 per_vehicles_0 //**
logistic Tfd4 per_electricity //**
logistic Tfd4 per_amentities_stove //**
logistic Tfd4 per_amentities_fridge //**
logistic Tfd4 per_amentities_microwave //**
logistic Tfd4 per_amentities_wash //** 
logistic Tfd4 per_amentities_tv // **
logistic Tfd4 per_amentities_radio
logistic Tfd4 per_amentities_computer //**
logistic Tfd4 per_vehicle_presence 
logistic Tfd4 per_rooms_less_3
logistic Tfd4 per_bedrooms_less_2 //**
logistic Tfd4 per_renting //**
logistic Tfd4 per_t_unemployment
logistic Tfd4 per_live_5_more
logistic Tfd4 per_t_manage_occupation 
logistic Tfd4 per_t_prof_occupation 
logistic Tfd4 per_t_prof_techoccupation //**
logistic Tfd4 per_t_prof_n_techoccupation //**
logistic Tfd4 SES

** Outcome variable: Food Desert at 3km buffer 
** Predictor variables : SES variables

logistic Tfd5 t_income_median
logistic Tfd5 t_age_median
logistic Tfd5 hsize_mean //**
logistic Tfd5 per_t_non_black //**
logistic Tfd5 per_t_young_age_depend
logistic Tfd5 per_t_old_age_depend //**
logistic Tfd5 per_htenure_owned //**
logistic Tfd5 per_smother_total //**
logistic Tfd5 per_t_education_tertiary 
logistic Tfd5 per_t_education_less_secondary //**
logistic Tfd5 per_t_income_0_49
logistic Tfd5 per_t_high_income 
logistic Tfd5 per_crime_victim //**
logistic Tfd5 per_bathroom_0
logistic Tfd5 per_toilet_presence //**
logistic Tfd5 per_vehicles_0 //**
logistic Tfd5 per_electricity //**
logistic Tfd5 per_amentities_stove //** 
logistic Tfd5 per_amentities_fridge //**
logistic Tfd5 per_amentities_microwave //**
logistic Tfd5 per_amentities_wash //**
logistic Tfd5 per_amentities_tv //**
logistic Tfd5 per_amentities_radio
logistic Tfd5 per_amentities_computer //**
logistic Tfd5 per_vehicle_presence 
logistic Tfd5 per_rooms_less_3
logistic Tfd5 per_bedrooms_less_2 //**
logistic Tfd5 per_renting //**
logistic Tfd5 per_t_unemployment
logistic Tfd5 per_live_5_more
logistic Tfd5 per_t_manage_occupation 
logistic Tfd5 per_t_prof_occupation 
logistic Tfd5 per_t_prof_techoccupation //**
logistic Tfd5 per_t_prof_n_techoccupation
logistic Tfd5 SES

** Outcome variable: Food Desert at 3.5km buffer 
** Predictor variables : SES variables
logistic Tfd6 t_income_median
logistic Tfd6 t_age_median
logistic Tfd6 hsize_mean //**
logistic Tfd6 per_t_non_black 
logistic Tfd6 per_t_young_age_depend
logistic Tfd6 per_t_old_age_depend //**
logistic Tfd6 per_htenure_owned //**
logistic Tfd6 per_smother_total 
logistic Tfd6 per_t_education_tertiary 
logistic Tfd6 per_t_education_less_secondary 
logistic Tfd6 per_t_income_0_49
logistic Tfd6 per_t_high_income 
logistic Tfd6 per_crime_victim //**
logistic Tfd6 per_bathroom_0
logistic Tfd6 per_toilet_presence //**
logistic Tfd6 per_vehicles_0 
logistic Tfd6 per_electricity //**
logistic Tfd6 per_amentities_stove //** 
logistic Tfd6 per_amentities_fridge //**
logistic Tfd6 per_amentities_microwave //**
logistic Tfd6 per_amentities_wash //**
logistic Tfd6 per_amentities_tv //**
logistic Tfd6 per_amentities_radio
logistic Tfd6 per_amentities_computer //**
logistic Tfd6 per_vehicle_presence 
logistic Tfd6 per_rooms_less_3
logistic Tfd6 per_bedrooms_less_2 
logistic Tfd6 per_renting //**
logistic Tfd6 per_t_unemployment
logistic Tfd6 per_live_5_more
logistic Tfd6 per_t_manage_occupation 
logistic Tfd6 per_t_prof_occupation 
logistic Tfd6 per_t_prof_techoccupation //**
logistic Tfd6 per_t_prof_n_techoccupation
logistic Tfd6 SES


** Outcome variable: Food Desert at 4km buffer 
** Predictor variables : SES variables
logistic Tfd7 t_income_median
logistic Tfd7 t_age_median
logistic Tfd7 hsize_mean //**
logistic Tfd7 per_t_non_black
logistic Tfd7 per_t_young_age_depend
logistic Tfd7 per_t_old_age_depend 
logistic Tfd7 per_htenure_owned //**
logistic Tfd7 per_smother_total 
logistic Tfd7 per_t_education_tertiary 
logistic Tfd7 per_t_education_less_secondary 
logistic Tfd7 per_t_income_0_49
logistic Tfd7 per_t_high_income 
logistic Tfd7 per_crime_victim //**
logistic Tfd7 per_bathroom_0
logistic Tfd7 per_toilet_presence //**
logistic Tfd7 per_vehicles_0 
logistic Tfd7 per_electricity //**
logistic Tfd7 per_amentities_stove //** 
logistic Tfd7 per_amentities_fridge //**
logistic Tfd7 per_amentities_microwave //**
logistic Tfd7 per_amentities_wash //**
logistic Tfd7 per_amentities_tv //**
logistic Tfd7 per_amentities_radio
logistic Tfd7 per_amentities_computer 
logistic Tfd7 per_vehicle_presence 
logistic Tfd7 per_rooms_less_3
logistic Tfd7 per_bedrooms_less_2 
logistic Tfd7 per_renting //**
logistic Tfd7 per_t_unemployment
logistic Tfd7 per_live_5_more
logistic Tfd7 per_t_manage_occupation 
logistic Tfd7 per_t_prof_occupation 
logistic Tfd7 per_t_prof_techoccupation //**
logistic Tfd7 per_t_prof_n_techoccupation
logistic Tfd7 SES

** Outcome variable: Food Desert at 4.5km buffer 
** Predictor variables : SES variables

logistic Tfd8 t_income_median
logistic Tfd8 t_age_median
logistic Tfd8 hsize_mean 
logistic Tfd8 per_t_non_black
logistic Tfd8 per_t_young_age_depend
logistic Tfd8 per_t_old_age_depend 
logistic Tfd8 per_htenure_owned //**
logistic Tfd8 per_smother_total 
logistic Tfd8 per_t_education_tertiary 
logistic Tfd8 per_t_education_less_secondary 
logistic Tfd8 per_t_income_0_49
logistic Tfd8 per_t_high_income 
logistic Tfd8 per_crime_victim 
logistic Tfd8 per_bathroom_0
logistic Tfd8 per_toilet_presence 
logistic Tfd8 per_vehicles_0 
logistic Tfd8 per_electricity 
logistic Tfd8 per_amentities_stove 
logistic Tfd8 per_amentities_fridge
logistic Tfd8 per_amentities_microwave 
logistic Tfd8 per_amentities_wash 
logistic Tfd8 per_amentities_tv 
logistic Tfd8 per_amentities_radio
logistic Tfd8 per_amentities_computer 
logistic Tfd8 per_vehicle_presence 
logistic Tfd8 per_rooms_less_3
logistic Tfd8 per_bedrooms_less_2 
logistic Tfd8 per_renting //**
logistic Tfd8 per_t_unemployment
logistic Tfd8 per_live_5_more
logistic Tfd8 per_t_manage_occupation 
logistic Tfd8 per_t_prof_occupation 
logistic Tfd8 per_t_prof_techoccupation 
logistic Tfd8 per_t_prof_n_techoccupation
logistic Tfd8 SES

** Outcome variable: Food Desert at 5km buffer 
** Predictor variables : SES variables
logistic Tfd9 t_income_median
logistic Tfd9 t_age_median
logistic Tfd9 hsize_mean  //**
logistic Tfd9 per_t_non_black
logistic Tfd9 per_t_young_age_depend
logistic Tfd9 per_t_old_age_depend 
logistic Tfd9 per_htenure_owned  //**
logistic Tfd9 per_smother_total 
logistic Tfd9 per_t_education_tertiary 
logistic Tfd9 per_t_education_less_secondary 
logistic Tfd9 per_t_income_0_49
logistic Tfd9 per_t_high_income 
logistic Tfd9 per_crime_victim 
logistic Tfd9 per_bathroom_0
logistic Tfd9 per_toilet_presence 
logistic Tfd9 per_vehicles_0 
logistic Tfd9 per_electricity 
logistic Tfd9 per_amentities_stove 
logistic Tfd9 per_amentities_fridge
logistic Tfd9 per_amentities_microwave 
logistic Tfd9 per_amentities_wash 
logistic Tfd9 per_amentities_tv 
logistic Tfd9 per_amentities_radio
logistic Tfd9 per_amentities_computer 
logistic Tfd9 per_vehicle_presence 
logistic Tfd9 per_rooms_less_3
logistic Tfd9 per_bedrooms_less_2 
logistic Tfd9 per_renting  //**
logistic Tfd9 per_t_unemployment
logistic Tfd9 per_live_5_more
logistic Tfd9 per_t_manage_occupation 
logistic Tfd9 per_t_prof_occupation 
logistic Tfd9 per_t_prof_techoccupation 
logistic Tfd9 per_t_prof_n_techoccupation
logistic Tfd9 SES


// Note : There are no deserts using the 10km buffer

** Outcome variable: Food Desert Buffers
** Predictor variables: Distance to Healthy and Unhealthy Food Outlets

** 1km buffer
logistic Tfd1 Distance_Healthy //**
logistic Tfd1 Distance_Unhealthy //**

** 1.5km buffer
logistic Tfd2 Distance_Healthy //**
logistic Tfd2 Distance_Unhealthy //**

** 2km buffer
logistic Tfd3 Distance_Healthy //**
logistic Tfd3 Distance_Unhealthy //**

** 2.5km buffer
logistic Tfd4 Distance_Healthy //**
logistic Tfd4 Distance_Unhealthy //**

** 3km buffer
logistic Tfd5 Distance_Healthy //**
logistic Tfd5 Distance_Unhealthy //**

** 3.5km buffer
logistic Tfd6 Distance_Healthy //**
logistic Tfd6 Distance_Unhealthy //**

** 4km buffer
logistic Tfd7 Distance_Healthy //**
logistic Tfd7 Distance_Unhealthy //**

** 4.5km buffer
logistic Tfd8 Distance_Healthy //**
logistic Tfd8 Distance_Unhealthy //**

** 5km buffer
logistic Tfd9 Distance_Healthy
logistic Tfd9 Distance_Unhealthy //** 


** Outcome variable: mRFEICat (Modified Food Retail Environment Index- Categories)
**                  1: No Healthy or Unhealhy Food Outlets
**                  2: Food Deserts
**                  3: Food Swamps
**                  4: Adequate availability of Healthy Food Outlets
** Predictor variables: SES variables








** -----------------------------------------------------------------------------------------
** PART 4 : Using Linear regression to explore the relationship between Food Deserts and Swamps with SES variables, individually
**        : Outcome variables --> Deserts and Swamps ( mRFEI100, proximity )
**        : Predictir variables --> SES variables (income, unemployment, vehicle ownership)
** ------------------------------------------------------------------------------------------

** Outcome variable: mRFEI100 (Modified Food Retail Environment Index)
** Predictor variables: SES variables

regress mRFEI100 t_age_median 
regress mRFEI100 t_income_median
regress mRFEI100 hsize_mean
regress mRFEI100 per_t_non_black
regress mRFEI100 per_t_young_age_depend
regress mRFEI100 per_t_old_age_depend
regress mRFEI100 per_htenure_owned
regress mRFEI100 per_smother_total
regress mRFEI100 per_t_education_tertiary
regress mRFEI100 per_t_education_less_secondary
regress mRFEI100 per_t_income_0_49
regress mRFEI100 per_t_high_income
regress mRFEI100 per_crime_victim
regress mRFEI100 per_bathroom_0
regress mRFEI100 per_toilet_presence
regress mRFEI100 per_vehicles_0
regress mRFEI100 per_electricity
regress mRFEI100 per_amentities_stove
regress mRFEI100 per_amentities_fridge
regress mRFEI100 per_amentities_microwave
regress mRFEI100 per_amentities_wash
regress mRFEI100 per_amentities_tv
regress mRFEI100 per_amentities_radio
regress mRFEI100 per_amentities_computer
regress mRFEI100 per_vehicle_presence
regress mRFEI100 per_rooms_less_3
regress mRFEI100 per_bedrooms_less_2
regress mRFEI100 per_renting
regress mRFEI100 per_t_unemployment
regress mRFEI100 per_live_5_more
regress mRFEI100 per_t_manage_occupation
regress mRFEI100 per_t_prof_occupation
regress mRFEI100 per_t_prof_techoccupation
regress mRFEI100 per_t_prof_n_techoccupation
regress mRFEI100 SES

** Outcome variable: mRFEI100 (Modified Food Retail Environment Index)
** Predictor variables: Distance to Healthy and Unhealthy Food Outlets
regress mRFEI100 Distance_Healthy
regress mRFEI100 Distance_Unhealthy




** Outcome variable: Distance to Healthy Food Outlets 
** Predictor variables: SES variables
regress Distance_Healthy t_income_median
regress Distance_Healthy hsize_mean
regress Distance_Healthy per_t_young_age_depend
regress Distance_Healthy per_t_old_age_depend
regress Distance_Healthy per_htenure_owned
regress Distance_Healthy per_smother_total
regress Distance_Healthy per_t_education_tertiary
regress Distance_Healthy per_t_education_less_secondary
regress Distance_Healthy per_t_income_0_49
regress Distance_Healthy per_t_high_income
regress Distance_Healthy per_crime_victim
regress Distance_Healthy per_vehicle_presence
regress Distance_Healthy per_rooms_less_3
regress Distance_Healthy per_bedrooms_less_2
regress Distance_Healthy per_renting
regress Distance_Healthy per_t_unemployment
regress Distance_Healthy SES


** -----------------------------------------------------------------------------------------
** PART 5 : Building the Logistical Model to explore the relationship between Food Deserts and Swamps with SES variables
**        : Outcome variables --> Deserts and Swamps ( Buffers: 1km, 1.5km, 2km, 2.5km, 3km, 3.5km, 4km, 4.5km, 5km,  )
**        : Predictir variables --> SES variables (income, unemployment, vehicle ownership)
** ------------------------------------------------------------------------------------------

** 1km buffer

logistic Tfd1 t_age_median t_age_median t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES

** 1.5km buffer
logistic Tfd2 t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES

** 2km buffer
logistic Tfd3 t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES

** 2.5km buffer
logistic Tfd4 t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES

** 3km buffer
logistic Tfd5 t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES

** 3.5km buffer
logistic Tfd6 t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES

** 4km buffer
logistic Tfd7 t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES

**4.5km buffer
logistic Tfd8 t_age_median t_income_median hsize_mean per_t_non_black per_t_young_age_depend per_t_old_age_depend per_htenure_owned per_smother_total per_t_education_tertiary per_t_education_less_secondary per_t_income_0_49 per_t_high_income per_crime_victim per_bathroom_0 per_toilet_presence per_vehicles_0 per_electricity per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_wash per_amentities_tv per_amentities_radio per_amentities_computer per_vehicle_presence per_rooms_less_3 per_bedrooms_less_2 per_renting per_t_unemployment per_live_5_more per_t_manage_occupation per_t_prof_occupation per_t_prof_techoccupation per_t_prof_n_techoccupation SES


// error was given at the 5km buffer


