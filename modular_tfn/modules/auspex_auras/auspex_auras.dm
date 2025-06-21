/mob/living/carbon/Initialize()
	. = ..()
	var/datum/atom_hud/abductor/hud = GLOB.huds[DATA_HUD_ABDUCTOR]
	hud.add_to_hud(src)

/mob/living/proc/update_auspex_hud()
	var/image/holder = hud_list[GLAND_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "aura"

	var/mob/living/carbon/human/H = src

	if(HAS_TRAIT(src, TRAIT_FRENETIC_AURA))
		holder.icon_state = "aura_bright"

	if(client)
		if(combat_mode)
			holder.color = AURA_MORTAL_HARM
		else
			holder.color = AURA_MORTAL_HELP
	else if (isnpc(src))
		var/mob/living/carbon/human/npc/N = src
		if (N.danger_source)
			holder.color = AURA_MORTAL_HARM
		else
			holder.color = AURA_MORTAL_HELP

	if (iskindred(src) || HAS_TRAIT(src, TRAIT_COLD_AURA) || (iscathayan(src) && !H.check_kuei_jin_alive()) || iszombie(src))
		//pale aura for vampires
		if(!HAS_TRAIT(src, TRAIT_WARM_AURA) && !H.diablerist)
			if(combat_mode)
				holder.color = AURA_UNDEAD_HARM
			else
				holder.color = AURA_UNDEAD_HELP
		//only Baali can get antifrenzy through selling their soul, so this gives them the unholy halo (MAKE THIS BETTER)
		if (H.antifrenzy)
			holder.icon = 'icons/effects/32x64.dmi' //I'm not fucking with this until GAGS are done being ported, antifrenzy aura has some weird colorized components.
		//black aura for diablerists
		if (H.diablerist || H.fakediablerist)
			holder.color = AURA_DIAB  //I don't understand why someone made a specific sprite for diab aura that's just blackscaled normal aura, instead of making it a defined color. This is far more elegant.

	if(isgarou(src) || iswerewolf(src))
		//garou have bright auras due to their spiritual potence
		holder.icon_state = AURA_GAROU

	if(isghoul(src) && !HAS_TRAIT(src, TRAIT_FRENETIC_AURA))
		//Pale spots in the aura, had to be done manually since holder.color will show only a type of color
		holder.icon_state = AURA_GHOUL

	if(mind?.holy_role >= HOLY_ROLE_PRIEST)
		holder.color = AURA_TRUE_FAITH
