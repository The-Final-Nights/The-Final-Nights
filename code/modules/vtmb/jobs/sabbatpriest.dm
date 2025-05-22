/datum/job/vamp/sabbatpriest
	title = "Sabbat Priest"
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Caine"
	selection_color = "#7B0000"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/sabbatpriest
	allowed_species = list("Vampire")
	exp_type_department = EXP_TYPE_SABBAT
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	paycheck_department = ACCOUNT_CIV

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	v_duty = "You are the Sabbat Priest. You are charged with the supervision of the ritae of your pack. You also serve as the second-in-command to the Ductus. Consecrate the Vaulderie for new Sabbat, consult your tome for rites to aid your pack, and ensure the Sabbat live on in Caine's favor.  <br> <b> NOTE: BY PLAYING THIS ROLE YOU AGREE TO AND HAVE READ THE SERVER'S RULES ON ESCALATION FOR ANTAGS. KEEP THINGS INTERESTING AND ENGAGING FOR BOTH SIDES. KILLING PLAYERS JUST BECAUSE YOU CAN MAY RESULT IN A ROLEBAN. "
	duty = "Down with the Camarilla. Down with the Elders. Down with the Jyhad! The Kindred are the true rulers of Earth, blessed by Caine, the Dark Father."
	minimal_masquerade = 0
	allowed_bloodlines = list("Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Ministry", "Lasombra", "Gargoyle", "Tzimisce", "Baali")
	display_order = JOB_DISPLAY_ORDER_SABBATPRIEST
	whitelisted = TRUE

/datum/outfit/job/sabbatpriest
	name = "Sabbat Priest"
	jobtype = /datum/job/vamp/sabbatpriest
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	r_pocket = /obj/item/vamp/keys/sabbat




/datum/outfit/job/sabbatpriest/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
	if(H.clane)
		if(H.clane.name == "Lasombra")
			backpack_contents = list(/obj/item/passport =1, /obj/item/vamp/creditcard=1)
	if(!H.clane)
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.clane && H.clane.name != "Lasombra")
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist/sabbatpriest)


/obj/effect/landmark/start/sabbatpriest
	name = "Sabbat Priest"
	icon_state = "Assistant"


/datum/antagonist/sabbatist/sabbatpriest
	name = "Sabbatist"
	roundend_category = "sabbattites"
	antagpanel_category = FACTION_SABBAT
	job_rank = ROLE_REV
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev_head"

/datum/antagonist/sabbatist/sabbatductus/New()
	..()
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev_head"

/datum/antagonist/sabbatist/sabbatpriest/on_gain()
	add_antag_hud(ANTAG_HUD_REV, "rev_head", owner.current)
	owner.special_role = src
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, use_reverb = FALSE)
	return ..()

/obj/sabbatrune
	name = "Monomacy Rune"
	desc = "Monomacy is the rite of resolving disputes among pack mates. Challenge that curr to a duel!"
	icon = 'icons/effects/crayondecal.dmi'
	icon_state = "rune4"
	color = rgb(64, 64, 64)
	anchored = TRUE
	var/activated = FALSE
	var/mob/living/last_activator
	var/list/sacrifices = list()
	var/challenge_cooldown = FALSE
	var/cooldown_duration = 600 SECONDS // 10 minute cooldown between challenges

/obj/sabbatrune/attack_hand(mob/living/user)
	. = ..()

	// Check if user is a sabbatist, ductus, or priest
	if(!is_sabbatist(user))
		to_chat(user, span_warning("You do not understand the power of this rune."))
		return

	if(challenge_cooldown)
		to_chat(user, span_warning("The rune is still cooling down from the last challenge."))
		return

	last_activator = user
	issue_challenge(user)

/obj/sabbatrune/proc/is_sabbatist(mob/living/user)

	return user.mind && (user.mind.has_antag_datum(/datum/antagonist/sabbatist))

