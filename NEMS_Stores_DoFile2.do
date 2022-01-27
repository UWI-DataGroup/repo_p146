clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		NEMS Stores
**  Project:      	NEMS
**	Date Created:	04/01/2022
**  Algorithm Task: Preliminary Analysis of NEMS Stores - SCORING


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

drop if Rater==. // rater had in one missing observation

drop DataCollector // duplicate of Rater

**---------------------------------------------------------------------**
** SECTION 2: ALLOCATING SCORING: AVAILABILITY AND PRICING
**---------------------------------------------------------------------

** MILK
**		AVAILABILITY: HEALTHY ALTERNATIVES

			** Availibility of skim milk: 2pt 
				
				gen MilkScore_Avail = .
				replace MilkScore_Avail = 2 if a_skimmilk==1 

			** >2 varieties of healthier alternatives: 1pt
				gen MilkScore_var =.
				replace MilkScore_var = 1 if variety_milk >2 & variety_milk <.


**		AVAILABILILTY: PROPORTION

			** Proportion of shelf space of skim milk greater than whole mik: 1pt
			
				replace shelf_skimmilk= 0 if shelf_skimmilk== .
				replace shelf_wholemilk = 0 if shelf_wholemilk == .

				gen milk_prop=.
				replace milk_prop=1 if shelf_skimmilk > shelf_wholemilk 
				replace milk_prop=0 if shelf_skimmilk <= shelf_wholemilk

				
** 		PRICING: --> cheapest price was chosen for comparison , healthy alternative chosen is skim milk
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen milkprice=.
				replace milkprice=2 if price_c_skimmilk < price_c_wmilk
				replace milkprice=1 if price_c_skimmilk == price_c_wmilk
				replace milkprice=-1 if price_c_skimmilk > price_c_wmilk
				replace milkprice=. if price_c_skimmilk==. | price_c_wmilk==.
**-----------------------------------------------------------------------------------------------------**

** FRUITS
**		AVAILABILITY: VARIETIES
				**0 varieties: 0pt 
				**< 5 varieties: 1pt 
				**5-9 varieties: 2pts 
				**10-14 varieties: 3pts 
				**15+ varieties: 4pts 

				gen FruitScore_Avail=.
				replace FruitScore_Avail = 0 if variety_fruits ==0
				replace FruitScore_Avail = 0 if a_fruits ==0
				replace FruitScore_Avail = 1 if variety_fruits <5 & variety_fruits >0
				replace FruitScore_Avail = 2 if variety_fruits>=5 & variety_fruits <10
				replace FruitScore_Avail = 3 if variety_fruits>=10 & variety_fruits <15
				replace FruitScore_Avail = 4 if variety_fruits>=15 & variety_fruits <.

**-----------------------------------------------------------------------------------------------------**

** VEGETABLES
**		AVAILABILITY: VARIETIES
				**0 varieties: 0pt 
				**< 5 varieties: 1pt 
				**5-9 varieties: 2pts 
				**10-14 varieties: 3pts 
				**15+ varieties: 4pts 

				gen VegScore_Avail=.
				replace VegScore= 0 if variety_veg==0
				replace VegScore= 1 if variety_veg<5 & variety_veg >0
				replace VegScore= 2 if variety_veg>=5 & variety_veg <10
				replace VegScore= 3 if variety_veg>=10 & variety_veg <15
				replace VegScore= 4 if variety_veg>=15 & variety_veg <.

** ----------------------------------------------------------------------------------------------------**

** GROUND BEEF
** 		AVAILABILITY
				**		Availability of lean ground beef : 2 pts
				gen BeefScore=.
				replace BeefScore=2 if a_leanmincedbeef==1

				**		>2 varieties of healthier alternative: 1pt
				gen BeefScore_var=.
				replace BeefScore_var=1 if variety_minedmeat>2 & variety_minedmeat<.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of lean mined beef greater than standard mined beef: 1pt
				replace shelf_leanmincedbeef = 0 if shelf_leanmincedbeef == .
				replace shelf_stdmincedbeef = 0 if shelf_stdmincedbeef == .

				gen beef_prop=.
				replace beef_prop=1 if shelf_leanmincedbeef > shelf_stdmincedbeef 
				replace beef_prop=0 if shelf_leanmincedbeef <= shelf_stdmincedbeef
				
				
** 		PRICING: 
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen beefprice=.
				replace beefprice=2 if price_leanmincedbeef < price_stdmincedbeef
				replace beefprice=1 if price_leanmincedbeef == price_stdmincedbeef
				replace beefprice=-1 if price_leanmincedbeef > price_stdmincedbeef
				replace beefprice=. if price_leanmincedbeef==. | price_stdmincedbeef==.
**-----------------------------------------------------------------------------------------------------**

** HOTDOGS
** 		AVAILABILITY 
				** Availability of lean hotdogs: 2pts
				gen Hotdog_Score= .
				replace Hotdog_Score=2 if a_lightbhotdogs==1 | a_lightphotdogs==1 | a_lightchotdogs==1
				replace Hotdog_Score=0 if Hotdog_Score==.

				** >2 varieties of healthier alternative: 1pt
				gen Hotdog_Score_var=.
				replace Hotdog_Score_var=1 if variety_hotdog>2 & variety_hotdog<.
				replace Hotdog_Score_var=0 if Hotdog_Score_var==.
				
