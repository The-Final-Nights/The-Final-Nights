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
	var/atom/A = parent

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
	var/mob/living/carbon/carbon_mob = parent
	if(carbon_mob.stat != DEAD)
		qdel(src)
		return

	// Wait a bit before decaying
	if(world.time - carbon_mob.timeofdeath < 2 MINUTES)
		return

	// Properly stored corpses shouldn't create miasma
	if(istype(carbon_mob.loc, /obj/structure/closet/crate/coffin)|| istype(carbon_mob.loc, /obj/structure/closet/body_bag) || istype(carbon_mob.loc, /obj/structure/bodycontainer))
		return

	// No decay if formaldehyde in corpse or when the corpse is charred
	if(carbon_mob.reagents.has_reagent(/datum/reagent/toxin/formaldehyde, 15) || HAS_TRAIT(carbon_mob, TRAIT_HUSK))
		return

	// Similar to formaldehyde except it slows down surgery too
	if(carbon_mob.reagents.has_reagent(/datum/reagent/cryostylane))
		return

	// Also no decay if corpse chilled or not organic/undead
	if(carbon_mob.bodytemperature <= T0C-10 || !(carbon_mob.mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)))
		return

	..()
