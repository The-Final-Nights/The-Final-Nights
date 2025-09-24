/obj/item/spirit_chime
	name = "Chime of Unseen Spirits"
	desc = "A mystical chime that reacts to nearby spirits."
	icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
	icon_state = "bell"
	anchored = FALSE
	var/isplaced = FALSE
	var/datum/proximity_monitor/advanced/spirit_chime/chime_field
	var/ringing = FALSE

/obj/item/spirit_chime/attackby(obj/item/W, mob/user)
	return ..()

// Picking the chime back up
/obj/item/spirit_chime/attack_hand(mob/user)
	if(!anchored)
		return ..()
	if(!do_after(user, 20, target = src))
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
        if(!do_after(user, 20))
            return

        anchored = TRUE
        icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
        icon_state = "bell"
        isplaced = TRUE
        user.visible_message(span_notice("[user] places the bell on the table."))

/obj/item/spirit_chime/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return

	// Handles wall placement
	if(istype(target, /turf/closed/wall))
		var/turf/T = target
		if(!do_after(user, 20))
			return

		var/obj/item/spirit_chime/placed_chime = new /obj/item/spirit_chime(T)
		placed_chime.anchored = TRUE
		placed_chime.icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
		placed_chime.icon_state = "chime"
		//placed_chime.pixel_y = -8

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
		if(!do_after(user, 20))
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
	chime_field = new /datum/proximity_monitor/advanced/spirit_chime(src, 10)
	chime_field.recalculate_field(full_recalc = TRUE)

/obj/item/spirit_chime/Destroy()
	ringing = FALSE
	QDEL_NULL(chime_field)
	return ..()

/datum/proximity_monitor/advanced/spirit_chime
	edge_is_a_field = TRUE
	var/list/tracked_mobs = list()
	var/obj/item/spirit_chime/chime

/datum/proximity_monitor/advanced/spirit_chime/New(host, range)
	. = ..()
	chime = host

/datum/proximity_monitor/advanced/spirit_chime/field_turf_crossed(atom/movable/entered, turf/old_location, turf/new_location)
	. = ..()
	if(!chime.isplaced)
		return
	if(valid_target(entered))
		if(!(entered in tracked_mobs))
			tracked_mobs |= entered
			if(tracked_mobs.len == 1) // Starts the loop on the first target, continues until there are no more targets
				chime.start_ringing()

/datum/proximity_monitor/advanced/spirit_chime/field_turf_uncrossed(atom/movable/gone, turf/old_location, turf/new_location)
	. = ..()
	if(!chime.isplaced)
		return
	if(gone in tracked_mobs)
		tracked_mobs -= gone

/obj/item/spirit_chime/proc/start_ringing()
	if(ringing || !isplaced || !chime_field)
		return
	ringing = TRUE
	ring_loop()

/obj/item/spirit_chime/proc/ring_loop()
	if(!ringing || !isplaced || !chime_field || chime_field.tracked_mobs.len < 1)
		ringing = FALSE
		return
	ring()
	spawn(50) // 5 second delay, adjust as needed
		ring_loop()

/obj/item/spirit_chime/proc/ring()
	playsound(src, 'modular_tfn/modules/spirit_chime/sound/spirit_chime_ring.ogg', 50, FALSE)
	visible_message(span_notice("The chime rings out!"), vision_distance = 10)

/proc/valid_target(atom/movable/target)
	if(istype(target, /mob/dead/observer))
		var/mob/dead/observer/ghost = target
		if(ghost.mind && !ghost.aghosted || isavatar(ghost)) // Checks only for ghosts of the dead & Auspex 5 avatars
			return TRUE
