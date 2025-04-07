//entirely neutral or internal status effects go here

/datum/status_effect/crusher_damage //tracks the damage dealt to this mob by kinetic crushers
	id = "crusher_damage"
	duration = -1
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/total_damage = 0

/datum/status_effect/syphon_mark
	id = "syphon_mark"
	duration = 50
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	on_remove_on_mob_delete = TRUE
	var/obj/item/borg/upgrade/modkit/bounty/reward_target

/datum/status_effect/syphon_mark/on_creation(mob/living/new_owner, obj/item/borg/upgrade/modkit/bounty/new_reward_target)
	. = ..()
	if(.)
		reward_target = new_reward_target

/datum/status_effect/syphon_mark/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	return ..()

/datum/status_effect/syphon_mark/proc/get_kill()
	if(!QDELETED(reward_target))
		reward_target.get_kill(owner)

/datum/status_effect/syphon_mark/tick()
	if(owner.stat == DEAD)
		get_kill()
		qdel(src)

/datum/status_effect/syphon_mark/on_remove()
	get_kill()
	. = ..()

/atom/movable/screen/alert/status_effect/in_love
	name = "In Blood Bond"
	desc = "You feel so wonderfully in bond!"
	icon_state = "in_love"

/datum/status_effect/in_love
	id = "in_love"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/in_love
	var/mob/living/date

/datum/status_effect/in_love/on_creation(mob/living/new_owner, mob/living/love_interest)
	. = ..()
	if(.)
		date = love_interest
		linked_alert.desc = "You're in blood bond with [date.real_name]! How lovely."
/*
/datum/status_effect/in_love/tick()
	if(date)
		new /obj/effect/temp_visual/love_heart/invisible(date.drop_location(), owner)
*/
/datum/status_effect/throat_soothed
	id = "throat_soothed"
	duration = 60 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/throat_soothed/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")

/datum/status_effect/throat_soothed/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")

/datum/status_effect/bounty
	id = "bounty"
	status_type = STATUS_EFFECT_UNIQUE
	var/mob/living/rewarded

/datum/status_effect/bounty/on_creation(mob/living/new_owner, mob/living/caster)
	. = ..()
	if(.)
		rewarded = caster

/datum/status_effect/bounty/on_apply()
	to_chat(owner, "<span class='boldnotice'>You hear something behind you talking...</span> <span class='notice'>You have been marked for death by [rewarded]. If you die, they will be rewarded.</span>")
	playsound(owner, 'sound/weapons/gun/shotgun/rack.ogg', 75, FALSE)
	return ..()

/datum/status_effect/bounty/tick()
	if(owner.stat == DEAD)
		rewards()
		qdel(src)

/datum/status_effect/bounty/proc/rewards()
	if(rewarded && rewarded.mind && rewarded.stat != DEAD)
		to_chat(owner, "<span class='boldnotice'>You hear something behind you talking...</span> <span class='notice'>Bounty claimed.</span>")
		playsound(owner, 'sound/weapons/gun/shotgun/shot.ogg', 75, FALSE)
		to_chat(rewarded, "<span class='greentext'>You feel a surge of mana flow into you!</span>")
		for(var/obj/effect/proc_holder/spell/spell in rewarded.mind.spell_list)
			spell.charge_counter = spell.charge_max
			spell.recharging = FALSE
			spell.update_icon()
		rewarded.adjustBruteLoss(-25)
		rewarded.adjustFireLoss(-25)
		rewarded.adjustToxLoss(-25)
		rewarded.adjustOxyLoss(-25)
		rewarded.adjustCloneLoss(-25)

// heldup is for the person being aimed at
/datum/status_effect/heldup
	id = "heldup"
	duration = -1
	tick_interval = -1
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/status_effect/heldup

/atom/movable/screen/alert/status_effect/heldup
	name = "Held Up"
	desc = "Making any sudden moves would probably be a bad idea!"
	icon_state = "aimed"

/datum/status_effect/heldup/on_apply()
	owner.apply_status_effect(STATUS_EFFECT_SURRENDER)
	return ..()

/datum/status_effect/heldup/on_remove()
	owner.remove_status_effect(STATUS_EFFECT_SURRENDER)
	return ..()

// holdup is for the person aiming
/datum/status_effect/holdup
	id = "holdup"
	duration = -1
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/holdup

