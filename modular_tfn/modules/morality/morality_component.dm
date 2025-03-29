/datum/component/morality
	// TODO: Put SOMETHING here?

/datum/component/morality/Initialize()
	if(!iskindred(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_PATH_HIT, PROC_REF(adjust_morality))

/datum/component/morality/proc/adjust_morality(datum/source, type, limit)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/kindred = parent

	if(SIGN(type) == -1)
		for(var/mob/living/carbon/human/H in viewers(7, kindred))
			if(H != kindred && H.mind?.dharma)
				if("judgement" in H.mind.dharma.tenets)
					to_chat(H, span_warning("[kindred] is doing something bad, I need to punish them!"))
					H.mind.dharma.judgement |= kindred.real_name

	if(!iskindred(kindred))
		return
	if(!GLOB.canon_event)
		return
	if(is_special_character(kindred))
		return
	if(kindred.in_frenzy)
		return
	// Don't get another path hit if cooldown is up
	if(TIMER_COOLDOWN_CHECK(kindred.morality_path, COOLDOWN_PATH_HIT))
		return

	var/path_rating = kindred.morality_path.score

	switch(kindred.morality_path.alignment)
		if(MORALITY_HUMANITY)
			switch(SIGN(type))
				if(PATH_SCORE_UP)
					path_rating += 1
					SEND_SOUND(kindred, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
					to_chat(kindred, span_userdanger("<b>HUMANITY INCREASED!</b>"))
				if(PATH_SCORE_DOWN)
					if(path_rating-1 < limit)
						return
					path_rating -= 1
					SEND_SOUND(kindred, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
					to_chat(kindred, span_userdanger("<b>HUMANITY DECREASED!</b>"))

					if(path_rating < 5)
						to_chat(kindred, span_userdanger("<b>If I don't stop, I will succumb to the Beast.</b>"))
					else if(path_rating < 3)
						var/intrusive_thoughts = pick("<b>I can barely control the Beast!</b>", "<b>I SHOULD STOP.</b>", "<b>I'm succumbing to the Beast!</b>")
						to_chat(kindred, span_userdanger(intrusive_thoughts))
		if(MORALITY_ENLIGHTENMENT)
			// ? Enlightenment paths go UP if the value is negative and DOWN if the value is positive, so the following is correct
			switch(SIGN(type))
				if(PATH_SCORE_DOWN)
					path_rating += 1
					SEND_SOUND(kindred, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
					to_chat(kindred, span_userdanger("<b>ENLIGHTENMENT INCREASED!</b>"))
				if(PATH_SCORE_UP)
					if(path_rating-1 < limit)
						return
					path_rating -= 1
					SEND_SOUND(kindred, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
					to_chat(kindred, span_userdanger("<b>ENLIGHTENMENT DECREASED!</b>"))
		else
			return

	kindred.morality_path.score = clamp(path_rating, 0, 10)
	S_TIMER_COOLDOWN_START(kindred.morality_path, COOLDOWN_PATH_HIT, 5 MINUTES)
