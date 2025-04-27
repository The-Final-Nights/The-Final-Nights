/datum/job/vamp/nagaraja
	title = "Butcher"
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Traditions"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/nagaraja
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_NAGARAJA

	v_duty = "Guh"
	duty = "Guh"
	minimal_masquerade = 0
	allowed_bloodlines = list("Nagaraja")

/datum/outfit/job/nagaraja
	name = "nagaraja"
	jobtype = /datum/job/vamp/nagaraja
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/vamp/creditcard=1,
	)

/datum/outfit/job/nagaraja/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clane)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clane.male_clothes)
				uniform = H.clane.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clane.female_clothes)
				uniform = H.clane.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/nagaraja
	name = "Butcher"
	icon_state = "Assistant"
