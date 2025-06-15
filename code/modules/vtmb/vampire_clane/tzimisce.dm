/datum/vampireclane/tzimisce
	name = CLAN_TZIMISCE
	desc = "If someone were to call a Tzimisce inhuman and sadistic, the Tzimisce would probably commend them for their perspicacity, and then demonstrate that their mortal definition of sadism was laughably inadequate. The Tzimisce have left the human condition behind gladly, and now focus on transcending the limitations of the vampiric state. At a casual glance or a brief conversation, a Tzimisce appears to be one of the more pleasant vampires. Polite, intelligent, and inquisitive, they seem a stark contrast to the howling Sabbat mobs or even the apparently more humane Brujah or Nosferatu. However, upon closer inspection, it becomes clear that this is merely a mask hiding something alien and monstrous."
	curse = "Grounded to material domain."
	clane_disciplines = list(
		/datum/discipline/auspex,
		/datum/discipline/animalism,
		/datum/discipline/vicissitude
	)
	violating_appearance = FALSE
	male_clothes = /obj/item/clothing/under/vampire/sport
	female_clothes = /obj/item/clothing/under/vampire/red
	clan_keys = /obj/item/vamp/keys/tzimisce
	is_enlightened = TRUE
	var/obj/item/heirl
	whitelisted = FALSE // dont ruin it
	current_accessory = "none"
	accessories = list("spines", "spines_slim", "animal_skull", "none")
	accessories_layers = list("spines" = UNICORN_LAYER, "spines_slim" = UNICORN_LAYER, "animal_skull" = UNICORN_LAYER, "none" = UNICORN_LAYER)


/obj/effect/proc_holder/spell/targeted/shapeshift/tzimisce
	name = "Tzimisce Form"
	desc = "Take on the shape a beast."
	charge_max = 10 SECONDS
	cooldown_min = 10 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/tzimisce_beast

/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler
	name = "Blood Crawler"
	desc = "Take on the shape a beast."
	charge_max = 5 SECONDS
	cooldown_min = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/bloodcrawler

/datum/vampireclane/tzimisce/post_gain(mob/living/carbon/human/H)
	..()
	var/obj/item/ground_heir/heirloom = new(get_turf(H))
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(heirloom, slots, FALSE)
	heirl = heirloom

/datum/crafting_recipe/tzi_trench
	name = "Leather-Bone Trenchcoat (Armor)"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 50, /obj/item/spine = 1)
	result = /obj/item/clothing/suit/vampire/trench/tzi
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_med
	name = "Medical Hand (Healing)"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 35, /obj/item/bodypart/r_arm = 1, /obj/item/organ/heart = 1, /obj/item/organ/tongue = 1)
	result = /obj/item/organ/cyberimp/arm/medibeam
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_heart
	name = "Second Heart (Antistun)"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 25, /obj/item/organ/heart = 1)
	result = /obj/item/organ/cyberimp/brain/anti_stun/tzi
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_eyes
	name = "Better Eyes (Nightvision)"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 15, /obj/item/organ/eyes = 1)
	result = /obj/item/organ/eyes/night_vision/nightmare
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_venom
	name = "Nematocyst Whip"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 15, /obj/item/guts = 1)
	result = /obj/item/organ/cyberimp/arm/tzimisce/venom
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_stun
	name = "Electrocyte Whip"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 15, /obj/item/guts = 1)
	result = /obj/item/organ/cyberimp/arm/tzimisce/shock
	always_available = FALSE
	category = CAT_TZIMISCE

