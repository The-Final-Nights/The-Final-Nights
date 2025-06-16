/obj/item/arcane_tome
	name = "arcane tome"
	desc = "The secrets of Blood Magic..."
	icon_state = "arcane"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	is_magic = TRUE
	var/list/rituals = list()

/obj/item/arcane_tome/Initialize()
	. = ..()
	for(var/i in subtypesof(/obj/ritualrune))
		if(i)
			var/obj/ritualrune/R = new i(src)
			rituals |= R

/obj/item/arcane_tome/attack_self(mob/user)
	. = ..()
	for(var/obj/ritualrune/R in rituals)
		if(R)
			if(R.sacrifices.len > 0)
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
				to_chat(user, "[R.thaumlevel] [R.name] - [R.desc] Requirements: [required_list].")
			else
				to_chat(user, "[R.thaumlevel] [R.name] - [R.desc]")

/obj/ritualrune
	name = "Tremere Rune"
	desc = "Learn the secrets of blood, neonate..."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rune1"
	color = rgb(128,0,0)
	anchored = TRUE
	var/word = "IDI NAH"
	var/activator_bonus = 0
	var/activated = FALSE
	var/mob/living/last_activator
	var/thaumlevel = 1
	var/list/sacrifices = list()

/obj/ritualrune/proc/complete()
	return

/obj/ritualrune/attack_hand(mob/user)
	if(!activated)
		var/mob/living/L = user
		if(L.thaumaturgy_knowledge)
			L.say(word)
			L.Immobilize(30)
			last_activator = user
			activator_bonus = L.thaum_damage_plus


			// (Optionally a rune animation to glow brighter)
			animate(src, color = rgb(255, 64, 64), time = 10)


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

/obj/ritualrune/AltClick(mob/user)
	..()
	qdel(src)

// **************************************************************** SELF GIB *************************************************************

/obj/ritualrune/selfgib
	name = "Self Destruction"
	desc = "Meet the Final Death."
	icon_state = "rune2"
	word = "CHNGE DA'WORD, GDBE"

/obj/ritualrune/selfgib/complete()
	last_activator.death()

// **************************************************************** BLOOD GUARDIAN *************************************************************

/obj/ritualrune/blood_guardian
	name = "Blood Guardian"
	desc = "Creates the Blood Guardian to protect tremere or his domain."
	icon_state = "rune1"
	word = "UR'JOLA"
	thaumlevel = 3

/obj/ritualrune/blood_guardian/complete()
	var/mob/living/carbon/human/H = last_activator
	if(!length(H.beastmaster))
		var/datum/action/beastmaster_stay/E1 = new()
		E1.Grant(last_activator)
		var/datum/action/beastmaster_deaggro/E2 = new()
		E2.Grant(last_activator)
	var/mob/living/simple_animal/hostile/beastmaster/blood_guard/BG = new(loc)
	BG.beastmaster = last_activator
	H.beastmaster |= BG
	BG.my_creator = last_activator
	BG.melee_damage_lower = BG.melee_damage_lower+activator_bonus
	BG.melee_damage_upper = BG.melee_damage_upper+activator_bonus
	playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
	if(length(H.beastmaster) > 3+H.mentality)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(H.beastmaster)
		B.death()
	qdel(src)

/mob/living/simple_animal/hostile/beastmaster/blood_guard
	name = "blood guardian"
	desc = "A clot of blood in humanoid form."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "blood_guardian"
	icon_living = "blood_guardian"
	del_on_death = 1
	healable = 0
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	speed = 0
	maxHealth = 110
	health = 110

	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	speak_emote = list("gnashes")

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(CLAN_TREMERE)
	bloodpool = 1
	maxbloodpool = 1

// **************************************************************** BLOOD TRAP *************************************************************

/obj/ritualrune/blood_trap
	name = "Blood Trap"
	desc = "Creates the Blood Trap to protect tremere or his domain."
	icon_state = "rune2"
	word = "DUH'K-A'U"

