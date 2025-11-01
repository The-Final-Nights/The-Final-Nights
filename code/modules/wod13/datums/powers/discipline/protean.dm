/datum/discipline/protean
	name = "Protean"
	desc = "Lets your beast out, making you stronger and faster. Violates Masquerade."
	icon_state = "protean"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/protean

/datum/discipline_power/protean
	name = "Protean power name"
	desc = "Protean power description"

	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/protean_deactivate.ogg'
	var/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/GA

//handles shapeshifting and associated vars
/datum/discipline_power/protean/post_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_RETURNED_TO_FORM, PROC_REF(on_form_restored))

/datum/discipline_power/protean/proc/on_form_restored()
	SIGNAL_HANDLER
	if(GA)
		if(GA.shapeshift_type)
			GA.shapeshift_type = null

//EYES OF THE BEAST
/datum/discipline_power/protean/eyes_of_the_beast
	name = "Eyes of the Beast"
	desc = "Let your eyes be a gateway to your Beast. Gain its eyes."

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0
	violates_masquerade = FALSE

	toggled = TRUE
	var/original_eye_color


/datum/discipline_power/protean/eyes_of_the_beast/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_PROTEAN_VISION, TRAIT_GENERIC)
	owner.update_sight()
	original_eye_color = owner.eye_color
	owner.eye_color = "#ff0000"
	var/obj/item/organ/eyes/organ_eyes = owner.getorganslot(ORGAN_SLOT_EYES)
	if(!organ_eyes)
		return
	else
		organ_eyes.eye_color = owner.eye_color
	owner.update_body()

/datum/discipline_power/protean/eyes_of_the_beast/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_PROTEAN_VISION, TRAIT_GENERIC)
	owner.update_sight()
	owner.eye_color = original_eye_color
	var/obj/item/organ/eyes/organ_eyes = owner.getorganslot(ORGAN_SLOT_EYES)
	if(!organ_eyes)
		return
	else
		organ_eyes.eye_color = owner.eye_color
	owner.update_body()

//FERAL CLAWS
/datum/movespeed_modifier/protean2
	multiplicative_slowdown = -0.15

/datum/discipline_power/protean/feral_claws
	name = "Feral Claws"
	desc = "Become a predator and grow hideous talons."

	level = 2

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE
	vitae_cost = 1
	violates_masquerade = TRUE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/shape_of_the_beast,
		/datum/discipline_power/protean/mist_form
	)


/datum/discipline_power/protean/feral_claws/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))
	owner.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel(owner))
	owner.add_movespeed_modifier(/datum/movespeed_modifier/protean2)

/datum/discipline_power/protean/feral_claws/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/knife/gangrel/G in owner.contents)
		qdel(G)
	owner.remove_client_colour(/datum/client_colour/glass_colour/red)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/protean2)

//Depreciated. Still kept since think there's mobs of this that are spawned
/mob/living/simple_animal/hostile/gangrel
	name = "warform"
	desc = "A horrid man-beast abomination."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "gangrel_f"
	icon_living = "gangrel_f"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mob_size = MOB_SIZE_HUGE
	speak_chance = 0
	speed = -0.4
	maxHealth = 275
	health = 275
	butcher_results = list(/obj/item/stack/human_flesh = 10)
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 10
	maxbloodpool = 10
	dextrous = TRUE
	held_items = list(null, null)

/mob/living/simple_animal/hostile/gangrel/best
	icon_state = "gangrel_m"
	icon_living = "gangrel_m"
	maxHealth = 400 //More in line with new health values.
	health = 400
	melee_damage_lower = 40
	melee_damage_upper = 40
	speed = -0.8


//Earth Meld

/datum/discipline_power/protean/earth_meld
	name = "Earth Meld"
	desc = "Place yourself in the Earth."

	level = 3

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE
	vitae_cost = 1
	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 999 SCENES

	grouped_powers = list(
		/datum/discipline_power/protean/feral_claws,
		/datum/discipline_power/protean/shape_of_the_beast,
		/datum/discipline_power/protean/mist_form
	)

/datum/discipline_power/protean/earth_meld/activate()
	. = ..()
	var/obj/structure/bury_pit/burial_pit = new (get_turf(owner))
	burial_pit.icon_state = "pit1"
	owner.forceMove(burial_pit)

/datum/discipline_power/protean/earth_meld/deactivate()
	. = ..()
	var/meld_check = SSroll.storyteller_roll(owner.morality_path.score, difficulty = 6, mobs_to_show_output = owner, numerical = FALSE)
	switch(meld_check)
		if(ROLL_BOTCH)
			to_chat(owner, span_warning("Mother Earth calls you to its warm embrace..."))
			owner.torpor("Earth Meld")
			return FALSE
		if(ROLL_FAILURE)
			to_chat(owner, span_warning("YOU ARE UNABLE TO DIG YOURSELF OUT"))
			return FALSE
		if(ROLL_SUCCESS)
			owner.forceMove(get_turf(owner))
			return .
		else
			return FALSE

