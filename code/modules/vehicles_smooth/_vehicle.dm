// Smooth movement vehicles, aren't locked to the game's grid like normal vehicles are.
/obj/vehicle_smooth
	name = "coderbus vehicle"
	desc = "If you see this, something fucked up."
	icon = 'icons/obj/vehicles/cars.dmi'
	icon_state = "taxi"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	// The vhicle's maximum speed, measured in pixels per tick
	var/max_speed = 512
	// Current speed of the vehicle, measured in pixels per tick
	var/speed = 0
	// Acceleration of the vehicle, indicates how many pixels the vehicle speed will increase per tick
	var/acceleration = 0
	// Turn speed of the vehicle, measured in degrees per tick
	var/turn_speed = 0

	// The current driver, if any
	var/mob/living/carbon/human/driver = null
	var/list/mob/living/passengers = list()
	// How many passengers can fit in the vehicle
	var/passenger_capacity = 0

	var/datum/looping_sound/car_engine/engine_noise
	var/beep_sound = 'sound/vehicles/cars/beep.ogg'

/obj/vehicle_smooth/Initialize(mapload)
	. = ..()
	engine_noise = new(list(src), TRUE)

/obj/vehicle_smooth/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	QDEL_NULL(engine_noise)
	return ..()

/obj/vehicle_smooth/MouseDrop_T(mob/living/dropping, mob/living/dropping_user)
	. = ..()
	if(dropping != dropping_user)
		add_passenger(dropping)
		return
	add_vehicle_user(dropping)

/obj/vehicle_smooth/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	var/removed_passenger = passengers[1]
	forceMove(removed_passenger, over)
	passengers -= removed_passenger

/*
// This is the function that allows WASD movement for the car. Oh God.
// W - Accelerate forwards
// S - Accelerate backwards
// A - Turn left
// D - Turn right
// Pressing no keys will eventually stop the vehicle, but that's handled in the base movement ticks.
*/
/obj/vehicle_smooth/relaymove(mob/living/user, direction)
	switch(direction)
		if(NORTH)
			accelerate()
		if(SOUTH)
			accelerate()
		if(WEST)
			turn()
		if(EAST)
			turn()

///////////////////////////////////////////////////// Custom vehicle functions from here.

/obj/vehicle_smooth/proc/add_passenger(mob/living/dropping)
	forceMove(dropping, src)
	passengers += dropping
	playsound(src, 'sound/vehicles/cars/door.ogg', 20, TRUE)

/obj/vehicle_smooth/proc/engine_start()
	START_PROCESSING(SSfastprocess, src) // Need SSfastprocess here to avoid jankiness and smoothment.
	engine_noise.start()

/obj/vehicle_smooth/proc/engine_stop()
	STOP_PROCESSING(SSfastprocess, src)
	engine_noise.stop()