/obj/ritualrune/blood_trap/complete()
	if(!activated)
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		activated = TRUE
		alpha = 28

/obj/ritualrune/blood_trap/Crossed(atom/movable/AM)
	..()
	if(isliving(AM) && activated)
		var/mob/living/L = AM
		L.adjustFireLoss(50+activator_bonus)
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		qdel(src)

// **************************************************************** BLOODWALL *************************************************************

/obj/ritualrune/blood_wall
	name = "Blood Wall"
	desc = "Creates the Blood Wall to protect tremere or his domain."
	icon_state = "rune3"
	word = "SOT'PY-O"
	thaumlevel = 2

/obj/ritualrune/blood_wall/complete()
	new /obj/structure/bloodwall(loc)
	playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
	qdel(src)

/obj/structure/bloodwall
	name = "blood wall"
	desc = "Wall from BLOOD."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "bloodwall"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	max_integrity = 100

// **************************************************************** WHY IS THIS IN PYRAMID.DM *************************************************************

/obj/structure/fleshwall
	name = "flesh wall"
	desc = "Wall from FLESH."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "fleshwall"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	max_integrity = 100

/obj/structure/tzijelly
	name = "jelly thing"
	desc = "an important part of the meat matrix."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "tzijelly"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	density = TRUE
	max_integrity = 100

// **************************************************************** ARTIFACT IDENTIFICATION *************************************************************

/obj/ritualrune/identification
	name = "Identification Rune"
	desc = "Identifies a single occult item."
	icon_state = "rune4"
	word = "IN'DAR"

/obj/ritualrune/identification/complete()
	for(var/obj/item/vtm_artifact/VA in loc)
		if(VA)
			VA.identificate()
			playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			qdel(src)
			return

// **************************************************************** QUESTION TO THE ANCESTORS *************************************************************

/obj/ritualrune/question
	name = "Question to the Ancestors Rune"
	desc = "Summon souls from the dead. Ask a question and get answers. Requires a bloodpack."
	icon_state = "rune5"
	word = "VOCA-ANI'MA"
	thaumlevel = 3
	sacrifices = list(/obj/item/reagent_containers/blood)

/mob/living/simple_animal/hostile/ghost/tremere
	maxHealth = 1
	health = 1
	melee_damage_lower = 1
	melee_damage_upper = 1
	faction = list(CLAN_TREMERE)

/obj/ritualrune/question/complete()
	var/text_question = tgui_input_text(usr, "Enter your question to the Ancestors:", "Question to Ancestors")
	visible_message("<span class='notice'>A call rings out to the dead from the [src.name] rune...</span>")
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to answer a question? (You are allowed to spread meta information) The question is : [text_question]", null, null, null, 20 SECONDS, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, span_ghostalert("Question rune has been triggered."))
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		var/mob/living/simple_animal/hostile/ghost/tremere/TR = new(loc)
		TR.key = C.key
		TR.name = C.name
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		qdel(src)
	else
		visible_message(span_notice("No one answers the [src.name] rune's call."))


// **************************************************************** TELEPORT *************************************************************

/obj/ritualrune/teleport
	name = "Teleportation Rune"
	desc = "Move your body among the city streets. Requires a bloodpack."
	icon_state = "rune6"
	word = "CLAV'TRANSITUM"
	thaumlevel = 5
	sacrifices = list(/obj/item/reagent_containers/blood)

/obj/ritualrune/teleport/complete()
	if(!activated)
		activated = TRUE
		color = rgb(255,255,255)
		icon_state = "teleport"

