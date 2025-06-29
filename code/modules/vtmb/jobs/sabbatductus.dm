/datum/job/vamp/sabbatductus
	title = "Sabbat Ductus"
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Caine"
	selection_color = "#7B0000"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/sabbatductus
	allowed_species = list("Vampire")
	exp_type_department = EXP_TYPE_SABBAT
	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	v_duty = "You are a Ductus and Pack Leader of your Sabbat pack. You are charged with rebellion against the Elders and the Camarilla, against the Jyhad, against the Masquerade and the Traditions, and the recognition of Caine as the true Dark Father of all Kindred kind.  <br> <b> NOTE: BY PLAYING THIS ROLE YOU AGREE TO AND HAVE READ THE SERVER'S RULES ON ESCALATION FOR ANTAGS. KEEP THINGS INTERESTING AND ENGAGING FOR BOTH SIDES. KILLING PLAYERS JUST BECAUSE YOU CAN MAY RESULT IN A ROLEBAN.</b>"
	duty = "Down with the Camarilla. Down with the Elders. Down with the Jyhad! The Kindred are the true rulers of Earth, blessed by Caine, the Dark Father."
	minimal_masquerade = 0
	allowed_bloodlines = list("Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Ministry", "Lasombra", "Gargoyle", "Tzimisce", "Baali", "Cappadocian", "Kiasyd", "Salubri", "Warrior Salubri", "Daughters of Cacophany", "True Brujah", "Nagaraja")
	display_order = JOB_DISPLAY_ORDER_SABBATDUCTUS
	whitelisted = TRUE

/datum/outfit/job/sabbatductus
	name = "Sabbat Ductus"
	jobtype = /datum/job/vamp/sabbatductus
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	r_pocket = /obj/item/vamp/keys/sabbat

/datum/outfit/job/sabbatductus/pre_equip(mob/living/carbon/human/H)
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
		temp_antag.add_antag_hud(ANTAG_HUD_REV, "rev_head", H)
		qdel(temp_antag)

/obj/effect/landmark/start/sabbatductus
	name = "Sabbat Ductus"
	icon_state = "Assistant"

/datum/antagonist/sabbatist/sabbatductus/on_gain()
	owner.special_role = src
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, use_reverb = FALSE)
	return ..()
