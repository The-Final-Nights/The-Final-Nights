GLOBAL_VAR_INIT(avatar_default_invisibility, INVISIBILITY_AVATAR)
GLOBAL_LIST_INIT(avatar_banned_verbs, list(
	/mob/dead/observer/verb/follow,
	/mob/dead/observer/verb/jumptomob,
	/mob/dead/observer/verb/toggle_ghostsee,
	/mob/dead/observer/verb/toggle_darkness,
	/mob/dead/observer/verb/view_manifest,
	/mob/dead/observer/verb/toggle_data_huds,
	/mob/dead/observer/verb/observe,
	/mob/dead/observer/verb/register_pai_candidate,
	/mob/dead/observer/verb/stay_dead,
	/mob/dead/observer/proc/dead_tele,
	/mob/dead/observer/proc/open_spawners_menu,
))

/// Astral avatar for Auspex lvl. 5 ability.
/mob/dead/observer/avatar
	invisibility = INVISIBILITY_AVATAR
	see_invisible = SEE_INVISIBLE_AVATAR
	can_reenter_corpse = TRUE
	var/mob_biotype = MOB_SPIRIT

/mob/dead/observer/avatar/Initialize()
	. = ..()
	set_invisibility(GLOB.avatar_default_invisibility)
	add_to_avatar_list()

	remove_verb(src, GLOB.avatar_banned_verbs)

	sight = NONE
	movement_type = FLYING | GROUND | PHASING

/mob/dead/observer/avatar/Destroy()
	remove_from_avatar_list()

	return ..()

/mob/living/carbon/human/proc/enter_avatar()
	RETURN_TYPE(/mob/dead/observer/avatar)

	stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/dead/observer/avatar/auspex_avatar = new(src)

	SStgui.on_transfer(src, auspex_avatar)
	auspex_avatar.icon = src.icon
	auspex_avatar.overlays = src.overlays
	auspex_avatar.key = key
	auspex_avatar.client.init_verbs()
	auspex_avatar.client = src.client
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTEARS
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTWHISPER
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTSIGHT
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTRADIO
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTPDA
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_GHOSTLAWS
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_LOGIN_LOGOUT
	auspex_avatar.client.prefs.chat_toggles &= ~CHAT_DEAD

	auspex_avatar.overlay_fullscreen("film_grain", /atom/movable/screen/fullscreen/film_grain, rand(1, 9))

	return auspex_avatar

/mob/dead/observer/avatar/reenter_corpse()
	if(!client)
		return FALSE
	if(!mind || QDELETED(mind.current))
		to_chat(src, span_warning("You have no body."))
		return FALSE
	if(!can_reenter_corpse)
		to_chat(src, span_warning("You cannot re-enter your body."))
		return FALSE

	var/mob/living/carbon/human/original_body = mind.current
	var/turf/current_turf = get_turf(src)
	var/turf/body_turf = get_turf(original_body)

	if(isnull(body_turf) || isnull(current_turf))
		return FALSE
	if(!(body_turf == current_turf))
		to_chat(src, span_warning("Your body is not here. It is located at coordinates: [body_turf.x], [body_turf.y], [body_turf.z]."))
		to_chat(src, span_warning("Your current coordinates are: [current_turf.x], [current_turf.y], [current_turf.z]."))
		return FALSE
	if(mind.current.key && mind.current.key[1] != "@")	//makes sure we don't accidentally kick any clients
		to_chat(usr, span_warning("Another consciousness is in your body...It is resisting you."))
		return FALSE

	client.view_size.setDefault(getScreenSize(client.prefs.widescreenpref))//Let's reset so people can't become allseeing gods
	SStgui.on_transfer(src, mind.current)
	mind.current.key = key
	mind.current.client.init_verbs()
	original_body.soul_state = SOUL_PRESENT

	return TRUE

/mob/dead/observer/avatar/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	return

/mob/dead/observer/avatar/say_dead(message)
	return

// Auspex Avatars can't manually orbit people.
/mob/dead/observer/avatar/ManualFollow(atom/movable/target)
	return
