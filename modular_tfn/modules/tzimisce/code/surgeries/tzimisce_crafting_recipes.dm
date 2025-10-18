/datum/crafting_recipe/tzi_heart
	name = "Second Heart"
	time = 100
	reqs = list(/obj/item/stack/human_flesh = 30, /obj/item/organ/heart = 1)
	result = /obj/item/organ/cyberimp/chest/reviver/tzimisce
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_stomach
	name = "Secondary Stomach"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 15, /obj/item/organ/stomach = 1)
	result = /obj/item/organ/cyberimp/chest/nutriment/tzimisce
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_eyes_thermal
	name = "Better Eyes (Thermal)"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 25, /obj/item/organ/eyes = 1)
	result = /obj/item/organ/eyes/thermal
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_ears
	name = "Feline Ears"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 10, /obj/item/organ/ears = 1)
	result = /obj/item/organ/ears/cat
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_armblade
	name = "Armblade"
	time = 100
	reqs = list(/obj/item/stack/human_flesh = 30, /obj/item/organ/heart = 1, /obj/item/melee/vampirearms/knife = 1, /obj/item/bodypart/r_arm = 1, /obj/item/bodypart/l_arm = 1)
	result = /obj/item/organ/cyberimp/arm/tzimisce
	always_available = FALSE
	category = CAT_TZIMISCE
