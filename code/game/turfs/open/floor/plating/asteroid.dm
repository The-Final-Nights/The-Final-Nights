
/**********************Asteroid**************************/

/turf/open/floor/plating/asteroid //floor piece
	gender = PLURAL
	name = "asteroid sand"
	baseturfs = /turf/open/floor/plating/asteroid
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	base_icon_state = "asteroid"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	/// Base turf type to be created by the tunnel
	var/turf_type = /turf/open/floor/plating/asteroid
	/// Probability floor has a different icon state
	var/floor_variance = 20
	attachment_holes = FALSE
	/// Itemstack to drop when dug by a shovel
	var/obj/item/stack/digResult = /obj/item/stack/ore/glass/basalt
	/// Whether the turf has been dug or not
	var/dug
	/// Whether to change the turf's icon_state to "[base_icon_state]_dug" when its dugged up
	var/postdig_icon_change = TRUE

/turf/open/floor/plating/asteroid/setup_broken_states()
	return list("asteroid_dug")

/turf/open/floor/plating/asteroid/Initialize()
	var/proper_name = name
	. = ..()
	name = proper_name
	if(prob(floor_variance))
		icon_state = "[base_icon_state][rand(0,12)]"

/// Drops itemstack when dug and changes icon
/turf/open/floor/plating/asteroid/proc/getDug()
	dug = TRUE
	new digResult(src, 5)
	if(postdig_icon_change)
		icon_state = "[base_icon_state]_dug"

/// If the user can dig the turf
/turf/open/floor/plating/asteroid/proc/can_dig(mob/user)
	if(!dug)
		return TRUE
	if(user)
		to_chat(user, "<span class='warning'>Looks like someone has dug here already!</span>")

/turf/open/floor/plating/asteroid/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/asteroid/burn_tile()
	return

/turf/open/floor/plating/asteroid/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/floor/plating/asteroid/MakeDry()
	return

/turf/open/floor/plating/asteroid/crush()
	return

/turf/open/floor/plating/asteroid/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(!.)
		if(W.tool_behaviour == TOOL_SHOVEL || W.tool_behaviour == TOOL_MINING)
			if(!can_dig(user))
				return TRUE

			if(!isturf(user.loc))
				return

			to_chat(user, "<span class='notice'>You start digging...</span>")

			if(W.use_tool(src, user, 40, volume=50))
				if(!can_dig(user))
					return TRUE
				to_chat(user, "<span class='notice'>You dig a hole.</span>")
				getDug()
				SSblackbox.record_feedback("tally", "pick_used_mining", 1, W.type)
				return TRUE
		else if(istype(W, /obj/item/storage/bag/ore))
			for(var/obj/item/stack/ore/O in src)
				SEND_SIGNAL(W, COMSIG_PARENT_ATTACKBY, O)

/turf/open/floor/plating/asteroid/ex_act(severity, target)
	. = SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, severity, target)
	contents_explosion(severity, target)

/turf/open/floor/plating/lavaland_baseturf
	baseturfs = /turf/open/floor/plating/asteroid/basalt/lava_land_surface

/turf/open/floor/plating/asteroid/basalt
	name = "volcanic floor"
	baseturfs = /turf/open/floor/plating/asteroid/basalt
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt"
	base_icon_state = "basalt"
	floor_variance = 15
	digResult = /obj/item/stack/ore/glass/basalt

/turf/open/floor/plating/asteroid/basalt/setup_broken_states()
	return list("basalt_dug")

/turf/open/floor/plating/asteroid/basalt/lava //lava underneath
	baseturfs = /turf/open/lava/smooth

/turf/open/floor/plating/asteroid/basalt/airless

/turf/open/floor/plating/asteroid/basalt/Initialize()
	. = ..()
	set_basalt_light(src)

/turf/open/floor/plating/asteroid/getDug()
	set_light(0)
	return ..()

/proc/set_basalt_light(turf/open/floor/B)
	switch(B.icon_state)
		if("basalt1", "basalt2", "basalt3")
			B.set_light(2, 0.6, LIGHT_COLOR_LAVA) //more light
		if("basalt5", "basalt9")
			B.set_light(1.4, 0.6, LIGHT_COLOR_LAVA) //barely anything!

///////Surface. The surface is warm, but survivable without a suit. Internals are required. The floors break to chasms, which drop you into the underground.

/turf/open/floor/plating/asteroid/basalt/lava_land_surface
	baseturfs = /turf/open/lava/smooth/lava_land_surface

/turf/open/floor/plating/asteroid/lowpressure
	baseturfs = /turf/open/floor/plating/asteroid/lowpressure
	turf_type = /turf/open/floor/plating/asteroid/lowpressure

/turf/open/floor/plating/asteroid/airless
	baseturfs = /turf/open/floor/plating/asteroid/airless
	turf_type = /turf/open/floor/plating/asteroid/airless

/turf/open/floor/plating/asteroid/snow
	gender = PLURAL
	name = "snow"
	desc = "Looks cold."
	icon = 'icons/turf/snow.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/snow
	icon_state = "snow"
	base_icon_state = "snow"
	slowdown = 2
	flags_1 = NONE
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	digResult = /obj/item/stack/sheet/mineral/snow

/turf/open/floor/plating/asteroid/snow/setup_broken_states()
	return list("snow_dug")

/turf/open/floor/plating/asteroid/snow/burn_tile()
	if(!burnt)
		visible_message("<span class='danger'>[src] melts away!.</span>")
		slowdown = 0
		burnt = TRUE
		icon_state = "snow_dug"
		return TRUE
	return FALSE

/turf/open/floor/plating/asteroid/snow/icemoon
	baseturfs = /turf/open/openspace/icemoon
	slowdown = 0

/turf/open/lava/plasma/ice_moon
	baseturfs = /turf/open/lava/plasma/ice_moon

/turf/open/floor/plating/asteroid/snow/ice
	name = "icy snow"
	desc = "Looks colder."
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice
	floor_variance = 0
	icon_state = "snow-ice"
	base_icon_state = "snow-ice"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/asteroid/snow/ice/setup_broken_states()
	return list("snow-ice")
/turf/open/floor/plating/asteroid/snow/ice/icemoon
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice/icemoon
	slowdown = 0

/turf/open/floor/plating/asteroid/snow/ice/burn_tile()
	return FALSE

/turf/open/floor/plating/asteroid/snow/airless

/turf/open/floor/plating/asteroid/snow/temperatre

/turf/open/floor/plating/asteroid/snow/atmosphere
