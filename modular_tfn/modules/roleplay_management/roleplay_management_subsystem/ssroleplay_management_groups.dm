// ================================================================
// RP Management Subsystem - Groups (ssroleplay_management_groups.dm)
// ================================================================
// Handles:
//   - Canonical group registration
//   - Initial group assignment based on species/role
//   - Runtime group lookup and modification
// ================================================================
//Species Factions, and Base clan membership is already handled before here.
/datum/controller/subsystem/roleplay_management/var/list/ROLE_GROUP_MAPPINGS = list(
	// Camarilla (Sect + Millennium Tower)
	"prince" = list(
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_MILLENNIUMTOWER, "is_leader" = TRUE)
	),
	"seneschal" = list(
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_MILLENNIUMTOWER, "is_officer" = TRUE)
	),
	"harpy" = list(
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_MILLENNIUMTOWER, "is_officer" = TRUE)
	),
	"sheriff" = list(
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_MILLENNIUMTOWER, "is_officer" = TRUE)
	),
	"hound" = list(
		list("sect" = GROUP_KEY_SECT_CAMARILLA),
		list("organization" = GROUP_KEY_ORG_MILLENNIUMTOWER)
	),

	// ---- PRIMOGEN ----
	// These get sect + clan, need orgs.

	"primogen banu haqim" = list(
		list("clan" = GROUP_KEY_CLAN_BANU_HAQIM, "is_leader" = TRUE),
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE)
		// NEVER Tower
	),
	"primogen lasombra" = list(
		list("clan" = GROUP_KEY_CLAN_LASOMBRA, "is_leader" = TRUE),
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE)
		// NEVER Tower
	),
	"primogen malkavian" = list(
		list("clan" = GROUP_KEY_CLAN_MALKAVIAN, "is_leader" = TRUE),
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE)
		// NEVER Tower
	),
	"primogen nosferatu" = list(
		list("clan" = GROUP_KEY_CLAN_NOSFERATU, "is_leader" = TRUE),
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE)
		// NEVER Tower
	),
	"primogen toreador" = list(
		list("clan" = GROUP_KEY_CLAN_TOREADOR, "is_leader" = TRUE),
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE)
		// NEVER Tower
	),
	// The only primogen with direct access to Tower.
	"primogen ventrue" = list(
		list("clan" = GROUP_KEY_CLAN_VENTRUE, "is_leader" = TRUE),
		list("sect" = GROUP_KEY_SECT_CAMARILLA, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_MILLENNIUMTOWER, "is_officer" = TRUE)
	),

	// Anarchs (Sect + Anarchy Rose Bar)
	"baron" = list(
		list("sect" = GROUP_KEY_SECT_ANARCHS, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_ANARCHYROSE, "is_leader" = TRUE)
	),
	"emissary" = list(
		list("sect" = GROUP_KEY_SECT_ANARCHS, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_ANARCHYROSE, "is_officer" = TRUE)
	),
	"sweeper" = list(
		list("sect" = GROUP_KEY_SECT_ANARCHS)
		// No org, just Anarchs sect
	),
	"bruiser" = list(
		list("sect" = GROUP_KEY_SECT_ANARCHS)
		// No org, just Anarchs sect
	),

	// Sabbat (Sect + Sabbat Cult Front)
	"ductus" = list(
		list("sect" = GROUP_KEY_SECT_SABBAT, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_SABBATCULT, "is_leader" = TRUE)
	),
	"pack priest" = list(
		list("sect" = GROUP_KEY_SECT_SABBAT, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_SABBATCULT, "is_officer" = TRUE)
	),
	"sabbat pack" = list(
		list("sect" = GROUP_KEY_SECT_SABBAT, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_SABBATCULT, "is_officer" = TRUE)
	),

	// Tremere (Clan + Historic Society)
	"chantry regent" = list(
		list("clan" = GROUP_KEY_CLAN_TREMERE, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_TREMERE_COVER, "is_leader" = TRUE)
	),
	"chantry gargoyle" = list(
		list("clan" = GROUP_KEY_CLAN_TREMERE, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_TREMERE_COVER, "is_officer" = TRUE)
	),
	"chantry archivist" = list(
		list("clan" = GROUP_KEY_CLAN_TREMERE),
		list("organization" = GROUP_KEY_ORG_TREMERE_COVER)
	),

	// Giovanni (Clan + Bank Front)
	"capo" = list(
		list("clan" = GROUP_KEY_CLAN_GIOVANNI, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_GIOVANNI_BANK, "is_leader" = TRUE)
	),
	"la squadra" = list(
		list("clan" = GROUP_KEY_CLAN_GIOVANNI, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_GIOVANNI_BANK, "is_officer" = TRUE)
	),
	"la famiglia" = list(
		list("clan" = GROUP_KEY_CLAN_GIOVANNI),
		list("organization" = GROUP_KEY_ORG_GIOVANNI_BANK)
	),

	// Amberglade
	"amberglade councillor" = list(
		list("sect" = GROUP_KEY_SECT_AMBERGLADE, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_AMBERGLADE, "is_leader" = TRUE)
	),
	"amberglade keeper" = list(
		list("sect" = GROUP_KEY_SECT_AMBERGLADE, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_AMBERGLADE, "is_officer" = TRUE)
	),
	"amberglade truthcatcher" = list(
		list("sect" = GROUP_KEY_SECT_AMBERGLADE),
		list("organization" = GROUP_KEY_ORG_AMBERGLADE)
	),
	"amberglade warder" = list(
		list("sect" = GROUP_KEY_SECT_AMBERGLADE),
		list("organization" = GROUP_KEY_ORG_AMBERGLADE)
	),
	"amberglade guardian" = list(
		list("sect" = GROUP_KEY_SECT_AMBERGLADE),
		list("organization" = GROUP_KEY_ORG_AMBERGLADE)
	),

	// Painted City
	"painted city councillor" = list(
		list("sect" = GROUP_KEY_SECT_PAINTEDCITY, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_PAINTEDCITYMALL, "is_leader" = TRUE)
	),
	"painted city keeper" = list(
		list("sect" = GROUP_KEY_SECT_PAINTEDCITY, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_PAINTEDCITYMALL, "is_officer" = TRUE)
	),
	"painted city truthcatcher" = list(
		list("sect" = GROUP_KEY_SECT_PAINTEDCITY),
		list("organization" = GROUP_KEY_ORG_PAINTEDCITYMALL)
	),
	"painted city warder" = list(
		list("sect" = GROUP_KEY_SECT_PAINTEDCITY),
		list("organization" = GROUP_KEY_ORG_PAINTEDCITYMALL)
	),
	"painted city guardian" = list(
		list("sect" = GROUP_KEY_SECT_PAINTEDCITY),
		list("organization" = GROUP_KEY_ORG_PAINTEDCITYMALL)
	),

	// Endron
	"endron branch lead" = list(
		list("sect" = GROUP_KEY_SECT_POISONEDSHORE, "is_leader" = TRUE),
		list("organization" = GROUP_KEY_ORG_ENDRON, "is_leader" = TRUE)
	),
	"endron executive" = list(
		list("sect" = GROUP_KEY_SECT_POISONEDSHORE, "is_officer" = TRUE),
		list("organization" = GROUP_KEY_ORG_ENDRON, "is_officer" = TRUE)
	),
	"endron internal affairs agent" = list(
		list("sect" = GROUP_KEY_SECT_POISONEDSHORE),
		list("organization" = GROUP_KEY_ORG_ENDRON, "is_officer" = TRUE)
	),
	"endron chief of security" = list(
		list("sect" = GROUP_KEY_SECT_POISONEDSHORE),
		list("organization" = GROUP_KEY_ORG_ENDRON, "is_officer" = TRUE)
	),
	"endron security agent" = list(
		list("sect" = GROUP_KEY_SECT_POISONEDSHORE),
		list("organization" = GROUP_KEY_ORG_ENDRON)
	),
	"endron employee" = list(
		list("sect" = GROUP_KEY_SECT_POISONEDSHORE),
		list("organization" = GROUP_KEY_ORG_ENDRON)
	),

	// Tzimisce (Plastic Surgery Front / Mansion)
	"voivode" = list(
		list("organization" = GROUP_KEY_ORG_TZIMISCE, "is_leader" = TRUE)
	),
	"bogatyr" = list(
		list("organization" = GROUP_KEY_ORG_TZIMISCE, "is_officer" = TRUE)
	),
	"zadruga" = list(
		list("organization" = GROUP_KEY_ORG_TZIMISCE)
	),

	// Triad (Criminal Front)
	"triad soldier" = list(
		list("organization" = GROUP_KEY_ORG_TRIAD, "is_officer" = TRUE)
	),

	// Police Department
	"police chief" = list(
		list("organization" = GROUP_KEY_ORG_POLICE, "is_leader" = TRUE)
	),
	"police sergeant" = list(
		list("organization" = GROUP_KEY_ORG_POLICE, "is_officer" = TRUE)
	),
	"police officer" = list(
		list("organization" = GROUP_KEY_ORG_POLICE)
	),
	"emergency dispatcher" = list(
		list("organization" = GROUP_KEY_ORG_POLICE, "is_officer" = TRUE)
	),

	// National Security / Federal Oversight
	"federal investigator" = list(
		list("organization" = GROUP_KEY_ORG_NATIONALSECURITY),
		list("organization" = GROUP_KEY_ORG_POLICE, "is_officer" = TRUE)
	),

	// Hospital
	"clinic director" = list(
		list("organization" = GROUP_KEY_ORG_HOSPITAL, "is_leader" = TRUE)
	),
	"doctor" = list(
		list("organization" = GROUP_KEY_ORG_HOSPITAL)
	),

	// Warehouse Union
	"union boss" = list(
		list("organization" = GROUP_KEY_ORG_WAREHOUSE, "is_leader" = TRUE)
	),
	"dealer" = list(
		list("organization" = GROUP_KEY_ORG_WAREHOUSE, "is_officer" = TRUE)
	),
	"supply technician" = list(
		list("organization" = GROUP_KEY_ORG_WAREHOUSE)
	),
	"dock worker" = list(
		list("organization" = GROUP_KEY_ORG_WAREHOUSE)
	),

	// Civic Services
	"graveyard keeper" = list(
		list("organization" = GROUP_KEY_ORG_CIVICSERVICES)
	),
	"club worker" = list(
		list("organization" = GROUP_KEY_ORG_CIVICSERVICES)
	),
	"street janitor" = list(
		list("organization" = GROUP_KEY_ORG_CIVICSERVICES)
	),
	"taxi driver" = list(
		list("organization" = GROUP_KEY_ORG_CIVICSERVICES)
	),

	//Church
	"priest" = list(
		list("organization" = GROUP_KEY_ORG_CHURCH, "is_leader" = TRUE)
	),
	"church curator" = list(
		list("organization" = GROUP_KEY_ORG_CHURCH, "is_officer" = TRUE)
	),
	"church caretaker" = list(
		list("organization" = GROUP_KEY_ORG_CHURCH, "is_officer" = TRUE)
	),

)

