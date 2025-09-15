//roleplay_management_defines.dm
#define GROUP_TYPE_CITY             "city"
#define GROUP_TYPE_FACTION          "faction"
#define GROUP_TYPE_SECT             "sect"
#define GROUP_TYPE_CLAN             "clan"
#define GROUP_TYPE_TRIBE            "tribe"
#define GROUP_TYPE_ORGANIZATION     "organization"
#define GROUP_TYPE_PARTY            "party"
#define GROUP_TYPE_PLAYER           "player_created"

#define RELATIONSHIP_ALLY           "ally"
#define RELATIONSHIP_ENEMY          "enemy"
#define RELATIONSHIP_RIVAL          "rival"
#define RELATIONSHIP_FRIEND         "friend"
#define RELATIONSHIP_LOVER          "lover"
#define RELATIONSHIP_CONTACT        "contact"
#define RELATIONSHIP_FAMILY         "family"
#define RELATIONSHIP_SUSPECT        "suspect"
#define RELATIONSHIP_UNKNOWN        "unknown"
#define RELATIONSHIP_GROUP          "group"

#define RELATIONSHIP_TYPE_KEYS list( \
	RELATIONSHIP_ALLY, \
	RELATIONSHIP_ENEMY, \
	RELATIONSHIP_RIVAL, \
	RELATIONSHIP_FRIEND, \
	RELATIONSHIP_LOVER, \
	RELATIONSHIP_CONTACT, \
	RELATIONSHIP_FAMILY, \
	RELATIONSHIP_SUSPECT, \
	RELATIONSHIP_UNKNOWN, \
	RELATIONSHIP_GROUP \
)

#define RELATIONSHIP_TAGS_ALLOWED list( \
	"trusted", "romantic", "bloodbond", "business", \
	"secret", "public", "clan", "rivalry", "political", \
	"mentor", "target", "ally", "danger" \
)

#define MEMORY_TAG_BACKGROUND       "background"
#define MEMORY_TAG_CURRENT          "current"
#define MEMORY_TAG_RECENT           "recent"
#define MEMORY_TAG_GOAL             "goal"
#define MEMORY_TAG_SECRET           "secret"
#define MEMORY_TAG_REPUTATION       "reputation"
#define MEMORY_TAG_RELATIONSHIP     "relationship"
#define MEMORY_TAG_CHARACTER        "character_memories"
#define MEMORY_TAG_ALL              "memories_all"


// GROUP KEY MACROS:
#define GROUP_KEY_SECT(SECT)        "sect_[lowertext(replacetext(SECT, " ", "_"))]"
#define GROUP_KEY_CLAN(CLAN)        "clan_[lowertext(replacetext(CLAN, " ", "_"))]"
#define GROUP_KEY_TRIBE(TRIBE)      "tribe_[lowertext(replacetext(TRIBE, " ", "_"))]"

#define GROUP_KEY_CITY              "city_sanfrancisco"
// Factions
#define GROUP_KEY_FACTION_UNKNOWING "faction_citizen"
#define GROUP_KEY_FACTION_KINDRED   "faction_kindred"
#define GROUP_KEY_FACTION_FERA      "faction_fera"
#define GROUP_KEY_FACTION_HUNTERS   "faction_hunters"
#define GROUP_KEY_FACTION_GHOUL "faction_ghoul"
#define GROUP_KEY_FACTION_KUEIJIN "faction_kueijin"
// Sects
#define GROUP_KEY_SECT_INDEPENDENT  "sect_independent"
#define GROUP_KEY_SECT_CAMARILLA    "sect_camarilla"
#define GROUP_KEY_SECT_ANARCHS      "sect_anarchs"
#define GROUP_KEY_SECT_SABBAT       "sect_sabbat"
#define GROUP_KEY_SECT_PAINTEDCITY  "sect_paintedcity"
#define GROUP_KEY_SECT_AMBERGLADE   "sect_amberglade"
#define GROUP_KEY_SECT_POISONEDSHORE "sect_poisonedshore"

