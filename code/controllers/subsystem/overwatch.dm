SUBSYSTEM_DEF(overwatch)
	name = "Overwatch"
	flags = SS_NO_INIT | SS_NO_FIRE

/datum/controller/subsystem/overwatch/proc/record_action(source, message)
	if(!CONFIG_GET(flag/discord_overwatch))
		return

	var/webhook = CONFIG_GET(string/discord_overwatch_webhook)

	var/list/webhook_info = list()

	var/datum/discord_embed/embed = format_embed_overwatch(source, message)
	webhook_info["embeds"] = list(embed.convert_to_list())
	if(embed.content)
		webhook_info["content"] = embed.content

	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/response.json")
	request.begin_async()

/datum/controller/subsystem/overwatch/proc/format_embed_overwatch(source, message)
	RETURN_TYPE(/datum/discord_embed)
	PRIVATE_PROC(TRUE)

	var/datum/discord_embed/embed = new()
	embed.title = "OVERWATCH"
	embed.description = "OVERWATCH"
	embed.author = key_name(source)

	var/client/client = CLIENT_FROM_VAR(source)
	if(client.holder)
		embed.description += " - Admin Action"
	else
		embed.description += " - Player Action"

	var/list/admin_counts = get_admin_counts(R_BAN)
	var/list/allmins = admin_counts["total"]
	var/list/active_admins = admin_counts["present"]
	var/list/stealth_admins = admin_counts["stealth"]
	var/list/afk_admins = admin_counts["afk"]
	var/list/other_admins = admin_counts["noflags"]
	var/admin_text = ""
	var/player_count = "**Total Clients**: [length(GLOB.clients)], **Player Mobs**: [length(GLOB.player_list)]"

	admin_text += "**Total**: [length(allmins)], "
	admin_text += "**Active**: [english_list(active_admins, "N/A")], "
	admin_text += "**Stealthed**: [english_list(stealth_admins, "N/A")], "
	admin_text += "**AFK**: [english_list(afk_admins, "N/A")], "
	admin_text += "**Lacks +BAN**: [english_list(other_admins, "N/A")]."

	embed.fields = list(
		"CKEY" = key_name(source, include_link = FALSE),
		"PLAYERS" = player_count,
		"ROUND ID" = GLOB.round_id,
		"ROUND TIME" = ROUND_TIME(),
		"ADMINS" = admin_text,
		"MESSAGE" = message,
	)

	return embed
