//SUITS

//SUITS

//SUITS

/obj/item/clothing/suit/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE

/obj/item/clothing/suit/vampire/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 15, "suit", FALSE)

/obj/item/clothing/suit/vampire/trench/malkav
	icon_state = "malkav_coat"

/obj/item/clothing/suit/hooded/heisenberg
	name = "chemical PPE Worksuit"
	desc = "A set of PPE, made for working with chemicals."
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "heisenberg"
	inhand_icon_state = "heisenberg"
	body_parts_covered = CHEST | GROIN | ARMS
	cold_protection = CHEST | GROIN | ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 0, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 0, RAD = 0, FIRE = 50, ACID = 100, WOUND = 10)
	hoodtype = /obj/item/clothing/head/hooded/heisenberg_hood
	body_worn = TRUE

/obj/item/clothing/head/hooded/heisenberg_hood
	name = "chemical hood"
	desc = "A hood attached to a chemical worksuit."
	icon_state = "heisenberg_helm"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR | HIDEEARS
	armor = list(MELEE = 0, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 0, RAD = 0, FIRE = 50, ACID = 100, WOUND = 10)
	body_worn = TRUE

//** SPOOOOKY ROBES FROM THE CAPPADOCIAN UPDATE **//
/obj/item/clothing/suit/hooded/robes
	name = "white robe"
	desc = "Some angelic-looking robes."
	icon_state = "robes"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	inhand_icon_state = "robes"
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST | GROIN | LEGS | ARMS
	cold_protection = CHEST | GROIN | LEGS | ARMS
	hoodtype = /obj/item/clothing/head/hooded/robes_hood
	body_worn = TRUE

/obj/item/clothing/head/hooded/robes_hood
	name = "white hood"
	desc = "The hood of some angelic-looking robes."
	icon_state = "robes_hood"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEHAIR | HIDEEARS
	body_worn = TRUE

/obj/item/clothing/suit/hooded/robes/black
	name = "black robe"
	desc = "Some creepy-looking robes."
	icon_state = "robes_black"
	inhand_icon_state = "robes_black"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/black

/obj/item/clothing/head/hooded/robes_hood/black
	name = "black hood"
	desc = "The hood of some creepy-looking robes."
	icon_state = "robes_black_hood"

/obj/item/clothing/suit/hooded/robes/grey
	name = "grey robe"
	desc = "Some somber-looking robes."
	icon_state = "robes_grey"
	inhand_icon_state = "robes_grey"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/grey

/obj/item/clothing/head/hooded/robes_hood/grey
	name = "grey hood"
	desc = "The hood of some somber-looking robes."
	icon_state = "robes_grey_hood"

/obj/item/clothing/suit/hooded/robes/darkred
	name = "dark red robe"
	desc = "Some zealous-looking robes."
	icon_state = "robes_darkred"
	inhand_icon_state = "robes_darkred"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/darkred

/obj/item/clothing/head/hooded/robes_hood/darkred
	name = "dark red hood"
	desc = "The hood of some zealous-looking robes."
	icon_state = "robes_darkred_hood"

/obj/item/clothing/suit/hooded/robes/yellow
	name = "yellow robe"
	desc = "Some happy-looking robes."
	icon_state = "robes_yellow"
	inhand_icon_state = "robes_yellow"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/yellow

/obj/item/clothing/head/hooded/robes_hood/yellow
	name = "yellow hood"
	desc = "The hood of some happy-looking robes."
	icon_state = "robes_yellow_hood"

/obj/item/clothing/suit/hooded/robes/green
	name = "green robe"
	desc = "Some earthy-looking robes."
	icon_state = "robes_green"
	inhand_icon_state = "robes_green"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/green

/obj/item/clothing/head/hooded/robes_hood/green
	name = "green hood"
	desc = "The hood of some earthy-looking robes."
	icon_state = "robes_green_hood"

/obj/item/clothing/suit/hooded/robes/red
	name = "red robe"
	desc = "Some furious-looking robes."
	icon_state = "robes_red"
	inhand_icon_state = "robes_red"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/red

/obj/item/clothing/head/hooded/robes_hood/red
	name = "red hood"
	desc = "The hood of some furious-looking robes."
	icon_state = "robes_red_hood"

