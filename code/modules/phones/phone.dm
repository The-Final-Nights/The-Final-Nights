/obj/item/smartphone
	name = "flip phone"
	desc = "A portable device to call anyone you want."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "phone0"
	inhand_icon_state = "phone0"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | ACID_PROOF

	// There's a radio in my phone that calls me stud muffin.
	var/obj/item/radio/phone_radio

	// Contacts the phone has saved.
	var/list/contacts = list()
	// Contacts the phone has blocked.
	var/list/blocked_contacts = list()
	// The phone history of the phone.
	var/list/phone_history_list = list()
	// Currently viewed newscaster channel. Used for IRC Announcements
	var/obj/machinery/newscaster/irc_channel
	//Current sound to play when the phone is ringing.
	var/call_sound = 'code/modules/wod13/sounds/call.ogg'
	/// Do we have a SIM card?
	var/obj/item/sim_card/sim_card
	/// Phone flags
	var/phone_flags = NONE
	/// The number the user is currently dialing.
	var/dialed_number
	// The frequency the phone is currently using to call another phone.
	var/secure_frequency
	// The frequency that is calling us.
	var/incoming_frequency
	var/obj/item/sim_card/incoming_sim_card

/obj/item/smartphone/Initialize(mapload)
	. = ..()
	sim_card = new()
	sim_card.phone_weakref = WEAKREF(src)
	phone_radio = new()
	RegisterSignal(sim_card, COMSIG_PHONE_RING, PROC_REF(ring))
	RegisterSignal(sim_card, COMSIG_PHONE_RING_TIMEOUT, PROC_REF(ring_timeout))
	irc_channel = new()

/obj/item/smartphone/Destroy(force)
	. = ..()
	UnregisterSignal(COMSIG_PHONE_RING)
	UnregisterSignal(COMSIG_PHONE_RING_TIMEOUT)
	if(sim_card)
		sim_card.phone_weakref = null
		QDEL_NULL(sim_card)
	if(phone_radio)
		QDEL_NULL(phone_radio)

/obj/item/smartphone/examine(mob/user)
	. = ..()
	. += span_notice("[EXAMINE_HINT("Interact")] to look at the screen.")
	. += span_notice("[EXAMINE_HINT("Alt-Click")] or [EXAMINE_HINT("Right-Click")] to toggle the screen.")
	if(sim_card)
		. += span_notice("[EXAMINE_HINT("Ctrl-Click")] to remove [sim_card].")
	else
		. += span_notice("You can [EXAMINE_HINT("Insert")] a SIM card.")

/obj/item/smartphone/attack_self(mob/user, modifiers)
	. = ..()
	if(!(phone_flags & PHONE_OPEN))
		toggle_screen(user)
	ui_interact()

/obj/item/smartphone/AltClick(mob/user)
	. = ..()
	toggle_screen(user)
	return TRUE

/obj/item/smartphone/CtrlClick(mob/user)
	. = ..()
	if(!(user.is_holding(src)))
		return FALSE
	if(!sim_card)
		balloon_alert(user, "no sim card!")
		return FALSE
	if(do_after(user, 2 SECONDS, src))
		balloon_alert(user, "you remove \the [sim_card]!")
		end_phone_call()
		user.put_in_hands(sim_card)
		sim_card.phone_weakref = null
		sim_card = null
		phone_flags |= PHONE_NO_SIM
		UnregisterSignal(COMSIG_PHONE_RING)
		UnregisterSignal(COMSIG_PHONE_RING_TIMEOUT)
		return TRUE
	return FALSE

/obj/item/smartphone/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/sim_card))
		if(sim_card)
			balloon_alert(user, "[sim_card] already installed!")
			return FALSE
		balloon_alert(user, "you insert \the [attacking_item]!")
		sim_card = attacking_item
		user.transferItemToLoc(attacking_item, src)
		sim_card.phone_weakref = WEAKREF(src)
		phone_flags &= ~PHONE_NO_SIM
		RegisterSignal(sim_card, COMSIG_PHONE_RING, PROC_REF(ring))
		RegisterSignal(sim_card, COMSIG_PHONE_RING_TIMEOUT, PROC_REF(ring_timeout))
		return TRUE
	return ..()

