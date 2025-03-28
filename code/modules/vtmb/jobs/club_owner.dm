/datum/job/vamp/club_owner
	title = "Club Manager"
	faction = FACTION_CLUB
	total_positions = 1
	spawn_positions = 1
	supervisors = "Toredaor Primogen"
	selection_color = "#ff69b4"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/club_owner
	paycheck = PAYCHECK_COMMAND
	exp_type_department = EXP_TYPE_CLUB

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_STRIP - 1
	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf", "Kuei-Jin")

	v_duty = "Manage your club and its employees. Run a profitable business while keeping an eye on the comings and goings of the supernatural world. You answer to the Toreador Primogen who oversees the city's nightlife."
	duty = "Manage your club and its employees. You're well aware of the supernatural clientele that frequents your establishment, and you maintain discretion."
	minimal_masquerade = 3
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Kiasyd")
	experience_addition = 15

/datum/outfit/job/club_owner
	name = "Club Manager"
	jobtype = /datum/job/vamp/club_owner
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/strip
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	uniform = /obj/item/clothing/under/vampire/slickback
	shoes = /obj/item/clothing/shoes/vampire/businessblack

/obj/effect/landmark/start/strip
	name = "Strip"
	icon_state = "Assistant"
