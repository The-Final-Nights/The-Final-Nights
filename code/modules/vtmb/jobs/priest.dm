
/datum/job/vamp/priest
	title = "Priest"
	department_head = list("Bishop")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "God ... And the Patron of the Church."
	selection_color = "#fff700"

	outfit = /datum/outfit/job/priest

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_PRIEST
	exp_type_department = EXP_TYPE_CHURCH

	allowed_species = list("Human", "Ghoul", "Vampire")
	allowed_bloodlines = list(CLAN_LASOMBRA, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_SALUBRI, CLAN_SALUBRI_WARRIOR, CLAN_NAGARAJA, CLAN_CAPPADOCIAN, CLAN_BANU_HAQIM, CLAN_NONE)
	species_slots = list("Vampire" = 2, "Ghoul" = 50, "Human" = 50)
	minimal_generation = 13

	duty = "Be the shepherd of the flock in San Francisco, lead them to salvation, piety and righteousness, despite whatever oddities you may notice from the restricted Top Floor, and the Patron of the Church that you answer to."
	v_duty = "Yours is the charge of this church and its safety, in diverting attention away from your kind. But behave when under the gaze of the true master of this shadowed Domain."
	minimal_masquerade = 0

/datum/outfit/job/priest
	name = "Priest"
	jobtype = /datum/job/vamp/priest

	uniform = /obj/item/clothing/under/vampire/graveyard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/id/hunter
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/church
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/priest
	name = "Priest"
