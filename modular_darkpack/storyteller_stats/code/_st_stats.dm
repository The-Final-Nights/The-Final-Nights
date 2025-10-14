
/datum/st_stat
	var/name = ""
	var/description = ""
	var/score = 0
	var/bonus_score = 0
	//The minimum score this stat can be.
	var/min_score = 0
	//The maximum score this stat can be.
	var/max_score = 5

	//determines the base type for this class, so we don't add in empty types
	var/base_type = /datum/st_stat

	//if a stat affects the hp pool, recalculate the hp of the mob when changed.
	var/affects_health_pool = FALSE

	//if a stat affects the willpower pool, recalculate the hp of the mob when changed.
	var/affects_willpower = FALSE

	//If a stat affects the player's speed, such as dexterity.
	var/affects_speed = FALSE

	/// A dictionary of modifiers to this attribute.
	var/list/modifiers = list()

	//What score does this stat start out with at character creation.
	var/starting_score = 0

	//How many points this stat category the player can use to upgrade the stats in this category.
	var/points = 0

	//At what score amount further upgrades require freebie point expendature to level up.
	var/max_level_before_freebie_points = 5

	//If the preferences menu should count the bonus score as a normal score, used for things like willpower.
	var/count_bonus_score = FALSE

/datum/st_stat/proc/get_score(include_bonus = TRUE)
	if(include_bonus)
		return score + bonus_score
	else
		return score

/datum/st_stat/proc/set_score(amount)
	var/temp_score = score
	score = clamp(amount, min_score, max_score)
	if(temp_score == score)
		return FALSE
	return TRUE

/datum/st_stat/proc/increase_score(amount)
	var/temp_score = score
	score = score + amount
	score = clamp(score, min_score, max_score)
	if(score == temp_score)
		return FALSE
	return TRUE

/datum/st_stat/proc/decrease_score(amount)
	var/temp_score = score
	score = score - amount
	score = clamp(score, min_score, max_score)
	if(score == temp_score)
		return FALSE
	return TRUE

/datum/st_stat/proc/update_modifiers()
	SHOULD_NOT_OVERRIDE(TRUE)
	bonus_score = initial(bonus_score)
	for(var/source in modifiers)
		bonus_score += modifiers[source]
	bonus_score = clamp(bonus_score, 0, 10)
