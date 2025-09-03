/datum/discipline/dementation
	name = "Dementation"
	desc = "Makes all humans in radius mentally ill for a moment, supressing their defending ability."
	icon_state = "dementation"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/dementation

/datum/discipline/dementation/post_gain()
	. = ..()
	if(!owner.has_quirk(/datum/quirk/derangement))
		owner.add_quirk(/datum/quirk/derangement)

/datum/discipline_power/dementation
	name = "Dementation power name"
	desc = "Dementation power description"

	activate_sound = 'code/modules/wod13/sounds/insanity.ogg'

/datum/discipline_power/dementation/proc/dementation_check(mob/living/carbon/human/owner, mob/living/target, base_difficulty = 4, var/dementation_succeeded = FALSE)

	if(!ishuman(target))
		return FALSE

	var/mypower = SSroll.storyteller_roll(owner.get_total_social(), difficulty = base_difficulty, mobs_to_show_output = owner, numerical = TRUE)
	var/theirpower = SSroll.storyteller_roll(target.get_total_mentality(), difficulty = 6, mobs_to_show_output = target, numerical = TRUE)

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.clan?.name == CLAN_GARGOYLE)
			theirpower -= 2


	return (mypower > theirpower)

//PASSION
/datum/discipline_power/dementation/passion
	name = "Passion"
	desc = "Stir the deepest parts of your target to manipulate their psyche."

	level = 1

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	duration_length = 3 SECONDS
	var/dementation_succeeded = FALSE