//SHAPE OF THE BEAST
/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel
	name = "Gangrel Form"
	desc = "Take on the shape a wolf."
	charge_max = 50
	cooldown_min = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = null
	possible_shapes = list(
		/mob/living/simple_animal/hostile/bear/wod13/vampire, \
		/mob/living/simple_animal/hostile/beastmaster/rat/flying/vampire, \
		/mob/living/simple_animal/hostile/shapeshift, \
		/mob/living/simple_animal/pet/dog/corgi, \
		/mob/living/simple_animal/hostile/shapeshift/wolf, \
		/mob/living/simple_animal/hostile/shapeshift/wolf/gray, \
		/mob/living/simple_animal/hostile/shapeshift/wolf/red, \
		/mob/living/simple_animal/hostile/shapeshift/wolf/white, \
		/mob/living/simple_animal/hostile/shapeshift/wolf/ginger, \
		/mob/living/simple_animal/hostile/shapeshift/wolf/brown, \
		/mob/living/simple_animal/hostile/shapeshift/dog, \
		/mob/living/simple_animal/hostile/shapeshift/dog/gray, \
		/mob/living/simple_animal/hostile/shapeshift/dog/red, \
		/mob/living/simple_animal/hostile/shapeshift/dog/white, \
		/mob/living/simple_animal/hostile/shapeshift/dog/ginger, \
		/mob/living/simple_animal/hostile/shapeshift/dog/brown, \
		/mob/living/simple_animal/hostile/shapeshift/bird/flying, \
		/mob/living/simple_animal/hostile/shapeshift/bird/flying/black, \
		/mob/living/simple_animal/hostile/shapeshift/bird/flying/white, \
		/mob/living/simple_animal/hostile/shapeshift/bird/flying/gray, \
		/mob/living/simple_animal/hostile/shapeshift/bird/flying/red, \
		/mob/living/simple_animal/hostile/shapeshift/cat, \
		/mob/living/simple_animal/hostile/shapeshift/cat/gray, \
		/mob/living/simple_animal/hostile/shapeshift/cat/brown, \
		/mob/living/simple_animal/hostile/shapeshift/cat/white, \
		/mob/living/simple_animal/hostile/shapeshift/cat/browntabby, \
		/mob/living/simple_animal/hostile/shapeshift/cat/graytabby, \
		/mob/living/simple_animal/hostile/shapeshift/cat/blacktabby
	)
	var/non_gangrel_shapes = list(
		/mob/living/simple_animal/hostile/beastmaster/rat/flying, \
		/mob/living/simple_animal/hostile/shapeshift/wolf
	)
	var/is_gangrel = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/cast(list/targets,mob/user = usr)
	if(src in user.mob_spell_list)
		LAZYREMOVE(user.mob_spell_list, src)
		user.mind.AddSpell(src)
	if(user.buckled)
		user.buckled.unbuckle_mob(src,force=TRUE)
	for(var/mob/living/M in targets)
		if(!shapeshift_type)
			var/list/animal_list = list()
			var/list/display_animals = list()
			if(!is_gangrel)
				for(var/path in non_gangrel_shapes)
					var/mob/living/simple_animal/animal = path
					animal_list[initial(animal.name)] = path
					var/image/animal_image = image(icon = initial(animal.icon), icon_state = initial(animal.icon_state))
					display_animals += list(initial(animal.name) = animal_image)
			else
				for(var/path in possible_shapes)
					var/mob/living/simple_animal/animal = path
					animal_list[initial(animal.name)] = path
					var/image/animal_image = image(icon = initial(animal.icon), icon_state = initial(animal.icon_state))
					display_animals += list(initial(animal.name) = animal_image)

			sort_list(display_animals)
			var/new_shapeshift_type = show_radial_menu(M, M, display_animals, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 38, require_near = TRUE)
			if(shapeshift_type)
				return
			shapeshift_type = new_shapeshift_type
			if(!shapeshift_type) //If you aren't gonna decide I am!
				shapeshift_type = pick(animal_list)
			shapeshift_type = animal_list[shapeshift_type]

		var/obj/shapeshift_holder/S = locate() in M
		if(S)
			M = Restore(M)
		else
			M = Shapeshift(M)

/datum/discipline_power/protean/shape_of_the_beast
	name = "Shape of the Beast"
	desc = "Assume the form of an animal and retain your power."

	level = 4

	check_flags = DISC_CHECK_CAPABLE
	vitae_cost = 1
	violates_masquerade = TRUE

	vitae_cost = 2

	cooldown_length = 20 SECONDS

	grouped_powers = list(
		/datum/discipline_power/protean/feral_claws,
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/mist_form
	)

