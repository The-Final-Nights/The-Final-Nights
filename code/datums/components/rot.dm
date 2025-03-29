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

	START_PROCESSING(SSprocessing, src)

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
