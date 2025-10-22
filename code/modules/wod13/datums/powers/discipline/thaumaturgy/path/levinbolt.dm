/datum/discipline/path/levinbolt
	name = "Path of the Levinbolt"
	desc = "A rudimentary path of Thaumaturgy that allows the manipulation of lightning. Violates Masquerade."
	icon_state = "levinbolt"
	power_type = /datum/discipline_power/thaumaturgy/path/levinbolt

/datum/discipline_power/thaumaturgy/path/levinbolt
	name = "Path of the Levinbolt Power Name"
	desc = "Path of the Levinbolt Power Description"

	effect_sound = 'sound/magic/lightningbolt.ogg'


// levinbolt allows for the user to click on certain electronics, disabling them, like radios while people are still wearing them, warehouse computer, fuseboxes.
/datum/discipline_power/thaumaturgy/path/levinbolt/proc/levinbolt_target_click(mob/source, atom/target, params, include_radio_effects = FALSE)
	if(!active || !toggled)
		return

	if(!target || get_dist(owner, target) > 1)
		return

	// disable radios, only used in levinbolt 3 and 5
	if(include_radio_effects && ishuman(target))
		var/mob/living/carbon/human/H = target
		var/disabled_any = FALSE
		for(var/obj/item/I in H.get_all_slots())
			if(istype(I, /obj/item/p25radio))
				var/obj/item/p25radio/radio = I
				if(radio.powered)
					radio.powered = FALSE
					H.visible_message(
						span_warning("[H]'s [I.name] crackles violently and powers down!"),
						span_warning("Your [I.name] crackles violently and powers down!"),
					)
					playsound(H, 'sound/effects/sparks4.ogg', 60, TRUE)
					disabled_any = TRUE
				else
					radio.powered = TRUE
					H.visible_message(
						span_warning("Electricity surges into [H]'s [I.name] - turning it on!"),
						span_warning("Electricity surges into your radio - turning it on!"),
					)
					playsound(H, 'sound/effects/sparks4.ogg', 60, TRUE)
					disabled_any = TRUE
		if(disabled_any)
			var/datum/effect_system/spark_spread/spark_system = new
			spark_system.set_up(5, 1, get_turf(H))
			spark_system.start()
			return TRUE

	// Warehouse computer 'hacking'
	if(istype(target, /obj/machinery/computer/cargo/express))
		var/obj/machinery/computer/cargo/express/cargo_comp = target
		cargo_comp.locked = !cargo_comp.locked

		// sparks
		var/datum/effect_system/spark_spread/spark_system = new
		spark_system.set_up(3, 1, get_turf(target))
		spark_system.start()
		playsound(target, 'sound/effects/sparks4.ogg', 50, TRUE)

		owner.visible_message(span_warning("[owner] sends sparks of electricity into [target]!"))
		return TRUE

	// Fusebox short-circuiting
	if(istype(target, /obj/fusebox))
		var/obj/fusebox/fuse = target

		// Break the fusebox
		fuse.damaged += 101
		fuse.check_damage(owner, TRUE)

		var/datum/effect_system/spark_spread/spark_system = new
		spark_system.set_up(5, 1, get_turf(target))
		spark_system.start()
		playsound(target, 'sound/effects/sparks2.ogg', 75, TRUE)

		owner.visible_message(span_warning("[owner] sends a surge of electricity into [target]!"))

		// Small chance to electrocute the user too
		if(prob(15))
			owner.electrocute_act(10, target, siemens_coeff = 1, flags = NONE)
			to_chat(owner, span_warning("Some of the electrical feedback hits you!"))

		return TRUE

	return FALSE

//SPARK - Level 1
/datum/discipline_power/thaumaturgy/path/levinbolt/one
	name = "Spark"
	desc = "Generate a small electrical discharge upon being struck, or target objects to disrupt their electronics."

	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_CONSCIOUS
	violates_masquerade = TRUE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/path/levinbolt/three,
		/datum/discipline_power/thaumaturgy/path/levinbolt/five
	)
	// storing original light values to control mobs lighting when theyre charged by electricity (dots one, three and five)
	var/original_light_range = 0
	var/original_light_power = 0
	var/original_light_color = null
	var/original_light_on = FALSE
	var/static/mutable_appearance/electricity

