/*
AI controllers are a datumized form of AI that simulates the input a player would otherwise give to a atom. What this means is that these datums
have ways of interacting with a specific atom and control it. They posses a blackboard with the information the AI knows and has, and will plan behaviors it will try to execute.
*/

/datum/ai_controller
	///The atom this controller is controlling
	var/atom/pawn
	///Bitfield of traits for this AI to handle extra behavior
	var/ai_traits
	///Current actions being performed by the AI.
	var/list/current_behaviors = list()
	///Current actions and their respective last time ran as an assoc list.
	var/list/behavior_cooldowns = list()
	///Current status of AI (OFF/ON)
	var/ai_status
	///Current movement target of the AI, generally set by decision making.
	var/atom/current_movement_target
	///Delay between atom movements, if this is not a multiplication of the delay in
	var/move_delay
	///This is a list of variables the AI uses and can be mutated by actions. When an action is performed you pass this list and any relevant keys for the variables it can mutate.
	var/list/blackboard = list()
	///Tracks recent pathing attempts, if we fail too many in a row we fail our current plans.
	var/pathing_attempts
	///Can the AI remain in control if there is a client?
	var/continue_processing_when_client = FALSE
	///distance to give up on target
	var/max_target_distance = 14

/datum/ai_controller/New(atom/new_pawn)
	PossessPawn(new_pawn)

/datum/ai_controller/Destroy(force, ...)
	set_ai_status(AI_STATUS_OFF)
	UnpossessPawn(FALSE)
	return ..()

///Proc to move from one pawn to another, this will destroy the target's existing controller.
/datum/ai_controller/proc/PossessPawn(atom/new_pawn)
	if(pawn) //Reset any old signals
		UnpossessPawn(FALSE)

	if(istype(new_pawn.ai_controller)) //Existing AI, kill it.
		QDEL_NULL(new_pawn.ai_controller)

	if(TryPossessPawn(new_pawn) & AI_CONTROLLER_INCOMPATIBLE)
		qdel(src)
		CRASH("[src] attached to [new_pawn] but these are not compatible!")

	pawn = new_pawn
	pawn.ai_controller = src

	if(!continue_processing_when_client && istype(new_pawn, /mob))
		var/mob/possible_client_holder = new_pawn
		if(possible_client_holder.client)
			set_ai_status(AI_STATUS_OFF)
		else
			set_ai_status(AI_STATUS_ON)
	else
		set_ai_status(AI_STATUS_ON)

	RegisterSignal(pawn, COMSIG_MOB_LOGIN, PROC_REF(on_sentience_gained))

///Abstract proc for initializing the pawn to the new controller
/datum/ai_controller/proc/TryPossessPawn(atom/new_pawn)
	return

///Proc for deinitializing the pawn to the old controller
/datum/ai_controller/proc/UnpossessPawn(destroy)
	UnregisterSignal(pawn, COMSIG_MOB_LOGIN, COMSIG_MOB_LOGOUT)
	pawn.ai_controller = null
	pawn = null
	if(destroy)
		qdel(src)
	return

///Returns TRUE if the ai controller can actually run at the moment.
/datum/ai_controller/proc/able_to_run()
	return TRUE

/// Generates a plan and see if our existing one is still valid.
/datum/ai_controller/process(delta_time)
	if(!able_to_run())
		var/atom/movable/movable_pawn = pawn
		walk(movable_pawn, 0) //stop moving
		return //this should remove them from processing in the future through event-based stuff.
	if(!current_behaviors?.len)
		SelectBehaviors(delta_time)
		if(!current_behaviors?.len)
			PerformIdleBehavior(delta_time) //Do some stupid shit while we have nothing to do
			return

	var/want_to_move = FALSE
	for(var/i in current_behaviors)
		var/datum/ai_behavior/current_behavior = i

		if(behavior_cooldowns[current_behavior] > world.time) //Still on cooldown
			continue

		if(current_behavior.behavior_flags & AI_BEHAVIOR_REQUIRE_MOVEMENT && current_movement_target && current_behavior.required_distance < get_dist(pawn, current_movement_target)) //Move closer
			want_to_move = TRUE
			if(current_behavior.behavior_flags & AI_BEHAVIOR_MOVE_AND_PERFORM) //Move and perform the action
				current_behavior.perform(delta_time, src)
		else //Perform the action
			current_behavior.perform(delta_time, src)

	if(want_to_move)
		MoveTo(delta_time) //Need to add some code to check if we can perform the actions now without too much overhead


