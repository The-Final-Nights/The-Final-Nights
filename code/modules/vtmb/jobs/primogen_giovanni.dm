/datum/job/vamp/primogen_giovanni
	title = "Primogen Giovanni"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions and the Family"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/giovanni_primogen

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_GIOVANNI
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Giovanni")
	minimal_generation = 10

	v_duty = "Offer your infinite knowledge to Prince of the City. You handle the family's business interests in the city and operate the funeral home as your domain. Keep your necromantic practices discreet, and ensure the Giovanni remain respected within the Camarilla."
	experience_addition = 20
	minimal_masquerade = 5
	my_contact_is_important = TRUE
	known_contacts = list("Prince", "Capo")

/datum/outfit/job/giovanni_primogen
	name = "Primogen Giovanni"
	jobtype = /datum/job/vamp/primogen_giovanni

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/giovanni
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/giovanni/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon)

/datum/outfit/job/giovanni_primogen/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/primogen_giovanni
	name = "Primogen Giovanni"
	icon_state = "Assistant"
