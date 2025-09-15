/datum/aboutme_record
	var/id

	//composite of character_name and owner_key
	var/character_id

	var/owner_key
	var/character_name

	//What are these holding? The preferences system should hold this instead.
	var/edit_display_name
	var/edit_goals
	var/edit_personal_quote
	var/edit_gender
	var/edit_physical_desc

	/*
	The below are represented by foreign keys in the database.
	var/list/group_keys = list()
	var/list/relationship_keys = list()
	var/list/chronicle_keys = list()
	var/list/memory_keys = list()
	*/

	/*
	Flattened the into create_time and update_time.
	var/created_at = ""
	var/created_at_ts = 0
	var/updated_at = ""
	var/updated_at_ts = 0
	*/
	var/create_time
	var/update_time

	//not tracked by the db.
	var/has_initialized_personal_chronicle = FALSE
	var/has_initialized_groups_from_role = FALSE
	var/has_initialized_entry_memory = FALSE
	var/dirty = FALSE
	var/autosave = TRUE

/datum/aboutme_record/proc/mark_dirty()
	dirty = TRUE

/datum/aboutme_record/proc/save()
	var/datum/db/roleplay_management/DB = new
	if (DB.aboutme_upsert_record(src))
		dirty = FALSE
		return TRUE
	return FALSE

/datum/aboutme_record/proc/touch()
	updated_at_ts = world.realtime
	updated_at = time2text(updated_at_ts, "MMM DD, YYYY hh:mm")
	mark_dirty()
	if (autosave)
		save()

/datum/aboutme_record/New(character_id)
	..()
	src.character_id = "[character_id]"
	if (!created_at_ts)
		created_at_ts = world.realtime
		created_at = time2text(created_at_ts, "MMM DD, YYYY hh:mm")
	updated_at_ts = created_at_ts
	updated_at = created_at
	SSroleplay_management.check_register_valid_character_id(src.character_id)

/datum/aboutme_record/proc/GetFormattedUI(mob/living/carbon/human/owner)
	return list(
		"overview" = get_ui_overview_data(owner),
		"groups" = get_ui_groups(owner),
		"relationships" = get_ui_relationships(owner),
		"chronicle" = get_ui_chronicles(owner),
		"memories" = get_ui_memories_by_tag(owner),
		"character_id" = character_id,
		"created_at" = created_at,
		"updated_at" = updated_at
	)

/datum/aboutme_record/proc/get_ui_groups(mob/living/carbon/human/owner)
	var/list/group_objects = list()
	for (var/group_key in group_keys)
		var/datum/group/G = SSroleplay_management.get_group_by_id(group_key)
		if (!G) continue
		var/gt = G.gtype || "unknown"
		if (!(gt in group_objects))
			group_objects[gt] = list()
		group_objects[gt] += list(G.GetFormattedUI())
	return list("group_objects" = group_objects)

/datum/aboutme_record/proc/get_ui_relationships(mob/living/carbon/human/owner)
	var/list/out = list()
	for (var/rkey in relationship_keys)
		var/datum/relationships/R = SSroleplay_management.get_relationship_by_key(rkey)
		out += list(R.GetFormattedUI())
	return out

/datum/aboutme_record/proc/get_ui_chronicles(mob/user)
	var/list/visible = list()
	for (var/ckey in chronicle_keys)
		var/datum/chronicle/C = SSroleplay_management.get_chronicle_by_key(ckey)
		if (!C || !C.is_visible_to(user, character_id)) continue
		var/list/event_data = C.GetFormattedUI()
		visible += list(event_data)
	return list("events" = visible)

/datum/aboutme_record/proc/get_ui_memories_by_tag(mob/user)
	var/list/by_tag = list(
		"memories_all" = list(),
		"background" = list(), "current" = list(), "recent" = list(),
		"goal" = list(), "secret" = list(), "reputation" = list(),
		"relationship" = list(), "character_memories" = list()
	)

	if (!islist(memory_keys) || !memory_keys.len)
		return by_tag

	for (var/mkey in memory_keys)
		var/datum/memory/M = SSroleplay_management.get_memory_by_key(mkey)
		if (!M) continue
		if (!M.is_visible_to(user, character_id)) continue

		var/list/mui = M.GetFormattedUI()
		by_tag["memories_all"] += list(mui)

		if (islist(M.tags))
			for (var/tag in M.tags)
				if (tag in by_tag)
					by_tag[tag] += list(mui)

	return by_tag

/datum/aboutme_record/proc/to_row_db()
	return list(
		"character_id" = character_id,
		"edit_display_name" = edit_display_name,
		"edit_goals" = edit_goals,
		"edit_personal_quote" = edit_personal_quote,
		"edit_gender" = edit_gender,
		"edit_physical_desc" = edit_physical_desc,
		"group_keys_json" = json_encode(islist(group_keys) ? group_keys : list()),
		"relationship_keys_json" = json_encode(islist(relationship_keys) ? relationship_keys : list()),
		"chronicle_keys_json" = json_encode(islist(chronicle_keys) ? chronicle_keys : list()),
		"memory_keys_json" = json_encode(islist(memory_keys) ? memory_keys : list()),
		"has_initialized_personal_chronicle" = has_initialized_personal_chronicle ? 1 : 0,
		"has_initialized_groups_from_role" = has_initialized_groups_from_role ? 1 : 0,
		"has_initialized_entry_memory" = has_initialized_entry_memory ? 1 : 0
	)

/datum/aboutme_record/proc/from_row_db(list/dbrow)
	character_id = "[dbrow["character_id"]]"
	edit_display_name = dbrow["edit_display_name"]
	edit_goals = dbrow["edit_goals"]
	edit_personal_quote = dbrow["edit_personal_quote"]
	edit_gender = dbrow["edit_gender"]
	edit_physical_desc = dbrow["edit_physical_desc"]
	group_keys        = json_decode(dbrow["group_keys_json"]        || "[]")
	relationship_keys = json_decode(dbrow["relationship_keys_json"] || "[]")
	chronicle_keys    = json_decode(dbrow["chronicle_keys_json"]    || "[]")
	memory_keys       = json_decode(dbrow["memory_keys_json"]       || "[]")
	has_initialized_personal_chronicle = !!dbrow["has_initialized_personal_chronicle"]
	has_initialized_groups_from_role   = !!dbrow["has_initialized_groups_from_role"]
	has_initialized_entry_memory       = !!dbrow["has_initialized_entry_memory"]
	created_at = dbrow["created_at"] || created_at
	updated_at = dbrow["updated_at"] || updated_at
