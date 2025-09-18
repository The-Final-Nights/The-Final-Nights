// ============================================================================
// CHRONICLE ENTRY — CORE (no JSON; flat columns)
// Optional link to a memory via memory_key.
// ============================================================================

/datum/chronicle_entry
	var/id
	var/chron_key
	var/memory_key
	var/title = ""
	var/body  = ""
	var/author_key = ""
	var/status = "Active"

	var/occurred_at = ""
	var/occurred_at_ts = 0

	var/created_at = ""
	var/created_at_ts = 0
	var/updated_at = ""
	var/updated_at_ts = 0

	// persistence
	var/dirty = FALSE
	var/autosave = TRUE

/datum/chronicle_entry/New(chron_key, load_mode = FALSE)
	..()
	src.chron_key = "[chron_key]"
	if (!id)
		id = SSroleplay_management.about_me_new_id("centry_[chron_key]")

	if (!created_at_ts)
		created_at_ts = world.realtime
		created_at = time2text(created_at_ts, "MMM DD, YYYY hh:mm")
	updated_at_ts = created_at_ts
	updated_at = created_at

	if (!occurred_at_ts)
		occurred_at_ts = created_at_ts
		occurred_at = created_at

	if (!load_mode)
		SSroleplay_management.register_chronicle_entry(src)

/datum/chronicle_entry/Destroy()
	SSroleplay_management.unregister_chronicle_entry(src)
	..()

/datum/chronicle_entry/proc/mark_dirty() dirty = TRUE

/datum/chronicle_entry/proc/touch()
	updated_at_ts = world.realtime
	updated_at = time2text(updated_at_ts, "MMM DD, YYYY hh:mm")
	mark_dirty()
	if (autosave) save()

/datum/chronicle_entry/proc/set_title(t)
    title = "[t]"
    src.touch()

/datum/chronicle_entry/proc/set_body(b)
    body = "[b]"
    src.touch()

/datum/chronicle_entry/proc/set_memory(k)
    memory_key = "[k]"
    src.touch()

/datum/chronicle_entry/proc/set_status(s)
    status = "[s]"
    src.touch()


/datum/chronicle_entry/proc/set_occurred_at(ts_text)
	occurred_at = "[ts_text]"
	occurred_at_ts = world.realtime // or parse if you prefer
	touch()

/datum/chronicle_entry/proc/save()
	var/datum/db/roleplay_management/DB = new
	var/list/row = to_row_db()
	if (DB.chronicle_entries_upsert_serial(row))
		dirty = FALSE
		return TRUE
	return FALSE

/datum/chronicle_entry/proc/reload()
	var/datum/db/roleplay_management/DB = new
	var/list/row = DB.chronicle_entries_get(id)
	if (!row) return FALSE
	from_row_db(row)
	dirty = FALSE
	return TRUE

/datum/chronicle_entry/proc/delete()
	var/datum/db/roleplay_management/DB = new
	if (DB.chronicle_entries_delete(id))
		// detach from parent chronicle list if present
		var/datum/chronicle/C = SSroleplay_management.get_chronicle_by_key(chron_key)
		if (C && islist(C.entries))
			//C.entries -= id
			C.touch()
		SSroleplay_management.unregister_chronicle_entry(src)
		qdel(src)
		return TRUE
	return FALSE

/datum/chronicle_entry/proc/GetFormattedUI()
	return list(
		"id" = id,
		"chron_key" = chron_key,
		"memory_key" = memory_key,
		"title" = title,
		"body" = body,
		"author_key" = author_key,
		"status" = status,
		"occurred_at" = occurred_at,
		"created_at" = created_at,
		"updated_at" = updated_at
	)

// --------- Serialization (flat)
/// to_row_db maps directly to table columns
/datum/chronicle_entry/proc/to_row_db()
	return list(
		"entry_key" = id,
		"chron_key" = chron_key,
		"memory_key" = memory_key,
		"title" = title,
		"body"  = body,
		"author_key" = author_key,
		"status" = status,
		"occurred_at"   = occurred_at,
		"occurred_at_ts"= occurred_at_ts,
		"created_at"    = created_at,
		"created_at_ts" = created_at_ts,
		"updated_at"    = updated_at,
		"updated_at_ts" = updated_at_ts
	)

/datum/chronicle_entry/proc/from_row_db(list/row)
	if (!islist(row)) return
	id = "[row["entry_key"]]"
	chron_key   = row["chron_key"]  || chron_key
	memory_key  = row["memory_key"] || memory_key
	title       = row["title"]      || title
	body        = row["body"]       || body
	author_key  = row["author_key"] || author_key
	status      = row["status"]     || status
	occurred_at    = row["occurred_at"]    || occurred_at
	occurred_at_ts = isnum(row["occurred_at_ts"]) ? row["occurred_at_ts"] : occurred_at_ts
	created_at     = row["created_at"]     || created_at
	created_at_ts  = isnum(row["created_at_ts"]) ? row["created_at_ts"] : created_at_ts
	updated_at     = row["updated_at"]     || updated_at
	updated_at_ts  = isnum(row["updated_at_ts"]) ? row["updated_at_ts"] : updated_at_ts

