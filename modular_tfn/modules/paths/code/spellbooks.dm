/obj/item/path_spellbook
	name = "Path Spellbook"
	desc = "A default path spellbook. if you're seeing this ingame, please report to coders"
	icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	icon_state = "spellbook"
	var/path_type = null
	var/path_level = 1
	var/do_after_time = 300 // 30 seconds
	var/activate_sound = 'modular_tfn/modules/paths/sounds/open_book.wav'
	var/deactivate_sound = 'modular_tfn/modules/paths/sounds/close_book.wav'
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'

	// Identification system
	var/identified = FALSE
	var/true_name = ""
	var/true_desc = ""

/obj/item/path_spellbook/Initialize(mapload)
	. = ..()
	if(!identified)
		true_name = name
		true_desc = desc
		name = "dusty forgotten tome"
		desc = "This book is covered in dust and the pages appear worn. Its probably not important."

/obj/item/path_spellbook/examine(mob/user)
	. = ..()
	if(!identified)
		. += span_notice("You could try to <b>clean</b> off the dust to see what lies beneath.")

/obj/item/path_spellbook/attack_self(mob/living/carbon/human/user)

	if(!identified)
		if(do_after(user, 5 SECONDS))
			to_chat(user, span_cult("You wipe the dust off the previously irrelevant tome. Did someone misplace it from the Library?"))
			src.identified = TRUE
			name = true_name
			desc = true_desc
			return

	var/is_knowing = FALSE
	var/datum/species/kindred/species = user.dna.species
	var/datum/discipline/existing_path_discipline = null

	if(!path_type)
		to_chat(user, span_warning("This spellbook appears to be incomplete!"))
		return

	if(istype(species, /datum/species/kindred))
		if(!HAS_TRAIT(user, TRAIT_THAUMATURGY_KNOWLEDGE))
			to_chat(user, span_warning("You must have knowledge of Thaumaturgy to use this book!"))
			return
		else
			for(var/datum/action/discipline/D in user.actions)
				if(D.discipline)
					//Checking if the discipline is the same as the path_type
					if(D.discipline.type == path_type)
						existing_path_discipline = D.discipline
						is_knowing = TRUE
						//Then we check if the level can be learned
						if(path_level == existing_path_discipline.level)
							// User already knows this level
							to_chat(user, span_warning("You already know this book!"))
							return
						else if(path_level == existing_path_discipline.level + 1)
							// The book's level is one higher than the user's current level
							user.playsound_local(user, activate_sound, 50, FALSE)
						else if (path_level > existing_path_discipline.level + 1)
							// The book's level is too high for the user to learn
							to_chat(user, span_warning("You must learn the previous book(s) first!"))
							return
						else if (path_level < existing_path_discipline.level)
							// The book's level is lower than the user's current level
							to_chat(user, span_warning("You already know a higher level of this path!"))
							return
			// If we reach here, the user does not know this path at all
			if(path_level > 1 && !is_knowing)
				to_chat(user, span_warning("You must know the first level of this path before you can learn higher levels!"))
				return
			else if(path_level == 1 && !is_knowing)
				user.playsound_local(user, activate_sound, 50, FALSE)
	else
		to_chat(user, span_warning("You must be a Kindred to use this spellbook!"))
		return

	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-opened"
	update_appearance()

	to_chat(user, span_notice("You begin studying the ancient texts..."))

	if(do_after(user, do_after_time, target = src))
		// Now checking the level again to assign the correct path level
		if(!is_knowing)
			var/datum/discipline/new_discipline = new path_type(path_level)
			species.disciplines += new_discipline
			var/datum/action/discipline/path/path_action = new /datum/action/discipline/path(new_discipline)
			path_action.Grant(user)
			to_chat(user, span_notice("The knowledge of [name] flows into your mind!"))
		else
			// If the user already knows the path, update the level
			to_chat(user, span_notice("You have increased your knowledge of [name]!"))

			// Remove the old discipline entirely
			species.disciplines -= existing_path_discipline

			// create list of old actions associated w/ existing_path_discipline
			var/list/actions_to_remove = list()
			for(var/datum/action/discipline/path/action in user.actions)
				if(action.discipline == existing_path_discipline)
					actions_to_remove += action

			// remove old actions
			for(var/datum/action/discipline/path/old_action in actions_to_remove)
				old_action.Remove(user)

			// create just a completely new discipline at the new path level
			var/datum/discipline/new_discipline = new path_type(path_level)
			species.disciplines += new_discipline

			// create a new action associated with the new discipline
			var/datum/action/discipline/path/new_action = new /datum/action/discipline/path(new_discipline)
			new_action.Grant(user)

		user.playsound_local(user, deactivate_sound, 50, FALSE)
		qdel(src)
	else
		icon_state = original_icon_state
		update_appearance()
		to_chat(user, span_warning("Your concentration was broken!"))

