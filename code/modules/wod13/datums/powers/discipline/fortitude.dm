/datum/discipline/fortitude
	name = "Fortitude"
	desc = "Boosts armor."
	icon_state = "fortitude"
	power_type = /datum/discipline_power/fortitude

/datum/discipline_power/fortitude
	name = "Fortitude power name"
	desc = "Fortitude power description"

	activate_sound = 'code/modules/wod13/sounds/fortitude_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/fortitude_deactivate.ogg'

	power_group = DISCIPLINE_POWER_GROUP_COMBAT
	var/fortitude_DR

/datum/discipline/fortitude/post_gain()
	. = ..()
	owner.physiology.damage_resistance += (5+(5*level))

//FORTITUDE 1
/datum/discipline_power/fortitude/one
	name = "Fortitude 1"
	desc = "Harden your muscles. Become sturdier than the bodybuilders."

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)
	fortitude_DR = 10

/datum/discipline_power/fortitude/one/activate()
	. = ..()
	owner.physiology.damage_resistance = min(60, (owner.physiology.damage_resistance+fortitude_DR) )

/datum/discipline_power/fortitude/one/deactivate()
	. = ..()
	owner.physiology.damage_resistance = max(0, (owner.physiology.damage_resistance-fortitude_DR) )

//FORTITUDE 2
/datum/discipline_power/fortitude/two
	name = "Fortitude 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)
	fortitude_DR = 15

/datum/discipline_power/fortitude/two/activate()
	. = ..()
	owner.physiology.damage_resistance = min(60, (owner.physiology.damage_resistance+fortitude_DR) )

/datum/discipline_power/fortitude/two/deactivate()
	. = ..()
	owner.physiology.damage_resistance = max(0, (owner.physiology.damage_resistance-fortitude_DR) )

//FORTITUDE 3
/datum/discipline_power/fortitude/three
	name = "Fortitude 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)
	fortitude_DR = 20

/datum/discipline_power/fortitude/three/activate()
	. = ..()
	owner.physiology.damage_resistance = min(60, (owner.physiology.damage_resistance+fortitude_DR) )

/datum/discipline_power/fortitude/three/deactivate()
	. = ..()
	owner.physiology.damage_resistance = max(0, (owner.physiology.damage_resistance-fortitude_DR) )

//FORTITUDE 4
/datum/discipline_power/fortitude/four
	name = "Fortitude 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/five
	)
	fortitude_DR = 25

/datum/discipline_power/fortitude/four/activate()
	. = ..()
	owner.physiology.damage_resistance = min(60, (owner.physiology.damage_resistance+fortitude_DR) )

/datum/discipline_power/fortitude/four/deactivate()
	. = ..()
	owner.physiology.damage_resistance = max(0, (owner.physiology.damage_resistance-fortitude_DR) )


//FORTITUDE 5
/datum/discipline_power/fortitude/five
	name = "Fortitude 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four
	)
	fortitude_DR = 30

/datum/discipline_power/fortitude/five/activate()
	. = ..()
	owner.physiology.damage_resistance = min(60, (owner.physiology.damage_resistance+fortitude_DR) )

/datum/discipline_power/fortitude/five/deactivate()
	. = ..()
	owner.physiology.damage_resistance = max(0, (owner.physiology.damage_resistance-fortitude_DR) )

