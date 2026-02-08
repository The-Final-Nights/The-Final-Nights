/datum/species/kindred/zulo
	name = "Zulo"
	id = "zulo"
	default_color = "FFFFFF"
	toxic_food = MEAT | VEGETABLES | RAW | JUNKFOOD | GRAIN | FRUIT | DAIRY | FRIED | ALCOHOL | SUGAR | PINEAPPLE
	liked_food = SANGUINE
	species_traits = list(EYECOLOR, HAS_FLESH, HAS_BONE, NO_UNDERWEAR)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LIMBATTACHMENT, TRAIT_VIRUSIMMUNE, TRAIT_NOBLEED, TRAIT_NOHUNGER, TRAIT_NOBREATH, TRAIT_TOXIMMUNE, TRAIT_NOCRITDAMAGE, TRAIT_MASQUERADE_VIOLATING_FACE, TRAIT_HARDENED_SOLES, TRAIT_STRONG_GRABBER, TRAIT_GIANT, TRAIT_PUSHIMMUNE, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_HARDLY_WOUNDED)
	no_equip = list(ITEM_SLOT_MASK, ITEM_SLOT_OCLOTHING, ITEM_SLOT_GLOVES, ITEM_SLOT_FEET, ITEM_SLOT_ICLOTHING, ITEM_SLOT_SUITSTORE)
	use_skintones = TRUE
	limbs_id = "tzi"
	wings_icon = "Dragon"
	mutant_bodyparts = list("tail_human" = "None", "ears" = "None", "wings" = "None")
	mutantbrain = /obj/item/organ/brain/vampire
	brutemod = 0.5
	heatmod = 1
	burnmod = 2
	punchdamagelow = 15 //A little more than Glabro, since this is a Crinos equivalent.
	punchdamagehigh = 25
	exotic_blood = /datum/reagent/blood/vitae
	selectable = FALSE
	var/old_appearance

/datum/species/kindred/zulo/on_species_gain(mob/living/carbon/human/H)
	..()
	H.hairstyle = "Bald"
	H.facial_hairstyle = "Shaved"
	H.undershirt = "Nude"
	H.underwear = "Nude"
	H.socks = "Nude"
	old_appearance = H.st_get_stat(STAT_APPEARANCE)
	H.st_add_stat_mod(STAT_STRENGTH, 3, "Zulo")
	H.st_add_stat_mod(STAT_STAMINA, 3, "Zulo")
	H.st_add_stat_mod(STAT_DEXTERITY, 3, "Zulo")
	H.st_set_stat(0, STAT_APPEARANCE)
	H.dna.add_mutation(GIGANTISM)

/datum/species/kindred/zulo/on_species_loss(mob/living/carbon/human/H)
	..()
	H.hairstyle = H.client.prefs.hairstyle
	H.facial_hairstyle = H.client.prefs.facial_hairstyle
	H.undershirt = H.client.prefs.undershirt
	H.underwear = H.client.prefs.underwear
	H.socks = H.client.prefs.socks
	H.st_remove_stat_mod(STAT_STRENGTH, 3, "Zulo")
	H.st_remove_stat_mod(STAT_STAMINA, 3, "Zulo")
	H.st_remove_stat_mod(STAT_DEXTERITY, 3, "Zulo")
	H.st_set_stat(old_appearance, STAT_APPEARANCE)
	H.dna.remove_mutation(GIGANTISM)


