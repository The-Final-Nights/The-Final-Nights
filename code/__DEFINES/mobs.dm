/*ALL MOB-RELATED DEFINES THAT DON'T BELONG IN ANOTHER FILE GO HERE*/

//Misc mob defines

//Ready states at roundstart for mob/dead/new_player
#define PLAYER_NOT_READY 0
#define PLAYER_READY_TO_PLAY 1
#define PLAYER_READY_TO_OBSERVE 2

//Game mode list indexes
#define CURRENT_LIVING_PLAYERS	"living_players_list"
#define CURRENT_LIVING_ANTAGS	"living_antags_list"
#define CURRENT_DEAD_PLAYERS	"dead_players_list"
#define CURRENT_OBSERVERS		"current_observers_list"

//movement intent defines for the m_intent var
#define MOVE_INTENT_WALK "walk"
#define MOVE_INTENT_RUN  "run"

//Blood levels
#define BLOOD_VOLUME_MAX_LETHAL		2150
#define BLOOD_VOLUME_EXCESS			2100
#define BLOOD_VOLUME_MAXIMUM		2000
#define BLOOD_VOLUME_SLIME_SPLIT	1120
#define BLOOD_VOLUME_NORMAL			560
#define BLOOD_VOLUME_SAFE			475
#define BLOOD_VOLUME_OKAY			336
#define BLOOD_VOLUME_BAD			224
#define BLOOD_VOLUME_SURVIVE		122

//Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 0
#define MOB_SIZE_SMALL 1
#define MOB_SIZE_HUMAN 2
#define MOB_SIZE_LARGE 3
#define MOB_SIZE_HUGE 4 // Use this for things you don't want bluespace body-bagged

//Ventcrawling defines
#define VENTCRAWLER_NONE   0
#define VENTCRAWLER_NUDE   1
#define VENTCRAWLER_ALWAYS 2

//Mob bio-types flags
#define MOB_ORGANIC 	(1 << 0)
#define MOB_MINERAL		(1 << 1)
#define MOB_ROBOTIC 	(1 << 2)
#define MOB_UNDEAD		(1 << 3)
#define MOB_HUMANOID 	(1 << 4)
#define MOB_BUG 		(1 << 5)
#define MOB_BEAST		(1 << 6)
#define MOB_EPIC		(1 << 7) //megafauna
#define MOB_REPTILE		(1 << 8)
#define MOB_SPIRIT		(1 << 9)

//Organ defines for carbon mobs
#define ORGAN_ORGANIC   1
#define ORGAN_ROBOTIC   2

#define BODYPART_ORGANIC   1
#define BODYPART_ROBOTIC   2

#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/human_parts_greyscale.dmi'
#define DEFAULT_BODYPART_ICON_ROBOTIC 'icons/mob/augmentation/augments.dmi'

#define MONKEY_BODYPART "monkey"
#define ALIEN_BODYPART "alien"
#define LARVA_BODYPART "larva"
/*see __DEFINES/inventory.dm for bodypart bitflag defines*/

// Health/damage defines
#define MAX_LIVING_HEALTH 100

#define HUMAN_MAX_OXYLOSS 3
#define HUMAN_CRIT_MAX_OXYLOSS (SSmobs.wait/30)

#define STAMINA_REGEN_BLOCK_TIME (10 SECONDS)

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 3 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 20
#define BRAIN_DAMAGE_SEVERE 100
#define BRAIN_DAMAGE_DEATH 200

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special
#define BRAIN_TRAUMA_MAGIC /datum/brain_trauma/magic

#define TRAUMA_RESILIENCE_BASIC 1      //Curable with chems
#define TRAUMA_RESILIENCE_SURGERY 2    //Curable with brain surgery
#define TRAUMA_RESILIENCE_LOBOTOMY 3   //Curable with lobotomy
#define TRAUMA_RESILIENCE_WOUND 4    //Curable by healing the head wound
#define TRAUMA_RESILIENCE_MAGIC 5      //Curable only with magic
#define TRAUMA_RESILIENCE_ABSOLUTE 6   //This is here to stay