/obj/ritualrune/teleport/attack_hand(mob/user)
	..()
	if(activated)
		if(last_activator != user)
			to_chat(user, span_warning("You are not the one who activated this rune!"))
			return
		var/direction = tgui_input_list(user, "Choose direction:", "Teleportation Rune", list("North", "East", "South", "West"))
		if(direction)
			var/x_dir = user.x
			var/y_dir = user.y
			var/step = 1
			var/min_distance = 10
			var/max_distance = 20
			var/valid_destination = FALSE
			var/turf/destination = null

			if(get_dist(src, user) > 1)
				to_chat(user, span_warning("You moved away from the rune!"))
				return

			// Move at least min_distance tiles in the chosen direction
			while(step <= min_distance)
				switch(direction)
					if("North")
						y_dir += 1
					if("East")
						x_dir += 1
					if("South")
						y_dir -= 1
					if("West")
						x_dir -= 1
				step += 1

			// Continue moving until a valid destination is found or max_distance is reached
			while(step <= max_distance && !valid_destination)
				switch(direction)
					if("North")
						y_dir += 1
					if("East")
						x_dir += 1
					if("South")
						y_dir -= 1
					if("West")
						x_dir -= 1

				if(x_dir < 15 || x_dir > 240 || y_dir < 15 || y_dir > 240)
					to_chat(user, span_warning("You can't teleport outside the city!"))
					return

				destination = locate(x_dir, y_dir, user.z)
				if(destination && !istype(destination, /turf/open/space/basic) && !istype(destination, /turf/closed/wall/vampwall))
					valid_destination = TRUE
				else
					step += 1

			if(valid_destination)
				playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
				user.forceMove(destination)
				qdel(src)
			else
				to_chat(user, span_warning("The spell fails as no destination is found!"))


// **************************************************************** CURSE RUNE AKA BLOODCURSE *************************************************************

/obj/ritualrune/curse
	name = "Curse Rune"
	desc = "Curse your enemies from afar. Place multiple hearts on the rune to increase the curse duration."
	icon_state = "rune7"
	word = "MAL'DICTO-SANGUINIS"
	thaumlevel = 5
	sacrifices = list() //checking for number of hearts in the function
	var/channeling = FALSE
	var/mob/living/channeler = null
	var/curse_target = null

/obj/ritualrune/curse/complete()
	if(!activated)
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		color = rgb(255,0,0)
		activated = TRUE

/obj/ritualrune/curse/attack_hand(mob/user)
	if(!activated)
		var/mob/living/L = user
		if(L.thaumaturgy_knowledge)
			L.say(word)
			L.Immobilize(30)
			last_activator = user
			activator_bonus = L.thaum_damage_plus
			animate(src, color = rgb(255, 64, 64), time = 10)
			complete()
			addtimer(CALLBACK(src, PROC_REF(start_curse), user), 1 SECONDS)
		return

	// If already activated but not channeling, allow restarting
	if(!channeling && last_activator == user)
		start_curse(user)
		return

	// only the activator can use the activated rune
	if(last_activator != user)
		to_chat(user, span_warning("You are not the one who activated this rune!"))
		return

	// check if already channeling
	if(channeling)
		to_chat(user, span_warning("The curse is already being channeled!"))
		return

/obj/ritualrune/curse/proc/start_curse(mob/user)
	if(!user || !activated || channeling)
		return

	// Count heart sacrifices
	var/list/hearts = list()
	for(var/obj/item/organ/heart/H in get_turf(src))
		hearts += H

	// at least one heart for the ritual
	if(hearts.len == 0)
		to_chat(user, span_warning("You need at least one heart to channel the curse!"))
		return

	// target name input
	var/target_name = tgui_input_text(user, "Choose target name:", "Curse Rune")
	if(!target_name || !user.Adjacent(src)) // Check if user is still nearby
		to_chat(user, span_warning("You must specify a target and remain close to the rune!"))
		return

	// begin channeling
	curse_target = target_name
	channeler = user
	channeling = TRUE

	// Begin the curse ritual
	to_chat(user, span_warning("You begin channeling dark energy through [hearts.len] heart[hearts.len > 1 ? "s" : ""]..."))
	channel_curse(hearts)
	do_after(hearts.len * 5)

