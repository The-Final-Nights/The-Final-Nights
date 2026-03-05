// Donator pets!
// For now it's just cats dogs and birds. Maybe it will always be cats dogs birds. I dunno.
// Donators are identified via the prefs.donator bool

/mob/living/simple_animal/pet
	can_be_held = TRUE

// Dogs
/mob/living/simple_animal/pet/dog
	name = "\improper dog"
	desc = "A loyal companion! They need lots of attention, but will love you unconditionally."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "dog"
	icon_living = "dog"
	icon_dead = "dog_dead"
	speak = list("Woof!","Woof?","Woof.","Woof woof!","Ruff!","Grrr!","Woof woof?","Ruff?","Grrr?")
	speak_emote = list("woofs")
	emote_hear = list("woofs.")
	emote_see = list("wags its tail happily.","looks up at you with adoring eyes.","hops around excitedly.","lets out a happy bark.","rolls over playfully.")

// Birds
/mob/living/simple_animal/pet/bird
	name = "\improper black bird"
	desc = "Adorable! They make such a racket though."
	icon = 'code/modules/wod13/corax_corvid.dmi'
	icon_state = "black"
	icon_living = "black"
	icon_dead = "spiralblack_rest"
	gender = PLURAL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!","Chirp!","Cheeps!","Brrr!","Chirrup?","Cheep?","Chirp?","Cheeps?","Brrr?")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps.")
	emote_see = list("pecks at the ground.","flaps its wings.","tilts its head curiously.","hops around.","chirps loudly.","looks around.","hops around in a small circle.")
	density = FALSE
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1) //taaaahstts liiiike chiiiickun... -roi
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	health = 3
	maxHealth = 3
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	pet_bonus = TRUE
	pet_bonus_emote = "chirps!"
	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/pet/bird/Initialize()
	. = ..()
	resize = 0.75 //so theyre distinguishable from corax despite using the sprite
	update_transform()

/mob/living/simple_animal/pet/bird/white
	name = "\improper white bird"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	icon_state = "white"
	icon_living = "white"
	icon_dead = "spiralwhite_rest"

/mob/living/simple_animal/pet/bird/gray
	name = "\improper gray bird"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	icon_state = "gray"
	icon_living = "gray"
	icon_dead = "spiralgray_rest"

/mob/living/simple_animal/pet/bird/red
	name = "\improper red bird"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	icon_state = "red"
	icon_living = "red"
	icon_dead = "spiralred_rest"

/mob/living/simple_animal/pet/bird/green
	name = "\improper green bird"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	icon_state = "green"
	icon_living = "green"
	icon_dead = "spiralgreen_rest"

/mob/living/simple_animal/pet/bird/brown
	name = "\improper brown bird"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	icon_state = "brown"
	icon_living = "brown"
	icon_dead = "spiralbrown_rest"

/mob/living/simple_animal/pet/bird/bat
	name = "\improper bat"
	desc = "A cute little bat! It looks like it could be a pet, but it might be a little high maintenance."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"

// Cats
/mob/living/simple_animal/pet/cat/vampire/black
	icon = 'code/modules/wod13/mobs.dmi'
	bloodpool = 2
	maxbloodpool = 2
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat1"

/mob/living/simple_animal/pet/cat/vampire/gray
	icon = 'code/modules/wod13/mobs.dmi'
	bloodpool = 2
	maxbloodpool = 2
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat2"

/mob/living/simple_animal/pet/cat/vampire/brown
	icon = 'code/modules/wod13/mobs.dmi'
	bloodpool = 2
	maxbloodpool = 2
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat3"

/mob/living/simple_animal/pet/cat/vampire/white
	icon = 'code/modules/wod13/mobs.dmi'
	bloodpool = 2
	maxbloodpool = 2
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat4"

/mob/living/simple_animal/pet/cat/vampire/tabby
	icon = 'code/modules/wod13/mobs.dmi'
	bloodpool = 2
	maxbloodpool = 2
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat5"

