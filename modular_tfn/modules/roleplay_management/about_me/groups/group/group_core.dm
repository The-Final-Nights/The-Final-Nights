/datum/group
	var/id

	/*
	Renamed to group_type for the sake of straightforward naming structures
	var/gtype = "org"
	*/
	var/group_type = "org"


	var/name = "Unnamed Group"
	var/desc = ""
	
	var/status = "Active"

	var/created_by_key = ""

	//Do we need both of these?
	var/visibility = TRUE
	var/is_public = TRUE


	var/canonical_key = ""
	var/is_canonical = FALSE
	var/load_mode = FALSE

	/*
	Flattened to Create_time/Update_time/End_time
	var/created_at = ""
	var/created_at_ts = 0
	var/updated_at = ""
	var/updated_at_ts = 0
	*/
	var/create_time
	var/update_time
	var/end_time


	//Not tracked by DB
	var/dirty = FALSE
	var/autosave = TRUE
	

/datum/group/New(id = null, load_mode = FALSE)
	..()

	if (!created_at_ts)
		created_at_ts = world.realtime
		created_at = time2text(created_at_ts, "MMM_DD_YYYY")
	updated_at_ts = created_at_ts
	updated_at = created_at

	if (!id)
		id = SSroleplay_management.group_id_new(gtype, lowertext(replacetext(name, " ", "_")))
		id += "_[created_at]"
	src.id = id

	if (!load_mode)
		SSroleplay_management.register_group(src)
		save()

/datum/group/Destroy()
	SSroleplay_management.unregister_group(src)
	..()

/datum/group/proc/mark_dirty()
	dirty = TRUE
/datum/group/proc/is_dirty()
	return dirty

/datum/group/proc/touch()
	updated_at_ts = world.realtime
	updated_at = time2text(updated_at_ts, "MMM DD, YYYY hh:mm")
	mark_dirty()
	if (autosave) save()

/datum/group/proc/add_member(char_key)
	if (!istext(char_key)) return
	if (!(char_key in members))
		members += char_key
	touch()

/datum/group/proc/remove_member(char_key)
	if (!istext(char_key)) return
	if (char_key in members)
		members -= char_key
	touch()

/datum/group/proc/save()
	var/datum/db/roleplay_management/DB = new
	if (!DB.groups_upsert_base(to_row_base()))
		return FALSE
	DB.group_members_replace(id, to_rows_members())
	dirty = FALSE
	return TRUE

/datum/group/proc/reload()
	var/datum/db/roleplay_management/DB = new
	var/list/base = DB.groups_get(id)
	if (!base) return FALSE
	from_row_db(base)
	from_rows_members(DB.group_members_list(id))
	dirty = FALSE
	return TRUE

/datum/group/proc/delete()
	var/datum/db/roleplay_management/DB = new
	if (DB.groups_delete(id))
		SSroleplay_management.unregister_group(src)
		qdel(src)
		return TRUE
	return FALSE

/datum/group/proc/GetFormattedUI()
	return list(
		"id" = id,
		"type" = gtype,
		"name" = name,
		"desc" = desc,
		"status" = status,
		"visibility" = visibility,
		"members" = islist(members) ? members.Copy() : list(),
		"created_at" = created_at,
		"updated_at" = updated_at
	)

/// base row
/datum/group/proc/to_row_base()
	return list(
		"group_key" = id,
		"type" = gtype,
		"name" = name,
		"desc" = desc,
		"visibility" = visibility,
		"status" = status,
		"created_by_key" = created_by_key,
		"created_at" = created_at,
		"created_at_ts" = created_at_ts,
		"updated_at" = updated_at,
		"updated_at_ts" = updated_at_ts
	)

/datum/group/proc/from_row_db(list/base)
	if (!islist(base)) return
	id             = "[base["group_key"] || id]"
	gtype          = base["type"]           || gtype
	name           = base["name"]           || name
	desc           = base["desc"]           || desc
	visibility     = isnull(base["visibility"]) ? visibility : !!base["visibility"]
	status         = base["status"]         || status
	created_by_key = base["created_by_key"] || created_by_key
	created_at     = base["created_at"]     || created_at
	created_at_ts  = isnum(base["created_at_ts"]) ? base["created_at_ts"] : created_at_ts
	updated_at     = base["updated_at"]     || updated_at
	updated_at_ts  = isnum(base["updated_at_ts"]) ? base["updated_at_ts"] : updated_at_ts

/datum/group/proc/to_rows_members()
	var/list/rows = list()
	for (var/ck in (members || list()))
		rows += list(list(
			"group_key" = id,
			"member_key" = ck,
			"role" = "", // optional; fill from UI later
			"joined_at" = created_at,
			"joined_at_ts" = created_at_ts
		))
	return rows

/datum/group/proc/from_rows_members(list/rows)
	members = list()
	if (!islist(rows) || !rows.len) return
	for (var/i in 1 to rows.len)
		var/list/r = rows[i]
		var/ck = r["member_key"]
		if (istext(ck) && !(ck in members))
			members += ck

/datum/group/proc/get_relationship_keys_for_owner(owner_key)
	if (!owner_key || !id)
		return list()
	var/list/matching = list()
	for (var/rid in GLOB.relationships)
		var/datum/relationships/Rel = GLOB.relationships[rid]
		if (!Rel) continue
		if (Rel.owner_key == owner_key && Rel.target_key == src.id)
			matching += rid
	return matching

/datum/group/proc/all_rel_keys()
	. = list()
	for (var/rid in GLOB.relationships)
		var/datum/relationships/R = GLOB.relationships[rid]
		if (R?.kind == "group" && R.target_key == src.id)
			. += rid

/datum/group/proc/rel_keys_for(owner_key)
	if (!owner_key) return list()
	. = list()
	for (var/rid in GLOB.relationships)
		var/datum/relationships/R = GLOB.relationships[rid]
		if (!R) continue
		if (R.kind == "group" && R.owner_key == owner_key && R.target_key == src.id)
			. += rid
