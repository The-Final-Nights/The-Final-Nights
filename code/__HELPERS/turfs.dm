/**
 * Returns the top-most atom sitting on the turf.
 * For example, using this on a disk, which is in a bag, on a mob,
 * will return the mob because it's on the turf.
 *
 * Arguments
 * * something_in_turf - a movable within the turf, somewhere.
 * * stop_type - optional - stops looking if stop_type is found in the turf, returning that type (if found).
 **/
/proc/get_atom_on_turf(atom/movable/something_in_turf, stop_type)
	if(!istype(something_in_turf))
		CRASH("get_atom_on_turf was not passed an /atom/movable! Got [isnull(something_in_turf) ? "null":"type: [something_in_turf.type]"]")

	var/atom/movable/topmost_thing = something_in_turf

	while(topmost_thing?.loc && !isturf(topmost_thing.loc))
		topmost_thing = topmost_thing.loc
		if(stop_type && istype(topmost_thing, stop_type))
			break

	return topmost_thing