// Lure of Flames Spellbooks
/obj/item/path_spellbook/lure_of_flames
	name = "Lure of Flames Spellbook"
	desc = "A tome containing the secrets of manipulating fire through blood magic."
	icon_state = "flames_spellbook"
	path_type = /datum/discipline/path/flames

/obj/item/path_spellbook/lure_of_flames/level1
	name = "Lure of Flames Spellbook (Level I)"
	desc = "A basic tome teaching the fundamentals of fire manipulation."
	path_level = 1

/obj/item/path_spellbook/lure_of_flames/level2
	name = "Lure of Flames Spellbook (Level II)"
	desc = "An intermediate tome revealing deeper secrets of flame control."
	path_level = 2

/obj/item/path_spellbook/lure_of_flames/level3
	name = "Lure of Flames Spellbook (Level III)"
	desc = "An advanced tome containing dangerous fire magic techniques."
	path_level = 3

/obj/item/path_spellbook/lure_of_flames/level4
	name = "Lure of Flames Spellbook (Level IV)"
	desc = "A master-level tome with devastating flame powers."
	path_level = 4

/obj/item/path_spellbook/lure_of_flames/level5
	name = "Lure of Flames Spellbook (Level V)"
	desc = "The ultimate tome of fire mastery, containing the most powerful flame techniques."
	path_level = 5

// Levinbolt Spellbooks
/obj/item/path_spellbook/levinbolt
	name = "Levinbolt Spellbook"
	desc = "A tome containing the secrets of channeling lightning through blood magic."
	icon_state = "levinbolt_spellbook"
	path_type = /datum/discipline/path/levinbolt

/obj/item/path_spellbook/levinbolt/level1
	name = "Levinbolt Spellbook (Level I)"
	desc = "A basic tome teaching the fundamentals of lightning manipulation."
	path_level = 1

/obj/item/path_spellbook/levinbolt/level2
	name = "Levinbolt Spellbook (Level II)"
	desc = "An intermediate tome revealing deeper secrets of electrical control."
	path_level = 2

/obj/item/path_spellbook/levinbolt/level3
	name = "Levinbolt Spellbook (Level III)"
	desc = "An advanced tome containing dangerous lightning magic techniques."
	path_level = 3

/obj/item/path_spellbook/levinbolt/level4
	name = "Levinbolt Spellbook (Level IV)"
	desc = "A master-level tome with devastating electrical powers."
	path_level = 4

/obj/item/path_spellbook/levinbolt/level5
	name = "Levinbolt Spellbook (Level V)"
	desc = "The ultimate tome of lightning mastery, containing the most powerful electrical techniques."
	path_level = 5