/obj/item/clothing/suit/hooded/robes/purple
	name = "purple robe"
	desc = "Some elegant-looking robes."
	icon_state = "robes_purple"
	inhand_icon_state = "robes_purple"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/purple

/obj/item/clothing/head/hooded/robes_hood/purple
	name = "purple hood"
	desc = "The hood of some elegant-looking robes."
	icon_state = "robes_purple_hood"

/obj/item/clothing/suit/hooded/robes/blue
	name = "blue robe"
	desc = "Some watery-looking robes."
	icon_state = "robes_blue"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/blue

/obj/item/clothing/head/hooded/robes_hood/blue
	name = "blue hood"
	desc = "The hood of some watery-looking robes."
	icon_state = "robes_blue_hood"

/obj/item/clothing/suit/hooded/robes/tremere
	name = "tremere robes"
	desc = "Black robes with red highlights, marked with the emblem of House Tremere."
	icon_state = "tremere_robes"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/tremere

/obj/item/clothing/head/hooded/robes_hood/tremere
	name = "tremere hood"
	desc = "A black hood with red highlights, marked with the emblem of House Tremere."
	icon_state = "tremere_hood"

/obj/item/clothing/suit/hooded/robes/magister
	name = "magister robes"
	desc = "A red robe with an ornate golden trim, marked with the emblem of House Tremere."
	icon_state = "magister_robes"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/magister

/obj/item/clothing/head/hooded/robes_hood/magister
	name = "magister hood"
	desc = "A red hood with an ornate golden trim, marked with the emblem of House Tremere."
	icon_state = "magister_hood"

/obj/item/clothing/suit/hooded/hoodie
	name = "hoodie"
	desc = "A simple hoodie."
	icon_state = "hoodie"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = CHEST | GROIN | ARMS
	cold_protection = CHEST | GROIN | ARMS
	hoodtype = /obj/item/clothing/head/hooded/hood_hood
	body_worn = TRUE

/obj/item/clothing/head/hooded/hood_hood
	name = "hoodie hood"
	desc = "A hoodies hoodie hood."
	icon_state = "hoodie_hood"
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEHAIR | HIDEEARS
	body_worn = TRUE

/obj/item/clothing/suit/hooded/hoodie/hoodie_pim
	name = "intruder pim hoodie"
	desc = "A hoodie of your favourite Intruder Pim character, Grr."
	icon_state = "hoodie_zim"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/hood_pim

/obj/item/clothing/head/hooded/hood_hood/hood_pim
	name = "intruder pim hoodie hood"
	desc = "A hood resembling your favourite Intruder Pim character, Grr."
	icon_state = "hoodie_zim_hood"

/obj/item/clothing/suit/vampire/nun
	name = "Sisterly Frock"
	desc = "The habit of a religious sister of the catholic church."
	icon_state = "nun"

/obj/item/clothing/suit/vampire/coat
	name = "brown coat"
	desc = "A warm and heavy brown coat."
	icon_state = "coat1"

/obj/item/clothing/suit/vampire/coat/alt
	name = "green coat"
	desc = "A warm and heavy green coat."
	icon_state = "coat2"

/obj/item/clothing/suit/vampire/coat/winter
	name = "black fur coat"
	desc = "Warm and heavy clothing."
	icon_state = "winter1"

/obj/item/clothing/suit/vampire/coat/winter/alt
	name = "brown fur coat"
	icon_state = "winter2"

/obj/item/clothing/suit/vampire/slickbackcoat
	name = "opulent coat"
	desc = "Lavish, luxurious, and deeply purple. Slickback Clothing Co. It exudes immense energy."
	icon_state = "slickbackcoat"
	armor = list(MELEE = 5, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 5)

/obj/item/clothing/suit/vampire/jacket
	name = "black leather jacket"
	desc = "True clothing for any punk. Provides some kind of protection."
	icon_state = "jacket1"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)
	allowed = list(
		/obj/item/card/id,
		/obj/item/flashlight,
	)

/obj/item/clothing/suit/vampire/jacket/cut
	name = "cropped black leather jacket"
	desc = "True clothing for any punk, this one cut to expose one's midrift. Provides some kind of proteciton."
	icon_state = "jacket1_cut"