**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of lean mined beef greater than standard mined beef: 1pt
				replace shelf_stdbhotdog=0 if shelf_stdbhotdog == .
				replace shelf_stdchotdog= 0 if shelf_stdchotdog== .
				replace shelf_stdphotdog= 0 if shelf_stdphotdog== .
				replace shelf_mixedhotdog= 0 if shelf_mixedhotdog== .
				
				replace shelf_lightbhotdog= 0 if shelf_lightbhotdog== .
				replace shelf_lightchotdog= 0 if shelf_lightchotdog== .
				replace shelf_lightphotdog= 0 if shelf_lightphotdog== .
				
			
				gen hotdog_prop=.
				replace hotdog_prop=1 if shelf_lightbhotdog > shelf_stdbhotdog
				replace hotdog_prop=1 if shelf_lightchotdog > shelf_stdchotdog
				replace hotdog_prop=1 if shelf_lightphotdog > shelf_stdphotdog
				replace hotdog_prop=0 if hotdog_prop==.
				

** 		PRICING: --> Chicken hotdogs were used for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen hotdogprice=.
				replace hotdogprice=2 if price_lightchotdog < price_stdchotdog
				replace hotdogprice=1 if  price_lightchotdog== price_stdchotdog
				replace hotdogprice=-1 if price_lightchotdog > price_stdchotdog
				replace hotdogprice=. if price_lightchotdog==. | price_stdchotdog==.	
		
				
** -----------------------------------------------------------------------------------------------------**

** FROZEN DINNERS
** 		AVAILABILITY 
			** 	Availability of healthier alternative frozen dinners : 2pts
				gen Dinner_score=.
				replace Dinner_score=2 if a_hfrozenmeal==1

**		>2 varieties of healthier alternative:
				//gen Dinner_score_var=.
				//replace Dinner_score_var=1 if variety_frozenmeals>2 & variety_frozenmeals<.


**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of lean mined beef greater than standard mined beef: 1pt
				replace shelf_hfrozenmeal = 0 if shelf_hfrozenmeal == .
				replace shelf_stdfrozenmeal = 0 if shelf_stdfrozenmeal == .

				gen frozenmeal_prop=.
				replace frozenmeal_prop=1 if shelf_hfrozenmeal > shelf_stdfrozenmeal
				replace frozenmeal_prop=0 if shelf_hfrozenmeal <= shelf_stdfrozenmeal
				
				
				
** 		PRICING: --> Cheapest priced frozen meals was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen frozenmeal_price=.
				replace frozenmeal_price=2 if price_hfrozenmeal < price_c_stdfrozenmeal
				replace frozenmeal_price=1 if price_hfrozenmeal == price_c_stdfrozenmeal
				replace frozenmeal_price=-1 if price_hfrozenmeal > price_c_stdfrozenmeal
				replace frozenmeal_price=. if price_hfrozenmeal ==. | price_c_stdfrozenmeal==.
				

** -----------------------------------------------------------------------------------------------------**

**  BAKED FOODS
**		AVAILABILITY 
				** Availability of healthier alternative baked goods: 2pts
					gen baked_score=.
					replace baked_score=2 if a_ha_bakedgoods==1

				** >2 varieties of healthier alternative: 1pt 
					gen baked_score_var=.
					replace baked_score_var=1 if variety_bakedgoods>2 & variety_bakedgoods <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of healthier alternative baked good greater than standard baked goods: 1pt
				replace shelf_habakedgoods = 0 if shelf_habakedgoods == .
				replace shelf_bakedgoods = 0 if shelf_bakedgoods == .

				gen bakedgoods_prop=.
				replace bakedgoods_prop=1 if shelf_habakedgoods > shelf_bakedgoods
				replace bakedgoods_prop=0 if shelf_habakedgoods <= shelf_bakedgoods
				

** 		PRICING: --> Cheapest priced baked good was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen bakedgoods_price=.
				replace bakedgoods_price=2 if price_c_habakedgood < price_c_bakedgood
				replace bakedgoods_price=1 if price_c_habakedgood == price_c_bakedgood
				replace bakedgoods_price=-1 if price_c_habakedgood > price_c_bakedgood
				replace bakedgoods_price=. if price_c_habakedgood ==. | price_c_bakedgood==.				

** -----------------------------------------------------------------------------------------------------**

** BEVERAGES
**		AVAILABILITY OF HEALTHEIR ALTERNATIVE BEVERAGES
			** Diet Sode: 2pts
			
				gen Bev_score_soda= .
				replace Bev_score_soda= 2 if a_dietsoda==1
				
			** 100% Juice: 2pts
				gen Bev_score_juice=.
				replace Bev_score_juice=2 if a_juice==1



** 		AVAILABILITY: PROPORTION 
			** Proportion of shelf space for diet soda greater than standard soda : 1pt
				replace shelf_dietsoda = 0 if shelf_dietsoda==.
				replace shelf_stdsoda = 0 if shelf_stdsoda==. 

				gen soda_prop=.
				replace soda_prop=1 if shelf_dietsoda > shelf_stdsoda
				replace soda_prop=0 if shelf_dietsoda <= shelf_stdsoda
				
			** Proportion of shelf space for diet soda greater than standard soda : 1pt
				replace shelf_juicedrink = 0 if shelf_juicedrink==.
				replace shelf_juice = 0 if shelf_juice==.

				gen juice_prop=.
				replace juice_prop=1 if shelf_juice > shelf_juicedrink
				replace juice_prop=0 if shelf_juice <= shelf_juicedrink

				
