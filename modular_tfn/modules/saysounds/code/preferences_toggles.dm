// Vocal Sound Preference Verbs
/client/verb/change_vocal_sound()
	set name = "Change Vocal Sound"
	set category = "Preferences"
	set desc = "Change what sound plays when you speak."

	var/list/sound_options = list("Talk", "Pencil", "None")
	var/new_sound = tgui_input_list(usr, "Choose your vocal sound:", "Vocal Sound", sound_options, prefs.vocal_sound)

	if(new_sound && new_sound != prefs.vocal_sound)
		prefs.vocal_sound = new_sound
		prefs.save_preferences()
		to_chat(usr, "Your vocal sound has been changed to: [new_sound]")
		SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Change Vocal Sound", new_sound))

/client/verb/toggle_vocal_sounds()
	set name = "Toggle Vocal Sounds"
	set category = "Preferences"
	set desc = "Enable or disable hearing vocal sounds from other players."

	prefs.disable_vocal_sounds = !prefs.disable_vocal_sounds
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.disable_vocal_sounds) ? "no longer" : "now"] hear vocal sounds from other players.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Vocal Sounds", "[(prefs.disable_vocal_sounds) ? "Disabled" : "Enabled"]"))
