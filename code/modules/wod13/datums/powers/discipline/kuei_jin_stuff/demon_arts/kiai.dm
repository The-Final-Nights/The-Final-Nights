
/datum/discipline/chi_discipline/kiai
	name = "Kiai"
	desc = "Manipulate reality by voice."
	icon_state = "kiai"
	power_type = /datum/discipline_power/chi_discipline_power/kiai
	discipline_type = "Demon"
	cost_demon = 1

/datum/discipline_power/chi_discipline_power/kiai
	name = "Kiai"
	desc = "Manipulate reality by voice."
	activate_sound = 'code/modules/wod13/sounds/kiai_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/kiai_activate.ogg'
	var/total_power = 1
	cost_demon = 1

/datum/movespeed_modifier/kiai
	multiplicative_slowdown = -0.3

/datum/discipline_power/chi_discipline_power/kiai/proc/kiai_check(mob/living/carbon/human/owner, mob/living/target, tiebreaker = FALSE) //These checks are common to all applications of Dominate.

	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()

	if((theirpower >= mypower) && !tiebreaker || (theirpower > mypower))
		to_chat(owner, span_warning("[target]'s mind is too powerful to kiai!"))
		return FALSE

	return TRUE

//KIAI 1
/datum/discipline_power/chi_discipline_power/kiai/one
	name = "Chi power name 1"
	desc = "HChi power description"

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/kiai/two,
		/datum/discipline_power/chi_discipline_power/kiai/three,
		/datum/discipline_power/chi_discipline_power/kiai/four,
		/datum/discipline_power/chi_discipline_power/kiai/five
	)

/datum/discipline_power/chi_discipline_power/kiai/one/activate()
	. = ..()
	var/sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
	switch(owner.gender)
		if(MALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
		if(FEMALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_female.ogg'
	playsound(owner.loc, sound_gender, 100, FALSE)
	owner.visible_message("<span class='danger'>[owner] SCREAMS!</span>")
	owner.physique += 2
	owner.dexterity += 2
	owner.athletics += 2
	owner.add_movespeed_modifier(/datum/movespeed_modifier/kiai)
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
	owner.do_jitter_animation(1 SECONDS)

/datum/discipline_power/chi_discipline_power/kiai/one/deactivate()
	. = ..()
	owner.physique -= 2
	owner.dexterity -= 2
	owner.athletics -= 2
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/kiai)
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)

//KIAI 2
/datum/discipline_power/chi_discipline_power/kiai/two
	name = "Fortitude 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/kiai/one,
		/datum/discipline_power/chi_discipline_power/kiai/three,
		/datum/discipline_power/chi_discipline_power/kiai/four,
		/datum/discipline_power/chi_discipline_power/kiai/five
	)