//unused due to being bad
/datum/crafting_recipe/tzi_koldun
	name = "Koldun Sorcery (Firebreath)"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 10, /obj/item/vampire_stake = 1, /obj/item/reagent_containers/blood = 1)
	result = /obj/item/dnainjector/koldun
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_implant
	name = "Implanting Flesh Device"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 10, /obj/item/melee/vampirearms/knife = 1, /obj/item/reagent_containers/blood = 1)
	result = /obj/item/autosurgeon/organ/vicissitude
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzicreature
	name = "Wretched Creature"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 10, /obj/item/organ/brain = 1, )
	result = /obj/item/toy/plush/tzi
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tziregenerativecore
	name = "Pulsating Heart"
	time = 50
	reqs = list(/obj/item/organ/heart = 1, /obj/item/reagent_containers/blood/elite = 1)
	result = /obj/item/organ/regenerative_core/legion/tzi
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/axetzi
	name = "Living Axe"
	time = 50
	reqs = list(/obj/item/organ/eyes = 1, /obj/item/spine = 2, /obj/item/stack/human_flesh = 40)
	result = /obj/item/melee/vampirearms/fireaxe/axetzi
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_floor
	name = "Gut Floor"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 1, /obj/item/guts = 1)
	result = /obj/effect/decal/gut_floor
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_floor_living
	name = "Writhing Floor"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 1, /obj/item/guts = 1)
	result = /turf/open/indestructible/necropolis
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_wall
	name = "Flesh Wall"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 2)
	result = /obj/structure/fleshwall
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzijelly
	name = "Living Meat Node"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 20, /obj/item/guts = 1, /obj/item/toy/plush/tzi = 1)
	result = /obj/structure/tzijelly
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/cattzi
	name = "flesh feline"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 20, /obj/item/guts = 1, /obj/item/spine = 1, /obj/item/toy/plush/tzi = 1)
	result = /mob/living/simple_animal/pet/cat/vampiretzi
	always_available = FALSE
	category = CAT_TZIMISCE

/obj/effect/decal/gut_floor
	name = "gut floor"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "tzimisce_floor"

/datum/movespeed_modifier/centipede
	multiplicative_slowdown = -1.2
	blacklisted_movetypes = (FLYING|FLOATING)

/datum/movespeed_modifier/leatherwings
	multiplicative_slowdown = -0.5
	movetypes = FLOATING|FLYING

/datum/movespeed_modifier/membranewings
	multiplicative_slowdown = -0.8
	movetypes = FLOATING|FLYING

/mob/living/simple_animal/hostile/bloodcrawler
	var/collected_blood = 0

/mob/living/simple_animal/hostile/bloodcrawler/Move(NewLoc, direct)
	. = ..()
	var/obj/structure/vampdoor/V = locate() in NewLoc
	if(V)
		if(V.lockpick_difficulty <= 10)
			forceMove(get_turf(V))
	for(var/obj/effect/decal/cleanable/blood/B in range(1, NewLoc))
		if(B)
			if(B.bloodiness)
				collected_blood = collected_blood+1
				to_chat(src, "You sense blood entering your mass...")
				var/turf/T = get_turf(B)
				if(T)
					T.wash(CLEAN_WASH)

/obj/effect/decal/gut_floor/Initialize()
	. = ..()
	if(isopenturf(get_turf(src)))
		var/turf/open/T = get_turf(src)
		if(T)
			T.slowdown = 1

/obj/effect/decal/gut_floor/Destroy()
	. = ..()
	var/turf/open/T = get_turf(src)
	if(T)
		T.slowdown = initial(T.slowdown)

/datum/crafting_recipe/tzi_stool
	name = "Arm Stool"
	time = 50
	reqs = list(/obj/item/stack/human_flesh = 5, /obj/item/bodypart/r_arm = 2, /obj/item/bodypart/l_arm = 2)
	result = /obj/structure/chair/old/tzimisce
	always_available = FALSE
	category = CAT_TZIMISCE

/obj/structure/chair/old/tzimisce
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "tzimisce_stool"

/obj/item/guts
	name = "guts"
	desc = "Just blood and guts..."
	icon_state = "guts"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/spine
	name = "spine"
	desc = "If only I had control..."
	icon_state = "spine"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL

/datum/crafting_recipe/tzi_biter
	name = "Biting Abomination"
	time = 100
	reqs = list(/obj/item/stack/human_flesh = 2, /obj/item/bodypart/r_arm = 2, /obj/item/bodypart/l_arm = 2, /obj/item/spine = 1)
	result = /mob/living/simple_animal/hostile/biter
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_fister
	name = "Punching Abomination"
	time = 100
	reqs = list(/obj/item/stack/human_flesh = 5, /obj/item/bodypart/r_arm = 1, /obj/item/bodypart/l_arm = 1, /obj/item/spine = 1, /obj/item/guts = 1)
	result = /mob/living/simple_animal/hostile/fister
	always_available = FALSE
	category = CAT_TZIMISCE

/datum/crafting_recipe/tzi_tanker
	name = "Fat Abomination"
	time = 100
	reqs = list(/obj/item/stack/human_flesh = 10, /obj/item/bodypart/r_arm = 1, /obj/item/bodypart/l_arm = 1, /obj/item/bodypart/r_leg = 1, /obj/item/bodypart/l_leg = 1, /obj/item/spine = 1, /obj/item/guts = 2)
	result = /mob/living/simple_animal/hostile/tanker
	always_available = FALSE
	category = CAT_TZIMISCE

