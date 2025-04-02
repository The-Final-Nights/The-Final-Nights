
/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typecache = /mob/living
	mob_type_blacklist_typecache = list(/mob/living/simple_animal/slime, /mob/living/brain)

/datum/emote/living/blush
	key = "blush"
	key_third_person = "blushes"
	message = "blushes."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/sing_tune
	key = "tunesing"
	key_third_person = "sings a tune"
	message = "sings a tune."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/bow
	key = "bow"
	key_third_person = "bows"
	message = "bows."
	message_param = "bows to %t."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/burp
	key = "burp"
	key_third_person = "burps"
	message = "burps."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "chokes!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/cross
	key = "cross"
	key_third_person = "crosses"
	message = "crosses their arms."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "chuckles."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/collapse
	key = "collapse"
	key_third_person = "collapses"
	message = "collapses!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(isliving(user))
		var/mob/living/living = user
		living.Unconscious(4 SECONDS)

/datum/emote/living/dance
	key = "dance"
	key_third_person = "dances"
	message = "dances around happily."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/deathgasp
	key = "deathgasp"
	key_third_person = "deathgasps"
	message = "seizes up and falls limp, their eyes dead and lifeless..."
	message_robot = "shudders violently for a moment before falling still, its eyes slowly darkening."
	message_AI = "screeches, its screen flickering as its systems slowly halt."
	message_alien = "lets out a waning guttural screech, and collapses onto the floor..."
	message_larva = "lets out a sickly hiss of air and falls limply to the floor..."
	message_monkey = "lets out a faint chimper as it collapses and stops moving..."
	message_simple =  "stops moving..."
	cooldown = (15 SECONDS)
	stat_allowed = HARD_CRIT

/datum/emote/living/deathgasp/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/simple_animal/S = user
	if(istype(S) && S.deathmessage)
		message_simple = S.deathmessage
	. = ..()
	message_simple = initial(message_simple)

	if(. && user.deathsound)
		if(isliving(user))
			var/mob/living/L = user
			if(!L.can_speak_vocal() || L.oxyloss >= 50)
				return //stop the sound if oxyloss too high/cant speak
		playsound(user, user.deathsound, 200, TRUE, TRUE)

/datum/emote/living/drool
	key = "drool"
	key_third_person = "drools"
	message = "drools."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/faint
	key = "faint"
	key_third_person = "faints"
	message = "faints."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(isliving(user))
		var/mob/living/living = user
		living.SetSleeping(20 SECONDS)

/datum/emote/living/flap
	key = "flap"
	key_third_person = "flaps"
	message = "flaps their wings."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	var/wing_time = 0.35 SECONDS

/datum/emote/living/flap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/open = FALSE
		if(H.dna.features["wings"] != "None")
			if(H.dna.species.mutant_bodyparts["wingsopen"])
				open = TRUE
				H.CloseWings()
			else
				H.OpenWings()
			addtimer(CALLBACK(H, open ? TYPE_PROC_REF(/mob/living/carbon/human, OpenWings) : TYPE_PROC_REF(/mob/living/carbon/human, CloseWings)), wing_time)

/datum/emote/living/flap/aflap
	key = "aflap"
	key_third_person = "aflaps"
	name = "flap (Angry)"
	message = "flaps their wings ANGRILY!"
	hands_use_check = TRUE
	wing_time = 10
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frowns."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/gag
	key = "gag"
	key_third_person = "gags"
	message = "gags."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/gasp
	key = "gasp"
	key_third_person = "gasps"
	message = "gasps!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	stat_allowed = HARD_CRIT

