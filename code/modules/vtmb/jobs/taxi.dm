/datum/job/vamp/taxi
	title = "Taxi Driver"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = " the Traditions"
	selection_color = "#e3e3e3"

	outfit = /datum/outfit/job/taxi

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TAXI
	exp_type_department = EXP_TYPE_SERVICES

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf", "Kuei-Jin")

	v_duty = "Drive people in the city."
	duty = "Drive people in the city."
	minimal_masquerade = 0
	experience_addition = 10
	allowed_bloodlines = list(CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_SALUBRI_WARRIOR, CLAN_NAGARAJA, CLAN_BAALI, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_GANGREL, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_GIOVANNI, CLAN_SETITES, CLAN_TZIMISCE, CLAN_LASOMBRA, CLAN_NONE, CLAN_KIASYD, CLAN_CAPPADOCIAN)


/datum/job/vamp/taxi/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	..()
	H.taxist = TRUE

/datum/outfit/job/taxi
	name = "Taxi Driver"
	jobtype = /datum/job/vamp/taxi

	id = /obj/item/cockclock
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/taxi
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/melee/vampirearms/tire=1)

/datum/outfit/job/taxi/pre_equip(mob/living/carbon/human/H)
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
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			uniform = /obj/item/clothing/under/vampire/sport
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			uniform = /obj/item/clothing/under/vampire/red

/obj/effect/landmark/start/taxi
	name = "Taxi Driver"
