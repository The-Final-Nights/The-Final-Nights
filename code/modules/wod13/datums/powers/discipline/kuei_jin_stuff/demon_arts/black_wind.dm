/datum/discipline_power/chi_discipline_power/black_wind


/datum/discipline/chi_discipline/black_wind
	name = "Black Wind"
	desc = "Your Demonic Side bursts out in a whirlwind of speed."
	icon_state = "blackwind"
	power_type = /datum/discipline_power/chi_discipline_power/black_wind
	discipline_type = "Demon"
	cost_demon = 1

/datum/discipline_power/chi_discipline_power/black_wind
	name = "Black Wind power name"
	desc = "Black Wind power description"

	activate_sound = 'code/modules/wod13/sounds/blackwind_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/blackwind_activate.ogg'
	cost_demon = 1

/datum/discipline_power/chi_discipline_power/black_wind/proc/black_wind_visual(datum/discipline_power/chi_discipline_power/black_wind/source, atom/newloc, dir)
	SIGNAL_HANDLER

	spawn()
		var/obj/effect/black_wind/C = new(owner.loc)
		C.name = owner.name
		C.appearance = owner.appearance
		C.dir = owner.dir
		C.color = "#40ffb4"
		animate(C, pixel_x = rand(-32, 32), pixel_y = rand(-32, 32), color = "#00196e", time = 0.5 SECONDS)
		if(owner.CheckEyewitness(owner, owner, 7, FALSE))
			owner.AdjustMasquerade(-1)

/obj/effect/black_wind
	name = "Demonic Afterimage"
	desc = "..."
	anchored = TRUE

/obj/effect/black_wind/Initialize()
	. = ..()
	spawn(0.5 SECONDS)
		qdel(src)

//CELERITY 1
/datum/movespeed_modifier/black_wind
	multiplicative_slowdown = -0.5

/datum/discipline_power/chi_discipline_power/black_wind/one
	name = "Black Wind 1"
	desc = "Enhances your speed to make everything a little bit easier."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/black_wind/two,
		/datum/discipline_power/chi_discipline_power/black_wind/three,
		/datum/discipline_power/chi_discipline_power/black_wind/four,
		/datum/discipline_power/chi_discipline_power/black_wind/five
	)

/datum/discipline_power/chi_discipline_power/black_wind/one/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(black_wind_visual))

	//put this out of its misery
	owner.black_wind_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/black_wind)

/datum/discipline_power/chi_discipline_power/black_wind/one/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

	owner.black_wind_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/black_wind)

//CELERITY 2
/datum/movespeed_modifier/black_wind2
	multiplicative_slowdown = -0.75

/datum/discipline_power/chi_discipline_power/black_wind/two
	name = "Black Wind 2"
	desc = "Significantly improves your speed and reaction time."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/black_wind/one,
		/datum/discipline_power/chi_discipline_power/black_wind/three,
		/datum/discipline_power/chi_discipline_power/black_wind/four,
		/datum/discipline_power/chi_discipline_power/black_wind/five
	)

/datum/discipline_power/chi_discipline_power/black_wind/two/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(black_wind_visual))

	owner.black_wind_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/black_wind2)

/datum/discipline_power/chi_discipline_power/black_wind/two/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	owner.black_wind_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/black_wind2)

//CELERITY 3
/datum/movespeed_modifier/black_wind3
	multiplicative_slowdown = -1

/datum/discipline_power/chi_discipline_power/black_wind/three
	name = "Black Wind 3"
	desc = "Move faster. React in less time. Your body is under perfect control."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/black_wind/one,
		/datum/discipline_power/chi_discipline_power/black_wind/two,
		/datum/discipline_power/chi_discipline_power/black_wind/four,
		/datum/discipline_power/chi_discipline_power/black_wind/five
	)

/datum/discipline_power/chi_discipline_power/black_wind/three/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(black_wind_visual))
	owner.black_wind_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/black_wind3)

/datum/discipline_power/chi_discipline_power/black_wind/three/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.black_wind_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/black_wind3)

//CELERITY 4
/datum/movespeed_modifier/black_wind4
	multiplicative_slowdown = -1.25

/datum/discipline_power/chi_discipline_power/black_wind/four
	name = "Black Wind 4"
	desc = "Breach the limits of what is humanly possible. Move like a lightning bolt."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/black_wind/one,
		/datum/discipline_power/chi_discipline_power/black_wind/two,
		/datum/discipline_power/chi_discipline_power/black_wind/three,
		/datum/discipline_power/chi_discipline_power/black_wind/five
	)

/datum/discipline_power/chi_discipline_power/black_wind/four/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(black_wind_visual))

	owner.black_wind_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/black_wind4)

/datum/discipline_power/chi_discipline_power/black_wind/four/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.black_wind_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/black_wind4)

//CELERITY 5
/datum/movespeed_modifier/black_wind5
	multiplicative_slowdown = -1.5

/datum/discipline_power/chi_discipline_power/black_wind/five
	name = "Black Wind 5"
	desc = "You are like light. Blaze your way through the world."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/black_wind/one,
		/datum/discipline_power/chi_discipline_power/black_wind/two,
		/datum/discipline_power/chi_discipline_power/black_wind/three,
		/datum/discipline_power/chi_discipline_power/black_wind/four
	)

/datum/discipline_power/chi_discipline_power/black_wind/five/activate()
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(black_wind_visual))

	owner.black_wind_visual = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/black_wind5)

/datum/discipline_power/chi_discipline_power/black_wind/five/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.black_wind_visual = FALSE
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/black_wind5)
