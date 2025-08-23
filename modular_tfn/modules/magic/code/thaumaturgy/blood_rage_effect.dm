/datum/status_effect/blood_rage
	id = "blood_rage"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/blood_rage

/datum/status_effect/blood_rage/on_creation(mob/living/new_owner, success_count)
	. = ..()
	owner.frenzy_hardness += success_count

/datum/status_effect/blood_rage/on_remove()
	. = ..()
	owner.frenzy_hardness = initial(owner.frenzy_hardness)

/atom/movable/screen/alert/status_effect/blood_rage
	name = "Blood Rage"
	desc = "You feel like you're going to lose it at any moment!"
	icon_state = "blooddrunk"
