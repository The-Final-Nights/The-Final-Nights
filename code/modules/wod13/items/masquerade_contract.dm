/obj/item/masquerade_contract
	name = "\improper elegant scroll"
	desc = "This piece of thaumaturgy shows Masquerade breakers. <b>CLICK ON the Contract to see possible breakers for catching. PUSH the target in torpor, to restore the Masquerade.</b>"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "masquerade"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/masquerade_contract/attack_self(mob/user)
	. = ..()
	var/list/masq_breakers = list()
	if(GLOB.masquerade_breakers_list.len)
		for(var/mob/living/carbon/human/breakor in GLOB.masquerade_breakers_list)
			masq_breakers += breakor

	if(masq_breakers.len)
		var/turf/UT = get_turf(user)
		if(UT)
			to_chat(user, "<b>YOU</b>, [get_area_name(user)] X:[UT.x] Y:[UT.y]")
		for(var/mob/living/carbon/human/H in masq_breakers)
			if(iskindred(H) || isghoul(H) || iscathayan(H) || iszombie(H))
				var/turf/TT = get_turf(H)
				var/location_info = ""
				if(TT && !is_sabbatist(H))
					location_info = "[get_area_name(H)] X:[TT.x] Y:[TT.y]"
				else if(is_sabbatist(H))
					location_info = "[get_area_name(H)]"
				if(TT)
					to_chat(user, "[H.real_name], Masquerade: [H.masquerade], Diablerist: [H.diablerist ? "<b>YES</b>" : "NO"], [location_info]")
	else
		to_chat(user, "No available Masquerade breakers in city...")


/obj/item/veil_contract
	name = "\improper brass pocketwatch"
	desc = "The hands do not tell the time, but a spirit's blessing on this fetish points you to dangers to the veil. <b>CLICK ON the clock to see possible breakers for catching. Shame or execute the offender for crimes against the nation.</b>"
	icon = 'icons/obj/items_and_weapons.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "pocketwatch"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/veil_contract/attack_self(mob/user)
	. = ..()
	var/list/masq_breakers = list()
	if(GLOB.masquerade_breakers_list.len)
		for(var/mob/living/carbon/breakor in GLOB.masquerade_breakers_list)
			if(isgarou(breakor) || iswerewolf(breakor))
				masq_breakers += breakor

	if(masq_breakers.len)
		var/turf/UT = get_turf(user)
		if(UT)
			to_chat(user, "<b>YOU</b>, [get_area_name(user)] X:[UT.x] Y:[UT.y]")
		for(var/mob/living/carbon/human/W in masq_breakers)
			var/turf/TT = get_turf(W)
			if(TT)
				to_chat(user, "[W.true_real_name], Veil: [W.masquerade], [get_area_name(W)] X:[TT.x] Y:[TT.y]")
	else
		to_chat(user, "No available Veil breakers in city...")
