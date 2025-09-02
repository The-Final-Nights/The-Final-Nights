/datum/outfit/job/first_team
	name = "First Team Operator"
	ears = /obj/item/p25radio/police/government
	uniform = /obj/item/clothing/under/response/firstteam_uniform
	gloves = /obj/item/clothing/gloves/response/firstteam
	mask = /obj/item/clothing/mask/vampire/balaclava
	glasses = /obj/item/clothing/glasses/night
	r_pocket = /obj/item/flashlight
	l_pocket = /obj/item/ammo_box/magazine/px66f
	shoes = /obj/item/clothing/shoes/response/firstteam
	belt = /obj/item/gun/ballistic/automatic/response/px66f
	suit = /obj/item/clothing/suit/response/firstteam_armor
	head = /obj/item/clothing/head/response/firstteam_helmet
	backpack_contents = list(
		/obj/item/ammo_box/magazine/px66f = 3,
		/obj/item/gun/ballistic/automatic/vampire/beretta=1,
		/obj/item/ammo_box/vampire/c556/bale = 1,
		/obj/item/vamp/keys/pentex = 1,
		/obj/item/veil_contract = 1,
		/obj/item/grenade/frag = 3,
		/obj/item/storage/firstaid/ifak = 2
		)

/datum/antagonist/first_team/proc/equip_first_team()
	var/mob/living/carbon/human/H = owner.current
	if(!ishuman(owner.current))
		return
	H.equipOutfit(first_team_outfit)
	H.set_species(/datum/species/human)
	H.set_clan(null)
	H.generation = 13
	H.maxHealth = round((initial(H.maxHealth)-initial(H.maxHealth)/4)+(initial(H.maxHealth)/4)*(H.physique+13-H.generation))
	H.health = round((initial(H.health)-initial(H.health)/4)+(initial(H.health)/4)*(H.physique+13-H.generation))
	for(var/datum/action/A in H.actions)
		if(A.vampiric)
			A.Remove(H)
	var/obj/item/organ/eyes/NV = new()
	NV.Insert(H, TRUE, FALSE)

	var/list/landmarkslist = list()
	for(var/obj/effect/landmark/start/S in GLOB.start_landmarks_list)
		if(S.name == name)
			landmarkslist += S
	var/obj/effect/landmark/start/D = pick(landmarkslist)
	H.forceMove(D.loc)

/datum/antagonist/first_team/proc/offer_loadout()
	var/list/loadouts = list(
		"Exterminator",
		"Field Medic",
		"Specialist",
		"Rifleman"
	)
	var/loadout_type = input(owner.current, "Choose your loadout:", "Loadout Selection") in loadouts
	switch(loadout_type)
		if("Exterminator")
			owner.current.put_in_r_hand(new /obj/item/vampire_flamethrower(owner.current))
			owner.current.put_in_l_hand(new /obj/item/gas_can/full(owner.current))
		if("Field Medic")
			owner.current.put_in_r_hand(new /obj/item/storage/firstaid/tactical(owner.current))
		if("Specialist")
			owner.current.put_in_r_hand(new /obj/item/gun/ballistic/shotgun/vampire/px12r(owner.current))
			owner.current.put_in_l_hand(new /obj/item/ammo_box/vampire/f12g(owner.current))
		if("Rifleman")
			owner.current.put_in_r_hand(new /obj/item/ammo_box/vampire/c556/bale(owner.current))
			owner.current.put_in_l_hand(new /obj/item/ammo_box/vampire/c556/bale(owner.current))

/obj/effect/landmark/start/first_team
	name = "First Team"
	delete_after_roundstart = FALSE

/datum/antagonist/first_team
	name = "First Team"
	roundend_category = "first_team"
	antagpanel_category = "First Team"
	job_rank = ROLE_FIRST_TEAM
	antag_hud_type = ANTAG_HUD_OPS
	antag_hud_name = "synd"
	antag_moodlet = /datum/mood_event/focused
	show_to_ghosts = TRUE
	var/always_new_team = FALSE
	var/datum/team/first_team/first_team_team
	var/first_team_outfit = /datum/outfit/job/first_team
	var/custom_objective

