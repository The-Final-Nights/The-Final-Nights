//Solar tracker

//Machine that tracks the sun and reports its direction to the solar controllers
//As long as this is working, solar panels on same powernet will track automatically

/obj/machinery/power/tracker
	name = "solar tracker"
	desc = "A solar directional tracker."
	icon = 'icons/obj/power.dmi'
	icon_state = "smes"
	density = TRUE
	use_power = NO_POWER_USE
	max_integrity = 250
	integrity_failure = 0.2

	var/id = 0
	var/obj/machinery/power/solar_control/control

/obj/machinery/power/tracker/Initialize(mapload, obj/item/solar_assembly/S)
	. = ..()
	Make(S)
	connect_to_network()
	RegisterSignal(SSsun, COMSIG_SUN_MOVED, PROC_REF(sun_update))

/obj/machinery/power/tracker/Destroy()
	unset_control() //remove from control computer
	return ..()

/obj/machinery/power/tracker/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	. = ..()
	if(same_z_layer)
		return
	SET_PLANE(tracker_dish_edge, PLANE_TO_TRUE(tracker_dish_edge.plane), new_turf)
	SET_PLANE(tracker_dish, PLANE_TO_TRUE(tracker_dish.plane), new_turf)

/obj/machinery/power/tracker/proc/add_panel_overlay(icon_state, y_offset)
	var/obj/effect/overlay/overlay = new()
	overlay.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_ICON
	overlay.appearance_flags = TILE_BOUND
	overlay.icon_state = icon_state
	overlay.layer = FLY_LAYER
	SET_PLANE_EXPLICIT(overlay, ABOVE_GAME_PLANE, src)
	overlay.pixel_y = y_offset
	vis_contents += overlay
	return overlay

/obj/machinery/power/tracker/proc/set_control(obj/machinery/power/solar_control/SC)
	unset_control()
	control = SC
	SC.connected_tracker = src

//set the control of the tracker to null and removes it from the previous control computer if needed
/obj/machinery/power/tracker/proc/unset_control()
	if(control)
		if(control.track == SOLAR_TRACK_AUTO)
			control.track = SOLAR_TRACK_OFF
		control.connected_tracker = null
		control = null

///Tell the controller to turn the solar panels
/obj/machinery/power/tracker/proc/sun_update(datum/source, azimuth)
	SIGNAL_HANDLER

	setDir(angle2dir(azimuth))
	if(control && control.track == SOLAR_TRACK_AUTO)
		control.set_panels(azimuth)

/obj/machinery/power/tracker/proc/Make(obj/item/solar_assembly/S)
	if(!S)
		S = new /obj/item/solar_assembly(src)
		S.glass_type = /obj/item/stack/sheet/glass
		S.tracker = 1
		S.set_anchored(TRUE)
	S.forceMove(src)

/obj/machinery/power/tracker/crowbar_act(mob/user, obj/item/I)
	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	user.visible_message("<span class='notice'>[user] begins to take the glass off [src].</span>", "<span class='notice'>You begin to take the glass off [src]...</span>")
	if(I.use_tool(src, user, 50))
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
		user.visible_message("<span class='notice'>[user] takes the glass off [src].</span>", "<span class='notice'>You take the glass off [src].</span>")
		deconstruct(TRUE)
	return TRUE

/obj/machinery/power/tracker/obj_break(damage_flag)
	. = ..()
	if(.)
		playsound(loc, 'sound/effects/glassbr3.ogg', 100, TRUE)
		unset_control()

/obj/machinery/power/tracker/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			var/obj/item/solar_assembly/S = locate() in src
			if(S)
				S.forceMove(loc)
				S.give_glass(machine_stat & BROKEN)
		else
			playsound(src, "shatter", 70, TRUE)
			new /obj/item/shard(src.loc)
			new /obj/item/shard(src.loc)
	qdel(src)

// Tracker Electronic

/obj/item/electronics/tracker
	name = "tracker electronics"