//Limit of traumas for each resilience tier
#define TRAUMA_LIMIT_BASIC 3
#define TRAUMA_LIMIT_SURGERY 2
#define TRAUMA_LIMIT_WOUND 2
#define TRAUMA_LIMIT_LOBOTOMY 3
#define TRAUMA_LIMIT_MAGIC 3
#define TRAUMA_LIMIT_ABSOLUTE INFINITY

#define BRAIN_DAMAGE_INTEGRITY_MULTIPLIER 0.5

//Surgery Defines
#define BIOWARE_GENERIC "generic"
#define BIOWARE_NERVES "nerves"
#define BIOWARE_CIRCULATION "circulation"
#define BIOWARE_LIGAMENTS "ligaments"
#define BIOWARE_CORTEX "cortex"

//Health hud screws for carbon mobs
#define SCREWYHUD_NONE 0
#define SCREWYHUD_CRIT 1
#define SCREWYHUD_DEAD 2
#define SCREWYHUD_HEALTHY 3

//Threshold levels for beauty for humans
#define BEAUTY_LEVEL_HORRID -66
#define BEAUTY_LEVEL_BAD -33
#define BEAUTY_LEVEL_DECENT 33
#define BEAUTY_LEVEL_GOOD 66
#define BEAUTY_LEVEL_GREAT 100

//Moods levels for humans
#define MOOD_LEVEL_HAPPY4 15
#define MOOD_LEVEL_HAPPY3 10
#define MOOD_LEVEL_HAPPY2 6
#define MOOD_LEVEL_HAPPY1 2
#define MOOD_LEVEL_NEUTRAL 0
#define MOOD_LEVEL_SAD1 -3
#define MOOD_LEVEL_SAD2 -7
#define MOOD_LEVEL_SAD3 -15
#define MOOD_LEVEL_SAD4 -20

//Sanity levels for humans
#define SANITY_MAXIMUM 150
#define SANITY_GREAT 125
#define SANITY_NEUTRAL 100
#define SANITY_DISTURBED 75
#define SANITY_UNSTABLE 50
#define SANITY_CRAZY 25
#define SANITY_INSANE 0

//Nutrition levels for humans
#define NUTRITION_LEVEL_FAT 600
#define NUTRITION_LEVEL_FULL 550
#define NUTRITION_LEVEL_WELL_FED 450
#define NUTRITION_LEVEL_FED 350
#define NUTRITION_LEVEL_HUNGRY 250
#define NUTRITION_LEVEL_STARVING 150

#define NUTRITION_LEVEL_START_MIN 250
#define NUTRITION_LEVEL_START_MAX 400

//Disgust levels for humans
#define DISGUST_LEVEL_MAXEDOUT 150
#define DISGUST_LEVEL_DISGUSTED 75
#define DISGUST_LEVEL_VERYGROSS 50
#define DISGUST_LEVEL_GROSS 25

//Used as an upper limit for species that continuously gain nutriment
#define NUTRITION_LEVEL_ALMOST_FULL 535

//Charge levels for Ethereals
#define ETHEREAL_CHARGE_NONE 0
#define ETHEREAL_CHARGE_LOWPOWER 400
#define ETHEREAL_CHARGE_NORMAL 1000
#define ETHEREAL_CHARGE_ALMOSTFULL 1500
#define ETHEREAL_CHARGE_FULL 2000
#define ETHEREAL_CHARGE_OVERLOAD 2500
#define ETHEREAL_CHARGE_DANGEROUS 3000

//Slime evolution threshold. Controls how fast slimes can split/grow
#define SLIME_EVOLUTION_THRESHOLD 10

//Slime extract crossing. Controls how many extracts is required to feed to a slime to core-cross.
#define SLIME_EXTRACT_CROSSING_REQUIRED 10

//Slime commands defines
#define SLIME_FRIENDSHIP_FOLLOW 			3 //Min friendship to order it to follow
#define SLIME_FRIENDSHIP_STOPEAT 			5 //Min friendship to order it to stop eating someone
#define SLIME_FRIENDSHIP_STOPEAT_NOANGRY	7 //Min friendship to order it to stop eating someone without it losing friendship
#define SLIME_FRIENDSHIP_STOPCHASE			4 //Min friendship to order it to stop chasing someone (their target)
#define SLIME_FRIENDSHIP_STOPCHASE_NOANGRY	6 //Min friendship to order it to stop chasing someone (their target) without it losing friendship
#define SLIME_FRIENDSHIP_STAY				3 //Min friendship to order it to stay
#define SLIME_FRIENDSHIP_ATTACK				8 //Min friendship to order it to attack

