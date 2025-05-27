
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
#define JOB_UNAVAILABLE_CHARACTER_AGE 15
#define JOB_UNAVAILABLE_VAMPIRE_AGE 16

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
#define JOB_DISPLAY_ORDER_NAGARAJA 9
#define JOB_DISPLAY_ORDER_PRINCE 10
#define JOB_DISPLAY_ORDER_SHERIFF 11
#define JOB_DISPLAY_ORDER_CLERK 12
#define JOB_DISPLAY_ORDER_HARPY 13
#define JOB_DISPLAY_ORDER_HOUND 14
#define JOB_DISPLAY_ORDER_TOWERWORK 15
#define JOB_DISPLAY_ORDER_BANUPRIM 16
#define JOB_DISPLAY_ORDER_LASOMBRAPRIM 17
#define JOB_DISPLAY_ORDER_MALKAVIAN 18
#define JOB_DISPLAY_ORDER_NOSFERATU 19
#define JOB_DISPLAY_ORDER_TOREADOR 20
#define JOB_DISPLAY_ORDER_VENTRUE 21
#define JOB_DISPLAY_ORDER_PRIEST 22
#define JOB_DISPLAY_ORDER_CLINICS_DIRECTOR 23
#define JOB_DISPLAY_ORDER_DOCTOR 24
#define JOB_DISPLAY_ORDER_GRAVEYARD 25
#define JOB_DISPLAY_ORDER_STREETJAN 26
#define JOB_DISPLAY_ORDER_STRIP 27
#define JOB_DISPLAY_ORDER_TAXI 28
#define JOB_DISPLAY_ORDER_TRIAD_GANGSTER 29
#define JOB_DISPLAY_ORDER_BARKEEPER 30
#define JOB_DISPLAY_ORDER_EMISSARY 31
#define JOB_DISPLAY_ORDER_SWEEPER 32
#define JOB_DISPLAY_ORDER_BRUISER 33
#define JOB_DISPLAY_ORDER_DEALER 34
#define JOB_DISPLAY_ORDER_SUPPLY 35
#define JOB_DISPLAY_ORDER_REGENT 36
#define JOB_DISPLAY_ORDER_ARCHIVIST 37
#define JOB_DISPLAY_ORDER_GARGOYLE 38
#define JOB_DISPLAY_ORDER_GIOVANNI 39
#define JOB_DISPLAY_ORDER_POLICE_CHIEF 40
#define JOB_DISPLAY_ORDER_POLICE 41
#define JOB_DISPLAY_ORDER_POLICE_SERGEANT 42
#define JOB_DISPLAY_ORDER_FBI 43
#define JOB_DISPLAY_ORDER_VOIVODE 44
#define JOB_DISPLAY_ORDER_BOGATYR 45
#define JOB_DISPLAY_ORDER_ZADRUGA 46
#define JOB_DISPLAY_ORDER_AMBERGLADE 47
#define JOB_DISPLAY_ORDER_PAINTEDCITY 48
#define JOB_DISPLAY_ORDER_ENDRON 49

#define DEPARTMENT_UNASSIGNED "No Department" // Shouldnt be in use, since default unassigned department is now "Citizen"

#define DEPARTMENT_BITFLAG_CAMARILLA			(1<<0)
#define DEPARTMENT_CAMARILLA					"Camarilla"

#define DEPARTMENT_BITFLAG_PRIMOGEN_COUNCIL 	(1<<1)
#define DEPARTMENT_PRIMOGEN_COUNCIL				"Primogen Council"

#define DEPARTMENT_BITFLAG_TREMERE				(1<<2)
#define DEPARTMENT_TREMERE						"Chantry"

#define DEPARTMENT_BITFLAG_GIOVANNI				(1<<3)
#define DEPARTMENT_GIOVANNI						"Giovanni"

#define DEPARTMENT_BITFLAG_CITIZEN				(1<<4)
#define DEPARTMENT_CITIZEN						"Citizen"

#define DEPARTMENT_BITFLAG_ANARCH				(1<<5)
#define DEPARTMENT_ANARCH						"Anarchs"

#define DEPARTMENT_BITFLAG_WAREHOUSE			(1<<6)
#define DEPARTMENT_WAREHOUSE					"Warehouse"

#define DEPARTMENT_BITFLAG_CLINIC				(1<<7)
#define DEPARTMENT_CLINIC						"Clinic"

#define DEPARTMENT_BITFLAG_SERVICES				(1<<8)
#define DEPARTMENT_SERVICES						"City Services"

#define DEPARTMENT_BITFLAG_CHURCH				(1<<9)
#define DEPARTMENT_CHURCH						"Church"

#define DEPARTMENT_BITFLAG_POLICE				(1<<10)
#define DEPARTMENT_POLICE						"Police"

#define DEPARTMENT_BITFLAG_NATIONAL_SECURITY	(1<<11)
#define DEPARTMENT_NATIONAL_SECURITY			"National Security"

#define DEPARTMENT_BITFLAG_TRIAD				(1<<12)
#define DEPARTMENT_TRIAD						"Triads"

#define DEPARTMENT_BITFLAG_TZIMISCE				(1<<13)
#define DEPARTMENT_TZIMISCE						"Manor"

#define DEPARTMENT_BITFLAG_ENDRON				(1<<14)
#define DEPARTMENT_ENDRON						"Endron"

#define DEPARTMENT_BITFLAG_PAINTED_CITY			(1<<15)
#define DEPARTMENT_PAINTED_CITY					"Painted City"

#define DEPARTMENT_BITFLAG_AMBERGLADE			(1<<16)
#define DEPARTMENT_AMBERGLADE					"Amberglade"

#define DEPARTMENT_BITFLAG_PRINCE				(1<<17)
#define DEPARTMENT_PRINCE						"Prince"


DEFINE_BITFIELD(departments_bitflags, list(
	"CAMARILLA" = DEPARTMENT_BITFLAG_CAMARILLA,
	"PRIMOGEN_COUNCIL" = DEPARTMENT_BITFLAG_PRIMOGEN_COUNCIL,
	"CHANTRY" = DEPARTMENT_BITFLAG_TREMERE,
	"CLINIC" = DEPARTMENT_BITFLAG_CLINIC,
	"CITIZEN" = DEPARTMENT_BITFLAG_CITIZEN,
	"PRINCE" = DEPARTMENT_BITFLAG_PRINCE,
	"WAREHOUSE" = DEPARTMENT_BITFLAG_WAREHOUSE,
	"MANOR" = DEPARTMENT_BITFLAG_MANOR,
	"GIOVANNI" = DEPARTMENT_BITFLAG_GIOVANNI,
	"POLICE" = DEPARTMENT_BITFLAG_POLICE,
	"ENDRON" = DEPARTMENT_BITFLAG_ENDRON,
	"PAINTED_CITY" = DEPARTMENT_BITFLAG_PAINTED_CITY,
	"AMBERGLADE" = DEPARTMENT_BITFLAG_AMBERGLADE,
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
