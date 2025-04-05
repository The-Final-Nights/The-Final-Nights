/datum/character_sheet
	// TODO: replace this with a UUID that coresponds with the owner's
	/// Owner of the character sheet, tmp so BYOND doesn't save the reference.
	//var/tmp/mob/living/carbon/human/owner
	var/unique_id
	// Attributes
	var/list/attributes = list(
		"strength" = 1,
		"dexterity" = 1,
		"stamina" = 1,
		"charisma" = 1,
		"manipulation" = 1,
		"composure" = 1,
		"intelligence" = 1,
		"wits" = 1,
		"resolve" = 1,
	)
	var/list/skills = list(
		"athletics" = 0,
		"larceny" = 0,
	)

	/// Derived from: Composure + Resolve
	var/willpower = 0

	var/additional_physique = 0
	var/additional_dexterity = 0
	var/additional_mentality = 0
	var/additional_social = 0
	var/additional_blood = 0
	var/additional_lockpicking = 0
	var/additional_athletics = 0

	/// Cached list of all attributes in the game. key: attribute name -> value: attribute id
	var/static/list/attributes_cache = list(
		"Strength" = "strength",
		"Dexterity" = "dexterity",
		"Stamina" = "stamina",
		"Charisma" = "charisma",
		"Manipulation" = "manipulation",
		"Composure" = "composure",
		"Intelligence" = "intelligence",
		"Wits" = "wits",
		"Resolve" = "resolve"
	)

	/// Cached list of all skills in the game. key: skill name -> value: skill id
	var/static/list/skills_cache = list(
		"Athletics" = "athletics",
		"Larceny" = "larceny"
	)
