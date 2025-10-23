// The spirit chime item itself
/obj/item/spirit_chime
	name = "Chime of Unseen Spirits"
	desc = "A mystical chime that reacts to nearby spirits."
	icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
	icon_state = "bell"
	anchored = FALSE
	var/isplaced = FALSE
	var/datum/proximity_monitor/advanced/spirit_chime/chime_field
	var/ringing = FALSE
	var/range = 10
	COOLDOWN_DECLARE(ring_cooldown)

/obj/item/spirit_chime/attackby(obj/item/W, mob/user)
	return ..()

// Picking the chime back up
/obj/item/spirit_chime/attack_hand(mob/user)
	if(!anchored)
		return ..()
	if(!do_after(user, 2 SECONDS, target = src))
		return
	user.visible_message(span_notice("[user] retrieves the chime."))
	anchored = FALSE
	user.put_in_active_hand(src)
	isplaced = FALSE

// Handles table placement (a bit awkwardly but wcyd)
/obj/item/spirit_chime/dropped(mob/user)
	. = ..()
	var/obj/structure/table/table = locate(/obj/structure/table) in get_turf(src)
	if(table && !anchored)
		if(!do_after(user, 2 SECONDS))
			return

		anchored = TRUE
		icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
		icon_state = "bell"
		isplaced = TRUE
		user.visible_message(span_notice("[user] places the bell on the table."))
		initial_check()

/obj/item/spirit_chime/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return

	// Handles wall placement
	if(istype(target, /turf/closed/wall))
		var/turf/T = target
		if(!do_after(user, 2 SECONDS))
			return

		var/obj/item/spirit_chime/placed_chime = new /obj/item/spirit_chime(T)
		placed_chime.anchored = TRUE
		placed_chime.icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
		placed_chime.icon_state = "chime"

		// Grabs click parameters for placement. Totally unnecessary, but I thought it was nice.
		var/list/params = params2list(click_parameters)
		if(params["icon-x"] && params["icon-y"])
			var/click_x = text2num(params["icon-x"])
			var/click_y = text2num(params["icon-y"])
			placed_chime.pixel_x = click_x - 16
			placed_chime.pixel_y = click_y - 30

		user.visible_message(span_notice("[user] hangs the chime on the wall."))
		placed_chime.isplaced = TRUE
		qdel(src)
		return

	// Handles floor placement
	if(isturf(target))
		var/turf/T = target
		if(!do_after(user, 2 SECONDS))
			return

		var/obj/item/spirit_chime/placed_chime = new /obj/item/spirit_chime(T)
		placed_chime.anchored = TRUE
		placed_chime.icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
		placed_chime.icon_state = "bell"

		// Grabs click parameters for placement. Totally unnecessary, but I thought it was nice.
		var/list/params = params2list(click_parameters)
		if(params["icon-x"] && params["icon-y"])
			var/click_x = text2num(params["icon-x"])
			var/click_y = text2num(params["icon-y"])
			placed_chime.pixel_x = click_x - 16
			placed_chime.pixel_y = click_y - 16

		user.visible_message(span_notice("[user] places the bell on the floor."))
		placed_chime.isplaced = TRUE
		qdel(src)
		return

/obj/item/spirit_chime/Initialize()
	. = ..()
	// Sets up a field with a range of 10
	chime_field = new /datum/proximity_monitor/advanced/spirit_chime(src, range)
	chime_field.recalculate_field(full_recalc = TRUE)
	if(!ringing)
		initial_check()

/obj/item/spirit_chime/Destroy()
	ringing = FALSE
	QDEL_NULL(chime_field)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/spirit_chime/process(delta_time)
	var/valid_targets = FALSE
	if(!ringing || !isplaced || !chime_field)
		ringing = FALSE
		STOP_PROCESSING(SSprocessing, src)
		return
	for(var/mob/dead/observer/ghost in chime_field.tracked_mobs) // Check if there are still valid targets
		if(valid_target(ghost))
			valid_targets = TRUE
			break
	for(var/mob/dead/observer/ghost in chime_field.tracked_mobs)
		if(ghost.z != z || !valid_target(ghost) || get_dist(get_turf(src), get_turf(ghost)) > chime_field.current_range) // Check for invalid targets & out of range
			chime_field.tracked_mobs -= ghost
	if(!valid_targets) // End if no valid targets
		ringing = FALSE
		chime_field.tracked_mobs.Cut()
		STOP_PROCESSING(SSprocessing, src)
		return
	if(COOLDOWN_FINISHED(src, ring_cooldown))
		ring()
		COOLDOWN_START(src, ring_cooldown, 5 SECONDS)

