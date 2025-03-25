// This is the new signals file for every signal vampire related in WOD13
// New signals related to vampires and things vampires do should be defined here

///called in bloodsucking.dm at the end of /mob/living/carbon/human/proc/drinksomeblood
#define COMSIG_MOB_VAMPIRE_SUCKED "mob_vampire_sucked"
	///vampire suck resisted
	#define COMPONENT_RESIST_VAMPIRE_KISS (1<<0)

///called when a vampire attempts to drink blood from a target
#define COMSIG_MOB_DRINK_BLOOD "mob_drink_blood"
	///vampire drink resisted
	#define COMPONENT_RESIST_BLOOD_DRINK (1<<0)

#define COMSIG_MOB_DEATH "mob_death"
#define COMSIG_MOB_LOGOUT "mob_logout"