//Sentience types, to prevent things like sentience potions from giving bosses sentience
#define SENTIENCE_ORGANIC 1
#define SENTIENCE_ARTIFICIAL 2
// #define SENTIENCE_OTHER 3 unused
#define SENTIENCE_MINEBOT 4
#define SENTIENCE_BOSS 5

//Mob AI Status
#define POWER_RESTORATION_OFF 0
#define POWER_RESTORATION_START 1
#define POWER_RESTORATION_SEARCH_APC 2
#define POWER_RESTORATION_APC_FOUND 3

//Hostile simple animals
//If you add a new status, be sure to add a list for it to the simple_animals global in _globalvars/lists/mobs.dm
#define AI_ON		1
#define AI_IDLE		2
#define AI_OFF		3
#define AI_Z_OFF	4

//The range at which a mob should wake up if you spawn into the z level near it
#define MAX_SIMPLEMOB_WAKEUP_RANGE 5

//determines if a mob can smash through it
#define ENVIRONMENT_SMASH_NONE			0
#define ENVIRONMENT_SMASH_STRUCTURES	(1<<0) 	//crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS			(1<<1)  //walls
#define ENVIRONMENT_SMASH_RWALLS		(1<<2)	//rwalls

#define NO_SLIP_WHEN_WALKING	(1<<0)
#define SLIDE					(1<<1)
#define GALOSHES_DONT_HELP		(1<<2)
#define SLIDE_ICE				(1<<3)
#define SLIP_WHEN_CRAWLING		(1<<4) //clown planet ruin

#define MAX_CHICKENS 50

///Flags used by the flags parameter of electrocute act.

///Makes it so that the shock doesn't take gloves into account.
#define SHOCK_NOGLOVES (1 << 0)
///Used when the shock is from a tesla bolt.
#define SHOCK_TESLA (1 << 1)
///Used when an illusion shocks something. Makes the shock deal stamina damage and not trigger certain secondary effects.
#define SHOCK_ILLUSION (1 << 2)
///The shock doesn't stun.
#define SHOCK_NOSTUN (1 << 3)

#define INCORPOREAL_MOVE_BASIC 1 /// normal movement, see: [/mob/living/var/incorporeal_move]
#define INCORPOREAL_MOVE_SHADOW 2 /// leaves a trail of shadows
#define INCORPOREAL_MOVE_JAUNT 3 /// is blocked by holy water/salt

//Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED		(1<<0)
#define JUDGE_IDCHECK		(1<<1)
#define JUDGE_WEAPONCHECK	(1<<2)
#define JUDGE_RECORDCHECK	(1<<3)
//ED209's ignore monkeys
#define JUDGE_IGNOREMONKEYS	(1<<4)

#define MEGAFAUNA_DEFAULT_RECOVERY_TIME 5

#define SHADOW_SPECIES_LIGHT_THRESHOLD 0.2

// Offsets defines

#define OFFSET_UNIFORM "uniform"
#define OFFSET_ID "id"
#define OFFSET_GLOVES "gloves"
#define OFFSET_GLASSES "glasses"
#define OFFSET_EARS "ears"
#define OFFSET_SHOES "shoes"
#define OFFSET_S_STORE "s_store"
#define OFFSET_FACEMASK "mask"
#define OFFSET_HEAD "head"
#define OFFSET_FACE "face"
#define OFFSET_BELT "belt"
#define OFFSET_BACK "back"
#define OFFSET_SUIT "suit"
#define OFFSET_NECK "neck"

//MINOR TWEAKS/MISC
#define AGE_MIN				21	//youngest a character can be, DO NOT LOWER THIS
#define AGE_MAX				122	//oldest a character can be
#define AGE_MINOR			20  //legal age of space drinking and smoking
#define WIZARD_AGE_MIN		30	//youngest a wizard can be
#define APPRENTICE_AGE_MIN	29	//youngest an apprentice can be
#define SHOES_SLOWDOWN		0	//How much shoes slow you down by default. Negative values speed you up
#define SHOES_SPEED_SLIGHT  SHOES_SLOWDOWN - 1 // slightest speed boost to movement
#define POCKET_STRIP_DELAY			40	//time taken (in deciseconds) to search somebody's pockets
#define DOOR_CRUSH_DAMAGE	15	//the amount of damage that airlocks deal when they crush you