// Clans
#define GROUP_KEY_CLAN_CAITIF               "clan_caitif"
#define GROUP_KEY_CLAN_VENTRUE              "clan_ventrue"
#define GROUP_KEY_CLAN_BRUJAH               "clan_brujah"
#define GROUP_KEY_CLAN_TRUE_BRUJAH          "clan_true_brujah"
#define GROUP_KEY_CLAN_TOREADOR             "clan_toreador"
#define GROUP_KEY_CLAN_MALKAVIAN            "clan_malkavian"
#define GROUP_KEY_CLAN_NOSFERATU            "clan_nosferatu"
#define GROUP_KEY_CLAN_GANGREL              "clan_gangrel"
#define GROUP_KEY_CLAN_TREMERE              "clan_tremere"
#define GROUP_KEY_CLAN_LASOMBRA             "clan_lasombra"
#define GROUP_KEY_CLAN_TZIMISCE             "clan_tzimisce"
#define GROUP_KEY_CLAN_MINISTRY             "clan_ministry"
#define GROUP_KEY_CLAN_GIOVANNI             "clan_giovanni"
#define GROUP_KEY_CLAN_SALUBRI              "clan_salubri"
#define GROUP_KEY_CLAN_DAUGHTERS_OF_CACOPHONY "clan_daughters_of_cacophony"
#define GROUP_KEY_CLAN_BAALI                "clan_baali"
#define GROUP_KEY_CLAN_BANU_HAQIM           "clan_banu_haqim"

// Tribes
#define GROUP_KEY_TRIBE_RONIN               "tribe_ronin"
#define GROUP_KEY_TRIBE_BLACKFURIES         "tribe_blackfuries"
#define GROUP_KEY_TRIBE_BLACKSPIRALDANCERS  "tribe_blackspiraldancers"
#define GROUP_KEY_TRIBE_BONEGNAWERS         "tribe_bonegnawers"
#define GROUP_KEY_TRIBE_CHILDRENOFGAIA      "tribe_childrenofgaia"
#define GROUP_KEY_TRIBE_CORAX               "tribe_corax"
#define GROUP_KEY_TRIBE_GALESTALKERS        "tribe_galestalkers"
#define GROUP_KEY_TRIBE_GETOFFENRIS         "tribe_getoffenris"
#define GROUP_KEY_TRIBE_GHOSTCOUNCIL        "tribe_ghostcouncil"
#define GROUP_KEY_TRIBE_GLASSWALKERS        "tribe_glasswalkers"
#define GROUP_KEY_TRIBE_HARTWARDENS         "tribe_hartwardens"
#define GROUP_KEY_TRIBE_REDTALONS           "tribe_redtalons"
#define GROUP_KEY_TRIBE_SHADOWLORDS         "tribe_shadowlords"
#define GROUP_KEY_TRIBE_SILENTSTRIDERS      "tribe_silentstriders"
#define GROUP_KEY_TRIBE_SILVERFANGS         "tribe_silverfangs"
#define GROUP_KEY_TRIBE_STARGAZERS          "tribe_stargazers"

// Organizations
#define GROUP_KEY_ORG_GOVERNMENT         "org_government"
#define GROUP_KEY_ORG_POLICE             "org_police"
#define GROUP_KEY_ORG_HOSPITAL           "org_hospital"
#define GROUP_KEY_ORG_MILITARY           "org_military"
#define GROUP_KEY_ORG_WAREHOUSE          "org_warehouse"
#define GROUP_KEY_ORG_CHURCH             "org_church"
#define GROUP_KEY_ORG_CIVICSERVICES      "org_civicservices"
#define GROUP_KEY_ORG_NATIONALSECURITY   "org_nationalsecurity"
#define GROUP_KEY_ORG_TZIMISCE           "org_tzimisce"
#define GROUP_KEY_ORG_TRIAD              "org_triad"
#define GROUP_KEY_ORG_MILLENNIUMTOWER    "org_millenniumtower"
#define GROUP_KEY_ORG_ANARCHYROSE        "org_anarchyrose"
#define GROUP_KEY_ORG_SABBATCULT         "org_sabbatcult"
#define GROUP_KEY_ORG_TREMERE_COVER      "org_tremerecover"
#define GROUP_KEY_ORG_GIOVANNI_BANK      "org_giovannibank"
#define GROUP_KEY_ORG_ENDRON             "org_endron"
#define GROUP_KEY_ORG_AMBERGLADE         "org_amberglade"
#define GROUP_KEY_ORG_PAINTEDCITYMALL    "org_paintedcitymall"

