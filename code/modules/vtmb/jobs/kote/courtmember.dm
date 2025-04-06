/datum/job/vamp/court_member
	title = "Court Member"
	department_head = list("The Mandarin of the Laughable Promise")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = " the Triads"
	selection_color = "#bb9d3d"

	outfit = /datum/outfit/job/court_member

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JJOB_DISPLAY_ORDER_COURT_MEMBER
	exp_type_department = EXP_TYPE_GANG

	allowed_species = list("Kuei-jin")

	duty = "You are a Kuei-Jin who has gone through training and are no longer a Chih-Mei. You serve the Court regardless of dharmic differences."
	minimal_masquerade = 0
	my_contact_is_important = FALSE

/datum/outfit/job/court_member/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/cantonese)
	H.grant_language(/datum/language/mandarin)
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/court_member
	name = "Court Retainer"
	jobtype = /datum/job/vamp/court_member
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/id/courtmemberbadge
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/courtmemberkeys
	backpack_contents = list(/obj/item/passport=1, /obj/item/vamp/creditcard=1, /obj/item/clothing/mask/vampire/balaclava =1, /obj/item/gun/ballistic/automatic/vampire/beretta=2,/obj/item/ammo_box/magazine/semi9mm=2, /obj/item/melee/vampirearms/knife)
