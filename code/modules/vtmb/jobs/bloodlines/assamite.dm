/datum/job/vamp/banu
	title = "Barista"
	faction = "Vampire"
	total_positions = 12
	spawn_positions = 12
	supervisors = "the Traditions, and the Coffee Shop owner (Primogen Banu Haqim)."
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/banu
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_BANU

	allowed_species = list("Vampire", "Ghoul", "Human")
	species_slots = list("Vampire" = 8)

	v_duty = "You are a childe of Haqim! You are one of the many Banu Haqim within the city and judge kindred where they stand. The Banu Haqim operate a coffee shop as a clan cover within the city."
	duty = "You work at a little quiet coffee shop in the ghetto, and you have some inkling of what goes on there - Perhaps you are a retainer or ghoul of one of the higher-tier members - Either way, you turn a blind eye to it for one reason or another."
	minimal_masquerade = 0
	allowed_bloodlines = list(CLAN_BANU_HAQIM)

/datum/outfit/job/banu
	name = "banu"
	jobtype = /datum/job/vamp/banu
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/vamp/creditcard=1,
	)

/datum/outfit/job/banu/pre_equip(mob/living/carbon/human/H)
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

/obj/effect/landmark/start/assamite
	name = "Barista"
	icon_state = "Assistant"
