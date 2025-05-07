/*
// Smooth movement vehicles, that aren't locked to the game's grid like normal vehicles are.
*/

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
	// How many passengers can fit in the vehicle
	var/passenger_capacity = 0

	var/datum/looping_sound/car_engine/engine_noise
	var/beep_sound = 'code/modules/wod13/sounds/beep.ogg'

/obj/vehicle_smooth/Initialize(mapload)
	. = ..()
	engine_noise = new(list(src), TRUE)

/obj/vehicle_smooth/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	QDEL_NULL(engine_noise)
	return ..()

/obj/vehicle_smooth/proc/engine_start()
	START_PROCESSING(SSfastprocess, src) // Need SSfastprocess here to avoid jankiness and smoothment.
	engine_noise.start()

/obj/vehicle_smooth/proc/engine_stop()
	STOP_PROCESSING(SSfastprocess, src)
	engine_noise.stop()