/obj/sabbatrune/proc/issue_challenge(mob/living/challenger)
	// Ask for the name of the player to challenge
	var/challenged_name = tgui_input_text(challenger, "Enter the name of the person you wish to challenge to Monomacy:", "Monomacy Challenge")
	if(!challenged_name)
		return

	// Find the target based on the provided name
	var/mob/living/target = null
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		// if the target is not dead, is the challenger isnt targeting themselves, if the target is a sabbatist, and if one of the name datums match the name input
		if(H.stat != DEAD && H != challenger && is_sabbatist(H) && (findtext(H.real_name, challenged_name) || findtext(H.name, challenged_name)))
			target = H

	if(!target)
		to_chat(challenger, span_cult("Could not find anyone with that name to challenge! Only members of the Sabbat may engage in Monomacy."))
		return


	// Notify the challenger
	to_chat(challenger, span_cult("You have challenged [target.real_name] to a duel of Monomacy!"))
	SEND_SOUND(challenger, sound('code/modules/wod13/sounds/announce.ogg'))

	// Notify the target
	to_chat(target, span_cult("[challenger.real_name] challenges you to a duel of Monomacy! Return to the lair at once!"))
	SEND_SOUND(target, sound('code/modules/wod13/sounds/announce.ogg'))

	// Announce the challenge to everyone nearby
	for(var/mob/M in viewers(7, src))
		if(M != challenger && M != target)
			to_chat(M, span_cult("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy!"))
			SEND_SOUND(M, sound('code/modules/wod13/sounds/announce.ogg'))

	// Notify the priest
	for(var/mob/living/carbon/human/priest in GLOB.player_list)
		if(priest.mind.has_antag_datum(/datum/antagonist/sabbatist/sabbatpriest))
			to_chat(priest, span_cult("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy! Return to the lair at once to ensure Caine's will is done."))
			SEND_SOUND(priest, sound('code/modules/wod13/sounds/announce.ogg'))

	// Visual and audio effects for the rune itself
	animate(src, color = rgb(192, 192, 192), time = 2) // Flash to a brighter gray
	animate(color = rgb(64, 64, 64), time = 3) // Return to original color
	playsound(src, 'sound/magic/smoke.ogg', 20, TRUE)

	// Set cooldown
	challenge_cooldown = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown_duration)

	// Log the challenge
	log_game("[key_name(challenger)] has challenged [key_name(target)] to Monomacy via sabbatrune.")


/obj/sabbatrune/proc/reset_cooldown()
	challenge_cooldown = FALSE

/obj/item/sabbat_priest_tome
	name = "Sabbat Priest's Tome"
	desc = "A tome adorned with the symbol of the Sabbat."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "sabbat-tome"

	//Ritae descriptions
	var/pack_credo = "We are the Sword of Caine. We do not bow to the Masquerade. We are not slaves to the Elders, nor tools of the Antediluvians. Through blood and fire, we bring about Gehenna. We act not in secrecy, but in strength, united as one Pack. Death to traitors. Death to tyrants. Caine wills it."
	var/vaulderie_info = "The Vaulderie is a ritual by which a vinculum is established among a pack. It establishes a low level, communal blood bond among its participants. It severs blood bonds, reminding all Cainites to be free from the Elders who usurped Caine. Perform this ritual via the Vaulderie Goblet or Silver Goblet. Each member must drip their vitae into the cup, which is then shared among all participants.\n"
	var/shovelhead_info = "The Creation Rites we are often slandered for. A Cainite makes their way into the True Sabbat by conquering their fear of fire and death in our lair, walking straight through our campfire. In times of desperation, however, and especially if we feel the need to embrace en masse, we may use the 'shovelhead method', embracing new Cainites and digging them into a shallow grave, awakening their frenzy, their Beast, their true nature... \n"
	var/monomacy_info = "The Rite of Monomacy is a rite which calls two Sabbat Cainites to duel when they may not settle their dispute peacefully or rationally. The challenger uses the Monomacy Circle Rune located within our lair to call the challenged to combat, where the challenged may accept, or decline, the duel. The Priest must decide whether or not the dispute is worthy of monomacy. The challenged Cainite gets to decide the terms of the duel, such as weapons, disciplines allowed or not, torpor or final death, and location... The Priest has ultimate power of the ritae, and the pack, always, and may declare certain duels as null and void.\n"
	var/bloodbath_info = "The Rite of the Blood Bath is the rite by which the Priest may select a new Ductus, usually taking place after the previous Ductus was challenged to Monomacy. Each Sabbat Cainite who wishes to serve the new Ductus approaches our bathtub, and contributes a large amount of vitae using the ritual knife. The new Ductus then bathes in the blood of the pack which recognizes them, and upon exiting the bathtub, the Priest is to scoop up the blood in a Vaulderie Goblet, for all to drink of, consecrating the new Pack formation's vinculum. \n"
	var/war_party_hunt_info = "The Ritus of the War Party may be invoked by using the War Party totem, fashioned from an Elder Cainite's skull. Its dark power calls upon all who have taken part of the Vaulderie in the city to return to our lair to discuss plans for a War Party,  where we may strike at the heretics, the pretenders, and the cowards who hide behind the Masquerade. The Elders betrayed Caine, and we are his vengeance made flesh."
	var/blood_feast_info = "The Blood Feast is a rite of celebration held by the pack, usually when any formal gathering is declared. Each of our Cainites, with the Priest being able to choose whether or not they participate, leaves in a competition for the hunt. Woe unto the Cainite who brings some foul beggar with blood that tastes of dirt. This Rite shall be a competition, to see who may offer the most worthy morsel to the communal pack, whether that is a nosy police officer, a Rogue Sabbat Cainite, or a worthy heretical Cainite for diablerie, the strength of the pack shall be shown, and we shall all feast this night. \n"
	var/wild_hunt_info = "None may defy Caine - especially not those who have undertaken the Vaulderie! Traitors and defectors to Caine and the Sabbat shall be struck down with a rightful war party, along with any who know of their treachery, but not before we have our fun with them, diablerie, burning them atop our ritual fire with a stake still in their putrid heart, or mutilation. None may defy Caine, and none may escape Caine's vengeance, not the Elders of the Camarilla or traitors to the pack. "

