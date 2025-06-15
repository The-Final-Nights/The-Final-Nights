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

/datum/discipline/melpominee/post_gain()
	. = ..()
	if(level >= 3)
		RegisterSignal(owner, COMSIG_MOB_EMOTE, PROC_REF(on_snap))

/datum/discipline/melpominee/proc/on_snap(atom/source, datum/emote/emote_args)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(handle_sf_snap), source, emote_args)

/datum/discipline/melpominee/proc/handle_sf_snap(atom/source, datum/emote/emote_args)
	var/list/emote_list = list("snap", "snap2", "snap3", "whistle")
	if(!emote_list.Find(emote_args.key))
		return
	// Look for all nearby mobs who can hear
	for (var/mob/living/carbon/human/target in get_hearers_in_view(6, owner))
		var/datum/component/superfan/SF = target.GetComponent(/datum/component/superfan)
		if (!SF)
			continue // skip if they're not a superfan
		switch(emote_args.key)
			if("snap")
				target.SetSleeping(0)
				target.silent = 3
				target.dir = get_dir(target, owner)
				target.emote("me", 1, "faces towards <b>[owner]</b> attentively.", TRUE)
				to_chat(target, span_danger("ATTENTION"))
			if("snap2")
				target.dir = get_dir(target, owner)
				target.Immobilize(50)
				target.emote("me",1,"flinches in response to <b>[owner]'s</b> snapping.", TRUE)
				to_chat(target, span_danger("HALT"))
			if("snap3")
				target.Knockdown(50)
				target.Immobilize(80)
				target.emote("me",1,"'s knees buckle under the weight of their body.",TRUE)
				target.do_jitter_animation(0.1 SECONDS)
				to_chat(target, span_danger("DROP"))
			if("whistle")
				target.apply_status_effect(STATUS_EFFECT_AWE, owner)
				to_chat(target, span_danger("HITHER"))

/datum/discipline_power/melpominee/the_missing_voice/activate(atom/movable/target)
	. = ..()
	var/new_say = tgui_input_text(owner, "What will [target] say?", "The Missing Voice:", FALSE, 500, TRUE, FALSE, 0)
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

	message_admins("[ADMIN_LOOKUPFLW(owner)] used missing_voice, saying '[new_say]' through [target].")
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

	var/input_message = tgui_input_text(owner, "What message will you project to them?", "Phantom Speaker:", FALSE, 500, TRUE, FALSE, 0)
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
	desc = "Project raw emotion into nearby minds through your melodic voice, inspiring compelling sinful or virtuous reactions."
	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_SPEAK
	target_type = NONE
	cooldown_length = 6 SECONDS
	duration_length = 2 SECONDS
	duration_override = TRUE
	multi_activate = TRUE
	var/all_listeners = list()
	var/song = ""
	var/sin_virtue = ""
	var/isSin = FALSE
	var/casterRoll = 0
	var/emote_text = ""
	var/super_fan_perCast = 3
	var/super_fans = 0
