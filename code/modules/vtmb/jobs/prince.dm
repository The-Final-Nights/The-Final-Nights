/datum/job/vamp/prince
	title = "Archbishop"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Regent")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Code of Milan and the Regent of the Sabbat."
	selection_color = "#bd3327"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_CAMARILLIA

	outfit = /datum/outfit/job/prince

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_PRINCE

	minimal_generation = 10
//	minimum_character_age = 150 //Uncomment if age-restriction wanted
	minimum_vampire_age = 75

	minimal_masquerade = 5
	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_NONE, CLAN_BRUJAH, CLAN_TOREADOR, CLAN_NOSFERATU, CLAN_TREMERE, CLAN_GANGREL, CLAN_VENTRUE, CLAN_MALKAVIAN, CLAN_TZIMISCE, CLAN_TRUE_BRUJAH, CLAN_OLD_TZIMISCE, CLAN_SALUBRI, CLAN_KIASYD, CLAN_LASOMBRA, CLAN_SETITES, CLAN_BANU_HAQIM, CLAN_GARGOYLE, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_CAPPADOCIAN, CLAN_NAGARAJA, CLAN_SALUBRI_WARRIOR, CLAN_GARGOYLE, CLAN_TZIMISCE)

	known_contacts = list(
		"Inquisitor",
		"Priscus",
		"Dealer",
		"Sabbat Tremere Bishop",
		"Bishops",
		"Baron",
		"Voivode"
	)

	v_duty = "You are the Archbishop of San Francisco, recently taken over by the forces of the Sabbat. Ensure the Code of Milan is upheld, and that Cainite society remains free from the Elders and the Jyhad, hidden from the mortals, so this city may support the liberation of others. Beware if you let the city fall into ruin, as there are Cainites greater than you who will punish you if the city falls..."
	experience_addition = 25

/datum/job/vamp/prince/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce), "Archbishop [H.real_name] has arrived in the district!"))

/datum/outfit/job/prince
	name = "Archbishop"
	jobtype = /datum/job/vamp/prince

	id = /obj/item/card/id/prince
	glasses = /obj/item/clothing/glasses/vampire/sun
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform =  /obj/item/clothing/under/vampire/prince
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/prince
	r_pocket = /obj/item/vamp/keys/sabbat
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/prince=1, /obj/item/card/id/elysium=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/prince/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/prince/female
		shoes = /obj/item/clothing/shoes/vampire/heels
	ADD_TRAIT(H, TRAIT_SABBATIST, "late_party")

/obj/effect/landmark/start/prince
	name = "Archbishop"
	icon_state = "Prince"
