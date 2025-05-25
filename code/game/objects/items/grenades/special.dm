/obj/item/grenade/sunlight
	name = "Solar Grenade"
	desc = "An odd looking grenade."
	w_class = ITEM_SIZE_SMALL
	icon_state = "emp"
	inhand_icon_state = "emp"

/obj/item/grenade/sunlight/detonate()
	for(var/mob/living/carbon/C in range(5)) //Five tile range
    if(iskindred)
    		C.visible_message("<b><span class='danger'>The grenade erupts in a flash of burning light!")
		    C.adjustFireLoss(80) //Sunlight REALLY hurts.
    		C.Paralyze(30)
    if(iscathayan)
      	C.visible_message("<b><span class='danger'>The grenade erupts in a flash of searing light!")
		    C.adjustCloneLoss(80) //Sunlight REALLY hurts. Kuei Jin rot, instead of burning.
    		C.Paralyze(30)
    else
      	C.visible_message("<b><span class='danger'>The grenade erupts in a flash of light!")
  	  	C.Paralyze(10) 