/obj/ritualrune/curse/proc/channel_curse(list/hearts)
	if(!channeling || !channeler || !curse_target)
		return

	if(!hearts.len)
		to_chat(channeler, span_warning("No more hearts remain for the ritual!"))
		channeling = FALSE
		qdel(src)
		return

	if(!channeler.Adjacent(src))
		to_chat(channeler, span_warning("The curse ritual has been interrupted because you moved away!"))
		channeling = FALSE
		return

	// Take the first heart
	var/obj/item/organ/heart/heart = hearts[1]
	if(!heart || QDELETED(heart) || heart.loc != get_turf(src))
		hearts -= heart
		if(hearts.len > 0)
			channel_curse(hearts) // Skip this heart and continue
		else
			to_chat(channeler, span_warning("The curse ritual has ended as no valid hearts remain!"))
			channeling = FALSE
			qdel(src)
		return

	hearts -= heart

	// Apply visual effects
	playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 25, FALSE)
	animate(src, color = rgb(255, 0, 0), time = 1.5)
	animate(color = rgb(128, 0, 0), time = 1.5)

	// Find the target and apply damage
	var/found_target = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name == curse_target)
			found_target = TRUE
			H.adjustCloneLoss(25)
			playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			to_chat(H, span_warning("You feel dark energy tearing at your very being!"))
			H.Stun(2) // Brief stun each pulse
			break

	if(!found_target)
		to_chat(channeler, span_warning("There is no one by that name in the city!"))
		channeling = FALSE
		qdel(heart)
		return

	// Consume the heart
	qdel(heart)

	// Display feedback
	to_chat(channeler, span_warning("A heart is consumed by the ritual. [hearts.len] heart[hearts.len != 1 ? "s" : ""] remain[hearts.len != 1 ? "" : "s"]."))

	// If we still have hearts, continue the channel
	if(hearts.len > 0)
		// After 4 seconds, process the next heart
		channeler.visible_message(span_warning("[channeler.name] continues channeling dark energy into the rune!"))

		addtimer(CALLBACK(src, PROC_REF(channel_curse), hearts), 4 SECONDS)
	else
		// after using all hearts
		to_chat(channeler, span_warning("The last heart is consumed, completing the curse ritual!"))
		channeling = FALSE
		qdel(src)

// **************************************************************** BLOOD TO WATER *************************************************************


/obj/ritualrune/blood_to_water
	name = "Blood To Water"
	desc = "Purges all blood in range into the water."
	icon_state = "rune8"
	word = "CL-ENE"

/obj/ritualrune/blood_to_water/complete()
	for(var/atom/A in range(7, src))
		if(A)
			A.wash(CLEAN_WASH)
	qdel(src)


// **************************************************************** GARGOYLE TRANSFORMATION *************************************************************


/obj/ritualrune/gargoyle
	name = "Gargoyle Transformation"
	desc = "Create a Gargoyle from vampire bodies. One body creates a normal Gargoyle, two bodies create a perfect Gargoyle."
	icon_state = "rune9"
	word = "FORMA-GARGONEM"
	thaumlevel = 5
	var/duration_length = 60 SECONDS