/obj/item/smartphone/ui_status(mob/user, datum/ui_state/state)
	if(!(phone_flags & PHONE_OPEN))
		return UI_CLOSE
	return ..()

/obj/item/smartphone/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Telephone")
		ui.open()

/obj/item/smartphone/ui_data(mob/user)
	var/list/data = list()
	data["dialed_number"] = dialed_number
	data["my_number"] = sim_card ? sim_card.phone_number : "No SIM card inserted."
	data["calling"] = (phone_flags & PHONE_CALLING) ? TRUE : FALSE
	data["being_called"] = (phone_flags & PHONE_RINGING) ? TRUE : FALSE
	data["in_call"] = (phone_flags & PHONE_IN_CALL) ? TRUE : FALSE
	data["calling_user"] = incoming_sim_card.phone_number

	data["online"] = (phone_flags & PHONE_IN_CALL) ? TRUE : FALSE
	data["talking"] = (phone_flags & PHONE_IN_CALL) ? TRUE : FALSE
	if(phone_flags & PHONE_IN_CALL)
		data["calling_user"] = "(+1 707) [incoming_sim_card.phone_number]"
		for(var/datum/phonecontact/P in contacts)
			if(P.number == incoming_sim_card.phone_number)
				data["calling_user"] = P.name

	data["silence"] = isnull(call_sound)
	data["our_number"] = sim_card ? sim_card.phone_number : "No SIM card inserted."

	var/list/published_numbers = list()
	for(var/i in 1 to min(LAZYLEN(GLOB.published_numbers), LAZYLEN(GLOB.published_number_names)))
		var/number = GLOB.published_numbers[i]
		var/name = GLOB.published_number_names[i]

		UNTYPED_LIST_ADD(published_numbers, list(
			"name" = name,
			"number" = number,
		))
	data["published_numbers"] = published_numbers

	var/list/our_contacts = list()
	for(var/datum/phonecontact/contact in contacts)
		UNTYPED_LIST_ADD(our_contacts, list(
			"name" = contact.name,
			"number" = contact.number,
		))
	data["our_contacts"] = our_contacts

	var/list/our_blocked_contacts = list()
	for(var/datum/phonecontact/contact in blocked_contacts)
		UNTYPED_LIST_ADD(our_blocked_contacts, list(
			"name" = contact.name,
			"number" = contact.number,
		))
	data["our_blocked_contacts"] = our_blocked_contacts

	var/list/phone_history = list()
	for(var/datum/phonehistory/PH in phone_history_list)
		UNTYPED_LIST_ADD(phone_history, list(
			"type" = PH.call_type,
			"name" = PH.name,
			"number" = PH.number,
			"time" = PH.time
		))
	data["phone_history"] = phone_history

	/*
	var/list/newscaster_channels = list()
	for(var/datum/newscaster/feed_channel/CHANNEL in GLOB.news_network.network_channels)
		UNTYPED_LIST_ADD(newscaster_channels, list(
			"name" = CHANNEL.channel_name,
			"censored" = CHANNEL.censored,
			"ref" = FAST_REF(CHANNEL),
		))
	data["newscaster_channels"] = newscaster_channels

	data["viewing_channel"] = null
	if(viewing_newscaster_channel)
		var/datum/newscaster/feed_channel/channel = locate(viewing_newscaster_channel)
		if(istype(channel))
			var/list/channel_data = list("messages" = list())
			if(channel.censored)
				channel_data["censored"] = TRUE
			else
				for(var/datum/newscaster/feed_message/MESSAGE in channel.messages)
					var/list/comments = list()

					for(var/datum/newscaster/feed_comment/comment in MESSAGE.comments)
						UNTYPED_LIST_ADD(comments, list(
							"body" = comment.body,
							"author" = comment.author,
							"time_stamp" = comment.time_stamp,
						))

					UNTYPED_LIST_ADD(channel_data["messages"], list(
						"body" = MESSAGE.returnBody(-1),
						"caption" = MESSAGE.caption,
						"author" = MESSAGE.returnAuthor(-1),
						"time_stamp" = MESSAGE.time_stamp,
						"comments" = comments,
					))
			data["viewing_channel"] = channel_data
	*/

	data += newscaster_information_request(user)
	return data

