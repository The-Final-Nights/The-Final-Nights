#define EXTERNALREPLYCOUNT 2
#define EXTERNAL_PM_USER "IRCKEY"

// HEY FUCKO, IMPORTANT NOTE!
// This file, and pretty much everything that directly handles ahelps, is VERY important
// An admin pm dropping by coding error is disastorus, because it gives no feedback to admins, so they think they're being ignored
// It is imparitive that this does not happen. Therefore, runtimes are not allowed in this file
// Additionally, any runtimes here would cause admin tickets to leak into the runtime logs
// This is less of a big deal, but still bad
//
// In service of this goal of NO RUNTIMES then, we make ABSOLUTELY sure to never trust the nullness of a value
// That's why variables are so separated from logic here. It's not a good pattern typically, but it helps make assumptions clear here
// We also make SURE to fail loud, IE: if something stops the message from reaching the recipient, the sender HAS to know
// If you "refactor" this to make it "cleaner" I will send you to hell

/// Allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M in GLOB.mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!holder)
		to_chat(src, "<span class='danger'>Error: Admin-PM-Context: Only administrators may use this command.</span>", type = MESSAGE_TYPE_ADMINPM)
		return
	if( !ismob(M) || !M.client )
		return
	cmd_admin_pm(M.client, null)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin PM Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/// Shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!holder)
		to_chat(src, "<span class='danger'>Error: Admin-PM-Panel: Only administrators may use this command.</span>", type = MESSAGE_TYPE_ADMINPM)
		return

	var/list/targets = list()
	for(var/client/client in GLOB.clients)
		var/nametag = ""
		var/mob/lad = client.mob
		var/mob_name = lad?.name
		var/real_mob_name = lad?.real_name
		if(!lad)
			nametag = "(No Mob)"
		else if(isnewplayer(lad))
			nametag = "(New Player)"
		else if(isobserver(lad))
			nametag = "[mob_name](Ghost)"
		else
			nametag = "[real_mob_name](as [mob_name])"
		targets["[nametag] - [client]"] = client

	var/target = input(src,"To whom shall we send a message?", "Admin PM", null) as null|anything in targets
	cmd_admin_pm(targets[target], null)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin PM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/// Replys to some existing ahelp, reply to whom, which can be a client or ckey
/client/proc/cmd_ahelp_reply(whom)
	if(IsAdminAdvancedProcCall())
		return FALSE

	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You are unable to use admin PM-s (muted).</span>", type = MESSAGE_TYPE_ADMINPM)
		return

	// We use the ckey here rather then keeping the client to ensure resistance to client logouts mid execution
	if(istype(whom, /client))
		var/client/boi = whom
		whom = boi.ckey

	var/ambiguious_recipient = disambiguate_client(whom)
	if(!istype(ambiguious_recipient, /client))
		if(holder)
			to_chat(src, "<span class='danger'>Error: Admin-PM: Client not found.</span>", type = MESSAGE_TYPE_ADMINPM)
		return

	var/datum/help_ticket/AH = C.current_adminhelp_ticket

	if(AH)
		message_admins("[key_name_admin(src)] has started replying to [key_name_admin(C, 0, 0)]'s admin help.")
	var/msg = stripped_multiline_input(src,"Message:", "Private message to [C.holder?.fakekey ? "an Administrator" : key_name(C, 0, 0)].")
	if (!msg)
		message_admins("[key_name_admin(src)] has cancelled their reply to [key_name_admin(C, 0, 0)]'s admin help.")
		return
	cmd_admin_pm(whom, msg)
	AH.Claim()

/client/proc/cmd_ahelp_reply_instant(whom, msg)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You are unable to use admin PM-s (muted).</span>", type = MESSAGE_TYPE_ADMINPM)
		return
	var/client/C
	if(istext(whom))
		if(whom[1] == "@")
			whom = findStealthKey(whom)
		C = GLOB.directory[whom]
	else if(istype(whom, /client))
		C = whom
	if(!C)
		if(holder)
			to_chat(src, "<span class='danger'>Error: Admin-PM: Client not found.</span>", type = MESSAGE_TYPE_ADMINPM)
		return

	if (!msg)
		return
	cmd_admin_pm(whom, msg)