#define	HUNGER_FACTOR		0.1	//factor at which mob nutrition decreases
#define	ETHEREAL_CHARGE_FACTOR	1.6 //factor at which ethereal's charge decreases
#define	REAGENTS_METABOLISM 0.4	//How many units of reagent are consumed per tick, by default.
#define REAGENTS_EFFECT_MULTIPLIER (REAGENTS_METABOLISM / 0.4)	// By defining the effect multiplier this way, it'll exactly adjust all effects according to how they originally were with the 0.4 metabolism

// Eye protection
#define FLASH_PROTECTION_SENSITIVE -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_FLASH 1
#define FLASH_PROTECTION_WELDER 2

// Roundstart trait system

#define MAX_QUIRKS 6 //The maximum amount of quirks one character can have at roundstart

//Medical Categories for quirks
#define CAT_QUIRK_ALL 0
#define CAT_QUIRK_NOTES 1
#define CAT_QUIRK_MINOR_DISABILITY 2
#define CAT_QUIRK_MAJOR_DISABILITY 3

// AI Toggles
#define AI_CAMERA_LUMINOSITY	5
#define AI_VOX // Comment out if you don't want VOX to be enabled and have players download the voice sounds.

// /obj/item/bodypart on_mob_life() retval flag
#define BODYPART_LIFE_UPDATE_HEALTH (1<<0)

#define MAX_REVIVE_FIRE_DAMAGE 180
#define MAX_REVIVE_BRUTE_DAMAGE 180

#define HUMAN_FIRE_STACK_ICON_NUM	3

#define GRAB_PIXEL_SHIFT_PASSIVE 6
#define GRAB_PIXEL_SHIFT_AGGRESSIVE 12
#define GRAB_PIXEL_SHIFT_NECK 16

#define PULL_PRONE_SLOWDOWN 1.5
#define HUMAN_CARRY_SLOWDOWN 0.35

//Flags that control what things can spawn species (whitelist)
//Badmin magic mirror
#define MIRROR_BADMIN (1<<0)
//Standard magic mirror (wizard)
#define MIRROR_MAGIC  (1<<1)
//Pride ruin mirror
#define MIRROR_PRIDE  (1<<2)
//Race swap wizard event
#define RACE_SWAP     (1<<3)
//ERT spawn template (avoid races that don't function without correct gear)
#define ERT_SPAWN     (1<<4)
//xenobio black crossbreed
#define SLIME_EXTRACT (1<<5)
//Wabbacjack staff projectiles
#define WABBAJACK     (1<<6)

// Reasons a defibrilation might fail
#define DEFIB_POSSIBLE (1<<0)
#define DEFIB_FAIL_SUICIDE (1<<1)
#define DEFIB_FAIL_HUSK (1<<2)
#define DEFIB_FAIL_TISSUE_DAMAGE (1<<3)
#define DEFIB_FAIL_FAILING_HEART (1<<4)
#define DEFIB_FAIL_NO_HEART (1<<5)
#define DEFIB_FAIL_FAILING_BRAIN (1<<6)
#define DEFIB_FAIL_NO_BRAIN (1<<7)
#define DEFIB_FAIL_NO_INTELLIGENCE (1<<8)

// Bit mask of possible return values by can_defib that would result in a revivable patient
#define DEFIB_REVIVABLE_STATES (DEFIB_FAIL_NO_HEART | DEFIB_FAIL_FAILING_HEART | DEFIB_FAIL_HUSK | DEFIB_FAIL_TISSUE_DAMAGE | DEFIB_FAIL_FAILING_BRAIN | DEFIB_POSSIBLE)

#define SLEEP_CHECK_DEATH(X) sleep(X); if(QDELETED(src) || stat == DEAD) return;

