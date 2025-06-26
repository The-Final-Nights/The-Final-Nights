/datum/job/vamp/lasombra
	title = "Church Caretaker"
	faction = "Vampire"
	total_positions = 12
	spawn_positions = 12
	supervisors = "Your Primogen."
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/lasombra
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_LASOMBRA

	allowed_species = list("Vampire", "Ghoul")
	species_slots = list("Vampire" = 6, "Ghoul" = 50)

	v_duty = "You are a member of the local Lasombra! You maintain the haven set up in the attic of the local Church, owned by your Clan Primogen."
	duty = "You are a Ghoul in service to the local Lasombra or its Primogen, get used to the dark of the upper floors and good luck with what you will endure. They rely on you, as much as they may say otherwise."
	minimal_masquerade = 0
	allowed_bloodlines = list(CLAN_LASOMBRA)

/datum/outfit/job/lasombra
	name = CLAN_LASOMBRA
	jobtype = /datum/job/vamp/lasombra
	l_pocket = /obj/item/vamp/phone/lasombra_caretaker
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/vamp/creditcard=1,
	)

/datum/outfit/job/lasombra/pre_equip(mob/living/carbon/human/H)
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

/obj/effect/landmark/start/lasombra
	name = "Monestary Monk"
	icon_state = "Assistant"
