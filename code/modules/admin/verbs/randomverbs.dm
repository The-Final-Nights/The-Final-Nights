/client/proc/cmd_admin_drop_everything(mob/M in GLOB.mob_list)
	set category = null
	set name = "Drop Everything"
	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		if(!M.dropItemToGround(W))
			qdel(W)
			M.regenerate_icons()

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	var/msg = "[key_name_admin(usr)] made [ADMIN_LOOKUPFLW(M)] drop everything!"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Everything") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_subtle_message(mob/M in GLOB.mob_list)
	set category = "Admin.Events"
	set name = "Subtle Message"

	if(!ismob(M))
		return
	if(!check_rights(R_ADMIN))
		return

	message_admins("[key_name_admin(src)] has started answering [ADMIN_LOOKUPFLW(M)]'s prayer.")
	var/msg = input("Message:", text("Subtle PM to [M.key]")) as text|null

	if(!msg)
		message_admins("[key_name_admin(src)] decided not to answer [ADMIN_LOOKUPFLW(M)]'s prayer")
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				to_chat(M, "<i>You hear a voice in your head... <b>[msg]</i></b>", confidential = TRUE)

	log_admin("SubtlePM: [key_name(usr)] -> [key_name(M)] : [msg]")
	msg = "<span class='adminnotice'><b> SubtleMessage: [key_name_admin(usr)] -> [key_name_admin(M)] :</b> [msg]</span>"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Subtle Message") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_headset_message(mob/M in GLOB.mob_list)
	set category = "Admin.Events"
	set name = "Headset Message"

	admin_headset_message(M)

