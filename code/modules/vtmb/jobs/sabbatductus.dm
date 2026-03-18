/datum/job/vamp/sabbatductus
	title = "Camarilla Praetor"
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Inner Council"
	selection_color = "#7B0000"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/sabbatductus
	allowed_species = list("Vampire")
	exp_type_department = EXP_TYPE_SABBAT
	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	v_duty = "Ever since the recent Sabbat takeover of the City, you, a prominent Primogen or Elder of the Camarilla, have been forced to gather up any essentials and flee the Millenium Tower for a hidden base in the sewers. It was then that you were contacted by a notable Justicar of your Clan, who tasked you as their Praetor to oversee a group of Archons to retake the Clan's entrenched position in the city. Work strategically to win back the city, or be doomed to report to your sire with failure."
	duty = ""
	minimal_masquerade = 0
	minimal_generation = 11
	allowed_bloodlines = list(CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_TOREADOR, CLAN_GANGREL, CLAN_MALKAVIAN, CLAN_LASOMBRA, CLAN_BANU_HAQIM, CLAN_LASOMBRA)
	display_order = JOB_DISPLAY_ORDER_SABBATDUCTUS
	whitelisted = TRUE

/datum/outfit/job/sabbatductus
	name = "Sabbat Ductus"
	jobtype = /datum/job/vamp/sabbatductus
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	r_pocket = /obj/item/vamp/keys/camarilla

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


/obj/effect/landmark/start/sabbatductus
	name = "Camarilla Praetor"
	icon_state = "Assistant"

/datum/antagonist/sabbatist/sabbatductus/on_gain()
	owner.special_role = src
	owner.current.playsound_local(get_turf(owner.current), 'code/modules/wod13/sounds/evil_start.ogg', 100, FALSE, use_reverb = FALSE)
	return ..()
