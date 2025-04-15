/// Client var used for returning the ahelp verb
/client/var/adminhelptimerid = 0
/// Client var used for tracking the ticket the (usually) not-admin client is dealing with
/client/var/datum/help_tickets/admin/current_ticket

GLOBAL_DATUM_INIT(ahelp_tickets, /datum/help_tickets/admin, new)

/**
 * # Adminhelp Ticket Manager
 */
/datum/help_tickets/admin

	var/obj/effect/statclick/ticket_list/ustatclick = new(null, null, TICKET_UNCLAIMED)
	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, TICKET_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, TICKET_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, TICKET_RESOLVED)

/datum/help_tickets/admin/Destroy()
	QDEL_NULL(ustatclick)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_state

/obj/effect/statclick/ticket_list/Initialize(mapload, name, state)
	. = ..()
	current_state = state

/obj/effect/statclick/ticket_list/Click()
	if (!usr.client?.holder)
		message_admins("[key_name_admin(usr)] non-holder clicked on a ticket list statclick! ([src])")
		log_game("[key_name(usr)] non-holder clicked on a ticket list statclick! ([src])")
		return

	GLOB.ahelp_tickets.BrowseTickets(current_state)

//called by admin topic
/obj/effect/statclick/ticket_list/proc/Action()
	Click()

#define WEBHOOK_NONE 0
#define WEBHOOK_URGENT 1
#define WEBHOOK_NON_URGENT 2

/**
 * # Adminhelp Ticket
 */
/datum/help_tickets/admin
	/// If any admins were online when the ticket was initialized
	var/heard_by_no_admins = FALSE
	/// The collection of interactions with this ticket. Use AddInteraction() or, preferably, admin_ticket_log()
	var/list/ticket_interactions
	/// Statclick holder for the ticket
	var/obj/effect/statclick/ahelp/statclick
	/// The list of clients currently responding to the opening ticket before it gets a response
	var/list/opening_responders
	/// Whether this ahelp has sent a webhook or not, and what type
	var/webhook_sent = WEBHOOK_NONE
	/// List of player interactions
	var/list/player_interactions

/**
 * Call this on its own to create a ticket, don't manually assign current_ticket
 *
 * Arguments:
 * * msg_raw - The first message of this admin_help: used for the initial title of the ticket
 * * is_bwoink - Boolean operator, TRUE if this ticket was started by an admin PM
 */
