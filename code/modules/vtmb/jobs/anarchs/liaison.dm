
/datum/job/vamp/liaison
	title = "Liaison"
	department_head = list("baron")
	faction = "Vampire"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Baron and New Promise Mandarinate"
	selection_color = "#434343"

	outfit = /datum/outfit/job/liaison

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_LIAISON
	known_contacts = list("Baron","Bouncer","Emissary","Sweeper")
	allowed_species = list("Kuei-Jin")

	v_duty = "You are a liaison to the San Francisco Barony, from the New Promise Mandarinate. Train the Hin of the Barony on the delicate means of Shadow War, and ensure that the rights of the Hungry Dead are respected in this City."

/datum/outfit/job/liaison/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/datum/outfit/job/liaison
	name = "liaison"
	jobtype = /datum/job/vamp/liaison
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	id = /obj/item/card/id/liaison
	l_pocket = /obj/item/vamp/phone/liaison
	r_pocket = /obj/item/vamp/keys/anarch
	backpack_contents = list(/obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/liaison
	name = "Liaison"
	icon_state = "Bouncer"
