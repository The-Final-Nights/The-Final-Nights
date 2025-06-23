/obj/necrorune
	name = "Necromancy Rune"
	desc = "Death is only the beginning."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rune1"
	color = rgb(10,128,20)
	anchored = TRUE
	var/word = "THURI'LLAH 'NHT"
	var/activator_bonus = 0
	var/activated = FALSE
	var/mob/living/last_activator
	var/necrolevel = 1
	var/list/sacrifices = list()

/obj/necrorune/proc/complete()
	return

/obj/necrorune/attack_hand(mob/user)
	if(activated)
		return

	var/mob/living/L = user
	if(!L.necromancy_knowledge)
		return

	L.say(word)
	L.Immobilize(30)
	last_activator = user

	animate(src, color = rgb(72, 230, 106), time = 10)


	if(sacrifices.len > 0)
		var/list/found_items = list()
		for(var/obj/item/I in get_turf(src))
			for(var/item_type in sacrifices)
				if(istype(I, item_type))
					if(istype(I, /obj/item/reagent_containers/blood))
						var/obj/item/reagent_containers/blood/bloodpack = I
						if(bloodpack.reagents && bloodpack.reagents.total_volume > 0)
							found_items += I
							break
					else
						found_items += I
						break
		if(found_items.len == sacrifices.len)
			for(var/obj/item/I in found_items)
				if(I)
					qdel(I)
			complete()
		else
			to_chat(user, "You lack the necessary sacrifices to complete the ritual. Found [found_items.len], required [sacrifices.len].")
	else
		complete()

/obj/necrorune/AltClick(mob/user)
	..()
	qdel(src)