/mob/living/simple_animal/pet/cat/vampire/bw
	icon = 'icons/mob/pets.dmi'
	bloodpool = 2
	maxbloodpool = 2
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat"

/obj/item/donator/pet_crate
	name = "pet crate"
	desc = "Unveil your favorite pet!"
	icon = 'icons/obj/pet_carrier.dmi'
	icon_state = "pet_carrier_closed"

/obj/item/donator/pet_crate/attack_self(mob/user)
	ui_interact(user)

/obj/item/donator/pet_crate/ui_interact(mob/user, datum/tgui/ui)
	if(!user.client || !user.client.prefs.donator)
		to_chat(user, span_notice("You must be a verified donator to use this item! If you have just donated, please run the ?verifydonator command in Discord and try again."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DonatorPetCrate")
		ui.open()

/obj/item/donator/pet_crate/ui_data(mob/user)
	var/list/data = list()

	var/list/dogs = list()
	dogs += list(list(
		"type" = "/mob/living/simple_animal/pet/dog",
		"name" = "Dog",
		"desc" = initial(/mob/living/simple_animal/pet/dog::desc),
		"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "dog"), user, sourceonly = TRUE)
	))
	dogs += list(list(
		"type" = "/mob/living/simple_animal/pet/dog/corgi",
		"name" = "Corgi",
		"desc" = initial(/mob/living/simple_animal/pet/dog/corgi::desc),
		"icon" = icon2html(icon('icons/mob/pets.dmi', "corgi"), user, sourceonly = TRUE)
	))
	dogs += list(list(
		"type" = "/mob/living/simple_animal/pet/dog/bullterrier",
		"name" = "Bull Terrier",
		"desc" = initial(/mob/living/simple_animal/pet/dog/bullterrier::desc),
		"icon" = icon2html(icon('icons/mob/pets.dmi', "bullterrier"), user, sourceonly = TRUE)
	))
	dogs += list(list(
		"type" = "/mob/living/simple_animal/pet/dog/pug",
		"name" = "Pug",
		"desc" = initial(/mob/living/simple_animal/pet/dog/pug::desc),
		"icon" = icon2html(icon('icons/mob/pets.dmi', "pug"), user, sourceonly = TRUE)
	))
	dogs += list(list(
		"type" = "/mob/living/simple_animal/pet/dog/corgi/puppy",
		"name" = "Corgi Puppy",
		"desc" = initial(/mob/living/simple_animal/pet/dog/corgi/puppy::desc),
		"icon" = icon2html(icon('icons/mob/pets.dmi', "puppy"), user, sourceonly = TRUE)
	))

	var/list/cats = list()
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat/vampire/bw",
		"name" = "B&W Cat",
		"desc" = initial(/mob/living/simple_animal/pet/cat/vampire/bw::desc),
		"icon" = icon2html(icon('icons/mob/pets.dmi', "cat"), user, sourceonly = TRUE)
	))
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat/vampire/black",
		"name" = "Black Cat",
		"desc" = initial(/mob/living/simple_animal/pet/cat/vampire/black::desc),
		"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "cat1"), user, sourceonly = TRUE)
	))
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat/vampire/gray",
		"name" = "Gray Cat",
		"desc" = initial(/mob/living/simple_animal/pet/cat/vampire/gray::desc),
		"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "cat2"), user, sourceonly = TRUE)
	))
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat/vampire/brown",
		"name" = "Brown Cat",
		"desc" = initial(/mob/living/simple_animal/pet/cat/vampire/brown::desc),
		"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "cat3"), user, sourceonly = TRUE)
	))
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat/vampire/white",
		"name" = "White Cat",
		"desc" = initial(/mob/living/simple_animal/pet/cat/vampire/white::desc),
		"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "cat4"), user, sourceonly = TRUE)
	))
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat/vampire/tabby",
		"name" = "Tabby Cat",
		"desc" = initial(/mob/living/simple_animal/pet/cat/vampire/tabby::desc),
		"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "cat5"), user, sourceonly = TRUE)
	))
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat",
		"name" = "Calico Cat",
		"desc" = initial(/mob/living/simple_animal/pet/cat::desc),
		"icon" = icon2html(icon('icons/mob/pets.dmi', "cat2"), user, sourceonly = TRUE)
	))
	cats += list(list(
		"type" = "/mob/living/simple_animal/pet/cat/kitten",
		"name" = "Calico Kitten",
		"desc" = initial(/mob/living/simple_animal/pet/cat/kitten::desc),
		"icon" = icon2html(icon('icons/mob/pets.dmi', "kitten"), user, sourceonly = TRUE)
	))

	var/list/birds = list()
	birds += list(list(
		"type" = "/mob/living/simple_animal/pet/bird",
		"name" = "Black Bird",
		"desc" = initial(/mob/living/simple_animal/pet/bird::desc),
		"icon" = icon2html(icon('code/modules/wod13/corax_corvid.dmi', "black"), user, sourceonly = TRUE)
	))
	birds += list(list(
		"type" = "/mob/living/simple_animal/pet/bird/white",
		"name" = "White Bird",
		"desc" = initial(/mob/living/simple_animal/pet/bird::desc),
		"icon" = icon2html(icon('code/modules/wod13/corax_corvid.dmi', "white"), user, sourceonly = TRUE)
	))
	birds += list(list(
		"type" = "/mob/living/simple_animal/pet/bird/gray",
		"name" = "Gray Bird",
		"desc" = initial(/mob/living/simple_animal/pet/bird::desc),
		"icon" = icon2html(icon('code/modules/wod13/corax_corvid.dmi', "gray"), user, sourceonly = TRUE)
	))
	birds += list(list(
		"type" = "/mob/living/simple_animal/pet/bird/red",
		"name" = "Red Bird",
		"desc" = initial(/mob/living/simple_animal/pet/bird::desc),
		"icon" = icon2html(icon('code/modules/wod13/corax_corvid.dmi', "red"), user, sourceonly = TRUE)
	))
	birds += list(list(
		"type" = "/mob/living/simple_animal/pet/bird/green",
		"name" = "Green Bird",
		"desc" = initial(/mob/living/simple_animal/pet/bird::desc),
		"icon" = icon2html(icon('code/modules/wod13/corax_corvid.dmi', "green"), user, sourceonly = TRUE)
	))
	birds += list(list(
		"type" = "/mob/living/simple_animal/pet/bird/brown",
		"name" = "Brown Bird",
		"desc" = initial(/mob/living/simple_animal/pet/bird::desc),
		"icon" = icon2html(icon('code/modules/wod13/corax_corvid.dmi', "brown"), user, sourceonly = TRUE)
	))
	birds += list(list(
		"type" = "/mob/living/simple_animal/pet/bird/bat",
		"name" = "Bat",
		"desc" = initial(/mob/living/simple_animal/pet/bird/bat::desc),
		"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "bat"), user, sourceonly = TRUE)
	))

	data["categories"] = list(
		list(
			"key" = "dogs",
			"label" = "Dogs",
			"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "dog"), user, sourceonly = TRUE),
			"pets" = dogs
		),
		list(
			"key" = "cats",
			"label" = "Cats",
			"icon" = icon2html(icon('code/modules/wod13/mobs.dmi', "cat1"), user, sourceonly = TRUE),
			"pets" = cats
		),
		list(
			"key" = "birds",
			"label" = "Birds",
			"icon" = icon2html(icon('code/modules/wod13/corax_corvid.dmi', "white"), user, sourceonly = TRUE),
			"pets" = birds
		)
	)
	return data

/obj/item/donator/pet_crate/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("choose_pet")
			var/pet_type = text2path(params["pet_type"])
			var/location = get_turf(src)
			visible_message(span_warning("\The [src] springs open!"))
			new pet_type(location)
			visible_message(span_notice("A [name] hops out of the crate!"))
			new /obj/item/pet_carrier(location) //swap out the fake crate for a real one
			to_chat(usr, span_notice("You have received a [pet_type]! Use the collar to name your pet!"))
			new /obj/item/clothing/neck/petcollar(location)
			qdel(src)
			return TRUE
