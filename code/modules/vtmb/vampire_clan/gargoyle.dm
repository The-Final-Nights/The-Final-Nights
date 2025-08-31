/datum/vampire_clan/gargoyle
	name = CLAN_GARGOYLE
	desc = "The Gargoyles are a vampiric bloodline created by the Tremere as their servitors. Although technically not a Tremere bloodline, the bloodline is largely under their control. In the Final Nights, Gargoyle populations seem to be booming; this is largely because older, free Gargoyles are coming out of hiding to join the Camarilla, because more indentured Gargoyles break free from the clutches of the Tremere, and because the free Gargoyles have also begun to Embrace more mortals on their own."
	curse = "All Gargoyles, much like the Nosferatu, are hideous to look at, a byproduct of their occult origins (and the varied Kindred stock from which they originate). This means that Gargoyles, just like the Nosferatu, have to hide their existence from common mortals, as their mere appearance is a breach of the Masquerade. In addition, the nature of the bloodline's origin manifests itself in the fact that Gargoyles are highly susceptible to mind control of any source. This weakness is intentional; a flaw placed into all Gargoyles by the Tremere in the hope that it would make them easier to control (and less likely to rebel)."
	clan_disciplines = list(
		/datum/discipline/fortitude,
		/datum/discipline/potence,
		/datum/discipline/visceratika
	)
	clan_traits = list(
		TRAIT_CANNOT_RESIST_MIND_CONTROL,
		TRAIT_MASQUERADE_VIOLATING_FACE
	)
	alt_sprite = "gargoyle"
	no_facial = FALSE
	male_clothes = /obj/item/clothing/under/vampire/malkavian
	female_clothes = /obj/item/clothing/under/vampire/malkavian
	default_accessory = "gargoyle_full"
	accessories = list("gargoyle_full", "gargoyle_left", "gargoyle_right", "gargoyle_broken", "gargoyle_round", "gargoyle_devil", "gargoyle_oni", "none")
	accessories_layers = list("gargoyle_full" = UNICORN_LAYER, "gargoyle_left" = UNICORN_LAYER, "gargoyle_right" = UNICORN_LAYER, "gargoyle_broken" = UNICORN_LAYER, "gargoyle_round" = UNICORN_LAYER, "gargoyle_devil" = UNICORN_LAYER, "gargoyle_oni" = UNICORN_LAYER, "none" = UNICORN_LAYER)
	//note for future gargoyle accessories - digitigrade legs toggle is currently using MARKS_LAYER, consult preferences.dm if you wish to add gargoyle accessories to this layer (and rework digitigrade legs)
	whitelisted = FALSE

/datum/vampire_clan/gargoyle/on_gain(mob/living/carbon/human/gargoyle)
	..()
	gargoyle.dna.species.wings_icon = "Gargoyle"
	gargoyle.physiology.brute_mod = 0.8
	gargoyle.dna.species.GiveSpeciesFlight(gargoyle)
	var/datum/action/gargoyle_statue_form/statue_action = new()
	statue_action.Grant(gargoyle)

/datum/vampire_clan/gargoyle/on_join_round(mob/living/carbon/human/H)
	. = ..()

	if(H.mind?.assigned_role == "Chantry Gargoyle") // Chantry Gargoyles spawn with unique robes/mask
		return

	var/obj/item/clothing/suit/hooded/robes/grey/new_robe = new(H.loc)
	H.equip_to_appropriate_slot(new_robe, FALSE)

	var/obj/item/clothing/mask/vampire/balaclava/balaclava = new(H.loc)
	H.equip_to_appropriate_slot(balaclava, FALSE)


// Gargoyle Statue Form
/datum/action/gargoyle_statue_form
	name = "Statue Form"
	desc = "Transform into a stone statue, becoming immobilized and mute but taking on the appearance of stone."
	button_icon_state = "gargoyle"
	var/active = FALSE
	var/original_color

/datum/action/gargoyle_statue_form/Trigger(trigger_flags)
	if(!owner || !isliving(owner))
		return

	if(active)
		deactivate_statue()
	else
		activate_statue()

/datum/action/gargoyle_statue_form/proc/activate_statue()
	if(!owner || active)
		return

	var/mob/living/carbon/human/living_owner = owner
	active = TRUE
	ADD_TRAIT(living_owner, TRAIT_IMMOBILIZED, "GARGOYLE_STATUE")
	ADD_TRAIT(living_owner, TRAIT_MUTE, "GARGOYLE_STATUE")
	REMOVE_TRAIT(living_owner, TRAIT_MASQUERADE_VIOLATING_FACE, "clan")
	REMOVE_TRAIT(living_owner, TRAIT_MASQUERADE_VIOLATING_FACE, "Gargoyle")
	living_owner.name_override = "Statue of [living_owner.real_name]"
	var/newcolor = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	living_owner.add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)

	// Update button name and description
	name = "Revert Form"
	desc = "Return to your normal form."

	to_chat(owner, span_notice("You transform into a stone statue, becoming immobile and silent."))

/datum/action/gargoyle_statue_form/proc/deactivate_statue()
	if(!owner || !active)
		return

	var/mob/living/carbon/human/living_owner = owner
	active = FALSE

	REMOVE_TRAIT(living_owner, TRAIT_IMMOBILIZED, "GARGOYLE_STATUE")
	REMOVE_TRAIT(living_owner, TRAIT_MUTE, "GARGOYLE_STATUE")
	ADD_TRAIT(living_owner, TRAIT_MASQUERADE_VIOLATING_FACE, "clan")
	ADD_TRAIT(living_owner, TRAIT_MASQUERADE_VIOLATING_FACE, "Gargoyle")
	living_owner.name_override = null
	living_owner.remove_atom_colour(FIXED_COLOUR_PRIORITY)

	// Update button name and description
	name = "Statue Form"
	desc = "Transform into a stone statue, becoming immobilized and mute but taking on the appearance of stone."

	to_chat(owner, span_notice("You return to your normal form."))

/datum/action/gargoyle_statue_form/Remove(mob/remove_from)
	if(active)
		deactivate_statue()
	return ..()
