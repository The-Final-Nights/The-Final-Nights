// vocal sound channel define
#define CHANNEL_VOCAL_SOUNDS 909

/mob/living/carbon/human/proc/send_voice(message, skip_thingy)
	if(!message || !length(message))
		return
	if(dna.species)
		dna.species.send_voice(src)

/mob/living/carbon/human/send_speech(message, message_range = 6, obj/source = src, bubble_type = bubble_icon, list/spans, datum/language/message_language=null, message_mods, original_message)
	. = ..()
	if(!message_mods[WHISPER_MODE])
		send_voice(message)

/datum/species/proc/send_voice(mob/living/L)
	// Only play sounds for mobs with a ckey (player-controlled)
	if(!L.ckey)
		return

	var/vocal_sound_pref = L.client?.prefs?.vocal_sound || "Talk"

	var/sound_file
	switch(vocal_sound_pref)
		if("Talk")
			sound_file = 'modular_tfn/modules/saysounds/sounds/talk.ogg'
		if("Pencil")
			sound_file = 'modular_tfn/modules/saysounds/sounds/pencil.ogg'
		if("None")
			return
		else
			sound_file = 'modular_tfn/modules/saysounds/sounds/talk.ogg' // Default fallback

	var/vocal_frequency = rand(95, 105) / 100 // 0.95 to 1.05 (5% variation)
	playsound(L, sound_file, 100, TRUE, 0, SOUND_FALLOFF_EXPONENT, vocal_frequency, CHANNEL_VOCAL_SOUNDS, FALSE)

// playsound_local override to check for CHANNEL_VOCAL_SOUNDS
/mob/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent = SOUND_FALLOFF_EXPONENT, channel = 0, sound/S, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE)

	// before running original playsound_local, check if the playsound is channel_vocal_sounds, and if they have the pref turned on, if they do, dont play that channel
	if(channel == CHANNEL_VOCAL_SOUNDS && client?.prefs?.disable_vocal_sounds)
		return

	// run original playsound_local
	return ..()