** 		PRICING- SODA: --> cheapest price was chosen for comparison
			** 	Lower price for diet soda: 2pts  
			**	Same price for all versions of product: 1pt 
			** 	Higher price for soda: -1pt 

				gen soda_price=.
				replace soda_price=2 if price_c_dietsoda < price_c_soda
				replace soda_price=1 if price_c_dietsoda == price_c_soda
				replace soda_price=-1 if price_c_dietsoda > price_c_soda
				replace soda_price=. if price_c_dietsoda== . | price_c_soda==.

				gen juice_price=.
				replace juice_price=2 if  price_c_juice < price_c_juicedrink
				replace juice_price=1 if price_c_juice == price_c_juicedrink
				replace juice_price=-1 if price_c_juice  > price_c_juicedrink
				replace juice_price=. if price_c_juice == . | price_c_juicedrink==.
**----------------------------------------------------------------------------------------------------**** ** BREAD
**		AVAILABILITY 
				** Availability of healthier alternative bread: 2pts
					gen bread_score=.
					replace bread_score=2 if a_wwbread==1

				** >2 varieties of healthier alternative: 1pt 
					gen bread_score_var=.
					replace bread_score_var=1 if variety_bread>2 & variety_bread <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of healthier alternative bread greater than standard white bread: 1pt
				replace shelf_wwbread = 0 if shelf_wwbread == .
				replace shelf_wslicedbread = 0 if shelf_wslicedbread == .

				gen bread_prop=.
				replace bread_prop=1 if shelf_wwbread > shelf_wslicedbread
				replace bread_prop=0 if shelf_wwbread <= shelf_wslicedbread
				

** 		PRICING: --> Cheapest priced bread was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen bread_price=.
				replace bread_price=2 if price_c_wwbread < price_c_wslicedbread
				replace bread_price=1 if price_c_wwbread == price_c_wslicedbread
				replace bread_price=-1 if price_c_wwbread > price_c_wslicedbread
				replace bread_price=. if price_c_wwbread ==. | price_c_wslicedbread ==.				
				
**----------------------------------------------------------------------------------------------------**
** BAKED CHIPS 
**		AVAILABILITY 
				** Availability of low-salt chips: 2pts
					gen chips_score=.
					replace chips_score=2 if a_lschips==1

				** >2 varieties of healthier alternative: 1pt 
					gen chips_score_var=.
					replace chips_score_var=1 if varieties_chips>2 & varieties_chips <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of healthier low salt chips greater than standard chips: 1pt
				replace shelf_chips= 0 if shelf_chips== .
				replace shelf_lschips = 0 if shelf_lschips== .

				gen chips_prop=.
				replace chips_prop=1 if shelf_lschips > shelf_chips
				replace chips_prop=0 if shelf_lschips <= shelf_chips
				

** 		PRICING: // Price for regular chips was not recorded.			
			




** -----------------------------------------------------------------------------------------------------**
** CEREALS
**		AVAILABILITY 
				** Availability of healthier alternative cereal: 2pts
					gen cereal_score=.
					replace cereal_score=2 if a_lscereal==1

				** >2 varieties of healthier alternative: 1pt 
					gen cereal_score_var=.
					replace cereal_score_var=1 if varieties_cereal>2 & varieties_cereal <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of healthier alternative cereal greater than standard cereal: 1pt
				replace shelf_lscereal = 0 if shelf_lscereal == .
				replace shelf_stdcereal = 0 if shelf_stdcereal == .

				gen cereal_prop=.
				replace cereal_prop=1 if shelf_lscereal > shelf_stdcereal
				replace cereal_prop=0 if shelf_lscereal <= shelf_stdcereal
				

** 		PRICING: --> Cheapest priced bread was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen cereal_price=.
				replace cereal_price=2 if price_c_lscereal < price_c_stdcereal
				replace cereal_price=1 if price_c_lscereal == price_c_stdcereal
				replace cereal_price=-1 if price_c_lscereal > price_c_stdcereal
				replace cereal_price=. if price_c_lscereal ==. | price_c_stdcereal ==.	



** -----------------------------------------------------------------------------------------------------**
** ROOTS AND TUBERS

**		AVAILABILITY: VARIETIES
				**0 varieties: 0pt 
				** 1-2 varieties: 1pt 
				** 3+ varieties: 2pts 
				

				gen RootsScore_Avail=.
				replace RootsScore_Avail = 0 if variety_rootsandtubers ==0
				replace RootsScore_Avail = 1 if variety_rootsandtubers==1 | variety_rootsandtubers==2
				replace RootsScore_Avail = 2 if variety_rootsandtubers>=3 & variety_rootsandtubers <.
			


** -----------------------------------------------------------------------------------------------------**

