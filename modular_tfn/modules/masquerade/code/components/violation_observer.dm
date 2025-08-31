// Used for things that detect masquerade violations.
// Usually NPCs or cameras.
/datum/component/violation_observer
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/proximity_monitor/advanced/violation_check_aoe/area_of_effect
	/// Time between us checking for violations
	COOLDOWN_DECLARE(scan_cooldown)
	var/list/breached_players

/datum/component/violation_observer/Initialize(add_area_of_effect) //Only add the AOE checker for NPCs and camera objects.
	if(add_area_of_effect)
		area_of_effect = new(parent, 7)
	breached_players = new()

/datum/component/violation_observer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_SEEN_MASQUERADE_VIOLATION, PROC_REF(on_observed_violation))
	RegisterSignal(parent, COMSIG_MASQUERADE_REINFORCE, PROC_REF(on_masquerade_violation_reinforced))
	RegisterSignals(parent, list(COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE), PROC_REF(on_death))

/datum/component/violation_observer/UnregisterFromParent(force, silent)
	QDEL_NULL(area_of_effect)
	breached_players = null
	UnregisterSignal(parent, list(COMSIG_SEEN_MASQUERADE_VIOLATION, COMSIG_MASQUERADE_REINFORCE, COMSIG_LIVING_DEATH, COMSIG_ALL_MASQUERADE_REINFORCE))

/datum/component/violation_observer/proc/on_observed_violation(atom/source, mob/living/player_breacher)
	SIGNAL_HANDLER

	if(!source || !player_breacher || ishumanbasic(player_breacher)) //Humans cant break the masquerade. Because reasons.
		return

	if(isliving(source))
		var/mob/living/mob_parent = source
		if(!mob_parent.incapacitated(ignore_restraints = 1))
			mob_parent.face_atom(player_breacher)
	source.observe_masquerade_violation(player_breacher)
	source.AddComponent(/datum/component/masquerade_hud, player_breacher)

	breached_players |= player_breacher
	SSmasquerade.masquerade_breach(source, player_breacher, (isliving(source) ? MASQUERADE_REASON_NPC : MASQUERADE_REASON_OBJECT))

/datum/component/violation_observer/proc/on_masquerade_violation_reinforced(atom/source, mob/living/player_breacher)
	SIGNAL_HANDLER

	SEND_SIGNAL(source, COMSIG_MASQUERADE_HUD_DELETE, player_breacher)
	SSmasquerade.masquerade_reinforce(source, player_breacher)
	source.observe_masquerade_reinforce(player_breacher)
	breached_players -= player_breacher

/datum/component/violation_observer/proc/on_death(atom/source)
	SIGNAL_HANDLER

	for(var/player_breacher as anything in breached_players)
		SEND_SIGNAL(source, COMSIG_MASQUERADE_HUD_DELETE, player_breacher)
		SSmasquerade.masquerade_reinforce(source, player_breacher)
		source.observe_masquerade_reinforce(player_breacher)
		breached_players -= player_breacher

/atom/proc/observe_masquerade_violation(player_breacher)
	do_alert_animation()
	if(isgarou(player_breacher) || iswerewolf(player_breacher))
		to_chat(player_breacher, span_userdanger(span_bold("VEIL VIOLATION")))
		SEND_SOUND(player_breacher, sound('code/modules/wod13/sounds/veil_violation.ogg', 0, 0, 75))
		return
	playsound(player_breacher, 'modular_tfn/modules/masquerade/sound/masquerade_violation.ogg', 50, FALSE, -5)
	to_chat(player_breacher, span_userdanger(span_bold("MASQUERADE VIOLATION")))

/atom/proc/observe_masquerade_reinforce(player_breacher)
	if(isgarou(player_breacher) || iswerewolf(player_breacher))
		SEND_SOUND(player_breacher, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
		to_chat(player_breacher, span_big(span_boldnicegreen("VEIL REINFORCEED")))
		return
	to_chat(player_breacher, span_big(span_boldnicegreen("MASQUERADE REINFORCED")))
	playsound(player_breacher, 'modular_tfn/modules/masquerade/sound/masquerade_reinforce.ogg', 50, FALSE, -5)
