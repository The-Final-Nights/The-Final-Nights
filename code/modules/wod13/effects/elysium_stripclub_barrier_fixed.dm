/obj/effect/vip_barrier/stripclub
	name = "VIP Area"
	desc = "Marks the beginning of the city's neutral zone for nonhumans. Beyond, true freaks of the night may congregate safely."
	protected_zone_id = "elysium_strip"
	social_roll_difficulty = 9


/obj/effect/vip_barrier/stripclub/check_entry_permission_custom(var/mob/living/carbon/human/entering_mob)
	// Non-human types always allowed
	if(!ishumanbasic(entering_mob))
		return TRUE

	// No mind means no entry
	if(!entering_mob.mind)
		return FALSE

	// No assigned role means no entry
	if(!entering_mob.mind.assigned_role)
		return FALSE

	// Allow specific job roles directly by checking the assigned_role string
	var/allowed_jobs = list("Club Worker", "Club Manager", "Club Bouncer", "Toreador Primogen", "Stripper")
	if(entering_mob.mind.assigned_role in allowed_jobs)
		return TRUE

	// Default deny
	return FALSE