/client/proc/admin_headset_message(mob/M in GLOB.mob_list, sender = null)
	var/mob/living/carbon/human/H = M

	if(!check_rights(R_ADMIN))
		return

	if(!istype(H))
		to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human", confidential = TRUE)
		return
	if(!istype(H.ears, /obj/item/radio/headset))
		to_chat(usr, "The person you are trying to contact is not wearing a headset.", confidential = TRUE)
		return

	if (!sender)
		sender = input("Who is the message from?", "Sender") as null|anything in list(RADIO_CHANNEL_CENTCOM,RADIO_CHANNEL_SYNDICATE)
		if(!sender)
			return

	message_admins("[key_name_admin(src)] has started answering [key_name_admin(H)]'s [sender] request.")
	var/input = input("Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from [sender]", "") as text|null
	if(!input)
		message_admins("[key_name_admin(src)] decided not to answer [key_name_admin(H)]'s [sender] request.")
		return

	log_directed_talk(mob, H, input, LOG_ADMIN, "reply")
	message_admins("[key_name_admin(src)] replied to [key_name_admin(H)]'s [sender] message with: \"[input]\"")
	to_chat(H, "<span class='hear'>You hear something crackle in your ears for a moment before a voice speaks. \"Please stand by for a message from [sender == "Syndicate" ? "your benefactor" : "Central Command"]. Message as follows[sender == "Syndicate" ? ", agent." : ":"] <b>[input].</b> Message ends.\"</span>", confidential = TRUE)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Headset Message") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_mod_antag_rep(client/C in GLOB.clients, operation)
	set category = "null"
	set name = "Modify Antagonist Reputation"

	if(!check_rights(R_ADMIN))
		return

	var/msg = ""
	var/log_text = ""

	if(operation == "zero")
		log_text = "Set to 0"
		SSpersistence.antag_rep -= C.ckey
	else
		var/prompt = "Please enter the amount of reputation to [operation]:"

		if(operation == "set")
			prompt = "Please enter the new reputation value:"

		msg = input("Message:", prompt) as num|null

		if (!msg)
			return

		var/ANTAG_REP_MAXIMUM = CONFIG_GET(number/antag_rep_maximum)

		if(operation == "set")
			log_text = "Set to [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(0, min(msg, ANTAG_REP_MAXIMUM))
		else if(operation == "add")
			log_text = "Added [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = min(SSpersistence.antag_rep[C.ckey]+msg, ANTAG_REP_MAXIMUM)
		else if(operation == "subtract")
			log_text = "Subtracted [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(SSpersistence.antag_rep[C.ckey]-msg, 0)
		else
			to_chat(src, "Invalid operation for antag rep modification: [operation] by user [key_name(usr)]", confidential = TRUE)
			return

		if(SSpersistence.antag_rep[C.ckey] <= 0)
			SSpersistence.antag_rep -= C.ckey

	log_admin("[key_name(usr)]: Modified [key_name(C)]'s antagonist reputation [log_text]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)]: Modified [key_name(C)]'s antagonist reputation ([log_text])</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Modify Antagonist Reputation") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_world_narrate()
	set category = "Admin.Events"
	set name = "Global Narrate"

	if(!check_rights(R_ADMIN))
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text|null

	if (!msg)
		return
	to_chat(world, "[msg]", confidential = TRUE)
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] Sent a global narrate</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Global Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_direct_narrate(mob/M)
	set category = "Admin.Events"
	set name = "Direct Narrate"

	if(!check_rights(R_ADMIN))
		return

	if(!M)
		M = input("Direct narrate to whom?", "Active Players") as null|anything in GLOB.player_list

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text|null

	if( !msg )
		return

	to_chat(M, msg, confidential = TRUE)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	msg = "<span class='adminnotice'><b> DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]):</b> [msg]<BR></span>"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Direct Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_local_narrate(atom/A)
	set category = "Admin.Events"
	set name = "Local Narrate"

	if(!check_rights(R_ADMIN))
		return
	if(!A)
		return
	var/range = input("Range:", "Narrate to mobs within how many tiles:", 7) as num|null
	if(!range)
		return
	var/msg = input("Message:", text("Enter the text you wish to appear to everyone within view:")) as text|null
	if (!msg)
		return
	for(var/mob/M in view(range,A))
		to_chat(M, msg, confidential = TRUE)

	log_admin("LocalNarrate: [key_name(usr)] at [AREACOORD(A)]: [msg]")
	message_admins("<span class='adminnotice'><b> LocalNarrate: [key_name_admin(usr)] at [ADMIN_VERBOSEJMP(A)]:</b> [msg]<BR></span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Local Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/cmd_admin_mute(whom, mute_type, automute = 0)
	if(!whom)
		return

	var/muteunmute
	var/mute_string
	var/feedback_string
	switch(mute_type)
		if(MUTE_IC)
			mute_string = "IC (say and emote)"
			feedback_string = "IC"
		if(MUTE_OOC)
			mute_string = "OOC"
			feedback_string = "OOC"
		if(MUTE_PRAY)
			mute_string = "pray"
			feedback_string = "Pray"
		if(MUTE_ADMINHELP)
			mute_string = "adminhelp, admin PM and ASAY"
			feedback_string = "Adminhelp"
		if(MUTE_DEADCHAT)
			mute_string = "deadchat and DSAY"
			feedback_string = "Deadchat"
		if(MUTE_ALL)
			mute_string = "everything"
			feedback_string = "Everything"
		else
			return

	var/client/C
	if(istype(whom, /client))
		C = whom
	else if(istext(whom))
		C = GLOB.directory[whom]
	else
		return

	var/datum/preferences/P
	if(C)
		P = C.prefs
	else
		P = GLOB.preferences_datums[whom]
	if(!P)
		return

	if(automute)
		if(!CONFIG_GET(flag/automute_on))
			return
	else
		if(!check_rights())
			return

	if(automute)
		muteunmute = "auto-muted"
		P.muted |= mute_type
		log_admin("SPAM AUTOMUTE: [muteunmute] [key_name(whom)] from [mute_string]")
		message_admins("SPAM AUTOMUTE: [muteunmute] [key_name_admin(whom)] from [mute_string].")
		if(C)
			to_chat(C, "You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin.", confidential = TRUE)
		SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Auto Mute [feedback_string]", "1")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return

	if(P.muted & mute_type)
		muteunmute = "unmuted"
		P.muted &= ~mute_type
	else
		muteunmute = "muted"
		P.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(whom)] from [mute_string]")
	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(whom)] from [mute_string].")
	if(C)
		to_chat(C, "You have been [muteunmute] from [mute_string] by [key_name(usr, include_name = FALSE)].", confidential = TRUE)
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Mute [feedback_string]", "[P.muted & mute_type]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//I use this proc for respawn character too. /N
/proc/create_xeno(ckey)
	if(!ckey)
		var/list/candidates = list()
		for(var/mob/M in GLOB.player_list)
			if(M.stat != DEAD)
				continue	//we are not dead!
			if(!(ROLE_ALIEN in M.client.prefs.be_special))
				continue	//we don't want to be an alium
			if(M.client.is_afk())
				continue	//we are afk
			if(M.mind && M.mind.current && M.mind.current.stat != DEAD)
				continue	//we have a live body we are tied to
			candidates += M.ckey
		if(candidates.len)
			ckey = input("Pick the player you want to respawn as a xeno.", "Suitable Candidates") as null|anything in sort_key(candidates)
		else
			to_chat(usr, "<span class='danger'>Error: create_xeno(): no suitable candidates.</span>", confidential = TRUE)
	if(!istext(ckey))
		return FALSE

	var/alien_caste = input(usr, "Please choose which caste to spawn.","Pick a caste",null) as null|anything in list("Queen","Praetorian","Hunter","Sentinel","Drone","Larva")
	var/obj/effect/landmark/spawn_here = GLOB.xeno_spawn.len ? pick(GLOB.xeno_spawn) : null
	var/mob/living/carbon/alien/new_xeno
	switch(alien_caste)
		if("Queen")
			new_xeno = new /mob/living/carbon/alien/humanoid/royal/queen(spawn_here)
		if("Praetorian")
			new_xeno = new /mob/living/carbon/alien/humanoid/royal/praetorian(spawn_here)
		if("Hunter")
			new_xeno = new /mob/living/carbon/alien/humanoid/hunter(spawn_here)
		if("Sentinel")
			new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(spawn_here)
		if("Drone")
			new_xeno = new /mob/living/carbon/alien/humanoid/drone(spawn_here)
		if("Larva")
			new_xeno = new /mob/living/carbon/alien/larva(spawn_here)
		else
			return FALSE
	if(!spawn_here)
		SSjob.SendToLateJoin(new_xeno, FALSE)

	new_xeno.ckey = ckey
	var/msg = "<span class='notice'>[key_name_admin(usr)] has spawned [ckey] as a filthy xeno [alien_caste].</span>"
	message_admins(msg)
	admin_ticket_log(new_xeno, msg)
	return TRUE

