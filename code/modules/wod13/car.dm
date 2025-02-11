GLOBAL_LIST_EMPTY(car_list)
SUBSYSTEM_DEF(carpool)
	name = "Car Pool"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_OBJ
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 5

	var/list/currentrun = list()

/datum/controller/subsystem/carpool/stat_entry(msg)
	var/list/activelist = GLOB.car_list
	msg = "CARS:[length(activelist)]"
	return ..()

/datum/controller/subsystem/carpool/fire(resumed = FALSE)
	if (!resumed)
		var/list/activelist = GLOB.car_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/obj/vampire_car/CAR = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(CAR))
			GLOB.car_list -= CAR
			if(QDELETED(CAR))
				log_world("Found a null in car list!")
			continue

		if(MC_TICK_CHECK)
			return
		CAR.running()

/obj/item/gas_can
	name = "gas can"
	desc = "Stores gasoline or pure fire death."
	icon_state = "gasoline"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/stored_gasoline = 0

/obj/item/gas_can/examine(mob/user)
	. = ..()
	. += "<b>Gas</b>: [stored_gasoline]/1000"

/obj/item/gas_can/full
	stored_gasoline = 1000

/obj/item/gas_can/rand

/obj/item/gas_can/rand/Initialize()
	. = ..()
	stored_gasoline = rand(0, 500)

/obj/item/gas_can/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(istype(get_turf(A), /turf/open/floor) && !istype(A, /obj/vampire_car) && !istype(A, /obj/structure/fuelstation) && !istype(A, /mob/living/carbon/human) && !istype(A, /obj/structure/drill))
		var/obj/effect/decal/cleanable/gasoline/G = locate() in get_turf(A)
		if(G)
			return
		if(!proximity)
			return
		if(stored_gasoline < 50)
			return
		stored_gasoline = max(0, stored_gasoline-50)
		new /obj/effect/decal/cleanable/gasoline(get_turf(A))
		playsound(get_turf(src), 'code/modules/wod13/sounds/gas_splat.ogg', 50, TRUE)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if(!proximity)
			return
		if(stored_gasoline < 50)
			return
		stored_gasoline = max(0, stored_gasoline-50)
		H.fire_stacks = min(10, H.fire_stacks+10)
		playsound(get_turf(H), 'code/modules/wod13/sounds/gas_splat.ogg', 50, TRUE)
		user.visible_message("<span class='warning'>[user] covers [A] in something flammable!</span>")


/obj/vampire_car/attack_hand(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == INTENT_HARM && H.potential >= 4)
			var/atom/throw_target = get_edge_target_turf(src, user.dir)
			playsound(get_turf(src), 'code/modules/wod13/sounds/bump.ogg', 100, FALSE)
			get_damage(10)
			throw_at(throw_target, rand(4, 6), 4, user)

/obj/vampire_car
	name = "car"
	desc = "Take me home, country roads..."
	icon_state = "2"
	icon = 'code/modules/wod13/cars.dmi'
	anchored = TRUE
	plane = GAME_PLANE
	layer = CAR_LAYER
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	throwforce = 150
	glide_size = 96

	var/image/Fari
	var/fari_on = FALSE

	var/mob/living/driver
	var/list/passengers = list()
	var/max_passengers = 3

	var/stage = 1
	var/on = FALSE
	var/locked = TRUE
	var/access = "none"

	var/traction = 2	//our resistance to lateral movement
	var/speed = 32		//acceleration in pixels per carpool/fire()
	var/top_speed = 256
	var/top_speed_back = 32

	var/speed_x
	var/speed_y
	var/accel_x
	var/accel_y
	var/speed_magnitude

	var/angle_looking

	var/health = 100
	var/maxhealth = 100
	var/repairing = FALSE

	var/last_beep = 0
	var/last_vzhzh = 0
	var/impact_delay = 0

	var/component_type = /datum/component/storage/concrete/vtm/car
	var/baggage_limit = 40
	var/baggage_max = WEIGHT_CLASS_BULKY

	var/exploded = FALSE
	var/beep_sound = 'code/modules/wod13/sounds/beep.ogg'

	var/gas = 1000

