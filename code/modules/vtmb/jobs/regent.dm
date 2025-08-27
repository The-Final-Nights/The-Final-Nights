
/datum/job/vamp/regent
	title = "Chantry Regent"
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Pyramid, or what remains of it"
	selection_color = "#ab2508"

	outfit = /datum/outfit/job/regent

	access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	exp_type_department = EXP_TYPE_TREMERE

	display_order = JOB_DISPLAY_ORDER_REGENT
	v_duty = "Lead the Chantry. You serve as both the Regent and Tremere Primogen. You report to the Tremere Lord of this region first, Prince second."
	minimal_masquerade = 4
	minimal_generation = 10
//	minimum_character_age = 150 //Uncomment if age-restriction wanted
	minimum_vampire_age = 60
	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_TREMERE)
	experience_addition = 20
	known_contacts = list("Prince")

/datum/outfit/job/regent
	name = "Chantry Regent"
	jobtype = /datum/job/vamp/regent

	ears = /obj/item/p25radio
	id = /obj/item/card/id/regent
	glasses = /obj/item/clothing/glasses/vampire/red
	suit = /obj/item/clothing/suit/vampire/trench/strauss
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/archivist
	r_pocket = /obj/item/vamp/keys/regent
	l_pocket = /obj/item/vamp/phone/tremere_regent
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/phone_book=1,
		/obj/item/cockclock=1,
		/obj/item/flashlight=1,
		/obj/item/arcane_tome=1,
		/obj/item/vamp/creditcard/elder=1,
		/obj/item/melee/vampirearms/katana/kosa=1,
	)

/datum/outfit/job/regent/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/archivist/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/regent
	name = "Chantry Regent"
	icon_state = "Archivist"