** RICE
**		AVAILABILITY 
				** Availability of brown rice: 2pts
					gen rice_score=.
					replace rice_score=2 if a_brownrice==1

				** >2 varieties of healthier alternative: 1pt 
					gen rice_score_var=.
					replace rice_score_var=1 if varieties_rice>2 & varieties_rice <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of brown rice greater than white rice : 1pt
				
				replace shelf_stdwrice = "0" in 8 // There was a typo in this cell... originally had "q0" 
				destring shelf_stdwrice, replace
				replace shelf_stdwrice = 10 in 8 // The typo was deteremined to be "10" instead of "q0"
				
				replace shelf_brice = 0 if shelf_brice == .
				replace shelf_stdwrice = 0 if shelf_stdwrice == .

				gen rice_prop=.
				replace rice_prop=1 if shelf_brice > shelf_stdwrice
				replace rice_prop=0 if shelf_brice <= shelf_stdwrice
				

** 		PRICING: --> Cheapest priced rice was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen rice_price=.
				replace rice_price=2 if price_c_brice < price_c_wrice
				replace rice_price=1 if price_c_brice == price_c_wrice
				replace rice_price=-1 if price_c_brice > price_c_wrice
				replace rice_price=. if price_c_brice ==. | price_c_wrice ==.	


** -----------------------------------------------------------------------------------------------------**
** PASTA
**		AVAILABILITY 
				** Availability of whole wheat pasta: 2pts
					gen pasta_score=.
					replace pasta_score=2 if a_ww_spaghetti==1

				** >2 varieties of healthier alternative: 1pt 
					gen pasta_score_var=.
					replace pasta_score_var=1 if variety_pasta>2 & variety_pasta <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of brown rice greater than white rice : 1pt
				
				replace shelf_ww_spaghetti = 0 if shelf_ww_spaghetti == .
				replace shelf_spaghetti = 0 if shelf_spaghetti == .

				gen pasta_prop=.
				replace pasta_prop=1 if shelf_ww_spaghetti > shelf_spaghetti
				replace pasta_prop=0 if shelf_ww_spaghetti <= shelf_spaghetti
				

** 		PRICING: --> Cheapest priced pasta was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen pasta_price=.
				replace pasta_price=2 if price_c_wwspaghetti < price_c_spaghetti
				replace pasta_price=1 if price_c_wwspaghetti == price_c_spaghetti
				replace pasta_price=-1 if price_c_wwspaghetti > price_c_spaghetti
				replace pasta_price=. if price_c_wwspaghetti ==. | price_c_spaghetti ==.	


** -----------------------------------------------------------------------------------------------------**

**FLOUR
**		AVAILABILITY 
				** Availability of whole wheat flour: 2pts
					gen flour_score=.
					replace flour_score=2 if a_wwflour==1

				** >2 varieties of healthier alternative: 1pt 
					gen flour_score_var=.
					replace flour_score_var=1 if varieties_flour>2 & varieties_flour <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of brown rice greater than white rice : 1pt
				
				replace shelf_wwflour = 0 if shelf_wwflour == .
				replace shelf_whiteflour = 0 if shelf_whiteflour == .

				gen flour_prop=.
				replace flour_prop=1 if shelf_wwflour > shelf_whiteflour
				replace flour_prop=0 if shelf_wwflour <= shelf_whiteflour
				

** 		PRICING: --> Cheapest priced pasta was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen flour_price=.
				replace flour_price=2 if price_c_wwflour < price_c_wflour
				replace flour_price=1 if price_c_wwflour == price_c_wflour
				replace flour_price=-1 if price_c_wwflour > price_c_wflour
				replace flour_price=. if price_c_wwflour ==. | price_c_wflour==.


**-----------------------------------------------------------------------------------------**

** CANNED VEGETABLES

**		AVAILABILITY 
				** Availability of low salt canned veg: 2pts
					gen canveg_score=.
					replace canveg_score=2 if a_lscanveg==1

				** >2 varieties of healthier alternative: 1pt 
					gen canveg_score_var=.
					replace canveg_score_var=1 if varieties_cannedveg>2 & varieties_cannedveg <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of low salt canned veg greater than regular canned veg : 1pt
				
				replace shelf_lscanveg = 0 if shelf_lscanveg == .
				replace shelf_cannedveg = 0 if shelf_cannedveg == .

				gen canveg_prop=.
				replace canveg_prop=1 if shelf_lscanveg > shelf_cannedveg
				replace canveg_prop=0 if shelf_lscanveg <= shelf_cannedveg
				

** 		PRICING: --> Cheapest priced canned mixed veg was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen canveg_price=.
				replace canveg_price=2 if price_c_lscanveg < price_c_mixveg
				replace canveg_price=1 if price_c_lscanveg == price_c_mixveg
				replace canveg_price=-1 if price_c_lscanveg > price_c_mixveg
				replace canveg_price=. if price_c_lscanveg ==. | price_c_mixveg==.


**-------------------------------------------------------------------------------------------**
** CANNED FRUIT

**		AVAILABILITY 
				** Availability of canned fruit in 100% juice: 2pts
					gen canfruit_score=.
					replace canfruit_score=2 if a_fjcanfruit==1

				** >2 varieties of healthier alternatives: 1pt 
					gen canfruit_score_var=.
					replace canfruit_score_var=1 if varieties_canfruit>2 & varieties_canfruit <.

