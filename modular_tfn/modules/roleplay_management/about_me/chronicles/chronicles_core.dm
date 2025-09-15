// ============================================================================
// CHRONICLE — CORE (chronicles_core.dm)
// Chronicle = story container with linked entries (memory ids).
// DB-backed; cache via GLOB.chronicles. Write-through on save().
// ============================================================================

/datum/chronicle
	var/id
	var/scope = "personal"
	var/title = "Untitled Chronicle"
	var/desc = ""
	var/owner_key
	var/group_id
	var/list/tags = list()
	var/list/entries = list() // entry ids
	var/status = "Ongoing"

	var/start_at = ""
	var/start_at_ts = 0
	var/end_at = ""
	var/end_at_ts = 0

	var/created_by_key
	var/created_at = ""
	var/created_at_ts = 0
	var/updated_at = ""
	var/updated_at_ts = 0

	// Persistence flags
	var/dirty = FALSE
	var/autosave = TRUE

/datum/chronicle/New(id, scope, title, desc, owner_key, group_id, created_by_key, load_mode = FALSE)
	..()
	src.id = id
	src.scope = scope || src.scope
	src.title = title || src.title
	src.desc  = desc  || src.desc
	src.owner_key = owner_key
	src.group_id  = group_id
	src.created_by_key = created_by_key

	if (!created_at_ts)
		created_at_ts = world.realtime
		created_at = time2text(created_at_ts, "MMM_DD_2015")
	updated_at_ts = created_at_ts
	updated_at = created_at

	start_at_ts = created_at_ts
	start_at = created_at

	if (!src.id)
		var/host = owner_key ? "[owner_key]" : (group_id ? "[group_id]" : "unknown")
		var/pfx = "chronicle_[src.scope]_[host]_[created_at]"
		src.id = SSroleplay_management.about_me_new_id(pfx)



	if (!load_mode)
		SSroleplay_management.register_chronicle(src)
		save() // write-through on create

/datum/chronicle/Destroy()
	SSroleplay_management.unregister_chronicle(src)
	..()

/datum/chronicle/proc/mark_dirty()
	dirty = TRUE

/datum/chronicle/proc/touch()
	updated_at_ts = world.realtime
	updated_at = time2text(updated_at_ts, "MMM DD, YYYY hh:mm")
	mark_dirty()
	if (autosave) save()

/datum/chronicle/proc/add_entry(memory_id)
	if (!memory_id) return
	if (!(memory_id in entries))
		entries += memory_id
	touch()

/datum/chronicle/proc/close(now = TRUE)
	status = "Concluded"
	if (now)
		end_at_ts = world.realtime
		end_at = time2text(end_at_ts, "MMM DD, YYYY hh:mm")
	touch()

/datum/chronicle/proc/save()
	var/datum/db/roleplay_management/DB = new
	if (!DB.chronicles_upsert_base(to_row_base()))
		return FALSE

	DB.chronicles_replace_entries(id, to_rows_entries())
	dirty = FALSE
	return TRUE

/datum/chronicle/proc/reload()
	var/datum/db/roleplay_management/DB = new
	var/list/base = DB.chronicles_get(id)
	if (!base) return FALSE
	from_row_db(base)
	from_rows_entries(DB.chronicles_get_entries(id))
	dirty = FALSE
	return TRUE



/datum/chronicle/proc/delete()
	var/datum/db/roleplay_management/DB = new
	if (DB.chronicles_delete(id))
		// unlink from AboutMe record if present
		for (var/datum/aboutme_record/R as anything in GLOB.aboutme_records)
			if (islist(R?.chronicle_keys) && (id in R.chronicle_keys))
				R.chronicle_keys -= id
				R.touch()
				SSroleplay_management.aboutme_save(R.character_id)
		SSroleplay_management.unregister_chronicle(src)
		qdel(src)
		return TRUE
	return FALSE

