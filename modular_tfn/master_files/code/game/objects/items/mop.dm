/obj/item/mop/proc/janicart_insert(mob/user, obj/structure/janitorialcart/J) //TFN Addition- To make the mop have the same procs as the other tools that can be put on the janicart.
	J.put_in_cart(src, user)
	J.mymop=src
	J.update_appearance()
