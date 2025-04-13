/datum/examine_panel
	/// Mob that the examine panel belongs to.
	var/mob/living/holder

/datum/examine_panel/ui_state(mob/user)
	return GLOB.always_state


/datum/examine_panel/ui_close(mob/user)
	// If this is an examine preview dummy, clean it up.
	if(istype(holder, /mob/living/carbon/human/dummy))
		qdel(holder)


/datum/examine_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExaminePanel")
		ui.open()


/datum/examine_panel/ui_data(mob/user)
	var/list/data = list()

	var/flavor_text = ""
	var/flavor_text_nsfw = ""
	var/obscured
	var/name = ""
	var/headshot = ""
	var/ooc_notes = ""
	var/character_notes = ""
	// Whether or not the viewing user wants to see potential NSFW content in the holder's examine panel
	var/nsfw_content = user.client.prefs?.nsfw_content_pref

	if(ishuman(holder))
		var/mob/living/carbon/human/holder_human = holder
		obscured = (holder_human.wear_mask && (holder_human.wear_mask.flags_inv & HIDEFACE)) && (holder_human.head && (holder_human.head.flags_inv & HIDEFACE))

		character_notes = holder_human.character_notes
		//Check if the mob is obscured, then continue to headshot
		if((obscured || !holder_human.dna) && !isobserver(user))
			flavor_text = "Obscured"
			name = "Unknown"
		else
			headshot = holder_human.headshot_link
			flavor_text = holder_human.flavor_text
			name = holder.name
		if(nsfw_content)
			flavor_text_nsfw = holder_human.flavor_text_nsfw
			ooc_notes = holder_human.ooc_notes

	data["obscured"] = obscured ? TRUE : FALSE
	data["character_name"] = name
	data["flavor_text"] = flavor_text
	data["flavor_text_nsfw"] = flavor_text_nsfw
	data["ooc_notes"] = ooc_notes
	data["character_notes"] = character_notes
	data["headshot"] = headshot
	data["nsfw_content"] = nsfw_content ? TRUE : FALSE
	return data
