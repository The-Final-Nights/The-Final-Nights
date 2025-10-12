// Global list to track mobs grabbed by any tentacle
var/global/list/global_tentacle_grabs = list()

/mob/living/simple_animal/hostile/abyss_tentacle
	name = "abyssal tentacle"
	desc = "A shadowy tentacle from the abyss that seeks to grab and crush its prey."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "Goliath_tentacle_wiggle"
	icon_living = "Goliath_tentacle_wiggle"
	icon_dead = "Goliath_tentacle_retract"
	color = rgb(0,0,0)
	layer = BELOW_MOB_LAYER
	anchored = TRUE
	notransform = TRUE
	density = FALSE
	maxHealth = 120
	health = 120
	see_in_dark = 10

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "crushes"
	attack_verb_simple = "crush"
	attack_sound = 'sound/weapons/punch1.ogg'
	speak_emote = list("writhes")

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	del_on_death = TRUE

	vision_range = 7
	aggro_vision_range = 7
	environment_smash = ENVIRONMENT_SMASH_NONE

	var/mob/living/owner
	var/mob/living/grabbed_mob = null
	var/list/recently_released = list()
	var/aggro_mode = "Aggressive"
	COOLDOWN_DECLARE(grab_cooldown)
	COOLDOWN_DECLARE(damage_cooldown)

/mob/living/simple_animal/hostile/abyss_tentacle/Initialize(mapload, mob/living/summoner)
	. = ..()
	if(summoner)
		owner = summoner
	if(owner.tentacle_aggro_mode)
		aggro_mode = owner.tentacle_aggro_mode

	COOLDOWN_START(src, grab_cooldown, 1 SECONDS)
	COOLDOWN_START(src, damage_cooldown, 1 SECONDS)
	START_PROCESSING(SSobj, src)

/mob/living/simple_animal/hostile/abyss_tentacle/Destroy()
	release_grabbed_mob()
	STOP_PROCESSING(SSobj, src)
	return ..()

/mob/living/simple_animal/hostile/abyss_tentacle/CanAttack(atom/targ)
	if(!isliving(targ))
		return FALSE

	var/mob/living/L = targ

	if(L == owner)
		return FALSE
	if(istype(L, /mob/living/simple_animal/hostile/abyss_tentacle))
		return FALSE
	if(L.stat == DEAD)
		return FALSE
	if(L == grabbed_mob)
		return FALSE
	if(L in global.global_tentacle_grabs)
		return FALSE
	if(L in recently_released)
		return FALSE
	if(get_dist(src, L) > vision_range)
		return FALSE

	return ..()

/mob/living/simple_animal/hostile/abyss_tentacle/process(delta_time)
	if(aggro_mode == "Passive")
		if(grabbed_mob)
			release_grabbed_mob()
		else
			return

	if(COOLDOWN_FINISHED(src, grab_cooldown) && !grabbed_mob && aggro_mode != "Passive")
		COOLDOWN_START(src, grab_cooldown, 2 SECONDS)

		// Find & grab target
		var/mob/living/target_to_grab
		for(var/mob/living/L in view(2, src))
			if(L == owner || L.stat == DEAD || L == grabbed_mob || (L in recently_released)) // Not owner, dead, grabbed, or recently released
				continue
			if(istype(L, /mob/living/simple_animal/hostile/abyss_tentacle)) // Not another tentacle
				continue
			if(L in global.global_tentacle_grabs) // Not on The List tm
				continue
			target_to_grab = L
			break

		if(target_to_grab)
			grab_mob(target_to_grab)

	// Damage grabbed mob occasionally
	if(aggro_mode == "Aggressive" && COOLDOWN_FINISHED(src, damage_cooldown) && grabbed_mob)
		COOLDOWN_START(src, damage_cooldown, 5 SECONDS)
		grabbed_mob.apply_damage(40, BRUTE)
		to_chat(grabbed_mob, span_danger("The tentacle tightens its grip, crushing you!"))
		playsound(/mob/living/simple_animal/hostile/abyss_tentacle, 'sound/creatures/venus_trap_hurt.ogg', 50, FALSE)