/obj/vampire_car/ComponentInitialize()
	. = ..()
	AddComponent(component_type)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 100
	STR.max_w_class = baggage_max
	STR.max_items = baggage_limit
	STR.locked = TRUE

/obj/vampire_car/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	. = ..()
	get_damage(5)
	for(var/mob/living/L in src)
		if(prob(50))
			L.apply_damage(P.damage, P.damage_type, pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST))

/obj/vampire_car/AltClick(mob/user)
	..()
	if(!repairing)
		if(locked)
			to_chat(user, "<span class='warning'>[src] is locked!</span>")
			return
		repairing = TRUE
		var/mob/living/L

		if(driver)
			L = driver
		else if(length(passengers))
			L = pick(passengers)
		else
			to_chat(user, "<span class='notice'>There's no one in [src].</span>")
			repairing = FALSE
			return

		user.visible_message("<span class='warning'>[user] begins pulling someone out of [src]!</span>", \
			"<span class='warning'>You begin pulling [L] out of [src]...</span>")
		if(do_mob(user, src, 5 SECONDS))
			var/datum/action/carr/exit_car/C = locate() in L.actions
			user.visible_message("<span class='warning'>[user] has managed to get [L] out of [src].</span>", \
				"<span class='warning'>You've managed to get [L] out of [src].</span>")
			if(C)
				C.Trigger()
		else
			to_chat(user, "<span class='warning'>You've failed to get [L] out of [src].</span>")
		repairing = FALSE
		return

/obj/vampire_car/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/gas_can))
		var/obj/item/gas_can/G = I
		if(G.stored_gasoline && gas < 1000 && isturf(user.loc))
			var/gas_to_transfer = min(1000-gas, min(100, max(1, G.stored_gasoline)))
			G.stored_gasoline = max(0, G.stored_gasoline-gas_to_transfer)
			gas = min(1000, gas+gas_to_transfer)
			playsound(loc, 'code/modules/wod13/sounds/gas_fill.ogg', 25, TRUE)
			to_chat(user, "<span class='notice'>You transfer [gas_to_transfer] fuel to [src].</span>")
		return
	if(istype(I, /obj/item/vamp/keys))
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
							H.AdjustHumanity(-1, 6)
							call_dharma("steal", H)
						return
				else
					to_chat(user, "<span class='warning'>You've failed to open [src]'s lock.</span>")
					repairing = FALSE
					return
			return
		if(K.accesslocks)
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

/obj/vampire_car/Destroy()
	GLOB.car_list -= src
	. = ..()
	for(var/mob/living/L in src)
		L.forceMove(loc)
		var/datum/action/carr/exit_car/E = locate() in L.actions
		if(E)
			qdel(E)
		var/datum/action/carr/fari_vrubi/F = locate() in L.actions
		if(F)
			qdel(F)
		var/datum/action/carr/engine/N = locate() in L.actions
		if(N)
			qdel(N)
		var/datum/action/carr/stage/S = locate() in L.actions
		if(S)
			qdel(S)
		var/datum/action/carr/beep/B = locate() in L.actions
		if(B)
			qdel(B)
		var/datum/action/carr/baggage/G = locate() in L.actions
		if(G)
			qdel(G)

/obj/vampire_car/examine(mob/user)
	. = ..()
	if(user.loc == src)
		. += "<b>Gas</b>: [gas]/1000"
	if(health < maxhealth && health >= maxhealth-(maxhealth/4))
		. += "It's slightly dented..."
	if(health < maxhealth-(maxhealth/4) && health >= maxhealth/2)
		. += "It has some major dents..."
	if(health < maxhealth/2 && health >= maxhealth/4)
		. += "It's heavily damaged..."
	if(health < maxhealth/4)
		. += "<span class='warning'>It appears to be falling apart...</span>"
	if(locked)
		. += "<span class='warning'>It's locked.</span>"
	if(driver || length(passengers))
		. += "<span class='notice'>\nYou see the following people inside:</span>"
		for(var/mob/living/rider in src)
			. += "<span class='notice'>* [rider]</span>"

