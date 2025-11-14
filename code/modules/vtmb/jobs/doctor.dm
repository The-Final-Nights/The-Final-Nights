
/datum/job/vamp/vdoctor
	title = "Doctor"
	department_head = list("Clinic Director")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Camarilla or the Anarchs"
	selection_color = "#80D0F4"
	exp_type_department = EXP_TYPE_CLINIC


	outfit = /datum/outfit/job/vdoctor

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	allowed_species = list("Vampire", "Ghoul", "Human", "Werewolf", "Kuei-Jin")
	display_order = JOB_DISPLAY_ORDER_DOCTOR
	bounty_types = CIV_JOB_MED

	v_duty = "Help your fellow kindred in all matters medicine related. Sell blood. Keep your human colleagues ignorant. Remember, this is a Malkavian Domain, even if they aren't aware of you personally."
	duty = "You are on the night shift at the local clinic. Your eccentric bosses seem to be keeping a close eye on your work."
	experience_addition = 15
	allowed_bloodlines = list(CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_NAGARAJA, CLAN_BAALI, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_GIOVANNI, CLAN_SETITES, CLAN_TZIMISCE, CLAN_LASOMBRA, CLAN_NONE, CLAN_KIASYD)
	known_contacts = list("Clinic Director")

/datum/outfit/job/vdoctor
	name = "Doctor"
	jobtype = /datum/job/vamp/vdoctor

	ears = /obj/item/p25radio
	id = /obj/item/card/id/clinic
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/clinic
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/storage/firstaid/medical=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/quickcarry)

/obj/effect/landmark/start/vdoctor
	name = "Doctor"
	icon_state = "Doctor"


/datum/job/vamp/vdirector
	title = "Clinic Director"
	department_head = list("Primogen Malkavian")
	faction = "Vampire"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Patron of the Hospital (Malkavian Primogen)"
	selection_color = "#80D0F4"
	exp_type_department = EXP_TYPE_CLINIC


	outfit = /datum/outfit/job/vdirector

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	allowed_species = list("Ghoul", "Human")
	display_order = JOB_DISPLAY_ORDER_CLINICS_DIRECTOR
	bounty_types = CIV_JOB_MED

	v_duty = "Keep Saint John's clinic up and running, and sell blood to the vegan kindred who need it. Keep your human colleagues ignorant. Serve the best interests of the hospital's generous eccentric Malkavian Primogen patron who finances everything."
	duty = "Keep Saint John's Hospital up and running on behalf of your hospital's eccentric patron who finances it. Keep your underlings and colleagues ignorant of the truth, as much as possible. Collect blood donations from locals for the day shift."
	experience_addition = 15
	// allowed_bloodlines = list(CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_SALUBRI, CLAN_BAALI, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_GIOVANNI, CLAN_SETITES, CLAN_TZIMISCE, CLAN_LASOMBRA, CLAN_NONE, CLAN_KIASYD)
	known_contacts = list("Primogen Malkavian")

/datum/outfit/job/vdirector
	name = "Clinic Director"
	jobtype = /datum/job/vamp/vdirector

	ears = /obj/item/p25radio
	id = /obj/item/card/id/clinic/director
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat/director
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/vamp/keys/clinics_director
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/storage/firstaid/medical=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/quickcarry)

/obj/effect/landmark/start/vdirector
	name = "Clinic Director"
	icon_state = "Doctor"

/datum/job/vamp/mortattendant
	title = "Mortuary Attendant"
	faction = "Vampire"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Traditions, or the Clinic Director"
	selection_color = "#80D0F4"
	exp_type_department = EXP_TYPE_CLINIC
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_PHARMACY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_PHARMACY)
	outfit = /datum/outfit/job/mortattendant
	antag_rep = 7
	paycheck = PAYCHECK_MEDIUM

	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_MORTATTENDANT

	allowed_species = list("Vampire", "Ghoul", "Human")
	species_slots = list("Vampire" = 4, "Ghoul" = 50, "Human" = 50)

	v_duty = "As one of the outcast practicioners of Necromancy, you're hiding out in this city for one reason or another. You're laying low, acting as a Mortician for the local hospital, dealing with the bodies, and staying out of the other doctors way."
	duty = "You work in the morgue for the local hospital, dealing with the dead bodies and keeping your workspace clean, while staying out of the way of the other doctors."
	allowed_bloodlines = list(CLAN_NAGARAJA, CLAN_CAPPADOCIAN)
	minimal_masquerade = 0

/datum/outfit/job/mortattendant
	name = "Mortuary Attendant"
	jobtype = /datum/job/vamp/mortattendant
	ears = /obj/item/p25radio
	id = /obj/item/card/id/clinic/mortattendant
	uniform = /obj/item/clothing/under/vampire/nurse/nurseb
	shoes = /obj/item/clothing/shoes/vampire/white
	r_pocket = /obj/item/vamp/keys/mortician
	l_pocket = /obj/item/vamp/phone
	gloves = /obj/item/clothing/gloves/vampire/latex
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/vamp/creditcard=1,
		/obj/item/cockclock=1
	)

	skillchips = list(/obj/item/skillchip/entrails_reader, /obj/item/skillchip/quickcarry)


/obj/effect/landmark/start/mortattendant
	name = "Mortuary Attendant"
	icon_state = "Doctor"
