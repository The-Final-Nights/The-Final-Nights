#define GET_ATTRIBUTE(user, attribute) (LAZYACCESS(user.character_sheet.attributes, attribute))
#define GET_SKILL(user, skill) (LAZYACCESS(user.character_sheet.skills, skill))

/// Highest level that a base attribute can be upgraded to. Bonus attributes can increase the actual amount past the limit.
#define MAX_ATTRIBUTE_SCORE 5
/// The lowest an attribute can go is 0, which usually means death.
#define MIN_ATTRIBUTE_SCORE 0
#define MAX_DICE_POOL 10
#define MIN_DICE_POOL 0