/obj/item/sabbat_priest_tome/attack_self(mob/living/carbon/human/user)

	if(!user.mind || !(user.mind.has_antag_datum(/datum/antagonist/sabbatist)))
		to_chat(user, "You feel nothing when you touch this tome.")
		return

	var/is_priest = user.mind.has_antag_datum(/datum/antagonist/sabbatist/sabbatpriest)

	to_chat(user, "These are the Auctoritas Ritae given to you by Caine.")

	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-open"

	addtimer(CALLBACK(src, .proc/close_book), 10 SECONDS)

	var/list/ritae_options = list()
	if(is_priest)
		ritae_options += "Pack Credo (Edit)"
	ritae_options += "Pack Credo"
	ritae_options += "Vaulderie"
	ritae_options += "Shovelhead"
	ritae_options += "Monomacy"
	ritae_options += "Blood Bath"
	ritae_options += "War Party"
	ritae_options += "Blood Feast"
	ritae_options += "Wild Hunt"

	var/choice = tgui_input_list(user, "Select a Rite to learn about:", "Sabbat Ritae", ritae_options)
	if(!choice)
		return
	var/current_credo = pack_credo
	switch(choice)
		if("Pack Credo (Edit)")
			to_chat(user, span_cult("<b>Pack Credo:</b>"))
			to_chat(user, span_cult("[current_credo]"))

			if(is_priest && choice == "Pack Credo (Edit)")
				var/new_credo = tgui_input_text(user, "Enter your interpretation of the Sabbat's goals:", "Edit Pack Credo", current_credo) as text|null
				if(new_credo && new_credo != current_credo)
					pack_credo = new_credo
					to_chat(user, span_cult("You update your pack's interpretation of the Sabbat Credo."))

		if("Pack Credo")
			to_chat(user, span_cult("<b>Pack Credo:</b>"))
			to_chat(user, span_cult("[current_credo]"))

		if("Vaulderie")
			to_chat(user, span_cult("<b>The Vaulderie:</b>"))
			to_chat(user, span_cult("[vaulderie_info]"))

		if("Shovelhead")
			to_chat(user, span_cult("<b>Shovelhead Creation Rites:</b>"))
			to_chat(user, span_cult("[shovelhead_info]"))

		if("Monomacy")
			to_chat(user, span_cult("<b>The Rite of Monomacy:</b>"))
			to_chat(user, span_cult("[monomacy_info]"))

		if("Blood Bath")
			to_chat(user, span_cult("<b>The Rite of the Blood Bath:</b>"))
			to_chat(user, span_cult("[bloodbath_info]"))

		if("War Party")
			to_chat(user, span_cult("<b>The Ritus of the War Party:</b>"))
			to_chat(user, span_cult("[war_party_hunt_info]"))

		if("Blood Feast")
			to_chat(user, span_cult("<b>The Blood Feast:</b>"))
			to_chat(user, span_cult("[blood_feast_info]"))

		if("Wild Hunt")
			to_chat(user, span_cult("<b>The Wild Hunt:</b>"))
			to_chat(user, span_cult("[wild_hunt_info]"))

/obj/item/sabbat_priest_tome/proc/close_book()
	icon_state = initial(icon_state)
