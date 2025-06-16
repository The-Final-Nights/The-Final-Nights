/datum/discipline/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	power_type = /datum/discipline_power/auspex

/datum/discipline_power/auspex
	name = "Auspex power name"
	desc = "Auspex power description"

	activate_sound = 'code/modules/wod13/sounds/auspex.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/auspex_deactivate.ogg'

//HEIGHTENED SENSES
/datum/discipline_power/auspex/heightened_senses
	name = "Heightened Senses"
	desc = "Enhances your senses far past human limitations."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

	toggled = TRUE

/datum/discipline_power/auspex/heightened_senses/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC)

	owner.update_sight()

/datum/discipline_power/auspex/heightened_senses/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC)

	owner.update_sight()

//AURA PERCEPTION
/datum/discipline_power/auspex/aura_perception
	name = "Aura Perception"
	desc = "Allows you to perceive the auras of those near you."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

	toggled = TRUE

/datum/discipline_power/auspex/aura_perception/activate()
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.add_hud_to(owner)

	owner.see_invisible = OBFUSCATE_INVISIBILITY

	owner.update_sight()

/datum/discipline_power/auspex/aura_perception/deactivate()
	. = ..()
	var/datum/atom_hud/abductor_hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	abductor_hud.remove_hud_from(owner)

	owner.see_invisible = SEE_INVISIBLE_LIVING

	owner.update_sight()

//THE SPIRIT'S TOUCH
/datum/discipline_power/auspex/the_spirits_touch
	name = "The Spirit's Touch"
	desc = "Allows you to feel the physical wellbeing of those near you."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

	toggled = TRUE

/datum/discipline_power/auspex/the_spirits_touch/activate()
	. = ..()

	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.add_hud_to(owner)

	owner.auspex_examine = TRUE

	owner.update_sight()

/datum/discipline_power/auspex/the_spirits_touch/deactivate()
	. = ..()

	var/datum/atom_hud/health_hud = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	health_hud.remove_hud_from(owner)

	owner.auspex_examine = FALSE

	owner.update_sight()

//sobs loudly
//rework me
/atom/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/Z = user
		if(Z.auspex_examine)
			if(!isturf(src) && !isobj(src) && !ismob(src))
				return
			var/list/fingerprints = list()
			var/list/blood = return_blood_DNA()
			var/list/fibers = return_fibers()
			var/list/reagents = list()

			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				if(!H.gloves)
					fingerprints += md5(H.dna.uni_identity)

			else if(!ismob(src))
				fingerprints = return_fingerprints()


				if(isturf(src))
					var/turf/T = src
					// Only get reagents from non-mobs.
					if(T.reagents && T.reagents.reagent_list.len)

						for(var/datum/reagent/R in T.reagents.reagent_list)
							T.reagents[R.name] = R.volume

							// Get blood data from the blood reagent.
							if(istype(R, /datum/reagent/blood))

								if(R.data["blood_DNA"] && R.data["blood_type"])
									var/blood_DNA = R.data["blood_DNA"]
									var/blood_type = R.data["blood_type"]
									LAZYINITLIST(blood)
									blood[blood_DNA] = blood_type
				if(isobj(src))
					var/obj/T = src
					// Only get reagents from non-mobs.
					if(T.reagents && T.reagents.reagent_list.len)

						for(var/datum/reagent/R in T.reagents.reagent_list)
							T.reagents[R.name] = R.volume

							// Get blood data from the blood reagent.
							if(istype(R, /datum/reagent/blood))

								if(R.data["blood_DNA"] && R.data["blood_type"])
									var/blood_DNA = R.data["blood_DNA"]
									var/blood_type = R.data["blood_type"]
									LAZYINITLIST(blood)
									blood[blood_DNA] = blood_type

			// We gathered everything. Create a fork and slowly display the results to the holder of the scanner.

			var/found_something = FALSE

			// Fingerprints
			if(length(fingerprints))
				to_chat(user, "<span class='info'><B>Prints:</B></span>")
				for(var/finger in fingerprints)
					to_chat(user, "[finger]")
				found_something = TRUE

			// Blood
			if (length(blood))
				to_chat(user, "<span class='info'><B>Blood:</B></span>")
				found_something = TRUE
				for(var/B in blood)
					to_chat(user, "Type: <font color='red'>[blood[B]]</font> DNA (UE): <font color='red'>[B]</font>")

			//Fibers
			if(length(fibers))
				to_chat(user, "<span class='info'><B>Fibers:</B></span>")
				for(var/fiber in fibers)
					to_chat(user, "[fiber]")
				found_something = TRUE

			//Reagents
			if(length(reagents))
				to_chat(user, "<span class='info'><B>Reagents:</B></span>")
				for(var/R in reagents)
					to_chat(user, "Reagent: <font color='red'>[R]</font> Volume: <font color='red'>[reagents[R]]</font>")
				found_something = TRUE

			if(!found_something)
				to_chat(user, "<I># No forensic traces found #</I>") // Don't display this to the holder user
			return

//TELEPATHY
/datum/discipline_power/auspex/telepathy
	name = "Telepathy"
	desc = "Project your thoughts into the mind of another."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS
	target_type = TARGET_LIVING
	vitae_cost = 0
	cooldown_length = 15 SECONDS
	range = 7

/datum/discipline_power/auspex/telepathy/activate(mob/living/target)
	. = ..()
	var/input_message = tgui_input_text(owner, "What message will you project to them?", encode = FALSE)
	if (!input_message)
		return

	//sanitisation!
	input_message = STRIP_HTML_SIMPLE(input_message, MAX_MESSAGE_LEN)
	if(CHAT_FILTER_CHECK(input_message))
		to_chat(owner, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[input_message]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	log_directed_talk(owner, input_message, LOG_SAY, "[name]")
	to_chat(owner, span_notice("You project your thoughts into [target]'s mind: [input_message]"))
	to_chat(target, span_boldannounce("You hear a voice in your head... [input_message]"))


//PSYCHIC PROJECTION
/datum/discipline_power/auspex/psychic_projection
	name = "Psychic Projection"
	desc = "Leave your body behind and fly across the land."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 1

/datum/discipline_power/auspex/psychic_projection/activate()
	. = ..()
	owner.enter_avatar()
	owner.soul_state = SOUL_PROJECTING