/datum/chronicle/proc/GetFormattedUI()
	return list(
		"id" = id,
		"scope" = scope,
		"title" = title,
		"desc" = desc,
		"owner_key" = owner_key,
		"group_id" = group_id,
		"tags" = islist(tags) ? tags.Copy() : list(),
		"entries" = islist(entries) ? entries.Copy() : list(),
		"status" = status,
		"start_at" = start_at,
		"end_at" = end_at,
		"created_at" = created_at,
		"updated_at" = updated_at
	)

/datum/chronicle/proc/is_visible_to(mob/user, character_id)
	if (!character_id) return FALSE
	switch (scope)
		if ("personal") return character_id == owner_key
		if ("group")
			var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(character_id)
			return !!(R && (group_id in R.group_keys))
		if ("active") return TRUE
	return TRUE


/datum/chronicle/proc/to_row_base()
	return list(
		"chron_key" = id,
		"scope" = scope,
		"title" = title,
		"summary" = desc,
		"owner_key" = owner_key,
		"group_id" = group_id,
		"status" = status,
		"start_at" = start_at,
		"start_at_ts" = start_at_ts,
		"end_at" = end_at,
		"end_at_ts" = end_at_ts,
		"created_by_key" = created_by_key,
		"created_at" = created_at,
		"created_at_ts" = created_at_ts,
		"updated_at" = updated_at,
		"updated_at_ts" = updated_at_ts
	)

/datum/chronicle/proc/from_row_db(list/base)
	if (!islist(base)) return
	id             = "[base["chron_key"] || id]"
	scope          = base["scope"]          || scope
	title          = base["title"]          || title
	desc           = base["summary"]        || desc
	owner_key      = base["owner_key"]      || owner_key
	group_id       = base["group_id"]       || group_id
	status         = base["status"]         || status
	start_at       = base["start_at"]       || start_at
	start_at_ts    = isnum(base["start_at_ts"]) ? base["start_at_ts"] : start_at_ts
	end_at         = base["end_at"]         || end_at
	end_at_ts      = isnum(base["end_at_ts"])   ? base["end_at_ts"]   : end_at_ts
	created_by_key = base["created_by_key"] || created_by_key
	created_at     = base["created_at"]     || created_at
	created_at_ts  = isnum(base["created_at_ts"]) ? base["created_at_ts"] : created_at_ts
	updated_at     = base["updated_at"]     || updated_at
	updated_at_ts  = isnum(base["updated_at_ts"]) ? base["updated_at_ts"] : updated_at_ts


/// rows: list of entry rows for chronicles_replace_entries()
/datum/chronicle/proc/to_rows_entries()
	var/list/rows = list()
	if (!islist(entries) || !entries.len) return rows
	for (var/eid in entries)
		var/datum/chronicle_entry/E = SSroleplay_management.get_chronicle_entry_by_id(eid)
		if (!E) continue
		rows += list(E.to_row_db())
	return rows

/datum/chronicle/proc/from_rows_entries(list/rows)
	entries = list()
	if (!islist(rows) || !rows.len) return
	for (var/i in 1 to rows.len)
		var/list/r = rows[i]
		var/eid = r["entry_key"]
		if (!eid) continue
		var/datum/chronicle_entry/E = SSroleplay_management.get_chronicle_entry_by_id(eid)
		if (!E)
			E = new /datum/chronicle_entry(null, TRUE)
			E.autosave = FALSE
			E.from_row_db(r)
			E.dirty = FALSE
			SSroleplay_management.register_chronicle_entry(E)
		if (!(eid in entries))
			entries += eid




//entries

/datum/chronicle/proc/add_entry_id(entry_id)
	if (!entry_id) return
	if (!islist(entries)) entries = list()
	if (!(entry_id in entries))
		entries += entry_id
	touch()

/datum/chronicle/proc/create_entry(title = "", body = "", memory_key = null, author_key = null)
	var/datum/chronicle_entry/E = new /datum/chronicle_entry(id)
	E.autosave = TRUE
	E.title = "[title]"
	E.body  = "[body]"
	E.author_key = "[author_key]"
	if (memory_key) E.memory_key = "[memory_key]"
	E.touch() // will save()
	SSroleplay_management.chronicle_attach_entry(id, E)
	return E