#define DOING_INTERACTION(user, interaction_key) (LAZYACCESS(user.do_afters, interaction_key))
#define DOING_INTERACTION_LIMIT(user, interaction_key, max_interaction_count) ((LAZYACCESS(user.do_afters, interaction_key) || 0) >= max_interaction_count)
#define DOING_INTERACTION_WITH_TARGET(user, target) (LAZYACCESS(user.do_afters, target))
#define DOING_INTERACTION_WITH_TARGET_LIMIT(user, target, max_interaction_count) ((LAZYACCESS(user.do_afters, target) || 0) >= max_interaction_count)

// recent examine defines
/// How long it takes for an examined atom to be removed from recent_examines. Should be the max of the below time windows
#define RECENT_EXAMINE_MAX_WINDOW (2 SECONDS)
/// If you examine the same atom twice in this timeframe, we call examine_more() instead of examine()
#define EXAMINE_MORE_TIME (1 SECONDS)
/// How far away you can be to make eye contact with someone while examining
#define EYE_CONTACT_RANGE	5

#define SILENCE_RANGED_MESSAGE (1<<0)

///Swarmer flags
#define SWARMER_LIGHT_ON (1<<0)

/// Returns whether or not the given mob can succumb
#define CAN_SUCCUMB(target) ((HAS_TRAIT(target, TRAIT_CRITICAL_CONDITION) || HAS_TRAIT(target, TRAIT_TORPOR)) && !HAS_TRAIT(target, TRAIT_NODEATH))

// Body position defines.
/// Mob is standing up, usually associated with lying_angle value of 0.
#define STANDING_UP 0
/// Mob is lying down, usually associated with lying_angle values of 90 or 270.
#define LYING_DOWN 1

///How much a mob's sprite should be moved when they're lying down
#define PIXEL_Y_OFFSET_LYING -6

///Define for spawning megafauna instead of a mob for cave gen
#define SPAWN_MEGAFAUNA "bluh bluh huge boss"

///Squash flags. For squashable element

/// Squashing will not occur if the mob is not lying down (bodyposition is LYING_DOWN)
#define SQUASHED_SHOULD_BE_DOWN (1<<0)
/// If present, outright gibs the squashed mob instead of just dealing damage
#define SQUASHED_SHOULD_BE_GIBBED (1<<1)
/// If squashing always passes if the mob is dead
#define SQUASHED_ALWAYS_IF_DEAD (1<<2)
/// Don't squash our mob if its not located in a turf
#define SQUASHED_DONT_SQUASH_IN_CONTENTS (1<<3)

/*
 * Defines for "AI emotions", allowing the AI to expression emotions
 * with status displays via emotes.
 */

#define AI_EMOTION_VERY_HAPPY "Very Happy"
#define AI_EMOTION_HAPPY "Happy"
#define AI_EMOTION_NEUTRAL "Neutral"
#define AI_EMOTION_UNSURE "Unsure"
#define AI_EMOTION_CONFUSED "Confused"
#define AI_EMOTION_SAD "Sad"
#define AI_EMOTION_BSOD "BSOD"
#define AI_EMOTION_BLANK "Blank"
#define AI_EMOTION_PROBLEMS "Problems?"
#define AI_EMOTION_AWESOME "Awesome"
#define AI_EMOTION_FACEPALM "Facepalm"
#define AI_EMOTION_THINKING "Thinking"
#define AI_EMOTION_FRIEND_COMPUTER "Friend Computer"
#define AI_EMOTION_DORFY "Dorfy"
#define AI_EMOTION_BLUE_GLOW "Blue Glow"
#define AI_EMOTION_RED_GLOW "Red Glow"

/// Throw modes, defines whether or not to turn off throw mode after
#define THROW_MODE_DISABLED 0
#define THROW_MODE_TOGGLE 1
#define THROW_MODE_HOLD 2

#define SOUL_PRESENT (1 << 0)
#define SOUL_ABSENT (1 << 1)
#define SOUL_PROJECTING ( 1<< 2)

// Height defines
// - They are numbers so you can compare height values (x height < y height)
// - They do not start at 0 for futureproofing
// - They skip numbers for futureproofing as well
// Otherwise they are completely arbitrary
#define HUMAN_HEIGHT_DWARF 2
#define HUMAN_HEIGHT_SHORTEST 4
#define HUMAN_HEIGHT_SHORT 6
#define HUMAN_HEIGHT_MEDIUM 8
#define HUMAN_HEIGHT_TALL 10
#define HUMAN_HEIGHT_TALLEST 12

