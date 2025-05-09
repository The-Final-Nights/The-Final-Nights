// Gargoyles are a subtype of kindred because they inherit basically all the stuff kindred can do
/datum/species/kindred/gargoyle
	name = "Gargoyle"
	id = "gargoyle"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LIMBATTACHMENT, TRAIT_VIRUSIMMUNE, TRAIT_NOBLEED, TRAIT_NOHUNGER, TRAIT_NOBREATH, TRAIT_TOXIMMUNE, TRAIT_NOCRITDAMAGE)
	mutant_bodyparts = list("wings" = "Gargoyle", "tail_human" = "None", "horns" = "Gargoyle", "legs" = "Digitigrade Legs")
	use_skintones = FALSE
	limbs_id = "gargoyle"
	wings_icon = "Gargoyle"
	brutemod = 0.8
	flying_species = TRUE
	has_innate_wings = TRUE

/datum/species/kindred/gargoyle/on_species_gain(mob/living/carbon/human/H)
	. = ..()
	if(H.base_body_mod == "f")
		H.base_body_mod = ""
	H.unique_body_sprite = "gargoyle"
	H.update_body()

/datum/species/kindred/gargoyle/regenerate_organs(mob/living/carbon/C, datum/species/old_species, replace_current=TRUE, list/excluded_zones)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		handle_mutant_bodyparts(H)