/obj/ritualrune/gargoyle/complete()
	// vampire bodies only
	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/H in loc)
		if(H && H.dna && istype(H.dna.species, /datum/species/kindred))
			if(H == usr)
				to_chat(usr, span_warning("You may not turn yourself into a Gargoyle!"))
				return
			else if(H.clane?.name == CLAN_GARGOYLE)
				to_chat(usr, span_warning("You may not use this ritual on a Gargoyle!"))
				return
			else if(H.stat > SOFT_CRIT)
				valid_bodies += H
			else
				H.adjustCloneLoss(50)
				playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 10, FALSE)
				to_chat(usr, "Your specimen must be incapacitated! The ritual has merely hurt them!")
				return


	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("The ritual requires at least one vampire body!"))
		return

	// Begin the ritual
	var/body_count = valid_bodies.len
	to_chat(usr, span_notice("You begin invoking the ritual of Gargoyle Creation with [body_count] vampire bod[body_count == 1 ? "y" : "ies"]..."))
	usr.visible_message(span_notice("[usr] begins invoking a ritual with [body_count] vampire bod[body_count == 1 ? "y" : "ies"]..."))

	playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
	playsound(loc, 'code/modules/wod13/sounds/vicissitude.ogg', 50, FALSE)

	// Apply stun so that they cant just crawl away in crit - caster must also stay still
	for(var/mob/living/carbon/human/H in valid_bodies)
		H.Stun(600)
		H.emote("twitch")

	// Start the transformation process
	if(do_after(usr, duration_length, usr))
		activated = TRUE
		last_activator = usr

		// Determine if we're creating a perfect gargoyle (2+ bodies) or regular (1 body)
		var/perfect_gargoyle = (body_count >= 2)

		var/transformation_message
		if(perfect_gargoyle)
			transformation_message = span_gargoylealert("The bodies begin to merge and petrify into a massive stone form!")
		else
			transformation_message = span_gargoylealert("The body begins to petrify into a stone form!")
		visible_message(transformation_message)

		// Complete the transformation
		addtimer(CALLBACK(src, PROC_REF(gargoyle_transform), valid_bodies, perfect_gargoyle), 1 SECONDS)
	else
		to_chat(usr, span_warning("Your ritual was interrupted!"))
		// Unstun the bodies if interrupted
		for(var/mob/living/carbon/human/H in valid_bodies)
			H.Stun(5) // Brief stun to recover

/obj/ritualrune/gargoyle/proc/gargoyle_transform(list/bodies, perfect_gargoyle = FALSE)
	if(!bodies || bodies.len < 1)
		return

	if(perfect_gargoyle)
		// Create perfect gargoyle (2+ bodies) -- you'd have to frag two different kindred players to create a perfect gargoyle.
		var/mob/living/simple_animal/hostile/gargoyle/perfect/G = new /mob/living/simple_animal/hostile/gargoyle/perfect(loc)
		G.visible_message(span_gargoylealert("A massive perfect Gargoyle rises from the ritual!"))

		// Ensure perfect gargoyle is at full health
		G.revive(TRUE)
		G.health = G.maxHealth
		G.apply_status_effect(STATUS_EFFECT_INLOVE, usr)

		// Handle the other bodies
		for(var/mob/living/carbon/human/H in bodies)
			if(!QDELETED(H))
				for(var/datum/action/A in H.actions)
					if(A && A.vampiric)
						A.Remove(H)

				H.gib(FALSE, FALSE, TRUE)

		// This function asks the ghosts and observers if theyd like to control the perfect Gargoyle. No clue why it's named that or what it stands for. It's from tzimisce.dm.
		G.gain_sentience()

		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		playsound(loc, 'code/modules/wod13/sounds/vicissitude.ogg', 50, FALSE)
	else
		// Create normal sentient gargoyle (1 body)
		var/mob/living/carbon/human/target_body = bodies[1]
		var/old_name = target_body.real_name

		// Transform the body into a gargoyle
		if(!target_body || QDELETED(target_body) || target_body.stat > DEAD)
			return

		// Remove any vampiric actions
		for(var/datum/action/A in target_body.actions)
			if(A && A.vampiric)
				A.Remove(target_body)

		var/original_location = get_turf(target_body)

		// Revive the specimen and turn them into a gargoyle kindred
		target_body.revive(TRUE)
		target_body.set_species(/datum/species/kindred)
		target_body.clane = new /datum/vampireclane/gargoyle()
		target_body.clane.on_gain(target_body)
		target_body.clane.post_gain(target_body)
		target_body.apply_status_effect(STATUS_EFFECT_INLOVE, usr)
		target_body.real_name = old_name // the ritual for some reason is deleting their old name and replacing it with a random name.
		target_body.name = old_name
		target_body.update_name()

		target_body.create_disciplines(FALSE, target_body.clane.clane_disciplines)

		if(target_body.loc != original_location)
			target_body.forceMove(original_location)

		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		playsound(target_body.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 50, FALSE)

		// Handle key assignment
		if(!target_body.key)
			var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to play as Sentient Gargoyle?", null, null, null, 20 SECONDS, src)
			for(var/mob/dead/observer/G in GLOB.player_list)
				if(G.key)
					to_chat(G, span_ghostalert("Gargoyle Transformation rune has been triggered."))
			if(LAZYLEN(candidates))
				var/mob/dead/observer/C = pick(candidates)
				target_body.key = C.key

			var/choice = tgui_alert(target_body, "Do you want to pick a new name as a Gargoyle?", "Gargoyle Choose Name", list("Yes", "No"), 10 SECONDS)
			if(choice == "Yes")
				var/chosen_gargoyle_name = tgui_input_text(target_body, "What is your new name as a Gargoyle?", "Gargoyle Name Input")
				target_body.real_name = chosen_gargoyle_name
				target_body.name = chosen_gargoyle_name
				target_body.update_name()
			else
				target_body.visible_message(span_gargoylealert("A Gargoyle rises from the ritual!"))
				qdel(src)
				return

		target_body.visible_message(span_gargoylealert("A Gargoyle rises from the ritual!"))

	qdel(src)