/mob/living/simple_animal/hostile/biter
	name = "szlachta"
	desc = "The human form twisted to a breaking point, into a vague resemblence of a fanged spider."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "biter"
	icon_living = "biter"
	icon_dead = "biter_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/stack/human_flesh = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	speed = -1
	maxHealth = 75
	health = 75

	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("gnashes")

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(CLAN_TZIMISCE)
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 2
	maxbloodpool = 2

/mob/living/simple_animal/hostile/fister
	name = "szlachta"
	desc = "A perversion of human form, waddling on a pair of overdeveloped arms."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fister"
	icon_living = "fister"
	icon_dead = "fister_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	maxHealth = 125
	health = 125
	butcher_results = list(/obj/item/stack/human_flesh = 2)
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	status_flags = CANPUSH
	faction = list(CLAN_TZIMISCE)
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 5
	maxbloodpool = 5

/mob/living/simple_animal/hostile/tanker
	name = "szlachta"
	desc = "A bloated parody of the human form, possessing an immense bulk."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "tanker"
	icon_living = "tanker"
	icon_dead = "tanker_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	maxHealth = 350
	health = 350
	butcher_results = list(/obj/item/stack/human_flesh = 4)
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	faction = list(CLAN_TZIMISCE)
	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 7
	maxbloodpool = 7

/mob/living/simple_animal/hostile/gargoyle
	name = CLAN_GARGOYLE
	desc = "Stone-skinned..."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "gargoyle_m"
	icon_living = "gargoyle_m"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mob_size = MOB_SIZE_LARGE
	speak_chance = 0
	speed = -1
	maxHealth = 400
	health = 400
	butcher_results = list(/obj/item/stack/human_flesh = 10)
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 45
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 10
	maxbloodpool = 10
	dextrous = TRUE
	held_items = list(null, null)
	possible_a_intents = list(INTENT_HELP, INTENT_GRAB, INTENT_DISARM, INTENT_HARM)
	faction = list(CLAN_TREMERE)

/mob/living/simple_animal/hostile/gargoyle/proc/gain_sentience()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as a Perfect Gargoyle?", null, null, null, 50, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, "<span class='ghostalert'>New Gargoyle has been made.</span>")
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		key = C.key
		var/choice = tgui_alert(C, "Do you want to pick a new name as a Gargoyle?", "Gargoyle Choose Name", list("Yes", "No"), 10)
		if(choice == "Yes")
			var/chosen_gargoyle_name = tgui_input_text(C, "What is your new name as a Gargoyle?", "Gargoyle Name Input")
			name = chosen_gargoyle_name
			update_name()
		else
			return

/mob/living/simple_animal/hostile/gargoyle/Initialize()
	. = ..()
	var/datum/action/gargoyle/G = new()
	G.Grant(src)

/datum/action/gargoyle
	name = "Turn into stone"
	desc = "Save some time till healing..."
	button_icon_state = "gargoyle"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/abuse_fix = 0

/datum/action/gargoyle/Trigger()
	. = ..()
	if(abuse_fix+100 > world.time)
		return
	abuse_fix = world.time
	var/mob/living/simple_animal/hostile/gargoyle/G = owner
	G.adjustBruteLoss(-300)
	G.adjustFireLoss(-300)
	G.Stun(50)
	G.petrify(50)

/mob/living/simple_animal/hostile/tzimisce_beast
	name = "zulo"
	desc = "The first step on the Path of Metamorphosis, this horrid form is unlike anything wrought by nature."
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "weretzi"
	icon_living = "weretzi"
	pixel_w = -16
	pixel_z = -16
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mob_size = MOB_SIZE_HUGE
	speak_chance = 0
	speed = -0.55
	maxHealth = 575
	health = 575
	butcher_results = list(/obj/item/stack/human_flesh = 10)
	harm_intent_damage = 5
	melee_damage_lower = 60
	melee_damage_upper = 70
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 10
	maxbloodpool = 10
	dodging = TRUE

/mob/living/simple_animal/hostile/bloodcrawler
	name = "bloodcrawler"
	desc = "A moving, oozing, sapient pool of blood. A stuff of nightmares."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "liquid"
	icon_living = "liquid"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	speak_chance = 0
	speed = -0.2
	maxHealth = 100
	health = 100
	butcher_results = list(/obj/item/stack/human_flesh = 1)
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 20
	maxbloodpool = 20

