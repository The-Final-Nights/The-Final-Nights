
/obj/item/storage/box/empty
	name = "box"
	desc = "What's in the box?!"
	icon_state = "box"
	icon = 'code/modules/wod13/items.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 3 GRID_BOXES
	grid_height = 3 GRID_BOXES

/obj/item/donator/plushie_box
	name = "plushie 3-pack"
	desc = "A pack of 3 plushies."
	icon_state = "box"
	icon = 'code/modules/wod13/items.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 1 GRID_BOXES
	grid_height = 1 GRID_BOXES
	var/amount_left = 3 // amount of plushies that can be taken before it becomes an empty box

/obj/item/donator/plushie_box/examine(mob/user)
	. = ..()
	. += span_info("There are [amount_left] plushies in the box.")

/obj/item/donator/plushie_box/attack_self(mob/user)
	ui_interact(user)

/obj/item/donator/plushie_box/ui_interact(mob/user, datum/tgui/ui)
	if(!user.client || !user.client.prefs.donator)
		to_chat(user, span_notice("You must be a verified donator to use this item! If you have just donated, please run the ?verifydonator command in Discord and try again."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DonatorPlushieBox")
		ui.open()

/obj/item/donator/plushie_box/ui_data(mob/user)
	var/list/data = list()

	var/list/animals = list()
	animals += list(list(
		"type" = "/obj/item/toy/plush/carpplushie",
		"name" = initial(/obj/item/toy/plush/carpplushie::name),
		"desc" = initial(/obj/item/toy/plush/carpplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "map_plushie_carp"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/beeplushie",
		"name" = initial(/obj/item/toy/plush/beeplushie::name),
		"desc" = initial(/obj/item/toy/plush/beeplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "plushie_h"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/moth",
		"name" = initial(/obj/item/toy/plush/moth::name),
		"desc" = initial(/obj/item/toy/plush/moth::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "moffplush"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/shark",
		"name" = initial(/obj/item/toy/plush/shark::name),
		"desc" = initial(/obj/item/toy/plush/shark::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "blahaj"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/goatplushie",
		"name" = initial(/obj/item/toy/plush/goatplushie::name),
		"desc" = initial(/obj/item/toy/plush/goatplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "goat"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/slimeplushie",
		"name" = initial(/obj/item/toy/plush/slimeplushie::name),
		"desc" = initial(/obj/item/toy/plush/slimeplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "map_plushie_slime"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/rouny",
		"name" = initial(/obj/item/toy/plush/rouny::name),
		"desc" = initial(/obj/item/toy/plush/rouny::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "rouny"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/snakeplushie",
		"name" = initial(/obj/item/toy/plush/snakeplushie::name),
		"desc" = initial(/obj/item/toy/plush/snakeplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "map_plushie_snake"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/horse",
		"name" = initial(/obj/item/toy/plush/horse::name),
		"desc" = initial(/obj/item/toy/plush/horse::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "horse"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/unicorn",
		"name" = initial(/obj/item/toy/plush/unicorn::name),
		"desc" = initial(/obj/item/toy/plush/unicorn::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "unicorn"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/lizard_plushie",
		"name" = initial(/obj/item/toy/plush/lizard_plushie::name),
		"desc" = initial(/obj/item/toy/plush/lizard_plushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "map_plushie_lizard"), user, sourceonly = TRUE)
	))
	animals += list(list(
		"type" = "/obj/item/toy/plush/lizard_plushie/space",
		"name" = initial(/obj/item/toy/plush/lizard_plushie/space::name),
		"desc" = initial(/obj/item/toy/plush/lizard_plushie/space::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "map_plushie_spacelizard"), user, sourceonly = TRUE)
	))

	var/list/Space = list()

	Space += list(list(
		"type" = "/obj/item/toy/plush/human",
		"name" = initial(/obj/item/toy/plush/human::name),
		"desc" = initial(/obj/item/toy/plush/human::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "plushie_human"), user, sourceonly = TRUE)
	))
	Space += list(list(
		"type" = "/obj/item/toy/plush/pkplush",
		"name" = initial(/obj/item/toy/plush/pkplush::name),
		"desc" = initial(/obj/item/toy/plush/pkplush::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "pkplush"), user, sourceonly = TRUE)
	))
	Space += list(list(
		"type" = "/obj/item/toy/plush/abductor",
		"name" = initial(/obj/item/toy/plush/abductor::name),
		"desc" = initial(/obj/item/toy/plush/abductor::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "abductor"), user, sourceonly = TRUE)
	))
	Space += list(list(
		"type" = "/obj/item/toy/plush/abductor/agent",
		"name" = initial(/obj/item/toy/plush/abductor/agent::name),
		"desc" = initial(/obj/item/toy/plush/abductor/agent::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "abductor_agent"), user, sourceonly = TRUE)
	))

	var/list/unique = list()
	unique += list(list(
		"type" = "/obj/item/toy/plush/donkpocket",
		"name" = initial(/obj/item/toy/plush/donkpocket::name),
		"desc" = initial(/obj/item/toy/plush/donkpocket::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "donkpocket"), user, sourceonly = TRUE)
	))
	unique += list(list(
		"type" = "/obj/item/toy/plush/nukeplushie",
		"name" = initial(/obj/item/toy/plush/nukeplushie::name),
		"desc" = initial(/obj/item/toy/plush/nukeplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "plushie_nuke"), user, sourceonly = TRUE)
	))
	unique += list(list(
		"type" = "/obj/item/toy/plush/plasmamanplushie",
		"name" = initial(/obj/item/toy/plush/plasmamanplushie::name),
		"desc" = initial(/obj/item/toy/plush/plasmamanplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "plushie_pman"), user, sourceonly = TRUE)
	))
	unique += list(list(
		"type" = "/obj/item/toy/plush/bubbleplush",
		"name" = initial(/obj/item/toy/plush/bubbleplush::name),
		"desc" = initial(/obj/item/toy/plush/bubbleplush::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "bubbleplush"), user, sourceonly = TRUE)
	))
	unique += list(list(
		"type" = "/obj/item/toy/plush/ratplush",
		"name" = initial(/obj/item/toy/plush/ratplush::name),
		"desc" = initial(/obj/item/toy/plush/ratplush::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "plushvar"), user, sourceonly = TRUE)
	))
	unique += list(list(
		"type" = "/obj/item/toy/plush/narplush",
		"name" = initial(/obj/item/toy/plush/narplush::name),
		"desc" = initial(/obj/item/toy/plush/narplush::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "narplush"), user, sourceonly = TRUE)
	))
	unique += list(list(
		"type" = "/obj/item/toy/plush/awakenedplushie",
		"name" = initial(/obj/item/toy/plush/awakenedplushie::name),
		"desc" = initial(/obj/item/toy/plush/awakenedplushie::desc),
		"icon" = icon2html(icon('icons/obj/plushes.dmi', "plushie_awake"), user, sourceonly = TRUE)
	))
	unique += list(list(
		"type" = "/obj/item/toy/plush/tzi",
		"name" = initial(/obj/item/toy/plush/tzi::name),
		"desc" = initial(/obj/item/toy/plush/tzi::desc),
		"icon" = icon2html(icon('code/modules/wod13/items.dmi', "plushtzi"), user, sourceonly = TRUE)
	))

	data["categories"] = list(
		list(
			"key" = "animals",
			"label" = "Animals",
			"icon" = icon2html(icon('icons/obj/plushes.dmi', "blahaj"), user, sourceonly = TRUE),
			"pets" = animals
		),
		list(
			"key" = "Space",
			"label" = "Science Fiction",
			"icon" = icon2html(icon('icons/obj/plushes.dmi', "map_plushie_lizard"), user, sourceonly = TRUE),
			"pets" = Space
		),
		list(
			"key" = "unique",
			"label" = "Unique",
			"icon" = icon2html(icon('icons/obj/plushes.dmi', "plushie_awake"), user, sourceonly = TRUE),
			"pets" = unique
		)
	)
	return data

/obj/item/donator/plushie_box/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("choose_plushie")
			var/plushie_type = text2path(params["plushie_type"])
			var/location = get_turf(src)
			new plushie_type(location)
			if(amount_left > 1)
				amount_left -= 1
				visible_message(span_notice("You remove a plushie from the box. There are [amount_left] plushies left in the box."))
			else
				visible_message(span_warning("The box is now empty."))
				qdel(src)
				new /obj/item/storage/box/empty(location)

			return TRUE
