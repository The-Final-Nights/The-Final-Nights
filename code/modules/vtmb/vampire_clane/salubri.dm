/datum/vampireclane/salubri
	name = CLAN_SALUBRI
	desc = "The Salubri are one of the original 13 clans of the vampiric descendants of Caine. Salubri believe that vampiric existence is torment from which Golconda or death is the only escape. Consequently, the modern Salubri would Embrace, teach a childe the basics of the route, leave clues for the childe to follow to achieve Golconda, and then have their childe diablerize them."
	curse = "Hunted and consensual feeding."
	clane_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/fortitude,
		/datum/discipline/valeren
	)
	common_disciplines = list(/datum/discipline/valeren_warrior)
	male_clothes = /obj/item/clothing/under/vampire/salubri
	female_clothes = /obj/item/clothing/under/vampire/salubri/female
	whitelisted = TRUE
	clan_keys = /obj/item/vamp/keys/salubri

/datum/vampireclane/salubri/on_gain(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_SALUBRI_EYE, TRAIT_CLAN)


/datum/action/salubri_eye
	name = "Open or Close the Third Eye"
	desc = "Open or Close the Third Eye."
	button_icon_state = "auspex"
	button_icon = 'code/modules/wod13/UI/actions.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/actions.dmi'
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/salubri_eye/Trigger()
	if(!iskindred(owner))
		return
	var/obj/item/organ/eyes/salubri/salubri = owner.getorganslot(ORGAN_SLOT_EYES)
	if(!salubri)
		return

	if(HAS_TRAIT(owner, TRAIT_SALUBRI_EYE_OPEN))
		salubri.eye_icon_state = "eyes"
		owner.update_body()
		owner.visible_message(span_danger("[owner]'s Third Eye sinks back into their head"), span_userdanger("You close your third eye!"))
		REMOVE_TRAIT(owner, TRAIT_SALUBRI_EYE_OPEN, SALUBRI_EYE_TRAIT)
	else
		salubri.eye_icon_state = "salubri"
		owner.update_body()
		owner.visible_message(span_danger("[owner] sprouts a Third Eye on their Forehead!"), span_userdanger("Your third eye forcibly awakens!"))
		ADD_TRAIT(owner, TRAIT_SALUBRI_EYE_OPEN, SALUBRI_EYE_TRAIT)