/datum/controller/subsystem/roleplay_management/proc/get_group_by_id(id)
	if (!id) return null
	// 1) runtime by id/key
	if (GLOB.groups && GLOB.groups[id]) return GLOB.groups[id]
	// 2) canonical by key
	if (GLOB.canonical_groups && GLOB.canonical_groups[id]) return GLOB.canonical_groups[id]
	return null

/datum/controller/subsystem/roleplay_management/proc/register_group(datum/group/G)
	if (G && G.id && is_valid_id(G.id))
		GLOB.groups[G.id] = G
/datum/controller/subsystem/roleplay_management/proc/unregister_group(datum/group/G)
	if (G?.id)
		GLOB.groups -= G.id

/datum/controller/subsystem/roleplay_management/proc/get_or_spawn_runtime_group(canon_key)
    for (var/gid in GLOB.groups)
        var/datum/group/G = GLOB.groups[gid]
        if (G?.canonical_key == canon_key)
            return G

    var/datum/group/C = GLOB.canonical_groups[canon_key]
    if (!C) return null
    for (var/gid2 in GLOB.groups)
        var/datum/group/H = GLOB.groups[gid2]
        if (!H?.canonical_key && H.gtype == C.gtype && H.name == C.name)
            H.canonical_key = canon_key
            return H

    var/datum/group/R = new C.type()
    R.id            = SSroleplay_management.group_id_new(C.gtype, C.name)
    R.gtype         = C.gtype
    R.name          = C.name
    R.desc          = C.desc
    R.status        = C.status
    R.visibility    = C.visibility
    R.canonical_key = canon_key
    R.leaders  = list(); R.officers = list(); R.members = list()
    GLOB.groups[R.id] = R
    return R

