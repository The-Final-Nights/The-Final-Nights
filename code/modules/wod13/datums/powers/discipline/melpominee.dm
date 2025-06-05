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
	var/isSin = FALSE
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
	isSin = FALSE //checks in a bit
	super_fans = 0 //zeros out the super_fans variable, so it can be used again this cast.

	//Input
	song = tgui_input_text(owner, "What are the words does your melodic voice Madrigal contain?", "Madrigal: Input Melodic Words/Song", FALSE, 500, TRUE, FALSE, 0)
	if (!song || song == "")
		to_chat(owner, span_warning("You must provide a song to sing!"))
		return FALSE
	emotion = tgui_input_text(owner, "Type a Sin or Virtue you wish to project through your voice. Listeners who fail will be given a prompt to work with.", "Madrigal: Input A Sin or Virtue", FALSE, 500, TRUE, FALSE, 0)
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
		return FALSE
	if (length(song) < 10)
		to_chat(owner, span_warning("Your song is too short! Must be at least [10] characters."))
		return FALSE
	if (CHAT_FILTER_CHECK(song))
		to_chat(owner, span_warning("That song contains a prohibited word. Naughty! Consider reviewing the server rules.\n<span replaceRegex='show_filtered_ic_chat'>\"[song]\"</span>"))
		SSblackbox.record_feedback("tally", "ic_blocked_words", 1, lowertext(config.ic_filter_regex.match))
		return FALSE

	// HARDSTOP: Caster Botched Roll.
	casterRoll = SSroll.storyteller_roll(owner.get_total_social(), mobs_to_show_output = owner, numerical = TRUE)
	if(casterRoll <= 0)
		to_chat(owner, span_warning("You feel your voice is not resonating, try again later."))
		return FALSE
	if (emotion in list("pride", "envy", "wrath", "sloth", "greed", "lust", "gluttony"))
		isSin = TRUE
	// Valid Sin or Virtue?
	if(!emotion in list("humility", "pride", "kindness", "envy", "patience", "wrath", "charity", "greed", "chastity", "lust", "diligence", "sloth", "gratitude", "gluttony"))
		to_chat(owner, span_warning("You must pick one of the Seven Heavenly Virtues or the Seven Deadly Sins. Valid: humility, pride, kindness, envy, patience, wrath, charity, greed, chastity, lust, diligence, sloth, gratitude, gluttony"))
		return FALSE

	var/found_emotion = FALSE //if it finds it, it stops checking.
	// HUMILITY vs PRIDE :
	if (emotion == ("humility") && !found_emotion)
		emotion = pick("humility", "modesty", "meekness", "selflessness")
		newEmote = " lowers their gaze, their [emotion] stirring softly under the grace of [owner]'s voice."
		emote_text = pick("nod", "bow", "smile")
		client_feedback = "You feel a quiet [emotion] settle over you, called forth by the reverence in [owner]'s voice."
		found_emotion = TRUE
	if (emotion == ("pride") && !found_emotion)
		emotion = pick("pride", "vanity", "arrogance", "ego")
		newEmote = "'s chin lifts faintly, the [emotion] in [owner]'s voice swelling their confidence."
		emote_text = pick("smirk", "grin", "stare")
		client_feedback = "[owner]'s voice feeds your [emotion], bold and affirming in its cadence."
		found_emotion = TRUE
	// KINDNESS vs ENVY
	if (emotion == ("kindness") && !found_emotion)
		emotion = pick("kindness", "compassion", "empathy", "mercy")
		newEmote = "'s expression eases, touched by the [emotion] carried gently by [owner]'s tone."
		emote_text = pick("smile", "sigh", "hug")
		client_feedback = "A wave of [emotion] moves through you, stirred by the warmth in [owner]'s voice."
		found_emotion = TRUE
	if (emotion == ("envy") && !found_emotion)
		emotion = pick("envy", "jealousy", "resentment", "covetousness")
		newEmote = " glances aside, their [emotion] prickling under the velvet edge of [owner]'s voice."
		emote_text = pick("glare", "frown", "stare")
		client_feedback = "Something in [owner]'s voice claws at you, awakening a bitter [emotion] within."
		found_emotion = TRUE
	// PATIENCE vs WRATH
	if (emotion == ("patience") && !found_emotion)
		emotion = pick("patience", "tolerance", "calm", "serenity", "composure")
		newEmote = " breathes in slow rhythm, [emotion] threading through them as [owner]'s voice calms the air."
		emote_text = pick("exhale", "nod", "blink")
		client_feedback = "The melody of [owner]'s voice centers you, ushering in a sense of [emotion]."
		found_emotion = TRUE
	if (emotion == ("wrath") && !found_emotion)
		emotion = pick("wrath", "anger", "rage", "fury", "irritation")
		newEmote = "'s jaw tenses for a moment, [emotion] sparked by the undercurrent in [owner]'s tone."
		emote_text = pick("scowl", "frown", "growl")
		client_feedback = "[owner]'s tone burns at the edges of your thoughts, drawing out a dangerous [emotion]."
		found_emotion = TRUE
	// CHARITY vs GREED
	if (emotion == ("charity") && !found_emotion)
		emotion = pick("charity", "generosity", "altruism")
		newEmote = " places a hand near their heart, the [emotion] in [owner]'s voice not going unnoticed."
		emote_text = pick("smile", "bow", "clap")
		client_feedback = "The kindness in [owner]'s words awakens a sense of [emotion] you hadn't expected."
		found_emotion = TRUE
	if (emotion == ("greed") && !found_emotion)
		emotion = pick("greed", "avarice", "materialism", "hoarding")
		newEmote = "'s gaze lingers, [emotion] whispering at the edges of [owner]'s inviting cadence."
		emote_text = pick("grin", "lick_lips", "stare")
		client_feedback = "[owner]'s voice hints at promise and gain — your [emotion] stirs in response."
		found_emotion = TRUE
	// CHASTITY vs LUST
	if (emotion == ("chastity") && !found_emotion)
		emotion = pick("chastity", "purity", "temperance", "restraint")
		newEmote = " composes themselves, recognizing the restraint and [emotion] woven into [owner]'s voice."
		emote_text = pick("nod", "fold_hands", "exhale")
		client_feedback = "A quiet [emotion] anchors you as [owner]'s words brush the edge of temptation."
		found_emotion = TRUE
	if (emotion == ("lust") && !found_emotion)
		emotion = pick("lust", "desire", "yearning", "craving")
		newEmote = " shifts their stance, [emotion] flickering briefly in response to [owner]'s sultry tone."
		emote_text = pick("blush", "stare", "bite_lip")
		client_feedback = "Your senses quicken — [owner]'s voice dances with [emotion] just beneath the surface."
		found_emotion = TRUE
	// DILIGENCE vs SLOTH
	if (emotion == ("diligence") && !found_emotion)
		emotion = pick("diligence", "drive", "determination", "focus")
		newEmote = " straightens subtly, [emotion] kindled at the edges by [owner]'s steady tone."
		emote_text = pick("nod", "clench", "straighten")
		client_feedback = "[owner]'s presence sharpens your resolve, fanning the flame of [emotion]."
		found_emotion = TRUE
	if (emotion == ("sloth") && !found_emotion)
		emotion = pick("sloth", "laziness", "apathy", "lethargy", "indifference")
		newEmote = " slows slightly, the drawl of [owner]'s voice tempting a quiet [emotion]."
		emote_text = pick("sigh", "yawn", "droop")
		client_feedback = "The lull of [owner]'s voice weighs on you, coaxing forth a creeping [emotion]."
		found_emotion = TRUE
	// GRATITUDE vs GLUTTONY
	if (emotion == ("gratitude") && !found_emotion)
		emotion = pick("gratitude", "thankfulness", "appreciation")
		newEmote = " dips their head slightly, [emotion] rising quietly in response to [owner]'s resonant voice."
		emote_text = pick("smile", "bow")
		client_feedback = "[owner]'s words resonate deep, and a sincere [emotion] finds its way to the surface."
		found_emotion = TRUE
	if (emotion == ("gluttony") && !found_emotion)
		emotion = pick("gluttony", "overindulgence", "excess", "binge")
		newEmote = "'s lips part almost imperceptibly, [emotion] echos to them faintly from [owner]'s indulgent voice."
		emote_text = pick("grin", "snicker", "lick_lips")
		client_feedback = "Every syllable from [owner] feels like a feast — [emotion] curls inside you, wanting more."
		found_emotion = TRUE

	//Collect Targets
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
	var/totalListeners = 0
	var/base_difficulty = 6

	//Listener Resistance Rolls:
	for (var/mob/living/carbon/human/listener in all_listeners)
		totalListeners++
		var/botched_roll = FALSE //Used to make Superfans.
		if (isnpc(listener))
			base_difficulty += 2
		if (iskindred(listener))
			base_difficulty -= 2
		if (isgarou(listener))
			base_difficulty -= 2
		if (listener.mind.holy_role) //Have to roll, extremely poorly to fail.
			base_difficulty -= 6

		var/targetRoll = SSroll.storyteller_roll(listener.get_total_mentality(), base_difficulty, numerical = TRUE, mobs_to_show_output = listener)
		if (targetRoll <= 0) //Botched Roll
			botched_roll = TRUE
			to_chat(listener, span_warning("You are completely overwhelmed with [emotion] and you can't seem to leave [owner]'s side..."))
		if (!botched_roll) //Contested Roll, Casters Social vs Listener's Mentality.
			if (targetRoll >= casterRoll) // Success, senses the emotion mildly, but resists. No forced emote.
				to_chat(listener, span_notice("You resist any emotional pull of [owner]'s voice of [emotion], but their voice still may hold weight."))
				listener.visible_message(span_userdanger("[client_feedback]"))
				continue
			if (targetRoll < casterRoll) // Failure, senses the emotion with more intensity. One forced emote.
				to_chat(listener, span_danger("You feel [emotion] fill your mind, and [owner]'s voice guides it."))
				listener.emote(emote_text) //only once
				listener.visible_message(span_userdanger("[client_feedback]"))
				continue

		// Superfan Limiter/Creator: Superfans, can be Players or NPCs.
		if (super_fans < super_fan_perCast && botched_roll)
			if (istype(listener, /mob/living/carbon/human))
				var/datum/component/superfan/SF = listener.GetComponent(/datum/component/superfan)
				if (SF && SF.superfan_active) //Skips Active Superfans
					SF.superfan_emotion = emote_text //updates exsisting fans mood to current cast.
					listener.visible_message("[listener][newEmote]")
					continue
			if (listener.client || isnpc(listener))
				listener.create_superfan(20, owner, emote_text)
				super_fans++
				listener.visible_message("[listener][newEmote]")
				continue

		// Quick Fire Cosmetics for each Listener, only last for two seconds.
		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)
		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)

	to_chat(owner, span_warning("You feel your voice resonate with [emotion], lets hope your words carry it too. You affected [totalListeners] member(s) of the crowd with [emotion], and now have [super_fans] more Superfans!"))
	message_admins("[ADMIN_LOOKUPFLW(owner)] used Madrigal, a Melpominee 3 Power: Roll : [casterRoll], Emotion : [emotion], Song : '[song].',  Mobs Affected: [totalListeners], SuperFans Made: [super_fans].")
	log_game("[key_name(owner)] used Madrigal, Melpominee 3 Power: Roll : [casterRoll], Emotion : [emotion], Song : '[song].',  Mobs Affected: [totalListeners], SuperFans Made: [super_fans].")
	SSblackbox.record_feedback("tally", "madrigal", 1, song)

