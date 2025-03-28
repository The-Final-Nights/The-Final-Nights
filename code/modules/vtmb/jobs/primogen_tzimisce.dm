/datum/job/vamp/primogen_tzimisce
	title = "Primogen Tzimisce"
	department_head = list("Justicar")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Traditions"
	selection_color = "#4f0404"

	outfit = /datum/outfit/job/tzi_primogen

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_TZIMISCE
	exp_type_department = EXP_TYPE_COUNCIL

	allowed_species = list("Vampire")
	allowed_bloodlines = list("Tzimisce")
	minimal_generation = 10

	v_duty = "Offer your infinite knowledge to Prince of the City. You are the bridge between the Camarilla and the Old Country. Maintain your domain and advise the Prince on matters related to the Tzimisce."
	experience_addition = 20
	minimal_masquerade = 5
	my_contact_is_important = TRUE
	known_contacts = list("Prince", "Voivode")

/datum/outfit/job/tzi_primogen
	name = "Primogen Tzimisce"
	jobtype = /datum/job/vamp/primogen_tzimisce

	id = /obj/item/card/id/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench/voivode
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone/tzimisce
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/tzimisce/primogen=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/elder=1, /obj/item/card/id/whip, /obj/item/card/id/steward, /obj/item/card/id/myrmidon)

/datum/outfit/job/tzi_primogen/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/primogen_tzimisce
	name = "Primogen Tzimisce"
	icon_state = "Assistant"
