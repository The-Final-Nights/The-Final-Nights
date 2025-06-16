#define SIREN_DURATION (14.1 SECONDS)
#define EMERGENCY_CODE_OFF 1
#define EMERGENCY_CODE_LIGHTS 2
#define EMERGENCY_CODE_SIREN 3
#define SIREN_SOUND_CHANNEL 1010
#define DOOR_SOUND 'code/modules/wod13/sounds/door.ogg'
#define SIREN_SOUND 'code/modules/wod13/sounds/siren.ogg'
#define FLASH_INTERVAL (0.8 SECONDS)

/obj/vampire_car/emergency
	name = "emergency vehicle"
	desc = "An emergency response vehicle."
	icon_state = "1"
	dir = WEST
	access = null
	baggage_limit = 40
	baggage_max = WEIGHT_CLASS_BULKY
	light_system = MOVABLE_LIGHT
	light_range = null
	light_power = null
	light_color = null
	light_flags = LIGHT_ATTACHED
	var/emergency_code = EMERGENCY_CODE_OFF
	var/list/emergency_colors
	var/emergency_light_range = 4
	var/emergency_light_power = 5
	var/flash_timer_id
	var/siren_timer_id
	var/current_color_index = 1
	var/list/current_light_overlays

/obj/vampire_car/emergency/Initialize(mapload)
	. = ..()
	emergency_colors = list("#CC0000", "#FFFFFF")

	// ensure the lighting component is properly added since parent doesn't handle MOVABLE_LIGHT
	if(light_system == MOVABLE_LIGHT)
		AddComponent(/datum/component/overlay_lighting)

	initialize_emergency_lights()

/obj/vampire_car/emergency/proc/initialize_emergency_lights()
	turn_off_emergency_lights()
	update_light()

/obj/vampire_car/emergency/proc/turn_off_emergency_lights()
	set_light_range(0)
	set_light_power(0)
	set_light_color(null)
	set_light_on(FALSE)
	clear_light_overlays()

/obj/vampire_car/emergency/proc/turn_on_emergency_lights()
	set_light_range(emergency_light_range)
	set_light_power(emergency_light_power)
	set_light_color(emergency_colors[current_color_index])
	set_light_on(TRUE)
	add_light_overlay()

/obj/vampire_car/emergency/proc/clear_light_overlays()
	if(!current_light_overlays)
		return
	SSvis_overlays.remove_vis_overlay(src, current_light_overlays)
	current_light_overlays = null

/obj/vampire_car/emergency/proc/add_light_overlay()
	clear_light_overlays()
	if(emergency_code == EMERGENCY_CODE_OFF)
		return

	// create colored overlay
	var/overlay_color = emergency_colors[current_color_index]
	var/overlay_alpha = 30
	current_light_overlays = list()

	var/obj/effect/overlay/vis/light_overlay = SSvis_overlays.add_vis_overlay(src, 'icons/effects/light_overlays/light_352.dmi', "light", CAMERA_STATIC_LAYER, ABOVE_LIGHTING_PLANE, dir, overlay_alpha, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM, TRUE)
	light_overlay.color = overlay_color
	light_overlay.pixel_x = -160
	light_overlay.pixel_y = -160

	current_light_overlays += light_overlay

/obj/vampire_car/emergency/Destroy()
	stop_emergency_systems()
	clear_light_overlays()
	return ..()

/obj/vampire_car/emergency/proc/cycle_emergency_code()
	var/old_code = emergency_code

	// calculate next emergency code, but skip Code 3 if engine is off
	if(!on && emergency_code == EMERGENCY_CODE_LIGHTS)
		// if engine is off and we're at Code 2, go back to Code 1 instead of Code 3
		emergency_code = EMERGENCY_CODE_OFF
	else
		emergency_code = (emergency_code % EMERGENCY_CODE_SIREN) + 1

	// only stop siren if we're transitioning away from Code 3
	if(old_code == EMERGENCY_CODE_SIREN && emergency_code != EMERGENCY_CODE_SIREN)
		stop_siren()

	// stop lights if turning off or changing modes
	if(flash_timer_id)
		deltimer(flash_timer_id)
		flash_timer_id = null
	turn_off_emergency_lights()

	if(emergency_code != EMERGENCY_CODE_OFF)
		start_emergency_systems()

