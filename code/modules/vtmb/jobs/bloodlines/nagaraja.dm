/datum/job/vamp/nagaraja
	title = "Mortuary Attendant"
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Traditions, or the Clinic Director"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/nagaraja
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_NAGARAJA

	allowed_species = list("Vampire", "Ghoul", "Human")
	species_slots = list("Vampire" = 4, "Ghoul" = 50, "Human" = 50)

	v_duty = "One of the Nagaraja bloodline, you're hiding out in this city for one reason or another. You're laying low, acting as a Mortician for the local hospital, dealing with the bodies, and staying out of the other doctors way."
	duty = "You work in the morgue for the local hospital, dealing with the dead bodies and keeping your workspace clean, while staying out of the way of the other doctors."
	allowed_bloodlines = list(CLAN_NAGARAJA)
	minimal_masquerade = 0

/datum/outfit/job/nagaraja
	name = CLAN_NAGARAJA
	jobtype = /datum/job/vamp/nagaraja
	r_pocket = /obj/item/vamp/keys/mortician
	l_pocket = /obj/item/vamp/phone
	gloves = /obj/item/clothing/gloves/vampire/latex
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/vamp/creditcard=1,
	)

/datum/outfit/job/nagaraja/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clan)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clan.male_clothes)
				uniform = H.clan.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clan.female_clothes)
				uniform = H.clan.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/nagaraja
	name = "Mortuary Attendant"
	icon_state = "Assistant"