/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Admin.Events"
	set name = "Add Custom AI law"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null
	if(!input)
		return

	log_admin("Admin [key_name(usr)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(usr)] has added a new AI law - [input]")

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	var/announce_ion_laws = (show_log == "Yes" ? 100 : 0)

	var/datum/round_event/ion_storm/add_law_only/ion = new()
	ion.announceChance = announce_ion_laws
	ion.ionMessage = input

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Add Custom AI Law") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_create_centcom_report()
	set category = "Admin.Events"
	set name = "Create Command Report"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Enter a Command Report. Ensure it makes sense IC. Command's name is currently set to [command_name()].", "What?", "") as message|null
	if(!input)
		return

	var/confirm = alert(src, "Do you want to announce the contents of the report to the crew?", "Announce", "Yes", "No", "Cancel")
	var/announce_command_report = TRUE
	switch(confirm)
		if("Yes")
			priority_announce(input, null, 'sound/ai/commandreport.ogg')
			announce_command_report = FALSE
		if("Cancel")
			return

	print_command_report(input, "[announce_command_report ? "Classified " : ""][command_name()] Update", announce_command_report)

	log_admin("[key_name(src)] has created a command report: [input]")
	message_admins("[key_name_admin(src)] has created a command report")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Create Command Report") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_change_command_name()
	set category = "Admin.Events"
	set name = "Change Command Name"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please input a new name for the City Council.", "What?", "") as text|null
	if(!input)
		return
	change_command_name(input)
	message_admins("[key_name_admin(src)] has changed Central Command's name to [input]")
	log_admin("[key_name(src)] has changed the Central Command name to: [input]")