/obj/item/clothing/suit/vampire/jacket/fbi
	name = "Federal Bureau of Investigation jacket"
	desc = "\"FBI OPEN UP!!\""
	icon_state = "fbi"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)
	allowed = list(
		/obj/item/card/id,
		/obj/item/flashlight,
		/obj/item/melee/classic_baton/vampire,
		/obj/item/restraints/handcuffs
	)
/obj/item/clothing/suit/vampire/jacket/punk
	icon_state = "punk"
	armor = list(MELEE = 50, BULLET = 50, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/jacket/better
	name = "brown leather jacket"
	icon_state = "jacket2"
	armor = list(MELEE = 35, BULLET = 35, LASER = 10, ENERGY = 10, BOMB = 35, BIO = 0, RAD = 0, FIRE = 35, ACID = 10, WOUND = 35)

/obj/item/clothing/suit/vampire/jacket/better/cut
	name = "cropped brown leather jacket"
	desc = "True clothing for any punk, this one cut to expose one's midrift. Provides some kind of proteciton."
	icon_state = "jacket2_cut"

/obj/item/clothing/suit/vampire/jacket/red
	name = "red leather jacket"
	icon_state = "jacket3"
	armor = list(MELEE = 35, BULLET = 35, LASER = 10, ENERGY = 10, BOMB = 35, BIO = 0, RAD = 0, FIRE = 35, ACID = 10, WOUND = 35)

/obj/item/clothing/suit/vampire/jacket/red/cut
	name = "cropped red leather jacket"
	desc = "True clothing for any punk, this one cut to expose one's midrift. Provides some kind of proteciton."
	icon_state = "jacket3_cut"

/obj/item/clothing/suit/vampire/jacket/better/armored
	name = "armored leather jacket"
	armor = list(MELEE = 45, BULLET = 45, LASER = 10, ENERGY = 10, BOMB = 35, BIO = 0, RAD = 0, FIRE = 45, ACID = 10,WOUND = 35);

/obj/item/clothing/suit/vampire/trench
	name = "trenchcoat"
	desc = "Best noir clothes for night. Provides some kind of protection."
	icon_state = "trench1"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/trench/alt
	name = "brown trenchcoat"
	icon_state = "trench2"

/obj/item/clothing/suit/vampire/trench/alt/armored
	name = "armored trenchcoat"
	icon_state = "trench2"
	armor = list("melee"=50,"bullet"=50,"laser"=50,"energy"=10,"bomb"=40,"bio"=0,"rad"=0,"fire"=40,"acid"=10,"wound"=25);
	max_integrity = 1000;

/obj/item/clothing/suit/vampire/trench/archive
	name = "rich trenchcoat"
	desc = "Best choise for pleasant life... or not."
	icon_state = "trench3"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/trench/strauss
	name = "red trenchcoat"
	desc = "True power lies not in wealth, but in the things it affords you."
	icon_state = "strauss_coat"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 25, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/trench/tzi
	name = "fleshcoat"
	desc = "HUMAN LEATHER JACKET."
	icon_state = "trench_tzi"
	armor = list(MELEE = 50, BULLET = 50, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 50)
	clothing_traits = list(TRAIT_UNMASQUERADE)

/obj/item/clothing/suit/vampire/trench/voivode
	name = "regal coat"
	desc = "A beautiful jacket. Whoever owns this must be important."
	icon_state = "voicoat"
	armor = list(MELEE = 60, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/vest
	name = "bulletproof vest"
	desc = "Durable, lightweight vest designed to protect against most threats efficiently."
	icon_state = "vest"
	armor = list(MELEE = 55, BULLET = 55, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)
	allowed = list(
		/obj/item/card/id,
		/obj/item/flashlight,
		/obj/item/melee/classic_baton/vampire,
		/obj/item/restraints/handcuffs
	)

/obj/item/clothing/suit/vampire/vest/medieval
	name = "medieval vest"
	desc = "Probably spanish. Provides good protection."
	icon_state = "medieval"
	armor = list(MELEE = 55, BULLET = 55, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)

/obj/item/clothing/suit/vampire/coat/leopard
	name = "leopard coat"
	desc = "This'll give PETA something to cry about."
	icon_state = "leopard_coat"
//Army

/obj/item/clothing/suit/vampire/vest/army
	name = "army vest"
	desc = "Army equipment. Provides great protection against blunt force."
	icon_state = "army"
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 70, BULLET = 70, LASER = 10, ENERGY = 10, BOMB = 55, BIO = 0, RAD = 0, FIRE = 45, ACID = 10, WOUND = 25)
//	clothing_traits = list(TRAIT_UNMASQUERADE)
	masquerade_violating = TRUE

/obj/item/clothing/suit/vampire/eod
	name = "EOD suit"
	desc = "Demoman equipment. Provides best protection against nearly everything."
	icon_state = "eod"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 2
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 90, BULLET = 90, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 0, RAD = 0, FIRE = 70, ACID = 90, WOUND = 50)
//	clothing_traits = list(TRAIT_UNMASQUERADE)
	masquerade_violating = TRUE

