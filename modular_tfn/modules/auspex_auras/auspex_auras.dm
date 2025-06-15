/mob/living/carbon/Initialize()
	. = ..()
	var/datum/atom_hud/abductor/auspexhud = GLOB.huds[DATA_HUD_ABDUCTOR]
	var/datum/atom_hud/sense_wyrm/sensewyrmhud = GLOB.huds[DATA_HUD_SENSEWYRM]
	auspexhud.add_to_hud(src)
	sensewyrmhud.add_to_hud(src)

/mob/living/carbon/proc/update_auspex_hud()
	var/image/holder = hud_list[GLAND_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "aura"

	var/mob/living/carbon/human/H = src

	if(HAS_TRAIT(src, TRAIT_FRENETIC_AURA))
		holder.icon_state = "aura_bright"

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
		if(!HAS_TRAIT(src, TRAIT_WARM_AURA) && !diablerist)
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
			holder.icon = 'icons/effects/32x64.dmi' //I'm not fucking with this until GAGS are done being ported, antifrenzy aura has some weird colorized components.
		//black aura for diablerists
		if (diablerist)
			holder.color = AURA_DIAB  //I don't understand why someone made a specific sprite for diab aura that's just blackscaled normal aura, instead of making it a defined color. This is far more elegant.

	if(isgarou(src) || iswerewolf(src) || iscorax(src))
		//garou have bright auras due to their spiritual potence
		holder.icon_state = AURA_GAROU

	if(isghoul(src) && !HAS_TRAIT(src, TRAIT_FRENETIC_AURA))
		//Pale spots in the aura, had to be done manually since holder.color will show only a type of color
		holder.icon_state = AURA_GHOUL

	if(mind?.holy_role >= HOLY_ROLE_PRIEST)
		holder.color = AURA_TRUE_FAITH

/mob/living/proc/update_sensewyrm_hud()
	var/image/holder = hud_list[SENSEWYRM_HUD]
	var/wyrm_taint = 0
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "" // no aura if you're not wyrmtainted

 // uses the same logic as the werewolf triatic scent in examine.dm
	if (iskindred(src)) //vampires are static, and may be Wyrm-tainted depending on behaviour
		var/mob/living/carbon/human/vampire = src

		if ((vampire.morality_path.score < 7) || client?.prefs?.is_enlightened)
			wyrm_taint++

		if ((vampire.clane.name == "Baali") || ( (client?.prefs?.is_enlightened && (vampire.morality_path.score >= 7)) || (!client?.prefs?.is_enlightened && (vampire.morality_path.score < 4)) ))
			wyrm_taint++

		if (istype(vampire.clane, /datum/vampireclane/kiasyd)) //the fae are Wyld-tainted by default
			wyrm_taint--

	if (isgarou(src) || iswerewolf(src) || iscorax(src)) // werewolves have the taint of whatever Triat member they venerate most
		var/mob/living/carbon/wolf = src

		if (wolf.auspice.tribe.name == "Black Spiral Dancers")
			wyrm_taint = 2

		if(HAS_TRAIT(wolf,TRAIT_WYRMTAINTED))
			wyrm_taint++

		if(istype(wolf,/mob/living/carbon/werewolf))
			var/mob/living/carbon/werewolf/werewolf = src
			if(werewolf.wyrm_tainted)
				wyrm_taint++

	if (wyrm_taint == 1)
		holder.color = AURA_WYRM_LIGHT
		holder.icon_state = "aura"

	else if (wyrm_taint >= 2)
		holder.color = AURA_WYRM_HEAVY
		holder.icon_state = "aura"


/mob/living/proc/NPC_wyrm_taint()
	var/image/holder = hud_list[SENSEWYRM_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "" // no aura if you're not wyrmtainted
	var/wyrm_prob = rand(100) // some humans might be wyrmtainted due to Pentex's work, this value randomly attributes if they are.
	if(wyrm_prob <= 15) // could be done with a switch but I ran into issues so I'm doing 2 ifs instead =)
		holder.color = AURA_WYRM_HEAVY
		holder.icon_state = "aura"
	if(wyrm_prob >15 && wyrm_prob <=40)
		holder.color = AURA_WYRM_LIGHT
		holder.icon_state = "aura"

