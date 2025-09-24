/mob/living
	var/faith = 0

/datum/discipline/numina
	name = "Test Numina"
	desc = "Test Numina. If you've seen this something has gone wrong."
	var/action_type = /datum/action/discipline/numina
	var/action_replaced = FALSE // Track if we've already done the replacement
	selectable = FALSE
	power_type = /datum/discipline_power

/datum/discipline/numina/post_gain()
	. = ..()

	if(action_replaced || !owner)
		return

	addtimer(CALLBACK(src, PROC_REF(replace_bugged_disc)), 1 SECONDS)

/datum/discipline/numina/proc/replace_bugged_disc() //Avoiding similar problems to Chaz's paths. If the method ain't broke I'm not gonna reinvent it.
	if(!owner)
		return

	var/datum/action/discipline/dummy_disc = null
	for(var/datum/action/discipline/action in owner.actions)
		if(action.discipline == src && action.type == /datum/action/discipline)
			dummy_disc = action
			break

	if(dummy_disc)
		var/datum/action/discipline/numina/desired_overwrite = new /datum/action/discipline/numina(src)

		desired_overwrite.Grant(owner)

		dummy_disc.Remove(owner)
		qdel(dummy_disc)

		action_replaced = TRUE

/datum/action/discipline/numina //Setup to overwrite icon sources; otherwise, we will always be pulling from WOD's file.
	check_flags = NONE
	button_icon = 'modular_tfn/modules/numina/icons/numina.dmi'
	background_icon_state = "default"
	icon_icon = 'modular_tfn/modules/numina/icons/numina.dmi'
	button_icon_state = "default"

/datum/action/
	var/numina = FALSE

/datum/action/discipline/numina/New(datum/discipline/discipline)
	. = ..()

/datum/action/discipline/numina/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE) //This actually handles the overwrite.
	button_icon = 'modular_tfn/modules/numina/icons/numina.dmi' //Thanks again, Chaz. Lifesaver.
	icon_icon = 'modular_tfn/modules/numina/icons/numina.dmi'
	background_icon_state = "default"
	button_icon_state = "default"

	current_button.icon = 'modular_tfn/modules/numina/icons/numina.dmi'
	current_button.icon_state = "default"

	if(icon_icon && button_icon_state && ((current_button.button_icon_state != button_icon_state) || force))
		current_button.cut_overlays(TRUE)

		if(discipline)
			current_button.name = discipline.current_power.name
			current_button.desc = discipline.current_power.desc

			var/discipline_icon_state = discipline.icon_state || "default"
			current_button.add_overlay(mutable_appearance('modular_tfn/modules/numina/icons/numina.dmi', discipline_icon_state))
			current_button.button_icon_state = discipline_icon_state

			if(discipline.level_casting)
				current_button.add_overlay(mutable_appearance('modular_tfn/modules/numina/icons/numina.dmi', "[discipline.level_casting]"))
		else
			current_button.add_overlay(mutable_appearance('modular_tfn/modules/numina/icons/numina.dmi', "default"))
			current_button.button_icon_state = "default"