/mob/living/simple_animal/hostile/biter/hostile
	faction = list("hostile")

/mob/living/simple_animal/hostile/fister/hostile
	faction = list("hostile")

/mob/living/simple_animal/hostile/tanker/hostile
	faction = list("hostile")

/obj/item/ground_heir
	name = "bag of ground"
	desc = "Boghatyrskaya sila taitsa zdies'..."
	icon_state = "dirt"
	icon = 'code/modules/wod13/icons.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL

/datum/material/vicissitude_flesh
	name = "flesh"
	desc = "What remains of a person, when you really get down to it."
	color = "#d8965b"
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/meat
	value_per_unit = 0.05
	beauty_modifier = -0.3
	strength_modifier = 0.7
	armor_modifiers = list(MELEE = 0.3, BULLET = 0.3, LASER = 1.2, ENERGY = 1.2, BOMB = 0.3, BIO = 0, RAD = 0.7, FIRE = 1, ACID = 1)
	item_sound_override = 'sound/effects/meatslap.ogg'
	turf_sound_override = FOOTSTEP_MEAT

/datum/material/vicissitude_flesh/on_removed(atom/source, amount, material_flags)
	. = ..()
	qdel(source.GetComponent(/datum/component/edible))

/datum/material/vicissitude_flesh/on_applied_obj(obj/O, amount, material_flags)
	. = ..()
	make_edible(O, amount, material_flags)

/datum/material/vicissitude_flesh/on_applied_turf(turf/T, amount, material_flags)
	. = ..()
	make_edible(T, amount, material_flags)

/datum/material/vicissitude_flesh/proc/make_edible(atom/source, amount, material_flags)
	var/nutriment_count = 3 * (amount / MINERAL_MATERIAL_AMOUNT)
	var/oil_count = 2 * (amount / MINERAL_MATERIAL_AMOUNT)
	source.AddComponent(/datum/component/edible, list(/datum/reagent/consumable/nutriment = nutriment_count, /datum/reagent/consumable/cooking_oil = oil_count), null, RAW | MEAT | GROSS, null, 30, list("Fleshy"))

/obj/item/stack/human_flesh
	name = "human flesh"
	desc = "What the fuck..."
	singular_name = "human flesh"
	icon_state = "human"
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	mats_per_unit = list(/datum/material/vicissitude_flesh = MINERAL_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/human_flesh
	max_amount = 50

/obj/item/stack/human_flesh/fifty
	amount = 50
/obj/item/stack/human_flesh/twenty
	amount = 20
/obj/item/stack/human_flesh/ten
	amount = 10
/obj/item/stack/human_flesh/five
	amount = 5

/obj/item/stack/human_flesh/update_icon_state()
	. = ..()
	var/amount = get_amount()
	switch(amount)
		if(30 to INFINITY)
			icon_state = "human_3"
		if(10 to 30)
			icon_state = "human_2"
		else
			icon_state = "human"

/obj/item/extra_arm
	name = "extra arm installer"
	desc = "Distantly related to the technology of the Man-Machine Interface, this state-of-the-art syndicate device adapts your nervous and circulatory system to the presence of an extra limb..."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "vicissitude"
	var/used = FALSE

/obj/item/extra_arm/attack_self(mob/living/carbon/M)
	if(!used)
		var/limbs = M.held_items.len
		M.change_number_of_hands(limbs+1)
		used = TRUE
		icon_state = "extra_arm_none"
		M.visible_message("<span class='notice'>[M] presses a button on [src], and you hear a disgusting noise.</span>", "<span class='notice'>You feel a sharp sting as [src] plunges into your body.</span>")
		to_chat(M, "<span class='notice'>You feel more dexterous.</span>")
		playsound(get_turf(M), 'sound/misc/splort.ogg', 50, 1)
		desc += "Looks like it's been used up."

/obj/item/autosurgeon/organ/vicissitude
	name = "little brother"
	desc = "A talented fleshcrafted creature that can insert an implant or organ into its master without the hassle of extensive surgery. \
		Its mouth is eagerly awaiting implants or organs. However, it's quite greedy, so a screwdriver must be used to pry away accidentally added items."
	icon = 'code/modules/wod13/items.dmi'
