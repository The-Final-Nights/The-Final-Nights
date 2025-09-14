/mob/living/carbon/Initialize()
	. = ..()
	var/datum/atom_hud/sense_wyrm/sensewyrmhud = GLOB.huds[DATA_HUD_SENSEWYRM]
	sensewyrmhud.add_to_hud(src)

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

		if ((vampire.clan.name == "Baali") || ( (client?.prefs?.is_enlightened && (vampire.morality_path.score >= 7)) || (!client?.prefs?.is_enlightened && (vampire.morality_path.score < 4)) ))
			wyrm_taint++

		if (istype(vampire.clan, /datum/vampire_clan/kiasyd)) //the fae are Wyld-tainted by default
			wyrm_taint--

	if (isgarou(src) || iswerewolf(src)) // werewolves have the taint of whatever Triat member they venerate most
		var/mob/living/carbon/wolf = src

		if (wolf.auspice.tribe.name == "Black Spiral Dancers")
			wyrm_taint = 2

		if(HAS_TRAIT(wolf,TRAIT_WYRMTAINTED))
			wyrm_taint++

		/*if(istype(wolf,/mob/living/carbon/werewolf))
			var/mob/living/carbon/werewolf/werewolf = src
			if(werewolf.wyrm_tainted)
				wyrm_taint++*/

	if (wyrm_taint == 1)
		holder.color = AURA_WYRM_LIGHT
		holder.icon_state = "aura"

	else if (wyrm_taint >= 2)
		holder.color = AURA_WYRM_HEAVY
		holder.icon_state = "aura"


/mob/living/carbon/proc/NPC_wyrm_taint()
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
