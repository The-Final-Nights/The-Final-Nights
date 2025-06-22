/datum/job/vamp/garou/spiral/lead
	title = "Endron Branch Lead"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Endron International")
	faction = "Vampire"

	minimal_renownrank = 4
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Board and Yourself."
	selection_color = "#015334"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 180
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endronlead

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRON

	minimal_masquerade = 5
	allowed_species = list("Werewolf")
	allowed_tribes = list("Black Spiral Dancers")

	known_contacts = null

	v_duty = "You are the current branch leader for the Endron Oil Refinery, operating out of San Francisco. Your job is to fuel production, keep your clowns in line, and to bring forth the banes that will ultimately allow the Wyrm to prevail over the Weaver."
	experience_addition = 25

/datum/outfit/job/garou/endronlead
	name = "Endron Branch Lead"
	jobtype = /datum/job/vamp/garou/spiral/lead

	id = /obj/item/card/id/garou/spiral/lead
	uniform =  /obj/item/clothing/under/pentex/pentex_executive_suit
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	suit = /obj/item/clothing/suit/pentex/pentex_labcoat_alt
	l_pocket = /obj/item/vamp/phone/endron_lead
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/prince=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/garou/endronlead/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/pentex/pentex_executiveskirt
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/garou/spiral/lead
	name = "Endron Branch Lead"
	icon_state = "Prince"

/datum/job/vamp/garou/spiral/executive
	title = "Endron Executive"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Endron International")
	faction = "Vampire"

	total_positions = 1
	spawn_positions = 1
	supervisors = "The Branch Lead, and yourself."
	selection_color = "#015334"

	minimal_renownrank = 3
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 150
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endronexec

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRON

	minimal_masquerade = 5
	allowed_species = list("Werewolf", "Vampire", "Human")
	allowed_tribes = list("Black Spiral Dancers")
	allowed_bloodlines = list(CLAN_TRUE_BRUJAH, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_BAALI, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_GIOVANNI, CLAN_SETITES, CLAN_TZIMISCE, CLAN_LASOMBRA, CLAN_NONE)

	known_contacts = null

	v_duty = "You are an acting executive for the Endron Oil Refinery, operating out of San Francisco. With discretion to the Branch Leader, a position you may aim for, your job is to fuel production, aid in bringing forth banes, and sate the heads of the Wyrm. Expand!"

/datum/outfit/job/garou/endronexec
	name = "Endron Executive"
	jobtype = /datum/job/vamp/garou/spiral/executive

	id = /obj/item/card/id/garou/spiral/executive
	uniform =  /obj/item/clothing/under/pentex/pentex_executive_suit
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	l_pocket = /obj/item/vamp/phone/endron_exec
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/seneschal=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/garou/endronexec/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/pentex/pentex_executiveskirt
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/garou/spiral/executive
	name = "Endron Executive"
	icon_state = "Clerk"

/datum/job/vamp/garou/spiral/affairs
	title = "Endron Internal Affairs Agent"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Endron International")
	faction = "Vampire"

	minimal_renownrank = 2
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Branch Lead."
	selection_color = "#015334"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 150
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endronaffairs

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRON

	minimal_masquerade = 4
	allowed_species = list("Werewolf")
	allowed_tribes = list("Black Spiral Dancers")

	known_contacts = null

	v_duty = "You are the internal affairs agent operating in the Endron Oil Refinery. You know the bloody and vile needs commanded of destruction will lead to jeopardy, and your duty is to see excellence on task rewarded and acknowledged, and curb the invariable atrocities that could endanger the greater plans of Pentex."

/datum/outfit/job/garou/endronaffairs
	name = "Endron Internal Affairs"
	jobtype = /datum/job/vamp/garou/spiral/executive

	id = /obj/item/card/id/garou/spiral/affairs
	uniform =  /obj/item/clothing/under/pentex/pentex_suit
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	l_pocket = /obj/item/vamp/phone/endron_affairs
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/veil_contract, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/garou/endronaffairs/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/pentex/pentex_suitskirt
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/garou/spiral/affairs
	name = "Endron Internal Affairs Agent"
	icon_state = "Clerk"

