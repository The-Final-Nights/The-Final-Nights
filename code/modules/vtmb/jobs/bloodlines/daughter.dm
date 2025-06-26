/datum/job/vamp/daughterof
	title = "Cabaret Worker"
	faction = "Vampire"
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Traditions"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/daughterof
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_DAUGHTER

	allowed_species = list("Vampire","Ghoul")
	species_slots = list("Vampire" = 6, "Ghoul" = 50)

	v_duty = "You are either a Daughter of Cacophony or a Son of Discord. You work at the Cabaret and sing masterful songs yet the singing never stops within your head..."
	duty = "You work at the local Cabaret, and have some inkling of the oddities going on with the owners, but for one reason or another you don't really care enough to bring it up. Perhaps the pay is nice, or you are personally involved with one of them."
	minimal_masquerade = 0
	allowed_bloodlines = list(CLAN_DAUGHTERS_OF_CACOPHONY)

/datum/outfit/job/daughterof
	name = "Cabaret Worker"
	jobtype = /datum/job/vamp/daughterof
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/vamp/creditcard=1,
	)

/datum/outfit/job/daughterof/pre_equip(mob/living/carbon/human/H)
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

/obj/effect/landmark/start/daughterof
	name = "Cabaret Worker"
	icon_state = "Assistant"
