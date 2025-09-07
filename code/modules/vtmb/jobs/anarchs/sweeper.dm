
/datum/job/vamp/sweeper
	title = "Sweeper"
	department_head = list("Baron")
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Baron"
	selection_color = "#434343"

	outfit = /datum/outfit/job/sweeper

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_SWEEPER
	known_contacts = list("Baron","Bouncer","Emissary","Sweeper")
	allowed_bloodlines = list(CLAN_BAALI, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_TRUE_BRUJAH, CLAN_BRUJAH, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TREMERE, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_TZIMISCE, CLAN_NONE, CLAN_VENTRUE, CLAN_LASOMBRA, CLAN_GARGOYLE, CLAN_KIASYD, CLAN_CAPPADOCIAN, CLAN_SETITES, CLAN_SALUBRI_WARRIOR, CLAN_SALUBRI, CLAN_NAGARAJA)

	v_duty = "You are the observer of the San Francisco Barony. You watch out for any new kindred, suspicious individuals, and any new rumors near the anarch turf, and then report it to your crew."
	minimal_masquerade = 2
	experience_addition = 15

/datum/outfit/job/sweeper
	name = "Sweeper"
	jobtype = /datum/job/vamp/sweeper

	ears = /obj/item/p25radio
	id = /obj/item/card/id/sweeper
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/vamp/phone/sweeper
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/keys/hack=1, /obj/item/vamp/creditcard=1, /obj/item/binoculars = 1)

/obj/effect/landmark/start/sweeper
	name = "Sweeper"
	icon_state = "Bouncer"