#define CANON_GROUPS_MAP list( \
	/* Cities */ \
	GROUP_KEY_CITY = /datum/group/city/sanfrancisco, \
	/* Factions */ \
	GROUP_KEY_FACTION_UNKNOWING = /datum/group/faction/citizen, \
	GROUP_KEY_FACTION_KINDRED   = /datum/group/faction/kindred, \
	GROUP_KEY_FACTION_FERA      = /datum/group/faction/fera, \
	GROUP_KEY_FACTION_HUNTERS   = /datum/group/faction/hunter, \
	GROUP_KEY_FACTION_GHOUL     = /datum/group/faction/ghoul, \
	GROUP_KEY_FACTION_KUEIJIN   = /datum/group/faction/kueijin, \
	/* Sects */ \
	GROUP_KEY_SECT_CAMARILLA    = /datum/group/sect/camarilla, \
	GROUP_KEY_SECT_ANARCHS      = /datum/group/sect/anarchs, \
	GROUP_KEY_SECT_SABBAT       = /datum/group/sect/sabbat, \
	GROUP_KEY_SECT_INDEPENDENT  = /datum/group/sect/independent, \
	GROUP_KEY_SECT_PAINTEDCITY  = /datum/group/sect/paintedcity, \
	GROUP_KEY_SECT_AMBERGLADE   = /datum/group/sect/amberglade, \
	GROUP_KEY_SECT_POISONEDSHORE = /datum/group/sect/poisonedshore, \
	/* Clans */ \
	GROUP_KEY_CLAN_VENTRUE      = /datum/group/clan/ventrue, \
	GROUP_KEY_CLAN_BRUJAH       = /datum/group/clan/brujah, \
	GROUP_KEY_CLAN_TRUE_BRUJAH  = /datum/group/clan/true_brujah, \
	GROUP_KEY_CLAN_BANU_HAQIM   = /datum/group/clan/banu_haqim, \
	GROUP_KEY_CLAN_TOREADOR     = /datum/group/clan/toreador, \
	GROUP_KEY_CLAN_MALKAVIAN    = /datum/group/clan/malkavian, \
	GROUP_KEY_CLAN_NOSFERATU    = /datum/group/clan/nosferatu, \
	GROUP_KEY_CLAN_GANGREL      = /datum/group/clan/gangrel, \
	GROUP_KEY_CLAN_TREMERE      = /datum/group/clan/tremere, \
	GROUP_KEY_CLAN_LASOMBRA     = /datum/group/clan/lasombra, \
	GROUP_KEY_CLAN_TZIMISCE     = /datum/group/clan/tzimisce, \
	GROUP_KEY_CLAN_MINISTRY     = /datum/group/clan/ministry, \
	GROUP_KEY_CLAN_GIOVANNI     = /datum/group/clan/giovanni, \
	GROUP_KEY_CLAN_SALUBRI      = /datum/group/clan/salubri, \
	GROUP_KEY_CLAN_DAUGHTERS_OF_CACOPHONY = /datum/group/clan/daughters_of_cacophony, \
	GROUP_KEY_CLAN_BAALI        = /datum/group/clan/baali, \
	GROUP_KEY_CLAN_CAITIF       = /datum/group/clan/caitif, \
	/* Tribes */ \
	GROUP_KEY_TRIBE_RONIN              = /datum/group/tribe/ronin, \
	GROUP_KEY_TRIBE_BLACKFURIES        = /datum/group/tribe/blackfuries, \
	GROUP_KEY_TRIBE_BLACKSPIRALDANCERS = /datum/group/tribe/blackspiraldancers, \
	GROUP_KEY_TRIBE_BONEGNAWERS        = /datum/group/tribe/bonegnawers, \
	GROUP_KEY_TRIBE_CHILDRENOFGAIA     = /datum/group/tribe/childrenofgaia, \
	GROUP_KEY_TRIBE_CORAX              = /datum/group/tribe/corax, \
	GROUP_KEY_TRIBE_GALESTALKERS       = /datum/group/tribe/galestalkers, \
	GROUP_KEY_TRIBE_GETOFFENRIS        = /datum/group/tribe/getoffenris, \
	GROUP_KEY_TRIBE_GHOSTCOUNCIL       = /datum/group/tribe/ghostcouncil, \
	GROUP_KEY_TRIBE_GLASSWALKERS       = /datum/group/tribe/glasswalkers, \
	GROUP_KEY_TRIBE_HARTWARDENS        = /datum/group/tribe/hartwardens, \
	GROUP_KEY_TRIBE_REDTALONS          = /datum/group/tribe/redtalons, \
	GROUP_KEY_TRIBE_SHADOWLORDS        = /datum/group/tribe/shadowlords, \
	GROUP_KEY_TRIBE_SILENTSTRIDERS     = /datum/group/tribe/silentstriders, \
	GROUP_KEY_TRIBE_SILVERFANGS        = /datum/group/tribe/silverfangs, \
	GROUP_KEY_TRIBE_STARGAZERS         = /datum/group/tribe/stargazers, \
	/* Core Orgs */ \
	GROUP_KEY_ORG_GOVERNMENT        = /datum/group/organization/government, \
	GROUP_KEY_ORG_POLICE            = /datum/group/organization/policedepartment, \
	GROUP_KEY_ORG_HOSPITAL          = /datum/group/organization/hospital, \
	GROUP_KEY_ORG_MILITARY          = /datum/group/organization/military, \
	GROUP_KEY_ORG_WAREHOUSE         = /datum/group/organization/warehouse, \
	GROUP_KEY_ORG_CHURCH            = /datum/group/organization/church, \
	GROUP_KEY_ORG_CIVICSERVICES     = /datum/group/organization/civicservices, \
	GROUP_KEY_ORG_NATIONALSECURITY  = /datum/group/organization/nationalsecurity, \
	/* Independent Orgs */ \
	GROUP_KEY_ORG_TZIMISCE          = /datum/group/organization/tzimisce, \
	GROUP_KEY_ORG_TRIAD             = /datum/group/organization/triad, \
	/* Fronts */ \
	GROUP_KEY_ORG_MILLENNIUMTOWER   = /datum/group/organization/millenniumtower, \
	GROUP_KEY_ORG_ANARCHYROSE       = /datum/group/organization/anarchyrose, \
	GROUP_KEY_ORG_SABBATCULT        = /datum/group/organization/sabbatcult, \
	GROUP_KEY_ORG_TREMERE_COVER     = /datum/group/organization/historicsociety, \
	GROUP_KEY_ORG_GIOVANNI_BANK     = /datum/group/organization/giovannibank, \
	GROUP_KEY_ORG_ENDRON            = /datum/group/organization/endron, \
	GROUP_KEY_ORG_AMBERGLADE        = /datum/group/organization/amberglade, \
	GROUP_KEY_ORG_PAINTEDCITYMALL   = /datum/group/organization/paintedcitymall \
)