/datum/discipline_power/dementation/passion/pre_activation_checks(mob/living/target)

	dementation_succeeded = dementation_check(owner, target, base_difficulty = 4)
	if(dementation_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE


/datum/discipline_power/dementation/passion/activate(mob/living/carbon/human/target)
	. = ..()

	if(dementation_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
		dementation_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("You flood [target]'s mind with uncontrollable madness!"))
		to_chat(target, span_danger("HAHAHAHAHAHAHAHAHAHAHAHA!!"))

		target.Stun(0.5 SECONDS)
		target.emote("laugh")
		owner.playsound_local(get_turf(target), pick('sound/items/SitcomLaugh1.ogg', 'sound/items/SitcomLaugh2.ogg', 'sound/items/SitcomLaugh3.ogg'), 100, FALSE)

		if(target.body_position == STANDING_UP)
			target.toggle_resting()
		SEND_SOUND(target, sound('code/modules/wod13/sounds/insanity.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your corruption!"))
		to_chat(target, span_warning("You feel unseen whispers crawling through your psyche, clawing for entry. You resist—but a chill remains."))

/datum/discipline_power/dementation/passion/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//THE HAUNTING
/datum/discipline_power/dementation/the_haunting
	name = "The Haunting"
	desc = "Manipulate your target's senses, making them perceive what isn't there."

	level = 2

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	duration_length = 3 SECONDS
	var/dementation_succeeded = FALSE

/datum/discipline_power/dementation/the_haunting/pre_activation_checks(mob/living/target)

	dementation_succeeded = dementation_check(owner, target, base_difficulty = 5)
	if(dementation_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dementation/the_haunting/activate(mob/living/carbon/human/target)
	. = ..()

	if(dementation_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
		dementation_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("You awaken a chorus of horrors in [target]'s mind!"))
		to_chat(target, span_warning("There’s something here. Watching. Whispering."))

		target.hallucination += 50
		new /datum/hallucination/oh_yeah(target, TRUE)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/insanity.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your corruption!"))
		to_chat(target, span_warning("You feel unseen whispers crawling through your psyche, clawing for entry. You resist—but a chill remains."))

/datum/discipline_power/dementation/the_haunting/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//EYES OF CHAOS
/datum/discipline_power/dementation/eyes_of_chaos
	name = "Eyes of Chaos"
	desc = "See the hidden patterns in the world and uncover people's true selves."

	level = 3

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	duration_length = 3 SECONDS
	var/dementation_succeeded = FALSE

/datum/discipline_power/dementation/eyes_of_chaos/pre_activation_checks(mob/living/target)

	dementation_succeeded = dementation_check(owner, target, base_difficulty = 6)
	if(dementation_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dementation/eyes_of_chaos/activate(mob/living/carbon/human/target)
	. = ..()

	if(dementation_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
		dementation_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("You unravel [target]'s perception into swirling patterns of madness!"))
		to_chat(target, span_danger("The world fractures—everything is color, rhythm, motion!"))

		target.Immobilize(2 SECONDS)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/insanity.ogg'))
		if(!HAS_TRAIT(target, TRAIT_KNOCKEDOUT) && !HAS_TRAIT(target, TRAIT_IMMOBILIZED) && !HAS_TRAIT(target, TRAIT_RESTRAINED))
			if(prob(50))
				dancefirst(target)
			else
				dancesecond(target)
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your corruption!"))
		to_chat(target, span_warning("You feel unseen whispers crawling through your psyche, clawing for entry. You resist—but a chill remains."))

/datum/discipline_power/dementation/eyes_of_chaos/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/proc/dancefirst(mob/living/M)
	if(M.dancing)
		return
	M.dancing = TRUE
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 75)
		if (!M)
			return
		switch(i)
			if (1 to 15)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (16 to 30)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (31 to 45)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,-1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (46 to 60)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-1,1)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (61 to 75)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(1,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(0.1 SECONDS)
	M.lying_fix()
	M.dancing = FALSE

/proc/dancesecond(mob/living/M)
	if(M.dancing)
		return
	M.dancing = TRUE
	animate(M, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
	var/matrix/initial_matrix = matrix(M.transform)
	for (var/i in 1 to 60)
		if (!M)
			return
		if (i<31)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		if (i>30)
			initial_matrix = matrix(M.transform)
			initial_matrix.Translate(0,-1)
			animate(M, transform = initial_matrix, time = 1, loop = 0)
		M.setDir(turn(M.dir, 90))
		switch (M.dir)
			if (NORTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (SOUTH)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(0,-3)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (EAST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
			if (WEST)
				initial_matrix = matrix(M.transform)
				initial_matrix.Translate(-3,0)
				animate(M, transform = initial_matrix, time = 1, loop = 0)
		sleep(0.1 SECONDS)
	M.lying_fix()
	M.dancing = FALSE

//VOICE OF MADNESS
/datum/discipline_power/dementation/voice_of_madness
	name = "Voice of Madness"
	desc = "Your voice becomes a source of utter insanity, affecting you and all those around you."

	level = 4

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	duration_length = 3 SECONDS
	var/dementation_succeeded = FALSE

/datum/discipline_power/dementation/voice_of_madness/pre_activation_checks(mob/living/target)

	dementation_succeeded = dementation_check(owner, target, base_difficulty = 6)
	if(dementation_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dementation/voice_of_madness/activate(mob/living/carbon/human/target)
	. = ..()

	if(dementation_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
		dementation_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("You shatter [target]'s grip on sanity with a single utterance!"))
		to_chat(target, span_danger("A scream echoes in your mind—yours or theirs, you can't tell anymore."))

		// 8 second instastun - needs to be looked at in the future
		new /datum/hallucination/death(target, TRUE)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/insanity.ogg'))

	else
		to_chat(owner, span_warning("[target]'s mind has resisted your corruption!"))
		to_chat(target, span_warning("You feel unseen whispers crawling through your psyche, clawing for entry. You resist—but a chill remains."))

/datum/discipline_power/dementation/voice_of_madness/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//TOTAL INSANITY
/datum/discipline_power/dementation/total_insanity
	name = "Total Insanity"
	desc = "Bring out the darkest parts of a person's psyche, bringing them to utter insanity."

	level = 5

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	duration_length = 3 SECONDS
	var/dementation_succeeded = FALSE

/datum/discipline_power/dementation/total_insanity/pre_activation_checks(mob/living/target)

	dementation_succeeded = dementation_check(owner, target, base_difficulty = 7)
	if(dementation_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dementation/total_insanity/activate(mob/living/carbon/human/target)
	. = ..()

	if(dementation_succeeded)
		start_total_insanity_effect(target)
		addtimer(CALLBACK(PROC_REF(stop_total_insanity_effect), target), 20 SECONDS)

		to_chat(owner, span_warning("You unravel [target]'s sanity, leaving them in a state of uncontrollable mania!"))
		to_chat(target, span_danger("Reality fractures and collapses around you. You lash out blindly, unsure what’s real."))
		SEND_SOUND(target, sound('code/modules/wod13/sounds/insanity.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your corruption!"))
		to_chat(target, span_warning("You feel unseen whispers crawling through your psyche, clawing for entry. You resist—but a chill remains."))

// Start the Total Insanity effect
/proc/start_total_insanity_effect(mob/living/carbon/human/target)
	if(!target) return

	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/dementation_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dementation", -MUTATIONS_LAYER)
	dementation_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = dementation_overlay
	target.apply_overlay(MUTATIONS_LAYER)

	// Repeated "attack self" behavior over time
	for(var/i in 1 to 20)
		addtimer(CALLBACK(target, /mob/living/carbon/human/proc/attack_myself_command), i * 1.5 SECONDS)

/proc/stop_total_insanity_effect(mob/living/carbon/human/target)
	if(!target) return

	target.remove_overlay(MUTATIONS_LAYER)

/datum/discipline_power/dementation/total_insanity/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