**		AVAILABILILTY: PROPORTION

				** Proportion of shelf space of canned fruit in 100% juice  greater than regular canned fruit : 1pt
				
				replace shelf_fjcanfruit = 0 if shelf_fjcanfruit == .
				replace shelf_canfruit = 0 if shelf_canfruit == .

				gen canfruit_prop=.
				replace canfruit_prop=1 if shelf_fjcanfruit > shelf_canfruit
				replace canfruit_prop=0 if shelf_fjcanfruit <= shelf_canfruit
				

** 		PRICING: --> Cheapest priced canned pineapples was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen canfruit_price=.
				replace canfruit_price=2 if price_c_fjcanfruit< price_c_canpine
				replace canfruit_price=1 if price_c_fjcanfruit == price_c_canpine
				replace canfruit_price=-1 if price_c_fjcanfruit > price_c_canpine
				replace canfruit_price=. if price_c_fjcanfruit ==. | price_c_canpine==.


**-------------------------------------------------------------------------------------------**
** MEATS/SEAFOOD

**		AVAILABILITY 
				** Availability of lean chicken breast: 2pts
					gen chicken_score=.
					replace chicken_score=2 if a_chickenbreast==1

				** >2 varieties of healthier alternatives: 1pt
				
					replace varieties_chickenbreast = "0" in 3 // There was one row with string typed in with "none" written. Replaced it with "0"
					destring varieties_chickenbreast, replace
					
					gen chicken_score_var=.
					replace chicken_score_var=1 if varieties_chickenbreast>2 & varieties_chickenbreast <.
		



** -----------------------------------------------------------------------------------------------------**

** OILS

**		AVAILABILITY 
				** Availability of olive oil: 2pts
					gen oil_score=.
					replace oil_score=2 if a_oliveoil==1

				** >2 varieties of healthier alternatives: 1pt 
					gen oil_score_var=.
					replace oil_score_var=1 if varieties_oils>2 & varieties_oils <.

**		AVAILABILILTY: PROPORTION

				** Proportion of olive oil greater than regular oil: 1pt
				
				replace  shelf_oliveoil= 0 if shelf_oliveoil== .
				replace shelf_soyoil = 0 if shelf_soyoil == .

				gen oil_prop=.
				replace canfruit_prop=1 if shelf_oliveoil > shelf_soyoil
				replace canfruit_prop=0 if shelf_oliveoil <= shelf_soyoil
				

** 		PRICING: --> Cheapest priced oil was chosen for comparison
			** Lower price for healthier alternative: 2pts  
			** Same price for all versions of product: 1pt 
			** Higher price for healthier: -1pt 

				gen oil_price=.
				replace oil_price=2 if price_c_oliveoil< price_c_soyoil
				replace oil_price=1 if price_c_oliveoil == price_c_soyoil
				replace oil_price=-1 if price_c_oliveoil > price_c_soyoil
				replace oil_price=. if price_c_oliveoil ==. | price_c_soyoil==.

	

**---------------------------------------------------------------------**
** SECTION 3: ALLOCATING SCORING: QUALITY
**---------------------------------------------------------------------**


** Cleaning the first 7 rows
foreach x of varlist accept_bananas accept_apples accept_oranges accept_grapes accept_cantaloupes accept_peaches accept_strawberries accept_honeydews accept_watermelons accept_pears accept_mangoes accept_tangerines accept_grapefruits accept_pawpaws accept_importedplums accept_pineapples accept_avocados accept_carrots accept_tomatoes accept_sweetpeppers accept_broccoli accept_lettuce accept_corn accept_celery accept_cucumber accept_cabbage accept_cauliflower accept_squash accept_pumpkin accept_ochro accept_spinach accept_eggplant accept_kale accept_beets accept_cassava accept_sweetpotatoes accept_engpotatoes accept_yams accept_dasheen accept_breadfruit accept_plantains accept_greenbananas accept_chickenbreast accept_fish accept_stdpork accept_redmeat accept_organmeat accept_stdmincedbeef accept_leanmincedbeef {

replace `x' = 1 if `x' >=0 & `x'<20 in 1/7	
replace `x' = 2 if `x' >=20 & `x'<40 in 1/7	
replace `x' = 3 if `x' >=40 & `x'<60 in 1/7
replace `x' = 4 if `x' >=60 & `x'<80 in 1/7
replace `x' = 5 if `x' >=80 & `x'<100 in 1/7
}

**-------------------------------------------------------------------------------------**
** CREATING THE OVERALL QUALITY SCORES FOR FRUITS

** Total number of fruits that had a quality rating
foreach x of varlist accept_bananas accept_apples accept_oranges accept_grapes accept_cantaloupes accept_peaches accept_strawberries accept_honeydews accept_watermelons accept_pears accept_mangoes accept_tangerines accept_grapefruits accept_pawpaws accept_importedplums accept_pineapples accept_avocados {
	
	gen `x'_total = .
	replace `x'_total = 1 if `x'!=.
	
}

egen fruit_total = rowtotal(accept_bananas_total - accept_avocados_total)


