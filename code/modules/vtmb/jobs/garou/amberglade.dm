#define AMBERGLADE_ALLOWED_TRIBES list("Galestalkers", "Ghost Council", "Hart Wardens", "Get of Fenris", "Black Furies", "Silent Striders", "Red Talons", "Silver Fangs", "Stargazers")

/datum/job/vamp/garou/amberglade/council
	title = "Amberglade Councillor"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("The Litany")

	selection_color = "#69e430"
	faction = "Vampire"
	allowed_species = list("Werewolf")
	allowed_tribes = AMBERGLADE_ALLOWED_TRIBES
	minimal_renownrank = 4

	total_positions = 3
	spawn_positions = 3
	supervisors = "The Litany and Yourself."

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 180
	exp_type_department = EXP_TYPE_AMBERGLADE

	outfit = /datum/outfit/job/garou/gladecouncil

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_AMBERGLADE

	minimal_masquerade = 5

	known_contacts = null

	v_duty = "You, along with any of the other two council members present, oversee the fate of the Sept. Your duty is to ensure the Keeper, the Truthfinder, and the Warder are able to keep the peace in the Sept, and to do your utmost to keep your territory clean of banes."
	experience_addition = 25

/datum/outfit/job/garou/gladecouncil
	name = "Amberglade Councillor"
	jobtype = /datum/job/vamp/garou/amberglade/council

	id = /obj/item/card/id/garou/glade/council
	uniform =  /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/coat/winter/alt
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	l_pocket = /obj/item/vamp/phone
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/glade/council
	name = "Amberglade Councillor"
	icon_state = "Prince"

/datum/job/vamp/garou/amberglade/keeper
	title = "Amberglade Keeper"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("The Litany")

	selection_color = "#69e430"
	faction = "Vampire"
	allowed_species = list("Werewolf")
	allowed_tribes = AMBERGLADE_ALLOWED_TRIBES

	minimal_renownrank = 3
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Litany and the Council."

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 100
	exp_type_department = EXP_TYPE_AMBERGLADE

	outfit = /datum/outfit/job/garou/gladekeeper

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_AMBERGLADE

	minimal_masquerade = 5

	known_contacts = null

	v_duty = "You are the keeper of your Sept's grounds. Your duty is to look after those with access to the caerns and bawns to ensure things remain pleasing to the spirits, and to ensure rites and rituals go well. Keep an eye on the land, and entrust your sept with keeping others in line."

/datum/outfit/job/garou/gladekeeper
	name = "Amberglade Keeper"
	jobtype = /datum/job/vamp/garou/amberglade/keeper

	id = /obj/item/card/id/garou/glade/keeper
	uniform =  /obj/item/clothing/under/vampire/mechanic
	suit = /obj/item/clothing/suit/vampire/labcoat
	gloves = /obj/item/clothing/gloves/vampire/work
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	l_pocket = /obj/item/vamp/phone
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/glade/keeper
	name = "Amberglade Keeper"
	icon_state = "Clerk"

/datum/job/vamp/garou/amberglade/truthcatcher
	title = "Amberglade Truthcatcher"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("The Litany")

	selection_color = "#69e430"
	faction = "Vampire"
	allowed_species = list("Werewolf")
	allowed_tribes = AMBERGLADE_ALLOWED_TRIBES

	total_positions = 1
	spawn_positions = 1
	supervisors = "The Litany and the Council."
	minimal_renownrank = 2

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 100
	exp_type_department = EXP_TYPE_AMBERGLADE

	outfit = /datum/outfit/job/garou/gladecatcher

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_AMBERGLADE

	minimal_masquerade = 5

	known_contacts = null

	v_duty = "You are the Truthcatcher of your sept. Your duty is to mediate in internal disputes, and work with the sept's Council to see deeds exonerated and punished. Keep an ear out to the people, and keep your heart a judge's balance."

