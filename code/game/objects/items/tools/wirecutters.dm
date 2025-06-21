/obj/item/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon_state = "fixer"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'

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
	var/random_color = FALSE
	var/static/list/wirecutter_colors = list(
		"blue" = "#1861d5",
		"red" = "#951710",
		"pink" = "#d5188d",
		"brown" = "#a05212",
		"green" = "#0e7f1b",
		"cyan" = "#18a2d5",
		"yellow" = "#d58c18"
	)


/obj/item/wirecutters/Initialize()
	. = ..()
	if(random_color) //random colors!
		icon_state = "cutters"
		var/our_color = pick(wirecutter_colors)
		add_atom_colour(wirecutter_colors[our_color], FIXED_COLOUR_PRIORITY)
		update_appearance()

/obj/item/wirecutters/update_overlays()
	. = ..()
	if(!random_color) //icon override
		return
	var/mutable_appearance/base_overlay = mutable_appearance(icon, "cutters_cutty_thingy")
	base_overlay.appearance_flags = RESET_COLOR
	. += base_overlay

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
	random_color = FALSE

/obj/item/wirecutters/cyborg
	name = "powered wirecutters"
	desc = "Cuts wires with the power of ELECTRICITY. Faster than normal wirecutters."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "wirecutters_cyborg"
	worn_icon_state = "cutters"
	toolspeed = 0.5
	random_color = FALSE

/obj/item/wirecutters/pliers
	name = "dental pliers"
	desc = "Meant for taking out teeth."
	icon_state = "neat_ripper"
	toolspeed = 2 //isn't meant for cutting wires
	random_color = FALSE
	var/permanent = TRUE ///if something lasts for the entire ROUND or not. very important just the ROUND.

/obj/item/wirecutters/pliers/bad_pliers
	name = "pliers"
	desc = "Meant for pulling wires but you could definetly crush something with these."
	icon_state = "ripper"
	toolspeed = 1.2 //is an actual tool but can't actually
	permanent = FALSE

/obj/item/wirecutters/pliers/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	if(isgarou(target) || iswerewolf(target) || isanimal(target))
		return
	if(iskindred(target))
		if(HAS_TRAIT(target, TRAIT_BABY_TEETH))
			to_chat(usr, span_warning("[user] can't pull out the fangs of [target] because they are already deformed!"))
		else
			to_chat(span_warning("[user] takes [src] straight to the [target]'s Fangs!"))
			to_chat(usr, span_warning ("You take [src] straight to the [target]'s Fangs!"))
			if(do_after(user, 30, target))
				user.do_attack_animation(target)
				to_chat(span_warning("[user] rips out [target]'s fangs!"))
				to_chat(usr, span_warning("You rip out [target]'s fangs!"))
				target.emote("scream")
				if (permanent == TRUE)
					ADD_TRAIT(target, TRAIT_BABY_TEETH, MAGIC_TRAIT)
					visible_message(span_warning("[user] stuff's in Bone putty into [target] to stop their fangs from regrowing!"))
				else
					target.apply_status_effect(STATUS_EFFECT_BABY_TEETH)