/obj/item/smartphone/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("keypad")
			switch(params["value"])
				if("C")
					dialed_number = null
					return TRUE
			dialed_number += params["value"]
			return TRUE

		if("call")
			initialize_phone_call(usr)
			return TRUE

		if("hang")
			end_phone_call()
			return TRUE

		if("accept")
			accept_phone_call()
			return TRUE

		if("decline")
			end_phone_call()
			return TRUE

		if("publish_number")
			var/name = tgui_input_text(usr, "Input name", "Publish Number")
			if(!name)
				to_chat(usr, span_danger("You must input a name to publish your number."))
				return
			if(!sim_card?.phone_number)
				to_chat(usr, span_danger("You must insert a SIM card to publish your number."))
				return
			name = trim(copytext_char(sanitize(name), 1, MAX_MESSAGE_LEN))
			if(sim_card.phone_number in GLOB.published_numbers)
				to_chat(usr, span_danger("Error: This number is already published."))
			else
				GLOB.published_numbers += sim_card.phone_number
				GLOB.published_number_names += name
				to_chat(usr, span_notice("Your number is now published."))
			return TRUE

		if("add_contact")
			var/number = params["number"]
			if(length(number) > 15)
				to_chat(usr, span_danger("Entered number is too long"))
				return
			var/stripped_number = replacetext(number, " ", "") // remove spaces
			var/new_contact_name = tgui_input_text(usr, "Input name", "Add Contact")
			if(!new_contact_name)
				to_chat(usr, span_danger("You must input a name to add a contact."))
				return

			var/datum/phonecontact/new_contact = new()
			new_contact.number = "[stripped_number]"
			new_contact.name = "[new_contact_name]"
			contacts += new_contact

			return TRUE

		if("remove_contact")
			var/name = params["name"]
			for(var/datum/phonecontact/contact in contacts)
				if(contact.name == name)
					contacts -= contact
					return TRUE
			return FALSE

		if("block")
			var/block_number = params["number"]
			if(!block_number)
				to_chat(usr, span_warning("You must provide a number."))
			if(length(block_number) > 15)
				to_chat(usr, span_warning("Invalid number."))
				return

			var/datum/phonecontact/blocked_contact = new()
			block_number = replacetext(block_number, " ", "")
			blocked_contact.number = "[block_number]"
			blocked_contact.name = "Blocked [length(blocked_contacts)+1]"
			blocked_contacts += blocked_contact
			return TRUE

		if("unblock")
			var/result = params["name"]
			for(var/datum/phonecontact/unblocked_contact in blocked_contacts)
				if(unblocked_contact.name == result)
					blocked_contacts -= unblocked_contact
					return TRUE
			return FALSE

		if("delete_call_history")
			if(!length(phone_history_list))
				to_chat(usr, span_danger("You have no call history to delete."))
				return

			to_chat(usr, "Your total amount of history saved is: [length(phone_history_list)]")
			var/number_of_deletions = tgui_input_number(usr, "Input the amount that you want to delete", "Deletion Amount", max_value = length(phone_history_list))
			//Delete the call history depending on the amount inputed by the User
			if(number_of_deletions > length(phone_history_list))
				//Verify if the requested amount in bigger than the history list.
				to_chat(usr, "You cannot delete more items than the history contains.")
				return FALSE
			else
				for(var/i in number_of_deletions)
					//It will always delete the first item of the list, so the last logs are deleted first
					var/item_to_remove = phone_history_list[1]
					phone_history_list -= item_to_remove
			to_chat(usr, "[number_of_deletions] call history entries were deleted. Remaining: [length(phone_history_list)]")
			return TRUE


		if("silent")
			if(call_sound)
				//If it is true, it will check all the other sounds for phone and disable them
				call_sound = null
				to_chat(usr, "<span class='notice'>Notifications and Sounds toggled off.</span>")
			else
				call_sound = 'code/modules/wod13/sounds/call.ogg'
				to_chat(usr, "<span class='notice'>Notifications and Sounds toggled on.</span>")
			return TRUE

		if("terminal_sound")
			if(!call_sound)
				playsound(loc, 'sound/machines/terminal_select.ogg', 15, TRUE)
			return TRUE
	return FALSE

