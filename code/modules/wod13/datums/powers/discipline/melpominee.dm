/datum/discipline/melpominee
	name = "Melpominee"
	desc = "Named for the Greek Muse of Tragedy, Melpominee is a unique discipline of the Daughters of Cacophony. It explores the power of the voice, shaking the very soul of those nearby and allowing the vampire to perform sonic feats otherwise impossible."
	icon_state = "melpominee"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/melpominee

/datum/discipline_power/melpominee
	name = "Melpominee power name"
	desc = "Melpominee power description"


	activate_sound = 'code/modules/wod13/sounds/melpominee.ogg'

//THE MISSING VOICE
/datum/discipline_power/melpominee/the_missing_voice
	name = "The Missing Voice"
	desc = "Throw your voice to any place you can see."

	level = 1
	vitae_cost = 0
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	target_type = TARGET_OBJ | TARGET_LIVING
	range = 7

	cooldown_length = 5 SECONDS

/datum/discipline_power/melpominee/the_missing_voice/activate(atom/movable/target)
	. = ..()
	var/new_say = input(owner, "What will [target] say?") as null|text
	if(!new_say)
		return

	//prevent forceful emoting and whatnot
	new_say = trim(copytext_char(sanitize(new_say), 1, MAX_MESSAGE_LEN))
	if (findtext(new_say, "*"))
		to_chat(owner, span_danger("You can't force others to perform emotes!"))
		return

	if (CHAT_FILTER_CHECK(new_say))
		to_chat(owner, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[new_say]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	target.say(message = new_say, forced = "melpominee 1")

	if (!isliving(target))
		return

	//viewers are able to detect if a person's words aren't their own
	var/base_difficulty = 5
	var/difficulty_malus = 0
	var/masked = FALSE
	if (ishuman(target)) //apply a malus and different text if victim's mouth isn't visible, and a malus if they're already typing
		var/mob/living/carbon/human/victim = target
		if (!victim.is_face_visible())
			masked = TRUE
			base_difficulty += 2
		if (victim.overlays_standing[SAY_LAYER]) //ugly way to check for if the victim is currently typing
			base_difficulty += 2

	for (var/mob/living/hearer in (oviewers(7, target) - owner))
		if (!hearer.client)
			continue
		difficulty_malus = 0
		if (get_dist(hearer, target) > 3)
			difficulty_malus += 1
		if (SSroll.storyteller_roll(hearer.get_total_mentality(), base_difficulty + difficulty_malus, mobs_to_show_output = hearer) == ROLL_SUCCESS)
			if (masked)
				to_chat(hearer, span_warning("[target]'s jaw isn't moving to match [target.p_their()] words."))
			else
				to_chat(hearer, span_warning("[target]'s lips aren't moving to match [target.p_their()] words."))

//PHANTOM SPEAKER
/datum/discipline_power/melpominee/phantom_speaker
	name = "Phantom Speaker"
	desc = "Project your voice to anyone you've met, speaking to them from afar."

	level = 2
	vitae_cost = 0
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cooldown_length = 5 SECONDS

/datum/discipline_power/melpominee/phantom_speaker/activate()
	. = ..()
	var/mob/living/target = input(owner, "Who will you project your voice to?") as null|mob in (GLOB.player_list - owner)
	if(!target)
		return

	var/input_message = input(owner, "What message will you project to them?") as null|text
	if (!input_message)
		return

	//sanitisation!
	input_message = trim(copytext_char(sanitize(input_message), 1, MAX_MESSAGE_LEN))
	if(CHAT_FILTER_CHECK(input_message))
		to_chat(owner, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[input_message]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	var/language = owner.get_selected_language()
	var/message = owner.compose_message(owner, language, input_message, , list())
	to_chat(target, "<span class='purple'><i>You hear someone's voice in your head...</i></span>")
	target.Hear(message, target, language, input_message, , , )
	to_chat(owner, span_notice("You project your voice to [target]'s ears."))

//MADRIGAL
/datum/discipline_power/melpominee/madrigal
	name = "Madrigal"
	desc = "Project raw emotion into nearby minds through your melodic voice, inspiring compelling emotional reactions."
	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	cooldown_length = 6 SECONDS
	duration_length = 2 SECONDS
	duration_override = TRUE
	multi_activate = TRUE

/mob/proc/is_alive()
	return istype(src, /mob/living) && !isdead(src)

/datum/discipline_power/melpominee/madrigal/activate()
	. = ..()

	// Prompt User for Song and Emotion
	var/userSong = lowertext(trim(input(owner, "What are the words of your melodic voice, Madrigal?") as null|text))
	if (!userSong || userSong == "")
		return

	var/emotion = lowertext(trim(input(owner, "What emotion do you wish to project through your voice? (fear, joy, sorrow, anger, awe, humor)") as null|text))
	if (!emotion || emotion == "")
		return

	// Validate song input
	var/song = sanitize(userSong)
	var/min_message = 10

	if (findtext(song, "*"))
		to_chat(owner, span_danger("No *'s are allowed in vocal powers!"))
		return
	if (length(song) < min_message)
		to_chat(owner, span_danger("Your song is too short! Must be at least [min_message] characters."))
		return
	if (CHAT_FILTER_CHECK(song))
		to_chat(owner, span_warning("That song contains a prohibited word. Naughty! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[song]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return
	//Sings the Song for the user after checks.
	owner.say(message = userSong, forced = "melpominee 3")

	var/newEmote = ""
	var/emote_text = ""
	var/client_feedback = ""

	//Emotional Storage <3
	switch(emotion)
		if ("fear")
			newEmote = " begins to tremble, in response to [owner]'s melodic voice."
			emote_text = "tremble"
			client_feedback = "You feel slight pangs of fear begin to seep into the cracks of your mind, bringing with it anxiety about the subject of [owner]'s voice."
		if ("joy")
			newEmote = " begins to grin slightly, in response to [owner]'s melodic voice."
			emote_text = "grin"
			client_feedback = "You feel joy begin to warm your thoughts, an unmistakeable hint of genuine bliss, brought on by the topic of [owner]'s voice."
		if ("sorrow")
			newEmote = "'s eyes begin to water, in response to [owner]'s melodic voice."
			emote_text = "mumble"
			client_feedback = "You feel sorrow begin to weigh down your heart brought on by the subject of [owner]'s melodic words."
		if ("anger")
			newEmote = " starts to grumble angrily, in response to [owner]'s melodic voice."
			emote_text = "grumble"
			client_feedback = "You feel anger, as your blood begins to boil with sudden directionless rage, you turn to [owner], their voice guides your anger, somewhat."
		if ("awe")
			newEmote = " looks at [owner] with wide eyes, in response to [owner]'s melodic voice."
			emote_text = "stare"
			client_feedback = "You are struck with awe for [owner]'s melodic voice."
		if ("humor")
			newEmote = " begins chuckling slightly, in response to [owner]'s melodic voice."
			emote_text = "chuckle"
			client_feedback = "You feel overwhelming humor for the topic of [owner]'s voice."
		else
			to_chat(owner, span_warning("Invalid emotion. Try: fear, joy, sorrow, anger, awe, humor."))
			return

	var/super_fan_limit = 5
	var/super_fans = 0
	var/affectedCrowdmembers = 0

	//rolls for owners social, used to set the difficulty of the roll for player/npc listeners.
	var/casterRoll = SSroll.storyteller_roll(owner.get_total_social(), mobs_to_show_output = owner, numerical = TRUE)

	//Minimum roll to affect the crowd.
	if(casterRoll < 3)
		to_chat(span_notice("(Poor Roll: [casterRoll]) You feel your voice is not strong enough to affect the crowd, try again later."))
		return //Hardstop on the power if the caster roll is too low.


	// Attempts to apply the Madrigal effect to all viewers within range
	for (var/mob/living/carbon/human/listener in oviewers(7, owner))
		if (!listener || !listener.is_alive()) //This works on dead people without this check. Lol.
			continue

		//Storage.
		//listener.visible_message(span_warning("[listener][newEmote]"), span_userdanger("[client_feedback]"))
		var/is_npc = istype(listener, /mob/living/carbon/human/npc)
		var/is_player = listener.client != null
		var/is_kindred = iskindred(listener)
		var/is_garou = isgarou(listener)
		var/base_difficulty = 6
		var/botched_roll = FALSE

		//Happens to all listeners, even if they resist, they feel a hint of something.
		listener.Stun(2 SECONDS)
		affectedCrowdmembers++

		// Cosmetic overlay
		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)
		// Remove the overlay after a short duration. Actual effects can lasts longer with strong RP.
		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

		//NPCs Superfans
		if (is_npc && casterRoll >= 3) //will move some of this to NPC_movement.dm later, probably.
			var/mob/living/carbon/human/npc/N = listener
			walk(N, 0)            // Stops NPC movement
			N.old_movement = TRUE
			N.walktarget = null

			//Sets the NPC to be a Superfan, if the caster passes the roll.
			botched_roll = TRUE
			listener.create_superfan(60, owner)
			super_fans++

		//Player Rolls:
		if (is_player && !is_npc)
			if (is_kindred)
				base_difficulty = 4
			else if (is_garou)
				base_difficulty = 5
			else //mortals/other/catchall
				base_difficulty = 6
			continue

		// Player Listener's Roll
			var/result = SSroll.storyteller_roll( listener.get_total_mentality(), base_difficulty, mobs_to_show_output = listener, numerical = TRUE)
			to_chat(owner, span_warning("[listener] rolled [result] successes your [casterRoll] casted Madrigal!")) //Debug Stuff

			if (result <= 0) // Botched roll (0 successes, assumed to have at least one, natural 1, for now. Not sure how to check that, yet.)
				botched_roll = TRUE
				listener.emote(emote_text)
				listener.visible_message(span_warning("[listener][newEmote]"), span_userdanger("[client_feedback]"))
				to_chat(listener, span_danger("(Botched Failure: [result]) You are completely overwhelmed with emotion and enamored with [owner]!"))
				continue

			else if (result >= casterRoll) // Success, compares the caster roll to the listener roll.
				to_chat(listener, span_notice("(Success: [result]) You resist the emotional pull of [owner]'s voice, and might notice a shift in the crowd."))
				continue

			else if (result < casterRoll) // Failure, listener roll is less than the caster rolled successes.
				if (is_player && !is_kindred && !is_garou)
					to_chat(listener, span_danger("(Failure: [result]) You feel [emotion] fill your mind."))
					listener.emote(emote_text)
					listener.visible_message(span_warning("[listener][newEmote]"), span_userdanger("[client_feedback]"))
					continue

		// Superfan creation
		if (super_fans < super_fan_limit)
			if (botched_roll) // Player becomes a superfan temporarily, compelled to be near the caster.
				to_chat(listener, span_warning("You feel drawn toward [owner], you can't seem to leave their side..."))
				listener.create_superfan(20, owner) // Superfan lasts for only 20 seconds for players, should still have control,
				//but compelled to walk to the cast when too far away, like superfans.
				super_fans++

	//After the effected listeners have been processed, we can give feedback to the caster, and Logging.
	to_chat(owner, span_warning("Successes [casterRoll] : You affected [affectedCrowdmembers] member(s) of the crowd with [emotion]!"))


/datum/discipline_power/melpominee/madrigal/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
	if (istype(target, /mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/N = target
		N.old_movement = FALSE
		N.walktarget = N.ChoosePath()


//SIREN'S BECKONING
/datum/discipline_power/melpominee/sirens_beckoning
	name = "Siren's Beckoning"
	desc = "Siren's Beckoning is a power that allows the user to stun and mesmerize those around them with their voice, drawing them in like moths to a flame."
	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	cooldown_length = 6 SECONDS
	duration_length = 2 SECONDS
	duration_override = TRUE

/datum/discipline_power/melpominee/sirens_beckoning/activate()
	. = ..()
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listener.Stun(2 SECONDS)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

/datum/discipline_power/melpominee/sirens_beckoning/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)



//SHATTERING CRESCENDO
/datum/discipline_power/melpominee/shattering_crescendo
	name = "Shattering Crescendo"
	desc = "Scream at an unnatural pitch, shattering the bodies of your enemies, and sending them into primal fear."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	effect_sound = 'code/modules/wod13/sounds/killscream.ogg'

	duration_length = 2 SECONDS
	cooldown_length = 7.5 SECONDS
	duration_override = TRUE

/datum/discipline_power/melpominee/shattering_crescendo/activate()
	. = ..()
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listener.Stun(2 SECONDS)
		listener.apply_damage(30, BRUTE, BODY_ZONE_HEAD)
		//listener.effects.add_effect(/datum/add_effect/Frenzy, 2 SECONDS)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

/datum/discipline_power/melpominee/shattering_crescendo/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
