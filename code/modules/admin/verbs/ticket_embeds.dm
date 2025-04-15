#define WEBHOOK_NONE 0
#define WEBHOOK_URGENT 1
#define WEBHOOK_NON_URGENT 2

/datum/help_ticket/proc/format_embed_discord(message)
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
		"ROUND TIME" = ROUND_TIME(),
		"MESSAGE" = message,
		"ADMINS" = admin_text,
	)
	if(CONFIG_GET(string/adminhelp_ahelp_link))
		var/ahelp_link = replacetext(CONFIG_GET(string/adminhelp_ahelp_link), "$RID", GLOB.round_id)
		ahelp_link = replacetext(ahelp_link, "$TID", id)
		embed.url = ahelp_link
	return embed

/datum/help_ticket/proc/send_message_to_tgs(message, urgent = FALSE)
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

#undef WEBHOOK_URGENT
#undef WEBHOOK_NONE
#undef WEBHOOK_NON_URGENT