/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in world)
	set category = "Admin.Fun"
	set name = "Explosion"

	if(!check_rights(R_ADMIN))
		return

	var/devastation = input("Range of total devastation. -1 to none", text("Input"))  as num|null
	if(devastation == null)
		return
	var/heavy = input("Range of heavy impact. -1 to none", text("Input"))  as num|null
	if(heavy == null)
		return
	var/light = input("Range of light impact. -1 to none", text("Input"))  as num|null
	if(light == null)
		return
	var/flash = input("Range of flash. -1 to none", text("Input"))  as num|null
	if(flash == null)
		return
	var/flames = input("Range of flames. -1 to none", text("Input"))  as num|null
	if(flames == null)
		return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1) || (flames != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20) || (flames > 20))
			if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return

		explosion(O, devastation, heavy, light, flash, null, null,flames)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[flames]) at [AREACOORD(O)]")
		message_admins("[key_name_admin(usr)] created an explosion ([devastation],[heavy],[light],[flames]) at [AREACOORD(O)]")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Explosion") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return
	else
		return

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set category = "Admin.Fun"
	set name = "EM Pulse"

	if(!check_rights(R_ADMIN))
		return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num|null
	if(heavy == null)
		return
	var/light = input("Range of light pulse.", text("Input"))  as num|null
	if(light == null)
		return

	if (heavy || light)

		empulse(O, heavy, light)
		log_admin("[key_name(usr)] created an EM Pulse ([heavy],[light]) at [AREACOORD(O)]")
		message_admins("[key_name_admin(usr)] created an EM Pulse ([heavy],[light]) at [AREACOORD(O)]")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "EM Pulse") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		return
	else
		return

/client/proc/cmd_admin_gib(mob/victim in GLOB.mob_list)
	set category = "Admin.Fun"
	set name = "Gib"

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Drop a brain?", "Confirm", "Yes", "No","Cancel")
	if(confirm == "Cancel")
		return
	//Due to the delay here its easy for something to have happened to the mob
	if(!victim)
		return

	log_admin("[key_name(usr)] has gibbed [key_name(victim)]")
	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(victim)]")

	if(isobserver(victim))
		new /obj/effect/gibspawner/generic(get_turf(victim))
		return

	var/mob/living/living_victim = victim
	if(iswerewolf(victim))
		to_chat(src, span_warning("You probably shouldn't do that to a werewolf."))
		return
	if (istype(living_victim))
		if(confirm == "Yes")
			living_victim.gib()
		else
			living_victim.gib(TRUE)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_gib_self()
	set name = "Gibself"
	set category = "Admin.Fun"

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm == "Yes")
		log_admin("[key_name(usr)] used gibself.")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] used gibself.</span>")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib Self") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		var/mob/living/ourself = mob
		if (istype(ourself))
			ourself.gib(TRUE, TRUE, TRUE)

/client/proc/admin_call_shuttle()
	set category = "Admin.Events"
	set name = "Call Shuttle"

	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "Yes (No Recall)", "No")
	switch(confirm)
		if(null, "No")
			return
		if("Yes (No Recall)")
			SSshuttle.adminEmergencyNoRecall = TRUE
			SSshuttle.emergency.mode = SHUTTLE_IDLE

	SSshuttle.emergency.request()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Call Shuttle") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] admin-called the emergency shuttle.")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] admin-called the emergency shuttle[confirm == "Yes (No Recall)" ? " (non-recallable)" : ""].</span>")
	return

/client/proc/admin_cancel_shuttle()
	set category = "Admin.Events"
	set name = "Cancel Shuttle"
	if(!check_rights(0))
		return
	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return

	if(SSshuttle.adminEmergencyNoRecall)
		SSshuttle.adminEmergencyNoRecall = FALSE

	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	SSshuttle.emergency.cancel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Cancel Shuttle") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] admin-recalled the emergency shuttle.")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] admin-recalled the emergency shuttle.</span>")

	return

/client/proc/admin_disable_shuttle()
	set category = "Admin.Events"
	set name = "Disable Shuttle"

	if(!check_rights(R_ADMIN))
		return

	if(SSshuttle.emergency.mode == SHUTTLE_DISABLED)
		to_chat(usr, "<span class='warning'>Error, shuttle is already disabled.</span>")
		return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return

	message_admins("<span class='adminnotice'>[key_name_admin(usr)] disabled the shuttle.</span>")

	SSshuttle.lastMode = SSshuttle.emergency.mode
	SSshuttle.lastCallTime = SSshuttle.emergency.timeLeft(1)
	SSshuttle.adminEmergencyNoRecall = TRUE
	SSshuttle.emergency.setTimer(0)
	SSshuttle.emergency.mode = SHUTTLE_DISABLED
	priority_announce("Warning: Emergency Shuttle uplink failure, shuttle disabled until further notice.", "Emergency Shuttle Uplink Alert", 'sound/misc/announce_dig.ogg')

