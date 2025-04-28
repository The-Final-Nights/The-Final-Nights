//Defines for dynamic mode and rulesets that are called by other files. Migrated here from dynamic.dm due to use outside local.
#define ONLY_RULESET       1
#define HIGHLANDER_RULESET 2
#define TRAITOR_RULESET    4
#define MINOR_RULESET      8

#define RULESET_STOP_PROCESSING 1

//Migrated from dynamic_rulesets.dm for same reason as above
#define EXTRA_RULESET_PENALTY 20	// Changes how likely a gamemode is to scale based on how many other roundstart rulesets are waiting to be rolled.
#define POP_SCALING_PENALTY 50		// Discourages scaling up rulesets if ratio of antags to crew is high.

#define REVOLUTION_VICTORY 1
#define STATION_VICTORY 2