/datum/discipline_power/protean/shape_of_the_beast/pre_activation_checks()
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_CURRENTLY_TRANSFORMING))
		to_chat(owner, span_warning("YOU ALREADY ARE TRANSFORMING!"))
		return FALSE
	else
		ADD_TRAIT(owner, TRAIT_CURRENTLY_TRANSFORMING, DISCIPLINE_TRAIT)
	to_chat(owner, span_warning("You begin transforming..."))
	if (do_after(owner, 6 SECONDS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM )))
		REMOVE_TRAIT(owner, TRAIT_CURRENTLY_TRANSFORMING, DISCIPLINE_TRAIT)
		return TRUE

/datum/discipline_power/protean/shape_of_the_beast/activate()
	. = ..()
	if (!GA)
		GA = new(owner)
	owner.drop_all_held_items()
	if(owner.clan?.name == CLAN_GANGREL)
		GA.is_gangrel = TRUE
	GA.cast(list(owner), owner)

//MIST FORM
/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/mist
	shapeshift_type = /mob/living/simple_animal/hostile/smokecrawler/mist

/mob/living/simple_animal/hostile/smokecrawler/mist
	name = "Mist"
	desc = "Levitating Spritz of Water."
	speed = 0
	alpha = 20
	damage_coeff = list(BRUTE = 0.5, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)

/datum/discipline_power/protean/mist_form
	name = "Mist Form"
	desc = "Dissipate your body and move as mist."

	level = 5

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	vitae_cost = 2
	violates_masquerade = TRUE
	cooldown_length = 20 SECONDS

	grouped_powers = list(
		/datum/discipline_power/protean/feral_claws,
		/datum/discipline_power/protean/earth_meld,
		/datum/discipline_power/protean/shape_of_the_beast
	)
	var/obj/effect/proc_holder/spell/targeted/shapeshift/gangrel/mist/GMA

/datum/discipline_power/protean/mist_form/pre_activation_checks()
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_CURRENTLY_TRANSFORMING))
		to_chat(owner, span_warning("YOU ALREADY ARE TRANSFORMING!"))
		return FALSE
	else
		ADD_TRAIT(owner, TRAIT_CURRENTLY_TRANSFORMING, DISCIPLINE_TRAIT)
	to_chat(owner, span_warning("You begin transforming..."))
	if (do_after(owner, 6 SECONDS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM )))
		REMOVE_TRAIT(owner, TRAIT_CURRENTLY_TRANSFORMING, DISCIPLINE_TRAIT)
		return TRUE

/datum/discipline_power/protean/mist_form/activate()
	. = ..()
	if (!GMA)
		GMA = new(owner)
	owner.drop_all_held_items()
	GMA.cast(list(owner), owner)
	if(GMA.myshape)
		ADD_TRAIT(GMA.myshape, TRAIT_PACIFISM, MAGIC_TRAIT)

//SHAPE MASTERY
/datum/discipline_power/protean/shape_mastery
	name = "Shape Mastery"
	desc = "Cause shapeshifters to revert to their natural form."

	level = 6

	check_flags = DISC_CHECK_CONSCIOUS
	target_type = TARGET_LIVING
	vitae_cost = 1
	violates_masquerade = FALSE

/datum/discipline_power/protean/shape_mastery/activate(mob/living/target)
	. = ..()
	var/obj/shapeshift_holder/shapeshift = locate() in target
	if(shapeshift)
		target = shapeshift.stored
		shapeshift.restore()
	if(iswerewolf(target) || isgarou(target))
		switch(target.client.prefs.auspice.breed_form)
			if("Homid")
				target.transformator.transform(target, "Homid", TRUE)
			if("Lupus")
				target.transformator.transform(target, "Lupus", TRUE)
			if("Crinos")
				target.transformator.transform(target, "Crinos", TRUE)
			if("Corvid")
				target.transformator.transform(target, "Corvid", TRUE)
			if("Corax Crinos")
				target.transformator.transform(target, "Corax Crinos", TRUE)
/*		addtimer(CALLBACK(target, TYPE_PROC_REF(mob/living, transformation_unblock)), 60 SECONDS)
		to_chat(target, span_userdanger("You feel your abilities suddenly drain. You can't transform!"))
		target.transformation_blocked = TRUE*/ //Uncomment when the Hunter PR is merged, since this relies on some additions from that PR.
/datum/discipline_power/protean/shape_mastery/post_gain()
	. = ..()
	owner.physiology.brute_mod *= 0.5 //Flesh of Marble 6th dot trait.
