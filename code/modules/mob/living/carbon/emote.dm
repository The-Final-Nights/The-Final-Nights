/datum/emote/living/carbon
	mob_type_allowed_typecache = list(/mob/living/carbon)

/datum/emote/living/carbon/airguitar
	key = "airguitar"
	message = "is strumming the air and headbanging like a safari chimp."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/clap
	key = "clap"
	key_third_person = "claps"
	message = "claps."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	vary = TRUE

/datum/emote/living/carbon/clap/get_sound(mob/living/user)
	if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
		return
	return pick(
		'sound/mobs/humanoids/human/clap/clap1.ogg',
		'sound/mobs/humanoids/human/clap/clap2.ogg',
		'sound/mobs/humanoids/human/clap/clap3.ogg',
		'sound/mobs/humanoids/human/clap/clap4.ogg',
	)

/datum/emote/living/carbon/eyeroll
	key = "eyeroll"
	key_third_person = "eyerolls"
	message = "rolls their eyes"
	vary = TRUE
	mob_type_blacklist_typecache = list(/mob/living/carbon/alien)

/datum/emote/living/carbon/eyeroll/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	var/obj/eyes_slot = user.get_item_by_slot(ITEM_SLOT_EYES)
	if(istype(eyes_slot, /obj/item/clothing/glasses/sunglasses)) //People can't see you rolling your eyes behind the glasses.
		return FALSE
	var/obj/item/organ/eyes/E = user.getorganslot(ORGAN_SLOT_EYES)
	return istype(E)

/datum/emote/living/carbon/crack
	key = "crack"
	key_third_person = "cracks"
	message = "cracks their knuckles."
	sound = 'sound/mobs/humanoids/human/knuckle_crack/knuckles.ogg'
	hands_use_check = TRUE
	cooldown = 6 SECONDS

/datum/emote/living/carbon/crack/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional, params)
	if(!iscarbon(user) || user.usable_hands < 2)
		return FALSE
	return ..()

/datum/emote/living/carbon/moan
	key = "moan"
	key_third_person = "moans"
	message = "moans!"
	message_mime = "appears to moan!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/tail
	key = "tail"
	message = "waves their tail."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)

/datum/emote/living/carbon/wink
	key = "wink"
	key_third_person = "winks"
	message = "winks."

/datum/emote/living/carbon/sweatdrop
	key = "sweatdrop"
	key_third_person = "sweatdrops"
	message = "sweats"
	emote_type = EMOTE_VISIBLE
	vary = TRUE

/datum/emote/living/carbon/sweatdrop/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/image/I = image('icons/mob/human/emote_visuals.dmi', user, "sweatdrop", ABOVE_MOB_LAYER, 0, 10, 10)
	flick_overlay_view(I, user, 3 SECONDS)

/datum/emote/living/carbon/sweatdrop/get_sound(mob/living/user)
	return 'sound/mobs/humanoids/human/sweat/sweatdrop.ogg'

/datum/emote/living/carbon/sweatdrop/sweat //This is entirely the same as sweatdrop, however people might use either, so i'm adding this one instead of editing the other one.
	key = "sweat"

/datum/emote/living/carbon/annoyed
	key = "annoyed"
	emote_type = EMOTE_VISIBLE
	vary = TRUE

/datum/emote/living/carbon/annoyed/get_sound(mob/living/user)
	return 'sound/mobs/humanoids/human/annoyed/annoyed.ogg'

/datum/emote/living/carbon/annoyed/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/image/I = image('icons/mob/human/emote_visuals.dmi', user, "annoyed", ABOVE_MOB_LAYER, 0, 10, 10)
	flick_overlay_view(I, user, 5 SECONDS)

/datum/emote/living/carbon/circle
	key = "circle"
	key_third_person = "circles"
	hands_use_check = TRUE

/datum/emote/living/carbon/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, "<span class='warning'>You don't have any free hands to make a circle with.</span>")
		return
	var/obj/item/hand_item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, "<span class='notice'>You make a circle with your hand.</span>")

/datum/emote/living/carbon/slap
	key = "slap"
	key_third_person = "slaps"
	hands_use_check = TRUE

/datum/emote/living/carbon/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/obj/item/hand_item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, "<span class='notice'>You ready your slapping hand.</span>")
	else
		qdel(N)
		to_chat(user, "<span class='warning'>You're incapable of slapping in your current state.</span>")

/datum/emote/living/carbon/noogie
	key = "noogie"
	key_third_person = "noogies"
	hands_use_check = TRUE

/datum/emote/living/carbon/noogie/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/obj/item/hand_item/noogie/noogie = new(user)
	if(user.put_in_hands(noogie))
		to_chat(user, "<span class='notice'>You ready your noogie'ing hand.</span>")
	else
		qdel(noogie)
		to_chat(user, "<span class='warning'>You're incapable of noogie'ing in your current state.</span>")

