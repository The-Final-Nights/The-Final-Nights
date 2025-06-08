
/datum/job/vamp/triad_soldier
	title = "Triad Soldier"
	department_head = list("Triad Leadership")
	faction = "Vampire"
	total_positions = 8
	spawn_positions = 8
	supervisors = " the Triads"
	selection_color = "#bb9d3d"

	outfit = /datum/outfit/job/triad_soldier

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TRIAD_GANGSTER
	exp_type_department = EXP_TYPE_GANG

	allowed_species = list("Human", "Werewolf", "Kuei-Jin")
	minimal_generation = 13

	duty = "Make money, do drugs, fight law. Your hideout is the laundromat in Chinatown."
	experience_addition = 10
	minimal_masquerade = 0

/datum/outfit/job/triad_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/cantonese)
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/triad_soldier
	name = "Triad Soldier"
	jobtype = /datum/job/vamp/triad_soldier
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/cockclock
	l_pocket = /obj/item/vamp/phone/triads_soldier
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/triads
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/clothing/mask/vampire/balaclava =1, /obj/item/gun/ballistic/automatic/vampire/beretta=2,/obj/item/ammo_box/magazine/semi9mm=2, /obj/item/melee/vampirearms/knife)

//Forest Remap Addition

/datum/job/vamp/temple/elder
	title = "Elder Monk"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Your Dharma")

	selection_color = "#FF6A00"
	faction = "Vampire"
	allowed_species = list("Kuei-Jin")

	total_positions = 1
	spawn_positions = 1
	supervisors = "Your Dharma and Ancestors."

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 180
	exp_type_department = EXP_TYPE_TEMPLE

	outfit = /datum/outfit/job/temple/elder

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_TEMPLE

	minimal_masquerade = 5

	known_contacts = null

	v_duty = "You must follow the teachings of your dharma and instill such knowledge in the lesser members of the temple. Yet also maintain the functionality of the Temple itself."
	experience_addition = 25

/datum/outfit/job/temple/elder
	name = "Elder Monk"
	jobtype = /datum/job/vamp/temple/elder

	id = /obj/item/passport
	uniform =  /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/kasaya
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/kuei_jin
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/temple/elder
	name = "Elder Monk"
	icon_state = "Prince"

/datum/job/vamp/temple/senior
	title = "Senior Monk"
	department_head = list("Your Dharma")

	selection_color = "#FF6A00"
	faction = "Vampire"
	allowed_species = list("Kuei-Jin")

	total_positions = 4
	spawn_positions = 4
	supervisors = "Your Dharma, The Elder and Ancestors."

	minimal_player_age = 25
	exp_requirements = 180
	exp_type_department = EXP_TYPE_TEMPLE

	outfit = /datum/outfit/job/temple/senior

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_TEMPLE

	minimal_masquerade = 4

	known_contacts = null

	v_duty = "You must follow the teachings of your dharma, yet also maintain the functionality of the Temple itself."

/datum/outfit/job/temple/senior
	name = "Senior Monk"
	jobtype = /datum/job/vamp/temple/senior

	id = /obj/item/passport
	uniform =  /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/kasaya
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/kuei_jin
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/temple/senior
	name = "Senior Monk"
	icon_state = "Clerk"

/datum/job/vamp/temple/monk
	title = "Monk"
	department_head = list("Your Dharma")

	selection_color = "#FF6A00"
	faction = "Vampire"
	allowed_species = list("Kuei-Jin")

	total_positions = -1
	spawn_positions = -1
	supervisors = "Your Dharma, The Elder and Ancestors."

	minimal_player_age = 25
	exp_requirements = 0
	exp_type_department = EXP_TYPE_TEMPLE

	outfit = /datum/outfit/job/temple/monk

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_TEMPLE

	minimal_masquerade = 0

	known_contacts = null

	v_duty = "You must follow the teachings of your dharma, yet also maintain the functionality of the Temple itself."

/datum/outfit/job/temple/monk
	name = "Monk"
	jobtype = /datum/job/vamp/temple/monk

	id = /obj/item/passport
	uniform =  /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/kasaya
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/kuei_jin
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/temple/monk
	name = "Monk"
	icon_state = "Hound"

/datum/job/vamp/temple/guardian
	title = "Temple Guardian"
	department_head = list("The Temple Itself")

	selection_color = "#FF6A00"
	faction = "Vampire"
	allowed_species = list("Kuei-Jin", "Werewolf")

	total_positions = 2
	spawn_positions = 2
	supervisors = "The Elder of the Temple"

	minimal_player_age = 25
	exp_requirements = 0
	exp_type_department = EXP_TYPE_TEMPLE

	outfit = /datum/outfit/job/temple/guardian

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_TEMPLE

	minimal_masquerade = 0

	known_contacts = null

	v_duty = "For whatever reason, you have been assigned to safeguard and ensure the sanctity of this temple, be you from the Beast Courts or another Kuei-Jin."

/datum/outfit/job/temple/guardian
	name = "Guardian"
	jobtype = /datum/job/vamp/temple/guardian

	id = /obj/item/passport
	uniform =  /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/kasaya
	belt = /obj/item/storage/belt/vampire/sheathe/longsword
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/kuei_jin
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1, /obj/item/melee/vampirearms/longsword=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/temple/guardian
	name = "Temple Guardian"
	icon_state = "Sheriff"

/datum/job/vamp/temple/novitiate
	title = "Novitiate"
	department_head = list("Your Dharma")

	selection_color = "#FF6A00"
	faction = "Vampire"
	allowed_species = list("Kuei-Jin")

	total_positions = -1
	spawn_positions = -1
	supervisors = "Your Dharma, The Elder and Ancestors."

	minimal_player_age = 25
	exp_requirements = 0
	exp_type_department = EXP_TYPE_TEMPLE

	outfit = /datum/outfit/job/temple/monk

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_ASSISTANT
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_TEMPLE

	minimal_masquerade = 0

	known_contacts = null

	v_duty = "You have a lot to learn about the dance of life, study the dharmas well!"

/datum/outfit/job/temple/novitiate
	name = "Novitiate"
	jobtype = /datum/job/vamp/temple/novitiate

	id = /obj/item/passport
	uniform =  /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/kasaya
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/kuei_jin
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/temple/novitiate
	name = "Novitiate"
	icon_state = "Assistant"