/datum/discipline_power/chi_discipline_power/kiai/two/activate()
	. = ..()
	var/mypower = owner.get_total_social()
	var/sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
	switch(owner.gender)
		if(MALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
		if(FEMALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_female.ogg'
	playsound(owner.loc, sound_gender, 100, FALSE)
	owner.visible_message("<span class='danger'>[owner] SCREAMS!</span>")
	for(var/mob/living/carbon/hearer in ohearers(4, owner))
		total_power = mypower / hearer.get_total_mentality()
		step_away(hearer, owner)
		hearer.apply_effect(total_power * 2, EFFECT_EYE_BLUR)
		if(total_power >= 1)
			hearer.apply_effect(total_power * 0.2 SECONDS, EFFECT_STUN)


/datum/discipline_power/chi_discipline_power/kiai/two/deactivate()
	. = ..()


//KIAI 3
/datum/discipline_power/chi_discipline_power/kiai/three
	name = "Fortitude 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK
	target_type = TARGET_LIVING

	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	range = 7


	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/kiai/one,
		/datum/discipline_power/chi_discipline_power/kiai/two,
		/datum/discipline_power/chi_discipline_power/kiai/four,
		/datum/discipline_power/chi_discipline_power/kiai/five
	)

/datum/discipline_power/chi_discipline_power/kiai/three/pre_activation_checks(mob/living/target)
	return kiai_check(owner, target)

/datum/discipline_power/chi_discipline_power/kiai/three/activate(mob/living/target)
	. = ..()
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	var/sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
	switch(owner.gender)
		if(MALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
		if(FEMALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_female.ogg'
	playsound(owner.loc, sound_gender, 100, FALSE)
	owner.visible_message("<span class='danger'>[owner] SCREAMS!</span>")
	total_power = mypower / theirpower
	step_away(target, owner)
	if(total_power > 1)
		target.apply_effect(total_power * 0.2 SECONDS, EFFECT_KNOCKDOWN)
	if(mypower >= (theirpower - 2))
		target.do_jitter_animation(1 SECONDS)
		new /datum/hallucination/fire(target, TRUE)


/datum/discipline_power/chi_discipline_power/kiai/three/deactivate()
	. = ..()

//KIAI 4
/datum/discipline_power/chi_discipline_power/kiai/four
	name = "Fortitude 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	range = 7
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK
	target_type = TARGET_LIVING
	multi_activate = TRUE
	cooldown_length = 10 SECONDS
	range = 7


	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/kiai/one,
		/datum/discipline_power/chi_discipline_power/kiai/two,
		/datum/discipline_power/chi_discipline_power/kiai/three,
		/datum/discipline_power/chi_discipline_power/kiai/five
	)


/datum/discipline_power/chi_discipline_power/kiai/four/activate(mob/living/target)
	. = ..()
	var/mypower = owner.get_total_social()
	var/sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
	switch(owner.gender)
		if(MALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
		if(FEMALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_female.ogg'
	playsound(owner.loc, sound_gender, 100, FALSE)
	owner.visible_message("<span class='danger'>[owner] SCREAMS!</span>")
	var/target_phys = target.get_total_physique()
	target.add_splatter_floor(get_turf(target))
	target.add_splatter_floor(get_turf(get_step(target, owner.dir)))
	switch(SSroll.storyteller_roll(mypower, target_phys + 3))
		if(ROLL_SUCCESS)
			target.apply_damage(5*mypower, BRUTE)
			target.apply_damage(2*mypower, CLONE)
			target.visible_message("<span class='danger'>[target]'s flesh tears!</span>", "<span class='userdanger'>[owner]'s scream rips the flesh from your bones!</span>")
		if(ROLL_FAILURE, ROLL_BOTCH)
			target.apply_damage(3*mypower, BRUTE)
			target.visible_message("<span class='danger'>Bleeding wounds open up on [target]!</span>", "<span class='userdanger'>[owner]'s scream tears at your flesh!</span>")

/datum/discipline_power/chi_discipline_power/kiai/four/deactivate()
	. = ..()



//KIAI 5
/datum/discipline_power/chi_discipline_power/kiai/five
	name = "Fortitude 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5


	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK
	cooldown_length = 10 SECONDS
	multi_activate = TRUE

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/kiai/one,
		/datum/discipline_power/chi_discipline_power/kiai/two,
		/datum/discipline_power/chi_discipline_power/kiai/three,
		/datum/discipline_power/chi_discipline_power/kiai/four
	)

/datum/discipline_power/chi_discipline_power/kiai/five/activate()
	. = ..()
	var/mypower = owner.get_total_social()
	var/sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
	switch(owner.gender)
		if(MALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_male.ogg'
		if(FEMALE)
			sound_gender = 'code/modules/wod13/sounds/kiai_female.ogg'
	playsound(owner.loc, sound_gender, 100, FALSE)
	owner.visible_message("<span class='danger'>[owner] SCREAMS!</span>")
	for(var/mob/living/carbon/hearer in ohearers(5, owner))
		var/theirpower = hearer.get_total_mentality()
		total_power = (mypower - 2) / theirpower //same as dot 3, but your power is treated as 2 points lower for determining the effects)
		step_away(hearer, owner)
		if(total_power > 1)
			hearer.apply_effect(total_power * 0.2 SECONDS, EFFECT_KNOCKDOWN)
			hearer.visible_message("<span class='danger'>[hearer] is knocked to the floor!</span>", "<span class='userdanger'>[owner]'s scream knocks you off your feet!</span>")
		if(mypower >= theirpower)
			hearer.do_jitter_animation(1 SECONDS)
			new /datum/hallucination/fire(hearer, TRUE)



/datum/discipline_power/chi_discipline_power/kiai/five/deactivate()
	. = ..()