/datum/antagonist/first_team/sergeant
	name = "First Team Sergeant"
	always_new_team = TRUE
	var/title

/datum/antagonist/first_team/on_gain()
	randomize_appearance()
	forge_objectives()
	add_antag_hud(ANTAG_HUD_OPS, "synd", owner.current)
	owner.special_role = src
	equip_first_team()
	give_alias()
	offer_loadout()
	return ..()

/datum/antagonist/first_team/on_removal()
	..()
	to_chat(owner.current,span_userdanger("You are no longer in the First Team!"))
	owner.special_role = null

/datum/antagonist/first_team/greet()
	to_chat(owner.current,span_alertsyndie("You're in the First Team."))
	to_chat(owner,span_notice("You are a [first_team_team ? first_team_team.first_team_name : "first team"] operator!"))
	owner.announce_objectives()


/datum/antagonist/first_team/proc/give_alias()
	var/my_name = "Tyler"
	var/list/military_ranks = list("Private", "Private First Class", "Specialist", "Corporal")
	var/selected_rank = pick(military_ranks)
	if(owner.current.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	owner.current.fully_replace_character_name(null,"[selected_rank] [my_name] [my_surname]")

/datum/antagonist/first_team/proc/forge_objectives()
	if(first_team_team)
		objectives |= first_team_team.objectives

/datum/antagonist/first_team/sergeant/give_alias()
	var/my_name = "Tyler"
	if(owner.current.gender == MALE)
		my_name = pick(GLOB.first_names_male)
	else
		my_name = pick(GLOB.first_names_female)
	var/my_surname = pick(GLOB.last_names)
	owner.current.fully_replace_character_name(null,"Sergeant [my_name] [my_surname]")

/datum/team/first_team/antag_listing_name()
	if(first_team_name)
		return "[first_team_name] Operators"
	else
		return "Operators"


/datum/antagonist/first_team/sergeant/greet()
	to_chat(owner, "<B>You are the leading sergeant for this mission. You are responsible for guiding your team's operation.</B>")
	to_chat(owner, "<B>If you feel you are not up to this task, give your command to another operator.</B>")
	owner.announce_objectives()
	addtimer(CALLBACK(src, PROC_REF(first_teamteam_name_assign)), 1)

/datum/antagonist/first_team/sergeant/proc/first_teamteam_name_assign()
	if(!first_team_team)
		return
	first_team_team.rename_team(ask_name())

/datum/antagonist/first_team/sergeant/proc/ask_name()
	var/randomname = pick(GLOB.last_names)
	var/newname = stripped_input(owner.current,"You are the sergeant. Please choose a name for your team.", "Name change",randomname)
	if (!newname)
		newname = randomname
	else
		newname = reject_bad_name(newname)
		if(!newname)
			newname = randomname

/datum/antagonist/first_team/create_team(datum/team/first_team/new_team)
	if(!new_team)
		if(!always_new_team)
			for(var/datum/antagonist/first_team/N in GLOB.antagonists)
				if(!N.owner)
					stack_trace("Antagonist datum without owner in GLOB.antagonists: [N]")
					continue
		first_team_team = new /datum/team/first_team
		first_team_team.update_objectives()
		return
	if(!istype(first_team_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	first_team_team = new_team

/datum/antagonist/first_team/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.assigned_role = ROLE_FIRST_TEAM
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has first team'd [key_name_admin(new_owner)].")
	log_admin("[key_name(admin)] has first team'd [key_name(new_owner)].")

/datum/random_gen/first_team
	var/hair_colors = list("040404",	//Black
										"120b05",	//Dark Brown
										"342414",	//Brown
										"554433",	//Light Brown
										"695c3b",	//Dark Blond
										"ad924e",	//Blond
										"dac07f",	//Light Blond
										"802400",	//Ginger
										"a5380e",	//Ginger alt
										"ffeace",	//Albino
										"650b0b",	//Punk Red
										"14350e",	//Punk Green
										"080918")	//Punk Blue

	var/male_hair = list("Balding Hair",
										"Bedhead",
										"Bedhead 2",
										"Bedhead 3",
										"Boddicker",
										"Business Hair",
										"Business Hair 2",
										"Business Hair 3",
										"Business Hair 4",
										"Coffee House",
										"Combover",
										"Crewcut",
										"Father",
										"Flat Top",
										"Gelled Back",
										"Joestar",
										"Keanu Hair",
										"Oxton",
										"Volaju")

	var/male_facial = list("Beard (Abraham Lincoln)",
											"Beard (Chinstrap)",
											"Beard (Full)",
											"Beard (Cropped Fullbeard)",
											"Beard (Hipster)",
											"Beard (Neckbeard)",
											"Beard (Three o Clock Shadow)",
											"Beard (Five o Clock Shadow)",
											"Beard (Seven o Clock Shadow)",
											"Moustache (Hulk Hogan)",
											"Moustache (Watson)",
											"Sideburns (Elvis)",
											"Sideburns")

	var/female_hair = list("Ahoge",
										"Long Bedhead",
										"Beehive",
										"Beehive 2",
										"Bob Hair",
										"Bob Hair 2",
										"Bob Hair 3",
										"Bob Hair 4",
										"Bobcurl",
										"Braided",
										"Braided Front",
										"Braid (Short)",
										"Braid (Low)",
										"Bun Head",
										"Bun Head 2",
										"Bun Head 3",
										"Bun (Large)",
										"Bun (Tight)",
										"Double Bun",
										"Emo",
										"Emo Fringe",
										"Feather",
										"Gentle",
										"Long Hair 1",
										"Long Hair 2",
										"Long Hair 3",
										"Long Over Eye",
										"Long Emo",
										"Long Fringe",
										"Ponytail",
										"Ponytail 2",
										"Ponytail 3",
										"Ponytail 4",
										"Ponytail 5",
										"Ponytail 6",
										"Ponytail 7",
										"Ponytail (High)",
										"Ponytail (Short)",
										"Ponytail (Long)",
										"Ponytail (Country)",
										"Ponytail (Fringe)",
										"Poofy",
										"Short Hair Rosa",
										"Shoulder-length Hair",
										"Volaju")

/datum/antagonist/first_team/proc/randomize_appearance()
	var/datum/random_gen/first_team/h_gen = new
	var/mob/living/carbon/human/H = owner.current
	H.gender = pick(MALE, FEMALE)
	H.body_type = H.gender
	H.age = rand(18, 36)
//	if(age >= 55)
//		hair_color = "a2a2a2"
//		facial_hair_color = hair_color
//	else
	H.hair_color = pick(h_gen.hair_colors)
	H.facial_hair_color = H.hair_color
	if(H.gender == MALE)
		H.hairstyle = pick(h_gen.male_hair)
		if(prob(25) || H.age >= 25)
			H.facial_hairstyle = pick(h_gen.male_facial)
		else
			H.facial_hairstyle = "Shaved"
	else
		H.hairstyle = pick(h_gen.female_hair)
		H.facial_hairstyle = "Shaved"
	H.name = H.real_name
	H.dna.real_name = H.real_name
	var/obj/item/organ/eyes/organ_eyes = H.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = random_eye_color()
	H.underwear = random_underwear(H.gender)
	if(prob(50))
		H.underwear_color = organ_eyes.eye_color
	if(prob(50) || H.gender == FEMALE)
		H.undershirt = random_undershirt(H.gender)
	if(prob(25))
		H.socks = random_socks()
	H.update_body()
	H.update_hair()
	H.update_body_parts()

/datum/team/first_team/proc/rename_team(new_name)
	first_team_name = new_name
	name = "[first_team_name] Team"

/datum/team/first_team
	var/first_team_name
	var/core_objective = /datum/objective/first_team
	member_name = "First Team Operative"
	var/memorized_code
	var/list/team_discounts
	var/obj/item/nuclear_challenge/war_button

/datum/team/first_team/New()
	..()
	first_team_name = first_team_name()

/datum/team/first_team/proc/update_objectives()
	if(core_objective)
		var/datum/objective/O = new core_objective
		O.team = src
		objectives += O


/datum/team/first_team/roundend_report()
	var/list/parts = list()
	parts += "<span class='header'>[first_team_name] Operatives:</span>"

	var/text = "<br><span class='header'>The First Team were:</span>"
	text += printplayerlist(members)
	parts += text

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"




//////////////////////////////////////////////
//                                          //
//        FIRST TEAM SQUAD (MIDROUND)    //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/midround/from_ghosts/first_team
	name = "First Team Squad"
	antag_flag = ROLE_FIRST_TEAM
	antag_datum = /datum/antagonist/first_team
	required_candidates = 1
	weight = 5
	cost = 35
	requirements = list(90,90,90,80,60,40,30,20,10,10)
	var/list/operative_cap = list(2,2,3,3,4,5,5,5,5,5)
	var/datum/team/first_team/first_team_team
	flags = HIGHLANDER_RULESET

/datum/dynamic_ruleset/midround/from_ghosts/first_team/acceptable(population=0, threat=0)
	indice_pop = min(operative_cap.len, round(living_players.len/5)+1)
	required_candidates = max(5, operative_cap[indice_pop])
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/first_team/ready(forced = FALSE)
	if (required_candidates > (dead_players.len + list_observers.len))
		return FALSE
	return ..()

/datum/dynamic_ruleset/midround/from_ghosts/first_team/finish_setup(mob/new_character, index)
	new_character.mind.special_role = "First Team"
	new_character.mind.assigned_role = "First Team"
	if (index == 1) // Our first guy is the leader
		var/datum/antagonist/first_team/sergeant/new_role = new
		first_team_team = new_role.first_team_team
		new_character.mind.add_antag_datum(new_role)
	else
		return ..()

//------------EQUIPMENT------------


//------------SHOES------------
/obj/item/clothing/shoes/response
	name = "shoes"
	desc = "Comfortable-looking shoes."
	icon = 'modular_tfn/modules/first_team/icons/clothing.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	icon_state = "shoes"
	gender = PLURAL
	can_be_tied = FALSE
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	body_worn = TRUE
	cost = 5

/obj/item/clothing/shoes/response/firstteam
	name = "first-team boots"
	desc = "Pitch-black boots with hard, industrial laces."
	icon_state = "ftboots"

//------------GLOVES------------

/obj/item/clothing/gloves/response
	icon = 'modular_tfn/modules/first_team/icons/clothing.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	inhand_icon_state = "fingerless"
	undyeable = TRUE
	body_worn = TRUE

/obj/item/clothing/gloves/response/firstteam
	name = "First Team gloves"
	desc = "Provides protection from the good, the bad and the ugly."
	icon_state = "ftgloves"
	armor = list(MELEE = 80, BULLET = 80, LASER = 80, ENERGY = 80, BOMB = 80, BIO = 80, RAD = 80, FIRE = 80, ACID = 80)

//------------HELMET------------

/obj/item/clothing/head/response
	icon = 'modular_tfn/modules/first_team/icons/clothing.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE

/obj/item/clothing/head/response/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 10, "headwear", FALSE)

/obj/item/clothing/head/response/firstteam_helmet
	name = "First Team helmet"
	desc = "A black helmet with two, green-glowing eye-pieces that seem to stare through your soul."
	icon_state = "fthelmet"
	armor = list(MELEE = 80, BULLET = 80, LASER = 80, ENERGY = 80, BOMB = 80, BIO = 80, RAD = 80, FIRE = 80, ACID = 80, WOUND = 80)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	clothing_flags = NO_HAT_TRICKS|SNUG_FIT
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF

//------------ARMOR------------

/obj/item/clothing/suit/response
	icon = 'modular_tfn/modules/first_team/icons/clothing.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'

	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE

/obj/item/clothing/suit/response/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 15, "suit", FALSE)


/obj/item/clothing/suit/response/firstteam_armor
	name = "First Team Armoured Vest"
	desc = "A strong looking, armoured-vest with a large '1' engraved onto the breast."
	icon_state = "ftarmor"
	armor = list(MELEE = 80, BULLET = 80, LASER = 80, ENERGY = 80, BOMB = 80, BIO = 80, RAD = 80, FIRE = 80, ACID = 90, WOUND = 40)

//------------SUIT------------

/obj/item/clothing/under/response
	desc = "Some clothes."
	name = "clothes"
	icon_state = "error"
	has_sensor = NO_SENSORS
	random_sensor = FALSE
	can_adjust = FALSE
	icon = 'modular_tfn/modules/first_team/icons/clothing.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 15)
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	body_worn = TRUE
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/response/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 10, "undersuit", FALSE)