/obj/item/occult_book
	name = "Occult Book"
	desc = "A default occult book. if you're seeing this ingame, please report to coders"
	icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	icon_state = "spellbook"
	var/do_after_time = 300 // 30 seconds
	var/activate_sound = 'modular_tfn/modules/paths/sounds/open_book.wav'
	var/deactivate_sound = 'modular_tfn/modules/paths/sounds/close_book.wav'
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'

	// research vars overriden by subtypes
	var/research_value = 10
	var/last_study_time = 0
	var/study_cooldown = 30 MINUTES
	var/study_research_value = 50
	var/required_trait = TRAIT_THAUMATURGY_KNOWLEDGE
	var/no_trait_message = "The text is incomprehensible to you without the proper knowledge."
	var/cooldown_message = "You have recently studied this tome extensively. You need %TIME% more minutes before you can gain further insight from it."
	var/study_start_message = "You begin studying the occult text..."
	var/study_interrupted_message = "Your concentration was broken. You failed to absorb any meaningful knowledge from the text."
	var/research_gain_message = "You gain %POINTS% research points from studying this tome!"

	// Flavor texts, must be overriden by subtypes
	var/list/study_flavor_texts = list(
		"You study the arcane text, gaining insight into occult mysteries.",
		"Ancient knowledge flows from the pages into your mind.",
		"The text reveals secrets of supernatural power and ritual."
	)

/obj/item/occult_book/attack_self(mob/living/carbon/human/user)
	if(!can_study(user))
		return ..()

	if(!check_cooldown(user))
		return

	begin_study(user)
	return ..()

/obj/item/occult_book/proc/can_study(mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, required_trait))
		to_chat(user, span_warning(no_trait_message))
		return FALSE
	return TRUE

/obj/item/occult_book/proc/check_cooldown(mob/living/carbon/human/user)
	if(last_study_time && world.time < last_study_time + study_cooldown)
		var/time_remaining = ((last_study_time + study_cooldown) - world.time) / 10 / 60
		var/formatted_message = replacetext(cooldown_message, "%TIME%", "[round(time_remaining, 0.1)]")
		to_chat(user, span_warning(formatted_message))
		return FALSE
	return TRUE

/obj/item/occult_book/proc/begin_study(mob/living/carbon/human/user)
	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-opened"
	update_appearance()

	to_chat(user, span_notice(study_start_message))
	user.playsound_local(user, activate_sound, 50, FALSE)

	if(do_after(user, do_after_time, target = src))
		complete_study(user)
	else
		to_chat(user, span_warning(study_interrupted_message))

	icon_state = original_icon_state
	update_appearance()

/obj/item/occult_book/proc/complete_study(mob/living/carbon/human/user)
	user.research_points += study_research_value
	var/flavor_text = pick(study_flavor_texts)
	to_chat(user, span_cult(flavor_text))

	var/formatted_message = replacetext(research_gain_message, "%POINTS%", "[study_research_value]")
	to_chat(user, span_green(formatted_message))

	last_study_time = world.time
	user.playsound_local(user, deactivate_sound, 50, FALSE)

