
/datum/job/vamp/barkeeper
	title = "Baron"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Anarchs and the Traditions"
	selection_color = "#434343"

	outfit = /datum/outfit/job/barkeeper

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BARKEEPER
	bounty_types = CIV_JOB_DRINK

//	minimal_generation = 13
//	minimum_character_age = 70 //Uncomment if age-restriction wanted.
	minimum_vampire_age = 1

	known_contacts = list(
		"Prince",
		"Sheriff",
		"Dealer",
		"Bouncer",
		"Emissary",
		"Sweeper",
		"Voivode"
	)

	v_duty = "You lead the Anarchs in the City. A Camarilla faction that values freedom and individuality. While not a fan of the traditions, you still respect the Masquerade."
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_BAALI, CLAN_BANU_HAQIM, CLAN_NONE, CLAN_TZIMISCE, CLAN_TRUE_BRUJAH, CLAN_BRUJAH, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_VENTRUE, CLAN_LASOMBRA, CLAN_GARGOYLE, CLAN_SETITES)
	experience_addition = 20

/datum/outfit/job/barkeeper
	name = "Baron"
	jobtype = /datum/job/vamp/barkeeper

	ears = /obj/item/p25radio
	id = /obj/item/card/id/baron
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/bar
	suit = /obj/item/clothing/suit/vampire/jacket/punk
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/work
	l_pocket = /obj/item/vamp/phone/baron
	r_pocket = /obj/item/vamp/keys/bar
	backpack_contents = list(/obj/item/passport=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/barkeeper/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/bar/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/barkeeper
	name = "Baron"
	icon_state = "Barkeeper"