/mob/living/simple_animal/hostile/abyss_tentacle/proc/grab_mob(mob/living/target)
	// More checks
	if(target == owner || istype(target, /mob/living/simple_animal/hostile/abyss_tentacle)) // Not owner, not another tentacle
		return
	if(target in global.global_tentacle_grabs) // Not grabbed by another tentacle
		return
	if(grabbed_mob) // Not already grabbing someone
		return
	if(target.client)
		to_chat(target, span_userdanger("A shadowy tentacle grabs you!"))
	visible_message(span_danger("[src] grabs hold of [target]!"))

	// Grab effects, short stun & drag
	playsound(/mob/living/simple_animal/hostile/abyss_tentacle, 'sound/misc/moist_impact.ogg', 50, FALSE)
	target.Stun(5)
	target.forceMove(get_turf(src))
	target.set_tentacle_grab(src)

	if(aggro_mode == "Control")
		target.mobility_flags &= ~(MOBILITY_STAND | MOBILITY_MOVE)
		target.set_resting(TRUE, TRUE, TRUE)
		to_chat(target, span_userdanger("The tentacle forces you to the ground!"))

	grabbed_mob = target
	global.global_tentacle_grabs += target

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_grabbed_mob_move))

/mob/living/simple_animal/hostile/abyss_tentacle/proc/release_mob(mob/living/target, add_cooldown = TRUE)
	if(target == grabbed_mob)
		grabbed_mob = null
		global.global_tentacle_grabs -= target
		target.Stun(0)
		target.clear_tentacle_grab()

		if(aggro_mode == "Control")
			target.mobility_flags |= (MOBILITY_STAND | MOBILITY_MOVE)
			target.set_resting(FALSE, TRUE, TRUE)

		UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
		to_chat(target, span_notice("The tentacle releases you!"))

		if(add_cooldown)
			recently_released += target
			addtimer(CALLBACK(src, PROC_REF(remove_from_recently_released), target), 10 SECONDS)

/mob/living/simple_animal/hostile/abyss_tentacle/proc/remove_from_recently_released(mob/living/target)
	recently_released -= target

/mob/living/simple_animal/hostile/abyss_tentacle/proc/release_grabbed_mob()
	if(grabbed_mob)
		release_mob(grabbed_mob, FALSE)

/mob/living/simple_animal/hostile/abyss_tentacle/proc/on_grabbed_mob_move(mob/living/source, atom/old_loc, movement_dir, forced)
	SIGNAL_HANDLER
	// If they try to move away, roll to break free
	if(get_dist(source, src) > 0)
		if(world.time >= source.escape_attempt)
			source.escape_attempt = world.time + 5 SECONDS
			var/rollcheck = SSroll.storyteller_roll(source.st_get_stat(STAT_STRENGTH), 6, FALSE, source)
			if(rollcheck == ROLL_SUCCESS)
				to_chat(source, span_notice("You break free from the tentacle's grasp!"))
				release_mob(source, TRUE) // Cooldown!
				return

			else if(rollcheck == ROLL_BOTCH || rollcheck == ROLL_FAILURE)
				to_chat(source, span_warning("You struggle against the tentacle but can't break free!"))

		source.visible_message(span_danger("The tentacle pulls [source] back!"))
		source.forceMove(get_turf(src))

/mob/living/simple_animal/hostile/abyss_tentacle/death()
	visible_message(span_danger("[src] retracts back into the shadows!"))
	release_grabbed_mob()
	. = ..()

/mob/living
	var/obj/grabbed_by_tentacle = null
	var/escape_attempt = 0
	var/tentacle_aggro_mode = "Aggressive"

/mob/living/proc/set_tentacle_grab(obj/tentacle)
	grabbed_by_tentacle = tentacle

/mob/living/proc/clear_tentacle_grab()
	grabbed_by_tentacle = null
	escape_attempt = 0
