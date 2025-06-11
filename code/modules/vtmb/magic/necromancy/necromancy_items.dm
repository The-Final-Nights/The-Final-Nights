/obj/item/necromancy_tome
	name = "necromancy tome"
	desc = "An old tome bound in peculiar leather."
	icon_state = "necronomicon"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	is_magic = TRUE
	var/list/rituals = list()

/obj/item/necromancy_tome/Initialize()
	. = ..()
	for(var/i in subtypesof(/obj/necrorune))
		if(i)
			var/obj/necrorune/R = new i(src)
			rituals |= R

/obj/item/necromancy_tome/attack_self(mob/user)
	. = ..()
	for(var/obj/necrorune/R in rituals)
		var/list/required_items = list()
		for(var/item_type in R.sacrifices)
			var/obj/item/I = new item_type(src)
			required_items += I.name
			qdel(I)
		var/required_list
		if(required_items.len == 1)
			required_list = required_items[1]
		else
			for(var/item_name in required_items)
				required_list += (required_list == "" ? item_name : ", [item_name]")
		to_chat(user, "[R.necrolevel] [R.name] - [R.desc] Requirements: [length(required_list) ? required_list : "None"].")