//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed.
//whom here is a client, a ckey, or [EXTERNAL_PM_USER] if this is from tgs. message is the default message to send
/client/proc/cmd_admin_pm(whom, message)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You are unable to use admin PM-s (muted).</span>", type = MESSAGE_TYPE_ADMINPM)
		return

	if(!holder && !current_adminhelp_ticket)	//no ticket? https://www.youtube.com/watch?v=iHSPf6x1Fdo
		to_chat(src, "<span class='danger'>You can no longer reply to this ticket, please open another one by using the Adminhelp verb if need be.</span>", type = MESSAGE_TYPE_ADMINPM)
		to_chat(src, "<span class='notice'>Message: [msg]</span>", type = MESSAGE_TYPE_ADMINPM)
		return

	var/client/recipient
	var/external = 0
	if(istext(whom))
		if(whom[1] == "@")
			whom = findStealthKey(whom)
		if(whom == "IRCKEY")
			external = 1
		else
			recipient = GLOB.directory[whom]
	else if(istype(whom, /client))
		recipient = whom

	var/html_encoded = FALSE
	if(external)
		if(!externalreplyamount)	//to prevent people from spamming irc/discord
			return
		if(!msg)
			msg = stripped_multiline_input(src,"Message:", "Private message to Administrator")
			html_encoded = TRUE
		if(!msg)
			to_chat(src,
				type = MESSAGE_TYPE_ADMINPM,
				html = span_danger("Error: Admin-PM-Message: No message input."),
				confidential = TRUE)
			return null

		if(holder)
			to_chat(src, "<span class='danger'>Error: Use the admin IRC/Discord channel, nerd.</span>", type = MESSAGE_TYPE_ADMINPM)
			return

	if(!istype(ambiguious_recipient, /client))
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = span_danger("Error: Admin-PM-Message: Client not found."),
			confidential = TRUE)
		return null

	var/client/recipient = ambiguious_recipient
	// Stored in case client is deleted between this and after the message is input
	var/recipient_ckey = recipient?.ckey
	// Stored in case client is deleted between this and after the message is input
	var/datum/admin_help/recipient_ticket = recipient?.current_ticket
	// Our current active ticket
	var/datum/admin_help/our_ticket = current_ticket
	// If our recipient is an admin, this is their admins datum
	var/datum/admins/recipient_holder = recipient?.holder
	// If our recipient has a fake name, this is it
	var/recipient_fake_key = recipient_holder?.fakekey
	// Just the recipient's ckey, formatted for htmlifying stuff
	var/recipient_print_key = key_name(recipient, FALSE, FALSE)

	// The message we intend on returning
	var/msg = ""
	if(existing_message)
		msg = existing_message
	else
		if(!recipient)
			if(holder)
				to_chat(src, "<span class='danger'>Error: Admin-PM: Client not found.</span>", type = MESSAGE_TYPE_ADMINPM)
				if(msg)
					to_chat(src, msg)
				return
			else if(msg) // you want to continue if there's no message instead of returning now
				current_adminhelp_ticket.MessageNoRecipient(msg)
				return

		//get message text, limit it's length.and clean/escape html
		if(!msg)
			msg = stripped_multiline_input(src,"Message:", "Private message to [recipient.holder?.fakekey ? "an Administrator" : key_name(recipient, 0, 0)].")
			msg = trim(msg)
			if(!msg)
				return
			// we need to not HTML encode again or you get &#39;s instead of 's
			html_encoded = TRUE

			if(prefs.muted & MUTE_ADMINHELP)
				to_chat(src, "<span class='danger'>Error: Admin-PM: You are unable to use admin PM-s (muted).</span>", type = MESSAGE_TYPE_ADMINPM)
				return

			if(!recipient)
				if(holder)
					to_chat(src, "<span class='danger'>Error: Admin-PM: Client not found.</span>", type = MESSAGE_TYPE_ADMINPM)
				else
					current_adminhelp_ticket.MessageNoRecipient(msg)
				return

	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0)||external)//no sending html to the poor bots
		msg = sanitize_simple(msg)
		if(!html_encoded)
			msg = html_encode(msg)
		msg = trim(msg, MAX_MESSAGE_LEN)
		if(!msg)
			return

	var/rawmsg = msg

	if(holder)
		msg = emoji_parse(msg)

	var/keywordparsedmsg = keywords_lookup(msg)

	if(external)
		to_chat(src, "<span class='notice'>PM to-<b>Admins</b>: <span class='linkify'>[rawmsg]</span></span>", type = MESSAGE_TYPE_ADMINPM)
		var/datum/help_ticket/AH = admin_ticket_log(src, "<font color='red'>Reply PM from-<b>[key_name(src, TRUE, TRUE)] to <i>External</i>: [keywordparsedmsg]</font>")
		externalreplyamount--
		send2tgs("[AH ? "#[AH.id] " : ""]Reply: [ckey]", rawmsg)
	else
		if(recipient.holder)
			if(holder)	//both are admins
				to_chat(recipient, "<span class='danger'>Admin PM from-<b>[key_name(src, recipient, 1)]</b>: <span class='linkify'>[keywordparsedmsg]</span></span>", type = MESSAGE_TYPE_ADMINPM)
				to_chat(src, "<span class='notice'>Admin PM to-<b>[key_name(recipient, src, 1)]</b>: <span class='linkify'>[keywordparsedmsg]</span></span>", type = MESSAGE_TYPE_ADMINPM)

				//omg this is dumb, just fill in both their tickets
				admin_ticket_log(src, keywordparsedmsg, key_name(src, recipient, 1), key_name(recipient, src, 1), color="teal", isSenderAdmin = TRUE, safeSenderLogged = TRUE)
				if(recipient != src)	//reeee
					admin_ticket_log(recipient, keywordparsedmsg, key_name(src, recipient, 1), key_name(recipient, src, 1), color="teal", isSenderAdmin = TRUE, safeSenderLogged = TRUE)

			else		//recipient is an admin but sender is not
				var/replymsg = "Reply PM from-<b>[key_name(src, recipient, 1)]</b>: <span class='linkify'>[keywordparsedmsg]</span>"
				admin_ticket_log(src, keywordparsedmsg, key_name(src, recipient, 1), null, "white", isSenderAdmin = TRUE, safeSenderLogged = TRUE)
				to_chat(recipient, "<span class='danger'>[replymsg]</span>", type = MESSAGE_TYPE_ADMINPM)
				to_chat(src, "<span class='notice'>PM to-<b>Admins</b>: <span class='linkify'>[msg]</span></span>", type = MESSAGE_TYPE_ADMINPM)

			//play the receiving admin the adminhelp sound (if they have them enabled)
			if(recipient.prefs.toggles & PREFTOGGLE_SOUND_ADMINHELP)
				SEND_SOUND(recipient, sound('sound/effects/adminhelp.ogg'))

		else
			if(holder)	//sender is an admin but recipient is not. Do BIG RED TEXT
				if(!recipient.current_adminhelp_ticket)
					var/datum/help_ticket/admin/ticket = new(recipient)
					ticket.Create(msg, TRUE)

				to_chat(recipient, "<font color='red' size='4'><b>-- Administrator private message --</b></font>", type = MESSAGE_TYPE_ADMINPM)
				to_chat(recipient, "<span class='adminsay'>Admin PM from-<b>[key_name(src, recipient, 0)]</b>: <span class='linkify'>[msg]</span></span>", type = MESSAGE_TYPE_ADMINPM)
				to_chat(recipient, "<span class='adminsay'><i>Click on the administrator's name to reply.</i></span>", type = MESSAGE_TYPE_ADMINPM)
				to_chat(src, "<span class='notice'>Admin PM to-<b>[key_name(recipient, src, 1)]</b>: <span class='linkify'>[msg]</span></span>", type = MESSAGE_TYPE_ADMINPM)

				admin_ticket_log(recipient, keywordparsedmsg, key_name_admin(src), null, "purple", safeSenderLogged = TRUE)

				//always play non-admin recipients the adminhelp sound
				SEND_SOUND(recipient, sound('sound/effects/adminhelp.ogg'))

				//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
				if(CONFIG_GET(flag/popup_admin_pm))
					spawn()	//so we don't hold the caller proc up
						var/sender = src
						var/sendername
						if(holder.fakekey)
							sendername = holder.fakekey
						else
							sendername = key
						var/reply = stripped_multiline_input(recipient, msg,"Admin PM from-[sendername]", "")		//show message and await a reply
						if(recipient && reply)
							if(sender)
								recipient.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
							else
								adminhelp(reply)													//sender has left, adminhelp instead
						return

			else		//neither are admins
				to_chat(src, "<span class='danger'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</span>", type = MESSAGE_TYPE_ADMINPM)
				return

	if(external)
		log_admin_private("PM: [key_name(src)]->External: [rawmsg]")
		for(var/client/X in GLOB.admins)
			to_chat(X, "<span class='notice'><B>PM: [key_name(src, X, 0)]-&gt;External:</B> [keywordparsedmsg]</span>")
	else
		window_flash(recipient, ignorepref = TRUE)
		log_admin_private("PM: [key_name(src)]->[key_name(recipient)]: [rawmsg]")
		//we don't use message_admins here because the sender/receiver might get it too
		for(var/client/X in GLOB.admins)
			if(X.key!=key && X.key!=recipient.key)	//check client/X is an admin and isn't the sender or recipient
				to_chat(X, "<span class='notice'><B>PM: [key_name(src, X, 0)]-&gt;[key_name(recipient, X, 0)]:</B> [keywordparsedmsg]</span>", type = MESSAGE_TYPE_ADMINPM)



#define TGS_AHELP_USAGE "Usage: ticket <close|resolve|icissue|reject|reopen \[ticket #\]|list>"
/proc/TgsPm(target, message, sender)
	var/requested_ckey = ckey(target)
	var/ambiguious_target = disambiguate_client(requested_ckey)

	var/client/recipient
	// This might seem like hiding a failure condition, but we want to be able to send commands to the ticket without the client being logged in
	if(istype(ambiguious_target, /client))
		recipient = ambiguious_target

	// The ticket we want to talk about here. Either the target's active ticket, or the last one it had
	var/datum/admin_help/ticket
	if(recipient)
		ticket = recipient.current_ticket
	else
		GLOB.ahelp_tickets.CKey2ActiveTicket(requested_ckey)
	// The ticket's id
	var/ticket_id = ticket?.id

	var/compliant_msg = trim(lowertext(message))
	var/tgs_tagged = "[sender](TGS/External)"
	var/list/splits = splittext(compliant_msg, " ")
	var/split_size = length(splits)

	if(split_size && splits[1] == "ticket")
		if(split_size < 2)
			return TGS_AHELP_USAGE
		switch(splits[2])
			if("close")
				if(ticket)
					ticket.Close(tgs_tagged)
					return "Ticket #[ticket_id] successfully closed"
			if("resolve")
				if(ticket)
					ticket.Resolve(tgs_tagged)
					return "Ticket #[ticket_id] successfully resolved"
			if("icissue")
				if(ticket && istype(ticket, /datum/help_ticket/admin))
					var/datum/help_ticket/admin/a_ticket = ticket
					a_ticket.ICIssue(tgs_tagged)
					return "Ticket #[ticket.id] successfully marked as IC issue"
			if("reject")
				if(ticket)
					ticket.Reject(tgs_tagged)
					return "Ticket #[ticket_id] successfully rejected"
			if("reopen")
				if(ticket)
					return "Error: [target] already has ticket #[ticket_id] open"
				var/ticket_num
				// If the passed in command actually has a ticket id arg
				if(split_size >= 3)
					ticket_num = text2num(splits[3])

				if(isnull(ticket_num))
					return "Error: No/Invalid ticket id specified. [TGS_AHELP_USAGE]"

				// The active ticket we're trying to reopen, if one exists
				var/datum/admin_help/active_ticket = GLOB.ahelp_tickets.TicketByID(ticket_num)
				// The ckey of the player to be targeted BY the ticket
				// Not the initiator all the time
				var/boinked_ckey = active_ticket?.initiator_ckey

				if(!active_ticket)
					return "Error: Ticket #[ticket_num] not found"
				if(boinked_ckey != target)
					return "Error: Ticket #[ticket_num] belongs to [boinked_ckey]"

				active_ticket.Reopen()
				return "Ticket #[ticket_num] successfully reopened"
			if("list")
				var/list/tickets = GLOB.ahelp_tickets.TicketsByCKey(target)
				var/tickets_length = length(tickets)

				if(!tickets_length)
					return "None"
				var/list/printable_tickets = list()
				for(var/datum/admin_help/iterated_ticket in tickets)
					// The id of the iterated adminhelp
					var/iterated_id = iterated_ticket?.id
					var/text = ""
					if(iterated_ticket == ticket)
						text += "Active: "
					text += "#[iterated_id]"
					printable_tickets += text
				return printable_tickets.Join(", ")
			else
				return TGS_AHELP_USAGE
		return "Error: Ticket could not be found"

	// Now that we've handled command processing, we can actually send messages to the client
	if(!recipient)
		return "Error: No client"

	var/adminname
	if(CONFIG_GET(flag/show_irc_name))
		adminname = tgs_tagged
	else
		adminname = "Administrator"

	var/stealthkey = GetTgsStealthKey()

	message = sanitize(copytext_char(message, 1, MAX_MESSAGE_LEN))
	message = emoji_parse(message)

	if(!message)
		return "Error: No message"

	// The ckey of our recipient, with a reply link, and their mob if one exists
	var/recipient_name_linked = key_name_admin(recipient)
	// The ckey of our recipient, with their mob if one exists. No link
	var/recipient_name = key_name_admin(recipient)

	message_admins("External message from [sender] to [recipient_name_linked] : [message]")
	log_admin_private("External PM: [sender] -> [recipient_name] : [message]")

	to_chat(recipient,
		type = MESSAGE_TYPE_ADMINPM,
		html = "<font color='red' size='4'><b>-- Administrator private message --</b></font>",
		confidential = TRUE)
	to_chat(recipient,
		type = MESSAGE_TYPE_ADMINPM,
		html = span_adminsay("Admin PM from-<b><a href='?priv_msg=[stealthkey]'>[adminname]</A></b>: [message]"),
		confidential = TRUE)
	to_chat(recipient,
		type = MESSAGE_TYPE_ADMINPM,
		html = span_adminsay("<i>Click on the administrator's name to reply.</i>"),
		confidential = TRUE)

	admin_ticket_log(C, msg, adminname, null, "cyan", isSenderAdmin = TRUE, safeSenderLogged = TRUE)

	window_flash(recipient, ignorepref = TRUE)
	// Nullcheck because we run a winset in window flash and I do not trust byond
	if(recipient)
		//always play non-admin recipients the adminhelp sound
		SEND_SOUND(recipient, 'sound/effects/adminhelp.ogg')

		recipient.externalreplyamount = EXTERNALREPLYCOUNT
	return "Message Successful"

/// Gets TGS's stealth key, generates one if none is found
/proc/GetTgsStealthKey()
	var/static/tgsStealthKey
	if(tgsStealthKey)
		return tgsStealthKey

	tgsStealthKey = generateStealthCkey()
	GLOB.stealthminID[EXTERNAL_PM_USER] = tgsStealthKey
	return tgsStealthKey

/// Takes an argument which could be either a ckey, /client, or IRC marker, and returns a client if possible
/// Returns [EXTERNAL_PM_USER] if an IRC marker is detected
/// Otherwise returns null
/proc/disambiguate_client(whom)
	if(istype(whom, /client))
		return whom

	if(!istext(whom) || !(length(whom) >= 1))
		return null

	var/searching_ckey = whom
	if(whom[1] == "@")
		searching_ckey = findTrueKey(whom)

	if(searching_ckey == EXTERNAL_PM_USER)
		return EXTERNAL_PM_USER

	return GLOB.directory[searching_ckey]


#undef EXTERNAL_PM_USER
#undef EXTERNALREPLYCOUNT