/datum/discipline_power/thaumaturgy/path/levinbolt/one/activate()
	. = ..()
	if(!.)

		//signal for counterattack
		RegisterSignal(owner, COMSIG_ATOM_ATTACKBY, PROC_REF(spark_counter))

		//signal for disabling electronics
		RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(spark_target_click))

		electricity = electricity || mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
		owner.add_overlay(electricity)

		// Set up overlay lighting component for electric glow
		owner.light_system = MOVABLE_LIGHT
		owner.AddComponent(/datum/component/overlay_lighting, 2, 1, "#f1fdfd", TRUE)
		to_chat(owner, span_notice("Small sparks of electricity begin crackling around you! Youn can now disable certain electrical systems with just a touch - and attackers will sometimes feel a slight shock."))

/datum/discipline_power/thaumaturgy/path/levinbolt/one/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_ATOM_ATTACKBY)
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	owner.cut_overlay(electricity)
	// Remove the lighting component
	var/datum/component/overlay_lighting/light_comp = owner.GetComponent(/datum/component/overlay_lighting)
	if(light_comp)
		qdel(light_comp)

	// Reset light system
	owner.light_system = initial(owner.light_system)
	to_chat(owner, span_notice("The electricity around you fades away."))

/datum/discipline_power/thaumaturgy/path/levinbolt/one/proc/spark_counter(mob/source, obj/item/weapon, mob/living/attacker)
	SIGNAL_HANDLER

	if(prob(30))
		attacker.Jitter(2)
		if(ishuman(attacker))
			var/mob/living/carbon/human/H = attacker
			H.electrocution_animation(40)
		attacker.Stun(1 SECONDS)

/datum/discipline_power/thaumaturgy/path/levinbolt/one/proc/spark_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	return levinbolt_target_click(source, target, params, FALSE)

//ILLUMINATE - Level 2
/datum/discipline_power/thaumaturgy/path/levinbolt/two
	name = "Illuminate"
	desc = "Surge a moderate amount of energy into your hand."
	level = 2
	violates_masquerade = TRUE
	toggled = TRUE
	duration_length = 2 TURNS

	var/list/conjured_illuminates = list()

/datum/discipline_power/thaumaturgy/path/levinbolt/two/activate(mob/living/target)
	. = ..()
	if(!.)
		owner.drop_all_held_items()

		var/right_illuminate = new /obj/item/lighter/conjured/levinbolt_arm(owner)
		var/left_illuminate = new /obj/item/lighter/conjured/levinbolt_arm(owner)

		owner.put_in_r_hand(right_illuminate)
		owner.put_in_l_hand(left_illuminate)

		conjured_illuminates += WEAKREF(right_illuminate)
		conjured_illuminates += WEAKREF(left_illuminate)

/datum/discipline_power/thaumaturgy/path/levinbolt/two/deactivate()
	. = ..()
	for(var/datum/weakref/illuminate_ref in conjured_illuminates)
		var/obj/item/lighter/conjured/levinbolt_arm/illuminate = illuminate_ref.resolve()
		if(illuminate)
			qdel(illuminate)
	conjured_illuminates.Cut()

//POWER ARRAY - Level 3
/datum/discipline_power/thaumaturgy/path/levinbolt/three
	name = "Power Array"
	desc = "Discharge a greater amount of energy around yourself."

	level = 3
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_CONSCIOUS
	violates_masquerade = TRUE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/path/levinbolt/one,
		/datum/discipline_power/thaumaturgy/path/levinbolt/five
	)
	// storing original light values to control mobs lighting when theyre charged by electricity (dots one, three and five)
	var/original_light_range = 0
	var/original_light_power = 0
	var/original_light_color = null
	var/original_light_on = FALSE
	var/static/mutable_appearance/electricity2


/datum/discipline_power/thaumaturgy/path/levinbolt/three/activate()
	. = ..()
	if(!.)

		//proc for counterattack
		RegisterSignal(owner, COMSIG_ATOM_ATTACKBY, PROC_REF(power_array_counter))

		//proc for clicking on objects to disable electronics
		RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(powerarray_target_click))

		electricity2 = electricity2 || mutable_appearance('icons/effects/effects.dmi', "electricity2", EFFECTS_LAYER)
		owner.add_overlay(electricity2)
		owner.light_system = MOVABLE_LIGHT
		owner.AddComponent(/datum/component/overlay_lighting, 3, 2, "#e9ffff", TRUE)
		to_chat(owner, span_notice("Intense electricity surges around your entire body!"))


