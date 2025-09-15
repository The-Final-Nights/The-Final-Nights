// RP Management Subsystem - Core (ssroleplay_management_subsystem.dm)
SUBSYSTEM_DEF(roleplay_management)
	name = "RP Management"
	init_order = INIT_ORDER_DEFAULT
	wait = 10
/datum/controller/subsystem/roleplay_management
var/list/runtime_by_canon = list()

/datum/controller/subsystem/roleplay_management/Initialize()
	. = ..()
	rpm_register_canonical_groups()
	groups_runtime_dedupe()

/datum/controller/subsystem/roleplay_management/fire()
	..()
	for (var/group_id in GLOB.groups)
		var/datum/group/G = GLOB.groups[group_id]
		if (!G?.active_votes || !length(G.active_votes)) continue
		G.resolve_votes()

/datum/controller/subsystem/roleplay_management/proc/about_me_new_id(prefix)
	if (!prefix) prefix = "BROKEN_ID"
	return "[prefix]"

/datum/controller/subsystem/roleplay_management/proc/group_id_new(gtype, gname)
	if (!istext(gtype) || !length(gtype)) gtype = "unknown"
	gtype = lowertext(gtype)
	var/id = "group_[gtype]_[gname]"
	return id

/datum/controller/subsystem/roleplay_management/proc/is_valid_id(key)
	return istext(key) && length(key) > 3

/datum/controller/subsystem/roleplay_management/proc/is_valid_character_id(character_key)
	return istext(character_key) && (character_key in GLOB.valid_character_ids)

/datum/controller/subsystem/roleplay_management/proc/check_register_valid_character_id(character_key)
	if (istext(character_key) && !(character_key in GLOB.valid_character_ids))
		GLOB.valid_character_ids += character_key

/datum/controller/subsystem/roleplay_management/proc/get_relationship_by_id(rel_id)
	if (!rel_id || !(rel_id in GLOB.relationships))
		return null
	return GLOB.relationships[rel_id]