/datum/job/vamp/garou/spiral/secchief
	title = "Endron Chief of Security"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Endron International")
	faction = "Vampire"

	minimal_renownrank = 3
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Branch Lead."
	selection_color = "#015334"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 150
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endronsecchief

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM, TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRON

	minimal_masquerade = 4
	allowed_species = list("Werewolf")
	allowed_tribes = list("Black Spiral Dancers")

	known_contacts = null

	v_duty = "You are an acting chief of security for the Endron Oil Refinery, operating out of San Francisco. With discretion to the Branch Leader, your job is to keep the complex and it's source of taint under control with the help of your security team, and to turn over contract violators to internal affairs or the executives."

/datum/outfit/job/garou/endronsecchief
	name = "Endron Chief of Security"
	jobtype = /datum/job/vamp/garou/spiral/secchief

	id = /obj/item/card/id/garou/spiral/secchief
	uniform =  /obj/item/clothing/under/pentex/pentex_turtleneck
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	gloves = /obj/item/clothing/gloves/vampire/work
	head = /obj/item/clothing/head/pentex/pentex_beret
	suit = /obj/item/clothing/suit/vampire/vest
	glasses = /obj/item/clothing/glasses/vampire/sun
	l_pocket = /obj/item/vamp/phone/endron_sec_chief
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/veil_contract, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/spiral/secchief
	name = "Endron Chief of Security"
	icon_state = "Sheriff"

/datum/job/vamp/garou/spiral/sec
	title = "Endron Security Agent"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Endron International")
	faction = "Vampire"

	total_positions = 5
	spawn_positions = 5
	supervisors = "The Branch Lead and the Security Chief."
	selection_color = "#015334"

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 100
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endronsec

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRON

	minimal_masquerade = 3
	allowed_species = list("Werewolf", "Vampire", "Human")
	allowed_tribes = list("Black Spiral Dancers")
	allowed_bloodlines = list(CLAN_TRUE_BRUJAH, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_BAALI, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_GIOVANNI, CLAN_SETITES, CLAN_TZIMISCE, CLAN_LASOMBRA, CLAN_NONE)

	known_contacts = null

	v_duty = "You are an acting security for the Endron Oil Refinery, operating out of San Francisco. Under the chief of security's direction, your job is to keep the complex free of nosy meddlers, pick up contract violators, and to assist the chief in tackling threats to corporate assets."

/datum/outfit/job/garou/endronsec
	name = "Endron Security Agent"
	jobtype = /datum/job/vamp/garou/spiral/sec

	id = /obj/item/card/id/garou/spiral/sec
	uniform =  /obj/item/clothing/under/pentex/pentex_shortsleeve
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/vest
	l_pocket = /obj/item/vamp/phone/endron_security
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/spiral/sec
	name = "Endron Security Agent"
	icon_state = "Hound"

/datum/job/vamp/garou/spiral/employee
	title = "Endron Employee"
	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf")
	department_head = list("Endron International")
	allowed_tribes = list("Black Spiral Dancers", "Ronin")
	allowed_bloodlines = list(CLAN_TRUE_BRUJAH, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_BAALI, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_GIOVANNI, CLAN_SETITES, CLAN_TZIMISCE, CLAN_LASOMBRA, CLAN_NONE)
	faction = "Vampire"
	selection_color = "#015334"

	total_positions = 5
	spawn_positions = 5
	supervisors = "The Branch Lead."

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 50
	exp_type_department = EXP_TYPE_SPIRAL

	outfit = /datum/outfit/job/garou/endron

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_ENDRON

	minimal_masquerade = 3

	known_contacts = null

	v_duty ="You are an employee for the Endron Oil Refinery, operating out of San Francisco. Your bosses can be a little strange; give credence to the security team and executives for tasks on the night shift, and avoid getting negative attention from the branch manager or internal affairs."

/datum/outfit/job/garou/endron
	name = "Endron Employee"
	jobtype = /datum/job/vamp/garou/spiral/employee

	id = /obj/item/card/id/garou/spiral/employee
	uniform = /obj/item/clothing/under/pentex/pentex_longleeve
	gloves = /obj/item/clothing/gloves/vampire/work
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/pentex
	l_pocket = /obj/item/vamp/phone/endron_employee
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/spiral/employee
	name = "Endron Employee"
	icon_state = "Hound"
