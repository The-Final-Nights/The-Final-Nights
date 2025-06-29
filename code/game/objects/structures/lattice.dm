/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice. These hold our station together."
	icon = 'icons/obj/smooth_structures/lattice.dmi'
	icon_state = "lattice-255"
	base_icon_state = "lattice"
	density = FALSE
	anchored = TRUE
	armor = list(MELEE = 50, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 50)
	max_integrity = 50
	layer = LATTICE_LAYER //under pipes
	plane = FLOOR_PLANE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_LATTICE)
	canSmoothWith = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_WALLS)
	var/number_of_mats = 1
	var/build_material = /obj/item/stack/rods

/obj/structure/lattice/pentex
	desc = "Looks sturdy enough and made of advanced materials."
	icon = 'code/modules/wod13/pentexcatwalk.dmi'

/obj/structure/lattice/grate
	name = "grate"
	desc = "A metal grate, who knows what kind of sewer clowns might dwell underneath it?"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "lattice_grate"
	base_icon_state = "lattice_grate"
	density = FALSE
	anchored = TRUE
	armor = list(MELEE = 50, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 50)
	max_integrity = 50
	layer = LATTICE_LAYER //under pipes
	plane = FLOOR_PLANE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	smoothing_flags = null
	smoothing_groups = null
	canSmoothWith = null

/obj/structure/lattice/examine(mob/user)
	. = ..()
	. += deconstruction_hints(user)

/obj/structure/lattice/proc/deconstruction_hints(mob/user)
	return "<span class='notice'>The rods look like they could be <b>cut</b>. There's space for more <i>rods</i> or a <i>tile</i>.</span>"

/obj/structure/lattice/Initialize(mapload)
	. = ..()
	for(var/obj/structure/lattice/LAT in loc)
		if(LAT == src)
			continue
		stack_trace("multiple lattices found in ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

/obj/structure/lattice/blob_act(obj/structure/blob/B)
	return

/obj/structure/lattice/attackby(obj/item/C, mob/user, params)
	if(resistance_flags & INDESTRUCTIBLE)
		return
	if(C.tool_behaviour == TOOL_WIRECUTTER)
		to_chat(user, "<span class='notice'>Slicing [name] joints ...</span>")
		deconstruct()
	else
		var/turf/T = get_turf(src)
		return T.attackby(C, user) //hand this off to the turf instead (for building plating, catwalks, etc)

/obj/structure/lattice/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new build_material(get_turf(src), number_of_mats)
	qdel(src)

/obj/structure/lattice/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(the_rcd.mode == RCD_FLOORWALL)
		return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 2)

/obj/structure/lattice/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	if(passed_mode == RCD_FLOORWALL)
		to_chat(user, "<span class='notice'>You build a floor.</span>")
		var/turf/T = src.loc
		if(isspaceturf(T))
			T.PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/lattice/catwalk
	name = "catwalk"
	desc = "A catwalk for easier EVA maneuvering and cable placement."
	icon = 'icons/obj/smooth_structures/catwalk.dmi'
	icon_state = "catwalk-0"
	base_icon_state = "catwalk"
	number_of_mats = 2
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_CATWALK, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_CATWALK)
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

	// storing original turf sounds so that catwalks may make appropriate noises
	var/original_footstep
	var/original_barefootstep
	var/original_clawfootstep
	var/original_heavyfootstep

/obj/structure/lattice/catwalk/Initialize(mapload)
	. = ..() //uses parent initialize
	if(. == INITIALIZE_HINT_QDEL) // if parent initialize wants to delete this catwalk dont modify the turf underneath
		return

	var/turf/T = get_turf(src)
	if(T)
		// Store original sounds if they exist
		if("footstep" in T.vars)
			original_footstep = T.vars["footstep"]
		if("barefootstep" in T.vars)
			original_barefootstep = T.vars["barefootstep"]
		if("clawfootstep" in T.vars)
			original_clawfootstep = T.vars["clawfootstep"]
		if("heavyfootstep" in T.vars)
			original_heavyfootstep = T.vars["heavyfootstep"]

		// Set catwalk sounds if possible
		if("footstep" in T.vars)
			T.vars["footstep"] = FOOTSTEP_PLATING
		if("barefootstep" in T.vars)
			T.vars["barefootstep"] = FOOTSTEP_HARD_BAREFOOT
		if("clawfootstep" in T.vars)
			T.vars["clawfootstep"] = FOOTSTEP_HARD_CLAW
		if("heavyfootstep" in T.vars)
			T.vars["heavyfootstep"] = FOOTSTEP_GENERIC_HEAVY

/obj/structure/lattice/catwalk/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		// Restore original sounds
		if("footstep" in T.vars)
			T.vars["footstep"] = original_footstep
		if("barefootstep" in T.vars)
			T.vars["barefootstep"] = original_barefootstep
		if("clawfootstep" in T.vars)
			T.vars["clawfootstep"] = original_clawfootstep
		if("heavyfootstep" in T.vars)
			T.vars["heavyfootstep"] = original_heavyfootstep
	. = ..() // Call parent Destroy

/obj/structure/lattice/catwalk/deconstruction_hints(mob/user)
	return "<span class='notice'>The supporting rods look like they could be <b>cut</b>.</span>"

/obj/structure/lattice/catwalk/Move()
	var/turf/T = loc
	for(var/obj/structure/cable/C in T)
		C.deconstruct()
	..()

/obj/structure/lattice/catwalk/deconstruct()
	var/turf/T = loc
	for(var/obj/structure/cable/C in T)
		C.deconstruct()
	..()

/obj/structure/lattice/lava
	name = "heatproof support lattice"
	desc = "A specialized support beam for building across lava. Watch your step."
	icon = 'icons/obj/smooth_structures/catwalk.dmi'
	icon_state = "catwalk-0"
	base_icon_state = "catwalk"
	number_of_mats = 1
	color = "#5286b9ff"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_LATTICE, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_LATTICE)
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/obj/structure/lattice/lava/deconstruction_hints(mob/user)
	return "<span class='notice'>The rods look like they could be <b>cut</b>, but the <i>heat treatment will shatter off</i>. There's space for a <i>tile</i>.</span>"

/obj/structure/lattice/lava/attackby(obj/item/C, mob/user, params)
	. = ..()
	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/item/stack/tile/plasteel/P = C
		if(P.use(1))
			to_chat(user, "<span class='notice'>You construct a floor plating, as lava settles around the rods.</span>")
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
			new /turf/open/floor/plating(locate(x, y, z))
		else
			to_chat(user, "<span class='warning'>You need one floor tile to build atop [src].</span>")
		return