/// Assoc list of all heights, cast to strings, to """"tuples"""""
/// The first """tuple""" index is the upper body offset
/// The second """tuple""" index is the lower body offset
GLOBAL_LIST_INIT(human_heights_to_offsets, list(
	"[HUMAN_HEIGHT_DWARF]" = list(-5, -4),
	"[HUMAN_HEIGHT_SHORTEST]" = list(-2, -1),
	"[HUMAN_HEIGHT_SHORT]" = list(-1, -1),
	"[HUMAN_HEIGHT_MEDIUM]" = list(0, 0),
	"[HUMAN_HEIGHT_TALL]" = list(1, 1),
	"[HUMAN_HEIGHT_TALLEST]" = list(2, 2),
))


// Mob Overlays Indexes
/// Total number of layers for mob overlays
/// KEEP THIS UP-TO-DATE OR SHIT WILL BREAK
/// Also consider updating layers_to_offset
#define TOTAL_LAYERS 50
#define LUZHA_LAYER 50
#define UNDERSHADOW_LAYER 49
/// Mutations layer - Tk headglows, cold resistance glow, etc
#define MUTATIONS_LAYER 48
/// Mutantrace features (tail when looking south) that must appear behind the body parts
#define BODY_BEHIND_LAYER 47
/// Layer for bodyparts that should appear behind every other bodypart - Mostly, legs when facing WEST or EAST
#define BODYPARTS_LOW_LAYER 46
/// Layer for most bodyparts, appears above BODYPARTS_LOW_LAYER and below BODYPARTS_HIGH_LAYER
#define BODYPARTS_LAYER 45
/// Mutantrace features (snout, body markings) that must appear above the body parts
#define BODY_ADJ_LAYER 44
/// Underwear, undershirts, socks, eyes, lips(makeup)
#define BODY_LAYER 43
/// Mutations that should appear above body, body_adj and bodyparts layer (e.g. laser eyes)
#define FRONT_MUTATIONS_LAYER 42
/// Damage indicators (cuts and burns)
#define DAMAGE_LAYER 41
/// Jumpsuit clothing layer
#define UNIFORM_LAYER 40
/// ID card layer
#define ID_LAYER 39
/// ID card layer (might be deprecated)
#define ID_CARD_LAYER 38
/// Layer for bodyparts that should appear above every other bodypart - Currently only used for hands
#define BODYPARTS_HIGH_LAYER 37
/// Gloves layer
#define GLOVES_LAYER 36
/// Shoes layer
#define SHOES_LAYER 35
/// Layer for masks that are worn below ears and eyes (like Balaclavas) (layers below hair, use flagsinv=HIDEHAIR as needed)
#define LOW_FACEMASK_LAYER 34
//For WoD-specific clanmarks etc
#define MARKS_LAYER	33
/// Ears layer (Spessmen have ears? Wow)
#define EARS_LAYER 32
/// Layer for neck apperal that should appear below the suit slot (like neckties)
#define LOW_NECK_LAYER 31
/// Suit layer (armor, coats, etc.)
#define SUIT_LAYER 30
/// Glasses layer
#define GLASSES_LAYER 29
/// Belt layer
#define BELT_LAYER 28 //Possible make this an overlay of something required to wear a belt?
/// Suit storage layer (tucking a gun or baton underneath your armor)
#define SUIT_STORE_LAYER 27
/// Neck layer (for wearing capes and bedsheets)
#define NECK_LAYER 26
/// Back layer (for backpacks and equipment on your back)
#define BACK_LAYER 25
/// Hair layer (mess with the fro and you got to go!)
#define HAIR_LAYER 24 //TODO: make part of head layer?
#define UPPER_EARS_LAYER 23
/// Facemask layer (gas masks, breath masks, etc.)
#define FACEMASK_LAYER 22
/// Head layer (hats, helmets, etc.)
#define HEAD_LAYER 21
/// Hair that layers out above clothing, including hats (high ponytails and such)
#define OUTER_HAIR_LAYER 20
/// Handcuff layer (when your hands are cuffed)
#define HANDCUFF_LAYER 19
/// Legcuff layer (when your feet are cuffed)
#define LEGCUFF_LAYER 18
/// Hands layer (for the actual hand, not the arm... I think?)
#define HANDS_LAYER 17
/// Body front layer. Usually used for mutant bodyparts that need to be in front of stuff (e.g. cat ears)
#define BODY_FRONT_LAYER 16
/// Special body layer that actually require to be above the hair (e.g. lifted welding goggles)
#define ABOVE_BODY_FRONT_GLASSES_LAYER 15
/// Special body layer for the rare cases where something on the head needs to be above everything else (e.g. flowers)
#define ABOVE_BODY_FRONT_HEAD_LAYER 14
#define DECAPITATION_BLOOD_LAYER 13
#define PROTEAN_LAYER 12
#define UNICORN_LAYER 11
#define POTENCE_LAYER 10
#define FORTITUDE_LAYER 9
#define FIRING_EFFECT_LAYER	8
//If you're on fire
#define FIRE_LAYER 7
#define BITE_LAYER 6
#define FIGHT_LAYER 5
#define SAY_LAYER 4
/// Bleeding wound icons
#define WOUND_LAYER 3
/// Blood cult ascended halo layer, because there's currently no better solution for adding/removing
#define HALO_LAYER 2
/// The highest most layer for mob overlays. Unused
#define HIGHEST_LAYER 1

