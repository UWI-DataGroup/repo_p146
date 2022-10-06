** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    DataPrep_Diet
    //  project:				    FoodScapes
    //  analysts:				    Stephanie Whiteman
    // 	date last modified	    	6th October 2022
    //  algorithm task			    



    ** General algorithm set-up
    version 16
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export

    ** DATASETS to encrypted SharePoint folder
    local datapath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\1-input\Salt-Use\nutribase\analysis\versions\version04\data"

    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\2-working\Logfiles"

    ** REPORTS and Other outputs
    local outputpath "X:\The University of the West Indies\DataGroup - repo_data\data_p146\version01\3-output"


    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\DataPrep_Diet", replace

    **--------------------------------------------------------
    ** PART 1: Importing the data set
    **--------------------------------------------------------
     use "`datapath'\catdash.dta"


    **----------------------------------------------------------------------------------------------------------------------
    ** PART 2: Grouping food names into the appropriate individual groups to calculate individual dietary diversity
    **----------------------------------------------------------------------------------------------------------------------
    
    ** Individual food groupings are as follows:
    **                                       1. Cereals
    **                                       2. White tubers, roots and plantains
    **                                       3. Vitamin A Rich Vegetables and Tubers
    **                                       4. Dark Green Leafy Vegetables
    **                                       5. Other Vegetables
    **                                       6. Vitamin A Rich Fruits (Dark Yellow or Orange)
    **                                       7. Other Fruits
    **                                       8. Organ Meat
    **                                       9. Flesh Meat
    **                                      10. Eggs
    **                                      11. Fish and Seafood
    **                                      12. Legumes
    **                                      13. Nuts & Seeds
    **                                      14. Milk and Milk Products
    **                                      15. Oils and Fats
    **                                      16. Sweets
    **                                      17. Spices, Condiments and Beverages


    gen DD_FoodCat= .
    order DD_FoodCat, after (FoodName)
    replace DD_FoodCat=1 if regexm(FoodName,"MULTIGRAIN BREAD") | regexm(FoodName,"PITA BREAD") | regexm(FoodName,"CHICKEN ALFREDO PASTA") | regexm(FoodName,"BAKES") | regexm(FoodName, "BARLEY CEREAL") | regexm(FoodName, "WHITE JASMINE/BASMATI RICE, DRY") | regexm(FoodName, "BISCUIT") | regexm(FoodName,"WHEAT BRAN BREAD") | regexm(FoodName,"BRAN FLAKES CEREAL") | regexm(FoodName,"BROWN RICE, MEDIUM OR LONG-GRAIN, COOKED") | regexm(FoodName,"CORN FLAKES") | regexm(FoodName, "RAISIN BRAN") | regexm(FoodName, "CEREAL RICE KRISPIES, RTE") | regexm(FoodName, "FROSTED FLAKES") | regexm(FoodName, "HONEY NUT CHEERIOS") | regexm(FoodName, "PORRIDGE") | regexm(FoodName, "CEREAL, RTE, CINNAMON MINI BUNS") | regexm(FoodName, "FROOT LOOPS") | regexm(FoodName, "CEREAL, RTE, HONEY BUNCHES OF OATS") | regexm(FoodName, "CEREAL, RTE, SHREDDED WHEAT") | regexm(FoodName, "CEREAL, RTE, SPECIAL K") | regexm(FoodName, "WEETABIX") | regexm(FoodName, "CHOW MEIN") | regexm(FoodName, "CHINESE FRIED RICE") | regexm(FoodName, "CORNNUTS SNACK, PLAIN") | regexm(FoodName, "CRACKER SANDWICH, RITZ BITS PEANUT BUTTER") | regexm(FoodName, "CREAM OF WHEAT") | regexm(FoodName, "CROISSANT, CHEESE") | regexm(FoodName, "CROUTONS, SEASONED") | regexm(FoodName, "DUMPLING") | regexm(FoodName, "ENGLISH MUFFIN, PLAIN") | regexm(FoodName, "ENGLISH MUFFIN, WHOLE WHEAT") | regexm(FoodName, "GRANOLA BAR") | regexm(FoodName, "GRANOLA W/RAISING, LOWFAT, RTE") | regexm(FoodName, "GREAT GRAINS CRUNCHY PECAN, RTE") | regexm(FoodName, "WHITE BREAD") | regexm(FoodName, "HIGH FIBER BAR, CHEWY, OATS & CHOCOLATE") | regexm(FoodName, "INDIAN SAMOSA WRAPS, VEGAN") | regexm(FoodName, "MACARONI & CHEESE, PACKET") | regexm(FoodName,"HOME-MADE BAJAN MACARONI PIE") | regexm(FoodName, "MACARONI SALAD") | regexm(FoodName, "MACARONI/SPAGHETTI") | regexm(FoodName, "PIZZA") | regexm(FoodName, "MEDITERRANEAN WRAP") | regexm(FoodName, "PANCAKE/WAFFLE") | regexm(FoodName, "PASTA W/CHICKEN, PEAS & CARROTS") | regexm(FoodName, "PILAU RICE") | regexm(FoodName, "POPCORN") | regexm(FoodName, "CORN MEAL PORRIDGE") | regexm(FoodName, "PUMPKIN QUICK BREAD MIX") | regexm(FoodName, "RAMEN NOODLE SOUP, ANY FLAVOR, DRY") | regexm(FoodName, "RICE AND PEAS") | regexm(FoodName, "ROTI SKIN") | regexm(FoodName, "RYE CRACKER, CRISPBREAD") | regexm(FoodName, "SKILLET MEAL MIX, TUNA NOODLE CASSEROLE") | regexm(FoodName, "STUFFING MIX, TURKEY") | regexm(FoodName, "TORTILLA WRAP, FLOUR") | regexm(FoodName, "VEGETABLE AND RICE") | regexm(FoodName, "VEGETABLE PANEER WRAP") | regexm(FoodName,"ECLIPSE/SODA - CRACKER") | regexm(FoodName,"WHEAT GERM, REGULAR, RTE") | regexm(FoodName, "WHEAT GLUTEN, VITAL") | regexm(FoodName, "WHITE RICE, LONG GRAIN, COOKED W/SALT" ) | regexm(FoodName,"WHOLE WHEAT BREAD") | regexm(FoodName, "WHOLE WHEAT CRACKER" ) | regexm(FoodName,"WONTON WRAPPER" ) | regexm(FoodName,"ROTI CHICKEN POTATO ROTI") | regexm(FoodName,"LASAGNA W/MEAT & SAUCE") 
    replace DD_FoodCat=2 if regexm(FoodName,"BREADFRUIT SEED,BOILED") | regexm(FoodName,"BREADFRUIT SEED, ROASTED") | regexm(FoodName,"CASSAVA PONE") | regexm(FoodName,"CASSAVA, RAW") | regexm(FoodName,"COUCOU") | regexm(FoodName,"POTATO WEDGES/FRENCH FRIES") | regexm(FoodName,"GINGER ROOT, RAW") | regexm(FoodName,"HOMESTYLE CHEESY SCALLOPED POTATOES MIX, PAD") | regexm(FoodName,"POTATO, BAKED W/SALT") | regexm(FoodName,"POTATO, BOILED/MASHED") | regexm(FoodName,"POTATO SALAD") | regexm(FoodName,"SNACKS, YUCCA (CASSAVA) CHIPS, SALTED") | regexm(FoodName,"STEAMED PUDDING") | regexm(FoodName,"YAM, BOILED OR BAKED") | regexm(FoodName,"Green Banana PLANTAIN, COOKED") | regexm(FoodName,"PLANTAIN CHIPS") | regexm(FoodName,"PLANTAIN") | regexm(FoodName,"SHEPHERD'S PIE, VEGAN")
    replace DD_FoodCat=3 if regexm(FoodName,"CARROT JUICE") | regexm(FoodName,"CARROT, BOILED W/SALT") | regexm(FoodName,"CARROT, BOILED, NO SALT") | regexm(FoodName,"CARROT, RAW, GRATED") | regexm(FoodName,"PUMPKIN FRITTERS") | regexm(FoodName,"PUMPKIN, BOILED, NO SALT, MASHED") | regexm(FoodName,"SWEET POTATO, BOILED/BAKED")
    replace DD_FoodCat=4 if regexm(FoodName,"BROCCOLI, BOILED W/SALT") | regexm(FoodName,"BROCCOLI, BOILED, NO SALT") | regexm(FoodName,"LETTUCE") | regexm(FoodName,"SALAD, TOSSED W/O DRESSING") | regexm(FoodName,"SPINACH")
    replace DD_FoodCat=5 if regexm(FoodName,"ASPARAGUS, BOILED") | regexm(FoodName,"BEET, BOILED") | regexm(FoodName,"CABBAGE, BOILED, NO SALT") | regexm(FoodName,"CELERY, RAW, CHOPPED") | regexm(FoodName,"CHILI PEPPER, GREEN, RAW") | regexm(FoodName,"CHINESE STIR FRY VEGETABLE BLEND, FROZEN") | regexm(FoodName,"CHRISTOPHINE - CHAYOTE, BOILED W/SALT") | regexm(FoodName,"CHRISTOPHINE - CHAYOTE, BOILED NO SALT") | regexm(FoodName,"COLESLAW") | regexm(FoodName,"CORN ON THE COB") | regexm(FoodName,"CORN, YELLOW, WHOLE KERNEL") | regexm(FoodName,"CUCUMBER, PEELED, RAW") | regexm(FoodName,"EGGPLANT") | regexm(FoodName,"EGGPLANT, BOILED W/SALT") | regexm(FoodName,"GREEN BEANS, STRAINED") | regexm(FoodName,"JALAPENO PEPPER") | regexm(FoodName,"MIXED VEGETABLES, BOILED W/SALT") | regexm(FoodName,"MUSHROOM, SLICED, BROILED IN BUTTER, CANNED") | regexm(FoodName,"OKRA, BOILED W/SALT") | regexm(FoodName,"OKRA") | regexm(FoodName,"ONION RINGS") | regexm(FoodName,"ONION") | regexm(FoodName,"PEPPERS, HOT CHILI, RED & GREEN, RAW") | regexm(FoodName,"PICKLE CUCUMBER") | regexm(FoodName,"RADISH, RAW") | regexm(FoodName,"VEGETABLE SOUP") | regexm(FoodName,"MIXED VEGETABLES, BOILED W/SALT") | regexm(FoodName,"SUMMER SQUASH, BOILED, NO SALT") | regexm(FoodName,"TOMATO, RED, RIPE, RAW") | regexm(FoodName,"VEGETABLE SPING ROLLS, VEGAN") | regexm(FoodName,"ZUCCHINI W/SKIN, BOILED W/SALT")
    replace DD_FoodCat=6 if regexm(FoodName,"CANTALOUPE, RAW""FRUIT BOWL, DICED PEACHES") | regexm(FoodName,"MANGO, RAW") | regexm(FoodName,"MELON, CANTELOUPE, RAW") | regexm(FoodName,"PAPAYA, RAW") | regexm(FoodName,"PEACH, RAW") 
    replace DD_FoodCat=7 if regexm(FoodName,"AVOCADO, RAW") | regexm(FoodName,"ACKEES - LITCHI, RAW") | regexm(FoodName,"APPLE W/SKIN, RAW") | regexm(FoodName,"BANANA, RAW") | regexm(FoodName,"BLACKBERRIES, FROZEN, BAG") | regexm(FoodName,"BLUEBERRY") | regexm(FoodName,"CARAMBOLA, RAW (STARFRUIT)") | regexm(FoodName,"CHOKECHRRIES, RAW, PITTED") | regexm(FoodName,"COCONUT MEAT, RAW") | regexm(FoodName,"DOCK, BOILED (SORREL)") | regexm(FoodName,"FIG, RAW") | regexm(FoodName,"GOLDEN APPLE") | regexm(FoodName,"GOLDEN APPLE, RAW") | regexm(FoodName,"GOOSEBERRY, LIGHT SYRUP PACK") | regexm(FoodName,"GRAPE, AMERICAN-TYPE, RAW") | regexm(FoodName,"GUAVA, COMMON, RAW") | regexm(FoodName,"HONEYDEW MELON, RAW") | regexm(FoodName,"KIWIFRUIT, GOLD, RAW") | regexm(FoodName,"LIME, RAW") | regexm(FoodName,"LITCHI, RAW") | regexm(FoodName,"ORANGE, FLORIDA, RAW") | regexm(FoodName,"PEAR, RAW") | regexm(FoodName,"PINEAPPLE, LIGHT SYRUP") | regexm(FoodName,"PINEAPPLE, RAW") | regexm(FoodName,"PLUM, RAW") | regexm(FoodName,"POMEGRANTE, RAW") | regexm(FoodName,"PRUNE, DRIED, UNCOOKED (DRIED PLUM)") | regexm(FoodName,"RAISIN, SEEDLESS") | regexm(FoodName,"SOURSOP, RAW") | regexm(FoodName,"STRAWBERRY, RAW") | regexm(FoodName,"SUGAR-APPLE, RAW") | regexm(FoodName,"TAMARIND, RAW") | regexm(FoodName,"TANGERINE, MANARIN, RAW")
    replace DD_FoodCat=8 if regexm(FoodName, "LIVER, STEWED")
    replace DD_FoodCat=9 if regexm(FoodName,"HAMBURGER") | regexm(FoodName,"BACON, PAN-FRIED") | regexm(FoodName,"CHICKEN, BAKED/ROTISSERIE/ROASTED") | regexm(FoodName,"BEEF STEAK/CHUCK/CLOD/FILET") | regexm(FoodName,"GROUND BEEF") | regexm(FoodName,"SALAMI/BOLOGNA") | regexm(FoodName,"FRIED CHICKEN") | regexm(FoodName,"STEWED/CURRIED CHICKEN") | regexm(FoodName,"CHICKEN PATTY/FILET/SANDWICH") | regexm(FoodName,"CHICKEN NUGGETS/FINGERS") | regexm(FoodName,"CHICKEN SOUP") | regexm(FoodName,"CORNED BEEF, COOKED") | regexm(FoodName,"BOILED TURKEY") | regexm(FoodName,"HOT DOG") | regexm(FoodName,"GOAT, ROASTED") | regexm(FoodName,"GRAVY, TURKEY") | regexm(FoodName,"HAM") | regexm(FoodName,"LAMB STEW") | regexm(FoodName,"AUSTRALIAN LAMB CHOPS, BROILED") | regexm(FoodName,"LUNCHEON MEAT") | regexm(FoodName,"OXTAIL SOUP MIX") | regexm(FoodName,"PORK, SPARERIBS") | regexm(FoodName,"PORK TAIL, SIMMERED") | regexm(FoodName,"RABBIT, STEWED/ROASTEC") | regexm(FoodName,"LAMB SOUP") | regexm(FoodName,"SOUSE") | regexm(FoodName,"BEEF STEW/GRAVY") | regexm(FoodName,"PORK STEW") | regexm(FoodName,"ROAST TURKEY") | regexm(FoodName,"TURKEY SOUP, CHUNKY, RTS")
    replace DD_FoodCat=10 if regexm(FoodName,"EGG")
    replace DD_FoodCat=11 if regexm(FoodName,"FISH SOUP") | regexm(FoodName,"BAKED FISH") | regexm(FoodName,"FISH CAKE") | regexm(FoodName,"FRIED FISH") | regexm(FoodName,"FRIZZLED SALT FISH") | regexm(FoodName,"SALMON, PINK") | regexm(FoodName,"SARDINES IN OIL") | regexm(FoodName,"STEAMED FISH") | regexm(FoodName,"FISH STICKS, CLASSIC BREADED") | regexm(FoodName,"TUNA IN OIL") | regexm(FoodName,"ROE, MIXED SPECIES, BAKED OR BROILED") | regexm(FoodName,"ROE, MIXED SPECIES, RAW")
    replace DD_FoodCat=12 if regexm(FoodName,"KIDNEY BEANS") | regexm(FoodName,"LENTILS") | regexm(FoodName,"THREE BEAN SALAD, CANNED") | regexm(FoodName,"BAKED BEAN, ORIGINAL") | regexm(FoodName,"BLACKEYED PEA (COWPEA)") | regexm(FoodName,"GARBANZOS") | regexm(FoodName,"ORGANIC NASOYA SUPER FIRM CUBED TOFU") | regexm(FoodName,"PIGEON PEA, BOILED W/SALT (RED GRAM)") | regexm(FoodName,"SOY MILK")
    replace DD_FoodCat=13 if regexm(FoodName,"FLAX SEEDS") | regexm(FoodName,"DRIED FRUITS & NUTS, RTE") | regexm(FoodName,"NUTS DRIED FRUIT & NUTS, RTE") | regexm(FoodName,"TRAIL MIX, MIXED NUTS & RAISINS") | regexm(FoodName,"COCONUT MILK, RAW") | regexm(FoodName,"ALMOND MEAL/FLOUR") | regexm(FoodName,"ALMONDS, NO SALT") | regexm(FoodName,"ALMOND, HONEY ROASTED") | regexm(FoodName,"CASHEWS, NO SALT") | regexm(FoodName,"CASHEWS, SALTED") | regexm(FoodName,"MACADAMIA NUT, DRIED (BUSHNUT)") | regexm(FoodName,"PEANUTS, SALTED") | regexm(FoodName,"PEANUTS, NO SALT") | regexm(FoodName,"PEANUT BUTTER") | regexm(FoodName,"PUMPKIN & SQUASH SEED, DRIED") | regexm(FoodName,"SESAME SEED, WHOLE") | regexm(FoodName,"SUNFLOWER SEED, DRIED") | regexm(FoodName,"WALNUT, WHOLE")
    replace DD_FoodCat=14 if regexm(FoodName,"FLAVOURED MILKS") | regexm(FoodName,"CHEDDAR CHEESE") | regexm(FoodName,"SWISS CHEESE") | regexm(FoodName,"EVAPORATED MILK") | regexm(FoodName,"COW'S MILK, LESS FAT, FLUID, 2% MILKFAT W/O ADDED VIT-A & D") | regexm(FoodName,"COW'S MILK, WHOLE, 3.25% MILKFAT W/O ADDED VIT-A & D") | regexm(FoodName,"MILK, COW'S, CONDENSED, SWEETENED") | regexm(FoodName,"MILK, COW'S, NONFAT, EVAPORATED (SKIM)") | regexm(FoodName,"MILK, DRY, SKIM, POWDER, INSTANT (NONFAT)") | regexm(FoodName,"MILK, DRY, SKIM, POWDER, REGULAR (NONFAT)") | regexm(FoodName,"MILK, GOAT'S") | regexm(FoodName,"YOGURT, FRUIT, LOWFAT")
    replace DD_FoodCat=15 if regexm(FoodName,"GARLIC BUTTER") | regexm(FoodName,"BUTTER, REGULAR, UNSALTED") | regexm(FoodName,"MARGARINE") | regexm(FoodName,"COCONUT OIL, UNREFINED") | regexm(FoodName,"MAYONNAISE, REAL") | regexm(FoodName,"SOYBEAN OIL") | regexm(FoodName,"VEGETABLE CORN OIL")
    replace DD_FoodCat=16 if regexm(FoodName,"SWEETENER, ASPARTAME, EQUAL") | regexm(FoodName,"SORBET, MANGO") | regexm(FoodName,"CONKIES") | regexm(FoodName,"CORN CAKE") | regexm(FoodName,"ICE CREAM, COOKIES & CREAM") | regexm(FoodName,"VANILLA ICE CREAM") | regexm(FoodName,"ANIMAL CRACKERS") | regexm(FoodName,"CHOCOLATE BAR") | regexm(FoodName,"TOFFEE") | regexm(FoodName,"CANDIES, TRUFFLES, PFR") | regexm(FoodName,"FRUIT CANDY") | regexm(FoodName,"MINT CANDY") | regexm(FoodName,"CHEWING GUM") | regexm(FoodName,"CHOCOLATE CHIP COOKIE") | regexm(FoodName,"CHOCOLATE WAFER COOKIE") | regexm(FoodName,"COCONUT MACAROON COOKIE, PFR") | regexm(FoodName,"COOKIE, SUGAR") | regexm(FoodName,"FROSTING TOPPERS, VANILLA W/RAINBOW SPRINKLES") | regexm(FoodName,"GINGERSNAP COOKIE") | regexm(FoodName,"GOLDEN SYRUP") | regexm(FoodName,"GRAHAM CRACKER") | regexm(FoodName,"HONEY") | regexm(FoodName,"JAM") | regexm(FoodName,"LOLLIPOP") | regexm(FoodName,"MARSHMALLOW") | regexm(FoodName,"OATMEAL COOKIE") | regexm(FoodName,"OREO COOKIE") | regexm(FoodName,"PANCAKE SYRUP, ORIGINAL") | regexm(FoodName,"SNACK CAKE, SNOWBALLS") | regexm(FoodName,"SUGAR CAKE") | regexm(FoodName,"SUGAR, GRANULATED") | regexm(FoodName,"SYRUP, MAPLE") | regexm(FoodName,"TAMARIND BALLS") | regexm(FoodName,"VANILLA SANDWICH COOKIE") | regexm(FoodName,"VANILLA SANDWICH COOKIE - TEA TIME BISCUITS") | regexm(FoodName,"VANILLA WAFER") | regexm(FoodName,"DANISH PASTRY") | regexm(FoodName,"BANANA BREAD, PFR") | regexm(FoodName,"BREAKFAST TART, LOWFAT") | regexm(FoodName,"CAKE, POUND, PANQUE CASERO") | regexm(FoodName,"CHEESECAKE") | regexm(FoodName,"CHOCOLATE CAKE") | regexm(FoodName,"CINNAMON SCONE") | regexm(FoodName,"COCONUT BREAD") | regexm(FoodName,"CRANBERRY SAUCE") | regexm(FoodName,"DONUT") | regexm(FoodName,"FLAN, CARAMEL CUSTARD, PFR") | regexm(FoodName,"FRENCH VANILLA SWIRL BREAD") | regexm(FoodName,"FRUITCAKE") | regexm(FoodName,"GELATIN MIX") | regexm(FoodName,"GREAT CAKE") | regexm(FoodName,"FRUIT PIE, SLICE") | regexm(FoodName,"TURNOVER")
    replace DD_FoodCat=17 if regexm(FoodName,"MANGO JUICE") | regexm(FoodName,"CRANBERRY JUICE") | regexm(FoodName,"APPLE JUICE, UNSWEETENED")| regexm(FoodName,"PASSION FRUIT JUICE, RAW") | regexm(FoodName,"FRUIT 'N' YOGURT SMOOTHIE, STRAWBERRY KIWI") | regexm(FoodName,"GRAPE JUICE") |regexm(FoodName,"JUICE MIXED FRUIT JUICE") | regexm(FoodName,"GRAPEFRUIT JUICE") | regexm(FoodName,"ORANGE JUICE, UNSWEETENED") |  regexm(FoodName,"JUICE PEAR JUICE") | regexm(FoodName,"PINEAPPLE JUICE, UNSWEETENED") | regexm(FoodName,"LEMON JUICE, RAW") | regexm(FoodName,"LIME JUICE, RAW") | regexm(FoodName,"WILD BERRY JUICE") | regexm(FoodName,"PRUNE JUICE") | regexm(FoodName,"MIXED BERRY FRUIT SMOOTHIE") | regexm(FoodName,"PINEAPPLE JUICE") | regexm(FoodName,"ORANGE & PINEAPPLE JUICE") | regexm(FoodName,"PEAR JUICE") | regexm(FoodName,"CAESAR DRESSING") | regexm(FoodName,"DRESSING, RANCH") | regexm(FoodName,"BBQ SAUCE") | regexm(FoodName,"CATSUP / KETCHUP") | regexm(FoodName,"CHOPPED SEASONING") | regexm(FoodName,"HOT PEPPER SAUCE, ORIGINAL") | regexm(FoodName,"SALSA, RTS") | regexm(FoodName,"PASTA SAUCE, 7 HERB TOMATO") | regexm(FoodName,"ALOE VERA JUICE") | regexm(FoodName,"PINA COLADA") | regexm(FoodName,"FRUIT SLUSH") | regexm(FoodName,"GINGER ALE") | regexm(FoodName,"COCA COLA") | regexm(FoodName,"CREAM SODA") | regexm(FoodName,"GINGER BEER") | regexm(FoodName,"DRINK LEMONADE") | regexm(FoodName,"MAUBY DRINK") | regexm(FoodName,"ORANGE FLAVOUR DRINK") | regexm(FoodName,"ENERGY DRINK POWERADE, LEMON-LIME, RTD") | regexm(FoodName,"ENERGY DRINK W/CAFFEINE") | regexm(FoodName,"ENERGY DRINK, MONSTER") | regexm(FoodName,"ISLAND GUAVA DRINK") | regexm(FoodName,"JUICE APPLE & CHERRY JUICE") | regexm(FoodName,"MALT DRINK") | regexm(FoodName,"MANDARIN PAPAYA DRINK") | regexm(FoodName,"MOUNTAIN DEW - TING") | regexm(FoodName,"ORANGE MANGO TANGO DRINK") | regexm(FoodName,"ORANGE SODA, CARBONATED") | regexm(FoodName,"PASSIONFRUIT FRUIT JUICE COCKTAIL") | regexm(FoodName,"PEPSI TWIST") | regexm(FoodName,"PLUS - BARBADIAN SPORTS DRINK") | regexm(FoodName,"RED BULL, SUGAR FREE") | regexm(FoodName,"CREAM SODA") | regexm(FoodName,"SODA DIET COKE") | regexm(FoodName,"FRUTEE") | regexm(FoodName,"SODA ORANGE SODA, CARBONATED") | regexm(FoodName,"SODA PEPPER-TYPE SODA W/CAFFEINE, CARBONATED") | regexm(FoodName,"SPRITE") | regexm(FoodName,"90 PROOF GIN, RUM, VODKA, WHISKEY") | regexm(FoodName,"BAY LEAF, CRUMBLED") | regexm(FoodName,"BEER, REGULAR") | regexm(FoodName,"GUINNESS") | regexm(FoodName,"BITTERS") | regexm(FoodName,) | regexm(FoodName,"CHOCOLATE DRINK MIX") | regexm(FoodName,"CINNAMON, GROUND") | regexm(FoodName,"COFFEE, BREWED, DECAFFEINATED") | regexm(FoodName,"COFFEE, HAZELNUT ROAST, INSTANT, PAD") | regexm(FoodName,"COFFEE, INSTANT") | regexm(FoodName,"COFFEE, INSTANT, FRENCH VANILLA W/ASPARTAME ,") | regexm(FoodName,"COFFEE, INSTANT, MOCHA, POWDER, WHITENER, LOW CAL") | regexm(FoodName,"CURRY POWDER") | regexm(FoodName,"ENSURE, RTU") | regexm(FoodName,"GINGER, GROUND") | regexm(FoodName,"HORLICKS - MALTED MILK, NATURAL FLAVOUR, 2% BF MILK ADDED") | regexm(FoodName,"HOT CHOCOLATE, COCOA") | regexm(FoodName,"LIQUEUR, CREME DE MENTHE") | regexm(FoodName,"ICED LATTE, HAZELNUT") | regexm(FoodName,"MOCHA LATTE") | regexm(FoodName,"MUSTARD, YELLOW") | regexm(FoodName,"ORIGINAL CREAMER") | regexm(FoodName,"SALAD DRESSING") | regexm(FoodName,"SALT, TABLE") | regexm(FoodName,"SOY SAUCE (SHOYU)") | regexm(FoodName,"TARTAR SAUCE") | regexm(FoodName,"TEA ICED TEA, LEMON FLAVOR, RTD") | regexm(FoodName,"TEA, BLACK") | regexm(FoodName,"TEA, BREWED, DECAFFEINATED (BLACK TEA)") | regexm(FoodName,"TEA, GINSENG PLUS, BREWED") | regexm(FoodName,"TEA, GREEN") | regexm(FoodName,"TEA, HERBAL") | regexm(FoodName,"TEA, LEMON") | regexm(FoodName,"TEA, PEPPERMINT, BREWED") | regexm(FoodName,"VINEGAR, APPLE CIDER") | regexm(FoodName,"WINE") | regexm(FoodName,"WORCESTERSHIRE") | regexm(FoodName,"LEMON LIME SPRITZER") | regexm(FoodName,"SODA LEMON-LIME SODA, CARBONATED") | regexm(FoodName,"TROPICAL FRUIT FRUIT SMOOTHIE") | regexm(FoodName,"BLENDED SMOOTHIE - BANANA OATS MILK HONEY YOGURT") | regexm(FoodName,"SMOOTHIE")

