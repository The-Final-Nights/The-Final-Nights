/datum/memory
	var/id

	//ID of the master aboutme record 
	var/about_me_id
	
	var/owner_key = ""
	var/summary = ""
	var/details = ""
	var/source = ""
	var/status = "New"

	/*
		Flattened these records into their own tables,
		memory_linked_keys and memory_tags
		var/list/related_keys = list()
		var/list/tags = list()
	*/
	

	/*
	Flattened the following into create_time and update_time. 
	Then, added End_time for tracking ended relationships.
	var/date_occurred = ""
	var/created_at = ""
	var/created_at_ts = 0
	var/updated_at = ""
	var/updated_at_ts = 0
	*/
	var/create_time
	var/update_time
	var/end_time

	//Not tracked by db
	var/dirty = FALSE
	var/autosave = TRUE

/datum/memory/New(owner_key, load_mode = FALSE, memory_type)
	..()
	src.owner_key = "[owner_key]"
	if(memory_type == null)
		memory_type = "generic"
	if (!date_occurred)
		date_occurred = time2text(world.realtime, "MMM_DD_2015")

	if (!id)
		var/pfx = owner_key ? "memory_[memory_type]_[owner_key]_[date_occurred]" : "mem"
		id = SSroleplay_management.about_me_new_id(pfx)

	if (!created_at_ts)
		created_at_ts = world.realtime
		created_at = time2text(created_at_ts, "MMM_DD_2015")
	updated_at_ts = created_at_ts
	updated_at = created_at_ts

	if (!load_mode)
		SSroleplay_management.register_memory(src)
		save()

/datum/memory/proc/mark_dirty()
	dirty = TRUE

/datum/memory/proc/save()
	var/datum/db/roleplay_management/DB = new
	var/list/serial = to_row_db()
	if (DB.memories_upsert_serial(serial))
		dirty = FALSE
		return TRUE
	return FALSE

/datum/memory/proc/delete()
	var/datum/db/roleplay_management/DB = new
	if (DB.memories_delete(id))
		var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(owner_key)
		if (R && islist(R.memory_keys))
			R.memory_keys -= id
			R.touch()
			SSroleplay_management.aboutme_save(owner_key)
		SSroleplay_management.unregister_memory(src)
		qdel(src)
		return TRUE
	return FALSE

/datum/memory/proc/reload()
	var/datum/db/roleplay_management/DB = new
	var/list/serial = DB.memories_get_serial_by_id(id)
	if (!serial) return FALSE
	from_row(serial)
	dirty = FALSE
	return TRUE

/datum/memory/proc/touch()
	updated_at_ts = world.realtime
	updated_at = time2text(updated_at_ts, "MMM DD, YYYY hh:mm")
	mark_dirty()
	if (autosave)
		save()

/datum/memory/proc/GetFormattedUI()
	return list(
		"id" = id,
		"summary" = summary,
		"details" = details,
		"tags" = islist(tags) ? tags.Copy() : list(),
		"owner_key" = owner_key,
		"related_keys" = islist(related_keys) ? related_keys.Copy() : list(),
		"date_occurred" = date_occurred,
		"status" = status,
		"source" = source,
		"created_at" = created_at,
		"updated_at" = updated_at
	)

/datum/memory/proc/is_visible_to(mob/user, character_key)
	return TRUE

/datum/memory/proc/to_row()
	return list(
		"id" = id,
		"summary" = summary,
		"details" = details,
		"tags" = tags.Copy(),
		"owner_key" = owner_key,
		"related_keys" = related_keys.Copy(),
		"date_occurred" = date_occurred,
		"source" = source,
		"status" = status,
	)

/datum/memory/proc/to_row_db()
	var/list/r = to_row()
	r["created_at"] = created_at
	r["updated_at"] = updated_at
	return r

/datum/memory/proc/from_row(list/row)
	if (!islist(row)) return

	id = "[row["id"]]"
	summary = row["summary"] || summary
	details = row["details"] || details
	tags = islist(row["tags"]) ? row["tags"] : list()
	owner_key = row["owner_key"] || owner_key
	related_keys = islist(row["related_keys"]) ? row["related_keys"] : list()
	date_occurred = row["date_occurred"] || date_occurred
	source = row["source"] || source
	status = row["status"] || status

	if (row["created_at"])
		created_at = row["created_at"]
	if (row["updated_at"])
		updated_at = row["updated_at"]

	dirty = FALSE
