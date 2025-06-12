SUBSYSTEM_DEF(graveyard)
	name = "Graveyard"
	init_order = INIT_ORDER_DEFAULT
	wait = 3000
	priority = FIRE_PRIORITY_DEFAULT

	var/max_graveyard_zombies = 50
	var/alive_zombies = 0
	var/lost_points = 0
	var/clear_runs = 0
	var/list/graves = list()
	var/total_good = 0
	var/total_bad = 0
	var/zombie_type_targets = list("default"=10, "siege"=6, "shrieker"=3, "wanderer"=10)

//
//Graveyard Core, and update loop, every 5 minutes.
//
/datum/controller/subsystem/graveyard/fire()
	if (!has_active_keeper()) return
	var/spawned_counts = list("default"=0, "siege"=0, "shrieker"=0, "wanderer"=0)
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

/datum/controller/subsystem/graveyard/proc/has_active_keeper()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L?.mind?.assigned_role == "Graveyard Keeper" && L.client)
			return TRUE
	return FALSE

/datum/controller/subsystem/graveyard/proc/get_current_zombie_counts()
	var/counts = list()
	for(var/mob/living/simple_animal/hostile/zombie/Z in GLOB.zombie_list)
		var/datum/component/graveyard_zombie/comp = Z.GetComponent(/datum/component/graveyard_zombie)
		if(comp) counts[comp.zombie_type] = (counts[comp.zombie_type] || 0) + 1
	return counts

/datum/controller/subsystem/graveyard/proc/spawn_graveyard_zombie(atom/grave, behavior)
	var/turf/T = get_turf(grave)
	var/Z = new /mob/living/simple_animal/hostile/zombie(T)
	if(Z)
		new /datum/component/graveyard_zombie(Z, list("zombie_type" = behavior))
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
	var/zombie_type = "default"
	var/can_rally = TRUE
	var/visiting_grave = FALSE
	var/current_task = "wander"
	var/mob/living/ai_target = null
	New(atom/parent, list/args)
		..()
		owner = parent
		zombie_type = args["zombie_type"] || "default"
		owner.name = setup_graveyardzombie()
		StartBehaviorLoop()
	proc/setup_graveyardzombie()
		var/names = list(
			"default" = list("Zombu", "Zombie", "Corpse"),
			"siege" = list("Siege Zombie", "Siege Corpse"),
			"shrieker" = list("Shrieker", "Shrieking Zombie", "Screaming Corpse"),
			"wanderer" = list("Shambling Corpse", "wandering Zombie", "Wandering Corpse")
		)
		return pick(names[zombie_type] || list("Zombie"))


	//
	// Graveyard Zombie Behavior: The "AI's", handles setting the Tasks, based on their contents.
	//
	proc/StartBehaviorLoop()
		if(loop_started) return
		loop_started = TRUE
		spawn()
			while(ismob(owner) && !QDELETED(owner))
				if(prob(5)) owner.say(pick("urrrgh...", "braaains...", "gruhhh..."))
				RunBehavior()
				sleep(10)

	//AI's return the current task, tasks try to get done.
	proc/RunBehavior()
		ai_target = owner.locate_nearest_attack_target() //checks for valid attack targets

		// Global stumble chance for all zombies
		if(prob(20)) // 20% chance to stumble
			var/dir = pick(NORTH, SOUTH, EAST, WEST)
			step(owner, dir)
			if(prob(25)) // 25% chance to actually fall
				owner.emote("trips and falls to the ground with a wet thud.")
				owner.Paralyze(60 * 1)
			return

		switch(zombie_type)
			if("default")   current_task = default_zombie_ai()
			if("siege")     current_task = siege_zombie_ai()
			if("shrieker")  current_task = shrieker_zombie_ai()
			if("wanderer")  current_task = wanderer_zombie_ai()
			else            current_task = "wander"
		HandleTask(current_task)

	//Sets the zombie's current task and handles it until its done, or interupts itself, etc.
	proc/HandleTask(task)
		switch(task)
			if("attack")          perform_attack() //attack until the target isn't worth attacking.
			if("go_to_gate")      perform_gate_rush() //Rush to the gate, punch it to open it, walk through if open.
			if("wander")          perform_wander() //wander around, maybe visit a grave and say something funny.
			if("flee_and_rally")  perform_rally() //Screamers cause zombies near them to target, their target, and avoid the target, unless trapped, then attacks.
	//There's many places to expand behaviors, this Tasks are the place to call the bare minimum behaviors needed in that tick.
	proc/perform_attack()
		owner.attack_target(ai_target)
	proc/perform_gate_rush()
		owner.charge_gate()
	proc/perform_wander()
		owner.wander_randomly()
	proc/perform_rally()
		owner.start_zombie_rally(ai_target)
		owner.follow_at_range(ai_target)

	//
	// GYZombie AI's, This is the BRAIN, and sets the Current Task based on conditions, and type of zombie. Like Attacking, Screaming, etc.
	//