/client/proc/admin_enable_shuttle()
	set category = "Admin.Events"
	set name = "Enable Shuttle"

	if(!check_rights(R_ADMIN))
		return

	if(SSshuttle.emergency.mode != SHUTTLE_DISABLED)
		to_chat(usr, "<span class='warning'>Error, shuttle not disabled.</span>")
		return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return

	message_admins("<span class='adminnotice'>[key_name_admin(usr)] enabled the emergency shuttle.</span>")
	SSshuttle.adminEmergencyNoRecall = FALSE
	SSshuttle.emergencyNoRecall = FALSE
	if(SSshuttle.lastMode == SHUTTLE_DISABLED) //If everything goes to shit, fix it.
		SSshuttle.lastMode = SHUTTLE_IDLE

	SSshuttle.emergency.mode = SSshuttle.lastMode
	if(SSshuttle.lastCallTime < 10 SECONDS && SSshuttle.lastMode != SHUTTLE_IDLE)
		SSshuttle.lastCallTime = 10 SECONDS //Make sure no insta departures.
	SSshuttle.emergency.setTimer(SSshuttle.lastCallTime)
	priority_announce("Warning: Emergency Shuttle uplink reestablished, shuttle enabled.", "Emergency Shuttle Uplink Alert", 'sound/misc/announce_dig.ogg')

