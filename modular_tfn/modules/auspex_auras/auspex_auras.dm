/mob/living/carbon/Initialize()
	. = ..()
	var/datum/atom_hud/abductor/hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	hud.add_to_hud(src)

/mob/living/carbon/proc/update_auspex_hud()
	var/image/holder = hud_list[GLAND_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "aura"

	if(client)
		if(a_intent == INTENT_HARM)
			holder.color = AURA_MORTAL_HOSTILE
		else
			holder.color = AURA_MORTAL
	else if(isnpc(src))
		var/mob/living/carbon/human/npc/N = src
		if (N.danger_source)
			holder.color = AURA_MORTAL_HOSTILE
		else
			holder.color = AURA_MORTAL

	if(iskindred(src))
		//pale aura for vampires
		holder.color = AURA_KINDRED
		//only Baali can get antifrenzy through selling their soul, so this gives them the unholy halo (MAKE THIS BETTER)
		if(antifrenzy)
			holder.icon = 'icons/effects/32x64.dmi'
		//black aura for diablerists
		if(diablerist)
			holder.icon_state = "diablerie_aura"

	if(iscathayan(src))
		var/mob/living/carbon/human/H = src
		if(!H.check_kuei_jin_alive())
			holder.color = AURA_KINDRED
		else
			holder.color = AURA_MORTAL

	if(isgarou(src) || iswerewolf(src))
		//garou have bright auras due to their spiritual potence
		holder.icon_state = AURA_GAROU

	if(isghoul(src))
		//Pale spots in the aura, had to be done manually since holder.color will show only a type of color
		holder.overlays = null
		holder.color = null
		holder.icon_state = AURA_GHOUL

	if(mind?.holy_role >= HOLY_ROLE_PRIEST)
		holder.color = AURA_TRUE_FAITH
		holder.icon_state = "aura"
