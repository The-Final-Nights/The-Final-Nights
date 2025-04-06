/datum/job/vamp/mandarin
	title = "Mandarin of the Laughable Promise"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("The Mandarin of the Laughable Promise.")
	head_announce = list(RADIO_CHANNEL_SECURITY)
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Ancestor."
	selection_color = "#bb9d3d"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 300
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_GANG

	outfit = /datum/outfit/job/mandarin

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM, TRAIT_ROYAL_METABOLISM)

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY,
					ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_AUX_BASE,
					ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING, ACCESS_EVA, ACCESS_TELEPORTER,
					ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY,
					ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_AUX_BASE,
					ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING, ACCESS_EVA,
					ACCESS_HEADS, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_COURT_MANDARIN
	bounty_types = CIV_JOB_SEC

	allowed_species = list("Kuei-Jin")
	v_duty = "You are a Mandarin of the Laughable Promise! The Laughable Promise is a court based out of the cities Chinatown area. Keep the political enemies of the Court at bay through diplomacy. Keep Chinatown safe."

/datum/outfit/job/mandarin
	name = "Mandarin of the Laughable Promise"
	jobtype = /datum/job/vamp/mandarin

	id = /obj/item/card/id/mandarinbadge
	uniform = /obj/item/clothing/under/vampire/sheriff
	belt = /obj/item/storage/belt/vampire/sheathe/rapier
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest
	gloves = /obj/item/clothing/gloves/vampire/leather
	head = /obj/item/clothing/head/hos/beret
	glasses = /obj/item/clothing/glasses/vampire/sun
	r_pocket = /obj/item/vamp/keys/ancestor
	backpack_contents = list(/obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/masquerade_contract=1, /obj/item/vamp/creditcard/elder=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/creaming_oni/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
	H.grant_language(/datum/language/cantonese)
	H.grant_language(/datum/language/mandarin)
		uniform = /obj/item/clothing/under/vampire/sheriff/female

/obj/effect/landmark/start/screamingoni
	name = "Mandarin"
	icon_state = "Sheriff"
