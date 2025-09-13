/datum/status_effect/blood_of_potency
	id = "blood_of_potency"
	duration = 1 INGAME_HOURS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/blood_of_potency
	var/stored_generation

/datum/status_effect/blood_of_potency/on_creation(mob/living/new_owner, generation, time)
	. = ..()
	if(time)
		duration = time
	stored_generation = owner.generation
	owner.generation = generation
	owner.calculate_max_bloodpool()

/datum/status_effect/blood_of_potency/on_remove()
	. = ..()

	//Can't do initial() due to it giving bad results.
	owner.generation = stored_generation
	stored_generation = null

	owner.calculate_max_bloodpool()

	if(owner.bloodpool > owner.maxbloodpool)
		owner.bloodpool = owner.maxbloodpool

/atom/movable/screen/alert/status_effect/blood_of_potency
	name = "Blood of Potency"
	desc = "You can feel your blood being stronger!"
	icon_state = "blooddrunk"
