/datum/job/vamp/sabbatpack
	title = "Sabbat Pack"
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Caine"
	selection_color = "#7B0000"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/sabbatpack
	allowed_species = list("Vampire")
	exp_type_department = EXP_TYPE_SABBAT
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	paycheck_department = ACCOUNT_CIV

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	v_duty = "You are a member of the Sabbat. You are charged with rebellion against the Elders and the Camarilla, against the Jyhad, against the Masquerade and the Traditions, and the recognition of Caine as the true Dark Father of all Kindred kind.  <br> <b> NOTE: BY PLAYING THIS ROLE YOU AGREE TO AND HAVE READ THE SERVER'S RULES ON ESCALATION FOR ANTAGS. KEEP THINGS INTERESTING AND ENGAGING FOR BOTH SIDES. KILLING PLAYERS JUST BECAUSE YOU CAN MAY RESULT IN A ROLEBAN. "
	duty = "Down with the Camarilla. Down with the Elders. Down with the Jyhad! The Kindred are the true rulers of Earth, blessed by Caine, the Dark Father."
	minimal_masquerade = 0
	allowed_bloodlines = list("Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Ministry", "Lasombra", "Gargoyle", "Tzimisce", "Baali", "Cappadocian", "Kiasyd", "Salubri", "Salubri Warrior", "Daughters of Cacophony", "True Brujah", "Nagaraja", "Caitiff")
	display_order = JOB_DISPLAY_ORDER_SABBATPACK
	whitelisted = TRUE

/datum/outfit/job/sabbatpack
	name = "Sabbat Pack"
	jobtype = /datum/job/vamp/sabbatpack
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	r_pocket = /obj/item/vamp/keys/sabbat

/datum/outfit/job/sabbatpack/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clan)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clan.male_clothes)
				uniform = H.clan.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clan.female_clothes)
				uniform = H.clan.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
	if(H.clan)
		if(H.clan.name == "Lasombra")
			backpack_contents = list(/obj/item/passport =1, /obj/item/vamp/creditcard=1)
	if(!H.clan)
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.clan && H.clan.name != "Lasombra")
		backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	if(H.mind)
		var/datum/antagonist/temp_antag = new()
		temp_antag.add_antag_hud(ANTAG_HUD_REV, "rev", H)
		qdel(temp_antag)

/obj/effect/landmark/start/sabbatpack
	name = "Sabbat Pack"
	icon_state = "Assistant"

// keeping this for lateparty sabbat
/datum/antagonist/sabbatist
	name = "Sabbatist"
	roundend_category = "sabbattites"
	antagpanel_category = FACTION_SABBAT
	job_rank = ROLE_REV
	antag_moodlet = /datum/mood_event/revolution
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev"

/datum/antagonist/sabbatist/on_gain()
	add_antag_hud(ANTAG_HUD_REV, "rev", owner.current)
	owner.special_role = src
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, use_reverb = FALSE)
	return ..()

