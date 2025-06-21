/datum/job/vamp/gargoyle
	title = "Chantry Gargoyle"
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Traditions and the Regent"
	selection_color = "#ab2508"

	outfit = /datum/outfit/job/gargoyle

	access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	exp_type_department = EXP_TYPE_TREMERE

	departments = DEPARTMENT_BITFLAG_TREMERE

	display_order = JOB_DISPLAY_ORDER_GARGOYLE

	v_duty = "An agent of the Chantry, you are a Tremere Gargoyle who was made legally having existed before their creation was banned. Serve the Regent well!"
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_GARGOYLE)
	known_contacts = list("Tremere Regent")
	experience_addition = 15

/datum/outfit/job/gargoyle
	name = "Chantry Gargoyle"
	jobtype = /datum/job/vamp/gargoyle

	id = /obj/item/card/id/archive
	glasses = /obj/item/clothing/glasses/vampire/red
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/work
	uniform = /obj/item/clothing/under/vampire/turtleneck_black
	suit = /obj/item/clothing/suit/hooded/robes/tremere
	mask = /obj/item/clothing/mask/vampire/venetian_mask
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/vamp/phone/gargoyle
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(
		/obj/item/cockclock=1,
		/obj/item/flashlight=1,
		/obj/item/arcane_tome=1,
		/obj/item/vamp/creditcard=1,
		/obj/item/melee/vampirearms/katana/kosa=1,
	)

/obj/effect/landmark/start/gargoyle
	name = "Chantry Gargoyle"
	icon_state = "Archivist"
