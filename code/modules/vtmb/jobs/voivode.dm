/datum/job/vamp/voivode
	title = "Voivode"
	department_head = list("Eldest")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Laws of Hospitality"
	selection_color = "#953d2d"

	outfit = /datum/outfit/job/voivode

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_VOIVODE
	exp_type_department = EXP_TYPE_TZIMISCE

	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_TZIMISCE)
	minimal_generation = 10
//	minimum_character_age = 150 //Uncomment if age-restriction wanted
	minimum_vampire_age = 75

	v_duty = "You are a Childe of the Voivode-in-Waiting, the ancient Tzimisce Elder who has rested beneath the Earth for an age longer than the city that now rests on their bones, and thus the master of your Haven. Honor them in all your actions, and remember that you walk with their favor."
	experience_addition = 20
	minimal_masquerade = 2
	known_contacts = list("Prince", "Baron", "Sheriff")



/datum/outfit/job/voivode
	name = "Voivode"
	jobtype = /datum/job/vamp/voivode
	id = /obj/item/card/id/voivode
	uniform = /obj/item/clothing/under/vampire/voivode
	suit = /obj/item/clothing/suit/vampire/trench/voivode
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	belt = /obj/item/storage/belt/vampire/sheathe/longsword
	l_pocket = /obj/item/vamp/phone/voivode
	backpack_contents = list(/obj/item/vamp/keys/tzimisce/manor=1, /obj/item/melee/vampirearms/eguitar=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1)

/obj/effect/landmark/start/voivode
	name = "Voivode"
