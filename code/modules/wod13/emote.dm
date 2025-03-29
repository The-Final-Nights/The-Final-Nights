/datum/emote/living/growl
	key = "growl"
	key_third_person = "growls"
	message = "growls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/growl/run_emote(mob/user, params , type_override, intentional)
	. = ..()
	if(isgarou(user))
		var/mob/living/carbon/human/wolf = user
		if(wolf.gender == FEMALE)
			playsound(get_turf(wolf), 'code/modules/wod13/sounds/female_growl.ogg', 75, FALSE)
		else
			playsound(get_turf(wolf), 'code/modules/wod13/sounds/male_growl.ogg', 75, FALSE)
		return

	if(iswerewolf(user))
		var/mob/living/carbon/werewolf/wolf = user
		if(iscrinos(wolf))
			playsound(get_turf(wolf), 'code/modules/wod13/sounds/crinos_growl.ogg', 75, FALSE)
		if(islupus(wolf))
			playsound(get_turf(wolf), 'code/modules/wod13/sounds/lupus_growl.ogg', 75, FALSE)

/datum/emote/living/howl
	key = "howl"
	key_third_person = "howls"
	message = "howls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