// The proimity monitor that creates the detection field
/datum/proximity_monitor/advanced/spirit_chime
	edge_is_a_field = TRUE
	var/list/tracked_mobs = list()
	var/obj/item/spirit_chime/chime

/datum/proximity_monitor/advanced/spirit_chime/New(host, range)
	. = ..()
	chime = host

/datum/proximity_monitor/advanced/spirit_chime/field_turf_crossed(atom/movable/entered, turf/old_location, turf/new_location) // Handles when a mob enters the field
	. = ..()
	if(!chime.isplaced)
		return
	if(entered.z != chime.z)
		return
	if(valid_target(entered))
		if(!(entered in tracked_mobs))
			tracked_mobs |= entered
			if(tracked_mobs.len == 1) // Starts ringing on the first target, continues until there are no more targets
				chime.start_ringing()
			else if(tracked_mobs.len < 1)
				chime.stop_ringing()
	if(!valid_target(entered))
		if(entered.orbiters)
			for(var/mob/dead/observer/ghost in entered.get_all_orbiters()) // Check for orbiting ghosts in the field
				if(valid_target(ghost))
					if(!(ghost in tracked_mobs))
						tracked_mobs |= ghost
						if(tracked_mobs.len == 1)
							chime.start_ringing()
						else if(tracked_mobs.len < 1)
							chime.stop_ringing()

/datum/proximity_monitor/advanced/spirit_chime/field_turf_uncrossed(atom/movable/gone, turf/old_location, turf/new_location) // Handles when a mob leaves the field
	. = ..()
	if(!chime.isplaced)
		return
	if(gone in tracked_mobs)
		tracked_mobs -= gone
	if(gone.z != chime.z || !valid_target(gone))
		if(gone in tracked_mobs)
			tracked_mobs -= gone
	if(gone.orbiters)
		for(var/mob/dead/observer/ghost in gone.get_all_orbiters())
			if(ghost in tracked_mobs)
				tracked_mobs -= ghost

// Procs
/obj/item/spirit_chime/proc/start_ringing()
	if(ringing || !isplaced || !chime_field)
		return
	ringing = TRUE
	COOLDOWN_START(src, ring_cooldown, 0 SECONDS)
	START_PROCESSING(SSprocessing, src)

/obj/item/spirit_chime/proc/stop_ringing()
	ringing = FALSE
	STOP_PROCESSING(SSprocessing, src)

/obj/item/spirit_chime/proc/ring()
	playsound(src, 'modular_tfn/modules/spirit_chime/sound/spirit_chime_ring.ogg', 25, FALSE)
	visible_message(span_notice("The chime rings out!"), vision_distance = range)

/obj/item/spirit_chime/proc/initial_check()
	for(var/mob/M in range(range, src))
		if(valid_target(M) && !(M in chime_field.tracked_mobs))
			chime_field.tracked_mobs |= M
		if(chime_field.tracked_mobs.len > 0 && !ringing)
			ringing = TRUE
			COOLDOWN_START(src, ring_cooldown, 0 SECONDS)
			START_PROCESSING(SSprocessing, src)

/proc/valid_target(atom/movable/target)
	if(istype(target, /mob/dead/observer))
		var/mob/dead/observer/ghost = target
		if((ghost.mind && !ghost.aghosted) || isavatar(ghost)) // Checks only for ghosts of the dead & Auspex 5 avatars
			return TRUE
		if(ghost.mind && ghost.orbiting) // Checks for orbiting ghosts
			return TRUE
	return FALSE
