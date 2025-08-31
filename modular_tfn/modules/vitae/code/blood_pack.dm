//Regular blooc packs are considered O-, due to being the all-purpose donation blood type.
/obj/item/reagent_containers/blood
	inhand_icon_state = "blood0"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	var/amount_of_bloodpoints = 2

/obj/item/reagent_containers/blood/Initialize(mapload)
	. = ..()
	if(blood_type != null)
		reagents.add_reagent(/datum/reagent/blood, 200,
		list("donor" = null,
			"viruses" = null,
			"blood_DNA" = null,
			"blood_type" = blood_type,
			"resistances" = null,
			"trace_chem" = null))
	update_appearance()

/obj/item/reagent_containers/blood/is_drainable()
	return TRUE

/obj/item/reagent_containers/blood/is_drawable(mob/user, allowmobs)
	return TRUE

/obj/item/reagent_containers/blood/is_refillable(mob/user, allowmobs)
	return TRUE

/obj/item/reagent_containers/blood/update_appearance(updates)
	. = ..()
	var/percent = round((reagents?.total_volume / volume) * 100)
	switch(percent)
		if(100)
			icon_state = "blood100"
		if(75)
			icon_state = "blood75"
		if(50)
			icon_state = "blood50"
		if(25)
			icon_state = "blood25"
		if(0)
			icon_state = "blood0"
	inhand_icon_state = icon_state
	onflooricon_state = icon_state

/// Handles updating the container when the reagents change.
/obj/item/reagent_containers/blood/on_reagent_change(datum/reagents/holder, ...)
	update_appearance()
	return ..()

/obj/item/reagent_containers/blood/update_appearance(updates)
	. = ..()
	update_blood_type()
	update_name()

/obj/item/reagent_containers/blood/update_name(updates)
	. = ..()
	name = "\improper blood pack - [blood_type ? "[blood_type]" : "(empty)"]"

/obj/item/reagent_containers/blood/proc/update_blood_type()
	if(!reagents)
		return
	var/datum/reagent/blood/B = (reagents.has_reagent(/datum/reagent/blood) || reagents.has_reagent(/datum/reagent/blood/vitae))
	if(B && B.data && B.data["blood_type"])
		blood_type = B.data["blood_type"]
	else
		blood_type = null

/obj/item/reagent_containers/blood/attackby(obj/item/I, mob/user, params)
	if(!IS_WRITING_UTENSIL(I))
		return ..()
	if(!user.is_literate())
		to_chat(user, span_notice("You scribble illegibly on the label of [src]!"))
		return
	var/new_name = tgui_input_text(user, "What would you like to label the blood pack?", "Renaming", name, 60)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if(user.get_active_held_item() != I)
		return
	if(new_name)
		labelled = TRUE
		name = "blood pack - [new_name]"
		playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
		balloon_alert(user, "new label set")
	else
		labelled = FALSE
		update_name()

/obj/item/reagent_containers/blood/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!canconsume(M, user))
		return
	if(!reagents.holder_full())
		return
	if(!do_after(user, 3 SECONDS, M))
		return
	reagents.trans_to(M, reagents.total_volume, transfered_by = user, methods = VAMPIRE, show_message = FALSE)

	playsound(M.loc, 'sound/items/drink.ogg', 50, TRUE)
	update_appearance()
	SEND_SIGNAL(M, COMSIG_MASQUERADE_VIOLATION)
	if(ishumanbasic(M) || (isghoul(M) && !reagents.has_reagent(/datum/reagent/blood/vitae)))
		to_chat(M, span_notice("That didn't taste very good..."))
		M.adjust_disgust(DISGUST_LEVEL_GROSS)
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "toxic_food", /datum/mood_event/disgusting_food)
	if(iskindred(M) || (isghoul(M) && reagents.has_reagent(/datum/reagent/blood/vitae)))
		M.bloodpool = min(M.maxbloodpool, M.bloodpool+amount_of_bloodpoints)
		M.adjustBruteLoss(-20, TRUE)
		M.adjustFireLoss(-20, TRUE)
		M.update_blood_hud()

/obj/item/reagent_containers/blood/empty
	blood_type = null

/obj/item/reagent_containers/blood/ab_plus
	blood_type = "AB+"

/obj/item/reagent_containers/blood/ab_minus
	blood_type = "AB-"

/obj/item/reagent_containers/blood/elite
	name = "\improper elite blood pack (full)"
	amount_of_bloodpoints = 4
	blood_type = null

/obj/item/reagent_containers/blood/elite/Initialize(mapload)
	if(mapload)
		blood_type = random_blood_type()
	return ..()

/obj/item/reagent_containers/blood/vitae
	name = "\improper vampire vitae pack (full)"
	amount_of_bloodpoints = 4
	blood_type = null

/obj/item/reagent_containers/blood/random

/obj/item/reagent_containers/blood/random/Initialize(mapload)
	if(mapload)
		blood_type = random_blood_type()
	return ..()

/obj/item/reagent_containers/blood/bweedpack
	name = "\improper elite blood pack (full)"
	blood_type = null

/obj/item/reagent_containers/blood/bweedpack/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/drug/cannabis, 20)
	reagents.add_reagent(/datum/reagent/toxin/lipolicide, 20)
	reagents.add_reagent(/datum/reagent/blood, 160,
		list("donor" = null,
			"viruses" = null,
			"blood_DNA" = null,
			"blood_type" = random_blood_type(),
			"resistances" = null,
			"trace_chem" = null))
	update_appearance()

/obj/item/reagent_containers/blood/cokepack
	name = "\improper elite blood pack (full)"
	blood_type = null

/obj/item/reagent_containers/blood/cokepack/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/drug/methamphetamine/cocaine, 15)
	reagents.add_reagent(/datum/reagent/blood, 185,
		list("donor" = null,
			"viruses" = null,
			"blood_DNA" = null,
			"blood_type" = random_blood_type(),
			"resistances" = null,
			"trace_chem" = null))
	update_appearance()

/obj/item/reagent_containers/blood/morphpack
	name = "\improper elite blood pack (full)"
	blood_type = null

/obj/item/reagent_containers/blood/morphpack/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/chloralhydrate, 10)
	reagents.add_reagent(/datum/reagent/medicine/morphine, 10)
	reagents.add_reagent(/datum/reagent/blood, 180,
		list("donor" = null,
			"viruses" = null,
			"blood_DNA" = null,
			"blood_type" = random_blood_type(),
			"resistances" = null,
			"trace_chem" = null))
	update_appearance()

/obj/item/reagent_containers/blood/methpack
	name = "\improper elite blood pack (full)"
	blood_type = null

/obj/item/reagent_containers/blood/methpack/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/drug/methamphetamine, 15)
	reagents.add_reagent(/datum/reagent/blood, 185,
		list("donor" = null,
			"viruses" = null,
			"blood_DNA" = null,
			"blood_type" = random_blood_type(),
			"resistances" = null,
			"trace_chem" = null))
	update_appearance()