/obj/vampire_car/emergency/proc/stop_emergency_systems()
	if(flash_timer_id)
		deltimer(flash_timer_id)
		flash_timer_id = null
		turn_off_emergency_lights()
	stop_siren()

/obj/vampire_car/emergency/proc/start_emergency_systems()
	if(emergency_code == EMERGENCY_CODE_OFF)
		// make sure everything is off
		stop_emergency_systems()
		return

	// emergency lights work regardless of engine state
	if(emergency_code >= EMERGENCY_CODE_LIGHTS)
		turn_on_emergency_lights()
		flash_timer_id = addtimer(CALLBACK(src, PROC_REF(flash_lights)), FLASH_INTERVAL, TIMER_LOOP | TIMER_UNIQUE | TIMER_STOPPABLE)

	// only start siren if engine is on and there's a driver
	if(emergency_code == EMERGENCY_CODE_SIREN && on && driver)
		siren_timer_id = addtimer(CALLBACK(src, PROC_REF(siren_loop)), 0, TIMER_UNIQUE | TIMER_STOPPABLE)
	else
		stop_siren()

/obj/vampire_car/emergency/proc/flash_lights()
	if(emergency_code == EMERGENCY_CODE_OFF)
		stop_emergency_systems()
		return

	// cycle through emergency light colors
	current_color_index = (current_color_index % length(emergency_colors)) + 1
	turn_on_emergency_lights()

/obj/vampire_car/emergency/proc/siren_loop()
	if(!on || emergency_code != EMERGENCY_CODE_SIREN || !driver)
		stop_siren()
		return

	playsound(src, SIREN_SOUND, 100, FALSE, channel = SIREN_SOUND_CHANNEL)
	// set the next loop to play after the sound duration
	siren_timer_id = addtimer(CALLBACK(src, PROC_REF(siren_loop)), SIREN_DURATION, TIMER_UNIQUE | TIMER_STOPPABLE)

/obj/vampire_car/emergency/proc/stop_siren()
	if(siren_timer_id)
		deltimer(siren_timer_id)
		siren_timer_id = null

	for(var/mob/listening_mob as anything in GLOB.player_list)
		if(!listening_mob.client || get_dist(src, listening_mob) > world.view * 2)
			continue
		listening_mob.stop_sound_channel(SIREN_SOUND_CHANNEL)

/obj/vampire_car/emergency/proc/remove_passenger_action(mob/living/passenger)
	var/datum/action/carr/exit_car/exit_action = locate() in passenger.actions
	if(!exit_action)
		return
	qdel(exit_action)

/datum/action/carr/emergency_response
	name = "Emergency Response"
	desc = "Toggle emergency response code. Code 1: Off, Code 2: Lights, Code 3: Lights + Siren"
	button_icon_state = "lights"

/datum/action/carr/emergency_response/Trigger()
	var/obj/vampire_car/emergency/emergency_vehicle = owner.loc
	if(!istype(emergency_vehicle))
		return

	emergency_vehicle.cycle_emergency_code()
	var/list/code_names = list("Off", "Lights", "Lights + Siren")
	to_chat(owner, "<span class='notice'>Response Code [emergency_vehicle.emergency_code] ([code_names[emergency_vehicle.emergency_code]])</span>")

/obj/vampire_car/emergency/proc/can_load_human(mob/living/carbon/human/target, mob/user)
	if(get_dist(src, target) >= 2 || get_dist(src, user) >= 2)
		to_chat(user, "<span class='warning'>You're too far away.</span>")
		return FALSE
	if(length(passengers) >= max_passengers)
		to_chat(user, "<span class='warning'>There's no space left for [target] in [src].</span>")
		return FALSE
	if(!target.IsUnconscious() && !HAS_TRAIT(target, TRAIT_INCAPACITATED) && !HAS_TRAIT(target, TRAIT_RESTRAINED))
		return FALSE
	return TRUE

