
/datum/preferences
	var/donator = FALSE

/client/verb/donator_verify()
	set category = "OOC"
	set name = "Verify Donator Status"

	var/localhost_addresses = list("127.0.0.1", "::1")
	if(isnull(address) || (address in localhost_addresses))
		prefs.donator = TRUE
		prefs.save_preferences()
		to_chat(src, span_notice("(localhost) Donator status verified!"))
		message_admins("[key_name_admin(src)] checked their donator status. Result: Verified donator")
		return

	var/datum/db_query/query_get_player_donator = SSdbcore.NewQuery(
		"SELECT donator FROM [format_table_name("player")] WHERE ckey = :ckey AND donator = 1",
		list("ckey" = src.ckey)
	)
	if(!query_get_player_donator.Execute())
		message_admins("Database error while checking donator status for [key_name_admin(src)]")
		qdel(query_get_player_donator)
		return
	if(!query_get_player_donator.NextRow())
		to_chat(src, span_notice("You are not a donator! If you have just donated, please run the ?verifydonator command in Discord and try again."))
		message_admins("[key_name_admin(src)] checked their donator status. Result: Not a donator")
		qdel(query_get_player_donator)
		return
	to_chat(src, span_notice("Donator status verified! Thank you for your support!"))
	prefs.donator = TRUE
	prefs.save_preferences()
	message_admins("[key_name_admin(src)] checked their donator status. Result: Verified donator")
	qdel(query_get_player_donator)