/obj/item/smartphone/proc/newscaster_information_request(mob/user)
	var/list/data = list()
	var/list/message_list = list()

	data["user"] = list()
	data["user"]["name"] = user.name
	data["user"]["job"] = "N/A"
	data["user"]["department"] = "N/A"

	data["photo_data"] = !isnull(irc_channel.current_image)
	data["creating_channel"] = irc_channel.creating_channel
	data["creating_comment"] = irc_channel.creating_comment
	data["viewing_wanted"] = irc_channel.viewing_wanted

	//Here is all the UI_data sent about the current wanted issue, as well as making a new one in the UI.
	data["making_wanted_issue"] = !(GLOB.news_network.wanted_issue?.active)
	data["criminal_name"] = irc_channel.criminal_name
	data["crime_description"] = irc_channel.crime_description
	var/list/wanted_info = list()
	if(GLOB.news_network.wanted_issue)
		var/has_wanted_issue = !isnull(GLOB.news_network.wanted_issue.img)
		if(has_wanted_issue)
			user << browse_rsc(GLOB.news_network.wanted_issue.img, "wanted_photo.png")
		wanted_info = list(list(
			"active" = GLOB.news_network.wanted_issue.active,
			"criminal" = GLOB.news_network.wanted_issue.criminal,
			"crime" = GLOB.news_network.wanted_issue.body,
			"author" = GLOB.news_network.wanted_issue.scanned_user,
			"image" = (has_wanted_issue ? "wanted_photo.png" : null)
		))

	//Code breaking down the channels that have been made on-station thus far. ha
	//Then, breaks down the messages that have been made on those channels.
	if(irc_channel.current_channel)
		for(var/datum/feed_message/feed_message as anything in irc_channel.current_channel.messages)
			var/photo_ID = null
			var/list/comment_list
			if(feed_message.img)
				user << browse_rsc(feed_message.img, "tmp_photo[feed_message.message_ID].png")
				photo_ID = "tmp_photo[feed_message.message_ID].png"
			for(var/datum/feed_comment/comment_message as anything in feed_message.comments)
				comment_list += list(list(
					"auth" = comment_message.author,
					"body" = comment_message.body,
					"time" = comment_message.time_stamp,
				))
			message_list += list(list(
				"auth" = feed_message.author,
				"body" = feed_message.body,
				"time" = feed_message.time_stamp,
				"channel_num" = feed_message.parent_ID,
				"censored_message" = feed_message.body_censor,
				"censored_author" = feed_message.author_censor,
				"ID" = feed_message.message_ID,
				"photo" = photo_ID,
				"comments" = comment_list
			))


	data["viewing_channel"] = irc_channel.current_channel?.channel_ID
	data["paper"] = irc_channel.paper_remaining
	//Here we display all the information about the current channel.
	data["channelName"] = irc_channel.current_channel?.channel_name
	data["channelAuthor"] = irc_channel.current_channel?.author

	if(!irc_channel.current_channel)
		data["channelAuthor"] = "Nanotrasen Inc"
		data["channelDesc"] = "Welcome to Newscaster Net. Interface & News networks Operational."
		data["channelLocked"] = TRUE
	else
		data["channelDesc"] = irc_channel.current_channel.channel_desc
		data["channelLocked"] = irc_channel.current_channel.locked
		data["channelCensored"] = irc_channel.current_channel.censored

	//We send all the information about all messages in existence.
	data["messages"] = message_list
	data["wanted"] = wanted_info

	var/list/formatted_requests = list()
	var/list/formatted_applicants = list()
	for (var/datum/station_request/request as anything in GLOB.request_list)
		formatted_requests += list(list("owner" = request.owner, "value" = request.value, "description" = request.description, "acc_number" = request.req_number))
		if(request.applicants)
			for(var/datum/bank_account/applicant_bank_account as anything in request.applicants)
				formatted_applicants += list(list("name" = applicant_bank_account.account_holder, "request_id" = request.owner_account.account_id, "requestee_id" = applicant_bank_account.account_id))
	data["requests"] = formatted_requests
	data["applicants"] = formatted_applicants
	data["bountyValue"] = irc_channel.bounty_value
	data["bountyText"] = irc_channel.bounty_text

	return data

