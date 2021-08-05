
#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_ACCOUNTAGE 4
#define JOB_UNAVAILABLE_SLOTFULL 5
#define JOB_UNAVAILABLE_GENERATION 6
#define JOB_UNAVAILABLE_MASQUERADE 7
#define JOB_UNAVAILABLE_SPECIES 8
#define JOB_UNAVAILABLE_SPECIES_LIMITED 9
#define JOB_UNAVAILABLE_CLAN 10
#define JOB_UNAVAILABLE_AGE 11
#define JOB_UNAVAILABLE_WHITELISTED 12
#define JOB_UNAVAILABLE_RANK 13
#define JOB_UNAVAILABLE_TRIBE 14
#define JOB_UNAVAILABLE_CHARACTER_AGE 13

#define DEFAULT_RELIGION "Christianity"
#define DEFAULT_DEITY "Space Jesus"
#define DEFAULT_BIBLE "Default Bible Name"
#define DEFAULT_BIBLE_REPLACE(religion) "The Holy Book of [religion]"

#define JOB_DISPLAY_ORDER_DEFAULT 0
#define JOB_DISPLAY_ORDER_CITIZEN 1
#define JOB_DISPLAY_ORDER_SALUBRI 2
#define JOB_DISPLAY_ORDER_LASOMBRA 3
#define JOB_DISPLAY_ORDER_DAUGHTER 4
#define JOB_DISPLAY_ORDER_BAALI 5
#define JOB_DISPLAY_ORDER_TRUJAH 6
#define JOB_DISPLAY_ORDER_KIASYD 7
#define JOB_DISPLAY_ORDER_BANU 8
#define JOB_DISPLAY_ORDER_PRINCE 9
#define JOB_DISPLAY_ORDER_SHERIFF 10
#define JOB_DISPLAY_ORDER_CLERK 11
#define JOB_DISPLAY_ORDER_HARPY 12
#define JOB_DISPLAY_ORDER_HOUND 13
#define JOB_DISPLAY_ORDER_TOWERWORK 14
#define JOB_DISPLAY_ORDER_BANUPRIM 15
#define JOB_DISPLAY_ORDER_LASOMBRAPRIM 16
#define JOB_DISPLAY_ORDER_MALKAVIAN 17
#define JOB_DISPLAY_ORDER_NOSFERATU 18
#define JOB_DISPLAY_ORDER_TOREADOR 19
#define JOB_DISPLAY_ORDER_VENTRUE 20
#define JOB_DISPLAY_ORDER_PRIEST 21
#define JOB_DISPLAY_ORDER_CLINICS_DIRECTOR 22
#define JOB_DISPLAY_ORDER_DOCTOR 23
#define JOB_DISPLAY_ORDER_GRAVEYARD 24
#define JOB_DISPLAY_ORDER_STREETJAN 25
#define JOB_DISPLAY_ORDER_STRIP 26
#define JOB_DISPLAY_ORDER_TAXI 27
#define JOB_DISPLAY_ORDER_TRIAD_GANGSTER 28
#define JOB_DISPLAY_ORDER_BARKEEPER 29
#define JOB_DISPLAY_ORDER_EMISSARY 30
#define JOB_DISPLAY_ORDER_SWEEPER 31
#define JOB_DISPLAY_ORDER_BRUISER 32
#define JOB_DISPLAY_ORDER_DEALER 33
#define JOB_DISPLAY_ORDER_SUPPLY 34
#define JOB_DISPLAY_ORDER_REGENT 35
#define JOB_DISPLAY_ORDER_ARCHIVIST 36
#define JOB_DISPLAY_ORDER_GARGOYLE 37
#define JOB_DISPLAY_ORDER_GIOVANNI 38
#define JOB_DISPLAY_ORDER_POLICE_CHIEF 39
#define JOB_DISPLAY_ORDER_POLICE 40
#define JOB_DISPLAY_ORDER_POLICE_SERGEANT 41
#define JOB_DISPLAY_ORDER_FBI 42
#define JOB_DISPLAY_ORDER_VOIVODE 43
#define JOB_DISPLAY_ORDER_BOGATYR 44
#define JOB_DISPLAY_ORDER_ZADRUGA 45
#define JOB_DISPLAY_ORDER_AMBERGLADE 46
#define JOB_DISPLAY_ORDER_PAINTEDCITY 47
#define JOB_DISPLAY_ORDER_ENDRON 48