/client/proc/everyone_random()
	set category = "Admin.Fun"
	set name = "Make Everyone Random"
	set desc = "Make everyone have a random appearance. You can only use this before rounds!"

	if(SSticker.HasRoundStarted())
		to_chat(usr, "Nope you can't do this, the game's already started. This only works before rounds!", confidential = TRUE)
		return

	var/frn = CONFIG_GET(flag/force_random_names)
	if(frn)
		CONFIG_SET(flag/force_random_names, FALSE)
		message_admins("Admin [key_name_admin(usr)] has disabled \"Everyone is Special\" mode.")
		to_chat(usr, "Disabled.", confidential = TRUE)
		return


	var/notifyplayers = alert(src, "Do you want to notify the players?", "Options", "Yes", "No", "Cancel")
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(src)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(usr)] has forced the players to have random appearances.")

	if(notifyplayers == "Yes")
		to_chat(world, "<span class='adminnotice'>Admin [usr.key] has forced the players to have completely random identities!</span>", confidential = TRUE)

	to_chat(usr, "<i>Remember: you can always disable the randomness by using the verb again, assuming the round hasn't started yet</i>.", confidential = TRUE)

	CONFIG_SET(flag/force_random_names, TRUE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Everyone Random") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/toggle_random_events()
	set category = "Server"
	set name = "Toggle random events on/off"
	set desc = "Toggles random events such as meteors, black holes, blob (but not space dust) on/off"
	var/new_are = !CONFIG_GET(flag/allow_random_events)
	CONFIG_SET(flag/allow_random_events, new_are)
	if(new_are)
		to_chat(usr, "Random events enabled", confidential = TRUE)
		message_admins("Admin [key_name_admin(usr)] has enabled random events.")
	else
		to_chat(usr, "Random events disabled", confidential = TRUE)
		message_admins("Admin [key_name_admin(usr)] has disabled random events.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Random Events", "[new_are ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/admin_change_sec_level()
	set category = "Admin.Events"
	set name = "Set Security Level"
	set desc = "Changes the security level. Announcement only, i.e. setting to Delta won't activate nuke"

	if(!check_rights(R_ADMIN))
		return

	var/level = input("Select security level to change to","Set Security Level") as null|anything in list("green","blue","red","delta")
	if(level)
		set_security_level(level)

		log_admin("[key_name(usr)] changed the security level to [level]")
		message_admins("[key_name_admin(usr)] changed the security level to [level]")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Security Level [capitalize(level)]") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_nuke(obj/machinery/nuclearbomb/N in GLOB.nuke_list)
	set name = "Toggle Nuke"
	set category = "Admin.Events"
	set popup_menu = FALSE
	if(!check_rights(R_DEBUG))
		return

	if(!N.timing)
		var/newtime = input(usr, "Set activation timer.", "Activate Nuke", "[N.timer_set]") as num|null
		if(!newtime)
			return
		N.timer_set = newtime
	N.set_safety()
	N.set_active()

	log_admin("[key_name(usr)] [N.timing ? "activated" : "deactivated"] a nuke at [AREACOORD(N)].")
	message_admins("[ADMIN_LOOKUPFLW(usr)] [N.timing ? "activated" : "deactivated"] a nuke at [ADMIN_VERBOSEJMP(N)].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Nuke", "[N.timing]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/has_antag_hud()
	var/datum/atom_hud/A = GLOB.huds[ANTAG_HUD_TRAITOR]
	return A.hudusers[mob]


/client/proc/run_weather()
	set category = "Admin.Events"
	set name = "Run Weather"
	set desc = "Triggers a weather on the z-level you choose."

	if(!holder)
		return

	var/weather_type = input("Choose a weather", "Weather")  as null|anything in sort_list(subtypesof(/datum/weather), GLOBAL_PROC_REF(cmp_typepaths_asc))
	if(!weather_type)
		return

	var/turf/T = get_turf(mob)
	var/z_level = input("Z-Level to target?", "Z-Level", T?.z) as num|null
	if(!isnum(z_level))
		return

	SSweather.run_weather(weather_type, z_level)

	message_admins("[key_name_admin(usr)] started weather of type [weather_type] on the z-level [z_level].")
	log_admin("[key_name(usr)] started weather of type [weather_type] on the z-level [z_level].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Run Weather")

/client/proc/mass_zombie_infection()
	set category = "Admin.Fun"
	set name = "Mass Zombie Infection"
	set desc = "Infects all humans with a latent organ that will zombify \
		them on death."

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Please confirm you want to add latent zombie organs in all humans?", "Confirm Zombies", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/H = i
		new /obj/item/organ/zombie_infection/nodamage(H)

	message_admins("[key_name_admin(usr)] added a latent zombie infection to all humans.")
	log_admin("[key_name(usr)] added a latent zombie infection to all humans.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Mass Zombie Infection")

/client/proc/mass_zombie_cure()
	set category = "Admin.Fun"
	set name = "Mass Zombie Cure"
	set desc = "Removes the zombie infection from all humans, returning them to normal."
	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Please confirm you want to cure all zombies?", "Confirm Zombie Cure", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/organ/zombie_infection/nodamage/I in GLOB.zombie_infection_list)
		qdel(I)

	message_admins("[key_name_admin(usr)] cured all zombies.")
	log_admin("[key_name(usr)] cured all zombies.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Mass Zombie Cure")

/client/proc/polymorph_all()
	set category = "Admin.Fun"
	set name = "Polymorph All"
	set desc = "Applies the effects of the bolt of change to every single mob."

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Please confirm you want polymorph all mobs?", "Confirm Polymorph", "Yes", "No")
	if(confirm != "Yes")
		return

	var/list/mobs = shuffle(GLOB.alive_mob_list.Copy()) // might change while iterating
	var/who_did_it = key_name_admin(usr)

	message_admins("[key_name_admin(usr)] started polymorphed all living mobs.")
	log_admin("[key_name(usr)] polymorphed all living mobs.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Polymorph All")

	for(var/mob/living/M in mobs)
		CHECK_TICK

		if(!M)
			continue

		M.audible_message("<span class='hear'>...wabbajack...wabbajack...</span>")
		playsound(M.loc, 'sound/magic/staff_change.ogg', 50, TRUE, -1)

		wabbajack(M)

	message_admins("Mass polymorph started by [who_did_it] is complete.")

/client/proc/roll_dice_vtm()
	set category = "Admin.Fun"
	set name = "Roll WoD dice"
	set desc = "Roll WoD dice at yourself."
	var/dice_count = tgui_input_number(usr, "Input amount of dice to roll:", "Dice", 5, 100, 1)
	var/difficulty = tgui_input_number(usr, "Input roll difficulty:", "Difficulty", 6, 10, 1)

	SSroll.storyteller_roll(dice_count, difficulty, mobs_to_show_output = usr)

/client/proc/show_tip()
	set category = "Admin"
	set name = "Show Tip"
	set desc = "Sends a tip (that you specify) to all players. After all \
		you're the experienced player here."

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please specify your tip that you want to send to the players.", "Tip", "") as message|null
	if(!input)
		return

	if(!SSticker)
		return

	SSticker.selected_tip = input

	// If we've already tipped, then send it straight away.
	if(SSticker.tipped)
		SSticker.send_tip_of_the_round()


	message_admins("[key_name_admin(usr)] sent a tip of the round.")
	log_admin("[key_name(usr)] sent \"[input]\" as the Tip of the Round.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Tip")

/proc/immerse_player(mob/living/carbon/target, toggle=TRUE, remove=FALSE)
	var/list/immersion_components = list(/datum/component/manual_breathing, /datum/component/manual_blinking)

	for(var/immersies in immersion_components)
		var/has_component = target.GetComponent(immersies)

		if(has_component && (toggle || remove))
			qdel(has_component)
		else if(toggle || !remove)
			target.AddComponent(immersies)

/proc/mass_immerse(remove=FALSE)
	for(var/mob/living/carbon/M in GLOB.mob_list)
		immerse_player(M, toggle=FALSE, remove=remove)

/client/proc/toggle_hub()
	set category = "Server"
	set name = "Toggle Hub"

	world.update_hub_visibility(!GLOB.hub_visibility)

	log_admin("[key_name(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	message_admins("[key_name_admin(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	if (GLOB.hub_visibility && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a filewall is blocking incoming connections.")

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Hub Visibility", "[GLOB.hub_visibility ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/smite(mob/living/target as mob)
	set name = "Smite"
	set category = "Admin.Fun"
	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		return


	var/punishment = input("Choose a punishment", "DIVINE SMITING") as null|anything in GLOB.smites

	if(QDELETED(target) || !punishment)
		return

	var/smite_path = GLOB.smites[punishment]
	var/datum/smite/smite = new smite_path
	var/configuration_success = smite.configure(usr)
	if (configuration_success == FALSE)
		return
	smite.effect(src, target)

/proc/breadify(atom/movable/target)
	var/obj/item/food/bread/plain/bread = new(get_turf(target))
	target.forceMove(bread)

/**
 * firing_squad is a proc for the :B:erforate smite to shoot each individual bullet at them, so that we can add actual delays without sleep() nonsense
 *
 * Hilariously, if you drag someone away mid smite, the bullets will still chase after them from the original spot, possibly hitting other people. Too funny to fix imo
 *
 * Arguments:
 * * target- guy we're shooting obviously
 * * source_turf- where the bullet begins, preferably on a turf next to the target
 * * body_zone- which bodypart we're aiming for, if there is one there
 * * wound_bonus- the wounding power we're assigning to the bullet, since we don't care about the base one
 * * damage- the damage we're assigning to the bullet, since we don't care about the base one
 */
/proc/firing_squad(mob/living/carbon/target, turf/source_turf, body_zone, wound_bonus, damage)
	if(!target.get_bodypart(body_zone))
		return
	playsound(target, 'sound/weapons/gun/revolver/shot.ogg', 100)
	var/obj/projectile/bullet/smite/divine_wrath = new(source_turf)
	divine_wrath.damage = damage
	divine_wrath.wound_bonus = wound_bonus
	divine_wrath.original = target
	divine_wrath.def_zone = body_zone
	divine_wrath.spread = 0
	divine_wrath.preparePixelProjectile(target, source_turf)
	divine_wrath.fire()

/client/proc/punish_log(whom, punishment)
	var/msg = "[key_name_admin(src)] punished [key_name_admin(whom)] with [punishment]."
	message_admins(msg)
	admin_ticket_log(whom, msg)
	log_admin("[key_name(src)] punished [key_name(whom)] with [punishment].")

/client/proc/trigger_centcom_recall()
	if(!check_rights(R_ADMIN))
		return
	var/message = pick(GLOB.admiral_messages)
	message = input("Enter message from the on-call admiral to be put in the recall report.", "Admiral Message", message) as text|null

	if(!message)
		return

	message_admins("[key_name_admin(usr)] triggered a CentCom recall, with the admiral message of: [message]")
	log_game("[key_name(usr)] triggered a CentCom recall, with the message of: [message]")
	SSshuttle.centcom_recall(SSshuttle.emergency.timer, message)

/client/proc/cmd_admin_check_player_exp()	//Allows admins to determine who the newer players are.
	set category = "Admin"
	set name = "Player Playtime"
	if(!check_rights(R_ADMIN))
		return

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, "<span class='warning'>Tracking is disabled in the server configuration file.</span>", confidential = TRUE)
		return

	var/list/msg = list()
	msg += "Playtime:<BR><UL>"
	var/list/clients_list_copy = GLOB.clients.Copy()
	sort_list(clients_list_copy)
	for(var/client/C in clients_list_copy)
		msg += "<LI> - [key_name_admin(C)]: <A href='byond://?_src_=holder;[HrefToken()];getplaytimewindow=[REF(C.mob)]'>" + C.get_exp_living() + "</a></LI>"
	msg += "</UL>"
	src << browse(HTML_SKELETON_TITLE("Playtime Report", msg.Join()), "window=Player_playtime_check")

/datum/admins/proc/cmd_show_exp_panel(client/client_to_check)
	if(!check_rights(R_ADMIN))
		return
	if(!client_to_check)
		to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>", confidential = TRUE)
		return
	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, "<span class='warning'>Tracking is disabled in the server configuration file.</span>", confidential = TRUE)
		return

	new /datum/job_report_menu(client_to_check, usr)

/datum/admins/proc/toggle_exempt_status(client/C)
	if(!check_rights(R_ADMIN))
		return
	if(!C)
		to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>", confidential = TRUE)
		return

	if(!C.set_db_player_flags())
		to_chat(usr, "<span class='danger'>ERROR: Unable read player flags from database. Please check logs.</span>", confidential = TRUE)
	var/dbflags = C.prefs.db_flags
	var/newstate = FALSE
	if(dbflags & DB_FLAG_EXEMPT)
		newstate = FALSE
	else
		newstate = TRUE

	if(C.update_flag_db(DB_FLAG_EXEMPT, newstate))
		to_chat(usr, "<span class='danger'>ERROR: Unable to update player flags. Please check logs.</span>", confidential = TRUE)
	else
		message_admins("[key_name_admin(usr)] has [newstate ? "activated" : "deactivated"] job exp exempt status on [key_name_admin(C)]")
		log_admin("[key_name(usr)] has [newstate ? "activated" : "deactivated"] job exp exempt status on [key_name(C)]")

/// Allow admin to add or remove traits of datum
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/add_or_remove = input("Remove/Add?", "Trait Remove/Add") as null|anything in list("Add","Remove")
	if(!add_or_remove)
		return
	var/list/available_traits = list()

	switch(add_or_remove)
		if("Add")
			for(var/key in GLOB.traits_by_type)
				if(istype(D,key))
					available_traits += GLOB.traits_by_type[key]
		if("Remove")
			if(!GLOB.trait_name_map)
				GLOB.trait_name_map = generate_trait_name_map()
			for(var/trait in D.status_traits)
				var/name = GLOB.trait_name_map[trait] || trait
				available_traits[name] = trait

	var/chosen_trait = input("Select trait to modify", "Trait") as null|anything in sort_list(available_traits)
	if(!chosen_trait)
		return
	chosen_trait = available_traits[chosen_trait]

	var/source = "adminabuse"
	switch(add_or_remove)
		if("Add") //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
			if(GLOB.movement_type_trait_to_flag[chosen_trait]) //include the required element.
				D.AddElement(/datum/element/movetype_handler)
			ADD_TRAIT(D,chosen_trait,source)
		if("Remove")
			var/specific = input("All or specific source ?", "Trait Remove/Add") as null|anything in list("All","Specific")
			if(!specific)
				return
			switch(specific)
				if("All")
					source = null
				if("Specific")
					source = input("Source to be removed","Trait Remove/Add") as null|anything in sort_list(D.status_traits[chosen_trait])
					if(!source)
						return
			REMOVE_TRAIT(D,chosen_trait,source)
