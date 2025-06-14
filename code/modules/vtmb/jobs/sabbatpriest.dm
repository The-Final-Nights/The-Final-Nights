/datum/job/vamp/sabbatpriest
	title = "Sabbat Priest"
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Caine"
	selection_color = "#7B0000"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/sabbatpriest
	allowed_species = list("Vampire")
	exp_type_department = EXP_TYPE_SABBAT
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	paycheck_department = ACCOUNT_CIV

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	v_duty = "You are the Sabbat Priest. You are charged with the supervision of the ritae of your pack. You also serve as the second-in-command to the Ductus. Consecrate the Vaulderie for new Sabbat, consult your tome for rites to aid your pack, and ensure the Sabbat live on in Caine's favor.  <br> <b> NOTE: BY PLAYING THIS ROLE YOU AGREE TO AND HAVE READ THE SERVER'S RULES ON ESCALATION FOR ANTAGS. KEEP THINGS INTERESTING AND ENGAGING FOR BOTH SIDES. KILLING PLAYERS JUST BECAUSE YOU CAN MAY RESULT IN A ROLEBAN. "
	duty = "Down with the Camarilla. Down with the Elders. Down with the Jyhad! The Kindred are the true rulers of Earth, blessed by Caine, the Dark Father."
	minimal_masquerade = 0
	allowed_bloodlines = list("Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Ministry", "Lasombra", "Gargoyle", "Tzimisce", "Baali", "Cappadocian", "Kiasyd", "Salubri", "Warrior Salubri", "Daughters of Cacophany", "True Brujah", "Nagaraja")
	display_order = JOB_DISPLAY_ORDER_SABBATPRIEST
	whitelisted = TRUE

/datum/outfit/job/sabbatpriest
	name = "Sabbat Priest"
	jobtype = /datum/job/vamp/sabbatpriest
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	r_pocket = /obj/item/vamp/keys/sabbat

/datum/outfit/job/sabbatpriest/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
	if(H.clane)
		if(H.clane.name == "Lasombra")
			backpack_contents = list(/obj/item/passport =1, /obj/item/vamp/creditcard=1)
	if(!H.clane)
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.clane && H.clane.name != "Lasombra")
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.mind)
		var/datum/antagonist/temp_antag = new()
		temp_antag.add_antag_hud(ANTAG_HUD_REV, "rev_head", H)
		qdel(temp_antag)

/obj/effect/landmark/start/sabbatpriest
	name = "Sabbat Priest"
	icon_state = "Assistant"

/proc/is_sabbatist(mob/living/user)
	return user?.mind?.assigned_role in list("Sabbat Priest", "Sabbat Ductus", "Sabbat Pack")

/proc/is_sabbat_priest(mob/living/user)
	return user?.mind?.assigned_role == "Sabbat Priest"

/proc/is_sabbat_ductus(mob/living/user)
	return user?.mind?.assigned_role == "Sabbat Ductus"

/obj/item/sabbat_priest_tome
	name = "Sabbat Priest's Tome"
	desc = "A tome adorned with the symbol of the Sabbat."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "sabbat-tome"

/datum/sabbat_ritae/ritae_description
	var/name = "Ritae Description"
	var/desc = "Ritae Description"

/datum/sabbat_ritae/ritae_description/pack_credo
	name = "Pack Credo"
	desc = "We are the Sword of Caine. We do not bow to the Masquerade. We are not slaves to the Elders, nor tools of the Antediluvians. Through blood and fire, we prepare for Gehenna. We act not in secrecy, but in strength, united as one Pack. Death to traitors. Death to tyrants. Caine wills it.\n"

/datum/sabbat_ritae/ritae_description/vaulderie_info
	name = "The Vaulderie"
	desc = "The Vaulderie is a ritual by which a vinculum is established among a pack. It establishes a low level, communal blood bond among its participants. It severs blood bonds, reminding all Cainites to be free from the Elders who usurped Caine. Perform this ritual via the Vaulderie Goblet or Silver Goblet. Each member must drip their vitae into the cup, which is then shared among all participants.\n"

/datum/sabbat_ritae/ritae_description/shovelhead_info
	name = "Creation Rites"
	desc = "The Creation Rites we are often slandered for. A Cainite makes their way into the True Sabbat by conquering their fear of fire and death in our lair, walking straight through our campfire. In times of desperation, however, and especially if we feel the need to embrace en masse, we may use the 'shovelhead method', embracing new Cainites and digging them into a shallow grave, awakening their frenzy, their Beast, their true nature... \n"

/datum/sabbat_ritae/ritae_description/monomacy_info
	name = "Monomacy"
	desc = "The Rite of Monomacy is a rite which calls two Sabbat Cainites to duel when they may not settle their dispute peacefully or rationally. The challenger uses the Monomacy Circle Rune located within our lair to call the challenged to combat, where the challenged may accept, or decline, the duel. The Priest must decide whether or not the dispute is worthy of monomacy. The challenged Cainite gets to decide the terms of the duel, such as weapons, disciplines allowed or not, torpor or final death, and location... The Priest has ultimate power of the ritae, and the pack, always, and may declare certain duels as null and void.\n"

