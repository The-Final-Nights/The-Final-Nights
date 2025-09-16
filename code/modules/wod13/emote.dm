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
		var/mob/living/carbon/werewolf/corax/corax = user
		if(iscoraxcrinos(corax))
			playsound(get_turf(corax), 'code/modules/wod13/sounds/cawcrinos.ogg', 100, FALSE)
		if(iscorvid(corax))
			playsound(get_turf(corax), 'code/modules/wod13/sounds/cawcorvid.ogg', 100, FALSE)


/datum/emote/living/howl
	key = "howl"
	key_third_person = "howls"
	message = "howls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

//TFN EDIT START - Small Emote Expansion #808 - Does The Thing

/datum/emote/living/snarl
	key = "snarl"
	key_third_person = "snarls"
	message = "snarls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/bark
	key = "bark"
	key_third_person = "barks"
	message = "barks."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/whine
	key = "whine"
	key_third_person = "whines"
	message = "whines."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/vhiss
	key = "vhiss"
	key_third_person = "vhisses"
	message = "hisses viciously!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/qhiss
	key = "qhiss"
	key_third_person = "qhiss"
	message = "hisses quietly."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/fanggrin
	key = "fgrin"
	key_third_person = "fgrins"
	message = "grins widely, fangs bared."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/fanglick
	key = "fanglick"
	key_third_person = "fanglicks"
	message = "runs their tongue over their fangs."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/grit
	key = "grit"
	key_third_person = "grits"
	message = "forcefully grits their teeth."
	emote_type = EMOTE_VISIBLE

//TFN EDIT END - Small Emote Expansion #808
