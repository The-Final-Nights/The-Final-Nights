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
	desc = "Project raw emotion into nearby minds through your melodic sounding voice, inspiring emotional reactions."
	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	cooldown_length = 6 SECONDS
	duration_length = 2 SECONDS
	duration_override = TRUE
	multi_activate = TRUE

/datum/discipline_power/melpominee/madrigal/activate()
	. = ..()
	//var/userSong = lowertext(trim(input(owner, "What are the words of your melodic voice, Madrigal? (This can be a song, or subtle poetic speaking, if you word it right.)") as null|text))
	//if (!userSong || userSong == "")
		//return

		// Example: "Disrespect your Suroundings!!!" , emotion; Anger.
		//The reason for this, is to make make this power much less spammable.
		//As well, IF there is no song entered, it will only work on NPCs.

	var/emotion = lowertext(trim(input(owner, "What emotion do you wish to project to those around you through your voice? (e.g., fear, joy, sorrow, anger, awe)", "Project Emotion") as null|text))
	if (!emotion || emotion == "")
		return

	var/song = sanitize(userSong)
	var/newEmote = ""
	var/emote_text = ""
	var/client_feedback = ""

	switch(emotion)
		if ("fear")
			newEmote = " begins to tremble, in response to [owner]'s melodic voice."
			emote_text = "tremble"
			client_feedback = "You feel fear begin to seep into the cracks of your mind, pangs of anxiety about the subject defined by [owner]'s voice."
		if ("joy")
			newEmote = " begins to smile, in response to [owner]'s melodic voice."
			emote_text = "smile"
			client_feedback = "You feel joy begin to warm your thoughts, an unmistakeable hint of genuine bliss, brought upon by [owner]'s voice."
		if ("sorrow")
			newEmote = "'s eyes begin to water, in response to [owner]'s melodic voice."
			emote_text = "mumble"
			client_feedback = "You feel sorrow begin to weigh down your heart brought by [owner]'s melodic voice."
		if ("anger")
			newEmote = " starts to grumble angrily, in response to [owner]'s melodic voice."
			emote_text = "grumble"
			client_feedback = "You feel anger, as your blood begins to boil with sudden directionless rage, you turn to [owner]'s their voice guides it, somewhat."
		if ("awe")
			newEmote = "looks at [owner] with wide eyes, in response to [owner]'s melodic voice."
			emote_text = "stare"
			client_feedback = "You are struck with overwhelming awe for [owner]'s melodic voice."
		if ("humor")
			newEmote = "begins chuckling heartily, in response to [owner]'s melodic voice."
			emote_text = "chuckle"
			client_feedback = "You feel overwhelming humor for [owner]'s voice.'"
		else
			to_chat(owner, span_warning("Invalid emotion. Try: fear, joy, sorrow, anger, awe, humor."))
			return

	// Apply effects to nearby targets, needs to always work on NPCs, a chance for players depending on distance and/or Species/Clan.
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listener.create_walk_to(2 SECONDS, owner)
		listener.Stun(1.5 SECONDS)
		listener.emote(emote_text)
		listener.visible_message(span_warning("[listener][newEmote]"), span_userdanger(client_feedback))
		listener.visible_message(
			span_warning("[listener] appears overcome by [emotion]!"),
			span_userdanger("[client_feedback]"))

		// Overlay effect
		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)
		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

	// Admin.Log([owner] is casting Madrigal, emotion = [emotion], on a crowd [(no) player(s) (targetted)].



/datum/discipline_power/melpominee/madrigal/deactivate(mob/living/carbon/human/target)
	. = ..()
	if(target)
		target.remove_overlay(MUTATIONS_LAYER)
		to_chat(target, "<span class='subtle'>The emotional projection fades, the feeling of [emotion] leaves you.</span>")

/mob/living/carbon/human/proc/create_walk_to(duration, mob/living/walk_to)
	var/datum/cb = CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, walk_to_caster), walk_to)
	for(var/i in 1 to duration)
		addtimer(cb, (i - 1) * total_multiplicative_slowdown())


//SIREN'S BECKONING
/datum/discipline_power/melpominee/sirens_beckoning
	name = "Siren's Beckoning"
	desc = "Sing an unearthly song to stun those around you, and force their voice, or reaction, *emote."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

var/new_say = input(owner, "What will [target] say?") as null|text
	if(!new_say)
		return

	effect_sound = 'code/modules/wod13/sounds/killscream.ogg'


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
				to_chat(hearer, span_warning("[target]'s isn't moving to match [target.p_their()] sounds."))
			else
				to_chat(hearer, span_warning("[target]'s aren't moving to match [target.p_their()] sounds."))


	duration_length = 2 SECONDS
	cooldown_length = 7.5 SECONDS
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
		listener.effects.add_effect(/datum/add_effect/Frenzy, 2 SECONDS)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

/datum/discipline_power/melpominee/shattering_crescendo/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
