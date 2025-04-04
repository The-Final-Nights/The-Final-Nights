/datum/character_sheet
	// TODO: replace this with a UUID that coresponds with the owner's
	/// Owner of the character sheet, tmp so BYOND doesn't save the reference.
	//var/tmp/mob/living/carbon/human/owner
	var/uid = ""
	// Attributes
	var/physique = 1
	var/dexterity = 1
	var/social = 1
	var/mentality = 1
	var/blood = 1
	// Skills
	var/lockpicking = 0
	var/athletics = 0

	var/additional_physique = 0
	var/additional_dexterity = 0
	var/additional_mentality = 0
	var/additional_social = 0
	var/additional_blood = 0
	var/additional_lockpicking = 0
	var/additional_athletics = 0

/datum/character_sheet/New(uid)
	src.uid = uid

/datum/character_sheet/Destroy()
	uid = null

	return ..()