/datum/controller/subsystem/roleplay_management/proc/rpm_get_or_make_canonical_group(group_key, group_typepath)
    if (!GLOB.canonical_groups)
        GLOB.canonical_groups = list()
    if (GLOB.canonical_groups[group_key])
        return GLOB.canonical_groups[group_key]

    var/datum/group/group_datum = new group_typepath()
    if (!group_datum.id)
        group_datum.id = group_key

    // marked clearly as canonical and keep it OUT of GLOB.groups
    group_datum.canonical_key = group_key
    group_datum.is_canonical = TRUE

    GLOB.canonical_groups[group_key] = group_datum
    return group_datum


/datum/controller/subsystem/roleplay_management/proc/rpm_register_canonical_groups()
	if (!GLOB.canonical_groups)
		GLOB.canonical_groups = list()
	if (!GLOB.groups)
		GLOB.groups = list()
	if (!GLOB.canonical_type_to_key)
		GLOB.canonical_type_to_key = list()
	var/list/canonical_map = CANON_GROUPS_MAP
	for (var/group_key in canonical_map)
		var/group_typepath = canonical_map[group_key]
		if (!ispath(group_typepath))
			world.log << "Bad typepath for canonical group: [group_key]"
			continue
		rpm_get_or_make_canonical_group(group_key, group_typepath)
		GLOB.canonical_type_to_key[group_typepath] = group_key

/datum/controller/subsystem/roleplay_management/proc/rpm_canonical_key_for_typepath(typepath)
	return GLOB.canonical_type_to_key ? GLOB.canonical_type_to_key[typepath] : null

#undef CANON_GROUPS_MAP
