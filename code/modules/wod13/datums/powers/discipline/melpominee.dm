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
	var/new_say = tgui_input_text(owner, "What will [target] say?", "The Missing Voice:", FALSE, 500, TRUE, FALSE, 0)
	if(!new_say)
		return

	//prevent forceful emoting and whatnot
	if (findtext(new_say, "*"))
		to_chat(owner, span_userdanger("You can't force others to perform emotes!"))
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

	var/input_message = tgui_input_text(owner, "What message will you project to them?", "Madrigal: Emotion", FALSE, 500, TRUE, FALSE, 0) as null|text
	if (!input_message)
		return
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

/datum/discipline_power/melpominee/madrigal/activate()
	. = ..()
	var/userSong = tgui_input_text(owner, "What are the words of your melodic voice, Madrigal?", "Madrigal:", FALSE, 500, TRUE, FALSE, 0)
	if (!userSong || userSong == "")
		return
	var/emotion = tgui_input_text(owner, "What emotion do you wish to project through your voice? (fear, joy, sorrow, anger, awe, humor)", "Madrigal: Emotion", FALSE, 500, TRUE, FALSE, 0)
	if (!emotion || emotion == "")
		return
	var/song = userSong
	var/min_message = 10
	if (findtext(song, "*"))
		to_chat(owner, span_warning("No *'s are allowed in vocal powers!"))
		return
	if (length(song) < min_message)
		to_chat(owner, span_warning("Your song is too short! Must be at least [min_message] characters."))
		return
	if (CHAT_FILTER_CHECK(song))
		to_chat(owner, span_warning("That song contains a prohibited word. Naughty! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[song]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	owner.say(message = userSong, forced = "melpominee 3")

	var/newEmote = ""
	var/emote_text = ""
	var/client_feedback = ""

	//Emotional Storage <3
	// Core emotional input, and responses to [owner]'s melodic voice
	switch(emotion)
		if ("admiration")
			newEmote = " looks at [owner] in wonder."
			emote_text = pick("stare")
			client_feedback = "You are struck with awe for [owner]'s melodic voice."

		if ("anger")
			newEmote = " starts to grumble angrily, in response to [owner]'s melodic voice."
			emote_text = pick("scowl", "frown")
			client_feedback = "Your blood runs hot. [owner]'s words sting and ignite your anger."

		if ("confusion")
			newEmote = " furrows their brow, clearly confused by [owner]'s melodic voice."
			emote_text = pick("blink", "tilt")
			client_feedback = "[owner]'s voice leaves you feeling disoriented, trying to understand the meaning behind the words."

		if ("desire")
			newEmote = " bites their lip, overcome with desire from [owner]'s melodic voice."
			emote_text = pick("blush")
			client_feedback = "[owner]'s voice awakens something deeper... a craving, hard to ignore."

		if ("disgust")
			newEmote = " recoils slightly, a look of disgust crossing their face at [owner]'s voice."
			emote_text = pick("grimace", "gag")
			client_feedback = "A sharp distaste rises within you. Something in [owner]'s tone repels you."

		if ("elation")
			newEmote = " beams brightly, lifted by [owner]'s melodic voice."
			emote_text = pick("grin")
			client_feedback = "A rush of joy and energy bursts from within you, stoked by [owner]'s voice."

		if ("empathy")
			newEmote = " nods slowly, visibly moved by [owner]'s melodic voice."
			emote_text = pick("nod", "sigh")
			client_feedback = "You feel compassion swell in your chest from the sincerity in [owner]'s voice."

		if ("envy")
			newEmote = " glares with barely concealed envy at [owner]."
			emote_text = pick("glare")
			client_feedback = "[owner]'s voice digs at you. Why do they have what you don’t?"

		if ("fear")
			newEmote = " begins to tremble, in response to [owner]'s melodic voice."
			emote_text = pick("tremble", "shiver")
			client_feedback = "Panic scratches at the edge of your mind, seeded by [owner]'s voice."

		if ("humor")
			newEmote = " begins chuckling slightly, in response to [owner]'s melodic voice."
			emote_text = pick("chuckle", "giggle", "laugh", "snicker", "snort", "clap")
			client_feedback = "You can't help but laugh. Something in [owner]'s tone amuses you deeply."

		if ("joy")
			newEmote = " begins to grin slightly, in response to [owner]'s melodic voice."
			emote_text = pick("grin", "smile")
			client_feedback = "A gentle joy flows through you, like sunlight in your chest."

		if ("love")
			newEmote = " gazes warmly at [owner], clearly touched."
			emote_text = pick("smile", "blush")
			client_feedback = "There’s a softness that overtakes you. You feel love bloom from [owner]'s words."

		if ("pride")
			newEmote = " stands tall, inspired by [owner]'s melodic voice."
			emote_text = pick("smirk", "grin", "nod")
			client_feedback = "A swelling of pride rushes through you. [owner]'s voice reinforces your strength."

		if ("relief")
			newEmote = " exhales slowly, tension draining at [owner]'s voice."
			emote_text = pick("exhale", "sigh")
			client_feedback = "Peace washes over you. [owner]'s words settle something deep within."

		if ("sadness")
			newEmote = "'s eyes begin to water, in response to [owner]'s melodic voice."
			emote_text = pick("sigh", "sulk")
			client_feedback = "[owner]'s voice conjures heavy memories. You feel sorrow settle over you."

		if ("shame")
			newEmote = " lowers their head in shame, avoiding [owner]'s gaze."
			emote_text = pick("sigh", "blush", "frown")
			client_feedback = "[owner]'s voice feels like a mirror reflecting your flaws. You can't look directly."

		if ("surprise")
			newEmote = " blinks rapidly, surprised by [owner]'s melodic voice."
			emote_text = pick("blink", "gasp", "scream")
			client_feedback = "The words hit harder than expected. [owner]'s voice caught you off guard."

		if ("trust")
			newEmote = " stands a little closer to [owner], visibly comforted."
			emote_text = pick("nod")
			client_feedback = "[owner]'s voice assures you. You feel protected, somehow."

		else
			to_chat(owner, span_warning("Invalid emotion. Try: admiration, anger, confusion, desire, disgust, elation, empathy, envy, fear, humor, joy, love, pride, relief, sadness, shame, surprise, trust."))
			return



	var/super_fan_limit = 5
	var/super_fans = 0
	var/affectedCrowdmembers = 0
	var/casterRoll = SSroll.storyteller_roll(owner.get_total_social(), mobs_to_show_output = owner, numerical = TRUE)

	if(casterRoll <= 0)
		to_chat(owner, span_warning("Botched/Failled Roll [casterRoll] : You feel your voice is not resonating, try again later."))
		return

// Attempts Madrigal effect on all listeners. Might expand range for Yelling/Exclaiming.
	for (var/mob/living/carbon/human/listener in oviewers(7, owner))
		if (listener.stat == DEAD)
			continue
		var/is_npc = istype(listener, /mob/living/carbon/human/npc)
		var/base_difficulty = 6
		var/botched_roll = FALSE

		//Happens to all listeners.
		listener.Stun(2 SECONDS)
		affectedCrowdmembers++ //All who hear it can give in to the emtion.

		// Cosmetic overlays, UI/Songs etc.
		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)
		// Remove the overlay after a short duration. Actual effects can lasts longer with strong RP.
		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

		//NPCs Superfans
		if (is_npc && casterRoll >= 3) //AutoFail NPCS if the caster successes is more than 3.
			var/mob/living/carbon/human/npc/N = listener
			// Stops NPC auto movement
			walk(N, 0)
			N.old_movement = TRUE
			N.walktarget = null
			//Sets the NPC to be a Superfan for 60 seconds, applied later, by listener.create_superfan(10, owner)
			botched_roll = TRUE //used to igonore the roll for NPCs later.

		// Listener's Roll to Resist.
		if (!botched_roll) //Ignore Rolls, if Pre-Botched, like for npcs.
			var/targetRoll = SSroll.storyteller_roll(listener.get_total_mentality(), base_difficulty, numerical = TRUE, mobs_to_show_output = listener)

			if (targetRoll <= 0) // Botched roll (0 successes, are assumed to have at least one, natural 1, for now. Not sure how to check that, yet.)
				botched_roll = TRUE //Will be a Superfan.
				listener.emote(emote_text)
				listener.visible_message(span_warning("[listener][newEmote]"), span_userdanger("[client_feedback]"))
				to_chat(listener, span_danger("(Contested Roll: Botched: You [casterRoll] vs [targetRoll]) You are completely overwhelmed with [emotion] and enamored with [owner]!"))
				continue

			if (targetRoll > casterRoll) // Success, compares the caster roll to the listener roll.
				to_chat(listener, span_notice("(Contested Roll: Success: You [casterRoll] vs [targetRoll]) You resist the emotional pull of [owner]'s voice, and might notice a strange shift in the crowd."))
				listener.visible_message(listener, span_userdanger("[client_feedback]"))
				continue

			if (targetRoll <= casterRoll) // Failure, listener roll is less than the caster rolled successes.
				to_chat(listener, span_danger("(Contested Roll: Failure: You [casterRoll] vs [targetRoll]) You feel [emotion] fill your mind."))
				listener.emote(emote_text)
				listener.visible_message(span_userdanger("[client_feedback]"))
				continue
			continue

		// Superfan Limiter; Applys Superfan effect to botched listeners.
		if (super_fans < super_fan_limit)
			if (botched_roll)
				to_chat(listener, span_warning("You feel enamored by and drawn toward [owner], you can't seem to leave their side..."))
				if (is_npc)
					listener.emote(emote_text)
					listener.create_superfan(30 SECONDS, owner, emote_text) // NPCs get a longer Superfan duration.
				else
					// Players/Non-NPCs get a shorter Superfan duration, and only if they botch the roll.
					listener.emote(emote_text)
					listener.create_superfan(10 SECONDS, owner, emote_text)
					to_chat(listener, span_warning("You feel drawn toward [owner], you can't seem to leave their side..."))
				super_fans++

	to_chat(owner, span_warning("Your Successes: [casterRoll] : You affected [affectedCrowdmembers] member(s) of the crowd with [emotion], and now have [super_fans] more Superfans!"))
	message_admins("[ADMIN_LOOKUPFLW(owner)] cast the Madrigal DoC Power: With [casterRoll] successes, vocalizing '[song].' They affected [affectedCrowdmembers], and made [super_fans] new Superfans, with a focus on [emotion].")
	log_game("[key_name(owner)] has used Madrigal DoC power, vocalizing '[song],' with emotion [emotion], and affecting [affectedCrowdmembers] npcs/players.")
	SSblackbox.record_feedback("tally", "madrigal", 1, song)

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
