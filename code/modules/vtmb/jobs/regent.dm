
/datum/job/vamp/regent
	title = "Tremere Bishop"
	department_head = list("Archbishop")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "House Goratrix and the Archbishop."
	selection_color = "#ab2508"

	outfit = /datum/outfit/job/regent

	access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	exp_type_department = EXP_TYPE_TREMERE

	display_order = JOB_DISPLAY_ORDER_REGENT
	v_duty = "The House Goratrix, while making inroads with the Camarilla, still have some stragglers who miraculously survived the magical purge of their kind, who cling to the Vaulderie and Dark Thaumaturgy, creating Blood Brothers, Gargoyles, and other inhuman servants alongside the Tzimisce."
	minimal_masquerade = 4
	minimal_generation = 10
//	minimum_character_age = 150 //Uncomment if age-restriction wanted
	minimum_vampire_age = 60
	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_TREMERE, CLAN_BAALI)
	experience_addition = 20
	known_contacts = list("Archbishop")

/datum/outfit/job/regent
	name = "Tremere Bishop"
	jobtype = /datum/job/vamp/regent

	id = /obj/item/card/id/regent
	glasses = /obj/item/clothing/glasses/vampire/sun
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/suit
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
		/obj/item/vamp/keys/sabbat=1,
	)

/datum/outfit/job/regent/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/archivist/female
		shoes = /obj/item/clothing/shoes/vampire/heels
	ADD_TRAIT(H, TRAIT_SABBATIST, "late_party")

/obj/effect/landmark/start/regent
	name = "Tremere Bishop"
	icon_state = "Archivist"