/datum/help_tickets/admin/New(msg_raw, client/C, is_bwoink, urgent = FALSE)
	//clean the input msg
	var/msg = sanitize(copytext_char(msg_raw, 1, MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = copytext_char(msg, 1, 100)

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_ticket) //This is a bug
		stack_trace("Multiple ahelp current_tickets")
		initiator.current_ticket.AddInteraction("Ticket erroneously left open by code")
		initiator.current_ticket.Close()
	initiator.current_ticket = src

	TimeoutVerb()

	statclick = new(null, src)
	ticket_interactions = list()
	player_interactions = list()

	if(is_bwoink)
		AddInteraction("<font color='blue'>[key_name_admin(usr)] PM'd [LinkedReplyName()]</font>", player_message = "<font color='blue'>[key_name_admin(usr, include_name = FALSE)] PM'd [LinkedReplyName()]</font>")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
	else
		MessageNoRecipient(msg_raw, urgent = urgent)
		send_message_to_tgs(msg, urgent)
	GLOB.ahelp_tickets.active_tickets += src

/datum/help_tickets/admin/proc/format_embed_discord(message)
	var/datum/discord_embed/embed = new()
	embed.title = "Ticket #[id]"
	embed.description = "<byond://[world.internet_address]:[world.port]>"
	embed.author = key_name(initiator_ckey)
	var/round_state
	switch(SSticker.current_state)
		if(GAME_STATE_STARTUP, GAME_STATE_PREGAME, GAME_STATE_SETTING_UP)
			round_state = "Round has not started"
		if(GAME_STATE_PLAYING)
			round_state = "Round is ongoing."
			if(SSshuttle.emergency.getModeStr())
				round_state += "\n[SSshuttle.emergency.getModeStr()]: [SSshuttle.emergency.getTimerStr()]"
				if(SSticker.emergency_reason)
					round_state += ", Shuttle call reason: [SSticker.emergency_reason]"
		if(GAME_STATE_FINISHED)
			round_state = "Round has ended"
	var/list/admin_counts = get_admin_counts(R_BAN)
	var/stealth_admins = jointext(admin_counts["stealth"], ", ")
	var/afk_admins = jointext(admin_counts["afk"], ", ")
	var/other_admins = jointext(admin_counts["noflags"], ", ")
	var/admin_text = ""
	var/player_count = "**Total**: [length(GLOB.clients)]"
	if(stealth_admins)
		admin_text += "**Stealthed**: [stealth_admins]\n"
	if(afk_admins)
		admin_text += "**AFK**: [afk_admins]\n"
	if(other_admins)
		admin_text += "**Lacks +BAN**: [other_admins]\n"
	embed.fields = list(
		"CKEY" = initiator_ckey,
		"PLAYERS" = player_count,
		"ROUND STATE" = round_state,
		"ROUND ID" = GLOB.round_id,
		"ROUND TIME" = world.time - SSticker.round_start_time,
		"MESSAGE" = message,
		"ADMINS" = admin_text,
	)
	if(CONFIG_GET(string/adminhelp_ahelp_link))
		var/ahelp_link = replacetext(CONFIG_GET(string/adminhelp_ahelp_link), "$RID", GLOB.round_id)
		ahelp_link = replacetext(ahelp_link, "$TID", id)
		embed.url = ahelp_link
	return embed

/datum/help_tickets/admin/proc/send_message_to_tgs(message, urgent = FALSE)
	var/message_to_send = message

	if(urgent)
		var/extra_message_to_send = "[message] - Requested an admin"
		var/extra_message = CONFIG_GET(string/urgent_ahelp_message)
		if(extra_message)
			extra_message_to_send += " ([extra_message])"
		to_chat(initiator, span_boldwarning("Notified admins to prioritize your ticket"))
		send2adminchat_webhook("RELAY: [initiator_ckey] | Ticket #[id]: [extra_message_to_send]")
	//send it to TGS if nobody is on and tell us how many were on
	var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [message_to_send]")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		to_chat(initiator, span_notice("No active admins are online, your adminhelp was sent to admins who are available through IRC or Discord."), confidential = TRUE)
		heard_by_no_admins = TRUE
		var/regular_webhook_url = CONFIG_GET(string/regular_adminhelp_webhook_url)
		if(regular_webhook_url && (!urgent || regular_webhook_url != CONFIG_GET(string/urgent_adminhelp_webhook_url)))
			var/extra_message = CONFIG_GET(string/ahelp_message)
			var/datum/discord_embed/embed = format_embed_discord(message)
			embed.content = extra_message
			embed.footer = "This player sent an ahelp when no admins are available [urgent? "and also requested an admin": ""]"
			send2adminchat_webhook(embed, urgent = FALSE)
			webhook_sent = WEBHOOK_NON_URGENT

/proc/send2adminchat_webhook(message_or_embed, urgent)
	var/webhook = CONFIG_GET(string/urgent_adminhelp_webhook_url)
	if(!urgent)
		webhook = CONFIG_GET(string/regular_adminhelp_webhook_url)

	if(!webhook)
		return
	var/list/webhook_info = list()
	if(istext(message_or_embed))
		var/message_content = replacetext(replacetext(message_or_embed, "\proper", ""), "\improper", "")
		message_content = GLOB.has_discord_embeddable_links.Replace(replacetext(message_content, "`", ""), " ```$1``` ")
		webhook_info["content"] = message_content
	else
		var/datum/discord_embed/embed = message_or_embed
		webhook_info["embeds"] = list(embed.convert_to_list())
		if(embed.content)
			webhook_info["content"] = embed.content
	if(CONFIG_GET(string/adminhelp_webhook_name))
		webhook_info["username"] = CONFIG_GET(string/adminhelp_webhook_name)
	if(CONFIG_GET(string/adminhelp_webhook_pfp))
		webhook_info["avatar_url"] = CONFIG_GET(string/adminhelp_webhook_pfp)
	// Uncomment when servers are moved to TGS4
	// send2chat(new /datum/tgs_message_conent("[initiator_ckey] | [message_content]"), "ahelp", TRUE)
	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/response.json")
	request.begin_async()

/datum/help_tickets/admin/Destroy()
	RemoveActive()
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	return ..()

//private
/datum/help_tickets/admin/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state == TICKET_ACTIVE)
		if (CONFIG_GET(flag/popup_admin_pm))
			. += " (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminpopup=[REF(initiator)]'>POPUP</A>)"
		. += ClosureLinks(ref_src)