/datum/discipline_power/thaumaturgy/path/levinbolt/three/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_ATOM_ATTACKBY)
	owner.cut_overlay(electricity2)
	var/datum/component/overlay_lighting/light_comp = owner.GetComponent(/datum/component/overlay_lighting)
	if(light_comp)
		qdel(light_comp)

	owner.light_system = initial(owner.light_system)
	to_chat(owner, span_notice("The electricity around your body dissipates."))

/datum/discipline_power/thaumaturgy/path/levinbolt/three/proc/power_array_counter(mob/source, obj/item/weapon, mob/living/attacker)
	SIGNAL_HANDLER

	if(prob(30))
		addtimer(CALLBACK(attacker, TYPE_PROC_REF(/mob, emote), "scream"), 1)
		if(ishuman(attacker))
			var/mob/living/carbon/human/H = attacker
			H.electrocution_animation(40)
		attacker.Jitter(2)
		attacker.Stun(3 SECONDS)
		attacker.adjustFireLoss(30)

/datum/discipline_power/thaumaturgy/path/levinbolt/three/proc/powerarray_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	return levinbolt_target_click(source, target, params, TRUE)


//ZEUS' FURY - Level 4 - Enhanced with Chain Lightning
/datum/discipline_power/thaumaturgy/path/levinbolt/four
	name = "Zeus' Fury"
	desc = "Build up energy and direct it as arcs of lightning that chain between targets."

	level = 4
	cooldown_length = 30 SECONDS
	violates_masquerade = TRUE
	target_type = TARGET_LIVING
	range = 7

	var/static/mutable_appearance/electric_halo

/datum/discipline_power/thaumaturgy/path/levinbolt/four/activate(mob/living/target)
	. = ..()
	if(!.)
		if(!target)
			to_chat(owner, span_warning("You need a target to direct your fury at!"))
			return

		if(get_dist(owner, target) > range)
			to_chat(owner, span_warning("[target.p_theyre(TRUE)] is too far away!"))
			return

		// Start the charging process
		owner.visible_message(span_danger("[owner.name] crackles with building electrical energy!"),
			span_danger("You begin channeling Zeus' fury, electricity arcing around your body!"))

		// Add visual effects during charge
		electric_halo = electric_halo || mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
		owner.add_overlay(electric_halo)

		// Allow movement during charge but require 3 seconds focus
		if(do_after(owner, 3 SECONDS, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_HELD_ITEM)))
			if(get_dist(owner, target) <= range)
				execute_zeus_fury(target)
			else
				cancel_fury("Target moved out of range.")
		else
			cancel_fury("Channeling interrupted.")

/datum/discipline_power/thaumaturgy/path/levinbolt/four/proc/execute_zeus_fury(mob/living/primary_target)
	owner.cut_overlay(electric_halo)

	var/max_bounces = success_count // Lightning chain dependent upon successes - two successes, two targets hit
	var/bolt_damage = 20 + (success_count * 4) // Base 20 + 4 per success

	switch(success_count)
		if(1)
			owner.visible_message(span_danger("[owner.name] releases a crackling bolt of lightning!"),
				span_danger("You release a modest arc of electrical energy!"))
		if(2 to 3)
			owner.visible_message(span_bolddanger("[owner.name] unleashes a powerful chain of lightning!"),
				span_bolddanger("You channel Zeus' power, lightning arcing between targets!"))
		if(4 to 5)
			owner.visible_message(span_reallybig(span_bolddanger("[owner.name] commands the very storm itself!")),
				span_reallybig(span_bolddanger("You become a conduit for divine wrath!")))
		else // 6+ successes
			owner.visible_message(span_reallybig(span_bolddanger("The air itself SCREAMS as [owner.name] becomes lightning incarnate!")),
				span_reallybig(span_bolddanger("UNLIMITED POWER courses through your being!")))

	playsound(get_turf(owner), 'sound/magic/lightningbolt.ogg', min(50 + (success_count * 10), 100), TRUE, extrarange = success_count)

	// bolt of lightning to the first target
	owner.Beam(primary_target, icon_state="lightning[rand(1,12)]", time = (5 + success_count))

	// Starts the chain lightning with bolt_damage as the bolt energy
	chain_bolt(owner, primary_target, bolt_damage, max_bounces, list(owner))