#define JOB_NO_MINIMUM_CHARACTER_AGE -1

/// Used when the `get_job_unavailable_error_message` proc can't make sense of a given code.
#define GENERIC_JOB_UNAVAILABLE_ERROR "Error: Unknown job availability."

// Human authority settings
// If you want to add another setting, make sure to also add it to the if chain in /datum/job_config_type/human_authority/validate_value()
#define JOB_AUTHORITY_HUMANS_ONLY "HUMANS_ONLY"
#define JOB_AUTHORITY_NON_HUMANS_ALLOWED "NON_HUMANS_ALLOWED"

// Keys for jobconfig.toml
#define JOB_CONFIG_PLAYTIME_REQUIREMENTS "Playtime Requirements"
#define JOB_CONFIG_REQUIRED_ACCOUNT_AGE "Required Account Age"
#define JOB_CONFIG_REQUIRED_CHARACTER_AGE "Required Character Age"
#define JOB_CONFIG_SPAWN_POSITIONS "Spawn Positions"
#define JOB_CONFIG_TOTAL_POSITIONS "Total Positions"
#define JOB_CONFIG_HUMAN_AUTHORITY "Human Authority Whitelist Setting"

#define DEPARTMENT_UNASSIGNED "No Department"

#define DEPARTMENT_BITFLAG_CAMARILLA (1<<0)
#define DEPARTMENT_CAMARILLA "Camarilla"

#define DEPARTMENT_BITFLAG_PRIMOGEN_COUNCIL (1<<1)
#define DEPARTMENT_PRIMOGEN_COUNCIL "Primogen Council"

#define DEPARTMENT_BITFLAG_TREMERE (1<<2)
#define DEPARTMENT_TREMERE "Tremere"

#define DEPARTMENT_BITFLAG_ANARCH (1<<3)
#define DEPARTMENT_ANARCH "Anarch"

#define DEPARTMENT_BITFLAG_GIOVANNI (1<<4)
#define DEPARTMENT_GIOVANNI "Giovanni"

#define DEPARTMENT_BITFLAG_CLAN_TZIMISCE (1<<5)
#define DEPARTMENT_CLAN_TZIMISCE "Clan Tzimisce"

#define DEPARTMENT_BITFLAG_LAW_ENFORCEMENT (1<<6)
#define DEPARTMENT_LAW_ENFORCEMENT "Law Enforcement"

#define DEPARTMENT_BITFLAG_WAREHOUSE (1<<7)
#define DEPARTMENT_WAREHOUSE "Warehouse"

#define DEPARTMENT_BITFLAG_TRIAD (1<<8)
#define DEPARTMENT_TRIAD "Triad"

DEFINE_BITFIELD(departments_bitflags, list(
	"CAMARILLA" = DEPARTMENT_BITFLAG_CAMARILLA,
	"PRIMOGEN_COUNCIL" = DEPARTMENT_BITFLAG_PRIMOGEN_COUNCIL,
	"TREMERE" = DEPARTMENT_BITFLAG_TREMERE,
	"ANARCH" = DEPARTMENT_BITFLAG_ANARCH,
	"GIOVANNI" = DEPARTMENT_BITFLAG_GIOVANNI,
	"CLAN_TZIMISCE" = DEPARTMENT_BITFLAG_CLAN_TZIMISCE,
	"LAW_ENFORCEMENT" = DEPARTMENT_BITFLAG_LAW_ENFORCEMENT,
	"WAREHOUSE" = DEPARTMENT_BITFLAG_WAREHOUSE,
	"TRIAD" = DEPARTMENT_BITFLAG_TRIAD,
))

