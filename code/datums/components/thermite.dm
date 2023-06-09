/datum/component/thermite
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/amount
	var/burn_require
	var/overlay

	var/static/list/blacklist = typecacheof(list(
		/turf/open/lava,
		/turf/open/space,
		/turf/open/water,
		/turf/open/chasm)
		)

	var/static/list/immunelist = typecacheof(list(
		/turf/closed/wall/mineral/diamond,
		/turf/closed/indestructible,
		/turf/open/indestructible)
		)

	var/static/list/resistlist = typecacheof(
		/turf/closed/wall/r_wall
		)

/datum/component/thermite/Initialize(_amount)
	if(!istype(parent, /turf) || blacklist[parent.type])
		return COMPONENT_INCOMPATIBLE

	if(immunelist[parent.type])
		amount = 0 //Yeah the overlay can still go on it and be cleaned but you arent burning down a diamond wall
	else
		amount = _amount
		if(resistlist[parent.type])
			burn_require = 50
		else
			burn_require = 30

	var/turf/master = parent
	overlay = mutable_appearance('icons/effects/effects.dmi', "thermite")
	master.add_overlay(overlay)

	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_react))
<<<<<<< HEAD
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(attackby_react))
	RegisterSignal(parent, COMSIG_ATOM_FIRE_ACT, PROC_REF(flame_react))

/datum/component/thermite/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT)
	UnregisterSignal(parent, COMSIG_PARENT_ATTACKBY)
	UnregisterSignal(parent, COMSIG_ATOM_FIRE_ACT)
=======
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(attackby_react))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(parent_qdeleting)) //probably necessary because turfs are wack
	var/turf/turf_parent = parent
	turf_parent.update_appearance()

/datum/component/thermite/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ATOM_FIRE_ACT,
		COMSIG_ATOM_UPDATE_OVERLAYS,
		COMSIG_COMPONENT_CLEAN_ACT,
		COMSIG_ATOM_ATTACKBY,
		COMSIG_ATOM_EXAMINE,
		COMSIG_QDELETING,
	))
	var/turf/turf_parent = parent
	turf_parent.update_appearance()
>>>>>>> ae5a4f955d0 (Pulls apart the vestiges of components still hanging onto signals (#75914))

/datum/component/thermite/Destroy()
	var/turf/master = parent
	master.cut_overlay(overlay)
	return ..()

/datum/component/thermite/InheritComponent(datum/component/thermite/newC, i_am_original, _amount)
	if(!i_am_original)
		return
	if(newC)
		amount += newC.amount
	else
		amount += _amount

/datum/component/thermite/proc/thermite_melt(mob/user)
<<<<<<< HEAD
	var/turf/master = parent
	master.cut_overlay(overlay)
	playsound(master, 'sound/items/welder.ogg', 100, TRUE)
	var/obj/effect/overlay/thermite/fakefire = new(master)
	addtimer(CALLBACK(src, PROC_REF(burn_parent), fakefire, user), min(amount * 0.35 SECONDS, 20 SECONDS))
	UnregisterFromParent()
=======
	var/turf/parent_turf = parent
	playsound(parent_turf, 'sound/items/welder.ogg', 100, TRUE)
	fakefire = new(parent_turf)
	burn_callback = CALLBACK(src, PROC_REF(burn_parent), user)
	burn_timer = addtimer(burn_callback, min(amount * 0.35 SECONDS, 20 SECONDS), TIMER_STOPPABLE)
	//unregister everything mechanical, we are burning up
	UnregisterSignal(parent, list(COMSIG_COMPONENT_CLEAN_ACT, COMSIG_ATOM_ATTACKBY, COMSIG_ATOM_FIRE_ACT))
>>>>>>> ae5a4f955d0 (Pulls apart the vestiges of components still hanging onto signals (#75914))

/datum/component/thermite/proc/burn_parent(datum/fakefire, mob/user)
	var/turf/master = parent
	if(!QDELETED(fakefire))
		qdel(fakefire)
	if(user)
		master.add_hiddenprint(user)
	if(amount >= burn_require)
		master = master.Melt()
		master.burn_tile()
	qdel(src)

/datum/component/thermite/proc/clean_react(datum/source, strength)
	SIGNAL_HANDLER

	//Thermite is just some loose powder, you could probably clean it with your hands. << todo?
	qdel(src)
	return COMPONENT_CLEANED

/datum/component/thermite/proc/flame_react(datum/source, exposed_temperature, exposed_volume)
	SIGNAL_HANDLER

	if(exposed_temperature > 1922) // This is roughly the real life requirement to ignite thermite
		thermite_melt()

/datum/component/thermite/proc/attackby_react(datum/source, obj/item/thing, mob/user, params)
	SIGNAL_HANDLER

	if(thing.get_temperature())
		thermite_melt(user)
<<<<<<< HEAD
=======

/// Signal handler for COMSIG_QDELETING, necessary because turfs can be weird with qdel()
/datum/component/thermite/proc/parent_qdeleting(datum/source)
	SIGNAL_HANDLER

	if(!QDELING(src))
		qdel(src)
>>>>>>> ae5a4f955d0 (Pulls apart the vestiges of components still hanging onto signals (#75914))