/datum/controller/subsystem/roleplay_management/proc/ensure_groups_from_role(character_id, mob/living/carbon/human/owner)
	if (!character_id || !owner) return
	var/datum/aboutme_record/R = get_aboutme_record(character_id)
	if (!R) return

	var/mob/living/carbon/human/H = owner
	var/list/new_keys = list()
	var/display_name = H.true_real_name || H.name

	// --- City (always) ---
	var/datum/group/city_rt = get_or_spawn_runtime_group(GROUP_KEY_CITY)
	if (city_rt)
		city_rt.add_member_key(character_id, display_name)
		new_keys += GROUP_KEY_CITY

	// --- Faction ---
	var/faction_key
	if (isghoul(H))        faction_key = GROUP_KEY_FACTION_GHOUL
	else if (iscathayan(H)) faction_key = GROUP_KEY_FACTION_KUEIJIN
	else if (iskindred(H))  faction_key = GROUP_KEY_FACTION_KINDRED
	else if (isgarou(H))    faction_key = GROUP_KEY_FACTION_FERA
	else                    faction_key = GROUP_KEY_FACTION_UNKNOWING

	if (faction_key)
		var/datum/group/faction_rt = get_or_spawn_runtime_group(faction_key)
		if (faction_rt)
			faction_rt.add_member_key(character_id, display_name)
			new_keys += faction_key

	// --- Dynamic Role-Based Assignments ---
	var/group_roles = role_to_groups(H.mind?.assigned_role)
	for (var/Role in group_roles)
		var/canon_key = Role["group_key"]
		var/datum/group/G = get_or_spawn_runtime_group(canon_key)
		if (!G) continue
		new_keys += canon_key

		if (Role["is_leader"])
			G.add_leader(character_id, display_name)
		else if (Role["is_officer"])
			G.add_officer(character_id, display_name)
		else
			G.add_member_key(character_id, display_name)

	// --- Clan (Kindred only) ---
	if (iskindred(H))
		var/datum/vampire_clan/clan = H.clan
		var/clan_key = clan ? GROUP_KEY_CLAN(clan.name) : GROUP_KEY_CLAN_CAITIF
		var/datum/group/clan_rt = get_or_spawn_runtime_group(clan_key)
		if (!clan_rt && clan_key != GROUP_KEY_CLAN_CAITIF)
			clan_key = GROUP_KEY_CLAN_CAITIF
			clan_rt = get_or_spawn_runtime_group(clan_key)
		if (clan_rt)
			for (var/k in new_keys)
				if (copytext(k, 1, 6) == "clan_" && k != clan_key)
					new_keys -= k
			clan_rt.add_member_key(character_id, display_name)
			if (!(clan_key in new_keys))
				new_keys += clan_key

	// --- Tribe (Garou) ---
	if (isgarou(H) || iswerewolf(H))
		var/tribe_name = H.auspice?.tribe?.name
		var/tribe_key = tribe_name ? GROUP_KEY_TRIBE(tribe_name) : GROUP_KEY_TRIBE_RONIN
		var/datum/group/tribe_rt = get_or_spawn_runtime_group(tribe_key) || get_or_spawn_runtime_group(GROUP_KEY_TRIBE_RONIN)
		if (tribe_rt)
			tribe_rt.add_member_key(character_id, display_name)
			new_keys += tribe_key

	if (!islist(R.group_keys)) R.group_keys = list()
	for (var/k in new_keys)
		if (!(k in R.group_keys))
			R.group_keys += k

	R.has_initialized_groups_from_role = TRUE
	R.touch()

