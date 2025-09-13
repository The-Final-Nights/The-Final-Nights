/datum/discipline/temporis
	name = "Temporis"
	desc = "Temporis is a Discipline unique to the True Brujah. Supposedly a refinement of Celerity, Temporis grants the Cainite the ability to manipulate the flow of time itself."
	icon_state = "temporis"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/temporis

/datum/discipline_power/temporis
	name = "Temporis power name"
	desc = "Temporis power description"

	activate_sound = 'code/modules/wod13/sounds/temporis.ogg'

/datum/discipline_power/temporis/proc/celerity_explode(datum/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER

	if (!istype(power, /datum/discipline_power/celerity))
		return
	to_chat(owner, span_userdanger("You try to use Celerity, but your active Temporis causes your body to wrench itself apart!"))
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream")
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, gib)), 3 SECONDS)

	return POWER_CANCEL_ACTIVATION

//HOURGLASS OF THE MIND
/datum/discipline_power/temporis/hourglass_of_the_mind
	name = "Hourglass of the Mind"
	desc = "Gain a perfect sense of time. Know exactly when you are, and share this knowledge with others."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0
	range = 7

/datum/discipline_power/temporis/hourglass_of_the_mind/activate()
	. = ..()
	//Display time
	to_chat(owner, span_notice("<b>[SScity_time.timeofnight]</b>"))
	//Check range for targets with Temporis and display them, if any exist
	var/list/targets = list()
	for(var/mob/living/carbon/human/target in view(range, owner))
		if(target == owner)
			continue
		if(iskindred(target))
			var/datum/species/kindred/vampire = target.dna.species
			if(vampire.get_discipline("Temporis"))
				targets += target
	if(targets.len)
		var/target_list = ""
		for(var/i = 1 to targets.len)
			var/mob/living/carbon/human/target = targets[i]
			target_list += target.name
			if(i < targets.len - 1)
				target_list += ", "
			else if(i == targets.len - 1)
				target_list += " and "
		to_chat(owner, span_notice("[english_list(targets)] [targets.len == 1 ? "has" : "have"] temporal distortions around [targets.len == 1 ? "themself" : "themselves"]."))
	else
		to_chat(owner, span_notice("There are no temporal distortions nearby."))
	return TRUE

//RECURRING CONTEMPLATION
/datum/discipline_power/temporis/recurring_contemplation
	name = "Recurring Contemplation"
	desc = "Trap your target into repeating the same set of actions."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7

	hostile = TRUE

	cooldown_length = 1 TURNS

/datum/discipline_power/temporis/recurring_contemplation/activate(mob/living/target)
	. = ..()
	//Roll for degree of success, mentality + social vs mentality in place of manipulation + occult vs willpower
	var/mypower = owner.get_total_mentality() + owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	var/rollsuccess = SSroll.storyteller_roll(mypower, difficulty = theirpower, mobs_to_show_output = owner, numerical = TRUE)
	if(rollsuccess > 0)
		target.AddComponent(/datum/component/dejavu, rewinds = rollsuccess, interval = 2 SECONDS)
	else
		to_chat(owner, span_userdanger("<b>You fail to affect your target!</b>"))
		return

//LEADEN MOMENT
/datum/movespeed_modifier/temporis3
	//Modifier applied by Leaden Moment, default value of 1
	multiplicative_slowdown = 1

/datum/discipline_power/temporis/leaden_moment
	name = "Leaden Moment"
	desc = "Slow time around your opponent, reducing their speed."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7

	hostile = TRUE

	duration_length = 15 SECONDS
	cooldown_length = 1 TURNS
	duration_override = TRUE

	//Variables for speed value modifier & dynamic duration
	var/datum/movespeed_modifier/temporis3/active_mod
	var/discduration

/datum/discipline_power/temporis/leaden_moment/activate(mob/living/target)
	. = ..()
	if(!.)
		return FALSE

	//Roll for degree of success, mentality + social in place of intelligence + occult
	var/dice = owner.get_total_mentality() + owner.get_total_social()
	var/success = SSroll.storyteller_roll(dice, difficulty = 6, mobs_to_show_output = owner, numerical = TRUE)
	var/trueroll = abs(success)
	if(!success)
		return FALSE
	//Discipline duration, 1 turn per 2 successes, rounded up
	var/discduration = CEILING(trueroll/2,1) TURNS
	//Half movement & action speed at 1 success, scaling per 2 successes after (1/3 at 3, 1/4 at 5, etc)
	var/slowdown = 1 + CEILING(trueroll/2,1)
	var/mob/living/affected_mob

	//Determine targets, start timers
	if(success > 0)
		addtimer(CALLBACK(src, PROC_REF(deactivate),target), discduration)
		to_chat(target, span_userdanger("<b>Time seems to slow to a crawl around you...</b>"))
		affected_mob = target
	else if(success < 0)
		//Botch causes the owner to be slowed instead
		addtimer(CALLBACK(src, PROC_REF(deactivate)), discduration)
		to_chat(owner, span_userdanger("<b>Your temporal manipulation backfires!</b>"))
		affected_mob = owner

	//Apply modifiers to target
	active_mod = new
	active_mod.multiplicative_slowdown = slowdown
	affected_mob.add_movespeed_modifier(active_mod, TRUE)
	affected_mob.next_move_modifier *= slowdown
	return TRUE

