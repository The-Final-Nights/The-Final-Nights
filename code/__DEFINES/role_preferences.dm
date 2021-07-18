

//Values for antag preferences, event roles, etc. unified here



//These are synced with the Database, if you change the values of the defines
//then you MUST update the database!
#define ROLE_SYNDICATE "Syndicate"
#define ROLE_TRAITOR "Traitor"
#define ROLE_OPERATIVE "Operative"
#define ROLE_CHANGELING "Changeling"
#define ROLE_WIZARD "Wizard"
#define ROLE_MALF "Malf AI"
#define ROLE_REV "Revolutionary"
#define ROLE_REV_HEAD "Head Revolutionary"
#define ROLE_REV_SUCCESSFUL "Victorious Revolutionary"
#define ROLE_ALIEN "Xenomorph"
#define ROLE_PAI "pAI"
#define ROLE_CULTIST "Cultist"
#define ROLE_HERETIC "Heretic"
#define ROLE_BLOB "Blob"
#define ROLE_NINJA "Space Ninja"
#define ROLE_MONKEY "Monkey"
#define ROLE_MONKEY_HELMET "Monkey Mind Magnification Helmet"
#define ROLE_ABDUCTOR "Abductor"
#define ROLE_REVENANT "Revenant"
#define ROLE_BROTHER "Blood Brother"
#define ROLE_BRAINWASHED "Brainwashed Victim"
#define ROLE_OVERTHROW "Syndicate Mutineer" //Role removed, left here for safety.
#define ROLE_HIVE "Hivemind Host" //Role removed, left here for safety.
#define ROLE_OBSESSED "Obsessed"
#define ROLE_SPACE_DRAGON "Space Dragon"
#define ROLE_SENTIENCE "Sentience Potion Spawn"
#define ROLE_PYROCLASTIC_SLIME "Pyroclastic Anomaly Slime"
#define ROLE_MIND_TRANSFER "Mind Transfer Potion"
#define ROLE_POSIBRAIN "Posibrain"
#define ROLE_DRONE "Drone"
#define ROLE_DEATHSQUAD "Deathsquad"
#define ROLE_LAVALAND "Lavaland"
#define ROLE_INTERNAL_AFFAIRS "Internal Affairs Agent"
#define ROLE_FAMILIES "Familes Antagonists"

#define ROLE_POSITRONIC_BRAIN "Positronic Brain"
#define ROLE_FREE_GOLEM "Free Golem"
#define ROLE_SERVANT_GOLEM "Servant Golem"
#define ROLE_NUCLEAR_OPERATIVE "Nuclear Operative"
#define ROLE_CLOWN_OPERATIVE "Clown Operative"
#define ROLE_LONE_OPERATIVE "Lone Operative"
#define ROLE_NIGHTMARE "Nightmare"
#define ROLE_WIZARD_APPRENTICE "apprentice"
#define ROLE_SLAUGHTER_DEMON "Slaughter Demon"
#define ROLE_SENTIENT_DISEASE "Sentient Disease"
#define ROLE_MORPH "Morph"
#define ROLE_SANTA "Santa"
#define ROLE_FUGITIVE "Fugitive"

//Spawner roles
#define ROLE_GHOST_ROLE "Ghost Role"
#define ROLE_SPIDER "Spider"
#define ROLE_EXILE "Exile"
#define ROLE_FUGITIVE_HUNTER "Fugitive Hunter"
#define ROLE_ESCAPED_PRISONER "Escaped Prisoner"
#define ROLE_LIFEBRINGER "Lifebringer"
#define ROLE_ASHWALKER "Ash Walker"
#define ROLE_LAVALAND_SYNDICATE "Lavaland Syndicate"
#define ROLE_HERMIT "Hermit"
#define ROLE_BEACH_BUM "Beach Bum"
#define ROLE_HOTEL_STAFF "Hotel Staff"
#define ROLE_SPACE_SYNDICATE "Space Syndicate"
#define ROLE_SYNDICATE_CYBERSUN "Cybersun Space Syndicate" //Ghost role syndi from Forgottenship ruin
#define ROLE_SYNDICATE_CYBERSUN_CAPTAIN "Cybersun Space Syndicate Captain" //Forgottenship captain syndie
#define ROLE_HEADSLUG_CHANGELING "Headslug Changeling"
#define ROLE_SPACE_PIRATE "Space Pirate"
#define ROLE_ANCIENT_CREW "Ancient Crew"
#define ROLE_SPACE_DOCTOR "Space Doctor"
#define ROLE_SPACE_BARTENDER "Space Bartender"
#define ROLE_SPACE_BAR_PATRON "Space Bar Patron"
#define ROLE_SKELETON "Skeleton"
#define ROLE_ZOMBIE "Zombie"
#define ROLE_MAINTENANCE_DRONE "Maintenance Drone"


//Missing assignment means it's not a gamemode specific role, IT'S NOT A BUG OR ERROR.
//The gamemode specific ones are just so the gamemodes can query whether a player is old enough
//(in game days played) to play that role
GLOBAL_LIST_INIT(special_roles, list(
	ROLE_TRAITOR = /datum/game_mode/traitor,
	ROLE_BROTHER = /datum/game_mode/traitor/bros,
	ROLE_OPERATIVE = /datum/game_mode/nuclear,
	ROLE_CHANGELING = /datum/game_mode/changeling,
	ROLE_WIZARD = /datum/game_mode/wizard,
	ROLE_MALF,
	ROLE_REV = /datum/game_mode/revolution,
	ROLE_ALIEN,
	ROLE_PAI,
	ROLE_CULTIST = /datum/game_mode/cult,
	ROLE_BLOB,
	ROLE_NINJA,
	ROLE_OBSESSED,
	ROLE_SPACE_DRAGON,
	ROLE_MONKEY = /datum/game_mode/monkey,
	ROLE_REVENANT,
	ROLE_ABDUCTOR,
	ROLE_INTERNAL_AFFAIRS = /datum/game_mode/traitor/internal_affairs,
	ROLE_SENTIENCE,
	ROLE_FAMILIES = /datum/game_mode/gang,
	ROLE_HERETIC = /datum/game_mode/heretics
))

//Job defines for what happens when you fail to qualify for any job during job selection
#define BEOVERFLOW 	1
#define BERANDOMJOB 	2
#define RETURNTOLOBBY 	3
