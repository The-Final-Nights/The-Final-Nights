#define MASQUERADE_FILTER_CHECK(T) (SSmasquerade.masquerade_breaching_phrase_regex && findtext(T, SSmasquerade.masquerade_breaching_phrase_regex))

/mob/living/carbon/human/npc/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(stat >= SOFT_CRIT)
		return ..()

	if(issabbat(src)) //Because sabbatists are idiots.
		return ..()

	var/treated_message = lang_treat(speaker, message_language, message, spans, message_mods)
	if(lowertext(MASQUERADE_FILTER_CHECK(treated_message)))
		SEND_SIGNAL(src, COMSIG_SEEN_MASQUERADE_VIOLATION, speaker)
	..()

/obj/item/vamp/phone/handle_hearing(datum/source, list/hearing_args)
	if(online && talking)
		if(istype(hearing_args[HEARING_SPEAKER], /obj/phonevoice))
			return ..()
		if(lowertext(MASQUERADE_FILTER_CHECK(hearing_args[HEARING_RAW_MESSAGE])))
			SEND_SIGNAL(src, COMSIG_SEEN_MASQUERADE_VIOLATION, hearing_args[HEARING_SPEAKER])
	..()

#undef MASQUERADE_FILTER_CHECK