/datum/sabbat_ritae/ritae_description/bloodbath_info
	name = "Blood Bath"
	desc = "The Rite of the Blood Bath is the rite by which the Priest may select a new Ductus, usually taking place after the previous Ductus was challenged to Monomacy. Each Sabbat Cainite who wishes to serve the new Ductus approaches our bathtub, and contributes a large amount of vitae using the ritual knife. The new Ductus then bathes in the blood of the pack which recognizes them, where the Priest then uses the Tome on the bathtub, and upon exiting the bathtub, the Priest is to scoop up the blood in a Vaulderie Goblet, for all to drink of, consecrating the new Pack formation's vinculum. \n"

/datum/sabbat_ritae/ritae_description/war_party_hunt_info
	name = "War Party"
	desc = "The Ritus of the War Party may be invoked by using the War Party totem, fashioned from an Elder Cainite's skull. Its dark power calls upon all who have taken part of the Vaulderie in the city to return to our lair to discuss plans for a War Party,  where we may strike at the heretics, the pretenders, and the cowards who hide behind the Masquerade. The Elders betrayed Caine, and we are his vengeance made flesh.\n"

/datum/sabbat_ritae/ritae_description/blood_feast_info
	name = "Blood Feast"
	desc = "The Blood Feast is a rite of celebration held by the pack, usually when any formal gathering is declared. Each of our Cainites, with the Priest being able to choose whether or not they participate, leaves in a competition for the hunt. Woe unto the Cainite who brings some foul beggar with blood that tastes of dirt. This Rite shall be a competition, to see who may offer the most worthy morsel to the communal pack, whether that is a nosy police officer, a Rogue Sabbat Cainite, or a worthy heretical Cainite for diablerie, the strength of the pack shall be shown, and we shall all feast this night. \n"

/datum/sabbat_ritae/ritae_description/wild_hunt_info
	name = "Wild Hunt"
	desc = "None may defy Caine - especially not those who have undertaken the Vaulderie! Traitors and defectors to Caine and the Sabbat shall be struck down with a rightful war party, along with any who know of their treachery. Diablerie, burning them atop our ritual fire with a stake still in their putrid heart, or mutilation may take place, before they are sentenced to death. None may defy Caine, and none may escape Caine's vengeance, not the Elders of the Camarilla or traitors to the pack.\n "

/obj/item/sabbat_priest_tome/attack_self(mob/living/carbon/human/user)
	if(!user.mind || !is_sabbatist(user))
		to_chat(user, "You feel nothing when you touch this tome.")
		return

	var/is_priest = is_sabbat_priest(user)

	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-open"
	addtimer(CALLBACK(src, .proc/close_book), 10 SECONDS)

	to_chat(user, "These are the Auctoritas Ritae given to you by Caine.")

	// Define all ritae datums
	var/list/ritae_datums = list(
		"Pack Credo" = new /datum/sabbat_ritae/ritae_description/pack_credo(),
		"Vaulderie" = new /datum/sabbat_ritae/ritae_description/vaulderie_info(),
		"Shovelhead" = new /datum/sabbat_ritae/ritae_description/shovelhead_info(),
		"Monomacy" = new /datum/sabbat_ritae/ritae_description/monomacy_info(),
		"Blood Bath" = new /datum/sabbat_ritae/ritae_description/bloodbath_info(),
		"War Party" = new /datum/sabbat_ritae/ritae_description/war_party_hunt_info(),
		"Blood Feast" = new /datum/sabbat_ritae/ritae_description/blood_feast_info(),
		"Wild Hunt" = new /datum/sabbat_ritae/ritae_description/wild_hunt_info()
	)

	var/list/ritae_options = list()

	// Everyone can see "Pack Credo"
	if(is_priest)
		ritae_options += "Pack Credo (Edit)"
	else
		ritae_options += "Pack Credo"

	// Only Priests can see other ritae
	if(is_priest)
		for(var/name in ritae_datums)
			if(name != "Pack Credo")
				ritae_options += name

	var/choice = tgui_input_list(user, "Select a Rite to learn about:", "Sabbat Ritae", ritae_options)
	if(!choice)
		return

	if(choice == "Pack Credo (Edit)")
		var/datum/sabbat_ritae/ritae_description/pack_credo/credo = ritae_datums["Pack Credo"]
		to_chat(user, span_cult("<b>Pack Credo:</b>"))
		to_chat(user, span_cult("[credo.desc]"))

		var/new_credo = tgui_input_text(user, "Enter your interpretation of the Sabbat's goals:", "Edit Pack Credo", credo.desc)
		if(new_credo && new_credo != credo.desc)
			credo.desc = new_credo
			to_chat(user, span_cult("You update your pack's interpretation of the Sabbat Credo."))
		return

	var/datum/sabbat_ritae/ritae_description/ritus = ritae_datums[choice]
	if(ritus)
		to_chat(user, span_cult("<b>[ritus.name]:</b>"))
		to_chat(user, span_cult("[ritus.desc]"))

/obj/item/sabbat_priest_tome/proc/close_book()
	icon_state = initial(icon_state)
