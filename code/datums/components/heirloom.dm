/datum/component/heirloom
	var/datum/mind/owner
	var/family_name

/datum/component/heirloom/Initialize(new_owner, new_family_name)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	owner = new_owner
	family_name = new_family_name

<<<<<<< HEAD
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(examine))

/datum/component/heirloom/proc/examine(datum/source, mob/user, list/examine_list)
=======
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/heirloom/Destroy(force, silent)
	owner = null
	return ..()

/**
 * Signal proc for [COMSIG_ATOM_EXAMINE].
 *
 * Shows who owns the heirloom on examine.
 */
/datum/component/heirloom/proc/on_examine(datum/source, mob/user, list/examine_list)
>>>>>>> ae5a4f955d0 (Pulls apart the vestiges of components still hanging onto signals (#75914))
	SIGNAL_HANDLER

	if(user.mind == owner)
		examine_list += "<span class='notice'>It is your precious [family_name] family heirloom. Keep it safe!</span>"
	else if(isobserver(user))
		examine_list += "<span class='notice'>It is the [family_name] family heirloom, belonging to [owner].</span>"
	else
		var/datum/antagonist/obsessed/creeper = user.mind.has_antag_datum(/datum/antagonist/obsessed)
		if(creeper && creeper.trauma.obsession == owner)
			examine_list += "<span class='nicegreen'>This must be [owner]'s family heirloom! It smells just like them...</span>"