// Proced each time a lightning bolt is sent
/datum/discipline_power/thaumaturgy/path/levinbolt/four/proc/chain_bolt(atom/origin, mob/living/current_target, bolt_energy, bounces_left, list/already_hit)
	current_target.electrocute_act(bolt_energy, "Zeus' Fury", flags = SHOCK_NOGLOVES)
	playsound(get_turf(current_target), 'sound/magic/lightningshock.ogg', 60, TRUE)

	// Animation for being struck
	current_target.Jitter(20 + (success_count * 5))
	if(ishuman(current_target))
		var/mob/living/carbon/human/H = current_target
		H.electrocution_animation(40 + (success_count * 10))

	// Better chance to stun with more successes
	var/stun_chance = min(30 + (success_count * 15), 85)
	if(bolt_energy >= 20 && prob(stun_chance))
		var/stun_duration = (success_count) SECONDS
		current_target.Paralyze(stun_duration)
		current_target.visible_message(span_warning("[current_target] convulses violently from the electrical shock!"))

	// No duplicating targets
	already_hit += current_target

	// Count the bounces
	if(bounces_left <= 0)
		return

	// Find next target
	var/list/possible_targets = list()
	for(var/mob/living/L in view(range, current_target))
		if(L in already_hit)
			continue
		possible_targets += L

	if(!possible_targets.len)
		return // No more valid targets

	// Pick closest target for more realistic chain lightning
	var/mob/living/next_target = null
	var/shortest_distance = INFINITY //compares distance between potential targets relative to infinity, but list is limited by view of the current victim
	for(var/mob/living/potential in possible_targets)
		var/distance = get_dist(current_target, potential)
		if(distance < shortest_distance)
			shortest_distance = distance
			next_target = potential

	if(next_target)
		var/chain_delay = max(5 - success_count, 1) // slight delay for coolness
		addtimer(CALLBACK(src, PROC_REF(continue_chain), current_target, next_target, bolt_energy, bounces_left, already_hit), chain_delay)

//reduces damage and bounces_left for each subsequent bolt
/datum/discipline_power/thaumaturgy/path/levinbolt/four/proc/continue_chain(atom/origin, mob/living/next_target, bolt_energy, bounces_left, list/already_hit)
	origin.Beam(next_target, icon_state="lightning[rand(1,12)]", time = (5 + success_count))
	// With more successes, damage loss per bounce is reduced
	var/energy_retention = 0.8 + (success_count * 0.05) // 80% base, up to 100% with 5 successes
	var/reduced_energy = max(bolt_energy * energy_retention, 10) // Minimum 10 damage

	// Continue the chain, applying reduced damage and bounces, while retaining the already_hit list
	chain_bolt(origin, next_target, reduced_energy, bounces_left - 1, already_hit)

/datum/discipline_power/thaumaturgy/path/levinbolt/four/proc/cancel_fury(reason)
	if(electric_halo)
		owner.cut_overlay(electric_halo)

	to_chat(owner, span_warning("Zeus' Fury fizzles out. [reason]"))

//EYE OF THE STORM - Level 5
/datum/discipline_power/thaumaturgy/path/levinbolt/five
	name = "Eye of the Storm"
	desc = "Become charged with an incredible amount of energy."

	level = 5
	violates_masquerade = TRUE
	toggled = TRUE
	duration_length = 1 TURNS
	vitae_cost = 2
	cooldown_length = 30 SECONDS

	var/lightning_timer
	var/spark_timer
	var/static/mutable_appearance/electricity3
	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/path/levinbolt/one,
		/datum/discipline_power/thaumaturgy/path/levinbolt/three
	)