/* Job datum job_flags */
/// Whether the mob is announced on arrival.
#define JOB_ANNOUNCE_ARRIVAL (1<<0)
/// Whether the mob is added to the crew manifest.
#define JOB_CREW_MANIFEST (1<<1)
/// Whether the mob is equipped through SSjob.equip_rank() on spawn.
#define JOB_EQUIP_RANK (1<<2)
/// Whether the job is considered a regular crew member of the station. Equipment such as AI and cyborgs not included.
#define JOB_CREW_MEMBER (1<<3)
/// Whether this job can be joined through the new_player menu.
#define JOB_NEW_PLAYER_JOINABLE (1<<4)
/// Whether this job appears in bold in the job menu.
#define JOB_BOLD_SELECT_TEXT (1<<5)
/// Reopens this position if we lose the player at roundstart.
#define JOB_REOPEN_ON_ROUNDSTART_LOSS (1<<6)
/// If the player with this job can have quirks assigned to him or not. Relevant for new player joinable jobs and roundstart antags.
#define JOB_ASSIGN_QUIRKS (1<<7)
/// Whether this job can be an intern.
#define JOB_CAN_BE_INTERN (1<<8)
/// This job cannot have more slots opened by the Head of Personnel (but admins or other random events can still do this).
#define JOB_CANNOT_OPEN_SLOTS (1<<9)
/// This job will not display on the job menu when there are no slots available, instead of appearing greyed out
#define JOB_HIDE_WHEN_EMPTY (1<<10)
/// This job cannot be signed up for at round start or recorded in your preferences
#define JOB_LATEJOIN_ONLY (1<<11)
/// This job is a head of staff.
#define JOB_HEAD_OF_STAFF (1<<12)

DEFINE_BITFIELD(job_flags, list(
	"JOB_ANNOUNCE_ARRIVAL" = JOB_ANNOUNCE_ARRIVAL,
	"JOB_CREW_MANIFEST" = JOB_CREW_MANIFEST,
	"JOB_EQUIP_RANK" = JOB_EQUIP_RANK,
	"JOB_CREW_MEMBER" = JOB_CREW_MEMBER,
	"JOB_NEW_PLAYER_JOINABLE" = JOB_NEW_PLAYER_JOINABLE,
	"JOB_BOLD_SELECT_TEXT" = JOB_BOLD_SELECT_TEXT,
	"JOB_REOPEN_ON_ROUNDSTART_LOSS" = JOB_REOPEN_ON_ROUNDSTART_LOSS,
	"JOB_ASSIGN_QUIRKS" = JOB_ASSIGN_QUIRKS,
	"JOB_CAN_BE_INTERN" = JOB_CAN_BE_INTERN,
	"JOB_CANNOT_OPEN_SLOTS" = JOB_CANNOT_OPEN_SLOTS,
	"JOB_HIDE_WHEN_EMPTY" = JOB_HIDE_WHEN_EMPTY,
	"JOB_LATEJOIN_ONLY" = JOB_LATEJOIN_ONLY,
	"JOB_HEAD_OF_STAFF" = JOB_HEAD_OF_STAFF,
))

/// Combination flag for jobs which are considered regular crew members of the station.
#define STATION_JOB_FLAGS (JOB_ANNOUNCE_ARRIVAL|JOB_CREW_MANIFEST|JOB_EQUIP_RANK|JOB_CREW_MEMBER|JOB_NEW_PLAYER_JOINABLE|JOB_REOPEN_ON_ROUNDSTART_LOSS|JOB_ASSIGN_QUIRKS|JOB_CAN_BE_INTERN)
/// Combination flag for jobs which are considered heads of staff.
#define HEAD_OF_STAFF_JOB_FLAGS (JOB_BOLD_SELECT_TEXT|JOB_CANNOT_OPEN_SLOTS|JOB_HEAD_OF_STAFF)
/// Combination flag for jobs which are enabled by station traits.
#define STATION_TRAIT_JOB_FLAGS (JOB_CANNOT_OPEN_SLOTS|JOB_HIDE_WHEN_EMPTY|JOB_LATEJOIN_ONLY&~JOB_REOPEN_ON_ROUNDSTART_LOSS)

#define FACTION_NONE "None"
#define FACTION_STATION "Station"

// Variable macros used to declare who is the supervisor for a given job, announced to the player when they join as any given job.
#define SUPERVISOR_CAPTAIN "the Captain"
#define SUPERVISOR_CE "the Chief Engineer"
#define SUPERVISOR_CMO "the Chief Medical Officer"
#define SUPERVISOR_HOP "the Head of Personnel"
#define SUPERVISOR_HOS "the Head of Security"
#define SUPERVISOR_QM "the Quartermaster"
#define SUPERVISOR_RD "the Research Director"

/// Mind traits that should be shared by every head of staff. has to be this way cause byond lists lol
#define HEAD_OF_STAFF_MIND_TRAITS TRAIT_FAST_TYING, TRAIT_HIGH_VALUE_RANSOM
