/datum/vampire_clan/salubri_warrior
	name = CLAN_SALUBRI_WARRIOR
	desc = "The Salubri are one of the original 13 clans of the vampiric descendants of Caine. Salubri believe that vampiric existence is torment from which Golconda or death is the only escape. Wherein the Healer Caste of the Salubri would tend towards the sickly and dying out of mercy. The Warrior Caste are valorous defenders of the other castes and furiously slay those who cannot be saved: demon-worshipers, inhumane vampires, and those who seek to disturb the delicate symbiosis engendered by the children of Saulot."
	curse = "They must feed upon those who have been bested within a fight."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/fortitude,
		/datum/discipline/valeren_warrior
	)
	common_disciplines = list(/datum/discipline/valeren)
	male_clothes = /obj/item/clothing/under/vampire/salubri
	female_clothes = /obj/item/clothing/under/vampire/salubri/female
	whitelisted = TRUE
	clan_keys = /obj/item/vamp/keys/salubri
