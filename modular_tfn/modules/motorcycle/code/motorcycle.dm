/obj/vehicle/ridden/motorcycle
	name = "Motorcycle"
	desc = "You see a motorcycle; a beautiful and dangerous deathtrap on two wheels. An engineering masterpeice born of equal parts bravery, foolish pride, and a raw desire for thrill. Not meant for faint of heart or cowardly."
	icon = 'modular_tfn/modules/motorcycle/icons/obj/motorcycle.dmi'
	icon_state = "speedbike_blue"
	layer = LYING_MOB_LAYER
	var/overlay_state = "cover_blue"
	var/mutable_appearance/overlay

	//Almost all of this is taken from vamp/car.dm, and modified to fit a motorcycle, cutting out anything unneeded.
	var/mob/living/carbon/human/driver
	var/list/passengers = list()
	var/max_passengers = 1

	var/obj/key = null
	var/on = FALSE
	var/idle_looping = FALSE
	var/gas = 500
	var/access = "anarch"
	var/locked = TRUE

	var/health = 100
	var/maxhealth = 100
	var/repairing = FALSE
	var/exploded = FALSE

	//car alarm.
	var/last_beep = 0

	max_buckled_mobs = 1
	var/last_run_sound = 0
	var/last_rev_sound = 0
	var/move_threshold = 10
	var/move_count = 0
	var/datum/action/motorcycle/start_engine/start_eng
	var/datum/action/motorcycle/rev_engine/rev_eng

/obj/vehicle/ridden/motorcycle/Initialize()
	. = ..()
	//Handles the overlay sprites.
	overlay = mutable_appearance(icon, overlay_state, ABOVE_MOB_LAYER)
	add_overlay(overlay)
	//Basically makes the motorcycle a fancy janitor cart.
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/motorcycle)

	//Actions: Gives the motorcycle it's actions to start and rev the engine.
	start_eng = new /datum/action/motorcycle/start_engine
	start_eng.this_bike = src
	rev_eng = new /datum/action/motorcycle/rev_engine
	rev_eng.this_bike = src

//Mouse Drop Buckling Override:
/mob/living/carbon/human/MouseDrop(atom/over_object)
	. = ..()
	if(istype(over_object, /obj/vehicle/ridden/motorcycle) && get_dist(src, over_object) < 2)
		var/obj/vehicle/ridden/motorcycle/bike = over_object
		if(bike.locked)
			if(bike.on)
				to_chat(src, "<span class='warning'>The [bike]'s front wheel is locked, but the engine is running! Rev it! I'm sure no one will mind!</span>")
				return
			to_chat(src, "<span class='warning'>The [bike]'s front wheel is locked, it has a very comfy seat though.</span>")
			return
		if(bike.driver && (length(bike.passengers) >= bike.max_passengers))
			to_chat(src, "<span class='warning'>There's no room for you on the [bike].")
			return
		visible_message("<span class='notice'>[src] begins getting on the [bike]...</span>", \
			"<span class='notice'>You begin mounting the [bike]...</span>")
		if(do_mob(src, over_object, 1 SECONDS))
			if(!bike.driver)
				bike.driver = src
				bike.rev_eng.Grant(src)
				if(!bike.locked)
					bike.start_eng.Grant(src)
			else if(length(bike.passengers) < bike.max_passengers)
				bike.passengers += src
			visible_message("<span class='notice'>[src] gets on the [bike].</span>", \
				"<span class='notice'>You get on the [bike], and put the key your key in the slot.</span>")
			return
		else
			to_chat(src, "<span class='warning'>You fail to get on the [bike].")
			return

//Dismount
/obj/vehicle/ridden/motorcycle/user_unbuckle_mob(mob/living/M, mob/user)
	. = ..()
	if(. && !has_buckled_mobs())
		driver = null
		start_eng.Remove(M)
		rev_eng.Remove(M)

//Movement trail and sound.
/obj/vehicle/ridden/motorcycle/Move(newloc,move_dir)
	if(!on || gas <= 0 || health <= 0) //If the bike is off, or out of gas, or broken, don't move.
		if(on && gas <= 0)
			to_chat(driver, "<span class='warning'>The [src] sputters and dies; it's out of gas!</span>")
			on = FALSE
			stop_idle_loop()
		if(on && health <= 5)
			to_chat(driver, "<span class='warning'>The [src] shudders and dies; it's too damaged to run!</span>")
			on = FALSE
			stop_idle_loop()
		return FALSE
	move_count++
	gas = max(0, gas-1)
	if(has_buckled_mobs() && move_count >= move_threshold)
		handle_run_sound()
		move_count = 0
	return ..()

