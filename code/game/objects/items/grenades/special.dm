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
			C.visible_message("<b><span class='danger'>The grenade erupts in a flash of burning light!")
			C.adjustFireLoss(80) //Sunlight REALLY hurts.
			C.Paralyze(30)
		else if(iscathayan(C))
			C.visible_message("<b><span class='danger'>The grenade erupts in a flash of searing light!")
			C.adjustCloneLoss(80) //Sunlight REALLY hurts. Kuei Jin rot, instead of burning.
			C.Paralyze(30)
		else
			C.visible_message("<b><span class='danger'>The grenade erupts in a flash of light!")
	qdel(src)