/obj/item/clothing/under/response/firstteam_uniform
	name = "First Team uniform"
	desc = "A completely blacked out uniform with a large '1' symbol sewn onto the shoulder-pad."
	icon_state = "ftuni"

/obj/item/gun/ballistic/automatic/response
	icon = 'code/modules/wod13/weapons.dmi'
	lefthand_file = 'modular_tfn/modules/first_team/icons/righthand.dmi'
	righthand_file = 'modular_tfn/modules/first_team/icons/lefthand.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	can_suppress = FALSE
	recoil = 2

/obj/item/ammo_box/vampire/c556/bale //DONT EVER PUT THIS IN A MAP
	name = "balefire ammo box (5.56)"
	icon = 'modular_tfn/modules/first_team/icons/ammo.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	icon_state = "556box-bale"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/bale

/obj/item/ammo_casing/vampire/c556mm/bale
	name = "green 5.56mm bullet casing"
	desc = "A modified 5.56mm bullet casing."
	caliber = CALIBER_556
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp556mm/bale
	icon = 'modular_tfn/modules/first_team/icons/ammo.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	icon_state = "b556"
	base_iconstate = "b556"

/obj/projectile/beam/beam_rifle/vampire/vamp556mm/bale
	armour_penetration = 50
	damage = 45
	var/bloodloss = 1

