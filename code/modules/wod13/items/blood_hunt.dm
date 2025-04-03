/obj/item/blood_hunt
	name = "Blood Hunt Announcer"
	desc = "A stylized skull, made out of marble. This thaumaturgically-created artifact allows you to announce a Blood Hunt to the city. Name your target."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "eye"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/blood_hunt/attack_self(mob/user)
	. = ..()
	var/chosen_name = tgui_input_text(user, "Write the hunted or forgiven character name:", "Blood Hunt")
	if(!chosen_name)
		return
	chosen_name = sanitize_name(chosen_name)

	var/reason = tgui_input_text(user, "Write the reason of the Blood Hunt:", "Blood Hunt Reason")
	if(!reason)
		reason = "No reason necessary."

	var/name_in_list = FALSE
	// Blood hunts are only able to be called on fellow Kindred.
	for(var/mob/living/carbon/human/H in GLOB.kindred_list)
		if(H.real_name != chosen_name)
			continue

		if(H in SSbloodhunt.hunted)
			if(HAS_TRAIT(src, TRAIT_HUNTED))
				to_chat(user, span_warning("You can't remove [chosen_name] from the list!"))
				return
			SSbloodhunt.hunted -= H
			H.bloodhunted = FALSE
			SSbloodhunt.update_shit()
			to_chat(user, span_warning("You remove [chosen_name] from the Hunted list."))
			for(var/mob/living/carbon/human/R in GLOB.kindred_list)
				if(!R.client)
					return
				to_chat(R, "<b>The Blood Hunt after <span class='green'>[H.real_name]</span> is over!</b>")
				SEND_SOUND(R, sound('code/modules/wod13/sounds/announce.ogg'))
		else
			SSbloodhunt.announce_hunted(H, reason)
			to_chat(user, span_warning("You add [chosen_name] to the Hunted list."))
		name_in_list = TRUE
	if(!name_in_list)
		to_chat(user, span_warning("There is no such name in the Camarilla's records!"))
