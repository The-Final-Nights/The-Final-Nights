/datum/job/vamp/gargoyle
	title = "Chantry Gargoyle"
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Traditions and the Regent"
	selection_color = "#ab2508"

	outfit = /datum/outfit/job/gargoyle

	access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	exp_type_department = EXP_TYPE_TREMERE

	display_order = JOB_DISPLAY_ORDER_GARGOYLE

	v_duty = "An agent of the Chantry, you are a Tremere Gargoyle who was made legally having existed before their creation was banned. Serve the Regent well!"
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	allowed_bloodlines = list("Gargoyle")
	known_contacts = list("Tremere Regent")
	experience_addition = 15

/datum/outfit/job/gargoyle
	name = "Chantry Gargoyle"
	jobtype = /datum/job/vamp/gargoyle

	id = /obj/item/card/id/archive
	glasses = /obj/item/clothing/glasses/vampire/perception
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/archivist
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/vamp/phone/archivist
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/arcane_tome=1, /obj/item/vamp/creditcard=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/gargoyle/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/archivist/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/gargoyle
	name = "Chantry Gargoyle"
	icon_state = "Archivist"
