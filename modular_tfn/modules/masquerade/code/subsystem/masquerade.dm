SUBSYSTEM_DEF(masquerade)
	name = "Masquerade"
	init_order = INIT_ORDER_DEFAULT
	flags = SS_NO_FIRE

	var/masquerade_level = MASQUERADE_MAX_LEVEL
	var/list/masquerade_breachers
	var/static/regex/masquerade_breaching_phrase_regex
	var/ending = FALSE

/datum/controller/subsystem/masquerade/Initialize()
	masquerade_breachers = new()
	var/list/masquerade_filter = list()
	for(var/line in world.file2list("modular_tfn/modules/masquerade/config/breach_word.txt"))
		if(!line)
			continue
		masquerade_filter += REGEX_QUOTE(line)
	masquerade_breaching_phrase_regex = masquerade_filter.len ? regex("\\b([jointext(masquerade_filter, "|")])\\b", "i") : null
	RegisterSignal(src, COMSIG_PLAYER_MASQUERADE_REINFORCE, PROC_REF(player_masquerade_reinforce))
	..()

// Used for the status menu's masquerade breach text.
/datum/controller/subsystem/masquerade/proc/get_description()
	var/return_list = ""
	switch(masquerade_level)
		if(0)
			return_list += "MASQUEARADE FAILURE: "
		if(1 to 9)
			return_list += "MASSIVE BREACH: "
		if(10 to 14)
			return_list += "MODERATE VIOLATION: "
		if(15 to 20)
			return_list += "SUSPICIOUS: "
		else
			return_list += "STABLE: "
	return_list += "[masquerade_level]/[MASQUERADE_MAX_LEVEL]"
	return return_list

/*
 * Reinforces a specific player's masquerade and changes the global masquerade level accordingly.
 *
 * source - The object or mob that saw the masquerade breach.
 * player_breacher - The player which caused the masquerade breach.
 * reason - Optional, the reason for the breach. For example,
 */
/datum/controller/subsystem/masquerade/proc/masquerade_reinforce(atom/source, mob/living/player_breacher, reason)
	. = FALSE
	for(var/masquerade_breach as anything in masquerade_breachers)
		var/list/source_list = list(masquerade_breach[2])
		if((source in source_list))
			if(!reason || (reason in masquerade_breach))
				masquerade_breachers -= list(masquerade_breach)
				masquerade_level = min(MASQUERADE_MAX_LEVEL, masquerade_level + 1)
				player_breacher.masquerade_score = min(5, player_breacher.masquerade_score + 1)
				. = TRUE
				break
	if(player_breacher.masquerade_score == 5) //Doesn't matter if they weren't in one of these lists.
		GLOB.veil_breakers_list -= player_breacher
		GLOB.masquerade_breakers_list -= player_breacher

	if(isgarou(player_breacher) || iswerewolf(player_breacher))
		var/random_renown = pick("Honor","Wisdom","Glory")
		switch(random_renown)
			if("Honor")
				player_breacher.adjust_renown("honor", -1, vessel = player_breacher)
			if("Glory")
				player_breacher.adjust_renown("glory", -1, vessel = player_breacher)
			if("Wisdom")
				player_breacher.adjust_renown("wisdom", -1, vessel = player_breacher)
	save_persistent_masquerade(player_breacher)
	return .

/*
 * Breaches a specific player's masquerade and changes the global masquerade level accordingly.
 *
 * source - The object or mob that saw the masquerade breach.
 * player_breacher - The player which caused the masquerade breach.
 * reason - The reason for the breach. For example,
 */
/datum/controller/subsystem/masquerade/proc/masquerade_breach(atom/source, mob/living/player_breacher, reason)
	player_breacher.masquerade_score = max(0, player_breacher.masquerade_score - 1)
	masquerade_breachers += list(list(player_breacher, source, reason))
	if(isgarou(player_breacher) || iswerewolf(player_breacher))
		GLOB.veil_breakers_list |= player_breacher
	else
		GLOB.masquerade_breakers_list |= player_breacher
	masquerade_level = max(0, masquerade_level - 1)
	save_persistent_masquerade(player_breacher)
	check_roundend_condition()

