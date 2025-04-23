/obj/machinery/jukebox
	name = "jukebox"
	desc = "A classic music player."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "jukebox"
	base_icon_state = "jukebox"
	verb_say = "states"
	density = TRUE
	processing_flags = START_PROCESSING_MANUALLY
	/// Cooldown between "Error" sound effects being played
	COOLDOWN_DECLARE(jukebox_error_cd)
	/// Cooldown between being allowed to play another song
	COOLDOWN_DECLARE(jukebox_song_cd)
	/// TimerID to when the current song ends
	var/song_timerid
	/// The actual music player datum that handles the music
	var/datum/jukebox/music_player

/obj/machinery/jukebox/Initialize(mapload)
	. = ..()
	music_player = new(src)

/obj/machinery/jukebox/examine(mob/user)
	. = ..()
	if(music_player.active_song_sound)
		. += "Now playing: [music_player.selection.song_name]"

/obj/machinery/jukebox/Destroy()
	stop_music()
	QDEL_NULL(music_player)
	return ..()

/obj/machinery/jukebox/wrench_act(mob/living/user, obj/item/tool)
	if(!isnull(music_player.active_song_sound))
		return NONE

	if(default_unfasten_wrench(user, tool) == SUCCESSFUL_UNFASTEN)
		return TRUE

	return FALSE

/obj/machinery/jukebox/update_icon_state()
	icon_state = "[base_icon_state][music_player.active_song_sound ? "-active" : null]"
	return ..()

/obj/machinery/jukebox/ui_status(mob/user)
	if(isobserver(user))
		return ..()
	if(!anchored)
		to_chat(user,span_warning("This device must be anchored by a wrench!"))
		return UI_CLOSE
	if(!allowed(user))
		to_chat(user,span_warning("Error: Access Denied."))
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	if(!length(music_player.songs))
		to_chat(user,span_warning("Error: No music tracks have been authorized for your city. Petition the city council to resolve this issue."))
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return UI_CLOSE
	return ..()

/obj/machinery/jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/machinery/jukebox/ui_data(mob/user)
	return music_player.get_ui_data()

/obj/machinery/jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			if(isnull(music_player.active_song_sound))
				if(!COOLDOWN_FINISHED(src, jukebox_song_cd))
					to_chat(usr, span_warning("Error: The device is still resetting from the last activation, \
						it will be ready again in [DisplayTimeText(COOLDOWN_TIMELEFT(src, jukebox_song_cd))]."))
					if(COOLDOWN_FINISHED(src, jukebox_error_cd))
						playsound(src, 'sound/misc/compiler-failure.ogg', 33, TRUE)
						COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)
					return TRUE

				activate_music()
			else
				stop_music()

			return TRUE

		if("select_track")
			if(!isnull(music_player.active_song_sound))
				to_chat(usr, span_warning("Error: You cannot change the song until the current one is over."))
				return TRUE

			var/datum/track/new_song = music_player.songs[params["track"]]
			if(QDELETED(src) || !istype(new_song, /datum/track))
				return TRUE

			music_player.selection = new_song
			return TRUE

		if("set_volume")
			var/new_volume = params["volume"]
			if(new_volume == "reset" || new_volume == "max")
				music_player.set_volume_to_max()
			else if(new_volume == "min")
				music_player.set_new_volume(0)
			else if(isnum(text2num(new_volume)))
				music_player.set_new_volume(text2num(new_volume))
			return TRUE

		if("loop")
			music_player.sound_loops = !!params["looping"]
			return TRUE

/obj/machinery/jukebox/proc/activate_music()
	if(!isnull(music_player.active_song_sound))
		return FALSE

	music_player.start_music()
	update_icon()
	if(!music_player.sound_loops)
		song_timerid = addtimer(CALLBACK(src, PROC_REF(stop_music)), music_player.selection.song_length, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_DELETE_ME)
	return TRUE

/obj/machinery/jukebox/proc/stop_music()
	if(!isnull(song_timerid))
		deltimer(song_timerid)

	music_player.unlisten_all()

	if(!QDELING(src))
		COOLDOWN_START(src, jukebox_song_cd, 10 SECONDS)
		playsound(src,'sound/machines/terminal_off.ogg',50,TRUE)
		update_icon()
	return TRUE

/obj/machinery/jukebox/on_set_is_operational(old_value)
	if(!is_operational)
		stop_music()
