/obj/lombard
	name = "pawnshop"
	desc = "Sell your stuff."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	icon_state = "sell"
	icon = 'code/modules/wod13/props.dmi'
	anchored = TRUE
	var/illegal = FALSE

/obj/lombard/attackby(obj/item/W, mob/living/user, params)
	var/mob/living/carbon/human/H = user

	if(W.cost <= 0)
		to_chat(H, span_notice("[W] isn't worth anything!"))
		return
	if(W.illegal)
		to_chat(H, span_notice("The pawnshop doesn't accept illegal goods!"))
		return
	if(istype(W, /obj/item/stack))
		return

	var/amount = round(W.cost / 5 * (user.social + (user.additional_social * 0.1)))
	if(amount > 0)
		new /obj/item/stack/dollar(get_turf(src), amount)

	playsound(get_turf(src), 'code/modules/wod13/sounds/sell.ogg', 50, TRUE)
	qdel(W)
	return

/obj/lombard/blackmarket
	name = "black market"
	desc = "Sell illegal goods."
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	icon_state = "sell_d"
	icon = 'code/modules/wod13/props.dmi'
	anchored = TRUE
	illegal = TRUE

/obj/lombard/blackmarket/attackby(obj/item/W, mob/living/user, params)
	var/mob/living/carbon/human/H = user

	if(W.cost <= 0)
		to_chat(H, span_notice("[W] isn't worth anything!"))
		return
	if(!W.illegal)
		to_chat(H, span_notice("The black market only accepts illegal goods!"))
		return
	if(istype(W, /obj/item/stack))
		return
	if(istype(W, /obj/item/organ))
		var/obj/item/organ/O = W
		if(O.damage > round(O.maxHealth/2))
			to_chat(user, span_warning("[W] is too damaged to sell!"))
			return

	if(istype(W, /obj/item/organ))
		to_chat(H, span_userdanger("<b>Selling organs is a depraved act... If I keep doing this, I will become a wight!</b>"))
		SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN, 0)
	else if(istype(W, /obj/item/reagent_containers/food/drinks/meth/cocaine))
		SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN, 5)
	else if(istype(W, /obj/item/reagent_containers/food/drinks/meth))
		SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN, 4)
	else if(illegal)
		SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN, 7)

	var/amount = round(W.cost / 5 * (user.social + (user.additional_social * 0.1)))
	if(amount > 0)
		new /obj/item/stack/dollar(get_turf(src), amount)

	playsound(get_turf(src), 'code/modules/wod13/sounds/sell.ogg', 50, TRUE)
	qdel(W)
	return
