/datum/species/moth
	name = "Mothman"
	id = "moth"
	say_mod = "flutters"
	default_color = "00FF00"
	species_traits = list(LIPS, NOEYESPRITES, HAS_FLESH, HAS_BONE, HAS_MARKINGS, TRAIT_ANTENNAE)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("moth_markings" = "None")
	external_organs = list(/obj/item/organ/external/wings/moth = "Plain", /obj/item/organ/external/antennae = "Plain")
	attack_verb = "slash"
	attack_effect = ATTACK_EFFECT_CLAW
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/food/meat/slab/human/mutant/moth
	liked_food = VEGETABLES | DAIRY | CLOTH
	disliked_food = FRUIT | GROSS
	toxic_food = MEAT | RAW
	mutanteyes = /obj/item/organ/eyes/moth
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/moth
	has_innate_wings = TRUE
	payday_modifier = 0.75

/datum/species/moth/regenerate_organs(mob/living/carbon/C,datum/species/old_species,replace_current=TRUE,list/excluded_zones)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		handle_mutant_bodyparts(H)

/datum/species/moth/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_moth_name()

	var/randname = moth_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/moth/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load)
	. = ..()
	RegisterSignal(human_who_gained_species, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(damage_weakness))

/datum/species/moth/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)

/datum/species/moth/proc/damage_weakness(datum/source, list/damage_mods, damage_amount, damagetype, def_zone, sharpness, attack_direction, obj/item/attacking_item)
	SIGNAL_HANDLER

	if(istype(attacking_item, /obj/item/melee/flyswatter))
		damage_mods += 10 // Yes, a 10x damage modifier

/datum/species/moth/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/wings = pick(GLOB.moth_wings_list)
	mutant_bodyparts["wings"] = wings
	mutant_bodyparts["moth_wings"] = wings
	human_mob.dna.features["wings"] = wings
	human_mob.dna.features["moth_wings"] = wings
	human_mob.update_body()
