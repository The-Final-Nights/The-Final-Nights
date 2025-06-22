/*
// A vampire who holds a blood bond over another being is said to be the victim's regnant,
// while the being subordinate to the bond is called the thrall.
*/

/atom/movable/screen/alert/status_effect/blood_bonded
	name = "Blood Bonded"
	desc = "You're blood bonded to someone!"
	icon_state = "in_love"

/datum/status_effect/blood_bonded
	id = "blood_bonded"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/blood_bonded
	var/mob/living/regent

/datum/status_effect/blood_bonded/on_creation(mob/living/thrall, mob/living/regnant)
	. = ..()
	if(.)
		regent = src.regent
		linked_alert.desc = "You're blood bonded to [regent.real_name]!"