/obj/item/clothing/suit/vampire/bogatyr
	name = "bogatyr armor"
	desc = "A regal set of armor, made from what seem to be unknown materials. In truth, the Voivodes know well how to mold flesh and bone."
	icon_state = "bogatyr_armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 65, BULLET = 65, LASER = 15, ENERGY = 15, BOMB = 20, BIO = 0, RAD = 0, FIRE = 55, ACID = 70, WOUND = 35)
//	clothing_traits = list(TRAIT_UNMASQUERADE)

/obj/item/clothing/suit/vampire/labcoat
	name = "labcoat"
	desc = "For medicine and research purposes."
	icon_state = "labcoat"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 90, WOUND = 10)

/obj/item/clothing/suit/vampire/labcoat/director
	name = "clinic director's labcoat"
	desc = "Special labcoat for clinic director with the Saint John's Hospital emblem."
	icon_state = "director"

/obj/item/clothing/suit/vampire/fancy_gray
	name = "fancy gray jacket"
	desc = "Gray-colored jacket"
	icon_state = "fancy_gray_jacket"

/obj/item/clothing/suit/vampire/fancy_red
	name = "fancy red jacket"
	desc = "Red-colored jacket"
	icon_state = "fancy_red_jacket"

/obj/item/clothing/suit/vampire/majima_jacket
	name = "too much fancy jacket"
	desc = "Woahhh, check it out! Two macho men havin' a tussle in the nude!? This is a world of shit I didn't know even existed..."
	icon_state = "majima_jacket"

/obj/item/clothing/suit/vampire/bahari
	name = "dark mother's suit"
	desc = "When I first tasted the fruit of the Trees,\
			felt the seeds of Life and Knowledge, burn within me, I swore that day I would not turn back..."
	icon_state = "bahari"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/kasaya
	name = "kasaya"
	desc = "A traditional robe worn by monks and nuns of the Buddhist faith."
	icon_state = "kasaya"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/imam
	name = "imam robe"
	desc = "A traditional robe worn by imams of the Islamic faith."
	icon_state = "imam"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/noddist
	name = "noddist robe"
	desc = "Shine black the sun! Shine blood the moon! Gehenna is coming soon."
	icon_state = "noddist"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/suit/vampire/orthodox
	name = "orthodox robe"
	desc = "A traditional robe worn by priests of the Orthodox faith."
	icon_state = "vestments"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

//Pentex Overwear

/obj/item/clothing/suit/pentex
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE

/obj/item/clothing/suit/vampire/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 15, "suit", FALSE)

/obj/item/clothing/suit/pentex/pentex_labcoat
	name = "Endron labcoat"
	desc = "A crisp white labcoat. This one has the Endron International logo stiched onto the breast!"
	icon_state = "pentex_closedlabcoat"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 90, WOUND = 10)

/obj/item/clothing/suit/pentex/pentex_labcoat_alt
	name = "Endron labcoat"
	desc = "A crisp white labcoat. This one has a green trim and the Endron International logo stiched onto the breast!"
	icon_state = "pentex_labcoat_alt"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 90, WOUND = 10)


/obj/item/clothing/suit/vampire/greatcoat
	name = "greatcoat"
	desc = "A heavy greatcoat."
	icon_state = "gentlecoat"
	inhand_icon_state = "black_coat"