/datum/discipline_power/temporis/leaden_moment/deactivate(mob/living/target)
	. = ..()
	if(active_mod)
		if(target)
			target.remove_movespeed_modifier(active_mod, TRUE)
			target.next_move_modifier /= active_mod.multiplicative_slowdown
		if(owner)
			owner.remove_movespeed_modifier(active_mod, TRUE)
			owner.next_move_modifier /= active_mod.multiplicative_slowdown
		qdel(active_mod)
		active_mod = null

//COWALKER
/datum/discipline_power/temporis/cowalker
	name = "Cowalker"
	desc = "Be in multiple places at once, creating several false images."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE

	toggled = TRUE
	duration_length = 2 TURNS

/datum/discipline_power/temporis/cowalker/activate()
	. = ..()
	var/matrix/initial_matrix = matrix(owner.transform)
	var/matrix/secondary_matrix = matrix(owner.transform)
	var/matrix/tertiary_matrix = matrix(owner.transform)
	initial_matrix.Translate(1,0)
	secondary_matrix.Translate(0,1)
	tertiary_matrix.Translate(1)
	animate(owner, transform = initial_matrix, time = 1 SECONDS, loop = 0)
	animate(owner, transform = secondary_matrix, time = 1 SECONDS, loop = 0, ANIMATION_PARALLEL)
	animate(owner, transform = tertiary_matrix, time = 1 SECONDS, loop = 0, ANIMATION_PARALLEL)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(temporis_visual))
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(celerity_explode))

/datum/discipline_power/temporis/cowalker/deactivate()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

/datum/discipline_power/temporis/cowalker/proc/temporis_visual(datum/discipline_power/temporis/source, atom/newloc, dir)
	SIGNAL_HANDLER

	spawn()
		var/obj/effect/temporis/temporis_visual = new(owner.loc)
		temporis_visual.name = owner.name
		temporis_visual.appearance = owner.appearance
		temporis_visual.dir = owner.dir
		animate(temporis_visual, pixel_x = rand(-32,32), pixel_y = rand(-32,32), alpha = 255, time = 1 SECONDS)
		SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

/obj/effect/temporis
	name = "Za Warudo"
	desc = "..."
	anchored = 1

/obj/effect/temporis/Initialize()
	. = ..()
	spawn(0.5 SECONDS)
		qdel(src)

//CLOTHO'S GIFT
/datum/movespeed_modifier/temporis5
	//Modifier applied by Clotho's Gift
	var/speed_modifier

/datum/discipline_power/temporis/clothos_gift
	name = "Clotho's Gift"
	desc = "Accelerate yourself through time and magnify your speed."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 3

	violates_masquerade = TRUE

	duration_length = 3 TURNS
	cooldown_length = 1 TURNS

	//Speed modifier & active modifier
	var/speed_modifier
	var/datum/movespeed_modifier/temporis5/active_modifier

/datum/discipline_power/temporis/clothos_gift/activate()
	. = ..()

	//Roll for degree of success, mentality + social in place of intelligence + occult
	var/dice = owner.get_total_mentality() + owner.get_total_social()
	var/success = SSroll.storyteller_roll(dice, difficulty = 7, mobs_to_show_output = owner, numerical = TRUE)
	if(success > 0)
		cancelable = TRUE
	else
		cancelable = FALSE

	//Applying the modifiers
	active_modifier = new
	active_modifier.speed_modifier = success
	active_modifier.multiplicative_slowdown = -success
	owner.add_movespeed_modifier(active_modifier)
	owner.next_move_modifier *= (1/(1+success))
	speed_modifier = success

	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(temporis_visual))
	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(celerity_explode))

/datum/discipline_power/temporis/clothos_gift/deactivate()
	. = ..()
	//Removing the modifiers
	if(active_modifier)
		if(active_modifier != 0)
			owner.remove_movespeed_modifier(active_modifier)
		qdel(active_modifier)
		active_modifier = null
	owner.next_move_modifier *= (1+speed_modifier)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)

/datum/discipline_power/temporis/clothos_gift/proc/temporis_visual(datum/discipline_power/temporis/source, atom/newloc, dir)
	SIGNAL_HANDLER

	spawn()
		var/obj/effect/temporis/temporis_visual = new(owner.loc)
		temporis_visual.name = owner.name
		temporis_visual.appearance = owner.appearance
		temporis_visual.dir = owner.dir
		animate(temporis_visual, pixel_x = rand(-32,32), pixel_y = rand(-32,32), alpha = 155, time = 0.5 SECONDS)
		SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

//KISS OF LACHESIS
/datum/discipline_power/temporis/kiss_of_lachesis
	name = "Kiss of Lachesis"
	desc = "Change a target's biological age."

	level = 6
	target_type = TARGET_HUMAN
	range = 7

	hostile = TRUE

	cooldown_length = 15 SECONDS

/datum/discipline_power/temporis/kiss_of_lachesis/activate(mob/living/carbon/human/target)
	. = ..()
	var/new_age = tgui_input_number(owner, "Choose your target's biological age:\n([AGE_MIN]-[AGE_MAX])", "Kiss of Lachesis", target.age, AGE_MAX, AGE_MIN, round_value = TRUE)
	target.age = clamp(new_age, AGE_MIN, AGE_MAX)
	target.update_hair()
	target.update_body()