/obj/vampire_car/emergency/proc/load_human(mob/living/carbon/human/target, mob/user)
	if(!can_load_human(target, user))
		return FALSE

	visible_message("<span class='notice'>[user] begins loading [target] into [src].</span>")
	if(!do_mob(user, target, 2 SECONDS))
		to_chat(user, "<span class='warning'>You fail to load [target] into [src].</span>")
		return FALSE

	target.forceMove(src)
	passengers += target
	var/datum/action/carr/exit_car/exit_action = new()
	exit_action.Grant(target)

	visible_message("<span class='notice'>[user] loads [target] into [src].</span>")
	playsound(src, DOOR_SOUND, 50, TRUE)
	return TRUE

/obj/vampire_car/emergency/MouseDrop(atom/over_object)
	. = ..()
	if(!istype(over_object, /mob/living/carbon/human))
		return
	load_human(over_object, usr)

// police cruiser
/obj/vampire_car/emergency/police
	name = "police cruiser"
	desc = "A black and white San Francisco Police Department patrol cruiser. It's a bit old, but it'll get the job done."
	icon_state = "police"
	access = "police"
	max_passengers = 4
	var/list/weapon_slots

/obj/vampire_car/emergency/police/Initialize(mapload)
	. = ..()
	emergency_colors = list("#CC0000", "#000080")
	setup_weapon_rack()

/obj/vampire_car/emergency/police/proc/setup_weapon_rack()
	weapon_slots = list(
		"AR-15 Carbine" = new /obj/item/gun/ballistic/automatic/vampire/ar15(src),
		"Shotgun" = new /obj/item/gun/ballistic/shotgun/vampire(src)
	)

/obj/vampire_car/emergency/police/CtrlClick(mob/user)
	if(locked || get_dist(src, user) > 1)
		return
	var/obj/item/held_item = user.get_active_held_item()
	if(held_item)
		store_weapon(held_item, user)
	else
		retrieve_weapon(user)

/obj/vampire_car/emergency/police/proc/store_weapon(obj/item/weapon, mob/user)
	var/static/list/weapon_types = list(
		/obj/item/gun/ballistic/automatic/vampire/ar15 = "AR-15 Carbine",
		/obj/item/gun/ballistic/shotgun/vampire = "Shotgun"
	)

	var/weapon_type = weapon_types[weapon.type]
	if(!weapon_type || weapon_slots[weapon_type])
		to_chat(user, "<span class='warning'>[weapon_type ? "The [weapon_type] slot is occupied" : "This weapon cannot be stored here"]!</span>")
		return

	visible_message("<span class='notice'>[user] begins securing [weapon] in the weapon rack.</span>")
	if(!do_mob(user, src, 1.5 SECONDS))
		return

	user.transferItemToLoc(weapon, src)
	weapon_slots[weapon_type] = weapon
	visible_message("<span class='notice'>[user] secures [weapon] in the weapon rack.</span>")
	playsound(src, DOOR_SOUND, 50, TRUE)

/obj/vampire_car/emergency/police/proc/retrieve_weapon(mob/user)
	var/list/available_weapons = list()
	for(var/slot_name in weapon_slots)
		if(!weapon_slots[slot_name])
			continue
		available_weapons[slot_name] = weapon_slots[slot_name]

	if(!length(available_weapons))
		to_chat(user, "<span class='warning'>The weapon rack is empty.</span>")
		return

	var/chosen_weapon = input(user, "Select a weapon:", "Weapon Rack") as null|anything in available_weapons
	if(!chosen_weapon || !user.canUseTopic(src, BE_CLOSE))
		return

	var/obj/item/selected_weapon = available_weapons[chosen_weapon]
	visible_message("<span class='notice'>[user] begins retrieving [selected_weapon] from the weapon rack.</span>")
	if(!do_mob(user, src, 1.5 SECONDS))
		return

	if(!user.put_in_hands(selected_weapon))
		return

	weapon_slots[chosen_weapon] = null
	visible_message("<span class='notice'>[user] retrieves [selected_weapon] from the weapon rack.</span>")
	playsound(src, DOOR_SOUND, 50, TRUE)

/obj/vampire_car/emergency/police/unmarked
	name = "car"
	icon_state = "unmarked"
	desc = "Take me home, country roads..."

/obj/vampire_car/emergency/police/unmarked/Initialize(mapload)
	. = ..()
	var/static/list/available_icons = list("1", "2", "3", "unmarked", "5", "6")
	icon_state = pick(available_icons)

