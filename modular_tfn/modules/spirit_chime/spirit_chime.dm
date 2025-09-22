/obj/item/spirit_chime
	name = "Chime of Unseen Spirits"
	desc = "A mystical chime that reacts to nearby spirits."
	icon = 'modular_tfn/modules/spirit_chime/icons/spirit_chime.dmi'
	icon_state = "bell"
	anchored = FALSE
	var/isplaced = FALSE

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
        pixel_y = 100
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
		placed_chime.pixel_y = -4
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
		user.visible_message(span_notice("[user] places the bell on the floor."))
		placed_chime.isplaced = TRUE
		qdel(src)
		return

/obj/item/spirit_chime/Initialize()
	. = ..()
	spawn(5)
		loop()

/obj/item/spirit_chime/proc/loop()
	while(TRUE)
		if(isplaced)
			area_check()
		sleep(50) // Check every 5 seconds

/obj/item/spirit_chime/proc/area_check()
	var/range = 10
	var/ring = FALSE
	for(var/mob/M in range(range, src))
		if(istype(M, /mob/dead/observer/avatar)) // Auspex check
			ring = TRUE
			break
		if(istype(M, /mob/dead/observer)) // Ghost check
			var/mob/dead/observer/ghost = M
			if(ghost.mind && !ghost.aghosted) // Only ghosts of the dead
				ring = TRUE
				break
	if(ring)
		playsound(src, 'modular_tfn/modules/spirit_chime/sound/spirit_chime_ring.ogg', 50, FALSE)
		visible_message(span_notice("The chime rings out!"))