/datum/discipline_power/melpominee/madrigal/pre_activation_checks()
	. = ..()
	song = ""
	sin_virtue = ""
	var/isYelling = FALSE
	super_fans = 0
	song = tgui_input_text(owner, ":: Elegant Words Laced with Sin / Virtue ::", "Madrigal: Melodic Voice/Song", FALSE, 500, TRUE, FALSE, 0)
	if (song == "")
		to_chat(owner, span_warning("You must provide an answer..."))
		return FALSE
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
	sin_virtue = tgui_input_text(owner, ":: Enter One Deadly Sin or Heavenly Virtue :: Your words should support this theme.", ":Madrigal: Project a Sin or Virtue:", FALSE, 500, TRUE, FALSE, 0)
	sin_virtue = lowertext(trim(sin_virtue))
	if (sin_virtue == "")
		to_chat(owner, span_warning("You must provide an answer..."))
		return FALSE
	casterRoll = SSroll.storyteller_roll(owner.get_total_social(), mobs_to_show_output = owner, numerical = TRUE)
	if(casterRoll <= 0) //Caster Botched Roll.
		to_chat(owner, span_warning("You feel your voice is not resonating, try again later."))
		return FALSE

	//Sins & Virtues
	if(!(sin_virtue in list("humility", "kindness", "patience", "charity", "chastity", "diligence", "gratitude", "pride", "envy", "wrath", "sloth", "greed", "lust", "gluttony")))
		to_chat(owner, span_warning("You must enter a Heavenly Virtue or Deadly Sin; humility, kindness, patience, charity, chastity, diligence, gratitude, pride, envy, wrath, sloth, greed, lust, gluttony."))
		return FALSE
	if (sin_virtue in list("humility", "kindness", "patience", "charity", "chastity", "diligence", "gratitude"))
		isSin = FALSE
	if (sin_virtue in list("pride", "envy", "wrath", "sloth", "greed", "lust", "gluttony"))
		isSin = TRUE
	var/found_sin_virtue = FALSE
	if (sin_virtue == ("humility") && !found_sin_virtue)
		sin_virtue = pick("humility", "modesty", "meekness", "selflessness")
		emote_text = pick("nod", "bow", "smile")
		found_sin_virtue = TRUE
	if (sin_virtue == ("pride") && !found_sin_virtue)
		sin_virtue = pick("pride", "vanity", "arrogance", "ego")
		emote_text = pick("smirk", "grin", "stare")
		found_sin_virtue = TRUE
	if (sin_virtue == ("kindness") && !found_sin_virtue)
		sin_virtue = pick("kindness", "compassion", "empathy", "mercy")
		emote_text = pick("smile", "sigh", "hug")
		found_sin_virtue = TRUE
	if (sin_virtue == ("envy") && !found_sin_virtue)
		sin_virtue = pick("envy", "jealousy", "resentment", "covetousness")
		emote_text = pick("glare", "frown", "stare")
		found_sin_virtue = TRUE
	if (sin_virtue == ("patience") && !found_sin_virtue)
		sin_virtue = pick("patience", "tolerance", "calm", "serenity", "composure")
		emote_text = pick("exhale", "nod", "blink")
		found_sin_virtue = TRUE
	if (sin_virtue == ("wrath") && !found_sin_virtue)
		sin_virtue = pick("wrath", "anger", "rage", "fury", "irritation")
		emote_text = pick("scowl", "frown", "growl")
		found_sin_virtue = TRUE
	if (sin_virtue == ("charity") && !found_sin_virtue)
		sin_virtue = pick("charity", "generosity", "altruism")
		emote_text = pick("smile", "bow", "clap")
		found_sin_virtue = TRUE
	if (sin_virtue == ("greed") && !found_sin_virtue)
		sin_virtue = pick("greed", "avarice", "materialism", "hoarding")
		emote_text = pick("grin", "lick_lips", "stare")
		found_sin_virtue = TRUE
	if (sin_virtue == ("chastity") && !found_sin_virtue)
		sin_virtue = pick("chastity", "purity", "temperance", "restraint")
		emote_text = pick("nod", "fold_hands", "exhale")
		found_sin_virtue = TRUE
	if (sin_virtue == ("lust") && !found_sin_virtue)
		sin_virtue = pick("lust", "desire", "yearning", "craving")
		emote_text = pick("blush", "stare", "bite_lip")
		found_sin_virtue = TRUE
	if (sin_virtue == ("diligence") && !found_sin_virtue)
		sin_virtue = pick("diligence", "drive", "determination", "focus")
		emote_text = pick("nod", "clench", "straighten")
		found_sin_virtue = TRUE
	if (sin_virtue == ("sloth") && !found_sin_virtue)
		sin_virtue = pick("sloth", "laziness", "apathy", "lethargy", "indifference")
		emote_text = pick("sigh", "yawn", "droop")
		found_sin_virtue = TRUE
	if (sin_virtue == ("gratitude") && !found_sin_virtue)
		sin_virtue = pick("gratitude", "thankfulness", "appreciation")
		emote_text = pick("smile", "bow")
		found_sin_virtue = TRUE
	if (sin_virtue == ("gluttony") && !found_sin_virtue)
		sin_virtue = pick("gluttony", "overindulgence", "excess", "binge")
		emote_text = pick("grin", "snicker", "lick_lips")
		found_sin_virtue = TRUE
	all_listeners = list()
	if(!isYelling)
		for (var/mob/living/carbon/human/listener in oviewers(7, owner))
			if (listener.stat != DEAD)
				all_listeners += listener
	if(isYelling)
		for (var/mob/living/carbon/human/listener in oviewers(10, owner))
			if (listener.stat != DEAD)
				all_listeners += listener
	spend_resources()