///Move somewhere using dumb movement (byond base)
/datum/ai_controller/proc/MoveTo(delta_time)
	var/current_loc = get_turf(pawn)
	var/atom/movable/movable_pawn = pawn

	var/turf/target_turf = get_step_towards(movable_pawn, current_movement_target)

	if(!is_type_in_typecache(target_turf, GLOB.dangerous_turfs))
		movable_pawn.Move(target_turf, get_dir(current_loc, target_turf))
	if(get_dist(movable_pawn, current_movement_target) > max_target_distance)
		CancelActions()
		pathing_attempts = 0
	if(current_loc == get_turf(movable_pawn))
		if(++pathing_attempts >= MAX_PATHING_ATTEMPTS)
			CancelActions()
			pathing_attempts = 0


///Perform some dumb idle behavior.
/datum/ai_controller/proc/PerformIdleBehavior(delta_time)
	return

///This is where you decide what actions are taken by the AI.
/datum/ai_controller/proc/SelectBehaviors(delta_time)
	SHOULD_NOT_SLEEP(TRUE) //Fuck you don't sleep in procs like this.
	return

///This proc handles changing ai status, and starts/stops processing if required.
/datum/ai_controller/proc/set_ai_status(new_ai_status)
	if(ai_status == new_ai_status)
		return FALSE //no change

	ai_status = new_ai_status
	switch(ai_status)
		if(AI_STATUS_ON)
			START_PROCESSING(SSai_controllers, src)
		if(AI_STATUS_OFF)
			STOP_PROCESSING(SSai_controllers, src)
			CancelActions()

/datum/ai_controller/proc/CancelActions()
	for(var/i in current_behaviors)
		var/datum/ai_behavior/current_behavior = i
		current_behavior.finish_action(src, FALSE)

/datum/ai_controller/proc/on_sentience_gained()
	UnregisterSignal(pawn, COMSIG_MOB_LOGIN)
	if(!continue_processing_when_client)
		set_ai_status(AI_STATUS_OFF) //Can't do anything while player is connected
	RegisterSignal(pawn, COMSIG_MOB_LOGOUT, PROC_REF(on_sentience_lost))

/datum/ai_controller/proc/on_sentience_lost()
	UnregisterSignal(pawn, COMSIG_MOB_LOGOUT)
	set_ai_status(AI_STATUS_ON) //Can't do anything while player is connected
	RegisterSignal(pawn, COMSIG_MOB_LOGIN, PROC_REF(on_sentience_gained))

/// Use this proc to define how your controller defines what access the pawn has for the sake of pathfinding, likely pointing to whatever ID slot is relevant
/datum/ai_controller/proc/get_access()
	return

///Returns the minimum required distance to preform one of our current behaviors. Honestly this should just be cached or something but fuck you
/datum/ai_controller/proc/get_minimum_distance()
	var/minimum_distance = max_target_distance
	// right now I'm just taking the shortest minimum distance of our current behaviors, at some point in the future
	// we should let whatever sets the current_movement_target also set the min distance and max path length
	// (or at least cache it on the controller)
	for(var/datum/ai_behavior/iter_behavior as anything in current_behaviors)
		if(iter_behavior.required_distance < minimum_distance)
			minimum_distance = iter_behavior.required_distance
	return minimum_distance

/**
 * Used to manage references to datum by AI controllers
 *
 * * tracked_datum - something being added to an ai blackboard
 * * key - the associated key
 */
