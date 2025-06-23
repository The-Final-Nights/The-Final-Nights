/obj/structure/closet/crate/wooden
	name = "wooden crate"
	desc = "Works just as well as a metal one."
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 6
	icon_state = "wooden"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/wooden/toy
	name = "toy box"
	desc = "It has the words \"Clown + Mime\" written underneath of it with marker."

/obj/structure/closet/crate/wooden/toy/PopulateContents()
	. = ..()
	new	/obj/item/megaphone/clown(src)
	new	/obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter(src)
	new /obj/item/pneumatic_cannon/pie(src)
	new /obj/item/food/pie/cream(src)
	new /obj/item/storage/crayons(src)

//SanFran community garden stuff
/obj/structure/closet/crate/wooden/communitygardens/tools
	name = "community garden tools"
	desc = "It's marked with the San Francisco City Council stamp."

/obj/structure/closet/crate/wooden/communitygardens/tools/PopulateContents()
	. = ..()
	new /obj/item/storage/bag/plants(src)
	new /obj/item/reagent_containers/glass/bottle/nutrient/rh(src)
	new /obj/item/reagent_containers/spray/weedspray(src)
	new /obj/item/reagent_containers/spray/pestspray(src)
	new	/obj/item/cultivator(src)
	new	/obj/item/clothing/gloves/botanic_leather(src)
	new	/obj/item/reagent_containers/glass/wateringcan(src)

/obj/structure/closet/crate/wooden/communitygardens/seeds
	name = "community garden seeds"
	desc = "It's marked with the San Francisco City Council stamp."

/obj/structure/closet/crate/wooden/communitygardens/seeds/PopulateContents()
	. = ..()
	new	/obj/item/seeds/cabbage(src)
	new	/obj/item/seeds/peas(src)
	new	/obj/item/seeds/potato(src)
	new	/obj/item/seeds/soya(src)
	new	/obj/item/seeds/tomato(src)
