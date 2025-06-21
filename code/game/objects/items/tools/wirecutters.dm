/obj/item/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "fixer"
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	onflooricon_state = "fixer"
	inhand_icon_state = "cutters"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'

	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 6
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=80)
	attack_verb_continuous = list("pinches", "nips")
	attack_verb_simple = list("pinch", "nip")
	hitsound = 'sound/items/wirecutter.ogg'
	usesound = 'sound/items/wirecutter.ogg'
	drop_sound = 'sound/items/handling/wirecutter_drop.ogg'
	pickup_sound =  'sound/items/handling/wirecutter_pickup.ogg'

	tool_behaviour = TOOL_WIRECUTTER
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user)
	if(istype(C) && C.handcuffed && istype(C.handcuffed, /obj/item/restraints/handcuffs/cable))
		user.visible_message("<span class='notice'>[user] cuts [C]'s restraints with [src]!</span>")
		qdel(C.handcuffed)
		return
	else if(istype(C) && C.has_status_effect(STATUS_EFFECT_CHOKINGSTRAND))
		to_chat(C, "<span class='notice'>You attempt to remove the durathread strand from around your neck.</span>")
		if(do_after(user, 1.5 SECONDS, C))
			to_chat(C, "<span class='notice'>You succesfuly remove the durathread strand.</span>")
			C.remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)
	else
		..()

/obj/item/wirecutters/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is cutting at [user.p_their()] arteries with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, usesound, 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/wirecutters/abductor
	name = "alien wirecutters"
	desc = "Extremely sharp wirecutters, made out of a silvery-green metal."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cutters"
	toolspeed = 0.1

/obj/item/wirecutters/cyborg
	name = "powered wirecutters"
	desc = "Cuts wires with the power of ELECTRICITY. Faster than normal wirecutters."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "wirecutters_cyborg"
	worn_icon_state = "cutters"
	toolspeed = 0.5
