/obj/fusebox
	name = "fuse box"
	desc = "Power the controlled area with pure electricity."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "fusebox"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	pixel_y = 32

	//If our shit damaged. bool
	var/damaged = FALSE
	//If our shit being repaired. bool
	var/repairing = FALSE
	//If our shit is open/closed. bool
	var/open = FALSE

/obj/fusebox/proc/check_damage(mob/living/user)
	if(damaged > 100 && !open)
		open = TRUE
		icon_state = "fusebox_open"
		var/area/power_area = get_area(src)
		power_area.requires_power = TRUE
		power_area.fire_controled = FALSE
		var/datum/effect_system/spark_spread/local_spark = new /datum/effect_system/spark_spread
		local_spark.set_up(5, 1, get_turf(src))
		local_spark.start()
		for(var/obj/machinery/light/L in power_area)
			L.update(FALSE)
		playsound(loc, 'code/modules/wod13/sounds/explode.ogg', 100, TRUE)
		user?.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)

/obj/fusebox/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER)
		if(repairing)
			return

		repairing = TRUE
		if(do_after(user, 100, src))
			open = FALSE
			icon_state = "fusebox"
			damaged = FALSE
			playsound(get_turf(src),'code/modules/wod13/sounds/fix.ogg', 75, FALSE)
			var/area/A = get_area(src)
			A.requires_power = FALSE
			if(initial(A.fire_controled))
				A.fire_controled = TRUE
			for(var/obj/machinery/light/L in A)
				L.update(FALSE)
		repairing = FALSE
		return

	..()
	if(I.force)
		damaged += I.force
		check_damage(user)

// substations (another type of fusebox)
/obj/transformer
	name = "transformer"
	desc = "Power the controlled area with pure electricity."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "sstation"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = 1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	//If our shit damaged. bool
	var/damaged = FALSE
	//If our shit being repaired. bool
	var/repairing = FALSE
	//If our shit is open/closed. bool
	var/open = FALSE
	var/datum/looping_sound/generator/soundloop

/obj/transformer/Initialize()
	. = ..()
	soundloop = new(list(src), TRUE)

/obj/transformer/proc/check_damage(mob/living/user)
	if(damaged > 100 && !open)
		open = TRUE
		icon_state = "sstation_off"
		var/area/power_area = get_area(src)
		power_area.requires_power = TRUE
		power_area.fire_controled = FALSE
		var/datum/effect_system/spark_spread/local_spark = new /datum/effect_system/spark_spread
		local_spark.set_up(5, 1, get_turf(src))
		local_spark.start()
		for(var/obj/machinery/light/L in power_area)
			L.update(FALSE)
		playsound(loc, 'code/modules/wod13/sounds/explode.ogg', 100, TRUE)
		QDEL_NULL(soundloop)
		user?.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)

/obj/transformer/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER)
		if(repairing)
			return

		repairing = TRUE
		if(do_after(user, 100, src))
			open = FALSE
			icon_state = "sstation"
			damaged = FALSE
			playsound(get_turf(src),'code/modules/wod13/sounds/fix.ogg', 75, FALSE)
			var/area/power_area = get_area(src)
			power_area.requires_power = FALSE
			if(initial(power_area.fire_controled))
				power_area.fire_controled = TRUE
			for(var/obj/machinery/light/L in power_area)
				L.update(FALSE)
		repairing = FALSE
		return

	..()
	if(I.force)
		damaged += I.force
		check_damage(user)
