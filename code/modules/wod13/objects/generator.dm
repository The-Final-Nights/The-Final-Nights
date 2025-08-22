/obj/generator
	name = "generator"
	desc = "Power the controlled area with pure electricity."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "gen"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/on = TRUE
	var/switching_on = FALSE
	var/datum/looping_sound/generator/soundloop
	var/fuel_remain = 1000

/obj/generator/examine(mob/user)
	. = ..()
	. += "<b>Fuel</b>: [fuel_remain]/1000"

/obj/generator/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/gas_can))
		var/obj/item/gas_can/G = I
		if(G.stored_gasoline && fuel_remain < 1000 && isturf(user.loc))
			var/gas_to_transfer = min(1000-fuel_remain, min(100, max(1, G.stored_gasoline)))
			G.stored_gasoline = max(0, G.stored_gasoline-gas_to_transfer)
			fuel_remain = min(1000, fuel_remain+gas_to_transfer)
			playsound(loc, 'code/modules/wod13/sounds/gas_fill.ogg', 25, TRUE)
			to_chat(user, "<span class='notice'>You transfer [gas_to_transfer] fuel to [src].</span>")
		return

/obj/generator/proc/brek()
	on = FALSE
	soundloop.stop()
	icon_state = "gen_off"
	var/area/A = get_area(src)
	A.requires_power = TRUE
	A.fire_controled = FALSE
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, get_turf(src))
	s.start()
	for(var/obj/machinery/light/L in A)
		L.update(FALSE)
	playsound(loc, 'code/modules/wod13/sounds/explode.ogg', 100, TRUE)

/obj/generator/attack_hand(mob/user)
	if(fuel_remain == 0)
		to_chat(user, "<span class='warning'>There is no fuel in [src].</span>")
		return
	if(do_after(user, 50, src))
		var/area/A = get_area(src)
		on = TRUE
		soundloop.start()
		icon_state = "gen"
		A.requires_power = FALSE
		if(initial(A.fire_controled))
			A.fire_controled = TRUE
		for(var/obj/machinery/light/L in A)
			L.update(FALSE)
		to_chat(user, "<span class='notice'>You switch [src] on.</span>")

/obj/generator/Initialize()
	. = ..()
	soundloop = new(list(src), on)
	GLOB.generators += src
	START_PROCESSING(SSobj, src)

/obj/generator/Destroy()
	. = ..()
	QDEL_NULL(soundloop)
	GLOB.generators -= src
	STOP_PROCESSING(SSobj, src)

/obj/generator/process(delta_time)
	if(!on)
		return
	fuel_remain = max(0, fuel_remain - 0.01)
	if(fuel_remain == 0)
		brek()