/obj/item/smartphone/proc/toggle_screen(mob/user)
	if(phone_flags & PHONE_OPEN)
		phone_flags &= ~PHONE_OPEN
	else
		phone_flags |= PHONE_OPEN
	icon_state = (phone_flags & PHONE_OPEN) ? "phone2" : "phone0"
	inhand_icon_state = (phone_flags & PHONE_OPEN) ? "phone2" : "phone0"
	update_icon()

/*
// Proc used for intializing a phone call, if secure_frequqncy isn't set, the phone is calling someone.
// If secure_frequency is set, the phone is being called by someone.
*/
/obj/item/smartphone/proc/initialize_phone_call(mob/user)
	if(!sim_card)
		balloon_alert(user, "no SIM card installed!")
		return
	if(!secure_frequency)
		secure_frequency = SSphones.initiate_phone_call(sim_card, dialed_number)
		phone_flags |= PHONE_CALLING
	if(secure_frequency)
		phone_radio.set_frequency(secure_frequency)
		phone_radio.broadcasting = TRUE
		phone_radio.listening = TRUE
		phone_flags |= PHONE_IN_CALL
		phone_flags &= ~PHONE_CALLING

/obj/item/smartphone/proc/end_phone_call()
	phone_radio.set_frequency(0)
	phone_radio.broadcasting = FALSE
	phone_radio.listening = FALSE
	secure_frequency = null
	SSphones.end_phone_call(sim_card, dialed_number)
	phone_flags &= ~PHONE_IN_CALL

/obj/item/smartphone/proc/accept_phone_call()
	SSphones.cancel_ring_timeout(incoming_sim_card)
	incoming_sim_card = null
	secure_frequency = incoming_frequency
	phone_flags &= ~PHONE_RINGING
	initialize_phone_call()

// called_sim_card: the SIM card that is being called right now.
// caller_sim_card: the SIM card that is calling right now.
// phone_number: The phone number of who is calling.
// established_frequency: On what frequency we are being called.
/obj/item/smartphone/proc/ring(obj/item/sim_card/called_sim_card, obj/item/sim_card/caller_sim_card, phone_number, established_frequency)
	SIGNAL_HANDLER

	say("RING RING RING")
	incoming_frequency = established_frequency
	incoming_sim_card = caller_sim_card
	phone_flags |= PHONE_RINGING

// sim_card: the SIM card that was calling right now.
// phone_number: The phone number of who was calling.
// established_frequency: On what frequency we were being called.
/obj/item/smartphone/proc/ring_timeout(obj/item/sim_card/sim_card, phone_number, established_frequency)
	SIGNAL_HANDLER

	if(secure_frequency)
		end_phone_call()
	incoming_frequency = null
	incoming_sim_card = null
	phone_flags &= ~PHONE_RINGING
