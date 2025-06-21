
/datum/job/vamp/strip
	title = "Club Worker"
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "The Club Owner (Toreador Primogen)"
	selection_color = "#e3e3e3"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/strip
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	exp_type_department = EXP_TYPE_SERVICES

	departments = DEPARTMENT_BITFLAG_SERVICES

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_STRIP
	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf", "Kuei-Jin")

	v_duty = "Offer strip club services to humans, undead or anything else that walks through the door."
	duty = "Offer strip club services. Some of your clientele may be... Unusual, but you are either addicted to vampire bites, or bribed to listen little and say even less."
	minimal_masquerade = 3
	allowed_bloodlines = list(CLAN_TRUE_BRUJAH, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_NAGARAJA, CLAN_SALUBRI_WARRIOR, CLAN_BAALI, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_GIOVANNI, CLAN_SETITES, CLAN_TZIMISCE, CLAN_LASOMBRA, CLAN_NONE, CLAN_KIASYD)
	experience_addition = 10

/datum/outfit/job/strip
	name = "Club Worker"
	jobtype = /datum/job/vamp/citizen
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/strip
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/datum/outfit/job/strip/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == MALE)
		shoes = /obj/item/clothing/shoes/vampire/white
		uniform = /obj/item/clothing/under/vampire/slickback
	else
		shoes = /obj/item/clothing/shoes/vampire/heels
		uniform = /obj/item/clothing/under/vampire/burlesque

/obj/effect/landmark/start/strip
	name = "Strip"
	icon_state = "Assistant"
