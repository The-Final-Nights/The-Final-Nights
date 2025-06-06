/datum/discipline_power/chi_discipline_power
	/// Name of the Discipline power
	name = "Chi Discipline power name"
	/// Description of the Discipline power
	desc = "Chi Discipline power description"

	/// CHI DISCIPLINES DO NOT COST BLOOD
	vitae_cost = 0

	///THE CHI COSTS
	var/cost_yang = 0
	var/cost_yin = 0
	var/cost_demon = 0


/* Not sure if needed but here just in case
/datum/discipline_power/chi_discipline_power/New(datum/discipline/chi_discipline/discipline)
	if(!discipline)
		CRASH("discipline_power [src.name] created without a parent discipline!")

	src.discipline = discipline
	src.owner = discipline.owner
*/

/datum/discipline_power/chi_discipline_power/can_afford()
	if (owner.yang_chi >= cost_yang)
		if (owner.yin_chi >= cost_yin)
			if (owner.demon_chi >= cost_demon)
				return TRUE


/**
 * Overridable proc handling the spending of resources (vitae/blood)
 * when casting the power. Returns TRUE if successfully spent,
 * returns FALSE otherwise.
 */
/datum/discipline_power/chi_discipline_power/spend_resources()
	if (can_afford())
		owner.yang_chi = owner.yang_chi - cost_yang
		owner.yin_chi = owner.yin_chi - cost_yin
		owner.demon_chi = owner.demon_chi - cost_demon
		owner.update_action_buttons()
		return TRUE
	else
		return FALSE

/datum/discipline_power/chi_discipline_power/refresh(atom/target)
	if (!active)
		return
	if (!owner)
		return

	//cancels if overridable proc returns FALSE
	if (!do_refresh_checks(target))
		return

	if (spend_resources())
		if(cost_yang > 0)
			to_chat(owner, span_engradio("[src] consumes your yang chi to stay active."))
		if(cost_yin > 0)
			to_chat(owner, span_medradio("[src] consumes your yin chi to stay active."))
		if(cost_demon > 0)
			to_chat(owner, span_syndradio("[src] consumes your demon chi to stay active."))
		if (!duration_override)
			do_duration(target)
	else
		to_chat(owner, span_warning("You don't have enough chi to keep [src] active!"))
		try_deactivate(target)


