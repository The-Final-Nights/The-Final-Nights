/datum/discipline/chi_discipline
	/* CUSTOMIZABLE */
	///Name of this Discipline.
	name = "Chi Discipline name"
	///Text description of this Discipline.
	desc = "Chi Discipline description"
	///If this Discipline is unique to a certain Clan.
	clan_restricted = FALSE
	///Chi Disciplines are for KJ Only!!
	var/kueijin_restricted = TRUE
	///The root type of the powers this Discipline uses.
	power_type = /datum/discipline_power/chi_discipline_power
	///If this Discipline can be selected at all, or has special handling.
	selectable = TRUE

	/* BACKEND */
	///What rank, or how many dots the caster has in this Discipline.
	level = 1
	///What rank of this Discipline is currently being casted.
	level_casting = 1

	///Stuff for knowing shizzle
	var/cost_yang = 0
	var/cost_yin = 0
	var/cost_demon = 0
	var/discipline_type = "Shintai" //OTIONS ARE Shintai, Chi, and Demon (CASE SENSITIVE)
