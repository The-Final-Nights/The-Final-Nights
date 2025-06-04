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
	var/new_say = tgui_input_text(owner, "What will [target] say?", "The Missing Voice:", FALSE, 500, TRUE, FALSE, 0) as null|text
	if(!new_say)
		return

	//prevent forceful emoting and whatnot
	new_say = trim(copytext_char(new_say, 1, MAX_MESSAGE_LEN))
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

	message_admins("[ADMIN_LOOKUPFLW(owner)] used missing_voice, saying '[new_say]' through [ADMIN_LOOKUPFLW(target)].")
	log_game("[key_name(owner)] used missing_voice, saying '[new_say]' through [key_name(target)].")
	SSblackbox.record_feedback("tally", "missing voice", 1, "[key_name(owner)] used missing_voice, saying '[new_say]' through [key_name(target)].")

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
	input_message = trim(copytext_char(input_message, 1, MAX_MESSAGE_LEN))
	if(CHAT_FILTER_CHECK(input_message))
		to_chat(owner, span_warning("That message contained a word prohibited in IC chat! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[input_message]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	var/language = owner.get_selected_language()
	var/message = owner.compose_message(owner, language, input_message, , list())
	to_chat(target, "<span class='purple'><i>You hear someone's voice in your head...</i></span>")
	target.Hear(message, target, language, input_message, , , )
	to_chat(owner, span_notice("You project your voice to [target]'s ears."))

	message_admins("[ADMIN_LOOKUPFLW(owner)] used phantom_speaker, saying '[input_message] secretly to [ADMIN_LOOKUPFLW(target)].")
	log_game("[key_name(owner)] used phantom_speaker, saying '[input_message] secretly to [key_name(target)].")
	SSblackbox.record_feedback("tally", "missing voice", 1, "[key_name(owner)] used phantom_speaker, saying '[input_message] secretly to [key_name(target)].")

//MADRIGAL
/datum/discipline_power/melpominee/madrigal
	name = "Madrigal"
	desc = "Project raw emotion into nearby minds through your melodic voice, inspiring compelling emotional reactions."
	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	target_type = NONE
	cooldown_length = 6 SECONDS
	duration_length = 2 SECONDS
	duration_override = TRUE
	multi_activate = TRUE

	//storage land!
	var/all_listeners = list()
	var/song = ""
	var/isYelling = FALSE
	var/emotion = ""
	var/casterRoll = 0
	var/newEmote = ""
	var/emote_text = ""
	var/client_feedback = ""
	var/super_fan_perCast = 5
	var/super_fans = 0

/datum/discipline_power/melpominee/madrigal/pre_activation_checks()
	. = ..()
	song = ""
	emotion = ""
	super_fans = 0 //zeros out the super_fans variable, so it can be used again this cast.
	song = tgui_input_text(owner, "What are the words of your melodic voice, Madrigal?", "Madrigal:", FALSE, 500, TRUE, FALSE, 0)
	if (!song || song == "")
		to_chat(owner, span_warning("You must provide a song to sing!"))
		return FALSE

	emotion = tgui_input_text(owner, "What emotion do you wish to project through your voice? Listeners who fail will be given a prompt to work with.", "Madrigal: Emotion", FALSE, 500, TRUE, FALSE, 0)
	emotion = lowertext(trim(emotion))
	if (!emotion || emotion == "")
		to_chat(owner, span_warning("You must provide an emotion to project!"))
		return FALSE

	//Filtering
	if (findtext(song, "!"))
		isYelling = TRUE
	if (!findtext(song, "!"))
		isYelling = FALSE
	if (findtext(song, "*"))
		to_chat(owner, span_warning("No *'s are allowed in vocal powers!"))
		return
	if (length(song) < 10)
		to_chat(owner, span_warning("Your song is too short! Must be at least [10] characters."))
		return
	if (CHAT_FILTER_CHECK(song))
		to_chat(owner, span_warning("That song contains a prohibited word. Naughty! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[song]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return

	// HARDSTOP: Caster Botched Roll.
	casterRoll = SSroll.storyteller_roll(owner.get_total_social(), mobs_to_show_output = owner, numerical = TRUE)
	if(casterRoll <= 0)
		to_chat(owner, span_warning("You feel your voice is not resonating, try again later."))
		return FALSE

	//Will move this soon, but for now, this is the best place to put it.
	if (emotion in list("awe", "admiration", "wonder", "amazement", "astonishment", "marvel"))
		newEmote = " looks at [owner] in [emotion]."
		emote_text = pick("stare")
		client_feedback = "You are struck with [emotion], for [owner]'s melodic voice."

	else if (emotion in list("anger", "rage", "fury", "wrath", "irritation", "annoyance"))
		newEmote = " starts to grumble with [emotion], in response to [owner]'s melodic voice."
		emote_text = pick("scowl", "frown")
		client_feedback = "Your blood runs hot. [owner]'s words sting and ignite your [emotion]."

	else if (emotion in list("confusion", "bewilderment", "puzzlement", "perplext", "bafflement"))
		newEmote = " furrows their brow, clearly confused by [owner]'s melodic voice."
		emote_text = pick("blink", "tilt")
		client_feedback = "[owner]'s voice leaves you feeling [emotion], trying to understand the meaning behind the words."

	else if (emotion in list("desire", "lust", "longing", "yearning", "craving"))
		newEmote = " bites their lip, overcome with desire from [owner]'s melodic voice."
		emote_text = pick("blush")
		client_feedback = "[owner]'s voice awakens something deeper... a [emotion], hard to ignore."

	else if (emotion in list("disgust", "revulsion", "aversion", "loathing", "abhorrence"))
		newEmote = " recoils slightly, a look of disgust crossing their face at [owner]'s voice."
		emote_text = pick("grimace", "gag")
		client_feedback = "A sharp [emotion] rises within you. Something in [owner]'s tone exposes it."

	else if (emotion in list("elation", "exhilaration", "ecstasy", "excitement", "enthusiasm"))
		newEmote = " beams brightly, lifted by [owner]'s melodic voice."
		emote_text = pick("grin")
		client_feedback = "A rush of [emotion] and energy bursts from within you, stoked by [owner]'s voice."

	else if (emotion in list("empathy", "compassion", "sympathy", "understanding", "kindness"))
		newEmote = " nods slowly, visibly moved by [owner]'s melodic voice."
		emote_text = pick("nod", "sigh")
		client_feedback = "You feel [emotion] swell in your chest from the sincerity in [owner]'s voice."

	else if (emotion in list("envy", "jealousy", "covetousness", "resentment", "spite"))
		newEmote = " glares with barely concealed envy at [owner]."
		emote_text = pick("glare")
		client_feedback = "[owner]'s voice digs at your [emotion]. Why do they have what you don’t?"

	else if (emotion in list("panic", "fear", "terror", "horror", "dread", "fright"))
		newEmote = " begins to tremble, in response to [owner]'s melodic voice."
		emote_text = pick("tremble", "shiver", "shudder", "scream")
		client_feedback = "Pangs of [emotion] scratch at the edges of your mind, seeded by [owner]'s voice."

	else if (emotion in list("humor", "laughter", "comedy", "amusement", "joviality", "mirth"))
		newEmote = " begins chuckling slightly, in response to [owner]'s melodic voice."
		emote_text = pick("chuckle", "giggle", "laugh", "snicker", "snort", "clap")
		client_feedback = "You can't help but find [emotion] in [owner]'s tone, it amuses you deeply."

	else if (emotion in list("joy", "happiness", "contentment", "pleasure", "satisfaction", "delight"))
		newEmote = " begins to grin slightly, in response to [owner]'s melodic voice."
		emote_text = pick("grin", "smile")
		client_feedback = "A gentle [emotion] warms you, like morning sunlight in your chest."

	else if (emotion in list("love", "affection", "adoration", "fondness", "devotion", "attachment"))
		newEmote = " gazes warmly at [owner], clearly touched."
		emote_text = pick("smile", "blush")
		client_feedback = "You feel [emotion] for [owner]'s words."

	else if (emotion in list("pride", "self-esteem", "confidence", "self-worth", "self-respect", "dignity"))
		newEmote = " stands tall, inspired by [owner]'s melodic voice."
		emote_text = pick("smirk", "grin", "nod")
		client_feedback = "A swell as [emotion] rushes through you. [owner]'s voice reinforces your strength."

	else if (emotion in list("relief", "calm", "peace", "tranquility", "serenity", "composure"))
		newEmote = " exhales slowly, tension draining at [owner]'s voice."
		emote_text = pick("exhale", "sigh")
		client_feedback = "You feel a sense of [emotion] wash over you. [owner]'s words settle something deep within you for a time."

	else if (emotion in list("sadness", "sorrow", "grief", "melancholy", "depression", "heartbreak"))
		newEmote = "'s eyes begin to water, in response to [owner]'s melodic voice."
		emote_text = pick("sigh", "sulk")
		client_feedback = "[owner]'s voice conjures clouds of [emotion], and you feel it settle over you."

	else if (emotion in list("shame", "guilt", "embarrassment", "humiliation", "mortification", "self-consciousness"))
		newEmote = " lowers their head in shame, avoiding [owner]'s gaze."
		emote_text = pick("sigh", "blush", "frown")
		client_feedback = "[owner]'s voice feels like a mirror reflecting your [emotion]."

	else if (emotion in list("surprise", "astonishment", "amazement", "shock", "stuned", "startlement"))
		newEmote = " blinks rapidly, surprised by [owner]'s melodic voice."
		emote_text = pick("blink", "gasp", "scream")
		client_feedback = "The words hit harder than expected. [owner]'s voice leaves you in [emotion]."

	else if (emotion in list("trust", "faith", "confidence", "belief"))
		newEmote = " stands a little closer to [owner], visibly comforted."
		emote_text = pick("nod")
		client_feedback = "[owner]'s voice assures you, by their words of [emotion]."
	else
		to_chat(owner, span_warning("Invalid emotion: Try: awe, anger, confusion, desire, disgust, elation, empathy, envy, panic, humor, joy, love, pride, relief, sadness, shame, surprise, trust"))
		return FALSE

	//Range, captures all listeners.
	all_listeners = list()
	if(!isYelling)
		for (var/mob/living/carbon/human/listener in oviewers(7, owner))
			if (listener.stat == DEAD)
				continue
			all_listeners += listener
	if(isYelling)
		for (var/mob/living/carbon/human/listener in oviewers(10, owner))
			if (listener.stat == DEAD)
				continue
			all_listeners += listener

	spend_resources()

/datum/discipline_power/melpominee/madrigal/activate()
	. = ..()
	owner.say( song, forced = "melpominee 3")
	to_chat(owner, span_warning("You feel your voice resonate with [emotion], lets hope your words carry it too."))
	//Listeners Roll to Save
	var/totalListeners = 0
	var/base_difficulty = 6
	//Caster Improvements:
	//If caster is playing an instrument, the difficulty is raised for listeners?

	//Resistance Rolls:
	for (var/mob/living/carbon/human/listener in all_listeners)
		totalListeners++
		listener.Stun(2 SECONDS)
		var/botched_roll = FALSE //used to make Superfans.
		if (isnpc(listener))
			base_difficulty += 2 //NPCs are easier to affect.
		if (iskindred(listener))
			base_difficulty -= 2 //4
		if (isgarou(listener))
			base_difficulty -= 2 //4
		var/targetRoll = SSroll.storyteller_roll(listener.get_total_mentality(), base_difficulty, numerical = TRUE, mobs_to_show_output = listener)

		if (targetRoll <= 0) //Botched Roll, makes a superfan, intense emotion, follow behaviors.
			botched_roll = TRUE //Will be a Superfan.
			to_chat(listener, span_warning("You are completely overwhelmed with [emotion] and you can't seem to leave [owner]'s side..."))
		if (!botched_roll) //Contested Roll, Casters Social vs Listener's Mentality.
			if (targetRoll >= casterRoll) // Success, senses the emotion mildly, but resists. No forced emote.
				to_chat(listener, span_notice("You resist any emotional pull of [owner]'s voice of [emotion], but their voice still may hold weight."))
				listener.visible_message(span_userdanger("[client_feedback]"))
				continue
			if (targetRoll < casterRoll) // Failure, senses the emotion with more intensity. One forced emote.
				to_chat(listener, span_danger("You feel [emotion] fill your mind, and [owner]'s voice guides it."))
				listener.emote(emote_text)
				listener.visible_message(span_userdanger("[client_feedback]"))
				continue

		// Superfan Limiter/Creator: Superfans, can be players or NPCs.
		//Create superfans, is a behavior that starts and ends itself. Short time for clients, longer for NPCs.
		//Players will be drawn to the caster if they leave a certain range, retaining control.
		if (super_fans < super_fan_perCast && botched_roll)
			if (istype(listener, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = listener
				if (H.superfan_active) //Already a Superfan, Skip.
					continue
			if (listener.client) //is player
				listener.emote(emote_text)
				listener.create_superfan(20, owner, emote_text)
				super_fans++
				listener.visible_message("[listener][newEmote]")
				continue
			if (isnpc(listener)) //is an NPC
				listener.emote(emote_text)
				listener.create_superfan(120, owner, emote_text) // NPCs get a longer Superfan duration.
				super_fans++
				listener.visible_message("[listener][newEmote]")
				continue
			else //its human so...
				listener.emote(emote_text)
				listener.create_superfan(20, owner, emote_text)
				super_fans++
				listener.visible_message("[listener][newEmote]")

		// Quick Fire Cosmetics, soung and showing who is affected, for two seconds.
		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)
		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

	to_chat(owner, span_warning("You affected [totalListeners] member(s) of the crowd with [emotion], and now have [super_fans] more Superfans!"))
	message_admins("[ADMIN_LOOKUPFLW(owner)] used Madrigal, a Melpominee 3 Power: Roll : [casterRoll], Emotion : [emotion], Song : '[song].',  Mobs Affected: [totalListeners], SuperFans Made: [super_fans].")
	log_game("[key_name(owner)] used Madrigal, Melpominee 3 Power: Roll : [casterRoll], Emotion : [emotion], Song : '[song].',  Mobs Affected: [totalListeners], SuperFans Made: [super_fans].")
	SSblackbox.record_feedback("tally", "madrigal", 1, song)

/datum/discipline_power/melpominee/madrigal/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/mob/living/carbon/human/proc/create_walk_to(duration, mob/living/walk_to)
	var/datum/cb = CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, walk_to_caster), walk_to)
	for(var/i in 1 to duration)
		addtimer(cb, (i - 1) * total_multiplicative_slowdown())

//SIREN'S BECKONING
/datum/discipline_power/melpominee/sirens_beckoning
	name = "Siren's Beckoning"
	desc = "Siren's Beckoning is a power that allows the user to stun and drawing others in like moths to a flame."
	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	cooldown_length = 6 SECONDS
	duration_length = 2 SECONDS
	duration_override = TRUE

/datum/discipline_power/melpominee/sirens_beckoning/activate()
	. = ..()
	var/listenerCount = 0
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listenerCount++
		listener.Stun(4 SECONDS)
		create_walk_to(4, listener)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

	message_admins("[ADMIN_LOOKUPFLW(owner)] used sirens_beckoning, stunning all [listenerCount] mobs in range for 4 seconds.")
	log_game("[key_name(owner)]  used sirens_beckoning, stunning [listenerCount] mobs in range with for 4 seconds.")
	SSblackbox.record_feedback("tally", "sirens beckoning", 1, "affected listeners [listenerCount]")

/datum/discipline_power/melpominee/sirens_beckoning/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SHATTERING CRESCENDO
/datum/discipline_power/melpominee/shattering_crescendo
	name = "Shattering Crescendo"
	desc = "Scream at an unnatural pitch, shattering the bodies of your enemies."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK

	effect_sound = 'code/modules/wod13/sounds/killscream.ogg'

	duration_length = 2 SECONDS
	cooldown_length = 7.5 SECONDS
	duration_override = TRUE

/datum/discipline_power/melpominee/shattering_crescendo/activate()
	. = ..()
	var/listenerCount = 0
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		listenerCount++
		listener.Stun(2 SECONDS)
		listener.apply_damage(50, BRUTE, BODY_ZONE_HEAD)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

	message_admins("[ADMIN_LOOKUPFLW(owner)] used shattering_cresendo, affecting [listenerCount] mobs in range with 50 Brute damage.")
	log_game("[key_name(owner)]  used shattering_cresendo, affecting [listenerCount] mobs in range with 50 Brute damage.")
	SSblackbox.record_feedback("tally", "shattering crescendo", 1, "affected listeners [listenerCount]")

/datum/discipline_power/melpominee/shattering_crescendo/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)