** Deleting the variables 
foreach x of varlist accept_bananas accept_apples accept_oranges accept_grapes accept_cantaloupes accept_peaches accept_strawberries accept_honeydews accept_watermelons accept_pears accept_mangoes accept_tangerines accept_grapefruits accept_pawpaws accept_importedplums accept_pineapples accept_avocados {
	
	drop `x'_total
}

** Total Number of fruits that had a rating of acceptable quality and above 
foreach x of varlist accept_bananas accept_apples accept_oranges accept_grapes accept_cantaloupes accept_peaches accept_strawberries accept_honeydews accept_watermelons accept_pears accept_mangoes accept_tangerines accept_grapefruits accept_pawpaws accept_importedplums accept_pineapples accept_avocados {
	
	gen `x'_accep = .
	replace `x'_accep = 1 if `x'>=3 & `x'!=.
	
}

** Adding the total number fruits that had a rating of acceptable quality and above
egen fruit_quality = rowtotal(accept_bananas_accep - accept_avocados_accep)

foreach x of varlist accept_bananas accept_apples accept_oranges accept_grapes accept_cantaloupes accept_peaches accept_strawberries accept_honeydews accept_watermelons accept_pears accept_mangoes accept_tangerines accept_grapefruits accept_pawpaws accept_importedplums accept_pineapples accept_avocados {
	
	drop `x'_accep
}


** Creating a percentage for the total number of fruits that had a rating of acceptable quality and above
gen fruit_quality_score = (fruit_quality/fruit_total)*100


** Allocating the scoring for the quality of the Fruits
		** 25-49% acceptable:  1pt  
		** 50-74% acceptable:2pts
		** 75% + acceptable: 3pts 

gen fruit_quality_cat = .
replace fruit_quality_cat = 3 if fruit_quality_score >=75 & fruit_quality_score!=.
replace fruit_quality_cat = 2 if fruit_quality_score >=50 & fruit_quality_score<75
replace fruit_quality_cat = 1 if fruit_quality_score >=25 & fruit_quality_score<50

**------------------------------------------------------------------------------------------------**
** CREATING THE OVERALL QUALITY SCORES FOR VEGETABLES

** Total number of vegetables that had a quality rating
foreach x of varlist accept_carrots accept_tomatoes accept_sweetpeppers accept_broccoli accept_lettuce accept_corn accept_celery accept_cucumber accept_cabbage accept_cauliflower accept_squash accept_pumpkin accept_ochro accept_spinach accept_eggplant accept_kale accept_beets{

gen `x'_total = .
	replace `x'_total = 1 if `x'!=.
}

egen veg_total = rowtotal(accept_carrots_total - accept_beets_total)

** Deleting the variables 
foreach x of varlist accept_carrots accept_tomatoes accept_sweetpeppers accept_broccoli accept_lettuce accept_corn accept_celery accept_cucumber accept_cabbage accept_cauliflower accept_squash accept_pumpkin accept_ochro accept_spinach accept_eggplant accept_kale accept_beets {
	
	drop `x'_total
}

** Total Number of vegetables that had a rating of acceptable quality and above 
foreach x of varlist accept_carrots accept_tomatoes accept_sweetpeppers accept_broccoli accept_lettuce accept_corn accept_celery accept_cucumber accept_cabbage accept_cauliflower accept_squash accept_pumpkin accept_ochro accept_spinach accept_eggplant accept_kale accept_beets {
	
	gen `x'_accep = .
	replace `x'_accep = 1 if `x'>=3 & `x'!=.
	
}

** Adding the total number vegetables that had a rating of acceptable quality and above
egen vegetable_quality = rowtotal(accept_carrots_accep - accept_beets_accep)

foreach x of varlist accept_carrots accept_tomatoes accept_sweetpeppers accept_broccoli accept_lettuce accept_corn accept_celery accept_cucumber accept_cabbage accept_cauliflower accept_squash accept_pumpkin accept_ochro accept_spinach accept_eggplant accept_kale accept_beets {
	
	drop `x'_accep
}


** Creating a percentage for the total number of vegetables that had a rating of acceptable quality and above
gen vegetable_quality_score = (vegetable_quality/veg_total)*100


** Allocating the scoring for the quality of the Vegetables
		** 25-49% acceptable:  1pt  
		** 50-74% acceptable:2pts
		** 75% + acceptable: 3pts 

gen vegetable_quality_cat = .
replace vegetable_quality_cat = 3 if vegetable_quality_score >=75 & vegetable_quality_score!=.
replace vegetable_quality_cat = 2 if vegetable_quality_score >=50 & vegetable_quality_score<75
replace vegetable_quality_cat = 1 if vegetable_quality_score >=25 & vegetable_quality_score<50


**------------------------------------------------------------------------------------------------------**
** CREATING THE OVERALL QUALITY SCORES FOR ROOTS AND TUBERS




** Total number roots and tubers that had a quality rating
foreach x of varlist accept_cassava accept_sweetpotatoes accept_engpotatoes accept_yams accept_dasheen accept_breadfruit accept_plantains accept_greenbananas{

gen `x'_total = .
	replace `x'_total = 1 if `x'!=.
}

egen roots_total = rowtotal(accept_cassava_total - accept_greenbananas_total)

** Deleting the variables 
foreach x of varlist accept_cassava accept_sweetpotatoes accept_engpotatoes accept_yams accept_dasheen accept_breadfruit accept_plantains accept_greenbananas {
	
	drop `x'_total
}

** Total Number of roots and tubers that had a rating of acceptable quality and above 
foreach x of varlist accept_cassava accept_sweetpotatoes accept_engpotatoes accept_yams accept_dasheen accept_breadfruit accept_plantains accept_greenbananas {
	
	gen `x'_accep = .
	replace `x'_accep = 1 if `x'>=3 & `x'!=.
	
}

