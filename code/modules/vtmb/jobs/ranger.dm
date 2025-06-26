/datum/job/vamp/ranger
	title = "San Bruno Park Peace Officer"
	department_head = list("California Park Services")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "California Park Services, County, State, and Federal governments."
	selection_color = "#4E5452"

	outfit = /datum/outfit/job/ranger

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_ARMORY, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_RANGER
	exp_type = EXP_TYPE_RANGER

	allowed_species = list("Ghoul", "Human")
	species_slots = list("Ghoul" = 1)

/obj/effect/landmark/start/ranger
	name = "California State Park Peace Officer"

/datum/outfit/job/ranger
	name = "Park Peace Officer"
	jobtype = /datum/job/vamp/ranger

	ears = /obj/item/p25radio/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police
	belt = /obj/item/storage/belt/police/full
	gloves = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/restraints/handcuffs = 1,/obj/item/melee/classic_baton/vampire = 1, /obj/item/storage/firstaid/ifak = 1, /obj/item/reagent_containers/spray/pepper = 1)