/obj/projectile/beam/beam_rifle/vampire/vamp556mm/bale/on_hit(atom/target, blocked = FALSE)
	if(iskindred(target) || isghoul(target))
		var/mob/living/carbon/human/H = target
		if(H.bloodpool == 0)
			to_chat(H, span_warning("only ash remains in my veins"))
			H.apply_damage(20, BURN)
			return
		H.bloodpool = max(H.bloodpool - bloodloss, 0)
		playsound(H, 'modular_tfn/modules/first_team/audio/balefire.ogg', rand(10,15), TRUE)
		to_chat(H, span_warning("green flames errupt from the bullets impact, boiling your blood"))
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)
		M.apply_damage(20, CLONE)
		playsound(M, 'modular_tfn/modules/first_team/audio/balefire.ogg', rand(10,15), TRUE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/item/ammo_casing/vampire/c12g/f12g
	name = "Frag-12g shell casing"
	desc = "A 12g explosive shell casing."
	caliber = CALIBER_12G
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/f12g
	icon = 'modular_tfn/modules/first_team/icons/ammo.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	icon_state = "f12"
	base_iconstate = "f12"

/obj/projectile/beam/beam_rifle/vampire/f12g
	name = "12g explosive slug"
	damage = 60
	armour_penetration = 50
	bare_wound_bonus = 10
	wound_bonus = 5

/obj/projectile/beam/beam_rifle/vampire/f12g/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 0, 2)
	return BULLET_ACT_HIT