#define TRACK_AI_DATUM_TARGET(tracked_datum, key) do { \
	if(isweakref(tracked_datum)) { \
		var/datum/weakref/_bad_weakref = tracked_datum; \
		stack_trace("Weakref (Actual datum: [_bad_weakref.resolve()]) found in ai datum blackboard! \
			This is an outdated method of ai reference handling, please remove it."); \
	}; \
	else if(isdatum(tracked_datum)) { \
		var/datum/_tracked_datum = tracked_datum; \
		if(!HAS_TRAIT_FROM(_tracked_datum, TRAIT_AI_TRACKING, "[REF(src)]_[key]")) { \
			RegisterSignal(_tracked_datum, COMSIG_QDELETING, PROC_REF(sig_remove_from_blackboard), override = TRUE); \
			ADD_TRAIT(_tracked_datum, TRAIT_AI_TRACKING, "[REF(src)]_[key]"); \
		}; \
	}; \
} while(FALSE)

/**
 * Used to clear previously set reference handing by AI controllers
 *
 * * tracked_datum - something being removed from an ai blackboard
 * * key - the associated key
 */
#define CLEAR_AI_DATUM_TARGET(tracked_datum, key) do { \
	if(isdatum(tracked_datum)) { \
		var/datum/_tracked_datum = tracked_datum; \
		REMOVE_TRAIT(_tracked_datum, TRAIT_AI_TRACKING, "[REF(src)]_[key]"); \
		if(!HAS_TRAIT(_tracked_datum, TRAIT_AI_TRACKING)) { \
			UnregisterSignal(_tracked_datum, COMSIG_QDELETING); \
		}; \
	}; \
} while(FALSE)

/// Used for above to track all the keys that have registered a signal
#define TRAIT_AI_TRACKING "tracked_by_ai"

/**
 * Sets the key to the passed "thing".
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/set_blackboard_key(key, thing)
	// Assume it is an error when trying to set a value overtop a list
	if(islist(blackboard[key]))
		CRASH("set_blackboard_key attempting to set a blackboard value to key [key] when it's a list!")

	// Clear existing values
	if(!isnull(blackboard[key]))
		clear_blackboard_key(key)

	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] = thing

/**
 * Sets the key at index thing to the passed value
 *
 * Assumes the key value is already a list, if not throws an error.
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/set_blackboard_key_assoc(key, thing, value)
	if(!islist(blackboard[key]))
		CRASH("set_blackboard_key_assoc called on non-list key [key]!")
	TRACK_AI_DATUM_TARGET(thing, key)
	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] = value

/**
 * Similar to [proc/set_blackboard_key_assoc] but operates under the assumption the key is a lazylist (so it will create a list)
 * More dangerous / easier to override values, only use when you want to use a lazylist
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/set_blackboard_key_assoc_lazylist(key, thing, value)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] = value

/**
 * Adds the passed "thing" to the associated key
 *
 * Works with lists or numbers, but not lazylists.
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/add_blackboard_key(key, thing)
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] += thing

/**
 * Similar to [proc/add_blackboard_key], but performs an insertion rather than an add
 * Throws an error if the key is not a list already, intended only for use with lists
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/insert_blackboard_key(key, thing)
	if(!islist(blackboard[key]))
		CRASH("insert_blackboard_key called on non-list key [key]!")
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] |= thing

/**
 * Adds the passed "thing" to the associated key, assuming key is intended to be a lazylist (so it will create a list)
 * More dangerous / easier to override values, only use when you want to use a lazylist
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/add_blackboard_key_lazylist(key, thing)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] += thing

/**
 * Similar to [proc/insert_blackboard_key_lazylist], but performs an insertion / or rather than an add
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/insert_blackboard_key_lazylist(key, thing)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	blackboard[key] |= thing

/**
 * Adds the value to the inner list at key with the inner key set to "thing"
 * Throws an error if the key is not a list already, intended only for use with lists
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/add_blackboard_key_assoc(key, thing, value)
	if(!islist(blackboard[key]))
		CRASH("add_blackboard_key_assoc called on non-list key [key]!")
	TRACK_AI_DATUM_TARGET(thing, key)
	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] += value


/**
 * Similar to [proc/add_blackboard_key_assoc], assuming key is intended to be a lazylist (so it will create a list)
 * More dangerous / easier to override values, only use when you want to use a lazylist
 *
 * * key - A blackboard key, with its value set to a list
 * * thing - a value which becomes the inner list value's key
 * * value - what to set the inner list's value to
 */
