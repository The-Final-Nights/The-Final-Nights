/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	message = "sadly can't find anybody to give daps to, and daps themself. Shameful."
	message_param = "give daps to %t."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/glasses
	key = "glasses"
	key_third_person = "glasses"
	message = "pushes up their glasses."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/glasses/can_run_emote(mob/user, status_check = TRUE, intentional, params)
	var/obj/eyes_slot = user.get_item_by_slot(ITEM_SLOT_EYES)
	if(istype(eyes_slot, /obj/item/clothing/glasses) || istype(eyes_slot, /obj/item/clothing/glasses/sunglasses))
		return ..()
	return FALSE

/datum/emote/living/carbon/human/glasses/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/image/emote_animation = image('icons/mob/human/emote_visuals.dmi', user, "glasses")
	flick_overlay_view(emote_animation, user, 1.6 SECONDS)

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hands."
	message_param = "shakes hands with %t."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "hugs themself."
	message_param = "hugs %t."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	message_mime = "acts out a scream!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	vary = TRUE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ishuman(H))
		if(user.gender == FEMALE)
			return pick('sound/mobs/humanoids/human/scream/femalescream_1.ogg', 'sound/mobs/humanoids/human/scream/femalescream_2.ogg', 'sound/mobs/humanoids/human/scream/femalescream_3.ogg', 'sound/mobs/humanoids/human/scream/femalescream_4.ogg', 'sound/mobs/humanoids/human/scream/femalescream_5.ogg')
		else
			if(prob(1))
				return 'sound/mobs/humanoids/human/scream/wilhelm_scream.ogg'
			return pick('sound/mobs/humanoids/human/scream/malescream_1.ogg', 'sound/mobs/humanoids/human/scream/malescream_2.ogg', 'sound/mobs/humanoids/human/scream/malescream_3.ogg', 'sound/mobs/humanoids/human/scream/malescream_4.ogg', 'sound/mobs/humanoids/human/scream/malescream_5.ogg', 'sound/mobs/humanoids/human/scream/malescream_6.ogg')

/datum/emote/living/carbon/human/scream/screech //If a human tries to screech it'll just scream.
	key = "screech"
	key_third_person = "screeches"
	message = "screeches."
	emote_type = EMOTE_AUDIBLE
	vary = FALSE

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "goes pale for a second."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "raises a hand."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/smirk
	key = "smirk"
	key_third_person = "smirks"
	message = "smirks."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/squint
	key = "squint"
	key_third_person = "squints"
	message = "squints."
	emote_type = EMOTE_VISIBLE

// People cant see you squinting with sunglasses, moron.
/datum/emote/living/carbon/human/squint/can_run_emote(mob/user, status_check = TRUE, intentional, params)
	var/obj/eyes_slot = user.get_item_by_slot(ITEM_SLOT_EYES)
	if(istype(eyes_slot, /obj/item/clothing/glasses/sunglasses))
		return FALSE
	return ..()

/datum/emote/living/carbon/human/tut
	key = "tut"
	key_third_person = "tuts"
	message = "tuts."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "wags their tail."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_wag_tail(H))
		return
	if(!H.dna.species.is_wagging_tail())
		H.dna.species.start_wagging_tail(H)
	else
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.dna || !H.dna.species)
		return
	if(H.dna.species.is_wagging_tail())
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		if(findtext(select_message_type(user,intentional), "open"))
			H.OpenWings()
		else
			H.CloseWings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species.mutant_bodyparts["wings"])
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species && (H.dna.features["wings"] != "None"))
		return TRUE

/mob/living/carbon/human/proc/OpenWings()
	if(!dna || !dna.species)
		return
	if(dna.species.mutant_bodyparts["wings"])
		dna.species.mutant_bodyparts["wingsopen"] = dna.species.mutant_bodyparts["wings"]
		dna.species.mutant_bodyparts -= "wings"
	update_body()

/mob/living/carbon/human/proc/CloseWings()
	if(!dna || !dna.species)
		return
	if(dna.species.mutant_bodyparts["wingsopen"])
		dna.species.mutant_bodyparts["wings"] = dna.species.mutant_bodyparts["wingsopen"]
		dna.species.mutant_bodyparts -= "wingsopen"
	update_body()
	if(isturf(loc))
		var/turf/T = loc
		T.Entered(src)

/datum/emote/living/carbon/human/clear_throat
	key = "clear"
	key_third_person = "clears throat"
	message = "clears their throat."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/blink
	key = "blink"
	key_third_person = "blinks"
	message = "blinks."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/blink/get_sound(mob/living/user)
	return 'sound/mobs/humanoids/human/blink/blink.ogg'

/datum/emote/living/carbon/human/blink_r
	key = "blink_r"
	name = "blink (Rapid)"
	message = "blinks rapidly."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/blink_r/get_sound(mob/living/user)
	return 'sound/mobs/humanoids/human/blink/blinkrapid.ogg'

/datum/emote/living/carbon/human/snap
	emote_type = EMOTE_AUDIBLE
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	vary = TRUE

/datum/emote/living/carbon/human/snap/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	// sorry pal, but you need an arm to snap
	var/mob/living/carbon/C = user
	return C.get_bodypart(BODY_ZONE_L_ARM) || C.get_bodypart(BODY_ZONE_R_ARM)

/datum/emote/living/carbon/human/snap/one
	key = "snap"
	key_third_person = "snaps"
	message = "snaps their fingers."
	message_param = "snaps their fingers at %t"
	sound = 'sound/mobs/humanoids/human/snap/snap.ogg'

/datum/emote/living/carbon/human/snap/two
	key = "snap2"
	key_third_person = "snaps2"
	message = "snaps their fingers twice."
	message_param = "snaps their fingers at %t twice"
	sound = 'sound/mobs/humanoids/human/snap/snap2.ogg'

/datum/emote/living/carbon/human/snap/three
	key = "snap3"
	key_third_person = "snaps3"
	message = "snaps their fingers thrice."
	message_param = "snaps their fingers at %t thrice"
	sound = 'sound/mobs/humanoids/human/snap/snap3.ogg'


/datum/emote/living/carbon/human/sign
	key = "sign"
	key_third_person = "signs"
	message_param = "signs the number %t."
	mob_type_allowed_typecache = list(/mob/living/carbon/alien)
	hands_use_check = TRUE

/datum/emote/living/carbon/human/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/human/sign/signal
	key = "signal"
	key_third_person = "signals"
	message_param = "raises %t fingers."
	mob_type_allowed_typecache = list(/mob/living/carbon/human)
	hands_use_check = TRUE

///Snowflake emotes only for le epic chimp
/datum/emote/living/carbon/human/monkey

/datum/emote/living/carbon/human/monkey/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(ismonkey(user))
		return ..()
	return FALSE

/datum/emote/living/carbon/human/monkey/gnarl
	key = "gnarl"
	key_third_person = "gnarls"
	message = "gnarls and shows its teeth..."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/monkey/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/monkey/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/monkey/screech/roar
	key = "roar"
	key_third_person = "roars"
	message = "roars."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/human/monkey/tail
	key = "tail"
	message = "waves their tail."
	emote_type = EMOTE_VISIBLE


/datum/emote/living/carbon/human/monkeysign
	key = "sign"
	key_third_person = "signs"
	message_param = "signs the number %t."
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/vomit
	key = "vomit"
	key_third_person = "vomits"

/datum/emote/living/carbon/human/vomit/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/mob/living/carbon/human/living = user
	if(iskindred(user) || iscathayan(user))
		living.vomit(force = TRUE, blood = TRUE)
	else
		living.vomit(force = TRUE)