/obj/vampire_car/proc/get_damage(var/cost)
	if(cost > 0)
		health = max(0, health-cost)
	if(cost < 0)
		health = min(maxhealth, health-cost)

	if(health == 0)
		on = FALSE
		set_light(0)
		color = "#919191"
		if(!exploded && prob(10))
			exploded = TRUE
			for(var/mob/living/L in src)
				L.forceMove(loc)
				var/datum/action/carr/exit_car/E = locate() in L.actions
				if(E)
					qdel(E)
				var/datum/action/carr/fari_vrubi/F = locate() in L.actions
				if(F)
					qdel(F)
				var/datum/action/carr/engine/N = locate() in L.actions
				if(N)
					qdel(N)
				var/datum/action/carr/stage/S = locate() in L.actions
				if(S)
					qdel(S)
				var/datum/action/carr/beep/B = locate() in L.actions
				if(B)
					qdel(B)
				var/datum/action/carr/baggage/G = locate() in L.actions
				if(G)
					qdel(G)
			explosion(loc,0,1,3,4)
			GLOB.car_list -= src
	else if(prob(50) && health <= maxhealth/2)
		on = FALSE
		set_light(0)
	return

/datum/action/carr/fari_vrubi
	name = "Toggle Light"
	desc = "Toggle light on/off."
	button_icon_state = "lights"

/datum/action/carr/fari_vrubi/Trigger()
	if(istype(owner.loc, /obj/vampire_car))
		var/obj/vampire_car/V = owner.loc
		if(!V.fari_on)
			V.fari_on = TRUE
			V.add_overlay(V.Fari)
			to_chat(owner, "<span class='notice'>You toggle [V]'s lights.</span>")
			playsound(V, 'sound/weapons/magin.ogg', 40, TRUE)
		else
			V.fari_on = FALSE
			V.cut_overlay(V.Fari)
			to_chat(owner, "<span class='notice'>You toggle [V]'s lights.</span>")
			playsound(V, 'sound/weapons/magout.ogg', 40, TRUE)

/datum/action/carr/beep
	name = "Signal"
	desc = "Beep-beep."
	button_icon_state = "beep"

/datum/action/carr/beep/Trigger()
	if(istype(owner.loc, /obj/vampire_car))
		var/obj/vampire_car/V = owner.loc
		if(V.last_beep+10 < world.time)
			V.last_beep = world.time
			playsound(V.loc, V.beep_sound, 60, FALSE)

/datum/action/carr/stage
	name = "Toggle Transmission"
	desc = "Toggle transmission to 1, 2 or 3."
	button_icon_state = "stage"

/datum/action/carr/stage/Trigger()
	if(istype(owner.loc, /obj/vampire_car))
		var/obj/vampire_car/V = owner.loc
		if(V.stage < 3)
			V.stage = V.stage+1
		else
			V.stage = 1
		to_chat(owner, "<span class='notice'>You enable [V]'s transmission at [V.stage].</span>")

/datum/action/carr/baggage
	name = "Lock Baggage"
	desc = "Lock/Unlock Baggage."
	button_icon_state = "baggage"

/datum/action/carr/baggage/Trigger()
	if(istype(owner.loc, /obj/vampire_car))
		var/obj/vampire_car/V = owner.loc
		var/datum/component/storage/STR = V.GetComponent(/datum/component/storage)
		STR.locked = !STR.locked
		playsound(V, 'code/modules/wod13/sounds/door.ogg', 50, TRUE)
		if(STR.locked)
			to_chat(owner, "<span class='notice'>You lock [V]'s baggage.</span>")
		else
			to_chat(owner, "<span class='notice'>You unlock [V]'s baggage.</span>")

/datum/action/carr/engine
	name = "Toggle Engine"
	desc = "Toggle engine on/off."
	button_icon_state = "keys"