** Adding the total number roots and tubers that had a rating of acceptable quality and above
egen roots_quality = rowtotal(accept_cassava_accep - accept_greenbananas_accep)

foreach x of varlist accept_cassava accept_sweetpotatoes accept_engpotatoes accept_yams accept_dasheen accept_breadfruit accept_plantains accept_greenbananas {
	
	drop `x'_accep
}


** Creating a percentage for the total number of roots and tubers that had a rating of acceptable quality and above
gen roots_quality_score = (roots_quality/roots_total)*100


** Allocating the scoring for the quality of the Roots and Tubers
		** 25-49% acceptable:  1pt  
		** 50-74% acceptable:2pts
		** 75% + acceptable: 3pts 

gen roots_quality_cat = .
replace roots_quality_cat = 3 if roots_quality_score >=75 & roots_quality_score!=.
replace roots_quality_cat = 2 if roots_quality_score >=50 & roots_quality_score<75
replace roots_quality_cat = 1 if roots_quality_score >=25 & roots_quality_score<50





**------------------------------------------------------------------------------------------------------**
** CREATING THE OVERALL QUALITY SCORES FOR MINCED MEAT


** Total number that had a minced meat quality rating
foreach x of varlist accept_stdmincedbeef accept_leanmincedbeef {

gen `x'_total = .
	replace `x'_total = 1 if `x'!=.
}

egen mincedmeat_total = rowtotal(accept_stdmincedbeef_total - accept_leanmincedbeef_total)

** Deleting the variables 
foreach x of varlist accept_stdmincedbeef accept_leanmincedbeef {
	
	drop `x'_total
}

** Total Number of minced meat that had a rating of acceptable quality and above 
foreach x of varlist accept_stdmincedbeef accept_leanmincedbeef {
	
	gen `x'_accep = .
	replace `x'_accep = 1 if `x'>=3 & `x'!=.
	
}

** Adding the total numberof minced meat that had a rating of acceptable quality and above
egen mincedmeat_quality = rowtotal(accept_stdmincedbeef_accep - accept_leanmincedbeef_accep)

foreach x of varlist accept_stdmincedbeef accept_leanmincedbeef {
	
	drop `x'_accep
}


** Creating a percentage for the total number of minced meat that had a rating of acceptable quality and above
gen mincedmeat_quality_score = (mincedmeat_quality/mincedmeat_total)*100


** Allocating the scoring for the quality of the Minced meat
		** 25-49% acceptable:  1pt  
		** 50-74% acceptable:2pts
		** 75% + acceptable: 3pts 

gen mincedmeat_quality_cat = .
replace mincedmeat_quality_cat = 3 if mincedmeat_quality_score >=75 & mincedmeat_quality_score!=.
replace mincedmeat_quality_cat = 2 if mincedmeat_quality_score >=50 & mincedmeat_quality_score<75
replace mincedmeat_quality_cat = 1 if mincedmeat_quality_score >=25 & mincedmeat_quality_score<50





**------------------------------------------------------------------------------------------------------**
** CREATING THE OVERALL QUALITY SCORES FOR MEATS/SEAFOOD


** Total number that had a meat quality rating
foreach x of varlist accept_chickenbreast accept_fish accept_stdpork accept_redmeat accept_organmeat  {

gen `x'_total = .
	replace `x'_total = 1 if `x'!=.
}

egen meat_total = rowtotal(accept_chickenbreast_total - accept_organmeat_total)

** Deleting the variables 
foreach x of varlist accept_chickenbreast accept_fish accept_stdpork accept_redmeat accept_organmeat  {
	
	drop `x'_total
}

** Total Number of meat that had a rating of acceptable quality and above 
foreach x of varlist accept_chickenbreast accept_fish accept_stdpork accept_redmeat accept_organmeat {
	
	gen `x'_accep = .
	replace `x'_accep = 1 if `x'>=3 & `x'!=.
	
}

** Adding the total numberof  meat that had a rating of acceptable quality and above
egen meat_quality = rowtotal(accept_chickenbreast_accep - accept_organmeat_accep)

