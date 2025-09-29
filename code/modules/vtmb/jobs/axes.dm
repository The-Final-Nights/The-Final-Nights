
/datum/job/vamp/axe_gang
	title = "Axe Gang"
	faction = "Vampire"
	total_positions = 8
	spawn_positions = 8
	supervisors = "the other Axes"
	selection_color = "#bb9d3d"

	outfit = /datum/outfit/job/axe_gangster

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_MECH_MINING, ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	bounty_types = CIV_JOB_RANDOM
	display_order = JOB_DISPLAY_ORDER_AXE_GANGSTER
	exp_type_department = EXP_TYPE_GANG

	allowed_species = list("Vampire", "Ghoul", "Human", "Kuei-Jin", "Werewolf")
	allowed_bloodlines = list(CLAN_NONE, CLAN_GANGREL, CLAN_GARGOYLE, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_CAPPADOCIAN, CLAN_NAGARAJA,)
	allowed_tribes = list("Ronin")


	duty = "Your gang answers to enigmatic leaders in Chinatown. In absence of their leadership, the Axes answer to nobody but themselves. Sell weapons using your Warehouse , do drugs, commit crime, and protect your own."
	v_duty = "You are a member of a Scarlet Screen known as the Axe Gang. Your leaders, the Screentenders, provide a place for outcasts like yourself to find fulfillment, and comradery. Sell weapons using your Warehouse , do drugs, commit crime, and protect your own."
	experience_addition = 10
	minimal_masquerade = 0

/datum/outfit/job/axe_gangster/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/cantonese)
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/axe_gangster
	name = "Axe Gangster"
	jobtype = /datum/job/vamp/axe_gang
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/id/supplytech
	l_pocket = /obj/item/vamp/phone/axe_gangster
	r_pocket = /obj/item/vamp/keys/axes
	backpack_contents = list(/obj/item/vamp/keys/supply, /obj/item/flashlight=1, /obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/clothing/mask/vampire/balaclava =1, /obj/item/gun/ballistic/automatic/vampire/beretta=2,/obj/item/ammo_box/magazine/semi9mm=2, /obj/item/melee/vampirearms/knife, /obj/item/hatchet)

/obj/effect/landmark/start/axe_gang
	name = "Axe Gang"
	icon_state = "bouncer"

/datum/job/vamp/axe_leader
	title = "Screentender"
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "nobody. You are beholden only to yourself."
	selection_color = "#bb9d3d"

	outfit = /datum/outfit/job/axe_leader

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE, ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE, ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR
	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM)
	bounty_types = CIV_JOB_RANDOM
	display_order = JOB_DISPLAY_ORDER_AXE_LEADER
	exp_type_department = EXP_TYPE_GANG

	known_contacts = list("Prince","Seneschal", "Sheriff", "Baron")
	allowed_species = list("Kuei-Jin", "Human")
	species_slots = list("Human" = 1, "Kuei-Jin" = 1)

	v_duty = "You lead a Scarlet Screen known as the Axe Gang. Wheather they are in the Know or not, Kindred, Werewolf, or a Hungry Dead like yourself, you offer shelter and fulfillment to these outcasts. Live up to your promises, and cultivate the Axe Gang."
	duty = "You lead a particular group, known as the Axe Gang, with the assistance of an enigmatic partner. You may understand the true identity of your co-conspirators, or not. Either way, they respect the position your co-leader and you hold."
	experience_addition = 20
	minimal_masquerade = 0

/datum/outfit/job/axe_leader/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/cantonese)
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/axe_leader
	name = "Screentender"
	jobtype = /datum/job/vamp/axe_leader
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/id/dealer
	l_pocket = /obj/item/vamp/phone/axe_leader
	r_pocket = /obj/item/vamp/keys/axes
	backpack_contents = list(/obj/item/vamp/keys/supply, /obj/item/flashlight=1, /obj/item/cockclock=1, /obj/item/passport=1, /obj/item/vamp/creditcard/rich=1, /obj/item/hatchet)

/obj/effect/landmark/start/axe_leader
	name = "Screentender"
	icon_state = "dealer"
