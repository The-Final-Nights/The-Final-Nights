// Status Effect Buffs - Darkpack portening
/// Celerity
/datum/status_effect/celerity
	id = "celerity"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/click_cooldown_modifier

/datum/status_effect/celerity/nextmove_modifier()
	return click_cooldown_modifier

// Celerity levels handle the click-delay reduction in intervals of 10%
/datum/status_effect/celerity/one
	click_cooldown_modifier = 0.9

/datum/status_effect/celerity/two
	click_cooldown_modifier = 0.8

/datum/status_effect/celerity/three
	click_cooldown_modifier = 0.7

/datum/status_effect/celerity/four
	click_cooldown_modifier = 0.6

/datum/status_effect/celerity/five
	click_cooldown_modifier = 0.5
