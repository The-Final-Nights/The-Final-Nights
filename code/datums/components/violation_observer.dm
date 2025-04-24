// Used for things that detect masquerade violations.
// Usually NPCs or cameras.
/datum/component/violation_observer
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/proximity_monitor/advanced/violation_check_aoe/area_of_effect
	/// Time between us checking for violations
	COOLDOWN_DECLARE(scan_cooldown)

/datum/component/violation_observer/Initialize()
	area_of_effect = new(parent, 10)

/datum/component/violation_observer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MASQUERADE_VIOLATION, PROC_REF(on_observed_violation))

/datum/component/violation_observer/UnregisterFromParent(force, silent)
	QDEL_NULL(area_of_effect)
	UnregisterSignal(parent, list(COMSIG_MASQUERADE_VIOLATION))

/datum/component/violation_observer/proc/on_observed_violation()
	SIGNAL_HANDLER

