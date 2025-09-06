/obj/item/food/vampire
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	eatsound = 'code/modules/wod13/sounds/eat.ogg'
	custom_price = 3
	food_flags = FOOD_BITE_SPRITE

//----------FAST FOOD--------///
/obj/item/food/burger/plain
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'
	custom_price = 3
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/donut/plain
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'
	custom_price = 1
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/donut/choco
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'
	custom_price = 1
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/pizzaslice/square
	name = "square pizza slice"
	icon_state = "pizza"
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'
	custom_price = 2
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/taco
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'
	custom_price = 2
	food_flags = FOOD_BITE_SPRITE

/obj/item/food/taco/plain
	icon_state = "taco"

/obj/item/trash/vampirenugget
	name = "chicken wing bone"
	icon_state = "nugget0"
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'

/obj/item/food/vampire/nugget
	name = "chicken wing"
	desc = "Big Wing for a big man."
	icon_state = "nugget1"
	trash_type = /obj/item/trash/vampirenugget
	bite_consumption = 1
	tastes = list("chicken" = 1)
	foodtypes = MEAT
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 3)
	eat_time = 15

//--------PACKAGED SNACKS-----------//

/obj/item/trash/vampirebar
	name = "chocolate bar wrapper"
	icon_state = "bar0"
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'

/obj/item/food/vampire/bar
	name = "chocolate bar"
	desc = "A fast way to reduce hunger."
	icon_state = "bar2"
	food_reagents = list(/datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/nutriment = 1)
	junkiness = 5
	trash_type = /obj/item/trash/vampirebar
	tastes = list("chocolate" = 1)
	food_flags = FOOD_IN_CONTAINER | FOOD_BITE_SPRITE
	foodtypes = JUNKFOOD | SUGAR

/obj/item/food/vampire/bar/proc/open_bar(mob/user)
	to_chat(user, "<span class='notice'>You pull back the wrapper of \the [src].</span>")
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	icon_state = "bar1"
	reagents.flags |= OPENCONTAINER

/obj/item/food/vampire/bar/attack_self(mob/user)
	if(!is_drainable())
		open_bar(user)
	return ..()

/obj/item/food/vampire/bar/attack(mob/living/M, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, "<span class='warning'>[src]'s wrapper hasn't been opened!</span>")
		return FALSE
	return ..()

/obj/item/trash/vampirecrisps
	name = "chips wrapper"
	icon_state = "crisps0"
	icon = 'modular_tfn/modules/food/icons/items.dmi'
	onflooricon = 'modular_tfn/modules/food/icons/food_onfloor.dmi'

/obj/item/food/vampire/crisps
	name = "chips"
	desc = "\"Days\" chips... Crispy!"
	icon_state = "crisps2"
	trash_type = /obj/item/trash/vampirecrisps
	bite_consumption = 1
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/salt = 1)
	junkiness = 10
	tastes = list("salt" = 1, "crisps" = 1)
	food_flags = FOOD_IN_CONTAINER | FOOD_BITE_SPRITE
	foodtypes = JUNKFOOD | FRIED
	eatsound = 'code/modules/wod13/sounds/crisp.ogg'

/obj/item/food/vampire/crisps/proc/open_crisps(mob/user)
	to_chat(user, "<span class='notice'>You pull back the wrapper of \the [src].</span>")
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	icon_state = "crisps1"
	reagents.flags |= OPENCONTAINER

/obj/item/food/vampire/crisps/attack_self(mob/user)
	if(!is_drainable())
		open_crisps(user)
	return ..()

/obj/item/food/vampire/crisps/attack(mob/living/M, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, "<span class='warning'>[src]'s wrapper hasn't been opened!</span>")
		return FALSE
	return ..()

/obj/item/food/vampire/icecream
	name = "ice cream"
	desc = "Taste the childhood."
	icon_state = "icecream2"
	food_reagents = list(/datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)
	tastes = list("vanilla" = 2, "ice cream" = 2)
	foodtypes = FRUIT | DAIRY | SUGAR

/obj/item/food/vampire/icecream/chocolate
	icon_state = "icecream1"
	tastes = list("chocolate" = 2, "ice cream" = 2)
	food_reagents = list(/datum/reagent/consumable/hot_coco = 4, /datum/reagent/consumable/salt = 1,  /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)

/obj/item/food/vampire/icecream/berry
	icon_state = "icecream3"
	tastes = list("berry" = 2, "ice cream" = 2)
	food_reagents = list(/datum/reagent/consumable/berryjuice = 4, /datum/reagent/consumable/salt = 1,  /datum/reagent/consumable/cream = 2, /datum/reagent/consumable/vanilla = 1, /datum/reagent/consumable/sugar = 4)