//private
/datum/help_tickets/admin/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = " (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=icissue'>IC</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[ref_src];ahelp_action=resolve'>RSLVE</A>)"

//Resolve ticket with IC Issue message
/datum/help_tickets/admin/proc/ICIssue(key_name = key_name_admin(usr))
	if(state != TICKET_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- AdminHelp marked as IC issue! -</b></font><br>"
	msg += "<font color='red'>Your issue has been determined by an administrator to be an in character issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that are in character.</font>"

	if(initiator)
		to_chat(initiator, msg, confidential = TRUE)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "IC")
	msg = "Ticket [TicketHref("#[id]")] marked as IC by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("Marked as IC issue by [key_name]", player_message = "Marked as IC issue!")
	SSblackbox.LogAhelp(id, "IC Issue", "Marked as IC issue by [usr.key]", null,  usr.ckey)
	Resolve(silent = TRUE)

/**
 * Renders the current status of the ticket into a displayable string
 */
/datum/help_tickets/admin/proc/ticket_status()
	switch(state)
		if(TICKET_ACTIVE)
			return "<font color='red'>OPEN</font>"
		if(TICKET_RESOLVED)
			return "<font color='green'>RESOLVED</font>"
		if(TICKET_CLOSED)
			return "CLOSED"
		else
			stack_trace("Invalid ticket state: [state]")
			return "INVALID, CALL A CODER"

//Forwarded action from admin/Topic
/datum/help_tickets/admin/proc/Action(action)
	testing("Ahelp action: [action]")
	if(webhook_sent != WEBHOOK_NONE)
		var/datum/discord_embed/embed = new()
		embed.title = "Ticket #[id]"
		if(CONFIG_GET(string/adminhelp_ahelp_link))
			var/ahelp_link = replacetext(CONFIG_GET(string/adminhelp_ahelp_link), "$RID", GLOB.round_id)
			ahelp_link = replacetext(ahelp_link, "$TID", id)
			embed.url = ahelp_link
		embed.description = "[key_name(usr)] has sent an action to this ticket. Action ID: [action]"
		if(webhook_sent == WEBHOOK_URGENT)
			send2adminchat_webhook(embed, urgent = TRUE)
		if(webhook_sent == WEBHOOK_NON_URGENT || CONFIG_GET(string/regular_adminhelp_webhook_url) != CONFIG_GET(string/urgent_adminhelp_webhook_url))
			send2adminchat_webhook(embed, urgent = FALSE)
		webhook_sent = WEBHOOK_NONE
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()

/datum/help_tickets/admin/proc/player_ticket_panel()
	var/list/dat = list("<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><title>Player Ticket</title></head>")
	dat += "<b>State: "
	switch(state)
		if(TICKET_ACTIVE)
			dat += "<font color='red'>OPEN</font></b>"
		if(TICKET_RESOLVED)
			dat += "<font color='green'>RESOLVED</font></b>"
		if(TICKET_CLOSED)
			dat += "CLOSED</b>"
		else
			dat += "UNKNOWN</b>"
	dat += "\n[FOURSPACES]<A href='?_src_=holder;[HrefToken(forceGlobal = TRUE)];player_ticket_panel=1'>Refresh</A>"
	dat += "<br><br>Opened at: [gameTimestamp("hh:mm:ss", opened_at)] (Approx [DisplayTimeText(world.time - opened_at)] ago)"
	if(closed_at)
		dat += "<br>Closed at: [gameTimestamp("hh:mm:ss", closed_at)] (Approx [DisplayTimeText(world.time - closed_at)] ago)"
	dat += "<br><br>"
	dat += "<br><b>Log:</b><br><br>"
	for (var/interaction in player_interactions)
		dat += "[interaction]<br>"

	var/datum/browser/player_panel = new(usr, "ahelp[id]", 0, 620, 480)
	player_panel.set_content(dat.Join())
	player_panel.open()