/atom/movable/screen/alert/status_effect/holdup
	name = "Holding Up"
	desc = "You're currently pointing a gun at someone."
	icon_state = "aimed"

// this status effect is used to negotiate the high-fiving capabilities of all concerned parties
/datum/status_effect/offering
	id = "offering"
	duration = -1
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	/// The people who were offered this item at the start
	var/list/possible_takers
	/// The actual item being offered
	var/obj/item/offered_item
	/// The type of alert given to people when offered, in case you need to override some behavior (like for high-fives)
	var/give_alert_type = /atom/movable/screen/alert/give

/datum/status_effect/offering/on_creation(mob/living/new_owner, obj/item/offer, give_alert_override, mob/living/carbon/offered)
	. = ..()
	if(!.)
		return
	offered_item = offer
	if(give_alert_override)
		give_alert_type = give_alert_override

	if(offered && is_taker_elligible(offered))
		register_candidate(offered)
	else
		for(var/mob/living/carbon/possible_taker in orange(1, owner))
			if(!is_taker_elligible(possible_taker))
				continue

			register_candidate(possible_taker)

	if(!possible_takers) // no one around
		qdel(src)
		return

	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_owner_in_range))
	RegisterSignal(offered_item, list(COMSIG_PARENT_QDELETING, COMSIG_ITEM_DROPPED), PROC_REF(dropped_item))

/datum/status_effect/offering/Destroy()
	for(var/mob/living/carbon/removed_taker as anything in possible_takers)
		remove_candidate(removed_taker)
	LAZYCLEARLIST(possible_takers)
	offered_item = null
	return ..()

/// Hook up the specified carbon mob to be offered the item in question, give them the alert and signals and all
/datum/status_effect/offering/proc/register_candidate(mob/living/carbon/possible_candidate)
	var/atom/movable/screen/alert/give/G = possible_candidate.throw_alert("[owner]", give_alert_type)
	if(!G)
		return
	LAZYADD(possible_takers, possible_candidate)
	RegisterSignal(possible_candidate, COMSIG_MOVABLE_MOVED, PROC_REF(check_taker_in_range))
	G.setup(possible_candidate, src)

/// Remove the alert and signals for the specified carbon mob. Automatically removes the status effect when we lost the last taker
/datum/status_effect/offering/proc/remove_candidate(mob/living/carbon/removed_candidate)
	removed_candidate.clear_alert("[owner]")
	LAZYREMOVE(possible_takers, removed_candidate)
	UnregisterSignal(removed_candidate, COMSIG_MOVABLE_MOVED)
	if(!possible_takers && !QDELING(src))
		qdel(src)

/// One of our possible takers moved, see if they left us hanging
/datum/status_effect/offering/proc/check_taker_in_range(mob/living/carbon/taker)
	SIGNAL_HANDLER
	if(owner.CanReach(taker) && !IS_DEAD_OR_INCAP(taker))
		return

	to_chat(taker, span_warning("You moved out of range of [owner]!"))
	remove_candidate(taker)

/// The offerer moved, see if anyone is out of range now
/datum/status_effect/offering/proc/check_owner_in_range(mob/living/carbon/source)
	SIGNAL_HANDLER

	for(var/mob/living/carbon/checking_taker as anything in possible_takers)
		if(!istype(checking_taker) || !owner.CanReach(checking_taker) || IS_DEAD_OR_INCAP(checking_taker))
			remove_candidate(checking_taker)

/// We lost the item, give it up
/datum/status_effect/offering/proc/dropped_item(obj/item/source)
	SIGNAL_HANDLER
	qdel(src)

/**
 * Is our taker valid as a target for the offering? Meant to be used when registering
 * takers in `on_creation()`. You should override `additional_taker_check()` instead of this.
 *
 * Returns `TRUE` if the taker is valid as a target for the offering.
 */
/datum/status_effect/offering/proc/is_taker_elligible(mob/living/carbon/taker)
	return owner.CanReach(taker) && !IS_DEAD_OR_INCAP(taker) && additional_taker_check(taker)

/**
 * Additional checks added to `CanReach()` and `IS_DEAD_OR_INCAP()` in `is_taker_elligible()`.
 * Should be what you override instead of `is_taker_elligible()`. By default, checks if the
 * taker can hold items.
 *
 * Returns `TRUE` if the taker is valid as a target for the offering based on these
 * additional checks.
 */
