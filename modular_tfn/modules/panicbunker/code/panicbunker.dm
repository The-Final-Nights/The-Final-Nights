GLOBAL_LIST_EMPTY(bunker_passthrough)

/client/proc/addbunkerbypass()
	set category = "Admin"
	set name = "Add Bunker Bypass"

	if(!check_rights(R_ADMIN))
		return
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice("The Database is not enabled!"))
		return

	var/ckeytobypass = input(usr, "Adds CKEY to the PB bypass list for a given round.", "Add PB Bypass") as text|null

	GLOB.bunker_passthrough |= ckey(ckeytobypass)
	GLOB.bunker_passthrough[ckey(ckeytobypass)] = world.realtime
	SSpersistence.save_panic_bunker() //we can do this every time, it's okay
	log_admin("[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")

/client/proc/revokebunkerbypass()
	set category = "Admin"
	set name = "Revoke Bunker Bypass"

	if(!check_rights(R_ADMIN))
		return
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice("The Database is not enabled!"))
		return

	var/ckeytobypass = input(usr, "Revoke CKEY from the PB bypass list for a given round.", "Revoke PB Bypass") as text|null

	GLOB.bunker_passthrough -= ckey(ckeytobypass)
	SSpersistence.save_panic_bunker()
	log_admin("[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")

/datum/tgs_chat_command/addbunkerbypass
	name = "whitelist"
	help_text = "whitelist <ckey>"
	admin_only = TRUE

/datum/tgs_chat_command/addbunkerbypass/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(flag/sql_enabled))
		return "The Database is not enabled!"

	GLOB.bunker_passthrough |= ckey(params)

	GLOB.bunker_passthrough[ckey(params)] = world.realtime
	SSpersistence.save_panic_bunker() //we can do this every time, it's okay
	log_admin("[sender.friendly_name] has added [params] to the current round's bunker bypass list.")
	message_admins("[sender.friendly_name] has added [params] to the current round's bunker bypass list.")
	return new /datum/tgs_message_content("[params] has been added to the current round's bunker bypass list.")

/datum/controller/subsystem/persistence/proc/load_panic_bunker()
	var/bunker_path = file("data/bunker_passthrough.json")
	if(fexists(bunker_path))
		var/list/json = json_decode(file2text(bunker_path))
		GLOB.bunker_passthrough = json["data"]
		for(var/ckey in GLOB.bunker_passthrough)
			if(daysSince(GLOB.bunker_passthrough[ckey]) >= CONFIG_GET(number/max_bunker_days))
				GLOB.bunker_passthrough -= ckey

/datum/controller/subsystem/persistence/proc/save_panic_bunker()
	var/json_file = file("data/bunker_passthrough.json")
	var/list/file_data = list()
	file_data["data"] = GLOB.bunker_passthrough
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))

/datum/config_entry/number/max_bunker_days
	default = 7
	min_val = 1