/obj/item/ammo_box/vampire/f12g //DO NOT DISTRIBUTE NORMALLY
	name = "ammo box (f12g)"
	icon = 'modular_tfn/modules/first_team/icons/ammo.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	icon_state = "12box_frag"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/f12g
	max_ammo = 40

/obj/item/ammo_box/magazine/px66f
	name = "PX66F magazine (5.56mm)"
	icon = 'modular_tfn/modules/first_team/icons/ammo.dmi'
	lefthand_file = 'modular_tfn/modules/first_team/icons/righthand.dmi'
	righthand_file = 'modular_tfn/modules/first_team/icons/lefthand.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	icon_state = "px66f"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/bale
	caliber = CALIBER_556
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/internal/px12r
	name = "shotgun internal magazine"
	ammo_type = /obj/item/ammo_casing/vampire/c12g
	caliber = CALIBER_12G
	multiload = FALSE
	max_ammo = 8
	masquerade_violating = FALSE

/obj/item/gun/ballistic/automatic/response/px66f //DO NOT DISTRIBUTE IN MAPPING
	name = "\improper PX66F Rifle" //four bursts to kill a fullHP crinos
	desc = "A three-round burst 5.56 death machine, with a Spiral brand below the barrel."
	icon = 'modular_tfn/modules/first_team/icons/48x32weapons.dmi'
	lefthand_file = 'modular_tfn/modules/first_team/icons/righthand.dmi'
	righthand_file = 'modular_tfn/modules/first_team/icons/lefthand.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	icon_state = "px66f"
	inhand_icon_state = "px66f"
	worn_icon_state = "rifle"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM //Bullpup makes it easy to fire with one hand, but we still don't want these dual-wielded
	mag_type = /obj/item/ammo_box/magazine/px66f
	burst_size = 3
	fire_delay = 1
	spread = 2
	bolt_type = BOLT_TYPE_LOCKING
	show_bolt_icon = FALSE
	mag_display = TRUE
	fire_sound = 'modular_tfn/modules/first_team/audio/silenced_rifle.ogg'
	masquerade_violating = TRUE
	is_iron = FALSE