foreach x of varlist accept_chickenbreast accept_fish accept_stdpork accept_redmeat accept_organmeat  {
	
	drop `x'_accep
}


** Creating a percentage for the total number of minced meat that had a rating of acceptable quality and above
gen meat_quality_score = (meat_quality/meat_total)*100


** Allocating the scoring for the quality of the  meat
		** 25-49% acceptable:  1pt  
		** 50-74% acceptable:2pts
		** 75% + acceptable: 3pts 

gen meat_quality_cat = .
replace meat_quality_cat = 3 if meat_quality_score >=75 & meat_quality_score!=.
replace meat_quality_cat = 2 if meat_quality_score >=50 & meat_quality_score<75
replace meat_quality_cat = 1 if meat_quality_score >=25 & meat_quality_score<50



**----------------------------------------------------------------------------------------------------
** SECTION 4 : CALCULATING TOTALS FOR AVAILABILITY, PROPORTION, PRICE AND QUALITY
**----------------------------------------------------------------------------------------------------

** TOTAL AVAILABILITY SCORE--> Range 0-58
egen TotalAvailability=rowtotal (MilkScore_Avail FruitScore_Avail VegScore_Avail BeefScore Hotdog_Score Dinner_score baked_score Bev_score_soda Bev_score_juice bread_score chips_score cereal_score RootsScore_Avail rice_score pasta_score flour_score canveg_score canfruit_score chicken_score oil_score MilkScore_var BeefScore_var Hotdog_Score_var baked_score_var bread_score_var chips_score_var cereal_score_var rice_score_var pasta_score_var flour_score_var canveg_score_var canfruit_score_var chicken_score_var oil_score_var)


** TOTAL PROPORTION SCORE--> Range 0-16
egen TotalProportion=rowtotal ( milk_prop beef_prop hotdog_prop frozenmeal_prop bakedgoods_prop soda_prop juice_prop bread_prop chips_prop cereal_prop rice_prop pasta_prop flour_prop canveg_prop canfruit_prop oil_prop )


** TOTAL PRICE SCORE --> Range -16 -32
egen TotalPrice=rowtotal ( milkprice beefprice hotdogprice frozenmeal_price bakedgoods_price soda_price juice_price bread_price cereal_price rice_price pasta_price flour_price canveg_price canfruit_price oil_price)

** TOTAL QUALITY SCORE --> Range 0-15
egen TotalQuality=rowtotal ( fruit_quality_cat vegetable_quality_cat roots_quality_cat mincedmeat_quality_cat meat_quality_cat)

**---------------------------------------------------------------------------------------------------------
** SECTION 5: TOTAL NEMS SCORE
**---------------------------------------------------------------------------------------------------------

** TOTAL NEMS SCORE ---> Range -16 to 121
egen TotalNEMS=rowtotal ( TotalAvailability TotalProportion TotalPrice TotalQuality)




**---------------------------------------------------------------------------------------------------------
** SECTION 6: RESHAPING THE DATA SET --> In preparation to calculate for inter rater reliability
**---------------------------------------------------------------------------------------------------------
preserve

keep Rater StoreID start_time endtime store_type cash_registers MilkScore_Avail MilkScore_var milk_prop milkprice FruitScore_Avail VegScore_Avail BeefScore BeefScore_var beef_prop beefprice Hotdog_Score Hotdog_Score_var hotdog_prop hotdogprice Dinner_score frozenmeal_prop frozenmeal_price baked_score baked_score_var bakedgoods_prop bakedgoods_price Bev_score_soda Bev_score_juice soda_prop juice_prop soda_price juice_price bread_score bread_score_var bread_prop bread_price chips_score chips_score_var chips_prop cereal_score cereal_score_var cereal_prop cereal_price RootsScore_Avail rice_score rice_score_var rice_prop rice_price pasta_score pasta_score_var pasta_prop pasta_price flour_score flour_score_var flour_prop flour_price canveg_score canveg_score_var canveg_prop canveg_price canfruit_score canfruit_score_var canfruit_prop canfruit_price chicken_score chicken_score_var oil_score oil_score_var oil_prop oil_price fruit_total fruit_quality fruit_quality_score fruit_quality_cat veg_total vegetable_quality vegetable_quality_score vegetable_quality_cat roots_total roots_quality roots_quality_score roots_quality_cat mincedmeat_total mincedmeat_quality mincedmeat_quality_score mincedmeat_quality_cat meat_total meat_quality meat_quality_score meat_quality_cat TotalAvailability TotalProportion TotalPrice TotalQuality TotalNEMS


reshape wide start_time endtime store_type cash_registers MilkScore_Avail MilkScore_var milk_prop milkprice FruitScore_Avail VegScore_Avail BeefScore BeefScore_var beef_prop beefprice Hotdog_Score Hotdog_Score_var hotdog_prop hotdogprice Dinner_score frozenmeal_prop frozenmeal_price baked_score baked_score_var bakedgoods_prop bakedgoods_price Bev_score_soda Bev_score_juice soda_prop juice_prop soda_price juice_price bread_score bread_score_var bread_prop bread_price chips_score chips_score_var chips_prop cereal_score cereal_score_var cereal_prop cereal_price RootsScore_Avail rice_score rice_score_var rice_prop rice_price pasta_score pasta_score_var pasta_prop pasta_price flour_score flour_score_var flour_prop flour_price canveg_score canveg_score_var canveg_prop canveg_price canfruit_score canfruit_score_var canfruit_prop canfruit_price chicken_score chicken_score_var oil_score oil_score_var oil_prop oil_price fruit_total fruit_quality fruit_quality_score fruit_quality_cat veg_total vegetable_quality vegetable_quality_score vegetable_quality_cat roots_total roots_quality roots_quality_score roots_quality_cat mincedmeat_total mincedmeat_quality mincedmeat_quality_score mincedmeat_quality_cat meat_total meat_quality meat_quality_score meat_quality_cat TotalAvailability TotalProportion TotalPrice TotalQuality TotalNEMS, i(StoreID) j(Rater)


**-------------------------------------------------------------------------------------------------------
** SECTION 7 : Inter-rater reliability using 

** RATER PAIRS : Malik & Rashaad, Eden & Stephanie, Shamika & Tinika
**			   : Rater 2 & Rater 3, Rater 1 & Rater 5, Rater 4 & Rater 6
**-------------------------------------------------------------------------------------------------------






