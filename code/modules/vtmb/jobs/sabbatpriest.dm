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
		if(H.stat != DEAD && is_sabbatist(H) && (findtext(H.real_name, challenged_name) || findtext(H.name, challenged_name)))
			target = H

	if(!target)
		to_chat(challenger, span_warning("Could not find anyone with that name to challenge! Only members of the Sabbat may engage in Monomacy."))
		return


	// Notify the challenger
	to_chat(challenger, span_notice("You have challenged [target.real_name] to a duel of Monomacy!"))
	SEND_SOUND(challenger, sound('code/modules/wod13/sounds/announce.ogg'))

	// Notify the target
	to_chat(target, span_warning("[challenger.real_name] challenges you to a duel of Monomacy! Return to the lair at once!"))
	SEND_SOUND(target, sound('code/modules/wod13/sounds/announce.ogg'))

	// Announce the challenge to everyone nearby
	for(var/mob/M in viewers(7, src))
		if(M != challenger && M != target)
			to_chat(M, span_notice("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy!"))
			SEND_SOUND(M, sound('code/modules/wod13/sounds/announce.ogg'))

	// Notify the priest
	for(var/mob/living/carbon/human/priest in GLOB.player_list)
		if(priest.mind.has_antag_datum(/datum/antagonist/sabbatist/sabbatpriest))
			to_chat(priest, span_warning("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy! Return to the lair at once to ensure Caine's will is done."))
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

