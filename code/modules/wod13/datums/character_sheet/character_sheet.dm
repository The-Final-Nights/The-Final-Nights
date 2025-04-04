/datum/character_sheet
	// TODO: replace this with a UUID that coresponds with the owner's
	/// Owner of the character sheet, tmp so BYOND doesn't save the reference.
	//var/tmp/mob/living/carbon/human/owner
	var/unique_id
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

/datum/character_sheet/New(unique_id)
	src.unique_id = unique_id

/datum/character_sheet/Destroy()
	unique_id = null

	return ..()

/datum/character_sheet/ui_state(mob/user)
	return GLOB.new_player_state

/datum/character_sheet/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterSheet")
		ui.open()

/datum/character_sheet/ui_data(mob/user)
	var/list/data = list()

	return data

/datum/character_sheet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("TO_BE_ADDED")
