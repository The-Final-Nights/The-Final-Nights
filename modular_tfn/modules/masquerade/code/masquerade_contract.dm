/obj/item/masquerade_contract
	name = "\improper elegant scroll"
	desc = "An elegant looking scroll."
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "masquerade"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/masquerade_contract/attack_self(mob/user)
	. = ..()
	if(!iskindred(user) && !isghoul(user))
		return
	var/turf/current_location = get_turf(user)
	to_chat(user, "[span_bold("YOU")], [get_area_name(user)] X:[current_location.x] Y:[current_location.y] Z:[current_location.z]")
	for(var/mob/living/carbon/breacher as anything in GLOB.masquerade_breakers_list)
		var/location_info
		var/turf/turf = get_turf(breacher)
		if(breacher.masquerade_score <= 2)
			location_info = "[get_area_name(turf)], X:[turf.x] Y:[turf.y] Z:[turf.z]"
		else
			location_info = "[get_area_name(turf)]"
		to_chat(user, span_info("[breacher.real_name], Masquerade: [breacher.masquerade_score], Diablerist: [breacher.diablerist ? "<b>YES</b>" : "NO"], [location_info]"))

	if(!GLOB.masquerade_breakers_list)
		to_chat(user, span_info("No available Masquerade breakers in city..."))

/obj/item/veil_contract
	name = "\improper brass pocketwatch"
	desc = "A posh looking pocketwatch."
	icon = 'icons/obj/items_and_weapons.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "pocketwatch"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/veil_contract/attack_self(mob/user)
	. = ..()
	if(!isgarou(user))
		return
	var/turf/current_location = get_turf(user)
	to_chat(user, "[span_bold("YOU")], [get_area_name(user)] X:[current_location.x] Y:[current_location.y] Z:[current_location.z]")
	for(var/mob/living/breacher as anything in GLOB.veil_breakers_list)
		var/location_info
		var/turf/turf = get_turf(breacher)
		if(breacher.masquerade_score <= 2)
			location_info = "[get_area_name(turf)], X:[turf.x] Y:[turf.y] Z:[turf.z]"
		else
			location_info = "[get_area_name(turf)]"
		to_chat(user, span_info("[breacher.real_name], Veil: [breacher.masquerade_score], [location_info]"))

	if(!GLOB.veil_breakers_list)
		to_chat(user, span_info("No available Veil breakers in city..."))
