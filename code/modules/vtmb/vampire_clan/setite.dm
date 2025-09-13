/datum/vampire_clan/setite
	name = CLAN_SETITES
	desc = "The Followers of Set, or Setites, are a clan of vampires who believe their founder was the Egyptian god Set."
	curse = "Extra damage from fire, sensitivity to very bright lights."
	clan_disciplines = list(
		/datum/discipline/obfuscate,
		/datum/discipline/presence,
		/datum/discipline/serpentis
	)
	male_clothes = /obj/item/clothing/under/vampire/slickback
	female_clothes = /obj/item/clothing/under/vampire/burlesque
	clan_keys = /obj/item/vamp/keys/setite

/datum/vampire_clan/setite/on_gain(mob/living/carbon/human/H)
	. = ..()
	H.physiology.burn_mod = 1.5 // Setites take extra damage from sunlight, so burn mod is a better flaw than the shitty fear of light quirk
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
