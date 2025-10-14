//Function for updating a player's health based on their current stats.
//Player gets an increase to HP when there are buffs to their stamina.
/mob/living/proc/recalculate_max_health(var/initial = FALSE)
	var/old_max_health = maxHealth
	maxHealth = round(initial(maxHealth) + (20 * st_get_stat(STAT_STAMINA)))
	if(initial)
		health = maxHealth
	else if(health > 0)
		health = max(health + maxHealth - old_max_health, 1)
