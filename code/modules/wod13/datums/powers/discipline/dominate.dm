/datum/discipline/dominate
	name = "Dominate"
	desc = "Suppresses will of your targets and forces them to obey you, if their will is not more powerful than yours."
	icon_state = "dominate"
	power_type = /datum/discipline_power/dominate

/datum/discipline/dominate/post_gain()
	. = ..()
	if(level >= 5)
		var/obj/effect/proc_holder/spell/voice_of_god/voice_of_domination = new(owner)
		owner.mind.AddSpell(voice_of_domination)
		RegisterSignal(owner, COMSIG_MOB_EMOTE, PROC_REF(on_snap))

/datum/discipline/dominate/proc/on_snap(atom/source, datum/emote/emote_args)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(handle_snap), source, emote_args)

/datum/discipline/dominate/proc/handle_snap(atom/source, datum/emote/emote_args)
	var/list/emote_list = list("snap", "snap2", "snap3", "whistle")
	if(!emote_list.Find(emote_args.key))
		return
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, owner))
		var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
		if(conditioner != owner)
			continue
		switch(emote_args.key)
			if("snap")
				target.SetSleeping(0)
				target.silent = 3
				target.dir = get_dir(target, owner)
				target.emote("me", 1, "faces towards <b>[owner]</b> attentively.", TRUE)
				to_chat(target, span_danger("ATTENTION"))
			if("snap2")
				target.dir = get_dir(target, owner)
				target.Immobilize(50)
				target.emote("me",1,"flinches in response to <b>[owner]'s</b> snapping.", TRUE)
				to_chat(target, span_danger("HALT"))
			if("snap3")
				target.Knockdown(50)
				target.Immobilize(80)
				target.emote("me",1,"'s knees buckle under the weight of their body.",TRUE)
				target.do_jitter_animation(0.1 SECONDS)
				to_chat(target, span_danger("DROP"))
			if("whistle")
				target.apply_status_effect(STATUS_EFFECT_AWE, owner)
				to_chat(target, span_danger("HITHER"))


/datum/discipline_power/dominate
	name = "Dominate power name"
	desc = "Dominate power description"

	activate_sound = 'code/modules/wod13/sounds/dominate.ogg'

/datum/discipline_power/dominate/activate(mob/living/target)
	. = ..()
	var/mob/living/carbon/human/dominate_target
	if(ishuman(target))
		dominate_target = target
		dominate_target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/dominate_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dominate", -MUTATIONS_LAYER)
		dominate_overlay.pixel_z = 2
		dominate_target.overlays_standing[MUTATIONS_LAYER] = dominate_overlay
		dominate_target.apply_overlay(MUTATIONS_LAYER)
		addtimer(CALLBACK(dominate_target, TYPE_PROC_REF(/mob/living/carbon/human, post_dominate_checks), dominate_target), 2 SECONDS)
	return TRUE

/datum/discipline_power/dominate/proc/dominate_hearing_check(mob/living/carbon/human/owner, mob/living/target)
	var/list/hearers = get_hearers_in_view(8, owner)
	if(!(target in hearers))
		to_chat(owner, span_warning("[target] cannot hear you — they are too far or behind an obstruction."))
		return FALSE
	else
		to_chat(owner, span_info("[target] hears you clearly."))
		return TRUE

/datum/discipline_power/dominate/proc/dominate_check(mob/living/carbon/human/owner, mob/living/target, tiebreaker = FALSE, base_difficulty = 4)

	if(!ishuman(target))
		return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.clan?.name == CLAN_GARGOYLE)
			return TRUE

	var/mypower = SSroll.storyteller_roll(owner.get_total_social(), difficulty = base_difficulty, mobs_to_show_output = owner, numerical = TRUE)
	var/theirpower = SSroll.storyteller_roll(target.get_total_mentality(), difficulty = 6, mobs_to_show_output = target, numerical = TRUE)
	var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()

	if(owner == conditioner)
		return TRUE

	if(target.conditioned)
		theirpower += 3

	return (mypower > theirpower && owner.generation <= target.generation)

