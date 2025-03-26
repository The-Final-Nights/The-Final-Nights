/obj/item/scissors
	name = "scissors"
	desc = "This cuts things."
	icon = 'icons/obj/tools.dmi'
	icon_state = "cutters"
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
	attack_verb_continuous = list("cuts", "snips")
	attack_verb_simple = list("cut", "snip")
	hitsound = 'sound/items/wirecutter.ogg'
	usesound = 'sound/items/wirecutter.ogg'
	drop_sound = 'sound/items/handling/wirecutter_drop.ogg'
	pickup_sound = 'sound/items/handling/wirecutter_pickup.ogg'
	tool_behaviour = TOOL_SCISSORS
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

/obj/item/scissors/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(!istype(M))
		return ..()

	var/selected_zone = user.zone_selected

	if(selected_zone == BODY_ZONE_PRECISE_MOUTH)
		if(user.a_intent == INTENT_HELP)
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			var/new_style = input(user, "Select a facial hairstyle", "Grooming") as null|anything in GLOB.facial_hairstyles_list
			if(!get_location_accessible(M, selected_zone))
				to_chat(user, "<span class='warning'>The mask is in the way!</span>")
				return
			user.visible_message("<span class='notice'>[user] tries to change [M]'s facial hairstyle using [src].</span>", "<span class='notice'>You try to change [M]'s facial hairstyle using [src].</span>")
			if(new_style && do_after(user, 60, target = M))
				user.visible_message("<span class='notice'>[user] successfully changes [M]'s facial hairstyle using [src].</span>", "<span class='notice'>You successfully change [M]'s facial hairstyle using [src].</span>")
				M.facial_hairstyle = new_style
				M.update_hair()
				return
		return ..()

	else if(selected_zone == BODY_ZONE_HEAD)
		if(user.a_intent == INTENT_HELP)
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			var/new_style = input(user, "Select a hairstyle", "Grooming") as null|anything in GLOB.hairstyles_list
			if(!get_location_accessible(M, selected_zone))
				to_chat(user, "<span class='warning'>The headgear is in the way!</span>")
				return
			if(HAS_TRAIT(M, TRAIT_BALD))
				to_chat(user, "<span class='warning'>[M] is just way too bald. Like, really really bald.</span>")
				return
			user.visible_message("<span class='notice'>[user] tries to change [M]'s hairstyle using [src].</span>", "<span class='notice'>You try to change [M]'s hairstyle using [src].</span>")
			if(new_style && do_after(user, 60, target = M))
				user.visible_message("<span class='notice'>[user] successfully changes [M]'s hairstyle using [src].</span>", "<span class='notice'>You successfully change [M]'s hairstyle using [src].</span>")
				M.hairstyle = new_style
				M.update_hair()
				return
	return ..()

/obj/item/scissors/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is cutting at [user.p_their()] arteries with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, usesound, 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/scissors/abductor
	name = "alien scissors"
	desc = "Extremely sharp scissors, made out of a silvery-green metal."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "scissors"
	toolspeed = 0.1

/obj/item/scissors/cyborg
	name = "powered scissors"
	desc = "Cuts things with the power of ELECTRICITY. Faster than normal scissors."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "scissors_cyborg"
	worn_icon_state = "scissors"
	toolspeed = 0.5