/datum/discipline_power/melpominee/madrigal/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SuperFan: NPCs and Players. Compelled to stay near caster.
/datum/component/superfan
	parent_type = /datum/component
	var/mob/living/_owner //The Fan
	var/mob/living/superfan_target //The Star
	var/superfan_active = FALSE //for outside checks
	var/superfan_emotion //repeated emote string
	var/superfan_duration //Length

/datum/component/superfan/Initialize(mob/living/M)
	. = ..()
	_owner = M

/datum/component/superfan/proc/start(duration, mob/living/target, emotion)
	if (superfan_active)
		return
	superfan_active = TRUE
	superfan_target = target
	superfan_emotion = emotion
	var/datum/callback/follow_cb = CALLBACK(src, PROC_REF(superfan_behavior))
	for (var/i in 1 to (duration * 2))
		addtimer(follow_cb, (i - 1) * 1/2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(end)), duration * 1 SECONDS)

/datum/component/superfan/proc/superfan_behavior()
	var/distance = get_dist(_owner, superfan_target)

	if (isnpc(_owner)) //NPC
		var/mob/living/carbon/human/npc/N
		N = _owner
		N.staying = TRUE
		if (distance > 2)
			N.walk_to_caster(superfan_target)
		if (distance <= 1)
			N.walktarget = superfan_target
		if (prob(2))
			N.emote(superfan_emotion)

	if(_owner.client) //Player Client
		var/mob/living/carbon/human/P
		if (distance > 2)
			P.walk_to_caster(superfan_target)
		if (prob(1))
			P.emote(superfan_emotion)

/datum/component/superfan/proc/end()
	superfan_active = FALSE
	superfan_target = null
	if (isnpc(_owner))
		var/mob/living/carbon/human/npc/N = _owner
		N.walktarget = N.ChoosePath()
		N.staying = FALSE

//SIREN'S BECKONING
/datum/discipline_power/melpominee/sirens_beckoning
	name = "Siren's Beckoning"
	desc = "Siren's Beckoning is a power that allows the user to stun the crowd."
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
