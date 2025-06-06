
/datum/discipline/chi_discipline/beast_shintai
	name = "Beast Shintai"
	desc = "Invoke upon the spirit of the animals"
	icon_state = "fortitude"
	power_type = /datum/discipline_power/chi_discipline_power/beast_shintai
	discipline_type = "Shintai"
	cost_yang = 1

/datum/discipline_power/chi_discipline_power/beast_shintai
	name = "Beast Shintai"
	desc = "Invoke upon the spirit of the animals"
	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/beastshintai_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/beastshintai_activate.ogg'


/mob/living/simple_animal/hostile/crinos_beast
	name = "Wolf-like Beast"
	desc = "The peak of abominations damage. Unbelievably deadly..."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "beast_crinos"
	icon_living = "beast_crinos"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mob_size = MOB_SIZE_HUGE
	speed = -0.8
	maxHealth = 575
	health = 575
	limb_destroyer = 1
	butcher_results = list(/obj/item/stack/human_flesh = 10)
	harm_intent_damage = 5
	melee_damage_lower = 65
	melee_damage_upper = 70
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	dextrous = TRUE
	held_items = list(null, null)
	possible_a_intents = list(INTENT_HELP, INTENT_GRAB, INTENT_DISARM, INTENT_HARM)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 10
	maxbloodpool = 10
	dodging = TRUE
	var/step_variable

/mob/living/simple_animal/hostile/crinos_beast/Move(NewLoc, direct)
	if(isturf(loc))
		step_variable = step_variable+1
		if(step_variable == 2)
			step_variable = 0
			playsound(get_turf(src), 'code/modules/wod13/sounds/werewolf_step.ogg', 50, FALSE)
	..()




//BEAST SHINTAI 1
/datum/discipline_power/chi_discipline_power/beast_shintai/one
	name = "Chi power name 1"
	desc = "HChi power description"

	level = 1

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK

	violates_masquerade = FALSE

	cooldown_length = 5 SECONDS



	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/beast_shintai/two,
		/datum/discipline_power/chi_discipline_power/beast_shintai/three,
		/datum/discipline_power/chi_discipline_power/beast_shintai/four,
		/datum/discipline_power/chi_discipline_power/beast_shintai/five
	)

/datum/discipline_power/chi_discipline_power/beast_shintai/one/activate()
	. = ..()
	var/limit = min(2, level) + owner.social + owner.additional_social + owner.more_companions - 1
	if(HAS_TRAIT(owner, TRAIT_ANIMAL_REPULSION))
		limit = max(1,limit-2)
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()
	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/stay = new()
		stay.Grant(owner)
		var/datum/action/beastmaster_deaggro/deaggro = new()
		deaggro.Grant(owner)

	var/mob/living/simple_animal/hostile/beastmaster/rat/rat = new(get_turf(owner))
	rat.my_creator = owner
	owner.beastmaster |= rat
	rat.beastmaster = owner

//BEAST SHINTAI 2
/datum/discipline_power/chi_discipline_power/beast_shintai/two
	name = "Fortitude 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK

	violates_masquerade = FALSE

	cooldown_length = 5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/beast_shintai/one,
		/datum/discipline_power/chi_discipline_power/beast_shintai/three,
		/datum/discipline_power/chi_discipline_power/beast_shintai/four,
		/datum/discipline_power/chi_discipline_power/beast_shintai/five
	)

/datum/discipline_power/chi_discipline_power/beast_shintai/two/activate()
	. = ..()
	var/limit = min(2, level) + owner.social + owner.additional_social + owner.more_companions - 1
	if(HAS_TRAIT(owner, TRAIT_ANIMAL_REPULSION))
		limit = max(1,limit-2)
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()
	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/stay = new()
		stay.Grant(owner)
		var/datum/action/beastmaster_deaggro/deaggro = new()
		deaggro.Grant(owner)

	var/mob/living/simple_animal/hostile/beastmaster/cat/cat = new(get_turf(owner))
	cat.my_creator = owner
	owner.beastmaster |= cat
	cat.beastmaster = owner

//BEAST SHINTAI 3
/datum/discipline_power/chi_discipline_power/beast_shintai/three
	name = "Fortitude 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK

	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/beast_shintai/one,
		/datum/discipline_power/chi_discipline_power/beast_shintai/two,
		/datum/discipline_power/chi_discipline_power/beast_shintai/four,
		/datum/discipline_power/chi_discipline_power/beast_shintai/five
	)

/datum/discipline_power/chi_discipline_power/beast_shintai/three/activate()
	. = ..()
	var/limit = min(2, level) + owner.social + owner.additional_social + owner.more_companions - 1
	if(HAS_TRAIT(owner, TRAIT_ANIMAL_REPULSION))
		limit = max(1,limit-2)
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()
	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/stay = new()
		stay.Grant(owner)
		var/datum/action/beastmaster_deaggro/deaggro = new()
		deaggro.Grant(owner)

	var/mob/living/simple_animal/hostile/beastmaster/dog = new(get_turf(owner))
	dog.my_creator = owner
	owner.beastmaster |= dog
	dog.beastmaster = owner

//BEAST SHINTAI 4
/datum/discipline_power/chi_discipline_power/beast_shintai/four
	name = "Fortitude 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK

	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/beast_shintai/one,
		/datum/discipline_power/chi_discipline_power/beast_shintai/two,
		/datum/discipline_power/chi_discipline_power/beast_shintai/three,
		/datum/discipline_power/chi_discipline_power/beast_shintai/five
	)

/datum/discipline_power/chi_discipline_power/beast_shintai/four/activate()
	. = ..()
	var/limit = min(2, level) + owner.social + owner.additional_social + owner.more_companions - 1
	if(HAS_TRAIT(owner, TRAIT_ANIMAL_REPULSION))
		limit = max(1,limit-2)
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/beast = pick(owner.beastmaster)
		beast.death()
	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/stay = new()
		stay.Grant(owner)
		var/datum/action/beastmaster_deaggro/deaggro = new()
		deaggro.Grant(owner)

	var/mob/living/simple_animal/hostile/beastmaster/rat/flying/bat = new(get_turf(owner))
	bat.my_creator = owner
	owner.beastmaster |= bat
	bat.beastmaster = owner



/obj/effect/proc_holder/spell/targeted/shapeshift/werewolf_like
	name = "Crinos Form"
	desc = "Take on the shape a Crinos."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/crinos_beast

//BEAST SHINTAI 5
/datum/discipline_power/chi_discipline_power/beast_shintai/five
	name = "Fortitude 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 4

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK

	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS
	duration_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shapeshift/werewolf_like/shapeshift

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/beast_shintai/one,
		/datum/discipline_power/chi_discipline_power/beast_shintai/two,
		/datum/discipline_power/chi_discipline_power/beast_shintai/three,
		/datum/discipline_power/chi_discipline_power/beast_shintai/four
	)

/datum/discipline_power/chi_discipline_power/beast_shintai/five/activate()
	. = ..()
	if(!shapeshift)
		shapeshift = new(owner)
	shapeshift.Shapeshift(owner)


/datum/discipline_power/chi_discipline_power/beast_shintai/five/deactivate()
	. = ..()
	if(owner.stat != DEAD)
		shapeshift.Restore(shapeshift.myshape)
		owner.Stun(1.5 SECONDS)