// Perfect Gargoyle definition
/mob/living/simple_animal/hostile/gargoyle/perfect
	name = "Perfect Gargoyle"
	desc = "A massive stone-skinned monstrosity with enhanced strength and durability."
	icon_state = "gargoyle_m"
	icon_living = "gargoyle_m"
	mob_size = MOB_SIZE_LARGE
	speed = -2
	maxHealth = 600
	health = 600
	harm_intent_damage = 8
	melee_damage_lower = 35
	melee_damage_upper = 60
	attack_verb_continuous = "brutally crushes"
	attack_verb_simple = "brutally crush"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	bloodpool = 15
	maxbloodpool = 15

/mob/living/simple_animal/hostile/gargoyle/perfect/Initialize()
	. = ..()
	// Make the perfect gargoyle slightly larger
	transform = transform.Scale(1.10, 1.10)




// **************************************************************** DEFLECTION OF THE WOODEN DOOM *************************************************************

//Deflection of the Wooden Doom ritual
//Protects you from being staked for a single hit. Is it useful? Marginally. But it is a level 1 rite.
/obj/ritualrune/deflection_stake
	name = "Deflection of the Wooden Doom"
	desc = "Shield your heart and splinter the enemy stake. Requires a stake."
	icon_state = "rune7"
	word = "Splinter, shatter, break the wooden doom."
	thaumlevel = 1
	sacrifices = list(/obj/item/vampire_stake)

/obj/ritualrune/deflection_stake/complete()
	for(var/mob/living/carbon/human/H in loc)
		if(H)
			if(!HAS_TRAIT(H, TRAIT_STAKE_RESISTANT))
				ADD_TRAIT(H, TRAIT_STAKE_RESISTANT, MAGIC_TRAIT)
				qdel(src)
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		color = rgb(255,0,0)
		activated = TRUE


// **************************************************************** BLOODWALK *************************************************************

/obj/ritualrune/bloodwalk
	name = "Blood Walk"
	desc = "Trace the subject's lineage from a blood syringe."
	icon_state = "rune7"
	word = "Reveal thy bloodline for mine eyes."
	thaumlevel = 2

