/obj/vehicle/ridden/speedbike
	name = "Motorcycle"
	desc = "You see a motorcycle, a beautiful and dangerous deathtrap on two wheels. An engineering masterpeice born of equal parts bravery, foolish pride, and desire for the thrill. Not meant for faint of heart or cowardly."
	icon = 'icons/obj/bike.dmi'
	icon_state = "speedbike_blue"
	layer = LYING_MOB_LAYER
	var/overlay_state = "cover_blue"
	var/mutable_appearance/overlay

	max_buckled_mobs = 1
	var/last_run_sound = 0
	var/last_rev_sound = 0
	var/move_threshold = 10
	var/move_count = 0
	var/datum/action/speedbike/rev_engine/rev_eng

/obj/vehicle/ridden/speedbike/Initialize()
	. = ..()
	overlay = mutable_appearance(icon, overlay_state, ABOVE_MOB_LAYER)
	add_overlay(overlay)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/speedbike)
	rev_eng = new /datum/action/speedbike/rev_engine
	rev_eng.this_bike = src

//Player mounts the bike.
/obj/vehicle/ridden/speedbike/user_buckle_mob(mob/living/M, mob/user, check_loc)
	. = ..()
	if(.)
		playsound(src, 'sound/vehicles/motorcycle/bike_idle_start.ogg', 80, TRUE, 3, 1.5)
		play_idle_loop() //repeat sound, killed in unbuckle.
		addtimer(CALLBACK(src, PROC_REF(handle_move_count_loop)), 1 SECONDS) //decriments the move count over time.
		rev_eng.Grant(M)

//Loops the idle sound.
/obj/vehicle/ridden/speedbike/proc/play_idle_loop()
	var/sound/idle_sound = sound('sound/vehicles/motorcycle/bike_idle.ogg',1,0,220,80)
	idle_sound.falloff = 1.5
	hearers(src) << idle_sound

//Decriments the move count over time.
/obj/vehicle/ridden/speedbike/proc/handle_move_count_loop()
	if(!has_buckled_mobs())
		return
	move_count = clamp(move_count, 0, 10)
	move_count--
	addtimer(CALLBACK(src, PROC_REF(handle_move_count_loop)), 1 SECONDS)

//Dismounts.
/obj/vehicle/ridden/speedbike/user_unbuckle_mob(mob/living/M, mob/user)
	. = ..()
	if(. && !has_buckled_mobs())
		src.rev_eng.Remove(M)
		var/sound/stop_idle = sound(null, repeat=0, channel=220)
		hearers(src) << stop_idle
		playsound(src, 'sound/vehicles/motorcycle/bike_idle_kill.ogg', 80, TRUE, 3, 1.5)

//Movement trail and sound.
/obj/vehicle/ridden/speedbike/Move(newloc,move_dir)
	move_count++
	if(has_buckled_mobs() && move_count >= move_threshold)
		new /obj/effect/temp_visual/dir_setting/speedbike_trail(loc,move_dir)
		handle_run_sound()
	return ..()

//Runs the motor when moving for long enough or sustained movement.
/obj/vehicle/ridden/speedbike/proc/handle_run_sound()
	if((world.time - last_run_sound) >= 3 SECONDS) //plays only every 3 seconds if moving
		last_run_sound = world.time
		playsound(src, 'sound/vehicles/motorcycle/bike_idle_run.ogg', 80, TRUE, 3, 1.5)

//Rev motor action button.
/datum/action/speedbike/rev_engine
	name = "Rev Engine"
	desc = "Revs the Engine."
	button_icon_state = "stage"
	var/obj/vehicle/ridden/speedbike/this_bike

/datum/action/speedbike/rev_engine/Trigger(trigger_flags)
	. = ..()
	if((world.time - this_bike.last_rev_sound) < 3 SECONDS)
		return
	playsound(this_bike, 'sound/vehicles/motorcycle/bike_idle_rev.ogg', 100, TRUE, 5, 1.5)
	this_bike.last_rev_sound = world.time

//VARIANTS
/obj/vehicle/ridden/speedbike/red
	icon_state = "speedbike_red"
	overlay_state = "cover_red"

//BM SPEEDWAGON

/obj/vehicle/ridden/speedwagon
	name = "BM Speedwagon"
	desc = "Push it to the limit, walk along the razor's edge."
	icon = 'icons/obj/car.dmi'
	icon_state = "speedwagon"
	layer = LYING_MOB_LAYER
	var/static/mutable_appearance/overlay = mutable_appearance('icons/obj/car.dmi', "speedwagon_cover", ABOVE_MOB_LAYER)
	max_buckled_mobs = 4
	var/crash_all = FALSE //CHAOS
	pixel_y = -48
	pixel_x = -48

/obj/vehicle/ridden/speedwagon/Initialize()
	. = ..()
	add_overlay(overlay)
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/speedwagon)

/obj/vehicle/ridden/speedwagon/Bump(atom/A)
	. = ..()
	if(!A.density || !has_buckled_mobs())
		return

	var/atom/throw_target = get_edge_target_turf(A, dir)
	if(crash_all)
		if(ismovable(A))
			var/atom/movable/AM = A
			AM.throw_at(throw_target, 4, 3)
		visible_message("<span class='danger'>[src] crashes into [A]!</span>")
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		H.Paralyze(100)
		H.adjustStaminaLoss(30)
		H.apply_damage(rand(20,35), BRUTE)
		if(!crash_all)
			H.throw_at(throw_target, 4, 3)
			visible_message("<span class='danger'>[src] crashes into [H]!</span>")
			playsound(src, 'sound/effects/bang.ogg', 50, TRUE)

/obj/vehicle/ridden/speedwagon/Moved()
	. = ..()
	if(!has_buckled_mobs())
		return
	for(var/atom/A in range(2, src))
		if(!(A in buckled_mobs))
			Bump(A)
