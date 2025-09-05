SUBSYSTEM_DEF(beastmastering)
	name = "Beastmastering"
	init_order = INIT_ORDER_DEFAULT
	wait = 10
	priority = FIRE_PRIORITY_NPC

	var/list/currentrun = list()

/datum/controller/subsystem/beastmastering/stat_entry(msg)
	var/list/activelist = GLOB.beast_list
	msg = "BEASTS:[length(activelist)]"
	return ..()

/datum/controller/subsystem/beastmastering/fire(resumed = FALSE)

	if (!resumed)
		var/list/activelist = GLOB.beast_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/simple_animal/hostile/beastmaster/NPC = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(NPC)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.npc_list -= NPC
			GLOB.alive_npc_list -= NPC
			log_world("Found a null in npc list!")
			continue

		//!NPC.route_optimisation()
		if(MC_TICK_CHECK)
			return
		NPC.handle_automated_beasting()

/mob/living/simple_animal/hostile/beastmaster/Initialize()
	. = ..()
	GLOB.beast_list += src

/mob/living/simple_animal/hostile/beastmaster/Destroy()
	. = ..()
	if(stat < 1)
		if(beastmaster)
			beastmaster_owner.beastmaster -= src
			if(!length(beastmaster_owner.beastmaster))
				for(var/datum/action/beastmaster_stay/E in beastmaster_owner.actions)
					if(E)
						qdel(E)
				for(var/datum/action/beastmaster_deaggro/E in beastmaster_owner.actions)
					if(E)
						qdel(E)
		GLOB.beast_list -= src

/mob/living/simple_animal/hostile/beastmaster/death(gibbed)
	. = ..()
	if(beastmaster)
		beastmaster_owner.beastmaster -= src
		if(!length(beastmaster_owner.beastmaster))
			for(var/datum/action/beastmaster_stay/E in beastmaster_owner.actions)
				if(E)
					qdel(E)
			for(var/datum/action/beastmaster_deaggro/E in beastmaster_owner.actions)
				if(E)
					qdel(E)
	GLOB.beast_list -= src

/mob/living/simple_animal/hostile/beastmaster
	name = "dog"
	desc = "Woof-woof."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "dog"
	icon_living = "dog"
	icon_dead = "dog_dead"
	del_on_death = 1
	footstep_type = FOOTSTEP_MOB_SHOE
	mob_biotypes = MOB_ORGANIC
	speak_chance = 0
	turns_per_move = 1
	speed = 0.35
	maxHealth = 55 //Killable in two swings from a proper melee.
	health = 55
	harm_intent_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/dog.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 2
	maxbloodpool = 2
	loot = list()
	AIStatus = AI_OFF

	var/follow = TRUE
	var/mob/living/carbon/human/beastmaster_owner
	var/list/enemies = list()
	var/mob/living/targa

/mob/living/simple_animal/hostile/beastmaster/proc/handle_automated_beasting()
	if(client)
		return
	if(stat > 0)
		GLOB.beast_list -= src
		return
	if(!targa)
		if(length(enemies))
			for(var/mob/living/L in enemies)
				if(L)
					if(L.stat < 1 && L.z == z && get_dist(src, L) < 12)
						targa = L
	else if(targa.z != z || get_dist(src, targa) > 11 || targa.stat > 0)
		targa = null
		if(length(enemies))
			for(var/mob/living/L in enemies)
				if(L)
					if(L.stat < 1 && L.z == z && get_dist(src, L) < 12)
						targa = L

	var/totalshit = 1
	if(total_multiplicative_slowdown() > 0)
		totalshit = total_multiplicative_slowdown()

	if(targa)
		var/reqsteps = round((SSbeastmastering.next_fire-world.time)/totalshit)
		walk_to(src, targa, reqsteps, total_multiplicative_slowdown())
		if(get_dist(src, targa) <= 1)
			ClickOn(targa)
	else
		if(follow && isturf(beastmaster_owner?.loc))
			if( (z != beastmaster_owner.z) & (get_dist(beastmaster_owner.loc, loc) <= 10) )
				forceMove(get_turf(beastmaster_owner))
			else
				var/reqsteps = round((SSbeastmastering.next_fire-world.time)/totalshit)
				walk_to(src, beastmaster_owner, reqsteps, total_multiplicative_slowdown())
		else
			walk(src, 0)

