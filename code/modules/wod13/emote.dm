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
		var/mob/living/simple_animal/werewolf/wolf = user
		if(iscrinos(wolf))
			playsound(get_turf(wolf), 'code/modules/wod13/sounds/crinos_growl.ogg', 75, FALSE)
		if(islupus(wolf))
			playsound(get_turf(wolf), 'code/modules/wod13/sounds/lupus_growl.ogg', 75, FALSE)

/datum/emote/living/caw
		key = "caw"
		key_third_person = "caws"
		message = "caws!"
		emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/caw/run_emote(mob/user, params , type_override, intentional)
	. = ..()
	if(isgarou(user) && HAS_TRAIT(user, TRAIT_CORAX))
		var/mob/living/carbon/human/corax = user
		playsound(get_turf(corax), 'code/modules/wod13/sounds/cawcorvid.ogg', 100, FALSE)

	if(HAS_TRAIT(user, TRAIT_CORAX))
		var/mob/living/simple_animal/werewolf/corax/corax = user
		if(iscoraxcrinos(corax))
			playsound(get_turf(corax), 'code/modules/wod13/sounds/cawcrinos.ogg', 100, FALSE)
		if(iscorvid(corax))
			playsound(get_turf(corax), 'code/modules/wod13/sounds/cawcorvid.ogg', 100, FALSE)


/datum/emote/living/howl
	key = "howl"
	key_third_person = "howls"
	message = "howls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