/datum/status_effect/offering/proc/additional_taker_check(mob/living/carbon/taker)
	return taker.can_hold_items()

/**
 * This status effect is meant only for items that you don't actually receive
 * when offered, mostly useful for `/obj/item/hand_item` subtypes.
 */
/datum/status_effect/offering/no_item_received

/datum/status_effect/offering/no_item_received/additional_taker_check(mob/living/carbon/taker)
	return taker.usable_hands > 0

/**
 * This status effect is meant only to be used for offerings that require the target to
 * be resting (like when you're trying to give them a hand to help them up).
 * Also doesn't require them to have their hands free (since you're not giving them
 * anything).
 */
/datum/status_effect/offering/no_item_received/needs_resting

/datum/status_effect/offering/no_item_received/needs_resting/additional_taker_check(mob/living/carbon/taker)
	return taker.body_position == LYING_DOWN

/datum/status_effect/offering/no_item_received/needs_resting/on_creation(mob/living/new_owner, obj/item/offer, give_alert_override, mob/living/carbon/offered)
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(check_owner_standing))

/datum/status_effect/offering/no_item_received/needs_resting/register_candidate(mob/living/carbon/possible_candidate)
	. = ..()
	RegisterSignal(possible_candidate, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(check_candidate_resting))

/datum/status_effect/offering/no_item_received/needs_resting/remove_candidate(mob/living/carbon/removed_candidate)
	UnregisterSignal(removed_candidate, COMSIG_LIVING_SET_BODY_POSITION)
	return ..()

/// Simple signal handler that ensures that, if the owner stops standing, the offer no longer stands either!
/datum/status_effect/offering/no_item_received/needs_resting/proc/check_owner_standing(mob/living/carbon/owner)
	if(src.owner.body_position == STANDING_UP)
		return

	// This doesn't work anymore if the owner is no longer standing up, sorry!
	qdel(src)

/// Simple signal handler that ensures that, should a candidate now be standing up, the offer won't be standing for them anymore!
/datum/status_effect/offering/no_item_received/needs_resting/proc/check_candidate_resting(mob/living/carbon/candidate)
	SIGNAL_HANDLER

	if(candidate.body_position == LYING_DOWN)
		return

	// No longer lying down? You're no longer eligible to take the offer, sorry!
	remove_candidate(candidate)

/// Subtype for high fives, so we can fake out people
/datum/status_effect/offering/no_item_received/high_five
	id = "offer_high_five"

/datum/status_effect/offering/no_item_received/high_five/dropped_item(obj/item/source)
	// Lets us "too slow" people, instead of qdeling we just handle the ref
	offered_item = null

//this effect gives the user an alert they can use to surrender quickly
/datum/status_effect/surrender
	id = "surrender"
	duration = -1
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/surrender

/atom/movable/screen/alert/status_effect/surrender
	name = "Surrender"
	desc = "Looks like you're in trouble now, bud. Click here to surrender. (Warning: You will be incapacitated.)"
	icon_state = "surrender"

/atom/movable/screen/alert/status_effect/surrender/Click(location, control, params)
	. = ..()
	owner.emote("surrender")

/*
 * A status effect used for preventing caltrop message spam
 *
 * While a mob has this status effect, they won't recieve any messages about
 * stepping on caltrops. But they will be stunned and damaged regardless.
 *
 * The status effect itself has no effect, other than to disappear after
 * a second.
 */
/datum/status_effect/caltropped
	id = "caltropped"
	duration = 1 SECONDS
	tick_interval = INFINITY
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/atom/movable/screen/alert/status_effect/leaning
	name = "Leaning"
	desc = "You're leaning on something!"
	icon_state = "buckled"

/atom/movable/screen/alert/status_effect/leaning/Click()
	var/mob/living/L = usr
	if(!istype(L) || L != owner)
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.last_special <= world.time)
		return L.stop_leaning()

/datum/status_effect/leaning
	id = "leaning"
	duration = -1
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/leaning

/datum/status_effect/leaning/on_creation(mob/living/carbon/new_owner, atom/object, leaning_offset = 11)
	. = ..()
	if(!.)
		return
	new_owner.start_leaning(object, leaning_offset)