// Used for adding logging messages to every logging_machine in GLOB.loggin_machines
/datum/controller/subsystem/masquerade/proc/log_phone_message(message, obj/phone_source)
	for(var/obj/machinery/logging_machine/logging_machine as anything in GLOB.logging_machines)
		logging_machine.saved_logs += list(list(message, phone_source))

// Save the player's masquerade level to their character sheet.
/datum/controller/subsystem/masquerade/proc/save_persistent_masquerade(mob/living/player_breacher)
	var/datum/preferences/preferences = GLOB.preferences_datums[ckey(player_breacher.key)]
	if(preferences)
		preferences.masquerade_score = player_breacher.masquerade_score
		preferences.save_character()

// This is for clearing the round's masquerade because a player matrix'd
/datum/controller/subsystem/masquerade/proc/cryo_masquerade_breacher(mob/living/player_breacher, update_preferences)
	for(var/masquerade_breach as anything in masquerade_breachers)
		if((player_breacher in masquerade_breach))
			masquerade_breachers -= list(masquerade_breach)
			masquerade_level = min(MASQUERADE_MAX_LEVEL, masquerade_level + 1)
	if(isgarou(player_breacher) || iswerewolf(player_breacher))
		GLOB.veil_breakers_list -= player_breacher
	else
		GLOB.masquerade_breakers_list -= player_breacher
	if(update_preferences)
		save_persistent_masquerade(player_breacher)

// This is for checking if a joined player should be on the breachers list.
/datum/controller/subsystem/masquerade/proc/masquerade_breacher_check(mob/living/player_breacher)
	if(player_breacher.masquerade_score < 5)
		if(isgarou(player_breacher) || iswerewolf(player_breacher))
			GLOB.veil_breakers_list |= player_breacher
		else
			GLOB.masquerade_breakers_list |= player_breacher
	else
		if(isgarou(player_breacher) || iswerewolf(player_breacher))
			GLOB.veil_breakers_list -= player_breacher
		else
			GLOB.masquerade_breakers_list -= player_breacher

/datum/controller/subsystem/masquerade/proc/player_masquerade_reinforce(datum/source, mob/living/player_breacher)
	SIGNAL_HANDLER

	for(var/masquerade_breach as anything in masquerade_breachers)
		var/list/masquerade_breach_list = masquerade_breach
		if(islist(masquerade_breach_list[2])) //If its the skull list, then its a long term masq breach. Clear it.
			for(var/atom/list_object as anything in masquerade_breach_list[2])
				SSmasquerade.masquerade_reinforce(list_object, masquerade_breach_list[1], MASQUERADE_REASON_PREFERENCES)
				return
		else
			var/atom/object = masquerade_breach_list[2]
			SEND_SIGNAL(object, COMSIG_MASQUERADE_REINFORCE, player_breacher)
			return

// A check for if we should be ending the round.
/datum/controller/subsystem/masquerade/proc/check_roundend_condition()
	if((masquerade_level != 0) || ending)
		return
	ending = TRUE
	for(var/player as anything in GLOB.player_list)
		SEND_SOUND(player, 'modular_tfn/modules/masquerade/sound/masquerade_failure.ogg') //Alerting them of their demise.
	addtimer(CALLBACK(src, PROC_REF(end_round)), 65 SECONDS)

// Ending the actual round.
/datum/controller/subsystem/masquerade/proc/end_round()
	for(var/masquerade_breach as anything in masquerade_breachers)
		var/list/masquerade_breach_list = masquerade_breach
		if(islist(masquerade_breach_list[2])) //If its the skull list, then its a long term masq breach. Clear it.
			for(var/atom/list_object as anything in masquerade_breach_list[2])
				SSmasquerade.masquerade_reinforce(list_object, masquerade_breach_list[1], MASQUERADE_REASON_PREFERENCES)
		else
			var/atom/object = masquerade_breach_list[2]
			SEND_SIGNAL(object, COMSIG_ALL_MASQUERADE_REINFORCE)
	SSticker.force_ending = 1
	SSticker.current_state = GAME_STATE_FINISHED
	GLOB.canon_event = FALSE
	toggle_ooc(TRUE) // Turn it on
	toggle_dooc(TRUE)
	SSticker.declare_completion(SSticker.force_ending)
	Master.SetRunLevel(RUNLEVEL_POSTGAME)
