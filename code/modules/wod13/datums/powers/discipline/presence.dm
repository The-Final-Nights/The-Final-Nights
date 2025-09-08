/datum/discipline/presence
	name = "Presence"
	desc = "Allows you to attract, sway, and control crowds through supernatural allure and emotional manipulation."
	icon_state = "presence"
	power_type = /datum/discipline_power/presence

/datum/discipline/presence/post_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CHARMER, /datum/discipline/presence)

/datum/discipline_power/presence
	name = "Presence power name"
	desc = "Presence power description"

	activate_sound = 'code/modules/wod13/sounds/presence_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/presence_deactivate.ogg'


/datum/discipline_power/presence/proc/presence_hearing_check(mob/living/carbon/human/owner, mob/living/target)
	var/list/hearers = get_hearers_in_view(8, owner)
	if(!(target in hearers))
		to_chat(owner, span_warning("[target] cannot hear you — they are too far or behind an obstruction."))
		return FALSE
	else
		to_chat(owner, span_info("[target] hears you clearly."))
		return TRUE

/datum/discipline_power/presence/proc/presence_check(mob/living/carbon/human/owner, mob/living/target, base_difficulty = 4, var/presence_succeeded = FALSE)

	if(!ishuman(target))
		return FALSE

	var/mypower = SSroll.storyteller_roll(owner.get_total_social(), difficulty = base_difficulty, mobs_to_show_output = owner, numerical = TRUE)
	var/theirpower = SSroll.storyteller_roll(target.get_total_mentality(), difficulty = 6, mobs_to_show_output = target, numerical = TRUE)

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.clan?.name == CLAN_GARGOYLE)
			theirpower -= 2


	return (mypower > theirpower && ((owner.generation - 3) < target.generation))

//AWE
/datum/discipline_power/presence/awe
	name = "Awe"
	desc = "Make those around you admire and want to be closer to you."

	level = 1
	vitae_cost = 0

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/awe/pre_activation_checks(mob/living/target)

	if(!presence_hearing_check(owner, target))
		return FALSE

	presence_succeeded = presence_check(owner, target, base_difficulty = 4)
	if(presence_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/presence/awe/activate(mob/living/carbon/human/target)
	. = ..()

	if(presence_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		target.apply_status_effect(STATUS_EFFECT_AWE, owner)
		to_chat(owner, span_warning("You've enthralled [target] with your commanding aura!"))
		to_chat(target, span_userlove("COME HERE"))
		owner.say("Come here.")
		SEND_SOUND(target, sound('code/modules/wod13/sounds/presence_activate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your attempt to sway!"))
		to_chat(target, span_warning("An overwhelming aura radiates from [owner], compelling your admiration… but you steel your heart and turn away from their unnatural allure."))

/datum/discipline_power/presence/awe/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/proc/walk_to_caster(mob/living/step_to)
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_to(src, step_to, 0)
		face_atom(step_to)

//DREAD GAZE
/datum/discipline_power/presence/dread_gaze
	name = "Dread Gaze"
	desc = "Incite fear in others through only your words and gaze."

	level = 2

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/dread_gaze/pre_activation_checks(mob/living/target)

	if(!presence_hearing_check(owner, target))
		return FALSE

	presence_succeeded = presence_check(owner, target, base_difficulty = 5)
	if(presence_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()

	if(presence_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		target.Stun(1 SECONDS)
		to_chat(target, span_userlove("DOWN"))
		to_chat(owner, span_warning("You've enthralled [target] with your commanding aura!"))
		owner.say("Down!")
		if(target.body_position == STANDING_UP)
			target.toggle_resting()
		SEND_SOUND(target, sound('code/modules/wod13/sounds/presence_activate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your attempt to sway!"))
		to_chat(target, span_warning("An overwhelming aura radiates from [owner], compelling your admiration… but you steel your heart and turn away from their unnatural allure."))

/datum/discipline_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//ENTRANCEMENT
/datum/discipline_power/presence/entrancement
	name = "Entrancement"
	desc = "Manipulate minds by bending emotions to your will."

	level = 3

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/entrancement/pre_activation_checks(mob/living/target)

	if(!presence_hearing_check(owner, target))
		return FALSE

	presence_succeeded = presence_check(owner, target, base_difficulty = 5)
	if(presence_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/presence/entrancement/activate(mob/living/carbon/human/target)
	. = ..()

	if(presence_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		var/obj/item/I1 = target.get_active_held_item()
		var/obj/item/I2 = target.get_inactive_held_item()

		to_chat(owner, span_warning("You've enthralled [target] with your commanding aura!"))
		to_chat(target, span_userlove("GIVE IT HERE"))
		owner.say("Give it here.")

		target.face_atom(owner)
		target.do_jitter_animation(3 SECONDS)
		target.Immobilize(1 SECONDS)
		target.drop_all_held_items()
		if(I1)
			I1.throw_at(get_turf(owner), 3, 1, target)
		if(I2)
			I2.throw_at(get_turf(owner), 3, 1, target)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/presence_activate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your attempt to sway!"))
		to_chat(target, span_warning("An overwhelming aura radiates from [owner], compelling your admiration… but you steel your heart and turn away from their unnatural allure."))

/datum/discipline_power/presence/entrancement/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SUMMON
/datum/discipline_power/presence/summon
	name = "Summon"
	desc = "Call anyone you've ever met to be by your side."

	level = 4

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/summon/pre_activation_checks(mob/living/target)

	if(!presence_hearing_check(owner, target))
		return FALSE

	presence_succeeded = presence_check(owner, target, base_difficulty = 6)
	if(presence_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/presence/summon/activate(mob/living/carbon/human/target)
	. = ..()

	if(presence_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("You've compelled [target] to heed your presence!"))
		to_chat(target, span_userlove("LEAVE"))
		owner.say("Leave!")

		var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
		for(var/i in 1 to 30)
			addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())

		target.emote("scream")
		target.do_jitter_animation(3 SECONDS)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/presence_activate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your attempt to sway!"))
		to_chat(target, span_warning("An overwhelming aura radiates from [owner], compelling your admiration… but you steel your heart and turn away from their unnatural allure."))

/datum/discipline_power/presence/summon/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	walk(src, 0)
	if(!CheckFrenzyMove())
		set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		step_away(src, step_from, 99)

//MAJESTY
/datum/discipline_power/presence/majesty
	name = "Majesty"
	desc = "Become so grand that others find it nearly impossible to disobey or harm you."

	level = 5

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7

	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 5 SECONDS
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/majesty/pre_activation_checks(mob/living/target)

	if(!presence_hearing_check(owner, target))
		return FALSE

	presence_succeeded = presence_check(owner, target, base_difficulty = 7)
	if(presence_succeeded)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/presence/majesty/activate(mob/living/carbon/human/target)
	. = ..()

	if(presence_succeeded)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("You've overwhelmed [target] with your majestic aura!"))
		to_chat(target, span_userlove("DISROBE"))
		owner.say("Disrobe.")
		target.Immobilize(1 SECONDS)
		for(var/obj/item/clothing/W in target.contents)
			target.dropItemToGround(W, TRUE)
		SEND_SOUND(target, sound('code/modules/wod13/sounds/presence_activate.ogg'))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your attempt to sway!"))
		to_chat(target, span_warning("An overwhelming aura radiates from [owner], compelling your admiration… but you steel your heart and turn away from their unnatural allure."))

/datum/discipline_power/presence/majesty/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
