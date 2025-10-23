/datum/discipline/path
	var/action_type = /datum/action/discipline/path
	var/action_replaced = FALSE
	selectable = FALSE //cant buy it as a ghoul

// Override post_gain to replace the action after the base system is done
/datum/discipline/path/post_gain()
	. = ..()

	if(action_replaced || !owner)
		return

	addtimer(CALLBACK(src, PROC_REF(replace_base_action)), 1 SECONDS)

// so a 'base action' was being created for the paths, bugging out the UI, solved this by just replacing this 'base action' upon creation
/datum/discipline/path/proc/replace_base_action()
	if(!owner)
		return

	var/datum/action/discipline/base_action = null
	for(var/datum/action/discipline/action in owner.actions)
		if(action.discipline == src && action.type == /datum/action/discipline)
			base_action = action
			break

	if(base_action)
		// Create the path action
		var/datum/action/discipline/path/path_action = new /datum/action/discipline/path(src)

		// Grant the path action
		path_action.Grant(owner)

		// Remove the base action
		base_action.Remove(owner)
		qdel(base_action)

		action_replaced = TRUE

/datum/action/discipline/path
	check_flags = NONE
	button_icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	background_icon_state = "default"
	icon_icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	button_icon_state = "default"

/datum/action/discipline/path/New(datum/discipline/discipline)
	. = ..()

/datum/action/discipline/path/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	button_icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	icon_icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	background_icon_state = "default"
	button_icon_state = "default"

	current_button.icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	current_button.icon_state = "default"

	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays(TRUE)

		if(discipline)
			current_button.name = discipline.current_power.name
			current_button.desc = discipline.current_power.desc

			var/discipline_icon_state = discipline.icon_state || "default"
			current_button.add_overlay(mutable_appearance('modular_tfn/modules/paths/icons/paths.dmi', discipline_icon_state))
			current_button.button_icon_state = discipline_icon_state

			if(discipline.level_casting)
				current_button.add_overlay(mutable_appearance('modular_tfn/modules/paths/icons/paths.dmi', "[discipline.level_casting]"))
		else
			current_button.add_overlay(mutable_appearance('modular_tfn/modules/paths/icons/paths.dmi', "default"))
			current_button.button_icon_state = "default"
