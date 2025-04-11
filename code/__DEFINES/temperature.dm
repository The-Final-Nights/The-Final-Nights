/// -270.3degC
#define TCMB					2.7
/// -48.15degC
#define TCRYO					225
/// 0degC
#define T0C						273.15
/// 20degC
#define T20C					293.15
/// -14C - Temperature used for kitchen cold room, medical freezer, etc.
#define COLD_ROOM_TEMP			259.15

/// This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define TEMPERATURE_DAMAGE_COEFFICIENT		1.5

#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD	(150+T0C)
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST	(100+T0C)
#define FIRE_SPREAD_RADIOSITY_SCALE			0.85
#define FIRE_GROWTH_RATE					40000	//For small fires

/// Humans are slowed by the difference between bodytemp and BODYTEMP_COLD_DAMAGE_LIMIT divided by this
#define COLD_SLOWDOWN_FACTOR				20

/// The natural temperature for a body
#define BODYTEMP_NORMAL						310.15
/// This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_DIVISOR		14
/// Minimum amount of kelvin moved toward 310K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_AUTORECOVERY_MINIMUM		6
///Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_COLD_DIVISOR				15
/// Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR				15
/// The maximum number of degrees that your body can cool in 1 tick, due to the environment, when in a cold area.
#define BODYTEMP_COOLING_MAX				-30
/// The maximum number of degrees that your body can heat up in 1 tick, due to the environment, when in a hot area.
#define BODYTEMP_HEATING_MAX				30
/// The body temperature limit the human body can take before it starts taking damage from heat.
/// This also affects how fast the body normalises it's temperature when hot.
/// 340k is about 66c, and rather high for a human.
#define BODYTEMP_HEAT_DAMAGE_LIMIT			(BODYTEMP_NORMAL + 30)
/// The body temperature limit the human body can take before it starts taking damage from cold.
/// This also affects how fast the body normalises it's temperature when cold.
/// 270k is about -3c, that is below freezing and would hurt over time.
#define BODYTEMP_COLD_DAMAGE_LIMIT			(BODYTEMP_NORMAL - 40)
/// The body temperature limit the human body can take before it will take wound damage.
#define BODYTEMP_HEAT_WOUND_LIMIT			(BODYTEMP_NORMAL + 90) // 400.5 k
/// The modifier on cold damage limit hulks get ontop of their regular limit
#define BODYTEMP_HULK_COLD_DAMAGE_LIMIT_MODIFIER 25
/// The modifier on cold damage hulks get.
#define HULK_COLD_DAMAGE_MOD 2

/// what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_HELM_MIN_TEMP_PROTECT			2.0
/// Thermal insulation works both ways /Malkevin
#define SPACE_HELM_MAX_TEMP_PROTECT			1500
/// what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define SPACE_SUIT_MIN_TEMP_PROTECT			2.0
/// The min cold protection of a space suit without the heater active
#define SPACE_SUIT_MIN_TEMP_PROTECT_OFF		72
#define SPACE_SUIT_MAX_TEMP_PROTECT			1500

/// Cold protection for firesuits
#define FIRE_SUIT_MIN_TEMP_PROTECT			60
/// what max_heat_protection_temperature is set to for firesuit quality suits. MUST NOT BE 0.
#define FIRE_SUIT_MAX_TEMP_PROTECT			30000
/// Cold protection for fire helmets
#define FIRE_HELM_MIN_TEMP_PROTECT			60
/// for fire helmet quality items (red and white hardhats)
#define FIRE_HELM_MAX_TEMP_PROTECT			30000

/// what max_heat_protection_temperature is set to for firesuit quality suits and helmets. MUST NOT BE 0.
#define FIRE_IMMUNITY_MAX_TEMP_PROTECT	35000

/// For normal helmets
#define HELMET_MIN_TEMP_PROTECT				160
/// For normal helmets
#define HELMET_MAX_TEMP_PROTECT				600
/// For armor
#define ARMOR_MIN_TEMP_PROTECT				160
/// For armor
#define ARMOR_MAX_TEMP_PROTECT				600

/// For some gloves (black and)
#define GLOVES_MIN_TEMP_PROTECT				2.0
/// For some gloves
#define GLOVES_MAX_TEMP_PROTECT				1500
/// For gloves
#define SHOES_MIN_TEMP_PROTECT				2.0
/// For gloves
#define SHOES_MAX_TEMP_PROTECT				1500
