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