//Actions:
//Starts the motor.
////SOUNDS////
//Start- 220
//Idle - 221
//Run - 222
//Rev - 223
//Kill - 224

/datum/action/motorcycle/start_engine
	name = "Start/Kill the Engine"
	desc = "Starts or Kills the Engine."
	button_icon_state = "keys"
	var/obj/vehicle/ridden/motorcycle/this_bike

/datum/action/motorcycle/start_engine/Trigger(trigger_flags)
	. = ..()
	if(this_bike.on == FALSE)
		if(this_bike.gas <= 0)
			to_chat(this_bike.driver, "<span class='warning'>The [this_bike] is out of gas!</span>")
			return
		if(this_bike.health <= 10)
			to_chat(this_bike.driver, "<span class='warning'>The [this_bike] is too damaged to start!</span>")
			return
		this_bike.on = TRUE
		to_chat(this_bike.driver, "<span class='notice'>You start the [this_bike]'s engine.</span>")
		this_bike.play_idle_loop()
		return
	else if(this_bike.on == TRUE)
		this_bike.on = FALSE
		to_chat(this_bike.driver, "<span class='notice'>You turn off the [this_bike]'s engine.</span>")
		this_bike.stop_idle_loop()
		return

//Rev motor action.
/datum/action/motorcycle/rev_engine
	name = "Rev Engine"
	desc = "Revs the Engine."
	button_icon_state = "stage"
	var/obj/vehicle/ridden/motorcycle/this_bike

/datum/action/motorcycle/rev_engine/Trigger(trigger_flags)
	. = ..()
	if(!this_bike.on)
		to_chat(this_bike.driver, "<span class='warning'>The [this_bike]'s engine is off!</span>")
		return
	if((world.time - this_bike.last_rev_sound) < 3 SECONDS)
		return
	this_bike.handle_rev_sound()
	this_bike.last_rev_sound = world.time

//Start Idle sound.
/obj/vehicle/ridden/motorcycle/proc/play_idle_loop()
	if(idle_looping) return
	idle_looping = TRUE
	playsound(src, 'modular_tfn/modules/motorcycle/sound/bike_idle_start.ogg', 80, FALSE, 220, 1)
	addtimer(CALLBACK(src, /obj/vehicle/ridden/motorcycle/proc/play_idle_loop_repeat), 2.5 SECONDS)

/obj/vehicle/ridden/motorcycle/proc/play_idle_loop_repeat()
	if(!on || !idle_looping) return
	playsound(src, 'modular_tfn/modules/motorcycle/sound/bike_idle.ogg', 80, FALSE, 0, 1, 221)
	addtimer(CALLBACK(src, /obj/vehicle/ridden/motorcycle/proc/play_idle_loop_repeat), 2.5 SECONDS)

/// Called when engine stops
/obj/vehicle/ridden/motorcycle/proc/stop_idle_loop()
	idle_looping = FALSE
	var/sound/stop_idle = sound(null, repeat=0, channel=221)
	hearers(src) << stop_idle
	if(!on)
		playsound(src, 'modular_tfn/modules/motorcycle/sound/bike_idle_kill.ogg', 80, FALSE, 0, 1, 224)

/obj/vehicle/ridden/motorcycle/proc/handle_rev_sound()
	if((world.time - last_run_sound) >= 3 SECONDS)
		last_run_sound = world.time
		stop_idle_loop()
		playsound(src, 'modular_tfn/modules/motorcycle/sound/bike_idle_rev.ogg', 80, FALSE, 223, 1)
		addtimer(CALLBACK(src, PROC_REF(play_idle_loop)), 2 SECONDS)

/obj/vehicle/ridden/motorcycle/proc/handle_run_sound()
	if((world.time - last_run_sound) >= 3 SECONDS)
		last_run_sound = world.time
		stop_idle_loop()
		playsound(src, 'modular_tfn/modules/motorcycle/sound/bike_idle_run.ogg', 80, FALSE, 222, 1)
		addtimer(CALLBACK(src, PROC_REF(play_idle_loop)), 2 SECONDS)

