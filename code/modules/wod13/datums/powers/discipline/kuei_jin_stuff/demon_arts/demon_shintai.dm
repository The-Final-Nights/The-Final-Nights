/datum/discipline/chi_discipline/demon_shintai
	name = "Chi Discipline"
	desc = "Chi Discipline demon_shintai."
	icon_state = "fortitude"
	cost_demon = 1
	discipline_type = "Demon"
	power_type = /datum/discipline_power/chi_discipline_power/demon_shintai

/datum/discipline_power/chi_discipline_power/demon_shintai
	name = "Demon Shintai"
	desc = "Possess the Form of Your Inner Demon"
	activate_sound = 'code/modules/wod13/sounds/demonshintai_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/demonshintai_activate.ogg'
	cost_demon = 1
	var/current_form = "Samurai"


/datum/movespeed_modifier/tentacles1
	multiplicative_slowdown = -0.5

/datum/movespeed_modifier/kiai
	multiplicative_slowdown = -0.3

/datum/movespeed_modifier/demonform1
	multiplicative_slowdown = -0.5
/datum/movespeed_modifier/demonform2
	multiplicative_slowdown = -1
/datum/movespeed_modifier/demonform3
	multiplicative_slowdown = -2
/datum/movespeed_modifier/demonform4
	multiplicative_slowdown = -3
/datum/movespeed_modifier/demonform5
	multiplicative_slowdown = -5

/datum/action/choose_demon_form
	name = "Choose Demon Form"
	desc = "Choose your form of a Demon."
	button_icon_state = "demon_form"
	button_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/kuei_jin.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	var/current_form

/* Going to shelve this for now and try the radial version (Yeah definitely doing radial first)
/datum/action/choose_demon_form/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/new_form = input(owner, "Choose your Demon Form", "Demon Form") as null|anything in list("Samurai", "Tentacles", "Demon", "Giant", "Foul")
		if(new_form)
			to_chat(owner, "Your new form is [new_form].")
			for(var/datum/discipline_power/chi_discipline_power/chi_action in owner.actions)
				if(chi_action)
					if(istype(chi_action.chi_discipline, /datum/discipline_power/chi_discipline_power/demon_shintai))
						var/datum/discipline/chi_discipline/demon_shintai/demon_shintai = chi_action.discipline
						demon_shintai.current_form = new_form
		button.color = "#970000"
		animate(button, color = "#ffffff", time = 2 SECONDS, loop = 1)
*/

//DEMON SHINTAI 1
/datum/discipline_power/chi_discipline_power/demon_shintai/one
	name = "Demon Shintai 1"
	desc = "HChi power description"

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/demon_shintai/two,
		/datum/discipline_power/chi_discipline_power/demon_shintai/three,
		/datum/discipline_power/chi_discipline_power/demon_shintai/four,
		/datum/discipline_power/chi_discipline_power/demon_shintai/five
	)

/datum/discipline_power/chi_discipline_power/demon_shintai/one/activate()
	. = ..()


/datum/discipline_power/chi_discipline_power/demon_shintai/one/deactivate()
	. = ..()


//DEMON SHINTAI 2
/datum/discipline_power/chi_discipline_power/demon_shintai/two
	name = "Demon Shintai 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/demon_shintai/one,
		/datum/discipline_power/chi_discipline_power/demon_shintai/three,
		/datum/discipline_power/chi_discipline_power/demon_shintai/four,
		/datum/discipline_power/chi_discipline_power/demon_shintai/five
	)

/datum/discipline_power/chi_discipline_power/demon_shintai/two/activate()
	. = ..()


/datum/discipline_power/chi_discipline_power/demon_shintai/two/deactivate()
	. = ..()

//DEMON SHINTAI 3
/datum/discipline_power/chi_discipline_power/demon_shintai/three
	name = "Demon Shintai 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/demon_shintai/one,
		/datum/discipline_power/chi_discipline_power/demon_shintai/two,
		/datum/discipline_power/chi_discipline_power/demon_shintai/four,
		/datum/discipline_power/chi_discipline_power/demon_shintai/five
	)

/datum/discipline_power/chi_discipline_power/demon_shintai/three/activate()
	. = ..()

/datum/discipline_power/chi_discipline_power/demon_shintai/three/deactivate()
	. = ..()

//DEMON SHINTAI 4
/datum/discipline_power/chi_discipline_power/demon_shintai/four
	name = "Demon Shintai 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/demon_shintai/one,
		/datum/discipline_power/chi_discipline_power/demon_shintai/two,
		/datum/discipline_power/chi_discipline_power/demon_shintai/three,
		/datum/discipline_power/chi_discipline_power/demon_shintai/five
	)

/datum/discipline_power/chi_discipline_power/demon_shintai/four/activate()
	. = ..()

/datum/discipline_power/chi_discipline_power/demon_shintai/four/deactivate()
	. = ..()

//DEMON SHINTAI 5
/datum/discipline_power/chi_discipline_power/demon_shintai/five
	name = "Demon Shintai 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/demon_shintai/one,
		/datum/discipline_power/chi_discipline_power/demon_shintai/two,
		/datum/discipline_power/chi_discipline_power/demon_shintai/three,
		/datum/discipline_power/chi_discipline_power/demon_shintai/four
	)

/datum/discipline_power/chi_discipline_power/demon_shintai/five/activate()
	. = ..()

/datum/discipline_power/chi_discipline_power/demon_shintai/five/deactivate()
	. = ..()
