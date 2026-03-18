
/datum/job/vamp/archivist
	title = "Sabbat Chantry Archivist"
	department_head = list("Bishop")
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Code of Milan, Caine, and the Bishop."
	selection_color = "#ab2508"

	outfit = /datum/outfit/job/archivist

	access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_AUX_BASE, ACCESS_MINING_STATION)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	exp_type_department = EXP_TYPE_TREMERE

	display_order = JOB_DISPLAY_ORDER_ARCHIVIST

	v_duty = "Your Bishop, a mirauclous survivor of the Sabbat of the purge of House Goratrix, maintains a small Chantry in the city to study Dark Thaumaturgy and oppose the forces of the mainline Tremere clan. Assist all Children of Caine and obey the Code of Milan!"
	minimal_masquerade = 3
	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_TREMERE, CLAN_BAALI)
	known_contacts = list("Tremere Regent")
	experience_addition = 15

/datum/outfit/job/archivist
	name = "Archivist"
	jobtype = /datum/job/vamp/archivist

	id = /obj/item/card/id/archive
	glasses = /obj/item/clothing/glasses/vampire/perception
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/turtleneck_black
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/vamp/phone/archivist
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/arcane_tome=1, /obj/item/vamp/creditcard=1, /obj/item/melee/vampirearms/katana/kosa=1, /obj/item/vamp/keys/sabbat=1)

/datum/outfit/job/archivist/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/archivist/female
		shoes = /obj/item/clothing/shoes/vampire/heels
	ADD_TRAIT(H, TRAIT_SABBATIST, "late_party")

/obj/effect/landmark/start/archivist
	name = "Archivist"
	icon_state = "Archivist"