/obj/item/clothing/suit/vampire/det_trench
	name = "classic trenchcoat"
	desc = "A rugged brown trenchcoat for the less-than-modern investigator."
	icon_state = "detective"
	inhand_icon_state = "detective"

/obj/item/clothing/suit/vampire/det_trench_grey
	name = "grey trenchcoat"
	desc = "A long grey trenchcoat for the less-than-modern investigator."
	icon_state = "detective2"
	inhand_icon_state = "detective2"

/obj/item/clothing/suit/vampire/shawl_white
	name = "white shawl"
	desc = "A long silk shawl, to be draped over the arms."
	icon_state = "shawl_white"

/obj/item/clothing/suit/vampire/charcoalsuit
	name = "charcoal suit jacket"
	desc = "A charcoal suit jacket."
	icon_state = "suitjacket_charcoal"
	inhand_icon_state = "suit_black"

/obj/item/clothing/suit/vampire/navysuit
	name = "navy suit jacket"
	desc = "A navy suit jacket."
	icon_state = "suitjacket_navy"
	inhand_icon_state = "suit_navy"

/obj/item/clothing/suit/vampire/burgundysuit
	name = "burgundy suit jacket"
	desc = "A burgundy suit jacket."
	icon_state = "suitjacket_burgundy"
	inhand_icon_state = "suit_red"

/obj/item/clothing/suit/vampire/checkeredsuit
	name = "checkered suit jacket"
	desc = "A checkered suit jacket."
	icon_state = "suitjacket_checkered"
	inhand_icon_state = "suit_grey"

/obj/item/clothing/suit/vampire/tansuit
	name = "tan suit jacket"
	desc = "A tan suit jacket."
	icon_state = "suitjacket_tan"
	inhand_icon_state = "suit_orange"


/obj/item/clothing/suit/vampire/toggle/suitjacket
	togglename = "buttons"

/obj/item/clothing/suit/vampire/toggle/suitjacket/blue
	name = "blue suit jacket"
	desc = "A blue suit jacket."
	icon_state = "suitjacket_blue"
	inhand_icon_state = "suit_blue"

/obj/item/clothing/suit/vampire/toggle/suitjacket/purple
	name = "purple suit jacket"
	desc = "A purple suit jacket. Quite the fashion statement."
	icon_state = "suitjacket_purp"
	inhand_icon_state = "suit_purple"

/obj/item/clothing/suit/vampire/toggle/suitjacket/black
	name = "black suit jacket"
	desc = "A black suit jacket."
	icon_state = "suitjacket_black"
	inhand_icon_state = "suit_black"

/obj/item/clothing/suit/vampire/toggle/leather
	name = "black leather jacket"
	desc = "True clothing for any punk."
	icon_state = "leather_jacket"

/obj/item/clothing/suit/vampire/toggle/leather_brown
	name = "brown leather jacket"
	desc = "True clothing for any biker."
	icon_state = "brown_jacket"

/obj/item/clothing/suit/vampire/toggle/leather_sleeveless
	name = "black leather vest"
	desc = "True clothing for any punk."
	icon_state = "leather_jacket_sleeveless"

/obj/item/clothing/suit/vampire/toggle/leather_brown_sleeveless
	name = "brown leather vest"
	desc = "True clothing for any biker."
	icon_state = "brown_jacket_sleeveless"

/obj/item/clothing/suit/vampire/toggle/hoodie_grey
	name = "grey zipper hoodie"
	desc = "A simple grey hoodie."
	icon_state = "grey_hoodie"

/obj/item/clothing/suit/vampire/toggle/hoodie_black
	name = "black zipper hoodie"
	desc = "A simple black hoodie."
	icon_state = "black_hoodie"

/obj/item/clothing/suit/vampire/toggle/hoodie_red
	name = "red zipper hoodie"
	desc = "A simple red hoodie."
	icon_state = "red_hoodie"

/obj/item/clothing/suit/vampire/toggle/hoodie_blue
	name = "blue zipper hoodie"
	desc = "A simple blue hoodie."
	icon_state = "blue_hoodie"

/obj/item/clothing/suit/vampire/toggle/hoodie_orange
	name = "orange zipper hoodie"
	desc = "A simple orange hoodie."
	icon_state = "orange_hoodie"