/datum/discipline_power/melpominee/madrigal/activate()
	. = ..()
	owner.say( song, forced = "melpominee 3")
	var/totalListeners = 0
	var/base_difficulty = 4
	for (var/mob/living/carbon/human/listener in all_listeners)
		totalListeners++
		var/botched_roll = FALSE
		if (isnpc(listener))
			base_difficulty -= 1
		if (iskindred(listener))
			var/datum/species/kindred/kindred_data = listener.dna.species
			if (listener.morality_path.score > 6 && isSin)
				if(!kindred_data.clane.is_enlightened) //Humanity
					base_difficulty -= 2
				if(kindred_data.clane.is_enlightened) //Enlightenment
					base_difficulty += 2
			if (listener.morality_path.score > 6 && !isSin)
				if(!kindred_data.clane.is_enlightened) //Humanity
					base_difficulty += 2
				if(kindred_data.clane.is_enlightened) //Enlightenment
					base_difficulty -= 2
		if (isgarou(listener))
			base_difficulty -= 1
		if(listener.mind) //Hunter and Priest Sin Resistance
			if (listener.mind.holy_role == HOLY_ROLE_PRIEST && isSin) //Have to roll EXTREMELY poorly to fail.
				base_difficulty -= 3
				to_chat(listener, span_notice("You sense [owner]'s melodic voice is full of candy coated sin..."))
		var/targetRoll = SSroll.storyteller_roll(listener.get_total_mentality(), base_difficulty, numerical = TRUE, mobs_to_show_output = listener)
		botched_roll = FALSE
		if (isnpc(listener) && casterRoll >= 3) // Botched, npcs don't have wisom.
			botched_roll = TRUE
		if (targetRoll < 0) // Botched, npcs don't have wisom.
			botched_roll = TRUE
		if (targetRoll > casterRoll && !botched_roll) // Success
			to_chat(listener, span_notice("You resist the pull of [owner]'s melodic voice. The feelings of [sin_virtue] their words project don't take hold of you, but linger..."))
			continue
		if (targetRoll <= casterRoll && !botched_roll) // Failure
			to_chat(listener, span_danger("The sound of [owner]'s voice strikes something deep and primal within you — [sin_virtue] rises within you, undeniable and fierce."))
			listener.emote(emote_text)
			listener.visible_message(span_notice("[listener] shows hints of [sin_virtue]."))
			continue
		if (super_fans < super_fan_perCast && botched_roll) //Superfan Generator
			if (istype(listener, /mob/living/carbon/human))
				var/datum/component/superfan/SF = listener.GetComponent(/datum/component/superfan)
				if (SF && SF.superfan_active)
					SF.superfan_emote = emote_text //updates current fans to match emotion
					to_chat(listener, span_danger("You lose yourself in primal feelings of [sin_virtue] stirred by [owner]'s voice, and are compelled to hear more."))
					listener.visible_message(span_notice("[listener] seems to give in to feelings of [sin_virtue]."))
					continue
			if (listener.client)
				listener.create_superfan(20, owner, emote_text)
				super_fans++
				to_chat(listener, span_danger("You lose yourself in primal feelings of [sin_virtue] stirred by [owner]'s voice, and are compelled to hear more."))
				listener.visible_message(span_notice("[listener] seems to give in to feelings of [sin_virtue]."))
				continue
			if (isnpc(listener))
				listener.create_superfan(60, owner, emote_text)
				super_fans++
				to_chat(listener, span_danger("You lose yourself in primal feelings of [sin_virtue] stirred by [owner]'s voice, and are compelled to hear more."))
				listener.visible_message(span_notice("[listener] seems to give in to feelings of [sin_virtue]."))
				continue
		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)
		addtimer(CALLBACK(src, PROC_REF(deactivate), listener), 2 SECONDS)
	to_chat(owner, span_warning("You feel your voice resonates with [sin_virtue]."))
	message_admins("[ADMIN_LOOKUPFLW(owner)] used Madrigal, a Melpominee 3 Power: Roll : [casterRoll], sin_virtue : [sin_virtue], Song : '[song].',  Mobs Affected: [totalListeners], SuperFans Made: [super_fans].")
	log_game("[key_name(owner)] used Madrigal, Melpominee 3 Power: Roll : [casterRoll], sin_virtue : [sin_virtue], Song : '[song].',  Mobs Affected: [totalListeners], SuperFans Made: [super_fans].")
	SSblackbox.record_feedback("tally", "madrigal", 1, song)

/datum/discipline_power/melpominee/madrigal/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//SuperFan Component: NPCs and Players.
/datum/component/superfan
	var/mob/living/superfan_target
	var/superfan_active = FALSE
	var/superfan_emote
	var/superfan_duration
	var/walk_started
/datum/component/superfan/Initialize(superfan_duration, mob/living/target, sin_virtue)
	start(superfan_duration, target, sin_virtue)
	. = ..()
/datum/component/superfan/proc/start(duration, mob/living/target, sin_virtue)
	if (superfan_active)
		return
	superfan_active = TRUE
	superfan_target = target
	superfan_emote = sin_virtue
	var/datum/callback/follow_cb = CALLBACK(src, PROC_REF(superfan_behavior))
	for (var/i in 1 to (duration * 2)) //2 ticks per second
		addtimer(follow_cb, (i - 1) * 1/2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(end)), duration * 1 SECONDS)
/datum/component/superfan/proc/superfan_behavior()
	var/mob/living/carbon/human/SF = parent
	var/distance = get_dist(SF, superfan_target)
	if (isnpc(SF)) // NPC logic, works from staying and walk target
		var/mob/living/carbon/human/npc/N = SF
		if (distance > 2 && !walk_started)
			N.staying = FALSE
			N.walktarget = superfan_target
			walk_started = TRUE
		if (distance <= 2)
			walk(SF, 0)
			N.staying = TRUE
			SF.dir = get_dir(SF, superfan_target)
			if (prob(1))
				SF.emote(superfan_emote)
			walk_started = FALSE
	if (SF.client) // Player logic
		if (distance > 3 && !walk_started)
			step_towards(SF, superfan_target)
			walk_started = TRUE
		if (distance <= 3)
			walk(SF, 0)
			SF.dir = get_dir(SF, superfan_target)
			walk_started = FALSE

		if (prob(1))
			SF.emote(superfan_emote)

/datum/component/superfan/proc/end()
	if(!QDELETED(src))
		qdel(src)
/datum/component/superfan/Destroy()
	if (isnpc(parent))
		var/mob/living/carbon/human/npc/N = parent
		walk(N, 0)
		N.staying = FALSE
		N.walktarget = N.ChoosePath()
	..()

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