/obj/item/gun/ballistic/automatic/response/px66f/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 350, "aug", FALSE)

/obj/item/gun/ballistic/shotgun/vampire/px12r  //DONT DISTRIBUTE IN MAPPING
	name = "\improper PX12R Breaching Shotgun"
	desc = "A highly modified 12G Shotgun designed to fire Frag-12 explosive breaching rounds"
	icon = 'modular_tfn/modules/first_team/icons/48x32weapons.dmi'
	lefthand_file = 'modular_tfn/modules/first_team/icons/righthand.dmi'
	righthand_file = 'modular_tfn/modules/first_team/icons/lefthand.dmi'
	worn_icon = 'modular_tfn/modules/first_team/icons/worn.dmi'
	onflooricon = 'modular_tfn/modules/first_team/icons/onfloor.dmi'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	icon_state = "px12r"
	inhand_icon_state = "px12r"
	worn_icon_state = "px12r"
	recoil = 3
	fire_delay = 6
	mag_type = /obj/item/ammo_box/magazine/internal/px12r
	can_be_sawn_off	= FALSE
	fire_sound = 'modular_tfn/modules/first_team/audio/shotgun_firing.ogg'
	load_sound = 'modular_tfn/modules/first_team/audio/shell_load.ogg'
	rack_sound = 'modular_tfn/modules/first_team/audio/cycling.ogg'
	recoil = 4
	inhand_x_dimension = 32
	inhand_y_dimension = 32