/obj/item/clothing/suit/vampire/toggle/hoodie_pink
	name = "pink zipper hoodie"
	desc = "A simple pink hoodie."
	icon_state = "pink_hoodie"

/obj/item/clothing/suit/vampire/toggle/trackjacket
	name = "black track jacket"
	desc = "A light, breathable athletic jacket."
	icon_state = "trackjacket"

/obj/item/clothing/suit/vampire/toggle/trackjacketblue
	name = "blue track jacket"
	desc = "A light, breathable athletic jacket."
	icon_state = "trackjacketblue"

/obj/item/clothing/suit/vampire/toggle/trackjacketgreen
	name = "green track jacket"
	desc = "A light, breathable athletic jacket."
	icon_state = "trackjacketgreen"

/obj/item/clothing/suit/vampire/toggle/trackjacketred
	name = "red track jacket"
	desc = "A light, breathable athletic jacket."
	icon_state = "trackjacketred"

/obj/item/clothing/suit/vampire/toggle/trackjacketwhite
	name = "white track jacket"
	desc = "A light, breathable athletic jacket."
	icon_state = "trackjacketwhite"

/obj/item/clothing/suit/vampire/toggle/yellow_dep_jacket
	name = "yellow fur-lined jacket"
	desc = "A warm wool-lined jacket."
	icon_state = "engi_dep_jacket"

/obj/item/clothing/suit/vampire/toggle/red_dep_jacket
	name = "red fur-lined jacket"
	desc = "A warm wool-lined jacket."
	icon_state = "sec_dep_jacket"

/obj/item/clothing/suit/vampire/toggle/white_dep_jacket
	name = "white fur-lined jacket"
	desc = "A warm wool-lined jacket."
	icon_state = "med_dep_jacket"

/obj/item/clothing/suit/vampire/toggle/brown_dep_jacket
	name = "brown fur-lined jacket"
	desc = "A warm wool-lined jacket."
	icon_state = "supply_dep_jacket"

/obj/item/clothing/suit/vampire/toggle/grey_dep_jacket
	name = "grey fur-lined jacket"
	desc = "A warm wool-lined jacket."
	icon_state = "grey_dep_jacket"

/obj/item/clothing/suit/vampire/toggle/blue_dep_jacket
	name = "blue fur-lined jacket"
	desc = "A warm wool-lined jacket."
	icon_state = "blue_dep_jacket"

/obj/item/clothing/suit/vampire/toggle/bomber
	name = "bomber jacket"
	desc = "A classic leather and wool jacket popular in WW2."
	icon_state = "bomber"

/obj/item/clothing/suit/vampire/toggle/retro_bomber
	name = "asymmetical aviator jacket"
	desc = "A classic leather and wool jacket in the style of early aviators."
	icon_state = "retro_bomber"


//FLANNELS
//these use a different system from other toggles bc they have three different things you can toggle
/obj/item/clothing/suit/vampire/flannel
	name = "grey flannel shirt"
	desc = "A comfy, grey flannel shirt. Unleash your inner hipster."
	icon_state = "flannel"
	inhand_icon_state = "black_coat"
	var/rolled = 0
	var/tucked = 0
	var/buttoned = 0

/obj/item/clothing/suit/vampire/flannel/verb/roll_sleeves()
	set name = "Roll Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living))
		return
	if(usr.stat)
		return

	if(rolled == 0)
		rolled = 1
		body_parts_covered &= ~(ARMS)
		to_chat(usr, "<span class='notice'>You roll up the sleeves of your [src].</span>")
	else
		rolled = 0
		body_parts_covered = initial(body_parts_covered)
		to_chat(usr, "<span class='notice'>You roll down the sleeves of your [src].</span>")
	update_icon_state()
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/vampire/flannel/verb/tuck()
	set name = "Toggle Shirt Tucking"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(tucked == 0)
		tucked = 1
		to_chat(usr, "<span class='notice'>You tuck in your your [src].</span>")
	else
		tucked = 0
		to_chat(usr, "<span class='notice'>You untuck your [src].</span>")
	update_icon_state()
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/vampire/flannel/verb/button()
	set name = "Toggle Shirt Buttons"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return

	if(buttoned == 0)
		buttoned = 1
		to_chat(usr, "<span class='notice'>You button your [src].</span>")
	else
		buttoned = 0
		to_chat(usr, "<span class='notice'>You unbutton your [src].</span>")
	update_icon_state()
	usr.update_inv_wear_suit()


