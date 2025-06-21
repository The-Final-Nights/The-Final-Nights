
/datum/job/vamp/emissary
	title = "Emissary"
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/emissary

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	departments = DEPARTMENT_BITFLAG_ANARCH

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_EMISSARY
	known_contacts = list("Baron","Bouncer","Emissary","Sweeper","Prince","Sheriff")
	allowed_bloodlines = list(CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_TRUE_BRUJAH, CLAN_BRUJAH, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TREMERE, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_TZIMISCE, CLAN_NONE, CLAN_VENTRUE, CLAN_LASOMBRA, CLAN_GARGOYLE, CLAN_KIASYD, CLAN_CAPPADOCIAN, CLAN_SETITES, CLAN_SALUBRI, CLAN_SALUBRI_WARRIOR)

	v_duty = "You are a diplomat for the anarchs. Make deals, keep the peace, all through words, not violence. But the latter may come to pass if the former fails."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/emissary
	name = "emissary"
	jobtype = /datum/job/vamp/emissary

	ears = /obj/item/p25radio
	id = /obj/item/card/id/emissary
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/emissary
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard/rich=1)

/datum/outfit/job/emissary/pre_equip(mob/living/carbon/human/H)
	..()

/obj/effect/landmark/start/emissary
	name = "Emissary"
	icon_state = "Bouncer"
