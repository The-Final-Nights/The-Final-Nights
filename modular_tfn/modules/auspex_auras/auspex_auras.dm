/mob/living/carbon/Initialize()
	. = ..()
	var/datum/atom_hud/abductor/hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	hud.add_to_hud(src)

/mob/living/carbon/proc/update_auspex_hud()
	var/image/holder = hud_list[GLAND_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "aura"

	var/mob/living/carbon/human/H = src

	if(client)
		switch(a_intent)
			if(INTENT_HARM)
				holder.color = AURA_MORTAL_HARM
			if(INTENT_GRAB)
				holder.color = AURA_MORTAL_GRAB
			if(INTENT_DISARM)
				holder.color = AURA_MORTAL_DISARM
			else
				holder.color = AURA_MORTAL_HELP
	else if (isnpc(src))
		var/mob/living/carbon/human/npc/N = src
		if (N.danger_source)
			holder.color = AURA_MORTAL_HARM
		else
			holder.color = AURA_MORTAL_DISARM

	if (iskindred(src) || HAS_TRAIT(src, TRAIT_COLD_AURA) || (iscathayan(src) && !H.check_kuei_jin_alive()))
		//pale aura for vampires
		if(!HAS_TRAIT(src, TRAIT_WARM_AURA))
			switch(a_intent)
				if(INTENT_HARM)
					holder.color = AURA_UNDEAD_HARM
				if(INTENT_GRAB)
					holder.color = AURA_UNDEAD_GRAB
				if(INTENT_DISARM)
					holder.color = AURA_UNDEAD_DISARM
				else
					holder.color = AURA_UNDEAD_HELP
		//only Baali can get antifrenzy through selling their soul, so this gives them the unholy halo (MAKE THIS BETTER)
		if (antifrenzy)
			holder.icon = 'icons/effects/32x64.dmi'
		//black aura for diablerists
		if (diablerist)
			holder.icon_state = "diablerie_aura"

	if(isgarou(src) || iswerewolf(src))
		//garou have bright auras due to their spiritual potence
		holder.icon_state = AURA_GAROU

	if(isghoul(src))
		//Pale spots in the aura, had to be done manually since holder.color will show only a type of color
		holder.icon_state = AURA_GHOUL

	if(mind?.holy_role >= HOLY_ROLE_PRIEST)
		holder.color = AURA_TRUE_FAITH
		holder.icon_state = "aura"