/obj/item/clothing/suit/vampire/flannel/red
	name = "red flannel shirt"
	desc = "A comfy, red flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_red"

/obj/item/clothing/suit/vampire/flannel/aqua
	name = "aqua flannel shirt"
	desc = "A comfy, aqua flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_aqua"

/obj/item/clothing/suit/vampire/flannel/brown
	name = "brown flannel shirt"
	desc = "A comfy, brown flannel shirt.  Unleash your inner hipster."
	icon_state = "flannel_brown"

//Letterman jackets

/obj/item/clothing/suit/vampire/letterman_c
	name = "letterman jacket, UCLA"
	desc = "A blue and gold UCLA varsity jacket."
	icon_state = "letterman_c"

/obj/item/clothing/suit/vampire/letterman_black
	name = "black letterman jacket"
	desc = "A letterman jacket in a moody black and white."
	icon_state = "varsity"

/obj/item/clothing/suit/vampire/letterman_purple
	name = "purple letterman jacket"
	desc = "A letterman jacket in a deep purple."
	icon_state = "varsity_purple"

//Military jacket

/obj/item/clothing/suit/vampire/military_white
	name = "white military jacket"
	desc = "A white canvas jacket styled after classic American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_white"

/obj/item/clothing/suit/vampire/military_tan
	name = "tan military jacket"
	desc = "A tan canvas jacket styled after classic American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_tan"

/obj/item/clothing/suit/vampire/military_navy
	name = "navy military jacket"
	desc = "A navy canvas jacket styled after classic American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_navy"

/obj/item/clothing/suit/vampire/military_grey
	name = "grey military jacket"
	desc = "A grey canvas jacket styled after classic American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_grey"

/obj/item/clothing/suit/vampire/military_black
	name = "black military jacket"
	desc = "A black canvas jacket styled after classic American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket_black"


/obj/item/clothing/suit/hooded/hoodie/parka_yellow
	name = "yellow parka"
	desc = "A heavy fur-lined winter coat, for all the snow in LA."
	icon_state = "yellowpark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka_yellow

/obj/item/clothing/head/hooded/hood_hood/parka_yellow
	name = "yellow parka hood"
	desc = "A heavy fur-lined hood, for all the snow in LA."
	icon_state = "yellowpark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka_red
	name = "red parka"
	desc = "A heavy fur-lined winter coat, for all the snow in LA."
	icon_state = "redpark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka_red

/obj/item/clothing/head/hooded/hood_hood/parka_red
	name = "red parka hood"
	desc = "A heavy fur-lined hood, for all the snow in LA."
	icon_state = "redpark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka_purple
	name = "purple parka"
	desc = "A heavy fur-lined winter coat, for all the snow in LA."
	icon_state = "purplepark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka_purple

/obj/item/clothing/head/hooded/hood_hood/parka_purple
	name = "purple parka hood"
	desc = "A heavy fur-lined hood, for all the snow in LA."
	icon_state = "purplepark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka_green
	name = "green parka"
	desc = "A heavy fur-lined winter coat, for all the snow in LA."
	icon_state = "greenpark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka_green

/obj/item/clothing/head/hooded/hood_hood/parka_green
	name = "green parka hood"
	desc = "A heavy fur-lined hood, for all the snow in LA."
	icon_state = "greenpark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka_blue
	name = "blue parka"
	desc = "A heavy fur-lined winter coat, for all the snow in LA."
	icon_state = "bluepark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka_blue

/obj/item/clothing/head/hooded/hood_hood/parka_blue
	name = "blue parka hood"
	desc = "A heavy fur-lined hood, for all the snow in LA."
	icon_state = "bluepark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka_vintage
	name = "vintage parka"
	desc = "A heavy fur-lined winter coat, for all the snow in LA."
	icon_state = "vintagepark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka_vintage

/obj/item/clothing/head/hooded/hood_hood/parka_vintage
	name = "vintage parka hood"
	desc = "A heavy fur-lined hood, for all the snow in LA."
	icon_state = "vintagepark_hood"
