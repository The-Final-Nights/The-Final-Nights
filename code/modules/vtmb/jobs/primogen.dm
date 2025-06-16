/datum/job/vamp/primogen_malkavian
	title = "Primogen Malkavian"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/malkav

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_MALKAVIAN
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_MALKAVIAN)
	minimal_generation = 12
//	minimum_character_age = 100
	minimum_vampire_age = 5 // Actually Malkavian Primo is whoever showed for work that day. Crazy bunch.

	v_duty = "Offer your infinite knowledge to Prince of the City. You likely have a hold over the local hospital, make good use of it and ensure the blood bags remain available."
	experience_addition = 20
	minimal_masquerade = 5
	known_contacts = list("Prince")

/datum/outfit/job/malkav
	name = "Primogen Malkavian"
	jobtype = /datum/job/vamp/primogen_malkavian

	ears = /obj/item/p25radio
	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/primogen_malkavian
	suit = /obj/item/clothing/suit/vampire/trench/malkav
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	head = /obj/item/clothing/head/vampire/malkav
	l_pocket = /obj/item/vamp/phone/malkavian_primo
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/malkav/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon)

/datum/outfit/job/malkav/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		suit = null
		head = null
		uniform = /obj/item/clothing/under/vampire/primogen_malkavian/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/job/vamp/primogen_nosferatu
	title = "Primogen Nosferatu"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/nosferatu

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_NOSFERATU
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_NOSFERATU)
	minimal_generation = 12
//	minimum_character_age = 100 //Uncomment if age restriction wanted
	minimum_vampire_age = 50

	v_duty = "Offer your infinite knowledge to Prince of the City, and run the warren, your domain watches over the sewers."
	experience_addition = 20
	minimal_masquerade = 5
	known_contacts = list("Prince")

/datum/outfit/job/nosferatu
	name = "Primogen Nosferatu"
	jobtype = /datum/job/vamp/primogen_nosferatu

	id = /obj/item/card/id/primogen
	mask = /obj/item/clothing/mask/vampire/shemagh
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/nosferatu_primo
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/nosferatu/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon)

/datum/outfit/job/nosferatu/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/job/vamp/primogen_ventrue
	title = "Primogen Ventrue"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/ventrue

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_VENTRUE
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_VENTRUE)
	minimal_generation = 12
//	minimum_character_age = 100 //Uncomment if age restriction wanted
	minimum_vampire_age = 50

	v_duty = "Offer your infinite knowledge to Prince of the City. Maintain the local Jazz Club, in front of the Tower, and its Elysium."
	experience_addition = 20
	minimal_masquerade = 5
	known_contacts = list("Prince")

/datum/outfit/job/ventrue
	name = "Primogen Ventrue"
	jobtype = /datum/job/vamp/primogen_ventrue

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/ventrue_primo
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/ventrue/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon)

/datum/outfit/job/ventrue/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/job/vamp/primogen_toreador
	title = "Primogen Toreador"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/toreador

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TOREADOR
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_TOREADOR)
	minimal_generation = 12
//	minimum_character_age = 100 //Uncomment if age restriction wanted
	minimum_vampire_age = 50

	v_duty = "Offer your infinite knowledge to Prince of the City. Take care of the Strip Club and its Elysium, for it is your domain and a social center within the city."
	experience_addition = 20
	minimal_masquerade = 5
	known_contacts = list("Prince")

/datum/outfit/job/toreador
	name = "Primogen Toreador"
	jobtype = /datum/job/vamp/primogen_toreador

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/primogen_toreador
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/toreador_primo
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/toreador/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon, /obj/item/gun/ballistic/automatic/vampire/beretta/toreador=1, /obj/item/ammo_box/magazine/semi9mm/toreador=1)

/datum/outfit/job/toreador/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/primogen_toreador/female
		shoes = /obj/item/clothing/shoes/vampire/heels/red

/datum/job/vamp/primogen_banu
	title = "Primogen Banu Haqim"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions and the Laws of Haqim"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/banuprim

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BANUPRIM
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_BANU_HAQIM)
	minimal_generation = 12
//	minimum_character_age = 100 //Uncomment if age restriction wanted
	minimum_vampire_age = 50

	v_duty = "Offer your infinite knowledge to Prince of the City, while overseeing the Banu Haqim in the city. Monitor their contracts and ensure they remain true to the ways of the Clan. You have an official cover with the Police Department as a local civilian consultant, ensure things run smoothly, on either end."
	experience_addition = 20
	minimal_masquerade = 5
	known_contacts = list("Prince")

/datum/outfit/job/banuprim
	name = "Primogen Banu Haqim"
	jobtype = /datum/job/vamp/primogen_banu

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/turtleneck_navy
	suit = /obj/item/clothing/suit/vampire/vest
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone/banu_primo
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/banuhaqim/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon)

/obj/effect/landmark/start/primogen_banu
	name = "Primogen Banu Haqim"
	icon_state = "Assistant"

/datum/job/vamp/primogen_lasombra
	title = "Primogen Lasombra"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions and the Friends of the Night"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/lasombraprim

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_LASOMBRAPRIM
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_LASOMBRA)
	minimal_generation = 12
//	minimum_character_age = 100
	minimum_vampire_age = 5 // Heavily meritocratic and new to the Camarilla, plus, Julia Sowinski *shrug

	v_duty = "Offer your infinite knowledge to Prince of the City. Monitor those of your Clan and your lesser cousins, while holding a Court of Blood as need be, for all it takes for the Camarilla to turn on you is one mistake. You and Your Clan were given a domain in the local Church and in the vicinity of a swarm of Lupines, keep matters under control."
	experience_addition = 20
	minimal_masquerade = 5
	known_contacts = list("Prince")

/datum/outfit/job/lasombraprim
	name = "Primogen Lasombra"
	jobtype = /datum/job/vamp/primogen_lasombra

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/turtleneck_black
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone/lasombra_primo
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/lasombra/primogen=1,/obj/item/passport=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon)

/datum/outfit/job/primogen_lasombra/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/business
		shoes = /obj/item/clothing/shoes/vampire/heels/red

/obj/effect/landmark/start/primogen_lasombra
	name = "Primogen Lasombra"
	icon_state = "Assistant"