//VARIANT, only one bike is in the sprite, this is still the old variant for now. (Gonna give the baron their own bike, after i learn how to rename these.)
/* Commented out for now, will finish.
/obj/vehicle/ridden/motorcycle/baron
	icon_state = "speedbike_red"
	overlay_state = "cover_red"
	access = "baron"
*/

//Keys/Lockpicking/Repair/Various: All from car.dm, very slightly modified.
/obj/vehicle/ridden/motorcycle/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/gas_can)) //gas
		var/obj/item/gas_can/G = I
		if(G.stored_gasoline && gas < 1000 && isturf(user.loc))
			var/gas_to_transfer = min(1000-gas, min(100, max(1, G.stored_gasoline)))
			G.stored_gasoline = max(0, G.stored_gasoline-gas_to_transfer)
			gas = min(1000, gas+gas_to_transfer)
			playsound(loc, 'code/modules/wod13/sounds/gas_fill.ogg', 25, TRUE)
			to_chat(user, "<span class='notice'>You transfer [gas_to_transfer] fuel to [src].</span>")
		return
	if(istype(I, /obj/item/vamp/keys)) //keys/lockpicking
		var/obj/item/vamp/keys/K = I
		if(istype(I, /obj/item/vamp/keys/hack))
			if(!repairing)
				repairing = TRUE
				if(do_mob(user, src, 20 SECONDS))
					var/roll = rand(1, 20) + (user.get_total_lockpicking()+user.get_total_dexterity()) - 8
					//(<= 1, break lockpick) (2-9, trigger car alarm), (>= 10, unlock car)
					if (roll <= 1)
						to_chat(user, "<span class='warning'>Your lockpick broke!</span>")
						qdel(K)
						repairing = FALSE
						return
					else if (roll >= 10)
						locked = FALSE
						repairing = FALSE
						to_chat(user, "<span class='notice'>You've managed to open [src]'s lock.</span>")
						playsound(src, 'code/modules/wod13/sounds/open.ogg', 50, TRUE)
					else
						to_chat(user, "<span class='warning'>You've failed to open [src]'s lock.</span>")
						playsound(src, 'code/modules/wod13/sounds/signal.ogg', 50, FALSE)
						for(var/mob/living/carbon/human/npc/police/P in oviewers(7, src))
							if(P)
								P.Aggro(user)
						repairing = FALSE
						return //Don't penalize vampire humanity if they failed.
					if(initial(access) == "none") //Stealing a car with no keys assigned to it is basically robbing a random person and not an organization
						if(ishuman(user))
							var/mob/living/carbon/human/H = user
							SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN, 6)
						return
				else
					to_chat(user, "<span class='warning'>You've failed to open [src]'s lock.</span>")
					repairing = FALSE
					return
			return
		if(K.accesslocks) //If the keys have any access
			for(var/i in K.accesslocks)
				if(i == access)
					to_chat(user, "<span class='notice'>You [locked ? "open" : "close"] [src]'s lock.</span>")
					playsound(src, 'code/modules/wod13/sounds/open.ogg', 50, TRUE)
					locked = !locked
					return
		return
	if(istype(I, /obj/item/melee/vampirearms/tire))
		if(!repairing)
			if(health >= maxhealth)
				to_chat(user, "<span class='notice'>[src] is already fully repaired.</span>")
				return
			repairing = TRUE
			var time_to_repair = (maxhealth - health) / 4 //Repair 4hp for every second spent repairing
			var start_time = world.time
			user.visible_message("<span class='notice'>[user] begins repairing [src]...</span>", \
				"<span class='notice'>You begin repairing [src]. Stop at any time to only partially repair it.</span>")
			if(do_mob(user, src, time_to_repair SECONDS))
				health = maxhealth
				playsound(src, 'code/modules/wod13/sounds/repair.ogg', 50, TRUE)
				user.visible_message("<span class='notice'>[user] repairs [src].</span>", \
					"<span class='notice'>You finish repairing all the dents on [src].</span>")
				color = "#ffffff"
				repairing = FALSE
				return
			else
				get_damage((world.time - start_time) * -2 / 5) //partial repair
				playsound(src, 'code/modules/wod13/sounds/repair.ogg', 50, TRUE)
				user.visible_message("<span class='notice'>[user] repairs [src].</span>", \
					"<span class='notice'>You repair some of the dents on [src].</span>")
				color = "#ffffff"
				repairing = FALSE
				return
		return

	else
		if(I.force)
			get_damage(round(I.force/2))
			for(var/mob/living/L in src)
				if(prob(50))
					L.apply_damage(round(I.force/2), I.damtype, pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST))

			if(!driver && !length(passengers) && last_beep+70 < world.time && locked)
				last_beep = world.time
				playsound(src, 'code/modules/wod13/sounds/signal.ogg', 50, FALSE)
				for(var/mob/living/carbon/human/npc/police/P in oviewers(7, src))
					P.Aggro(user)

			if(prob(10) && locked)
				playsound(src, 'code/modules/wod13/sounds/open.ogg', 50, TRUE)
				locked = FALSE

	..()

