/obj/structure/closet/crate/critter
	name = "critter crate"
	desc = "A crate designed for safe transport of animals. It has an oxygen tank for safe transport in space."
	icon_state = "crittercrate"
	horizontal = FALSE
	allow_objects = FALSE
	breakout_time = 600
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 4
	delivery_icon = "deliverybox"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

/obj/structure/closet/crate/critter/Initialize()
	. = ..()

/obj/structure/closet/crate/critter/update_icon_state()
	return

/obj/structure/closet/crate/critter/update_overlays()
	. = ..()
	if(opened)
		. += "crittercrate_door_open"
	else
		. += "crittercrate_door"
		if(manifest)
			. += "manifest"

