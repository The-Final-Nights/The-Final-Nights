SUBSYSTEM_DEF(graveyard)
	name = "Graveyard"
	init_order = INIT_ORDER_DEFAULT
	wait = 3000
	priority = FIRE_PRIORITY_DEFAULT

	var/max_graveyard_zombies = 20
	var/alive_zombies = 0
	var/lost_points = 0
	var/clear_runs = 0
	var/list/graves = list()
	var/total_good = 0
	var/total_bad = 0
	var/zombie_type_targets = list("default"=6, "siege"=6, "shrieker"=3, "wonderer"=6)

// Core update loop
/datum/controller/subsystem/graveyard/fire()
	if (!has_active_keeper()) return

	var/spawned_counts = list("default"=0, "siege"=0, "shrieker"=0, "wonderer"=0)

	if(alive_zombies < 10)
		announce_to_keepers("WALKING DEAD ARE RISING...")
		var/current_counts = get_current_zombie_counts()

		for(var/ztype in zombie_type_targets)
			var/needed = zombie_type_targets[ztype] - (current_counts[ztype] || 0)
			while(needed-- > 0 && alive_zombies < max_graveyard_zombies)
				var/Z = spawn_graveyard_zombie(pick(graves), ztype)
				if(Z)
					alive_zombies++
					spawned_counts[ztype]++

		clear_runs++
	else
		lost_points++
		clear_runs = 0
		announce_to_keepers("Zombies not spawned. Too many alive.")
		total_good += count_active_keepers()

	message_admins("Graveyard Spawn Summary: [json_encode(spawned_counts)]")

// Support functions
/datum/controller/subsystem/graveyard/proc/has_active_keeper()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L?.mind?.assigned_role == "Graveyard Keeper" && L.client)
			return TRUE
	return FALSE

/datum/controller/subsystem/graveyard/proc/get_current_zombie_counts()
	var/counts = list()
	for(var/mob/living/simple_animal/hostile/zombie/Z in GLOB.zombie_list)
		var/datum/component/graveyard_zombie/comp = Z.GetComponent(/datum/component/graveyard_zombie)
		if(comp) counts[comp.zombie_behavior] = (counts[comp.zombie_behavior] || 0) + 1
	return counts

/datum/controller/subsystem/graveyard/proc/spawn_graveyard_zombie(atom/grave, behavior)
	var/turf/T = get_turf(grave)
	var/Z = new /mob/living/simple_animal/hostile/zombie(T)
	if(Z)
		new /datum/component/graveyard_zombie(Z, list("zombie_behavior" = behavior))
		GLOB.zombie_list += Z
	return Z


/datum/controller/subsystem/graveyard/proc/announce_to_keepers(msg)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L?.mind?.assigned_role == "Graveyard Keeper" && L.client)
			to_chat(L, msg)

/datum/controller/subsystem/graveyard/proc/count_active_keepers()
	var/count = 0
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L?.mind?.assigned_role == "Graveyard Keeper" && L.client)
			count++
	return count


//
// Graveyard Zombie Component
//

/datum/component/graveyard_zombie
	var/mob/living/simple_animal/hostile/zombie/owner
	var/loop_started = FALSE
	var/zombie_behavior = "default"
	var/can_rally = TRUE
	var/visiting_grave = FALSE
	var/current_task = "idle"

	New(atom/parent, list/args)
		..()
		owner = parent
		zombie_behavior = args["zombie_behavior"] || "default"
		owner.name = setup_graveyardzombie()
		StartBehaviorLoop()
		message_admins("zombie [owner] spawned with behavior: [zombie_behavior]")

	proc/setup_graveyardzombie()
		var/names = list(
			"default" = list("Zombu", "Zombie", "Corpse"),
			"siege" = list("Siege Zombie", "Siege Corpse"),
			"shrieker" = list("Shrieker", "Shrieking Zombie", "Screaming Corpse"),
			"wonderer" = list("Shambling Corpse", "Wondering Zombie", "Wandering Corpse")
		)
		return pick(names[zombie_behavior] || list("Zombie"))

	//Handles death of the zombie and rewards the last attacker if they are in the Graveyard area.
	proc/on_death()
		var/mob/living/H = owner.last_attacker
		if(H && get_area_name(H) == "Graveyard")
			H.killedzombies++
			if(H.killedzombies >= 10)
				H.killedzombies = 0
				H.masquerade++
				to_chat(H, "You slew 10 undead. Masquerade Point Restored.")
			else
				to_chat(H, "Graveyard Duty: Zombies killed: [H.killedzombies]/10.")


//
// Graveyard Zombie Behavior:
//
	//Prime the zombie behavior loop, which will run every 20 ticks if the zombie is alive.
	proc/StartBehaviorLoop()
		if(loop_started) return
		loop_started = TRUE
		spawn()
			while(ismob(owner) && !QDELETED(owner))
				if(prob(5)) owner.say(pick("urrrgh...", "braaains...", "gruhhh..."))
				RunBehavior()
				sleep(20)

	/// Decides what  AI logic to run.
	proc/RunBehavior()
		switch(zombie_behavior)
			if("default")   default_zombie_ai()
			if("siege")     siege_zombie_ai()
			if("shrieker")  shrieker_zombie_ai()
			if("wonderer")  wonderer_zombie_ai()
			else            default_zombie_ai()

	//Sets the zombie's current task and handles it accordingly until its done, or interupted.
	proc/HandleTask(task)
		switch(task)
			if("attack")      owner.attack_target(owner.locate_nearest_living_target())
			if("go_to_gate")  owner.path_attack_vampgate()
			if("wonder")      owner.wonder_randomly()
			if("flee_and_rally") owner.start_zombie_rally()

