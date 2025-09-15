/datum/relationships
	var/id
	var/owner_key
	var/target_key
	var/kind = "acquaintance"
	var/label = ""
	var/notes = ""
	var/visibility = TRUE
	var/status = "Active"
	var/intensity = 0
	var/created_at = ""
	var/created_at_ts = 0
	var/updated_at = ""
	var/updated_at_ts = 0
	var/dirty = FALSE
	var/autosave = TRUE

/datum/relationships/New(owner_key, target_key, load_mode = FALSE)
	..()
	src.owner_key = owner_key
	src.target_key = target_key
	if (!id)
		var/pfx = "[owner_key]_to_[target_key]"
		id = SSroleplay_management.about_me_new_id(pfx)
	if (!created_at_ts)
		created_at_ts = world.realtime
		created_at = time2text(created_at_ts, "MMM DD, YYYY hh:mm")
	updated_at_ts = created_at_ts
	updated_at = created_at
	if (!load_mode)
		SSroleplay_management.register_relationship(src)
		save()

/datum/relationships/Destroy()
	SSroleplay_management.unregister_relationship(src)
	..()

/datum/relationships/proc/mark_dirty()
	dirty = TRUE

/datum/relationships/proc/touch()
	updated_at_ts = world.realtime
	updated_at = time2text(updated_at_ts, "MMM DD, YYYY hh:mm")
	mark_dirty()
	if (autosave) save()

/datum/relationships/proc/save()
	var/datum/db/roleplay_management/DB = new
	if (DB.relationships_upsert_base(to_row()))
		dirty = FALSE
		return TRUE
	return FALSE

/datum/relationships/proc/reload()
	var/datum/db/roleplay_management/DB = new
	var/list/base = DB.relationships_get(id)
	if (!base) return FALSE
	from_row(base)
	dirty = FALSE
	return TRUE

/datum/relationships/proc/delete()
	var/datum/db/roleplay_management/DB = new
	if (DB.relationships_delete(id))
		for (var/datum/aboutme_record/R as anything in GLOB.aboutme_records)
			if (islist(R?.relationship_keys) && (id in R.relationship_keys))
				R.relationship_keys -= id
				R.touch()
				SSroleplay_management.aboutme_save(R.character_id)
		SSroleplay_management.unregister_relationship(src)
		qdel(src)
		return TRUE
	return FALSE

/datum/relationships/proc/GetFormattedUI()
	return list(
		"id" = id,
		"owner_key" = owner_key,
		"target_key" = target_key,
		"kind" = kind,
		"label" = label,
		"notes" = notes,
		"visibility" = visibility,
		"status" = status,
		"intensity" = intensity,
		"created_at" = created_at,
		"updated_at" = updated_at
	)

/datum/relationships/proc/is_visible_to(mob/user, character_id)
	if (!character_id) return FALSE
	if (character_id == owner_key) return TRUE
	var/is_group = (!!GLOB.groups && GLOB.groups[target_key]) || (!!GLOB.canonical_groups && GLOB.canonical_groups[target_key])

	if (is_group)
		var/datum/aboutme_record/rec = SSroleplay_management.get_aboutme_record(character_id)
		if (!rec) return FALSE
		return (target_key in rec.group_keys)

	return character_id == target_key

/datum/relationships/proc/to_row()
	return list(
		"id" = id,
		"owner_key" = owner_key,
		"target_key" = target_key,
		"kind" = kind,
		"label" = label,
		"notes" = notes,
		"visibility" = visibility,
		"status" = status,
		"intensity" = intensity
	)

/datum/relationships/proc/to_row_db()
	var/list/r = to_row()
	r["created_at"] = created_at
	r["created_at_ts"] = created_at_ts
	r["updated_at"] = updated_at
	r["updated_at_ts"] = updated_at_ts
	return r

/datum/relationships/proc/from_row(list/row)
	if (!islist(row)) return
	id = "[row["id"]]"
	owner_key = row["owner_key"] || owner_key
	target_key = row["target_key"] || target_key
	kind = row["kind"] || kind
	label = row["label"] || label
	notes = row["notes"] || notes
	visibility = (row["visibility"] != null) ? row["visibility"] : visibility
	status = row["status"] || status
	intensity = row["intensity"] || intensity
	if (row["created_at"]) created_at = row["created_at"]
	if (row["created_at_ts"]) created_at_ts = row["created_at_ts"]
	if (row["updated_at"]) updated_at = row["updated_at"]
	if (row["updated_at_ts"]) updated_at_ts = row["updated_at_ts"]
	dirty = FALSE
