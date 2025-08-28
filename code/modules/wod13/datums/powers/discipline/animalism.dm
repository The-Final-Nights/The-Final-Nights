/datum/discipline/animalism
	name = "Animalism"
	desc = "Summons spectral animals over your targets. Violates Masquerade."
	icon_state = "animalism"
	power_type = /datum/discipline_power/animalism

/datum/discipline_power/animalism
	name = "Animalism power name"
	desc = "Animalism power description"

	effect_sound = 'code/modules/wod13/sounds/wolves.ogg'

//SUMMON RAT
/datum/discipline_power/animalism/summon_rat
	name = "Skittering Critters"
	desc = "Summons rats to follow you and gnaw on your enemies."

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	level = 1
	violates_masquerade = FALSE

	cooldown_length = 8 SECONDS

/datum/discipline_power/animalism/summon_rat/activate()
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

	var/summon_option = /mob/living/simple_animal/hostile/beastmaster/rat
	if(HAS_TRAIT(owner, TRAIT_UNLIVING_HIVE))
		summon_option = /mob/living/simple_animal/hostile/beastmaster/cockroach
	var/mob/living/simple_animal/hostile/beastmaster/summon = new summon_option(get_turf(owner))
	summon.my_creator = owner
	owner.beastmaster |= summon
	summon.beastmaster_owner = owner


//SUMMON CAT
/datum/discipline_power/animalism/summon_cat
	name = "Clawing Felines"
	desc = "Summons very cute cats to accompany you in the night."

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	level = 2
	violates_masquerade = FALSE

	cooldown_length = 8 SECONDS

/datum/discipline_power/animalism/summon_cat/activate()
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


	var/summon_option = /mob/living/simple_animal/hostile/beastmaster/cat
	if(HAS_TRAIT(owner, TRAIT_UNLIVING_HIVE))
		summon_option = /mob/living/simple_animal/hostile/beastmaster/cockroach/spider
	var/mob/living/simple_animal/hostile/beastmaster/summon = new summon_option(get_turf(owner))
	summon.my_creator = owner
	owner.beastmaster |= summon
	summon.beastmaster_owner = owner


//SUMMON WOLF
/*
/obj/effect/spectral_wolf
	name = "Spectral Wolf"
	desc = "Bites enemies in other dimensions."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "wolf"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
*/

/datum/discipline_power/animalism/summon_wolf
	name = "Spectral Wolf"
	desc = "Summons a phantasmal wolf to attack the target."

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	level = 3
	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS

/datum/discipline_power/animalism/summon_wolf/activate()
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

	var/summon_option = /mob/living/simple_animal/hostile/beastmaster
	if(HAS_TRAIT(owner, TRAIT_UNLIVING_HIVE))
		summon_option = /mob/living/simple_animal/hostile/beastmaster/largespider
	var/mob/living/simple_animal/hostile/beastmaster/summon = new summon_option(get_turf(owner))
	summon.my_creator = owner
	owner.beastmaster |= summon
	summon.beastmaster_owner = owner

//SUMMON BAT
/datum/discipline_power/animalism/summon_bat
	name = "Bloodsucker's Communion"
	desc = "Summons a swarm of bats to drain blood from the victim and transfer it to you."

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	level = 4
	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS

/datum/discipline_power/animalism/summon_bat/activate()
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
	bat.beastmaster_owner = owner

//RAT SHAPESHIFT
/obj/effect/proc_holder/spell/targeted/shapeshift/animalism
	name = "Animalism Form"
	desc = "Take on the shape a bat."
	charge_max = 5 SECONDS
	cooldown_min = 5 SECONDS
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/beastmaster/rat/flying

/datum/discipline_power/animalism/rat_shapeshift
	name = "Skitter"
	desc = "Become one of the bats that fly above the city."

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	violates_masquerade = TRUE

	cooldown_length = 8 SECONDS
	duration_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shapeshift/animalism/shapeshift

/datum/discipline_power/animalism/rat_shapeshift/activate()
	. = ..()
	if(!shapeshift)
		shapeshift = new(owner)
	shapeshift.Shapeshift(owner)

/datum/discipline_power/animalism/rat_shapeshift/deactivate()
	. = ..()
	if(owner.stat != DEAD)
		shapeshift.Restore(shapeshift.myshape)
		owner.Stun(1.5 SECONDS)
