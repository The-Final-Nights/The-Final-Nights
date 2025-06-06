
/datum/discipline/chi_discipline/iron_mountain
	name = "Iron Mountain"
	desc = "Let your Demonic Side shield you"
	icon_state = "ironmountain"
	cost_demon = 1
	discipline_type = "Demon"
	power_type = /datum/discipline_power/chi_discipline_power/iron_mountain

/datum/discipline_power/chi_discipline_power/iron_mountain
	name = "Iron Mountain"
	desc = "Let your Demonic Side Shield you"
	cost_demon = 1

	activate_sound = 'code/modules/wod13/sounds/ironmountain_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/ironmountain_deactivate.ogg'

//Iron Mountain 1
/datum/discipline_power/chi_discipline_power/iron_mountain/one
	name = "Iron Mountain 1"
	desc = "Harden your muscles. Become sturdier than the bodybuilders."

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/iron_mountain/two,
		/datum/discipline_power/chi_discipline_power/iron_mountain/three,
		/datum/discipline_power/chi_discipline_power/iron_mountain/four,
		/datum/discipline_power/chi_discipline_power/iron_mountain/five
	)

/datum/discipline_power/chi_discipline_power/iron_mountain/one/activate()
	. = ..()
	owner.physiology.armor.melee += 15
	owner.physiology.armor.bullet += 15
	owner.physiology.armor.fire += 10

/datum/discipline_power/chi_discipline_power/iron_mountain/one/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 15
	owner.physiology.armor.bullet -= 15
	owner.physiology.armor.fire -= 10

//Iron Mountain 2
/datum/discipline_power/chi_discipline_power/iron_mountain/two
	name = "Iron Mountain 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/iron_mountain/one,
		/datum/discipline_power/chi_discipline_power/iron_mountain/three,
		/datum/discipline_power/chi_discipline_power/iron_mountain/four,
		/datum/discipline_power/chi_discipline_power/iron_mountain/five
	)

/datum/discipline_power/chi_discipline_power/iron_mountain/two/activate()
	. = ..()
	owner.physiology.armor.melee += 30
	owner.physiology.armor.bullet += 30
	owner.physiology.armor.fire += 20

/datum/discipline_power/chi_discipline_power/iron_mountain/two/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 30
	owner.physiology.armor.bullet -= 30
	owner.physiology.armor.fire -= 20

//Iron Mountain 3
/datum/discipline_power/chi_discipline_power/iron_mountain/three
	name = "Iron Mountain 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/iron_mountain/one,
		/datum/discipline_power/chi_discipline_power/iron_mountain/two,
		/datum/discipline_power/chi_discipline_power/iron_mountain/four,
		/datum/discipline_power/chi_discipline_power/iron_mountain/five
	)

/datum/discipline_power/chi_discipline_power/iron_mountain/three/activate()
	. = ..()
	owner.physiology.armor.melee += 45
	owner.physiology.armor.bullet += 45
	owner.physiology.armor.fire += 30

/datum/discipline_power/chi_discipline_power/iron_mountain/three/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 45
	owner.physiology.armor.bullet -= 45
	owner.physiology.armor.fire -= 30

//Iron Mountain 4
/datum/discipline_power/chi_discipline_power/iron_mountain/four
	name = "Iron Mountain 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/iron_mountain/one,
		/datum/discipline_power/chi_discipline_power/iron_mountain/two,
		/datum/discipline_power/chi_discipline_power/iron_mountain/three,
		/datum/discipline_power/chi_discipline_power/iron_mountain/five
	)

/datum/discipline_power/chi_discipline_power/iron_mountain/four/activate()
	. = ..()
	owner.physiology.armor.melee += 60
	owner.physiology.armor.bullet += 60
	owner.physiology.armor.fire += 40

/datum/discipline_power/chi_discipline_power/iron_mountain/four/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 60
	owner.physiology.armor.bullet -= 60
	owner.physiology.armor.fire -= 40

//Iron Mountain 5
/datum/discipline_power/chi_discipline_power/iron_mountain/five
	name = "Iron Mountain 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/iron_mountain/one,
		/datum/discipline_power/chi_discipline_power/iron_mountain/two,
		/datum/discipline_power/chi_discipline_power/iron_mountain/three,
		/datum/discipline_power/chi_discipline_power/iron_mountain/four
	)

/datum/discipline_power/chi_discipline_power/iron_mountain/five/activate()
	. = ..()
	owner.physiology.armor.melee += 75
	owner.physiology.armor.bullet += 75
	owner.physiology.armor.fire += 50

/datum/discipline_power/chi_discipline_power/iron_mountain/five/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 75
	owner.physiology.armor.bullet -= 75
	owner.physiology.armor.fire -= 50