/datum/movespeed_modifier/dominate
	multiplicative_slowdown = 5


//COMMAND
/datum/discipline_power/dominate/command
	name = "Command"
	desc = "Speak one word and force others to obey."

	level = 1

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_LIVING

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 3 SECONDS
	range = 7
	var/custom_command = "FORGET ABOUT IT"

/datum/discipline_power/dominate/command/pre_activation_checks(mob/living/target)  // this pre-check includes some special checks
	if(!dominate_hearing_check(owner, target)) // putting the hearing check into the pre_activation so that if the target cant hear you it doesnt consume blood and alerts you
		return FALSE

	// This dominate check has a special difficulty that is dependent on the words entered in the custom command.
	return TRUE

/datum/discipline_power/dominate/command/activate(mob/living/target)
	. = ..()

	custom_command = tgui_input_text(owner, "Dominate Command", "What is your command?", "FORGET ABOUT IT")
	if (!custom_command)
		return  // No message, no dominate

	var/word_count = length(splittext(custom_command, " "))
	var/extra_words_difficulty = 4 + max(0, word_count - 1) // Base 4 +1 per extra word

	if(dominate_check(owner, target, base_difficulty = extra_words_difficulty))
		to_chat(owner, span_warning("You've successfully dominated [target]'s mind!"))
		owner.say("[custom_command]")
		to_chat(target, span_big("[custom_command]"))
		SEND_SOUND(target, sound('code/modules/wod13/sounds/dominate.ogg'))
	else
		to_chat(owner, span_warning("[target] has resisted your domination!"))
		to_chat(target, span_warning("Your thoughts blur—[owner] tries to bend your will. You resist."))


//MESMERIZE
/datum/discipline_power/dominate/mesmerize
	name = "Mesmerize"
	desc = "Plant a suggestion in a target's head and force them to obey it."

	level = 2

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_LIVING

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	range = 7
	var/domination_succeeded = FALSE

