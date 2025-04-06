/datum/job/vamp/Ancestor
	title = "Ancestor of the Laughable Promise"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Scarlet Screen")
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Camarilla and the Traditions. Yourself."
	selection_color = "#bd3327"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_GANG

	outfit = /datum/outfit/job/ancestor

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_COURT_ANCESTOR

	minimal_generation = 10	//Uncomment when players get exp enough
	minimal_masquerade = 5
	allowed_species = list("Kuei-Jin")

	v_duty = "You are the ruling Ancestor. Ruling the Court of the Laughable Promise, members of the Wu of each dharma fight amongst each other. Keep the Court together or die trying."

/datum/job/vamp/ancestor/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, PROC_REF(minor_announce), "Ancestor [H.real_name] has arrived in the district!"))

/datum/outfit/job/ancestor
	name = "Ancestor"
	jobtype = /datum/job/vamp/ancestor

	id = /obj/item/card/id/ancestorbadge
	glasses = /obj/item/clothing/glasses/vampire/sun
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform =  /obj/item/clothing/under/vampire/ancestor
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/vamp/phone/ancestor
	r_pocket = /obj/item/vamp/keys/ancestor
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/elder=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/ancestor/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/ancestor/female
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/ancestor
	name = "Ancestor"
	icon_state = "ancestor"