//crashing into stuff, direct rip.
/obj/vehicle/ridden/motorcycle/Bump(atom/A)
	if(!A)
		return
	if(istype(A, /mob/living))
		var/mob/living/hit_mob = A
		switch(hit_mob.mob_size)
			if(MOB_SIZE_HUGE) 	//gangrel warforms, werewolves, bears, ppl with fortitude
				playsound(src, 'code/modules/wod13/sounds/bump.ogg', 75, TRUE)
				hit_mob.Paralyze(1 SECONDS)
			if(MOB_SIZE_LARGE)	//ppl with fat bodytype
				playsound(src, 'code/modules/wod13/sounds/bump.ogg', 60, TRUE)
				hit_mob.Knockdown(1 SECONDS)
			if(MOB_SIZE_SMALL)	//small animals
				playsound(src, 'code/modules/wod13/sounds/bump.ogg', 40, TRUE)
				hit_mob.Knockdown(1 SECONDS)
			else				//everything else
				playsound(src, 'code/modules/wod13/sounds/bump.ogg', 50, TRUE)
				hit_mob.Knockdown(1 SECONDS)
	else
		playsound(src, 'code/modules/wod13/sounds/bump.ogg', 75, TRUE)

	if(driver && istype(A, /mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/NPC = A
		NPC.Aggro(driver, TRUE)

	for(var/mob/living/L in src)
		if(L)
			if(L.client)
				L.client.pixel_x = 0
				L.client.pixel_y = 0
	if(istype(A, /mob/living))
		var/dam = 20
		var/mob/living/L = A
		if(!HAS_TRAIT(L, TRAIT_TOUGH_FLESH))
			L.apply_damage(dam, BRUTE, BODY_ZONE_CHEST)
		if(driver)
			if(HAS_TRAIT(driver, TRAIT_EXP_DRIVER))
				dam = round(dam/2)
		get_damage(dam)
	else
		var/dam = 20
		if(driver)
			if(HAS_TRAIT(driver, TRAIT_EXP_DRIVER))
				dam = round(dam/2)
			driver.apply_damage(dam, BRUTE, BODY_ZONE_CHEST)
		get_damage(dam)
	return


//Motorcycle explodes!
/obj/vehicle/ridden/motorcycle/proc/get_damage(cost)
	if(cost > 0)
		health = max(0, health-cost)
	if(cost < 0)
		health = min(maxhealth, health-cost)
	if(health == 0)
		on = FALSE
		color = "#919191"
		if(!exploded && prob(10))
			exploded = TRUE
			for(var/mob/living/L in src)
				L.forceMove(loc)
				to_chat(L, "<span class='warning'>You are thrown from the wrecked [src]!</span>")
			explosion(loc,0,1,3,4)
			GLOB.car_list -= src
	else if(prob(50) && health <= maxhealth/2)
		on = FALSE
	return


/obj/vehicle/ridden/motorcycle/examine(mob/user)
	. = ..()
	if(user.loc == src)
		. += "<b>Gas</b>: [gas]/1000"
	if(health < maxhealth && health >= maxhealth-(maxhealth/4))
		. += "It's slightly dented..."
	if(health < maxhealth-(maxhealth/4) && health >= maxhealth/2)
		. += "It has some pretty major dents..."
	if(health < maxhealth/2 && health >= maxhealth/4)
		. += "It's heavily damaged..."
	if(health < maxhealth/4)
		. += "<span class='warning'>It appears to be falling apart...</span>"
	if(locked)
		. += "<span class='warning'>It's wheel is locked.</span>"
	if(driver || length(passengers))
		. += "<span class='notice'>\nYou see the following people on the motorcycle:</span>"
		for(var/mob/living/rider in src)
			. += "<span class='notice'>* [rider]</span>"
