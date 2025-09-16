/datum/relationships
	var/id
	var/owner
	var/target
	var/kind = "acquaintance"
	var/relationship_type = "acquaintance"

	var/status = "Active"
	var/label = ""
	var/notes = ""
	var/intensity = 0
	var/visibility = TRUE

	/*
	Flattened the into create_time and update_time.
	Then, added End_time for tracking ended relationships.
	var/created_at = ""
	var/created_at_ts = 0
	var/updated_at = ""
	var/updated_at_ts = 0
	*/
	var/create_time
	var/update_time
	var/end_time

	//Not tracked by database.
	var/dirty = FALSE
	var/autosave = TRUE

/datum/relationships/New(owner_key, target_key, load_mode = FALSE)
	..()
	owner = owner_key
	target = target_key
	if (!id)
		var/pfx = "[owner]_to_[lowertext(replacetext(target_key, " ", "_"))]"
		id = SSroleplay_management.about_me_new_id(pfx)
	if (!create_time)
		create_time = time2text(world.realtime, "MMM DD, YYYY hh:mm")
	update_time = create_time
	if (!load_mode)
		SSroleplay_management.register_relationship(src)
		save()

/datum/relationships/Destroy()
	SSroleplay_management.unregister_relationship(src)
	..()

/datum/relationships/proc/mark_dirty()
	dirty = TRUE

/datum/relationships/proc/touch()
	update_time = time2text(world.realtime, "MMM DD, YYYY hh:mm")
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
		"owner_key" = owner,
		"target_key" = target,
		"kind" = kind,
		"label" = label,
		"notes" = notes,
		"visibility" = visibility,
		"status" = status,
		"intensity" = intensity,
		"created_at" = create_time,
		"updated_at" = update_time
	)

/datum/relationships/proc/is_visible_to(mob/user, character_id)
	if (!character_id) return FALSE
	if (character_id == owner) return TRUE
	var/is_group = (!!GLOB.groups && GLOB.groups[target]) || (!!GLOB.canonical_groups && GLOB.canonical_groups[target])

	if (is_group)
		var/datum/aboutme_record/rec = SSroleplay_management.get_aboutme_record(character_id)
		if (!rec) return FALSE
		return (target in rec.group_keys)

	return character_id == target

/datum/relationships/proc/to_row()
	return list(
		"id" = id,
		"owner_key" = owner,
		"target_key" = target,
		"kind" = kind,
		"label" = label,
		"notes" = notes,
		"visibility" = visibility,
		"status" = status,
		"intensity" = intensity
	)

/datum/relationships/proc/to_row_db()
	var/list/r = to_row()
	r["created_at"] = create_time
	r["updated_at"] = update_time
	return r

/datum/relationships/proc/from_row(list/row)
	if (!islist(row)) return
	id = "[row["id"]]"
	owner = row["owner_key"] || owner
	target = row["target_key"] || target
	kind = row["kind"] || kind
	label = row["label"] || label
	notes = row["notes"] || notes
	visibility = (row["visibility"] != null) ? row["visibility"] : visibility
	status = row["status"] || status
	intensity = row["intensity"] || intensity
	if (row["created_at"]) create_time = row["created_at"]
	if (row["updated_at"]) create_time = row["updated_at"]
	dirty = FALSE