//
// TICKET STATCLICK
//

/obj/effect/statclick/ahelp
	var/datum/help_tickets/admin/ahelp_datum

/obj/effect/statclick/ahelp/Initialize(mapload, datum/help_tickets/admin/AH)
	ahelp_datum = AH
	. = ..()

/obj/effect/statclick/ahelp/update()
	return ..(ahelp_datum.name)

/obj/effect/statclick/ahelp/Click()
	if (!usr.client?.holder)
		message_admins("[key_name_admin(usr)] non-holder clicked on an ahelp statclick! ([src])")
		log_game("[key_name(usr)] non-holder clicked on an ahelp statclick! ([src])")
		return

	ahelp_datum.TicketPanel()

/obj/effect/statclick/ahelp/Destroy()
	ahelp_datum = null
	return ..()

//
// CLIENT PROCS
//

/client/proc/openTicketManager()
	set name = "Ticket Manager"
	set desc = "Opens the ticket manager"
	set category = "Admin"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	GLOB.ahelp_tickets.BrowseTickets(usr)

/datum/help_tickets/admin/BrowseTickets(mob/user)
	var/client/C = user.client
	if(!C)
		return
	var/datum/admins/admin_datum = GLOB.admin_datums[C.ckey]
	if(!admin_datum)
		message_admins("[C.ckey] attempted to browse tickets, but had no admin datum")
		return
	if(!admin_datum.admin_interface)
		admin_datum.admin_interface = new(user)
	admin_datum.admin_interface.ui_interact(user)

/client/proc/giveadminhelpverb()
	add_verb(src, /client/verb/adminhelp)
	deltimer(adminhelptimerid)
	adminhelptimerid = 0

GLOBAL_DATUM_INIT(admin_help_ui_handler, /datum/help_tickets/admin_ui_handler, new)

/datum/help_tickets/admin_ui_handler
	var/list/ahelp_cooldowns = list()

/datum/help_tickets/admin_ui_handler/ui_state(mob/user)
	return GLOB.always_state

/datum/help_tickets/admin_ui_handler/ui_data(mob/user)
	. = list()
	var/list/admins = get_admin_counts(R_BAN)
	.["adminCount"] = length(admins["present"])

/datum/help_tickets/admin_ui_handler/ui_static_data(mob/user)
	. = list()
	.["bannedFromUrgentAhelp"] = is_banned_from(user.ckey, "Urgent Adminhelp")
	.["urgentAhelpPromptMessage"] = CONFIG_GET(string/urgent_ahelp_user_prompt)
	var/webhook_url = CONFIG_GET(string/urgent_adminhelp_webhook_url)
	if(webhook_url)
		.["urgentAhelpEnabled"] = TRUE

/datum/help_tickets/admin_ui_handler/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Adminhelp")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/help_tickets/admin_ui_handler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/client/user_client = usr.client
	var/message = sanitize_text(trim(params["message"]))
	var/urgent = !!params["urgent"]
	var/list/admins = get_admin_counts(R_BAN)
	if(length(admins["present"]) != 0 || is_banned_from(user_client.ckey, "Urgent Adminhelp"))
		urgent = FALSE

	if(user_client.adminhelptimerid)
		return

	perform_adminhelp(user_client, message, urgent)
	ui.close()

