/obj/item/latexballon
	name = "latex glove"
	desc = "Sterile and airtight."
	icon_state = "latexballon"
	inhand_icon_state = "lgloves"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 7

/obj/item/latexballon/ex_act(severity, target)
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)