// Questions/Problems
// 1. Whenever a word occurs twice, it replaces the other. For example "HONEY NUT CHERRIOS" is categorized as a Cereal but "HONEY" is in Sweets, when I run the do-file "HONEY NUT CHEERIOS" Is then replaced as a sweet because of the word "HONEY"
// 2. Error at the end says invalid syntax
// 3. Some just seem to be missing.. Eg. "BBQ SAUCE" and I'm not sure why
    
    ** Adding Labels
    label variable DD_FoodCat "Dietatry Diversity Food Categories"
    label define DD_FoodCat 1 "Cereals" 2 "White tubers and roots, plantains" 3 "Vitamin A Rich Veg" 4 "Dark Green Leafy Veg" 5 "Other Veg" 6 "Vitamin A Rich Fruits" 7 "Other Fruits" 8 "Organ Meat" 9 "Flesh Meat" 10 "Eggs" 11 "Fish and Seafood" 12 "Legumes" 13 "Nuts & Seeds" 14 "Milk and Milk Products" 15 "Oils and Fats" 16 "Sweets" 17 "Spices, Condiments and Beverages"
    label values DD_FoodCat DD_FoodCat


    **--------------------------------------------------------------------------------
    ** PART 3: Further grouping for Individual Dietary Diversity
    **--------------------------------------------------------------------------------

    ** Aggregation of food groups 
    ** 1. Starchy staples - FoodCats 1 & 2
    ** 2. Dark Green leafy vegetables - FoodCat 4
    ** 3. Other Vitamin A rich fruits and vegetables - FoodCats 3 & 6
    ** 4. Other Fruits and Vegetables - FoodCats 5 & 7
    ** 5. Organ Meat - FoodCat 8
    ** 6. Meat and Fish - Food Cats 9 & 11
    ** 7. Eggs - FoodCats 10
    ** 8. Legumes, Nuts and Seeds - FoodCats 12 & 13
    ** 9. Milk and milk products - FoodCats 14


    gen IDD=.
    replace IDD=1 if DD_FoodCat==1 | DD_FoodCat==2
    replace IDD=2 if DD_FoodCat==4
    replace IDD=3 if DD_FoodCat== 3 | DD_FoodCat==6
    replace IDD=4 if DD_FoodCat==5 | DD_FoodCat==7
    replace IDD=5 if DD_FoodCat==8
    replace IDD=6 if DD_FoodCat==9 | DD_FoodCat==11
    replace IDD=7 if DD_FoodCat==10
    replace IDD=8 if DD_FoodCat==12 | DD_FoodCat==13
    replace IDD=9 if DD_FoodCat=14

    