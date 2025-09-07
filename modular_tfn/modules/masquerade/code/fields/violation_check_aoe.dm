/datum/proximity_monitor/advanced/violation_check_aoe
	edge_is_a_field = TRUE
	var/datum/component/violation_observer/violation_observer_callback
	var/list/tracking_mobs

/datum/proximity_monitor/advanced/violation_check_aoe/New(atom/_host, range, _ignore_if_not_on_turf = TRUE, _violation_observer_callback)
	. = ..()
	violation_observer_callback = violation_observer_callback
	tracking_mobs = new()

/datum/proximity_monitor/advanced/violation_check_aoe/Destroy()
	violation_observer_callback = null
	for(var/mob as anything in tracking_mobs)
		UnregisterSignal(mob, COMSIG_MASQUERADE_VIOLATION)
	tracking_mobs = null
	return ..()

/datum/proximity_monitor/advanced/violation_check_aoe/on_entered(turf/source, atom/movable/entered, turf/old_loc)
	. = ..()
	if(QDELETED(src))
		return
	if(!isliving(entered))
		return
	if(isnpc(entered)) //only track non-NPCs
		return
	if(entered == host)
		return
	if(entered in tracking_mobs)
		return
	tracking_mobs |= entered
	RegisterSignal(entered, COMSIG_MASQUERADE_VIOLATION, PROC_REF(violation_observer_breach_callback))

/datum/proximity_monitor/advanced/violation_check_aoe/on_uncrossed(turf/source, atom/movable/gone, direction)
	. = ..()
	if(QDELETED(src))
		return
	if(!isliving(gone))
		return
	if(isnpc(gone)) //only track non-NPCs
		return
	if(gone == host)
		return
	if(!(gone in tracking_mobs))
		return
	tracking_mobs -= gone
	UnregisterSignal(gone, COMSIG_MASQUERADE_VIOLATION)

/datum/proximity_monitor/advanced/violation_check_aoe/on_z_change()
	if(QDELETED(src))
		return
	for(var/mob as anything in tracking_mobs)
		UnregisterSignal(mob, COMSIG_MASQUERADE_VIOLATION)
		tracking_mobs -= mob

/datum/proximity_monitor/advanced/violation_check_aoe/cleanup_field_turf(turf/target)
	if(QDELETED(src))
		return
	for(var/mob/living/living_mob in target.contents)
		UnregisterSignal(living_mob, COMSIG_MASQUERADE_VIOLATION)
		tracking_mobs -= living_mob

/datum/proximity_monitor/advanced/violation_check_aoe/proc/violation_observer_breach_callback(mob/living/source)
	SIGNAL_HANDLER

	if(!GLOB.canon_event)
		return
	var/mob/living/host_mob = host
	if(host_mob.incapacitated() || host_mob.stat >= SOFT_CRIT || host_mob.IsSleeping() || host_mob.IsParalyzed())
		return
	if(HAS_TRAIT(source, TRAIT_OBFUSCATED))
		return
	if(!CheckZoneMasquerade(host_mob))
		return
	if(!can_see(host_mob, source, 7))
		return
	if(!COOLDOWN_FINISHED(source, masquerade_timer))
		return
	COOLDOWN_START(source, masquerade_timer, 10 SECONDS)
	SEND_SIGNAL(host_mob, COMSIG_SEEN_MASQUERADE_VIOLATION, source)
