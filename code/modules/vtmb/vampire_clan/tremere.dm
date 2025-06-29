/datum/vampire_clan/tremere
	name = CLAN_TREMERE
	desc = "The arcane Clan Tremere were once a house of mortal mages who sought immortality but found only undeath. As vampires, they’ve perfected ways to bend their own Blood to their will, employing their sorceries to master and ensorcel both the mortal and vampire world. Their power makes them valuable, but few vampires trust their scheming ways."
	curse = "Deficient vitae results in the Tremere being unable to blood-bond other Kindred. Their ability to bond Kine, however, is unaffected."
	clan_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/dominate,
		/datum/discipline/thaumaturgy
	)
	male_clothes = /obj/item/clothing/under/vampire/tremere
	female_clothes = /obj/item/clothing/under/vampire/tremere/female

/datum/vampire_clan/tremere/on_gain(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_DEFICIENT_VITAE, ROUNDSTART_TRAIT)