/datum/component/graveyard_zombie/proc/default_zombie_ai()
	if (ai_target) //if it has a target, keep attacking.
		return "attack"
	if (!ai_target && GLOB.vampgate) //No target, break the gate or walk through it to damage global masquerade.
		return "go_to_gate"
	else //if its stupid or broken, wander i guess
		return "wander"

/datum/component/graveyard_zombie/proc/siege_zombie_ai()
	if (ai_target)
		return "attack"
	if (!ai_target && GLOB.vampgate) //if they're far from the gate, then just wander, they might get there.
		return "go_to_gate"
	else
		return "wander"

/datum/component/graveyard_zombie/proc/shrieker_zombie_ai()
	if (ai_target) //if i gets a target, it will try to avoid them, but stay close, calling other zombies to attack, attacks if cornered
		return "flee_and_rally"
	else
		return "wander"

/datum/component/graveyard_zombie/proc/wanderer_zombie_ai()
	if (ai_target) //sad little zombie that kicks rocks and mopes around the graveyard, meant for backing up skriekers, and populating the graveyard.
		return "attack"
	else
		return "wander"


//
// Graveyard Zombie Shared Behaviors: used mostly for Performing tasks, some are support, some are the tasks themselves.
//
/// Finds the closest valid living target for the zombie to pursue. Only sets the target, the brain decides if it wants to attack, or something else.


/mob/living/simple_animal/hostile/zombie/proc/locate_nearest_attack_target()
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
/mob/living/simple_animal/hostile/zombie/proc/wander_randomly()
	// Chance to initiate grave visiting task
	if(prob(10))
		start_grave_wander()
		return

	// Otherwise, 50% chance to stumble
	if(prob(50))
		var/dir = pick(NORTH, SOUTH, EAST, WEST)
		step(src, dir)

/mob/living/simple_animal/hostile/zombie/proc/start_grave_wander()
	var/datum/component/graveyard_zombie/comp = src.GetComponent(/datum/component/graveyard_zombie)
	if(!comp) return
	if(comp.visiting_grave) return
	var/list/nearby = list()
	for(var/obj/vampgrave/G in SSgraveyard.graves)
		if(get_dist(src, G) <= 20)
			nearby += G
	if(!length(nearby)) return
	var/obj/vampgrave/G = pick(nearby)
	comp.visiting_grave = TRUE
	spawn(0)
		if(get_dist(src, G) <= 1)
			sleep(20) // Already there, just linger
		else
			while(get_dist(src, G) > 1 && !QDELETED(G) && !QDELETED(src))
				step_towards(src, G)
				sleep(5)
		// Linger behavior within a radius
		var/turf/origin = get_turf(src)
		for(var/i = 0, i < rand(4, 8), i++)
			if(QDELETED(src) || QDELETED(G)) break
			var/turf/T = get_turf(src)
			if(get_dist(T, origin) > 2)
				step_to(src, origin)
			else
				var/dir = pick(NORTH, SOUTH, EAST, WEST)
				step(src, dir)
			sleep(rand(10, 20))
		comp.visiting_grave = FALSE


/// Rallies nearby zombies to move toward a target or the vampgate.
/mob/living/simple_animal/hostile/zombie/proc/start_zombie_rally(mob/living/target = null)
	if(!target && GLOB.vampgate)
		target = GLOB.vampgate
	// The initiator lets out a distinct screech to begin the rally
	emote("scream")
	// Rally nearby zombies
	for(var/mob/living/simple_animal/hostile/zombie/Z in view(7, src))
		if(Z == src) continue

		var/datum/component/graveyard_zombie/comp = Z.GetComponent(/datum/component/graveyard_zombie)
		if(!comp || comp.current_task == "attack") continue

		comp.ai_target = target
		comp.current_task = "go_to_gate"

		Z.emote(pick("moans hungrily...", "lets out a rasping groan...", "lurches toward the sound..."))
		step_towards(Z, target)

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

//CHARGE THE GATE.
/mob/living/simple_animal/hostile/zombie/proc/charge_gate()
	if(!GLOB.vampgate || QDELETED(GLOB.vampgate)) return
	var/gate_open = GLOB.vampgate.icon_state == "gate-open"
	if(get_dist(src, GLOB.vampgate) <= 1)
		if(!gate_open)
			UnarmedAttack(GLOB.vampgate) //visual
			GLOB.vampgate.punched() //actually what damages the gates HP, and triggers gate stuff.
		else
			// Loiter near the gate for a bit
			for(var/i = 0, i < rand(4, 8); i++)
				if(QDELETED(src)) break
				var/dir = pick(NORTH, SOUTH, EAST, WEST)
				step(src, dir)
				sleep(rand(5, 10))
	else
		step_towards(src, GLOB.vampgate)
		if(prob(10))
			emote(pick("moans...", "shuffles forward...", "growls lowly..."))

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
