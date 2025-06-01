/datum/action/secondary_power
	var/old_discipline_icon_state = null  // Icon state to use when old_discipline pref is enabled

/datum/action/secondary_power/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(owner && ismob(owner))
		var/mob/M = owner
		if(M?.client?.prefs?.old_discipline)
			button_icon = 'code/modules/wod13/disciplines.dmi'
			icon_icon = 'code/modules/wod13/disciplines.dmi'
			background_icon_state = null
			// Use the old discipline icon state if specified, otherwise use default button_icon_state
			if(old_discipline_icon_state)
				button_icon_state = old_discipline_icon_state
				background_icon_state = old_discipline_icon_state
		else
			button_icon = 'icons/hud/actions.dmi'
			icon_icon = 'icons/hud/actions.dmi'
			background_icon_state = ACTION_BUTTON_DEFAULT_BACKGROUND

	// Apply the new settings
	..(current_button, force)