/datum/discipline_power/thaumaturgy/path/levinbolt/five/activate(atom/target)
	. = ..()
	if(!.)
		electricity3 = electricity3 || mutable_appearance('icons/effects/effects.dmi', "electricity2", EFFECTS_LAYER)
		owner.add_overlay(electricity3)
		owner.light_system = MOVABLE_LIGHT
		owner.AddComponent(/datum/component/overlay_lighting, 5, 4, "#e9ffff", TRUE)

		//signal for clicking electronics to disable them
		RegisterSignal(owner, COMSIG_CLICK, PROC_REF(storm_target_click))

		//signal for counterattack from being struck
		RegisterSignal(owner, COMSIG_ATOM_ATTACKBY, PROC_REF(storm_counter))

		//create sparks every few seconds for coolness
		spark_timer = addtimer(CALLBACK(src, PROC_REF(create_sparks)), 2 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)

		//fire lightning bolt at a random nearby mob
		lightning_timer = addtimer(CALLBACK(src, PROC_REF(fire_lightning_bolt)), 5 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
		owner.visible_message(span_danger("[owner] becomes surrounded by crackling electrical energy!"))
		to_chat(owner, span_notice("You feel incredible electrical power coursing through your body!"))
		playsound(owner, 'sound/effects/sparks4.ogg', 75, TRUE)

/datum/discipline_power/thaumaturgy/path/levinbolt/five/proc/create_sparks()
	if(!owner)
		return

	var/datum/effect_system/spark_spread/spark_system = new
	spark_system.set_up(rand(3,7), 1, get_turf(owner))
	spark_system.start()

	if(prob(50))
		playsound(owner, pick('sound/effects/sparks1.ogg', 'sound/effects/sparks2.ogg', 'sound/effects/sparks3.ogg', 'sound/effects/sparks4.ogg'), 40, TRUE)

/datum/discipline_power/thaumaturgy/path/levinbolt/five/proc/fire_lightning_bolt()
	if(!owner)
		return

	var/list/potential_targets = list()
	for(var/mob/living/L in range(7, owner))
		if(L != owner && L.stat != DEAD)
			potential_targets += L

	if(!length(potential_targets))
		return

	var/mob/living/target = pick(potential_targets)

	owner.Beam(target, icon_state="lightning[rand(1,12)]", time = 10)

	target.adjustFireLoss(20)
	target.Jitter(25)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.electrocution_animation(50)

	if(prob(60))
		target.Stun(1 SECONDS)
		target.visible_message(span_warning("[target] convulses from the electrical shock!"))

	var/datum/effect_system/spark_spread/spark_system = new
	spark_system.set_up(8, 1, get_turf(target))
	spark_system.start()

	owner.visible_message(span_danger("Lightning arcs from [owner] to [target]!"))
	playsound(target, 'sound/magic/lightningshock.ogg', 75, TRUE)

/datum/discipline_power/thaumaturgy/path/levinbolt/five/proc/storm_counter(mob/source, obj/item/weapon, mob/living/attacker)
	SIGNAL_HANDLER

	if(prob(60))
		attacker.Jitter(3)
		if(ishuman(attacker))
			var/mob/living/carbon/human/H = attacker
			H.electrocution_animation(60)
		addtimer(CALLBACK(attacker, TYPE_PROC_REF(/mob, emote), "scream"), 1)
		attacker.Stun(4 SECONDS)
		attacker.electrocute_act(rand(10,20), owner, siemens_coeff = 1, flags = NONE)
		var/datum/effect_system/spark_spread/spark_system = new
		spark_system.set_up(5, 1, get_turf(attacker))
		spark_system.start()
		playsound(attacker, 'sound/effects/sparks4.ogg', 60, TRUE)

/datum/discipline_power/thaumaturgy/path/levinbolt/five/proc/storm_target_click(mob/source, atom/target, params)
	SIGNAL_HANDLER

	return levinbolt_target_click(source, target, params, TRUE)

/datum/discipline_power/thaumaturgy/path/levinbolt/five/deactivate()
	if(!owner)
		return

	UnregisterSignal(owner, list(COMSIG_CLICK, COMSIG_ATOM_ATTACKBY))

	// Stop timers
	if(spark_timer)
		deltimer(spark_timer)
		spark_timer = null
	if(lightning_timer)
		deltimer(lightning_timer)
		lightning_timer = null

	owner.visible_message(span_notice("The electrical energy around [owner] dissipates."))
	to_chat(owner, span_notice("The storm within you calms."))
	owner.cut_overlay(electricity3)
	var/datum/component/overlay_lighting/light_comp = owner.GetComponent(/datum/component/overlay_lighting)
	if(light_comp)
		qdel(light_comp)
	QDEL_NULL(electricity3)
	. = ..()

/datum/discipline_power/thaumaturgy/path/levinbolt/five/Destroy()
	if(spark_timer)
		deltimer(spark_timer)
	if(lightning_timer)
		deltimer(lightning_timer)
	if(electricity3)
		QDEL_NULL(electricity3)
	. = ..()

