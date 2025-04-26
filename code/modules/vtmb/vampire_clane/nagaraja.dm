/datum/vampireclane/nagaraja
	name = CLAN_NAGARAJA
	desc = "Placeholder."
	curse = "Placeholder."
	clane_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dominate,
		/datum/discipline/necromancy
	)
	whitelisted = FALSE

/datum/vampireclane/nagaraja/on_gain(mob/living/carbon/human/H)
	. = ..()
	H.add_quirk(/datum/quirk/organovore)