/datum/action/carr/engine/Trigger()
	if(istype(owner.loc, /obj/vampire_car))
		var/obj/vampire_car/V = owner.loc
		if(!V.on)
			if(V.health == V.maxhealth)
				V.on = TRUE
				playsound(V, 'code/modules/wod13/sounds/start.ogg', 50, TRUE)
				to_chat(owner, "<span class='notice'>You managed to start [V]'s engine.</span>")
				return
			if(prob(100*(V.health/V.maxhealth)))
				V.on = TRUE
				playsound(V, 'code/modules/wod13/sounds/start.ogg', 50, TRUE)
				to_chat(owner, "<span class='notice'>You managed to start [V]'s engine.</span>")
				return
			else
				to_chat(owner, "<span class='warning'>You failed to start [V]'s engine.</span>")
				return
		else
			V.on = FALSE
			playsound(V, 'code/modules/wod13/sounds/stop.ogg', 50, TRUE)
			to_chat(owner, "<span class='notice'>You stop [V]'s engine.</span>")
			V.set_light(0)
			return

/datum/action/carr/exit_car
	name = "Exit"
	desc = "Exit the vehicle."
	button_icon_state = "exit"

/datum/action/carr/exit_car/Trigger()
	if(istype(owner.loc, /obj/vampire_car))
		var/obj/vampire_car/V = owner.loc
		if(V.driver == owner)
			V.driver = null
		if(owner in V.passengers)
			V.passengers -= owner
		owner.forceMove(V.loc)

		var/list/exit_side = list(
			SIMPLIFY_DEGREES(V.angle_looking + 90),
			SIMPLIFY_DEGREES(V.angle_looking - 90)
		)
		for(var/angle in exit_side)
			if(get_step(owner, angle2dir(angle)).density)
				exit_side.Remove(angle)
		var/list/exit_alt = GLOB.alldirs.Copy()
		for(var/dir in exit_alt)
			if(get_step(owner, dir).density)
				exit_alt.Remove(dir)
		if(length(exit_side))
			owner.Move(get_step(owner, angle2dir(pick(exit_side))))
		else if(length(exit_alt))
			owner.Move(get_step(owner, exit_alt))

		to_chat(owner, "<span class='notice'>You exit [V].</span>")
		if(owner)
			if(owner.client)
				owner.client.pixel_x = 0
				owner.client.pixel_y = 0
		playsound(V, 'code/modules/wod13/sounds/door.ogg', 50, TRUE)
		for(var/datum/action/carr/C in owner.actions)
			qdel(C)

/mob/living/carbon/human/MouseDrop(atom/over_object)
	. = ..()
	if(istype(over_object, /obj/vampire_car) && get_dist(src, over_object) < 2)
		var/obj/vampire_car/V = over_object

		if(V.locked)
			to_chat(src, "<span class='warning'>[V] is locked.</span>")
			return

		if(V.driver && (length(V.passengers) >= V.max_passengers))
			to_chat(src, "<span class='warning'>There's no space left for you in [V].")
			return

		visible_message("<span class='notice'>[src] begins entering [V]...</span>", \
			"<span class='notice'>You begin entering [V]...</span>")
		if(do_mob(src, over_object, 1 SECONDS))
			if(!V.driver)
				forceMove(over_object)
				V.driver = src
				var/datum/action/carr/exit_car/E = new()
				E.Grant(src)
				var/datum/action/carr/fari_vrubi/F = new()
				F.Grant(src)
				var/datum/action/carr/engine/N = new()
				N.Grant(src)
				var/datum/action/carr/beep/B = new()
				B.Grant(src)
				var/datum/action/carr/baggage/G = new()
				G.Grant(src)
			else if(length(V.passengers) < V.max_passengers)
				forceMove(over_object)
				V.passengers += src
				var/datum/action/carr/exit_car/E = new()
				E.Grant(src)
			visible_message("<span class='notice'>[src] enters [V].</span>", \
				"<span class='notice'>You enter [V].</span>")
			playsound(V, 'code/modules/wod13/sounds/door.ogg', 50, TRUE)
			return
		else
			return

/obj/vampire_car/retro
	icon_state = "1"
	max_passengers = 1
	dir = WEST

/obj/vampire_car/retro/rand
	icon_state = "3"

/obj/vampire_car/retro/rand/Initialize()
	icon_state = "[pick(1, 3, 5)]"
	if(access == "none")
		access = "npc[rand(1, 20)]"
	..()

