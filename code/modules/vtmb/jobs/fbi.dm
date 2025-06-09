
/datum/job/vamp/fbi
	title = "Federal Investigator"
	department_head = list("Federal Bureau of Investigation")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = " the FBI"
	selection_color = "#1a1d8a"

	outfit = /datum/outfit/job/fbi

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_ARMORY, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_FBI
	exp_type_department = EXP_TYPE_NATIONAL_SECURITY

	allowed_species = list("Human")
	minimal_generation = 13

	duty = "You are here on an officially unofficial assignment, to look into local oddities and sort them out as deemed reasonable, whatever that means. To the point you arent even assigned a proper office, as much a ghetto hideout in the local Hotel, quietly paid for with some renovations. If anyone asks? Make something mundane up, they wouldnt believe the truth anyways."
	minimal_masquerade = 0
	known_contacts = list("Police Chief")

/datum/outfit/job/fbi
	name = "Federal Investigator"
	jobtype = /datum/job/vamp/fbi

	ears = /obj/item/p25radio/police/government
	uniform = /obj/item/clothing/under/vampire/office
	shoes = /obj/item/clothing/shoes/vampire
	suit = /obj/item/clothing/suit/vampire/jacket/fbi
	belt = /obj/item/storage/belt/holster/detective/vampire/fbi
	id = /obj/item/card/id/police/fbi
	gloves = /obj/item/clothing/gloves/vampire/investigator
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/binoculars
	l_hand = /obj/item/vamp/keys/police/federal
	r_hand = /obj/item/storage/secure/briefcase/fbi

	backpack_contents = list(/obj/item/ammo_box/magazine/glock45acp=1, /obj/item/police_radio=1, /obj/item/flashlight=1, /obj/item/cockclock=1, /obj/item/card/id/police/sergeant=1, /obj/item/passport=1, /obj/item/camera=1, /obj/item/camera_film=1, /obj/item/taperecorder=1, /obj/item/ammo_box/vampire/c45acp=1, /obj/item/tape=3, /obj/item/vamp/creditcard=1, /obj/item/storage/firstaid/ifak=1)

//Ranger Job Addition for Forest Remap

/datum/job/vamp/ranger
	title = "National Park Ranger"
	department_head = list("National Park Services")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = " Senior Rangers and the National Park Services"
	selection_color = "#1a1d8a"

	outfit = /datum/outfit/job/ranger

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_ARMORY, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_RANGER
	exp_type_department = EXP_TYPE_RANGER

	allowed_species = list("Human")

	duty = "Enforce the federal laws of the NPS. You have jurisdictional authority in the park, yet should work with other agencies when dealing with matters within the park. Assist with hunting licenses. Ensure poachers are punished. Maintain the hunting lodge."
	minimal_masquerade = 0
	known_contacts = null

/obj/effect/landmark/start/ranger
	name = "National Park Ranger"

/datum/outfit/job/ranger
	name = "National Park Ranger"
	jobtype = /datum/job/vamp/ranger

	uniform = /obj/item/clothing/under/vampire/guard //replace with proper ranger uniform in future
	shoes = /obj/item/clothing/shoes/vampire
	belt = /obj/item/storage/belt/police
	id = /obj/item/card/id/garou/glade/guardian
	gloves = /obj/item/clothing/gloves/vampire/work
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/ranger
	backpack_contents = list(/obj/item/card/id/police/sergeant=1, /obj/item/passport=1, /obj/item/camera/detective=1, /obj/item/camera_film=1, /obj/item/taperecorder=1, /obj/item/tape=1, /obj/item/vamp/creditcard=1, /obj/item/ammo_box/vampire/c9mm=1, /obj/item/storage/firstaid/ifak=1)
	