/datum/help_tickets/admin_ui_handler/proc/perform_adminhelp(client/user_client, message, urgent)
	if(GLOB.say_disabled) //This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."), confidential = TRUE)
		return

	if(!message)
		return

	//handle muting and automuting
	if(user_client.prefs.muted & MUTE_ADMINHELP)
		to_chat(user_client, span_danger("Error: Admin-PM: You cannot send adminhelps (Muted)."), confidential = TRUE)
		return
	if(user_client.handle_spam_prevention(message, MUTE_ADMINHELP))
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(urgent)
		if(!COOLDOWN_FINISHED(src, ahelp_cooldowns?[user_client.ckey]))
			urgent = FALSE // Prevent abuse
		else
			COOLDOWN_START(src, ahelp_cooldowns[user_client.ckey], CONFIG_GET(number/urgent_ahelp_cooldown) * (1 SECONDS))

	if(user_client.current_ticket)
		user_client.current_ticket.TimeoutVerb()
		if(urgent)
			var/sanitized_message = sanitize(copytext_char(message, 1, MAX_MESSAGE_LEN))
			user_client.current_ticket.send_message_to_tgs(sanitized_message, urgent = TRUE)
		user_client.current_ticket.MessageNoRecipient(message, urgent = urgent)
		return

	new /datum/help_tickets/admin(message, user_client, FALSE, urgent)

/client/verb/no_tgui_adminhelp(message as message)
	set name = "NoTguiAdminhelp"
	set hidden = TRUE

	if(adminhelptimerid)
		return

	message = trim(message)

	GLOB.admin_help_ui_handler.perform_adminhelp(src, message, FALSE)

/client/verb/adminhelp()
	set category = "Admin"
	set name = "Adminhelp"
	GLOB.admin_help_ui_handler.ui_interact(mob)
	to_chat(src, span_boldnotice("Adminhelp failing to open or work? <a href='?src=[REF(src)];tguiless_adminhelp=1'>Click here</a>"))

/client/verb/view_latest_ticket()
	set category = "Admin"
	set name = "View Latest Ticket"

	if(!current_ticket)
		// Check if the client had previous tickets, and show the latest one
		var/list/prev_tickets = list()
		var/datum/help_tickets/admin/last_ticket
		// Check all resolved tickets for this player
		for(var/datum/help_tickets/admin/resolved_ticket in GLOB.ahelp_tickets.resolved_tickets)
			if(resolved_ticket.initiator_ckey == ckey) // Initiator is a misnomer, it's always the non-admin player even if an admin bwoinks first
				prev_tickets += resolved_ticket
		// Check all closed tickets for this player
		for(var/datum/help_tickets/admin/closed_ticket in GLOB.ahelp_tickets.closed_tickets)
			if(closed_ticket.initiator_ckey == ckey)
				prev_tickets += closed_ticket
		// Take the most recent entry of prev_tickets and open the panel on it
		if(LAZYLEN(prev_tickets))
			last_ticket = pop(prev_tickets)
			last_ticket.player_ticket_panel()
			return

		// client had no tickets this round
		to_chat(src, span_warning("You have not had an ahelp ticket this round."))
		return

	current_ticket.player_ticket_panel()

/**
 * Sends a message to a set of cross-communications-enabled servers using world topic calls
 *
 * Arguments:
 * * source - Who sent this message
 * * msg - The message body
 * * type - The type of message, becomes the topic command under the hood
 * * target_servers - A collection of servers to send the message to, defined in config
 * * additional_data - An (optional) associated list of extra parameters and data to send with this world topic call
 */
/proc/send2otherserver(source, msg, type = "Ahelp", target_servers, list/additional_data = list())
	if(!CONFIG_GET(string/comms_key))
		debug_world_log("Server cross-comms message not sent for lack of configured key")
		return

	var/our_id = CONFIG_GET(string/cross_comms_name)
	additional_data["message_sender"] = source
	additional_data["message"] = msg
	additional_data["source"] = "([our_id])"
	additional_data += type

	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	for(var/I in servers)
		if(I == our_id) //No sending to ourselves
			continue
		if(target_servers && !(I in target_servers))
			continue
		world.send_cross_comms(I, additional_data)