/datum/outfit/job/garou/gladecatcher
	name = "Amberglade Truthcatcher"
	jobtype = /datum/job/vamp/garou/amberglade/truthcatcher

	id = /obj/item/card/id/garou/glade/truthcatcher
	uniform =  /obj/item/clothing/under/vampire/office
	suit = /obj/item/clothing/suit/vampire/coat/winter/alt
	gloves = /obj/item/clothing/gloves/vampire/work
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	l_pocket = /obj/item/vamp/phone
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/veil_contract, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/glade/catcher
	name = "Amberglade Truthcatcher"
	icon_state = "Clerk"

/datum/job/vamp/garou/amberglade/warder
	title = "Amberglade Warder"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("The Litany")

	selection_color = "#69e430"
	faction = "Vampire"
	allowed_species = list("Werewolf")
	allowed_tribes = AMBERGLADE_ALLOWED_TRIBES

	minimal_renownrank = 3
	total_positions = 1
	spawn_positions = 1
	supervisors = "The Litany and the Council."

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 100
	exp_type_department = EXP_TYPE_AMBERGLADE

	outfit = /datum/outfit/job/garou/gladewarder

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_AMBERGLADE

	minimal_masquerade = 5

	known_contacts = null

	v_duty = "You are the overseer of the sept's force. In times where Gaia's warriors are needed, you pull them together and direct them onto the field, under the Council's direction. You must conserve your strength for fights glorious and honorable."

/datum/outfit/job/garou/gladewarder
	name = "Amberglade Warder"
	jobtype = /datum/job/vamp/garou/amberglade/warder

	id = /obj/item/card/id/garou/glade/warder
	uniform =  /obj/item/clothing/under/vampire/biker
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	gloves = /obj/item/clothing/gloves/vampire/work
	head = /obj/item/clothing/head/vampire/cowboy
	belt = /obj/item/storage/belt/vampire/sheathe/sabre
	suit = /obj/item/clothing/suit/vampire/vest/medieval
	glasses = /obj/item/clothing/glasses/vampire/sun
	l_pocket = /obj/item/vamp/phone
	backpack_contents = list(/obj/item/gun/ballistic/automatic/vampire/deagle=1, /obj/item/passport=1, /obj/item/veil_contract, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/glade/warder
	name = "Amberglade Warder"
	icon_state = "Sheriff"

/datum/job/vamp/garou/amberglade/guardian
	title = "Amberglade Guardian"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("The Litany")

	selection_color = "#69e430"
	faction = "Vampire"
	allowed_species = list("Werewolf")
	allowed_tribes = AMBERGLADE_ALLOWED_TRIBES

	total_positions = 5
	spawn_positions = 5
	supervisors = "The Litany and the Council."

	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 50
	exp_type_department = EXP_TYPE_AMBERGLADE

	outfit = /datum/outfit/job/garou/gladeguardian

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DONUT_LOVER)
	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_AMBERGLADE

	minimal_masquerade = 3

	known_contacts = null

	v_duty = "You have put yourself forward as a force for the Sept. Working under the Warder, your duty is to defend and protect the sacred grounds of Gaia, and assist in bringing to heel those who have breached the veil for the Truthcatcher."

/datum/outfit/job/garou/gladeguardian
	name = "City Sept Guardian"
	jobtype = /datum/job/vamp/garou/amberglade/guardian

	id = /obj/item/card/id/garou/glade/guardian
	uniform =  /obj/item/clothing/under/vampire/biker
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	head = /obj/item/clothing/head/vampire/baseballcap
	belt = /obj/item/melee/classic_baton/vampire
	gloves = /obj/item/clothing/gloves/vampire/leather
	suit = /obj/item/clothing/suit/vampire/jacket
	l_pocket = /obj/item/vamp/phone
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)


	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/effect/landmark/start/garou/glade/guardian
	name = "Amberglade Guardian"
	icon_state = "Hound"

#undef AMBERGLADE_ALLOWED_TRIBES
