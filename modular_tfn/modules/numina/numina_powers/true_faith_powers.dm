/datum/discipline/true_faith
	name = "True Faith"
	desc = "For the LORD is thy Shepard. (PUT DETAILS HERE WHEN POWERS ARE DONE)"
	icon_state = "daimonion"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/true_faith

/datum/discipline_power/true_faith
	name = "true_faith power name"
	desc = "true_faith power description"

	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/protean_deactivate.ogg'

/datum/discipline/true_faith/post_gain()
	. = ..()
	if(level >= 1)
		var/datum/action/blessing/blessing = new()
		blessing.Grant(owner)

/datum/action/blessing
	name = "Blessing"
	desc = "Call upon the powers that be to bless an object of holy significance."
	button_icon_state = "bloodshield"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/blessing/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE) //This is all TODO

/datum/discipline_power/true_faith/ward
	name = "Banish the Night"
	desc = "Through prayer and faith, send away the unholy."

	level = 1

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_LIVING

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 3 SECONDS
	range = 12
	var/command = "repulse" //As ward is essentially just making everyone fuck off from around you, we're going to borrow heavily from Dominate which does the same thing.

/datum/discipline_power/true_faith/ward/proc/ward_check(mob/living/carbon/human/owner, mob/living/target, tiebreaker = FALSE, base_difficulty = 4)

	if(!ishuman(target))
		return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.clan?.name == CLAN_GARGOYLE)
			return TRUE

	var/mypower = SSroll.storyteller_roll(owner.get_total_social(), difficulty = base_difficulty, mobs_to_show_output = owner, numerical = TRUE)
	var/theirpower = SSroll.storyteller_roll(target.get_total_mentality(), difficulty = 6, mobs_to_show_output = target, numerical = TRUE)

	return (mypower > theirpower)

/datum/discipline_power/true_faith/ward/pre_activation_checks(mob/living/target)  // this pre-check includes some special checks

	if(!iskindred(target) || !iswerewolf(target))
		return FALSE

	if(ward_check(owner, target, 4))
		return TRUE
	else
		to_chat(owner, span_warning("[target] has resisted your prayer!"))
		to_chat(target, span_warning("Your thoughts blur as a feeling of intense sickness washes over you. You resist."))
		do_cooldown(TRUE)
		return FALSE

/datum/discipline_power/true_faith/ward/activate(mob/living/target)
	. = ..()
	to_chat(owner, span_warning("You've successfully sent away [target]!"))
	to_chat(target,span_warning("The power extruding off of [owner] repulses you viciously!"))
	SEND_SOUND(target, sound('code/modules/wod13/sounds/dominate.ogg'))

	var/list/listeners = list(target)
	var/power_multiplier = 1
	apply_voice_of_god_effects(command, owner, listeners, power_multiplier)