/obj/vampire_car/emergency/police/unmarked/setup_weapon_rack()
	return

// ambulance
/obj/vampire_car/emergency/ambulance
	name = "ambulance"
	desc = "An ambulance belonging to St John's Community Clinic. A beacon of hope in times of crisis."
	icon_state = "ambulance"
	access = "clinic"
	max_passengers = 6
	var/list/loaded_structures

/obj/vampire_car/emergency/ambulance/Initialize(mapload)
	. = ..()
	loaded_structures = list()
	emergency_colors = list("#CC0000", "#fc8484")

/obj/vampire_car/emergency/ambulance/MouseDrop_T(atom/dropping, mob/user)
	. = ..()
	if(!istype(user) || get_dist(src, dropping) > 1 || get_dist(src, user) > 1)
		return

	if(!istype(dropping, /obj/structure/bed/roller) && !istype(dropping, /obj/structure/closet/body_bag))
		return
	load_medical_structure(dropping, user)

/obj/vampire_car/emergency/ambulance/proc/load_medical_structure(obj/structure/structure, mob/user)
	var/list/occupants = get_structure_occupants(structure)
	if(length(occupants) && length(passengers) + length(occupants) > max_passengers)
		to_chat(user, "<span class='warning'>There's no space left for all occupants in [src].</span>")
		return

	visible_message("<span class='notice'>[user] begins loading [structure] into [src].</span>")
	if(!do_mob(user, structure, 2 SECONDS))
		return

	structure.forceMove(src)
	loaded_structures += structure

	for(var/mob/living/patient as anything in occupants)
		if(istype(structure, /obj/structure/bed/roller))
			structure.unbuckle_mob(patient)
		patient.forceMove(src)
		passengers += patient
		var/datum/action/carr/exit_car/exit_action = new()
		exit_action.Grant(patient)

	visible_message("<span class='notice'>[user] loads [structure] into [src].</span>")
	playsound(src, DOOR_SOUND, 50, TRUE)

/obj/vampire_car/emergency/ambulance/proc/get_structure_occupants(obj/structure/structure)
	if(istype(structure, /obj/structure/bed/roller))
		return structure.buckled_mobs.Copy()
	if(istype(structure, /obj/structure/closet/body_bag))
		var/list/occupants = list()
		for(var/mob/living/patient as anything in structure.contents)
			occupants += patient
		return occupants
	return list()

/obj/vampire_car/emergency/ambulance/AltClick(mob/user)
	if(!length(loaded_structures) || locked || get_dist(src, user) > 1)
		return ..()

	unload_medical_structure(user)

/obj/vampire_car/emergency/ambulance/proc/unload_medical_structure(mob/user)
	var/obj/structure/structure_to_unload = loaded_structures[length(loaded_structures)]
	visible_message("<span class='notice'>[user] begins unloading [structure_to_unload] from [src].</span>")

	if(!do_mob(user, src, 2 SECONDS))
		return

	structure_to_unload.forceMove(get_turf(user))
	loaded_structures -= structure_to_unload

	if(istype(structure_to_unload, /obj/structure/bed/roller))
		for(var/mob/living/patient as anything in passengers.Copy())
			passengers -= patient
			patient.forceMove(get_turf(user))
			structure_to_unload.buckle_mob(patient)
			remove_passenger_action(patient)
			break
	else if(istype(structure_to_unload, /obj/structure/closet/body_bag))
		var/obj/structure/closet/body_bag/body_bag = structure_to_unload
		for(var/mob/living/patient as anything in passengers.Copy())
			passengers -= patient
			patient.forceMove(body_bag)
			remove_passenger_action(patient)
			break

	visible_message("<span class='notice'>[user] unloads [structure_to_unload] from [src].</span>")
	playsound(src, DOOR_SOUND, 50, TRUE)

	if(istype(structure_to_unload, /obj/structure/bed/roller))
		playsound(src, 'sound/effects/roll.ogg', 50, TRUE)

#undef SIREN_DURATION
#undef EMERGENCY_CODE_OFF
#undef EMERGENCY_CODE_LIGHTS
#undef EMERGENCY_CODE_SIREN
#undef SIREN_SOUND_CHANNEL
#undef DOOR_SOUND
#undef SIREN_SOUND
#undef FLASH_INTERVAL