/mob/living/simple_animal/hostile/beastmaster/proc/add_beastmaster_enemies(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/beastmaster))
		var/mob/living/simple_animal/hostile/beastmaster/M = L
		if(M.beastmaster_owner == beastmaster_owner)
			return
	if(L == beastmaster_owner)
		return
	enemies |= L
	if(!targa)
		targa = L

/mob/living/carbon/human/attack_hand(mob/living/carbon/human/user)
	if(user)
		if(!(user.combat_mode))
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster)
				B.add_beastmaster_enemies(user)
	..()

/mob/living/carbon/human/attack_animal(mob/user)
	if(user)
		for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster)
			B.add_beastmaster_enemies(user)
	..()

/mob/living/carbon/human/on_hit(obj/projectile/P)
	. = ..()
	if(P)
		if(P.firer)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster)
				B.add_beastmaster_enemies(P.firer)

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	. = ..()
	if(throwingdatum)
		if(throwingdatum.thrower)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster)
				B.add_beastmaster_enemies(throwingdatum.thrower)

/mob/living/carbon/human/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	if(user)
		if(W.force)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster)
				B.add_beastmaster_enemies(user)

/mob/living/carbon/human/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	. = ..()
	for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster)
		B.add_beastmaster_enemies(user)

/mob/living/carbon/human/pointed(atom/A as mob|obj|turf in view(client.view, src))
	if(..())
		if(isliving(A))
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster)
				B.add_beastmaster_enemies(A)

/mob/living/simple_animal/hostile/beastmaster/attack_hand(mob/living/carbon/human/user)
	if(user)
		if(user.combat_mode)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster_owner.beastmaster)
				B.add_beastmaster_enemies(user)
	..()

/mob/living/simple_animal/hostile/beastmaster/on_hit(obj/projectile/P)
	. = ..()
	if(P)
		if(P.firer)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster_owner.beastmaster)
				B.add_beastmaster_enemies(P.firer)

/mob/living/simple_animal/hostile/beastmaster/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	. = ..()
	if(throwingdatum)
		if(throwingdatum.thrower)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster_owner.beastmaster)
				B.add_beastmaster_enemies(throwingdatum.thrower)

/mob/living/simple_animal/hostile/beastmaster/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	if(user)
		if(W.force)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster_owner.beastmaster)
				B.add_beastmaster_enemies(user)

/mob/living/simple_animal/hostile/beastmaster/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	. = ..()
	if(user)
		for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster_owner.beastmaster)
			B.add_beastmaster_enemies(user)

/mob/living/simple_animal/hostile/beastmaster/attack_animal(mob/user)
	if(user)
		for(var/mob/living/simple_animal/hostile/beastmaster/B in beastmaster_owner.beastmaster)
			B.add_beastmaster_enemies(user)
	..()

/datum/action/beastmaster_stay
	name = "Stay/Follow"
	desc = "Command to stay or follow."
	button_icon_state = "wait"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/cool_down = 0
	var/following = FALSE

/datum/action/beastmaster_stay/Trigger(trigger_flags)
	. = ..()
	if(ishuman(owner))
		if(cool_down+10 >= world.time)
			return
		cool_down = world.time
		var/mob/living/carbon/human/H = owner
		if(!following)
			following = TRUE
			to_chat(owner, "You call your support.")
			for(var/mob/living/simple_animal/hostile/beastmaster/B in H.beastmaster)
				B.follow = TRUE
		else
			following = FALSE
			to_chat(owner, "Your support will wait here.")
			for(var/mob/living/simple_animal/hostile/beastmaster/B in H.beastmaster)
				B.follow = FALSE

/datum/action/beastmaster_deaggro
	name = "Loose Aggression"
	desc = "Command to stop any aggressive moves."
	button_icon_state = "deaggro"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/cool_down = 0

/datum/action/beastmaster_deaggro/Trigger(trigger_flags)
	. = ..()
	if(ishuman(owner))
		if(cool_down+10 >= world.time)
			return
		cool_down = world.time
		var/mob/living/carbon/human/H = owner
		for(var/mob/living/simple_animal/hostile/beastmaster/B in H.beastmaster)
			B.enemies = list()
			B.targa = null