/obj/vampire_car/rand
	icon_state = "4"
	dir = WEST

/obj/vampire_car/rand/Initialize()
	icon_state = "[pick(2, 4, 6)]"
	if(access == "none")
		access = "npc[rand(1, 20)]"
	..()

/obj/vampire_car/rand/camarilla
	access = "camarilla"
	icon_state = "6"

/obj/vampire_car/retro/rand/camarilla
	access = "camarilla"
	icon_state = "5"

/obj/vampire_car/rand/anarch
	access = "anarch"
	icon_state = "6"

/obj/vampire_car/retro/rand/anarch
	access = "anarch"
	icon_state = "5"

/obj/vampire_car/rand/clinic
	access = "clinic"
	icon_state = "6"

/obj/vampire_car/retro/rand/clinic
	access = "clinic"
	icon_state = "5"

/obj/vampire_car/police
	icon_state = "police"
	max_passengers = 3
	dir = WEST
	beep_sound = 'code/modules/wod13/sounds/migalka.ogg'
	access = "police"
	baggage_limit = 45
	baggage_max = WEIGHT_CLASS_BULKY
	var/color_blue = FALSE
	var/last_color_change = 0

/obj/vampire_car/police/running()
	if(fari_on)
		if(last_color_change+10 <= world.time)
			last_color_change = world.time
			if(color_blue)
				color_blue = FALSE
				set_light(0)
				set_light(4, 6, "#ff0000")
			else
				color_blue = TRUE
				set_light(0)
				set_light(4, 6, "#0000ff")
	else
		if(last_color_change+10 <= world.time)
			last_color_change = world.time
			set_light(0)
	..()

/obj/vampire_car/taxi
	icon_state = "taxi"
	max_passengers = 3
	dir = WEST
	access = "taxi"
	baggage_limit = 40
	baggage_max = WEIGHT_CLASS_BULKY

/obj/vampire_car/track
	icon_state = "track"
	max_passengers = 6
	dir = WEST
	access = "none"
	baggage_limit = 100
	baggage_max = WEIGHT_CLASS_BULKY
	component_type = /datum/component/storage/concrete/vtm/car/track

/obj/vampire_car/track/Initialize()
	if(access == "none")
		access = "npc[rand(1, 20)]"
	..()

/obj/vampire_car/track/volkswagen
	icon_state = "volkswagen"
	baggage_limit = 60

/obj/vampire_car/track/ambulance
	icon_state = "ambulance"
	access = "clinic"
	baggage_limit = 60

/obj/vampire_car/Initialize()
	. = ..()
	Fari = new (src)
	Fari.icon = 'icons/effects/light_overlays/light_cone_car.dmi'
	Fari.icon_state = "light"
	Fari.pixel_x = -64
	Fari.pixel_y = -64
	Fari.layer = O_LIGHTING_VISUAL_LAYER
	Fari.plane = O_LIGHTING_VISUAL_PLANE
	Fari.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	Fari.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	Fari.alpha = 110
	gas = rand(100, 1000)
	GLOB.car_list += src

	angle_looking = dir2angle(dir)

	add_overlay(image(icon = src.icon, icon_state = src.icon_state, pixel_x = -32, pixel_y = -32))
	icon_state = "empty"

/obj/vampire_car/relaymove(mob/living/carbon/human/driver, movement_dir) //fires 5 times for every call to running()
	if(world.time-impact_delay < 20 \
		|| driver.IsUnconscious() \
		|| HAS_TRAIT(driver, TRAIT_INCAPACITATED) \
		|| HAS_TRAIT(driver, TRAIT_RESTRAINED)
	)
		return

	var/delta_angle = 0
	if(movement_dir & EAST)
		delta_angle = min(abs(speed_magnitude) / 6, 5)
	if(movement_dir & WEST)
		delta_angle = -min(abs(speed_magnitude) / 6, 5)
	angle_looking = SIMPLIFY_DEGREES(angle_looking + delta_angle)

	//TODO dont drink and drive

	//at max turn speed, snap to nearest cardinal if our angle increment is higher than our difference to a cardinal direction
	var/nearest_cardinal = round((angle_looking + 45) / 90) * 90
	if(abs(delta_angle) == 5 && abs(angle_looking - nearest_cardinal) < 5)
		angle_looking = nearest_cardinal
	handle_rotation()

	accel_x = 0
	accel_y = 0
	if(movement_dir & NORTH)
		playsound(src, 'code/modules/wod13/sounds/stopping.ogg', 10, FALSE)
		accel_x = round(sin(angle_looking) * speed)
		accel_y = round(cos(angle_looking) * speed)