/datum/emote/living/gasp/get_sound(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user
	if(human_user.physique == FEMALE)
		return pick(
			'sound/mobs/humanoids/human/gasp/gasp_female1.ogg',
			'sound/mobs/humanoids/human/gasp/gasp_female2.ogg',
			'sound/mobs/humanoids/human/gasp/gasp_female3.ogg',
			)
	return pick(
		'sound/mobs/humanoids/human/gasp/gasp_male1.ogg',
		'sound/mobs/humanoids/human/gasp/gasp_male2.ogg',
		)

/datum/emote/living/gasp/shock
	key = "gaspshock"
	key_third_person = "gaspsshock"
	name = "gasp (Shock)"
	message = "gasps in shock!"
	message_mime = "gasps in silent shock!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	stat_allowed = SOFT_CRIT

/datum/emote/living/giggle
	key = "giggle"
	key_third_person = "giggles"
	message = "giggles."
	message_mime = "giggles silently!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/glare
	key = "glare"
	key_third_person = "glares"
	message = "glares."
	message_param = "glares at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/grin
	key = "grin"
	key_third_person = "grins"
	message = "grins."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/groan
	key = "groan"
	key_third_person = "groans"
	message = "groans!"
	message_mime = "appears to groan!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/grimace
	key = "grimace"
	key_third_person = "grimaces"
	message = "grimaces."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/must_breathe/huff
	key = "huff"
	key_third_person = "huffs"
	message ="lets out a huff!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/kiss
	key = "kiss"
	key_third_person = "kisses"
	cooldown = 3 SECONDS
	emote_type = EMOTE_VISIBLE

/datum/emote/living/kiss/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	var/obj/item/kiss_blower = new /obj/item/hand_item/kisser(user)
	if(user.put_in_hands(kiss_blower))
		to_chat(user, span_notice("You ready your kiss-blowing hand."))
		return

	qdel(kiss_blower)
	to_chat(user, span_warning("You're incapable of blowing a kiss in your current state."))

/datum/emote/living/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "laughs."
	message_mime = "laughs silently!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	vary = TRUE

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent

/datum/emote/living/laugh/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_laugh_sound(user)

/datum/emote/living/look
	key = "look"
	key_third_person = "looks"
	message = "looks."
	message_param = "looks at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/nod
	key = "nod"
	key_third_person = "nods"
	message = "nods."
	message_param = "nods at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/point
	key = "point"
	key_third_person = "points"
	message = "points."
	message_param = "points at %t."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/point/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.usable_hands == 0)
			if(H.usable_legs != 0)
				message_param = "tries to point at %t with a leg, <span class='userdanger'>falling down</span> in the process!"
				H.Paralyze(20)
			else
				message_param = "<span class='userdanger'>bumps [user.p_their()] head on the ground</span> trying to motion towards %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	return ..()

/datum/emote/living/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "sneezes."
	message_mime = "acts out an exaggerated silent sneeze."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/sneeze/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_sneeze_sound(user)

/datum/emote/living/cough
	key = "cough"
	key_third_person = "coughs"
	message = "coughs!"
	message_mime = "acts out an exaggerated cough!"
	vary = TRUE
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE | EMOTE_RUNECHAT

/datum/emote/living/cough/can_run_emote(mob/user, status_check = TRUE , intentional, params)
	return !HAS_TRAIT(user, TRAIT_SOOTHED_THROAT) && ..()

/datum/emote/living/cough/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_cough_sound(user)

/datum/emote/living/pout
	key = "pout"
	key_third_person = "pouts"
	message = "pouts."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams."
	message_mime = "acts out a scream!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	mob_type_blacklist_typecache = list(/mob/living/carbon/human) //Humans get specialized scream.

/datum/emote/living/scream/select_message_type(mob/user, intentional)
	. = ..()
	if(!intentional && isanimal(user))
		return "makes a loud and pained whimper."

/datum/emote/living/scowl
	key = "scowl"
	key_third_person = "scowls"
	message = "scowls."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/shake
	key = "shake"
	key_third_person = "shakes"
	message = "shakes their head."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/shiver
	key = "shiver"
	key_third_person = "shiver"
	message = "shivers."
	emote_type = EMOTE_VISIBLE