/obj/ritualrune/bloodwalk/attack_hand(mob/user)
	for(var/obj/item/reagent_containers/syringe/S in loc)
		if(S)
			for(var/datum/reagent/blood/B in S.reagents.reagent_list)
				if(B)
					if(B.type == /datum/reagent/blood)
						var/blood_data = B.data
						if(blood_data)
							var/generation = blood_data["generation"]
							var/clan = blood_data["clan"]
							var/message = generate_message(generation, clan)
							to_chat(user, "[message]")
						else
							to_chat(user, "The blood speaks not-it is empty of power!")
					else
						to_chat(user, "This reagent is lifeless, unworthy of the ritual!")
		playsound(loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
		color = rgb(255,0,0)
		activated = TRUE
		qdel(src)

/obj/ritualrune/bloodwalk/proc/generate_message(generation, clan)
	var/message = ""

	switch(generation)
		if(4)
			message += "The blood is incredibly ancient and powerful! It must be from an ancient Methuselah!\n"
		if(5)
			message += "The blood is incredibly ancient and powerful! It must be from a Methuselah!\n"
		if(6)
			message += "The blood is incredibly ancient and powerful! It must be from an Elder!\n"
		if(7, 8, 9)
			message += "The blood is powerful. It must come from an Ancilla or Elder!\n"
		if(10, 11)
			message += "The blood is of middling strength. It must come from someone young.\n"
		if(12, 13)
			message += "The blood is of waning strength. It must come from a neonate.\n"
		else
			if(generation >= 14)
				message += "This is the vitae of a thinblood!\n"

	//clan
	switch(clan)
		if(CLAN_TOREADOR, CLAN_DAUGHTERS_OF_CACOPHONY)
			message += "The blood is sweet and rich. The owner must, too, be beautiful.\n"
		if(CLAN_VENTRUE)
			message += "The blood has kingly power in it, descending from Mithras or Hardestadt.\n"
		if(CLAN_LASOMBRA)
			message += "Cold and dark, this blood has a mystical connection to the Abyss.\n"
		if(CLAN_TZIMISCE)
			message += "The vitae is mutable and twisted. Is there any doubt to the cursed line it belongs to?\n"
		if(CLAN_OLD_TZIMISCE)
			message += "This vitae is old and ancient. It reminds you of a more twisted and cursed blood...\n"
		if(CLAN_GANGREL)
			message += "The blood emits a primal and feral aura. The same is likely of the owner.\n"
		if(CLAN_MALKAVIAN)
			message += "You can sense chaos and madness within this blood. It's owner must be maddened too.\n"
		if(CLAN_BRUJAH)
			message += "The blood is filled with passion and anger. So must be the owner of the blood.\n"
		if(CLAN_NOSFERATU)
			message += "The blood is foul and disgusting. Same must apply to the owner.\n"
		if(CLAN_TREMERE)
			message += "The blood is filled with the power of magic. The owner must be a thaumaturge.\n"
		if(CLAN_BAALI)
			message += "Tainted and corrupt. Vile and filthy. You see your reflection in the blood, but something else stares back.\n"
		if("Assamite")
			message += "Potent... deadly... and cursed. You know well the curse laid by Tremere on the assassins.\n"
		if(CLAN_TRUE_BRUJAH)
			message += "The blood is cold and static... It's hard to feel any emotion within it.\n"
		if(CLAN_SALUBRI)
			message += "The cursed blood of the Salubri! The owner of this blood must be slain.\n"
		if(CLAN_SALUBRI_WARRIOR)
			message += "The avatar of Samiel's vengeance stands before you, do you dare return their bitter hatred?\n"
		if(CLAN_GIOVANNI, CLAN_CAPPADOCIAN)
			message += "The blood is very cold and filled with death. The owner must be a necromancer.\n"
		if(CLAN_KIASYD)
			message += "The blood is filled with traces of fae magic.\n"
		if(CLAN_GARGOYLE)
			message += "The blood of our stone servants.\n"
		if(CLAN_SETITES)
			message += "Seduction and allure are in the blood. Ah, one of the snakes.\n"
		if(CLAN_NAGARAJA)
			message += "This blood has an unsettling hunger to it, cold and stained with death.\n"
		else
			message += "The blood's origin is hard to trace. Perhaps it is one of the clanless?\n"

	return message

