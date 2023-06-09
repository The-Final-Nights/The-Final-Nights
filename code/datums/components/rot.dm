/datum/component/rot
	/// Amount of miasma we're spawning per tick
	var/amount = 1
	/// Time remaining before we remove the component
	var/time_remaining = 5 MINUTES

/datum/component/rot/Initialize(new_amount)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(new_amount)
		amount = new_amount

<<<<<<< HEAD
	START_PROCESSING(SSprocessing, src)
=======
	RegisterSignals(parent, list(COMSIG_ATOM_HULK_ATTACK, COMSIG_ATOM_ATTACK_ANIMAL, COMSIG_ATOM_ATTACK_HAND), PROC_REF(rot_react_touch))
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(rot_hit_react))
	if(ismovable(parent))
		AddComponent(/datum/component/connect_loc_behalf, parent, loc_connections)
		RegisterSignal(parent, COMSIG_MOVABLE_BUMP, PROC_REF(rot_react))
	if(isliving(parent))
		RegisterSignal(parent, COMSIG_LIVING_REVIVE, PROC_REF(react_to_revive)) //mobs stop this when they come to life
		RegisterSignal(parent, COMSIG_LIVING_GET_PULLED, PROC_REF(rot_react_touch))
	if(iscarbon(parent))
		var/mob/living/carbon/carbon_parent = parent
		RegisterSignals(carbon_parent.reagents, list(COMSIG_REAGENTS_ADD_REAGENT,
			COMSIG_REAGENTS_REM_REAGENT,
			COMSIG_REAGENTS_DEL_REAGENT), PROC_REF(check_reagent))
		RegisterSignals(parent, list(SIGNAL_ADDTRAIT(TRAIT_HUSK), SIGNAL_REMOVETRAIT(TRAIT_HUSK)), PROC_REF(check_husk_trait))
		check_reagent(carbon_parent.reagents, null)
		check_husk_trait(null)
	if(ishuman(parent))
		var/mob/living/carbon/human/human_parent = parent
		RegisterSignal(parent, COMSIG_HUMAN_CORETEMP_CHANGE, PROC_REF(check_for_temperature))
		check_for_temperature(null, 0, human_parent.coretemperature)
>>>>>>> ae5a4f955d0 (Pulls apart the vestiges of components still hanging onto signals (#75914))

/datum/component/rot/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/datum/component/rot/process(delta_time)
	//SSprocessing goes off per 1 second
	time_remaining -= delta_time * 1 SECONDS
	if(time_remaining <= 0)
		qdel(src)

/datum/component/rot/corpse
	time_remaining = 7 MINUTES //2 minutes more to compensate for the delay

/datum/component/rot/corpse/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()

/datum/component/rot/corpse/process()
	var/mob/living/carbon/C = parent
	if(C.stat != DEAD)
		qdel(src)
		return

	// Wait a bit before decaying
	if(world.time - C.timeofdeath < 2 MINUTES)
		return

	// Properly stored corpses shouldn't create miasma
	if(istype(C.loc, /obj/structure/closet/crate/coffin)|| istype(C.loc, /obj/structure/closet/body_bag) || istype(C.loc, /obj/structure/bodycontainer))
		return

	// No decay if formaldehyde in corpse or when the corpse is charred
	if(C.reagents.has_reagent(/datum/reagent/toxin/formaldehyde, 15) || HAS_TRAIT(C, TRAIT_HUSK))
		return

	// Also no decay if corpse chilled or not organic/undead
	if(C.bodytemperature <= T0C-10 || !(C.mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)))
		return

	..()