#define SHIVER_LOOP_DURATION (1 SECONDS)
/datum/emote/living/shiver/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	animate(user, pixel_w = 1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
	for(var/i in 1 to SHIVER_LOOP_DURATION / (0.2 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
		animate(pixel_w = -2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
		animate(pixel_w = 2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
	animate(pixel_w = -1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
#undef SHIVER_LOOP_DURATION

/datum/emote/living/sigh
	key = "sigh"
	key_third_person = "sighs"
	message = "sighs."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/sigh/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(!ishuman(user))
		return
	var/image/emote_animation = image('icons/mob/human/emote_visuals.dmi', user, "sigh")
	flick_overlay_view(emote_animation, user, 2.0 SECONDS)

/datum/emote/living/sigh/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_sigh_sound(user)

/datum/emote/living/sit
	key = "sit"
	key_third_person = "sits"
	message = "sits down."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/smile
	key = "smile"
	key_third_person = "smiles"
	message = "smiles."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/smug
	key = "smug"
	key_third_person = "smugs"
	message = "grins smugly."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/sniff
	key = "sniff"
	key_third_person = "sniffs"
	message = "sniffs."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/sniff/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_sniff_sound(user)

/datum/emote/living/snore
	key = "snore"
	key_third_person = "snores"
	message = "snores."
	message_mime = "sleeps soundly."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/datum/emote/living/snore/get_sound(mob/living/carbon/human/user)
	if(!istype(user))
		return
	return user.dna.species.get_snore_sound(user)

/datum/emote/living/stare
	key = "stare"
	key_third_person = "stares"
	message = "stares."
	message_param = "stares at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/strech
	key = "stretch"
	key_third_person = "stretches"
	message = "stretches their arms."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/sulk
	key = "sulk"
	key_third_person = "sulks"
	message = "sulks down sadly."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/surrender
	key = "surrender"
	key_third_person = "surrenders"
	message = "puts their hands on their head and falls to the ground, they surrender!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/surrender/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Paralyze(20 SECONDS)
		L.remove_status_effect(STATUS_EFFECT_SURRENDER)

/datum/emote/living/sway
	key = "sway"
	key_third_person = "sways"
	message = "sways around dizzily."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/sway/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	animate(user, pixel_w = 2, time = 0.5 SECONDS, flags = ANIMATION_RELATIVE)
	for(var/i in 1 to 2)
		animate(pixel_w = -6, time = 1.0 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
		animate(pixel_w = 6, time = 1.0 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
	animate(pixel_w = -2, time = 0.5 SECONDS, flags = ANIMATION_RELATIVE)

/datum/emote/living/tilt
	key = "tilt"
	key_third_person = "tilts"
	message = "tilts their head to the side."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/tremble
	key = "tremble"
	key_third_person = "trembles"
	message = "trembles in fear!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

#define TREMBLE_LOOP_DURATION (4.4 SECONDS)
/datum/emote/living/tremble/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	animate(user, pixel_w = 2, time = 0.2 SECONDS, flags = ANIMATION_RELATIVE)
	for(var/i in 1 to TREMBLE_LOOP_DURATION / (0.4 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
		animate(pixel_w = -4, time = 0.2 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
		animate(pixel_w = 4, time = 0.2 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
	animate(pixel_w = -2, time = 0.2 SECONDS, flags = ANIMATION_RELATIVE)
#undef TREMBLE_LOOP_DURATION

/datum/emote/living/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "twitches violently."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/twitch/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	animate(user, pixel_w = 1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_w = -2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(time = 0.1 SECONDS)
	animate(pixel_w = 2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_w = -1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)

/datum/emote/living/twitch_s
	key = "twitch_s"
	name = "twitch (Slight)"
	message = "twitches."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/twitch_s/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()

	animate(user, pixel_w = -1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_w = 1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)

/datum/emote/living/wave
	key = "wave"
	key_third_person = "waves"
	message = "waves."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."
	message_mime = "appears hurt."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/wsmile
	key = "wsmile"
	key_third_person = "wsmiles"
	message = "smiles weakly."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "yawns."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/gurgle
	key = "gurgle"
	key_third_person = "gurgles"
	message = "makes an uncomfortable gurgle."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
	message = null
/datum/emote/living/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	var/static/regex/stop_bad_mime = regex(@"says|exclaims|yells|asks")
	if(stop_bad_mime.Find(input, 1, 1))
		to_chat(user, span_danger("Invalid emote."))
		return TRUE
	return FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	var/custom_emote
	var/custom_emote_type
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, span_boldwarning("You cannot send custom emotes (banned)."))
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("You cannot send IC messages (muted)."))
		return FALSE
	else if(!params)
		custom_emote = copytext(sanitize(input("Choose an emote to display.") as text|null), 1, MAX_MESSAGE_LEN)
		if(custom_emote && !check_invalid(user, custom_emote))
			var/type = input("Is this a visible or hearable emote?") as null|anything in list("Visible", "Hearable", "Both")
			switch(type)
				if("Visible")
					custom_emote_type = EMOTE_VISIBLE
				if("Hearable")
					custom_emote_type = EMOTE_AUDIBLE
				if("Both")
					custom_emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
				else
					tgui_alert(usr,"Unable to use this emote, must be either hearable or visible.")
					return
	else
		custom_emote = params
		if(type_override)
			custom_emote_type = type_override
	message = custom_emote
	emote_type = custom_emote_type
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/inhale
	key = "inhale"
	key_third_person = "inhales"
	message = "breathes in."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/exhale
	key = "exhale"
	key_third_person = "exhales"
	message = "breathes out."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/datum/emote/living/swear
	key = "swear"
	key_third_person = "swears"
	message = "says a swear word!"
	message_mime = "makes a rude gesture!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "whistles."
	message_mime = "whistles silently!"
	vary = TRUE
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/whistle/get_sound(mob/living/user)
	return 'sound/mobs/humanoids/human/whistle/whistle1.ogg'

/datum/emote/living/carbon/hum
	key = "hum"
	key_third_person = "hums"
	message = "hums a tune."
	emote_type = EMOTE_AUDIBLE