/datum/discipline_power/dominate/mesmerize/pre_activation_checks(mob/living/target)

	if(!dominate_hearing_check(owner, target))
		return FALSE

	if (HAS_TRAIT(target, TRAIT_CANNOT_RESIST_MIND_CONTROL))
		return TRUE

	domination_succeeded = dominate_check(owner, target, base_difficulty = 5)
	if(domination_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dominate/mesmerize/activate(mob/living/target)
	. = ..()

	if(domination_succeeded)
		target.Immobilize(0.5 SECONDS)
		if(target.body_position == STANDING_UP)
			to_chat(owner, span_warning("You've successfully dominated [target]'s mind!"))
			to_chat(target, span_danger("FALL"))
			target.toggle_resting()
			owner.say("Fall.")
			SEND_SOUND(target, sound('code/modules/wod13/sounds/dominate.ogg'))
		else
			to_chat(owner, span_warning("You've successfully dominated [target]'s mind!"))
			to_chat(target, span_danger("STAY DOWN"))
			owner.say("Stay down.")
			SEND_SOUND(target, sound('code/modules/wod13/sounds/dominate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your domination!"))
		to_chat(target, span_warning("Your thoughts blur—[owner] tries to bend your will. You resist."))

//THE FORGETFUL MIND
/datum/discipline_power/dominate/the_forgetful_mind
	name = "The Forgetful Mind"
	desc = "Invade a person's mind and recreate their memories."

	level = 3

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_LIVING

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 3 SECONDS
	range = 7
	var/domination_succeeded = FALSE

/datum/discipline_power/dominate/the_forgetful_mind/pre_activation_checks(mob/living/target)

	if(!dominate_hearing_check(owner, target))
		return FALSE

	if (HAS_TRAIT(target, TRAIT_CANNOT_RESIST_MIND_CONTROL))
		return TRUE

	domination_succeeded = dominate_check(owner, target, base_difficulty = 6)
	if(domination_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dominate/the_forgetful_mind/activate(mob/living/target)
	. = ..()

	if(domination_succeeded)
		to_chat(owner, span_warning("You've successfully dominated [target]'s mind!"))
		to_chat(target, span_danger("THINK TWICE"))
		owner.say("Think twice.")
		target.add_movespeed_modifier(/datum/movespeed_modifier/dominate)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/dominate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your domination!"))
		to_chat(target, span_warning("Your thoughts blur—[owner] tries to bend your will. You resist."))

/datum/discipline_power/dominate/the_forgetful_mind/deactivate(mob/living/target)
	. = ..()
	target.remove_movespeed_modifier(/datum/movespeed_modifier/dominate)

//CONDITIONING
/datum/discipline_power/dominate/conditioning
	name = "Conditioning"
	desc = "Break a person's mind over time and bend them to your will."

	level = 4

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_LIVING

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 6 SECONDS
	range = 2
	var/domination_succeeded = FALSE

/datum/discipline_power/dominate/conditioning/pre_activation_checks(mob/living/target)

	if(!dominate_hearing_check(owner, target))
		return FALSE

	if (HAS_TRAIT(target, TRAIT_CANNOT_RESIST_MIND_CONTROL))
		return TRUE

	domination_succeeded = dominate_check(owner, target, base_difficulty = 6)
	if(domination_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE


/datum/discipline_power/dominate/conditioning/activate(mob/living/target)
	. = ..()

	if(domination_succeeded)
		target.dir = get_dir(target, owner)
		to_chat(target, span_danger("LOOK AT ME"))
		owner.say("Look at me.")
		if(do_mob(owner, target, 20 SECONDS))
			target.conditioned = TRUE
			target.conditioner = WEAKREF(owner)
			target.additional_social -= 3
			to_chat(target, span_danger("Your mind is filled with thoughts surrounding [owner]. Their every word and gesture carries weight to you."))
			SEND_SOUND(target, sound('code/modules/wod13/sounds/dominate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your domination!"))
		to_chat(target, span_warning("Your thoughts blur—[owner] tries to bend your will. You resist."))

/datum/discipline_power/dominate/conditioning/deactivate(mob/living/target)
	. = ..()

//POSSESSION
/datum/discipline_power/dominate/possession
	name = "Possession"
	desc = "Take full control of your target's mind and body."

	level = 5

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_HUMAN

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	range = 7
	var/domination_succeeded = FALSE


/datum/discipline_power/dominate/possession/pre_activation_checks(mob/living/target)

	if(!dominate_hearing_check(owner, target))
		return FALSE

	if (HAS_TRAIT(target, TRAIT_CANNOT_RESIST_MIND_CONTROL))
		return TRUE

	domination_succeeded = dominate_check(owner, target, base_difficulty = 7)
	if(domination_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dominate/possession/activate(mob/living/carbon/human/target)
	. = ..()

	if(domination_succeeded)
		to_chat(owner, span_warning("You've successfully dominated [target]'s mind!"))
		to_chat(target, span_danger("HIT YOURSELF"))
		owner.say("Hit yourself.")

		var/datum/cb = CALLBACK(target, /mob/living/carbon/human/proc/attack_myself_command)
		for(var/i in 1 to 20)
			addtimer(cb, (i - 1) * 1.5 SECONDS)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/dominate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your domination!"))
		to_chat(target, span_warning("Your thoughts blur—[owner] tries to bend your will. You resist."))


/mob/living/carbon/human/proc/attack_myself_command()
	if(!CheckFrenzyMove())
		set_combat_mode(TRUE)
		var/obj/item/I = get_active_held_item()
		if(I)
			if(I.force)
				ClickOn(src)
			else
				drop_all_held_items()
				ClickOn(src)
		else
			ClickOn(src)

/mob/living/carbon/human/proc/post_dominate_checks(mob/living/carbon/human/dominate_target)
	if(dominate_target)
		dominate_target.remove_overlay(MUTATIONS_LAYER)