/datum/controller/subsystem/roleplay_management/proc/clear_group_relationship(character_key, datum/group/G)
	G.leaders -= character_key
	G.officers -= character_key
	G.members -= character_key
	var/datum/aboutme_record/R = get_aboutme_record(character_key)
	if (R && islist(R.group_keys))
		R.group_keys -= G.id
	for (var/datum/relationships/rel in GLOB.relationships)
		if (rel.owner_key == character_key && rel.target_key == G.id)
			GLOB.relationships -= rel.id
			if (R?.relationship_keys)
				R.relationship_keys -= rel.id
			qdel(rel)
			break
	return
/datum/controller/subsystem/roleplay_management/proc/role_to_groups(role)
	var/list/results = list()
	var/entry = SSroleplay_management.ROLE_GROUP_MAPPINGS[lowertext(trim(role))]
	if (!islist(entry))
		return results
	if (!islist(entry[1]))
		entry = list(entry)
	for (var/map in entry)
		for (var/group_type in map)
			if (!(group_type in list(GROUP_TYPE_SECT, GROUP_TYPE_CLAN, GROUP_TYPE_TRIBE, GROUP_TYPE_ORGANIZATION, GROUP_TYPE_PARTY)))
				continue
			var/group_key = map[group_type]
			results += list(list(
				"group_key" = group_key,
				"group_type" = group_type,
				"is_leader" = map["is_leader"] || FALSE,
				"is_officer" = map["is_officer"] || FALSE
			))
	return results

/datum/controller/subsystem/roleplay_management/proc/remove_key_from_all_groups(character_key)
	for (var/group_id in GLOB.groups)
		var/datum/group/G = GLOB.groups[group_id]
		if (!G) continue
		G.leaders -= character_key
		G.officers -= character_key
		G.members -= character_key

/datum/controller/subsystem/roleplay_management/proc/groups_runtime_dedupe(canon_key)
	var/datum/group/C = GLOB.canonical_groups ? GLOB.canonical_groups[canon_key] : null
	if (!C) return null
	var/datum/group/keep = null
	var/list/trash = list()
	for (var/gid in (GLOB.groups || list()))
		var/datum/group/G = GLOB.groups[gid]
		if (!G) continue
		var/is_candidate = (G.canonical_key == canon_key) || ((G.gtype == C.gtype) && (G.name == C.name))
		if (!is_candidate) continue
		if (!keep)
			keep = G
		else
			trash += gid
	for (var/gid in trash)
		var/datum/group/T = GLOB.groups[gid]
		if (!T) continue
		SSroleplay_management.unregister_group(T)
		qdel(T)

	return keep

