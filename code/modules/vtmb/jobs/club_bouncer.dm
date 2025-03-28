/datum/job/vamp/club_bouncer
	title = "Club Bouncer"
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "The Club Manager"
	selection_color = "#ff69b4"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/club_bouncer
	antag_rep = 10
	paycheck = PAYCHECK_COMMAND
	exp_type_department = EXP_TYPE_CLUB

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_STRIP
	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf", "Kuei-Jin")

	v_duty = "Provide security for the club, ensuring that no trouble-makers disturb the peace. Protect the staff and patrons."
	duty = "Keep order at the club entrance and inside the establishment. You're aware of the supernatural nature of some clients and know to follow the owner's lead when dealing with them."
	minimal_masquerade = 3
	allowed_bloodlines = list("True Brujah", "Daughters of Cacophony", "Salubri", "Baali", "Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry", "Tzimisce", "Lasombra", "Caitiff", "Kiasyd")
	experience_addition = 10

/datum/outfit/job/club_bouncer
	name = "Club Bouncer"
	jobtype = /datum/job/vamp/club_bouncer
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/strip
	id = /obj/item/cockclock
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)
	suit = /obj/item/clothing/suit/armor/vest
	uniform = /obj/item/clothing/under/vampire/bouncer
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	head = /obj/item/clothing/head/soft/black

/obj/effect/landmark/start/strip
	name = "Strip"
	icon_state = "Assistant"
