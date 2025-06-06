

/datum/discipline/chi_discipline/yang_prana
	name = "Yang Prana"
	desc = "Master the Flow of your Yang Chi."
	icon_state = "yang_prana"
	power_type = /datum/discipline_power/chi_discipline_power/yang_prana
	discipline_type = "Chi"
	cost_yang = 2

/datum/discipline_power/chi_discipline_power/yang_prana
	name = "Yang Prana"
	desc = "Master the Flow of your Yang Chi."
	activate_sound = 'code/modules/wod13/sounds/yang_prana.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/yang_prana.ogg'
	cost_yang = 2


//Yang Prana 1
/datum/discipline_power/chi_discipline_power/yang_prana/one
	name = "Enchanting Presuasion"
	desc = "Shout a statement that is utterly convincing to the eprson"

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yang_prana/two,
		/datum/discipline_power/chi_discipline_power/yang_prana/three,
		/datum/discipline_power/chi_discipline_power/yang_prana/four,
		/datum/discipline_power/chi_discipline_power/yang_prana/five
	)


/datum/discipline_power/chi_discipline_power/yang_prana/one/activate()
	. = ..()
	var/new_say = input(owner, "What are you trying to say?", "Say") as null|text
	new_say = sanitize_text(new_say)
	if(new_say)
		owner.say(new_say)
		for(var/mob/living/carbon/human/victim in oviewers(7, owner))
			victim.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_MAGIC)
			victim.gain_trauma(new /datum/brain_trauma/hypnosis(new_say), TRAUMA_RESILIENCE_MAGIC)
			spawn(30 SECONDS) //Dunno how to make this better, tell me how to do add timers when we review this
				if(victim)
					victim.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_MAGIC)

/datum/discipline_power/chi_discipline_power/yang_prana/one/deactivate()
	. = ..()


//Yang Prana 2
/datum/discipline_power/chi_discipline_power/yang_prana/two
	name = "Yang Mantle"
	desc = "Create an utterly blinding aura around you."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS


	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yang_prana/one,
		/datum/discipline_power/chi_discipline_power/yang_prana/three,
		/datum/discipline_power/chi_discipline_power/yang_prana/four,
		/datum/discipline_power/chi_discipline_power/yang_prana/five
	)
	var/mantle_loop = FALSE

/datum/discipline_power/chi_discipline_power/yang_prana/two/activate()
	. = ..()
	owner.remove_overlay(HALO_LAYER)
	var/mutable_appearance/fortitude_overlay = mutable_appearance('icons/effects/96x96.dmi', "boh_tear", -HALO_LAYER)
	fortitude_overlay.pixel_x = -32
	fortitude_overlay.pixel_y = -32
	fortitude_overlay.alpha = 128
	owner.overlays_standing[HALO_LAYER] = fortitude_overlay
	owner.apply_overlay(HALO_LAYER)
	owner.set_light(4, 10, "#ffffff")
	mantle_loop = TRUE
	while(mantle_loop)
		for(var/mob/living/viewing_mantle in oviewers(3, owner))
			if(prob(60))
				viewing_mantle.flash_act(affect_silicon = 1)

		sleep(2 SECONDS)

/datum/discipline_power/chi_discipline_power/yang_prana/two/deactivate()
	. = ..()
	mantle_loop = FALSE
	owner.remove_overlay(HALO_LAYER)
	owner.set_light(0)


//Yang Prana 3
/datum/discipline_power/chi_discipline_power/yang_prana/three
	name = "Dragon Dance"
	desc = "Dodge good"

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yang_prana/one,
		/datum/discipline_power/chi_discipline_power/yang_prana/two,
		/datum/discipline_power/chi_discipline_power/yang_prana/four,
		/datum/discipline_power/chi_discipline_power/yang_prana/five
	)

/datum/discipline_power/chi_discipline_power/yang_prana/three/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ENHANCED_MELEE_DODGE, "yang prana 3")
	to_chat(owner, "<span class='notice'>Your muscles relax and start moving on their own. You feel like you could dodge any strike...</span>")
	if(prob(50))
		dancefirst(owner)
	else
		dancesecond(owner)

/datum/discipline_power/chi_discipline_power/yang_prana/four/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ENHANCED_MELEE_DODGE, "yang prana 3")
	to_chat(owner, "<span class='warning'>Your muscles feel normal again.</span>")

//Yang Prana 4
/datum/discipline_power/chi_discipline_power/yang_prana/four
	name = "Dragon's Flow of the Bullet"
	desc = "Swat bullets away good."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_FREE_HAND
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yang_prana/one,
		/datum/discipline_power/chi_discipline_power/yang_prana/two,
		/datum/discipline_power/chi_discipline_power/yang_prana/three,
		/datum/discipline_power/chi_discipline_power/yang_prana/five
	)

/datum/discipline_power/chi_discipline_power/yang_prana/four/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCK_PROJECTILES, "yang prana 4")
	to_chat(owner, "<span class='notice'>Your muscles relax and start moving on their own. You feel like you could deflect bullets...</span>")
	if(prob(50))
		dancefirst(owner)
	else
		dancesecond(owner)

/datum/discipline_power/chi_discipline_power/yang_prana/four/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCK_PROJECTILES, "yang prana 4")
	to_chat(owner, "<span class='warning'>Your muscles feel normal again.</span>")

//Yang Prana 5
/datum/discipline_power/chi_discipline_power/yang_prana/five
	name = "Semblance of the Ebon Dragon"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yang_prana/one,
		/datum/discipline_power/chi_discipline_power/yang_prana/two,
		/datum/discipline_power/chi_discipline_power/yang_prana/three,
		/datum/discipline_power/chi_discipline_power/yang_prana/four
	)
	var/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/jaunt

/datum/discipline_power/chi_discipline_power/yang_prana/five/activate()
	. = ..()
	if(!jaunt)
		jaunt = new(owner)
	jaunt.cast(list(owner), owner)