/obj/item/occult_book/veneficorum_artum_sanguis
	name = "Veneficorum Artum Sanguis"
	desc = "To the untrained eyes of Mortals and unknowing Kindred, this book appears to be some manner of Latin text, but those Kindred who truly know the history of the Tremere recognize the author - Inner Councilman Etrius of the Tremere. The Veneficorum - as it is called by most Magi of the Tremere, is the oldest and most foundational work of Thaumaturgical inquiry known to the Tremere, and chronicles the early experiments and exploits in the developments of Thaumaturgy. The work is thorough and explicit in its explanation of many procedures, rituals, and concepts of how to use Blood Magic. The Tremere guard all copies of this work extremely jealously - as they fear that any Kindred in posession of this work may use it to learn Thaumaturgy. This book is EXTREMELY RARE, with only a dozen or so copies ever being made of the original tome from Vienna."
	research_value = 50
	last_study_time = 0
	study_cooldown = 30 MINUTES
	study_research_value = 100
	icon_state = "veneficorum"
	study_flavor_texts = list(
		"You delve into Etrius's detailed explanations of blood manipulation, gaining deeper insight into the fundamental principles of Thaumaturgy.",
		"The ancient text reveals secrets of ritual preparation and the proper channeling of vitae through arcane and Hermetic formulae.",
		"You study the meticulously documented experiments on blood manipulation, understanding the precise movements and incantations required.",
		"The Veneficorum details the hierarchical structure of Thaumaturgical power, explaining how the Tremere maintain their mystical dominance - such is the way of a Clan with power unmatched, and envied by all.",
		"Ancient diagrams and formulae illuminate the connection between mortal blood and supernatural power, expanding your understanding of the Art.",
		"You absorb Etrius's warnings about the dangers of improper blood magic, learning from the failures and catastrophes of early practitioners.",
		"The text describes the creation of blood-based wards and protective circles, knowledge jealously guarded by the Tremere hierarchy.",
		"You study the philosophical underpinnings of Thaumaturgy, understanding how will, blood, and ancient knowledge combine to reshape reality.",
		"The book reveals the historical development of various Thaumaturgical paths, each built upon centuries of experimentation and refinement.",
		"Ancient Latin passages describe the transformation of the Tremere from mortal mages to vampiric masters of blood sorcery.",
		"Multiple passages detail the conflicts the Tremeres faced from all sides - their 'siege mentality' lasting to this day. Attacked on all sides by the Lupines, the Tzimisce, the Nosferatu, the Gangrel, and yet, the power of Thaumaturgy was our salvation. We must protect it at all costs.",
		"'Go forth, young student, master the blood, master the will, study under your senior Magi, and bend reality to your will. Transcend. Evolve. Ensure the survival of our kind. Innovate. Expand. Conquer.' - A final note from Etrius at the end of this work"
	)



/obj/item/occult_book/das_tiefe_geheimnis
	name = "Das Tiefe Geheimnis"
	desc = "Das Tiefe Geheimnis - this copy is an English translation, titled 'The Dark Secret'. The most common musings on blood magic Hermeticism, this book was written by Johann Kloepfer, a member of the Cologne Chantry, in the 15th century. Found in nearly every major Chantry, and studied at least once by virtually every Tremere, this book lays the foundation for the most common Paths (Blood and Lure of Flames), Rituals, and Principles of Thaumaturgy. Unfortunately, this work is known to have several glaring errors in its descriptions of some of the most common rituals, making the work useful only in a supplemental capacity. Many Tremere believe Kloepfer placed these ommissions intentionally to safeguard the art of Thaumaturgy from non-Tremere. Most copies, including this one, are littered with copious hand-written notes and corrections added by members over the centuries."
	research_value = 20
	last_study_time = 0
	study_cooldown = 15 MINUTES
	study_research_value = 50
	icon_state = "tiefe"
	study_flavor_texts = list(
		"You study Kloepfer's foundational explanations of the Path of Blood, cross-referencing the handwritten corrections in the margins.",
		"The text details the basic principles of the Lure of Flames, though you notice several deliberate omissions that have been filled in by later scholars.",
		"You examine the fundamental rituals described by Kloepfer, noting where centuries of Tremere have added their own insights and corrections.",
		"The book's exploration of Hermetic principles provides a solid foundation, despite the intentional errors you've learned to identify.",
		"Marginal notes from previous readers reveal the true incantations behind Kloepfer's deliberately obscured ritual descriptions.",
		"You study the basic ward creation techniques, comparing Kloepfer's original text with the extensive annotations added over the centuries.",
		"The fundamental theory of vitae manipulation becomes clearer as you cross-reference the original text with generations of scholarly corrections.",
		"Kloepfer's discussion of Thaumaturgical hierarchy and apprenticeship provides insight into traditional Tremere teaching methods.",
		"You decipher the intentionally cryptic passages about blood transmutation, aided by the copious notes left by previous students.",
		"The text's exploration of basic protective circles and ritual preparation gives you a better grasp of foundational Thaumaturgy.",
		"Annotations reveal the true nature of several 'errors' in Kloepfer's work, showing how the author protected Tremere secrets from outsiders.",
		"You study the relationship between will, blood, and incantation as described in this cornerstone work of Thaumaturgical literature."
	)