/obj/vampire_car/proc/running()
	speed_x = clamp(speed_x + accel_x, -top_speed, top_speed) * 0.8
	speed_y = clamp(speed_y + accel_y, -top_speed, top_speed) * 0.8
	speed_magnitude = sqrt(speed_x ** 2 + speed_y ** 2)

	var/delta_angle = angle_looking - ATAN2(speed_y, speed_x)
	if(delta_angle != 0)
		var/turn_radius = (speed_magnitude * (360 / abs(delta_angle))) / (2 * PI)
		var/centripetal_force = round((speed_magnitude ** 2) / turn_radius) //f = v^2 / r
		var/inwards = SIMPLIFY_DEGREES(angle_looking + 90 * SIGN(delta_angle))
		speed_x += round(sin(inwards) * centripetal_force)
		speed_y += round(cos(inwards) * centripetal_force)

	var/new_pix_x = pixel_x + speed_x //we'll call animate() later to update our pixel_x to this
	var/new_pix_y = pixel_y + speed_y

	//if our sprite's offset is >16 pixels offcenter, move accross the world
	var/delta_x = (new_pix_x < 0 ? -1 : 1) * round((abs(new_pix_x) + 16) / 32) //amount of turfs we will cross
	var/delta_y = (new_pix_y < 0 ? -1 : 1) * round((abs(new_pix_y) + 16) / 32)
	if(delta_x || delta_y)
		var/horizontal = new_pix_x < 0 ? WEST : EAST
		var/vertical = new_pix_y < 0 ? SOUTH : NORTH
		pixel_x -= delta_x * 32
		pixel_y -= delta_y * 32
		new_pix_x -= delta_x * 32
		new_pix_y -= delta_y * 32
		if(abs(delta_x) > abs(delta_y))
			bresenham_move(abs(delta_x), abs(delta_y), horizontal, vertical)
		else
			bresenham_move(abs(delta_y), abs(delta_x), vertical, horizontal)

	//vfx
	for(var/mob/living/rider in src)
		if(rider && rider.client)
			rider.client.pixel_x = pixel_x
			rider.client.pixel_y = pixel_y
			animate(rider.client,
				pixel_x = new_pix_x,
				pixel_y = new_pix_y,
				SScarpool.wait, 1)
	var/turn_state = round(SIMPLIFY_DEGREES(angle_looking + 22.5) / 45)
	dir = GLOB.modulo_angle_to_dir[turn_state + 1]
	animate(src,
		pixel_x = new_pix_x,
		pixel_y = new_pix_y,
		SScarpool.wait, 1)

//move in a straight diagonal line
/obj/vampire_car/proc/bresenham_move(dx, dy, h, v)
	var/margin = 2 * dy - dx
	for(var/i=0; i<dx; i++)
		if(margin >= 0)
			if(!Move(get_step(src, v), v)) return FALSE
			margin -= 2 * dx
		margin += 2 * dy
		if(!Move(get_step(src, h), h)) return FALSE
	return TRUE

/obj/vampire_car/Bump(atom/contact)
	to_chat(driver, "we bumped [contact]")

/obj/vampire_car/proc/handle_rotation()
	var/turn_state = round(SIMPLIFY_DEGREES(angle_looking + 22.5) / 45)
	dir = GLOB.modulo_angle_to_dir[turn_state + 1]
	transform = turn(matrix(), angle_looking - turn_state * 45)

/obj/vampire_car/setDir(newdir)
	. = ..()
	handle_rotation()
