
/datum/discipline/chi_discipline/hellweaving
	name = "Hellweaving"
	desc = "Taught by the Yama Kings' court, you invoke your domain over the Thousand Hells."
	icon_state = "hellweaving"
	cost_demon = 1
	discipline_type = "Demon"
	power_type = /datum/discipline_power/chi_discipline_power/hellweaving

/datum/discipline_power/chi_discipline_power/hellweaving
	name = "Chi power name"
	desc = "Chi power description"
	cost_demon = 1
	activate_sound = "code/modules/wod13/sounds/hellweaving_activate.ogg"



/atom/movable/screen/fullscreen/yomi_world
	icon = 'icons/hud/fullscreen.dmi'
	icon_state = "ghost1"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/yomi_world/Initialize()
	. = ..()
	dir = pick(NORTH, EAST, WEST, SOUTH, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)

/obj/effect/particle_effect/smoke/bad/yomi
	name = "dark red smoke"
	color = "#6f0000"
	opaque = FALSE

/datum/effect_system/smoke_spread/bad/yomi
	effect_type = /obj/effect/particle_effect/smoke/bad/yomi

/obj/effect/particle_effect/smoke/bad/yomi/smoke_mob(mob/living/carbon/inhaling_mob)
	. = ..()
	if(.)
		inhaling_mob.adjustCloneLoss(10, TRUE)
		inhaling_mob.emote(pick("scream", "groan", "cry"))
		return TRUE

/datum/movespeed_modifier/yomi_flashback
	multiplicative_slowdown = 6


/datum/discipline_power/chi_discipline_power/hellweaving/proc/hellweaving_check(mob/living/carbon/human/owner, mob/living/target, tiebreaker = FALSE)
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()

	if(owner == conditioner)
		return TRUE

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.clane?.name == "Gargoyle")
			return TRUE

	if((theirpower > mypower))
		to_chat(owner, span_warning("[target]'s mind is too powerful to torment!"))
		return FALSE

	return TRUE

//HELLWEAVING 1
/datum/discipline_power/chi_discipline_power/hellweaving/one
	name = "Glimpse of Yomi"
	desc = "HChi power description"

	level = 1

	check_flags = DISC_CHECK_CAPABLE| DISC_CHECK_SEE
	target_type = TARGET_MOB

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	duration_length = 12 SECONDS
	range = 7

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/hellweaving/two,
		/datum/discipline_power/chi_discipline_power/hellweaving/three,
		/datum/discipline_power/chi_discipline_power/hellweaving/four,
		/datum/discipline_power/chi_discipline_power/hellweaving/five
	)

/datum/discipline_power/chi_discipline_power/hellweaving/one/pre_activation_checks(mob/living/target)
	return hellweaving_check(owner, target)

/datum/discipline_power/chi_discipline_power/hellweaving/one/activate(mob/living/target)
	. = ..()
	target.Immobilize(1 SECONDS)
	target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
	owner.update_sight()

/datum/discipline_power/chi_discipline_power/hellweaving/one/deactivate(mob/living/target)
	. = ..()
	target.clear_fullscreen("yomi", 5)
	owner.update_sight()

//HELLWEAVING 2
/datum/discipline_power/chi_discipline_power/hellweaving/two
	name = "Razor Winds"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CAPABLE| DISC_CHECK_SEE
	target_type = TARGET_MOB

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	range = 7


	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/hellweaving/one,
		/datum/discipline_power/chi_discipline_power/hellweaving/three,
		/datum/discipline_power/chi_discipline_power/hellweaving/four,
		/datum/discipline_power/chi_discipline_power/hellweaving/five
	)

/datum/discipline_power/chi_discipline_power/hellweaving/two/pre_activation_checks(mob/living/target)
	return hellweaving_check(owner, target)


/datum/discipline_power/chi_discipline_power/hellweaving/two/activate(mob/living/target)
	. = ..()
	playsound(get_turf(target), 'code/modules/wod13/sounds/portal.ogg', 100, TRUE)
	var/datum/effect_system/smoke_spread/bad/yomi/smoke = new
	smoke.set_up(discipline.level, target)
	smoke.start()

//HELLWEAVING 3
/datum/discipline_power/chi_discipline_power/hellweaving/three
	name = "Curse of the Yama Kings"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CAPABLE| DISC_CHECK_SEE
	target_type = TARGET_MOB

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	duration_length = 3 SECONDS
	range = 7

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/hellweaving/one,
		/datum/discipline_power/chi_discipline_power/hellweaving/two,
		/datum/discipline_power/chi_discipline_power/hellweaving/four,
		/datum/discipline_power/chi_discipline_power/hellweaving/five
	)

/datum/discipline_power/chi_discipline_power/hellweaving/four/pre_activation_checks(mob/living/target)
	return hellweaving_check(owner, target)


/datum/discipline_power/chi_discipline_power/hellweaving/three/activate(mob/living/target)
	. = ..()
	target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
	target.add_movespeed_modifier(/datum/movespeed_modifier/yomi_flashback)
	target.emote("cry")
	owner.update_sight()

/datum/discipline_power/chi_discipline_power/hellweaving/three/deactivate(mob/living/target)
	. = ..()
	target.clear_fullscreen("yomi", 5)
	target.remove_movespeed_modifier(/datum/movespeed_modifier/yomi_flashback)
	owner.update_sight()

//HELLWEAVING 4
/datum/discipline_power/chi_discipline_power/hellweaving/four
	name = "Rememberance of Yomi"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CAPABLE| DISC_CHECK_SEE
	target_type = TARGET_MOB

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	range = 7

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/hellweaving/one,
		/datum/discipline_power/chi_discipline_power/hellweaving/two,
		/datum/discipline_power/chi_discipline_power/hellweaving/three,
		/datum/discipline_power/chi_discipline_power/hellweaving/five
	)

/datum/discipline_power/chi_discipline_power/hellweaving/four/activate(mob/living/target)
	. = ..()
	target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
	owner.update_sight()
	var/datum/cb = CALLBACK(target, /mob/living/carbon/human/proc/attack_myself_command)
	for(var/i in 2 to 20)
		addtimer(cb, (i - 1) * 1.5 SECONDS)

/datum/discipline_power/chi_discipline_power/hellweaving/four/deactivate(mob/living/target)
	. = ..()
	target.clear_fullscreen("yomi", 5)
	owner.update_sight()

//HELLWEAVING 5
/datum/discipline_power/chi_discipline_power/hellweaving/five
	name = "Weaving The Yomi World"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	check_flags = DISC_CHECK_CAPABLE| DISC_CHECK_SEE
	target_type = TARGET_MOB

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	range = 7

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/hellweaving/one,
		/datum/discipline_power/chi_discipline_power/hellweaving/two,
		/datum/discipline_power/chi_discipline_power/hellweaving/three,
		/datum/discipline_power/chi_discipline_power/hellweaving/four
	)

/datum/discipline_power/chi_discipline_power/hellweaving/five/pre_activation_checks(mob/living/target)
	return hellweaving_check(owner, target)


/datum/discipline_power/chi_discipline_power/hellweaving/five/activate(mob/living/target)
	. = ..()
	if(do_after(owner, 5 SECONDS, target))
		target.overlay_fullscreen("yomi", /atom/movable/screen/fullscreen/yomi_world)
		target.set_fire_stacks(10)
		target.IgniteMob()

/datum/discipline_power/chi_discipline_power/hellweaving/five/deactivate(mob/living/target)
	. = ..()
	target.clear_fullscreen("yomi", 5)