//
// These are the actual "AI" They call HandleTask() when they need to.
//
/datum/component/graveyard_zombie/proc/default_zombie_ai()
	var/mob/living/target = owner.locate_nearest_living_target()
	if(target)
		current_task = "attack"
	else
		current_task = "go_to_gate"
	HandleTask(current_task)

/datum/component/graveyard_zombie/proc/siege_zombie_ai()
	if(owner.last_attacker && get_dist(owner, owner.last_attacker) <= 7)
		current_task = "attack"
	else
		current_task = "go_to_gate"
	HandleTask(current_task)

/datum/component/graveyard_zombie/proc/shrieker_zombie_ai()
	if(owner.locate_nearest_living_target())
		current_task = "attack"
	else
		current_task = "wonder"
	HandleTask(current_task)

/datum/component/graveyard_zombie/proc/wonderer_zombie_ai()
	if(owner.locate_nearest_living_target())
		current_task = "attack"
	else
		current_task = "wonder"
	HandleTask(current_task)


//
// Graveyard Zombie Behaviors: Used to build tasks for the zombies, and to handle other actions.
//

/// Finds the closest valid living target for the zombie to pursue.
/mob/living/simple_animal/hostile/zombie/proc/locate_nearest_living_target()
	var/mob/living/closest
	var/best_dist = 99
	for(var/mob/living/M in view(7, src))
		if(iszomboid(M)) continue
		if(M.stat < DEAD && M != src && !isdead(M))
			var/d = get_dist(src, M)
			if(d < best_dist)
				best_dist = d
				closest = M
	return closest

/// Attacks the given target if in range; otherwise moves toward them.
/mob/living/simple_animal/hostile/zombie/proc/attack_target(mob/living/target)
	if(!target || QDELETED(target)) return
	if(get_dist(src, target) <= 1)
		UnarmedAttack(target)
	else
		step_towards(src, target)

/// Makes the zombie wander aimlessly, or occasionally visit a nearby grave.
/mob/living/simple_animal/hostile/zombie/proc/wonder_randomly()
	var/datum/component/graveyard_zombie/comp = src.GetComponent(/datum/component/graveyard_zombie)
	if(!comp || comp.visiting_grave) return
	if(prob(10) && length(SSgraveyard.graves))
		var/list/nearby = list()
		for(var/obj/vampgrave/G in SSgraveyard.graves)
			if(get_dist(src, G) <= 20)
				nearby += G

		if(length(nearby))
			var/obj/vampgrave/G = pick(nearby)
			step_towards(src, G)
			comp.visiting_grave = TRUE
			spawn(120)
				comp.visiting_grave = FALSE
			return

	step_to(src, get_step(src, pick(NORTH, SOUTH, EAST, WEST)))

/// Rallies nearby zombies to move toward a target or the vampgate.
/mob/living/simple_animal/hostile/zombie/proc/start_zombie_rally(mob/living/target = null)
	if(!target && GLOB.vampgate) target = GLOB.vampgate

	for(var/mob/living/simple_animal/hostile/zombie/Z in view(7, src))
		if(Z == src) continue
		if(target)
			step_towards(Z, target)
			Z.path_attack_vampgate()
			Z.emote("moans and shuffles toward the gate...")

	src.emote("screeches in a piercing tone!")
	src.emote("scream")

/// Makes the zombie maintain a position within a certain range of a target.
/mob/living/simple_animal/hostile/zombie/proc/follow_at_range(mob/living/target, min_range = 3, max_range = 5)
	if(!target || QDELETED(target) || target.stat >= DEAD) return

	var/dist = get_dist(src, target)
	if(dist < min_range)
		step_away(src, target)
	else if(dist > max_range)
		step_towards(src, target)
	else
		src.dir = get_dir(src, target)

/// Directs the zombie to approach and attack the vampgate, or wander if none exists.
/mob/living/simple_animal/hostile/zombie/proc/path_attack_vampgate()
	if(!GLOB.vampgate)
		wonder_randomly()
		return

	if(get_dist(src, GLOB.vampgate) > 1)
		step_towards(src, GLOB.vampgate)
	else
		UnarmedAttack(GLOB.vampgate)




//
// Graves
//

/obj/vampgrave
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "grave1"
	name = "grave"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
/obj/vampgrave/Initialize()
	. = ..()
	SSgraveyard.graves += src
	icon_state = "grave[rand(1,10)]"
	if(GLOB.winter)
		var/area/vtm/V = get_area(src)
		if(istype(V) && V.upper)
			icon_state = "[icon_state]-snow"
/obj/vampgrave/Destroy()
	. = ..()
	SSgraveyard.graves -= src