/datum/ai_controller/proc/add_blackboard_key_assoc_lazylist(key, thing, value)
	LAZYINITLIST(blackboard[key])
	TRACK_AI_DATUM_TARGET(thing, key)
	TRACK_AI_DATUM_TARGET(value, key)
	blackboard[key][thing] += value

/**
 * Clears the passed key, resetting it to null
 *
 * Not intended for use with list keys - use [proc/remove_thing_from_blackboard_key] if you are removing a value from a list at a key
 *
 * * key - A blackboard key
 */
/datum/ai_controller/proc/clear_blackboard_key(key)
	CLEAR_AI_DATUM_TARGET(blackboard[key], key)
	blackboard[key] = null

/**
 * Remove the passed thing from the associated blackboard key
 *
 * Intended for use with lists, if you're just clearing a reference from a key use [proc/clear_blackboard_key]
 *
 * * key - A blackboard key
 * * thing - a value to set the blackboard key to.
 */
/datum/ai_controller/proc/remove_thing_from_blackboard_key(key, thing)
	var/associated_value = blackboard[key]
	if(thing == associated_value)
		stack_trace("remove_thing_from_blackboard_key was called un-necessarily in a situation where clear_blackboard_key would suffice. ")
		clear_blackboard_key(key)
		return

	if(!islist(associated_value))
		CRASH("remove_thing_from_blackboard_key called with an invalid \"thing\" argument ([thing]). \
			(The associated value of the passed key is not a list and is also not the passed thing, meaning it is clearing an unintended value.)")

	for(var/inner_key in associated_value)
		if(inner_key == thing)
			// flat list
			CLEAR_AI_DATUM_TARGET(thing, key)
			associated_value -= thing
			return
		else if(associated_value[inner_key] == thing)
			// assoc list
			CLEAR_AI_DATUM_TARGET(thing, key)
			associated_value -= inner_key
			return

	CRASH("remove_thing_from_blackboard_key called with an invalid \"thing\" argument ([thing]). \
		(The passed value is not tracked in the passed list.)")

/// Signal proc to go through every key and remove the datum from all keys it finds
/datum/ai_controller/proc/sig_remove_from_blackboard(datum/source)
	SIGNAL_HANDLER

	var/list/list/remove_queue = list(blackboard)
	var/index = 1
	while(index <= length(remove_queue))
		var/list/next_to_clear = remove_queue[index]
		for(var/inner_value in next_to_clear)
			var/associated_value = next_to_clear[inner_value]
			// We are a lists of lists, add the next value to the queue so we can handle references in there
			// (But we only need to bother checking the list if it's not empty.)
			if(islist(inner_value) && length(inner_value))
				UNTYPED_LIST_ADD(remove_queue, inner_value)

			// We found the value that's been deleted. Clear it out from this list
			else if(inner_value == source)
				next_to_clear -= inner_value

			// We are an assoc lists of lists, the list at the next value so we can handle references in there
			// (But again, we only need to bother checking the list if it's not empty.)
			if(islist(associated_value) && length(associated_value))
				UNTYPED_LIST_ADD(remove_queue, associated_value)

			// We found the value that's been deleted, it was an assoc value. Clear it out entirely
			else if(associated_value == source)
				next_to_clear -= inner_value

		index += 1

#undef TRACK_AI_DATUM_TARGET
#undef CLEAR_AI_DATUM_TARGET
#undef TRAIT_AI_TRACKING
