// **************************************************************** DAEMONIC POSSESSION *************************************************************

/obj/necrorune/zombie
	name = "Daemonic Possession"
	desc = "Place a wraith inside of a dead body and raise it as a sentient zombie."
	icon_state = "rune7"
	word = "GI'TI FOA'HP"
	necrolevel = 5
	var/duration_length = 15 SECONDS

/obj/necrorune/zombie/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("You cannot invoke this ritual upon yourself."))
			return
		else if(targetbody.stat == DEAD)
			valid_bodies += targetbody
		else
			to_chat(usr, span_warning("The target lives still!"))
			return

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("There is no body that can undergo this Ritual."))
		return

	usr.visible_message(span_notice("[usr] begins chanting in vile tongues..."), span_notice("You begin the resurrection ritual."))
	playsound(loc, 'code/modules/wod13/sounds/necromancy2.ogg', 50, FALSE)

	if(do_after(usr, duration_length, usr))

		activated = TRUE
		last_activator = usr

		var/mob/living/target_body = pick(valid_bodies)

		var/old_name = target_body.real_name

		// Transform the body into a zombie
		if(!target_body || QDELETED(target_body) || target_body.stat > DEAD)
			return

		// Remove any vampiric actions
		for(var/datum/action/A in target_body.actions)
			if(A && A.vampiric)
				A.Remove(target_body)

		var/original_location = get_turf(target_body)

		// Revive the specimen and turn them into a zombie
		target_body.revive(TRUE)
		target_body.set_species(/datum/species/zombie)
		target_body.real_name = old_name // the ritual for some reason is deleting their old name and replacing it with a random name.
		target_body.name = old_name
		qdel(target_body.GetComponent(/datum/component/violation_observer))
		target_body.update_name()

		if(target_body.loc != original_location)
			target_body.forceMove(original_location)

		playsound(loc, 'code/modules/wod13/sounds/necromancy.ogg', 50, FALSE)

		// Handle key assignment
		if(!target_body.key)
			var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to play as Sentient Zombie?", null, null, null, 20 SECONDS, src)
			for(var/mob/dead/observer/G in GLOB.player_list)
				if(G.key)
					notify_ghosts("Zombie rune has been triggered.", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Zombie Rune Triggered")
			if(LAZYLEN(candidates))
				var/mob/dead/observer/C = pick(candidates)
				target_body.key = C.key

			var/choice = tgui_alert(target_body, "Do you want to pick a new name as a Zombie?", "Zombie Choose Name", list("Yes", "No"), 10 SECONDS)
			if(choice == "Yes")
				var/chosen_zombie_name = tgui_input_text(target_body, "What is your new name as a Zombie?", "Zombie Name Input")
				target_body.real_name = chosen_zombie_name
				target_body.name = chosen_zombie_name
				target_body.update_name()
			else
				target_body.visible_message(span_ghostalert("[target_body.name] twitches to unlife!"))
				qdel(src)
				return

		target_body.visible_message(span_ghostalert("[target_body.name] twitches to unlife!"))
		qdel(src)
