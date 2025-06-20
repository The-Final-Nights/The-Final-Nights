/obj/item/grenade/sunlight
	name = "Solar Grenade"
	desc = "An odd looking grenade."
	icon_state = "emp"
	inhand_icon_state = "emp"

/obj/item/grenade/sunlight/detonate()
	var/detonate_turf = get_turf(src)
	if(!detonate_turf)
		return
	do_sparks(rand(5, 9), FALSE, src)
	playsound(detonate_turf, 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)
	for(var/mob/living/carbon/C in range(5, detonate_turf)) //Five tile range
		if(iskindred(C))
			to_chat(C, span_userdanger("The grenade erupts in a flash of burning light!"))
			C.adjustFireLoss(80) //Sunlight REALLY hurts.
			C.Paralyze(30)
		else if(iscathayan(C))
			to_chat(C, span_userdanger("The grenade erupts in a flash of searing light!"))
			C.adjustCloneLoss(80) //Sunlight REALLY hurts. Kuei Jin rot, instead of burning.
			C.Paralyze(30)
		else
			to_chat(C, span_userdanger("The grenade erupts in a flash of light!"))
	qdel(src)

/obj/item/grenade/equaliser
	name = "Equaliser Grenade"
	desc = "An odd looking grenade."
	icon_state = "syndicate"
	inhand_icon_state = "syndicate"

/obj/item/grenade/equaliser/detonate()
	var/detonate_turf = get_turf(src)
	if(!detonate_turf)
		return
	do_sparks(rand(5, 9), FALSE, src)
	playsound(detonate_turf, 'sound/weapons/flashbang.ogg', 100, TRUE, 8, 0.9)
	for(var/mob/living/carbon/C in range(5, detonate_turf)) //Five tile range
		if(isgarou(C))
			addtimer(CALLBACK(C, PROC_REF(transformation_unblock)), 60 SECONDS)
			to_chat(C, span_userdanger("The grenade erupts in a screech of noise, distrupting your focus. You can't transform!"))
			C.transformation_blocked == TRUE
			C.auspice_drain()
		else
			to_chat(C, span_userdanger("The grenade erupts in a screech of noise!"))
	qdel(src)
	

/mob/living/carbon/proc/auspice_drain()
	if(transformation_blocked == TRUE)
		if(auspice.rage > 0)
			auspice.rage adjust_rage(-1, src, TRUE)
			to_chat(src, span_userdanger("The noise makes it hard to concentrate, even on your anger."))
		else
			to_chat(src, span_userdanger("Your head swims. You can barely think, let alone feel anger."))
		addtimer(CALLBACK(C, PROC_REF(auspice_drain)), 1 SECONDS) //Yes, I know the singular is "Second", but it's a define. 

/mob/living/carbon/proc/transformation_unblock()
		transformation_blocked == TRUE)
		visible_message("<b><span class='danger'>You regain your focus, you can transform again!")