/// Sends a message to a given cross comms server by name (by name for security).
/world/proc/send_cross_comms(server_name, list/message, auth = TRUE)
	set waitfor = FALSE
	if (auth)
		var/comms_key = CONFIG_GET(string/comms_key)
		if(!comms_key)
			debug_world_log("Server cross-comms message not sent for lack of configured key")
			return
		message["key"] = comms_key
	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	var/server_url = servers[server_name]
	if (!server_url)
		CRASH("Invalid cross comms config: [server_name]")
	world.Export("[server_url]?[list2params(message)]")

/proc/get_mob_by_name(msg)
	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//who might fit the shoe
	var/list/potential_hits = list()

	for(var/i in GLOB.mob_list)
		var/mob/M = i
		var/list/nameWords = list()
		if(!M.mind)
			continue

		for(var/string in splittext(lowertext(M.real_name), " "))
			if(!(string in ignored_words))
				nameWords += string
		for(var/string in splittext(lowertext(M.name), " "))
			if(!(string in ignored_words))
				nameWords += string

		for(var/string in nameWords)
			if(string in msglist)
				potential_hits += M
				break

	return potential_hits

/**
 * Checks a given message to see if any of the words are something we want to treat specially, as detailed below.
 *
 * There are 3 cases where a word is something we want to act on
 * 1. Admin pings, like @adminckey. Pings the admin in question, text is not clickable
 * 2. Datum refs, like @0x2001169 or @mob_23. Clicking on the link opens up the VV for that datum
 * 3. Ticket refs, like #3. Displays the status and ahelper in the link, clicking on it brings up the ticket panel for it.
 * Returns a list being used as a tuple. Index ASAY_LINK_NEW_MESSAGE_INDEX contains the new message text (with clickable links and such)
 * while index ASAY_LINK_PINGED_ADMINS_INDEX contains a list of pinged admin clients, if there are any.
 *
 * Arguments:
 * * msg - the message being scanned
 */
/proc/check_asay_links(msg)
	var/list/msglist = splittext(msg, " ") //explode the input msg into a list
	var/list/pinged_admins = list() // if we ping any admins, store them here so we can ping them after
	var/modified = FALSE // did we find anything?

	var/i = 0
	for(var/word in msglist)
		i++
		if(!length(word))
			continue

		switch(word[1])
			if("@")
				var/stripped_word = ckey(copytext(word, 2))

				// first we check if it's a ckey of an admin
				var/client/client_check = GLOB.directory[stripped_word]
				if(client_check?.holder)
					msglist[i] = "<u>[word]</u>"
					pinged_admins[stripped_word] = client_check
					modified = TRUE
					continue

				// then if not, we check if it's a datum ref

				var/word_with_brackets = "\[[stripped_word]\]" // the actual memory address lookups need the bracket wraps
				var/datum/datum_check = locate(word_with_brackets)
				if(!istype(datum_check))
					continue
				msglist[i] = "<u><a href='?_src_=vars;[HrefToken(TRUE)];Vars=[word_with_brackets]'>[word]</A></u>"
				modified = TRUE

			if("#") // check if we're linking a ticket
				var/possible_ticket_id = text2num(copytext(word, 2))
				if(!possible_ticket_id)
					continue

				var/datum/help_tickets/admin/ahelp_check = GLOB.ahelp_tickets?.TicketByID(possible_ticket_id)
				if(!ahelp_check)
					continue

				var/state_word
				switch(ahelp_check.state)
					if(TICKET_ACTIVE)
						state_word = "Active"
					if(TICKET_CLOSED)
						state_word = "Closed"
					if(TICKET_RESOLVED)
						state_word = "Resolved"

				msglist[i]= "<u><A href='?_src_=holder;[HrefToken()];ahelp=[REF(ahelp_check)];ahelp_action=ticket'>[word] ([state_word] | [ahelp_check.initiator_key_name])</A></u>"
	if(modified)
		var/list/return_list = list()
		return_list[ASAY_LINK_NEW_MESSAGE_INDEX] = jointext(msglist, " ") // without tuples, we must make do!
		return_list[ASAY_LINK_PINGED_ADMINS_INDEX] = pinged_admins
		return return_list


#undef WEBHOOK_URGENT
#undef WEBHOOK_NONE
#undef WEBHOOK_NON_URGENT
