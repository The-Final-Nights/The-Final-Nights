/datum/species/monkey
	name = "Monkey"
	id = "monkey"
	say_mod = "chimpers"
	attack_verb = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	miss_sound = 'sound/weapons/bite.ogg'
	mutant_organs = list(/obj/item/organ/tail/monkey)
	mutant_bodyparts = list("tail_monkey" = "Monkey")
	skinned_type = /obj/item/stack/sheet/animalhide/monkey
	meat = /obj/item/food/meat/slab/monkey
	knife_butcher_results = list(/obj/item/food/meat/slab/monkey = 5, /obj/item/stack/sheet/animalhide/monkey = 1)
	species_traits = list(HAS_FLESH,HAS_BONE,NO_UNDERWEAR,LIPS,NOEYESPRITES,NOBLOODOVERLAY,NOTRANSSTING, NOAUGMENTS)
	inherent_traits = list(TRAIT_MONKEYLIKE)
	no_equip = list(ITEM_SLOT_EARS, ITEM_SLOT_EYES, ITEM_SLOT_OCLOTHING, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_SUITSTORE)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | ERT_SPAWN | SLIME_EXTRACT
	liked_food = MEAT | FRUIT
	limbs_id = "monkey"
	damage_overlay_type = "monkey"
	sexes = FALSE
	punchdamagelow = 1
	punchdamagehigh = 3
	species_language_holder = /datum/language_holder/monkey
	bodypart_overides = list(
	BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/monkey,\
	BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/monkey,\
	BODY_ZONE_HEAD = /obj/item/bodypart/head/monkey,\
	BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/monkey,\
	BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/monkey,\
	BODY_ZONE_CHEST = /obj/item/bodypart/chest/monkey)
	dust_anim = "dust-m"
	gib_anim = "gibbed-m"

	payday_modifier = 1.5


/datum/species/monkey/random_name(gender,unique,lastname)
	var/randname = "monkey ([rand(1,999)])"

	return randname

/datum/species/monkey/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	passtable_on(H, SPECIES_TRAIT)
	H.dna.add_mutation(/datum/mutation/human/race, MUT_NORMAL)
	H.dna.activate_mutation(/datum/mutation/human/race)

/datum/species/monkey/on_species_loss(mob/living/carbon/C)
	. = ..()
	passtable_off(C, SPECIES_TRAIT)
	C.dna.remove_mutation(/datum/mutation/human/race)


/datum/species/monkey/check_roundstart_eligible()
	if(SSevents.holidays && SSevents.holidays[MONKEYDAY])
		return TRUE
	return ..()