#define UPPER_BODY "upper body"
#define LOWER_BODY "lower body"
#define NO_MODIFY "do not modify"

/// Used for human height overlay adjustments
/// Certain standing overlay layers shouldn't have a filter applied and should instead just offset by a pixel y
/// This list contains all the layers that must offset, with its value being whether it's a part of the upper half of the body (TRUE) or not (FALSE)
GLOBAL_LIST_INIT(layers_to_offset, list(
	// Weapons commonly cross the middle of the sprite so they get cut in half by the filter
	"[HANDS_LAYER]" = LOWER_BODY,
	// Very tall hats will get cut off by filter
	"[HEAD_LAYER]" = UPPER_BODY,
	// Hair will get cut off by filter
	"[HAIR_LAYER]" = UPPER_BODY,
	// Long belts (sabre sheathe) will get cut off by filter
	"[BELT_LAYER]" = LOWER_BODY,
	// Everything below looks fine with or without a filter, so we can skip it and just offset
	// (In practice they'd be fine if they got a filter but we can optimize a bit by not.)
	"[NECK_LAYER]" = UPPER_BODY,
	"[GLASSES_LAYER]" = UPPER_BODY,
	"[LOW_NECK_LAYER]" = UPPER_BODY,
	"[ABOVE_BODY_FRONT_GLASSES_LAYER]" = UPPER_BODY, // currently unused
	"[ABOVE_BODY_FRONT_HEAD_LAYER]" = UPPER_BODY, // only used for head stuff
	"[GLOVES_LAYER]" = LOWER_BODY,
	"[HALO_LAYER]" = UPPER_BODY, // above the head
	"[HANDCUFF_LAYER]" = LOWER_BODY,
	"[ID_CARD_LAYER]" = UPPER_BODY, // unused
	"[ID_LAYER]" = UPPER_BODY,
	"[FACEMASK_LAYER]" = UPPER_BODY,
	"[LOW_FACEMASK_LAYER]" = UPPER_BODY,
	// These two are cached, and have their appearance shared(?), so it's safer to just not touch it
	"[MUTATIONS_LAYER]" = NO_MODIFY,
	"[FRONT_MUTATIONS_LAYER]" = NO_MODIFY,
	// These DO get a filter, I'm leaving them here as reference,
	// to show how many filters are added at a glance
	// BACK_LAYER (backpacks are big)
	// BODYPARTS_HIGH_LAYER (arms)
	// BODY_LAYER (body markings (full body), underwear (full body), eyes)
	// BODY_ADJ_LAYER (external organs like wings)
	// BODY_BEHIND_LAYER (external organs like wings)
	// BODY_FRONT_LAYER (external organs like wings)
	// DAMAGE_LAYER (full body)
	// HIGHEST_LAYER (full body)
	// UNIFORM_LAYER (full body)
	// WOUND_LAYER (full body)
))
