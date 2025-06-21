/datum/crafting_recipe/methpack
	name = "Make Meth Adulterated Bloodpack"
	time = 25
	reqs = list(/obj/item/reagent_containers/food/drinks/meth = 1, /obj/item/reagent_containers/blood = 1, /datum/reagent/blood = 200)
	result = /obj/item/reagent_containers/blood/methpack
	always_available = TRUE
	category = CAT_DRUGS

/datum/crafting_recipe/morphpack1
	name = "Make Morphine Adulterated Bloodpack (Syringe)"
	time = 25
	reqs = list(/obj/item/reagent_containers/syringe/contraband/morphine = 1, /obj/item/reagent_containers/blood = 1, /datum/reagent/blood = 200)
	result = /obj/item/reagent_containers/blood/morphpack
	always_available = TRUE
	category = CAT_DRUGS

/datum/crafting_recipe/morphpack2
	name = "Make Morphine Adulterated Bloodpack (Reagent)"
	time = 25
	reqs = list(/datum/reagent/medicine/morphine = 15, /obj/item/reagent_containers/blood = 1, /datum/reagent/blood = 200)
	result = /obj/item/reagent_containers/blood/morphpack
	always_available = TRUE
	category = CAT_DRUGS

/datum/crafting_recipe/cokepack
	name = "Make Cocaine Adulterated Bloodpack"
	time = 25
	reqs = list(/obj/item/reagent_containers/food/drinks/meth/cocaine = 1, /obj/item/reagent_containers/blood = 1, /datum/reagent/blood = 200)
	result = /obj/item/reagent_containers/blood/cokepack
	always_available = TRUE
	category = CAT_DRUGS

/datum/crafting_recipe/bweedpack
	name = "Make Weed Adulterated Bloodpack"
	time = 25
	reqs = list(/obj/item/food/grown/cannabis = 1, /obj/item/reagent_containers/blood = 1, /datum/reagent/blood = 200)
	result = /obj/item/reagent_containers/blood/bweedpack
	always_available = TRUE
	category = CAT_DRUGS
