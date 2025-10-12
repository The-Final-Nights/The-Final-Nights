/datum/discipline/obtenebration
	name = "Obtenebration"
	desc = "Controls the darkness around you."
	icon_state = "obtenebration"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/obtenebration

/datum/discipline/obtenebration/post_gain()
	. = ..()
	var/datum/action/mysticism/mystic = new()
	owner.mysticism_knowledge = TRUE
	mystic.Grant(owner)
	mystic.level = level
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/mystome)

/datum/discipline_power/obtenebration
	name = "Obtenebration power name"
	desc = "Obtenebration power description"

	effect_sound = 'sound/magic/voidblink.ogg'

// **************************************************************** SHADOW PLAY *************************************************************
/datum/discipline_power/obtenebration/shadow_play
	name = "Shadow Play"
	desc = "Manipulate shadows to block visibility."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_TURF | TARGET_MOB | TARGET_OBJ | TARGET_SELF
	range = 7
	vitae_cost = 1

	multi_activate = TRUE
	duration_length = 1 SCENES
	cooldown_length = 1 TURNS

	var/list/shadows = list() // A list of all active shadows
	var/datum/action/clear_shadows/cbutton // The button to clear everything

/datum/discipline_power/obtenebration/shadow_play/activate(target)
	. = ..()
	var/atom/movable/new_shadow = new(target)
	new_shadow.set_light(discipline.level+2, -10) // Ideally, the shadows would be a special thing impenetrable by anyone but the user, but this works for now
	shadows += new_shadow

	if(!cbutton) // Grant the button if it doesn't exist
		cbutton = new(src)
		cbutton.Grant(owner)

	addtimer(CALLBACK(src, .proc/remove_shadow, new_shadow), duration_length) // 3 minute timer per shadow

/datum/discipline_power/obtenebration/shadow_play/proc/remove_shadow(atom/movable/old_shadow)
	if(old_shadow && (old_shadow in shadows)) // Check if shadow still exists
		shadows -= old_shadow
		qdel(old_shadow)

	if(!length(shadows) && cbutton) // Remove the button if there are no shadows left
		cbutton.Remove(owner)
		QDEL_NULL(cbutton)

/datum/discipline_power/obtenebration/shadow_play/proc/remove_all_shadows()
	for(var/atom/movable/all_shadows in shadows)
		qdel(all_shadows)
	shadows.Cut()

	if(cbutton)
		cbutton.Remove(owner)
		QDEL_NULL(cbutton)

// **************************************************************** SHROUD OF NIGHT *************************************************************
/datum/discipline_power/obtenebration/shroud_of_night
	name = "Shroud of Night"
	desc = "Turn the shadows into appendages to pull your enemies."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 7

	aggravating = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/obtenebration/shroud_of_night/pre_activation_checks(atom/target)
	if(SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_OCCULT), 7, FALSE, owner))
		return TRUE
	return FALSE

/datum/discipline_power/obtenebration/shroud_of_night/activate(mob/living/target)
	. = ..()
	target.Stun(1 SECONDS)
	var/obj/item/ammo_casing/magic/tentacle/lasombra/casing = new (owner.loc)
	casing.fire_casing(target, owner, null, null, null, ran_zone(), 0,  owner)

// **************************************************************** ARMS OF THE ABYSS *************************************************************
/datum/discipline_power/obtenebration/arms_of_the_abyss
	name = "Arms of the Abyss"
	desc = "Use shadows as your arms to harm and grab others from afar."

	level = 3
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_TURF
	range = 7

	violates_masquerade = TRUE
	cooldown_length = 1 TURNS

/datum/discipline_power/obtenebration/arms_of_the_abyss/activate(var/atom/target)
	. = ..()
	var/turf/target_turf = get_turf(target)
	var/dice = (owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_OCCULT))

	if(target_turf && target_turf.get_lumcount() <= 0.4) // Only works if the area is dark enough. Modify as needed.
		// Remove any existing tentacles first
		for(var/mob/living/simple_animal/hostile/abyss_tentacle/T in world)
			if(T.owner == owner)
				T.release_grabbed_mob()
				qdel(T)
		var/roll = SSroll.storyteller_roll(dice, 7, TRUE, owner)
		var/has_action = FALSE
		for(var/datum/action/A in owner.actions)
			if(istype(A, /datum/action/aggro_mode))
				has_action = TRUE
				break

		// Grant the aggro mode button if it doesn't exist
		if(!has_action)
			var/datum/action/aggro_mode/A = new()
			A.Grant(owner)

		// Create tentacles based on successes
		for(var/i in 1 to roll)
			// For the first tentacle, use the target turf
			if(i == 1 && !target_turf.is_blocked_turf(exclude_mobs = TRUE))
				new /mob/living/simple_animal/hostile/abyss_tentacle(target_turf, owner)
			else
				// For additional tentacles, find nearby valid turfs
				var/list/open_turfs = list()
				for(var/turf/T in orange(3, target_turf))
					if(!T.is_blocked_turf(exclude_mobs = TRUE) && T.get_lumcount() <= 0.4)
						open_turfs += T
				if(open_turfs.len)
					new /mob/living/simple_animal/hostile/abyss_tentacle(pick(open_turfs), owner)
	else
		to_chat(usr, span_warning("The area is too bright for the shadows to manifest!"))
		return FALSE

// **************************************************************** BLACK METAMORPHOSIS *************************************************************
/datum/discipline_power/obtenebration/black_metamorphosis
	name = "Black Metamorphosis"
	desc = "Fuse with your inner darkness, gaining shadowy armor."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 0

	violates_masquerade = TRUE

	toggled = TRUE
	duration_length = 999 SCENES

	var/activating = FALSE
	var/successful = FALSE

/datum/discipline_power/obtenebration/black_metamorphosis/pre_activation_checks()
	. = ..()
	if(activating) // Prevent multi-activation while the do_after is ongoing
		to_chat(owner, span_warning("You are already attempting to activate Black Metamorphosis!"))
		return FALSE
	else if(!activating)
		if(owner.bloodpool >= 2)
			owner.bloodpool -= 2 // Pay the cost here to prevent spending more from multi-activation attempts
		else
			to_chat(owner, span_warning("You do not have enough vitae to activate Black Metamorphosis!"))
			return FALSE

	if(owner.generation >= 10)
		activating = TRUE
		to_chat(owner, span_warning("Your body starts to meld with the shadows..."))
		if(do_after(owner, 2 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM)))
			return TRUE
	else if(owner.generation <= 9)
		activating = TRUE
		to_chat(owner, span_warning("Your body starts to rapidly meld with the shadows..."))
		if(do_after(owner, 1 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM)))
			return TRUE

/datum/discipline_power/obtenebration/black_metamorphosis/activate()
	. = ..()
	activating = FALSE
	var/roll = SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_COURAGE), 7, FALSE, owner)
	if(roll == ROLL_SUCCESS)
		successful = TRUE
		owner.physiology.damage_resistance += 60
		animate(owner, color = "#000000", time = 1 SECONDS, loop = 1)
		to_chat(owner, span_green("You successfully fuse with the shadows!"))
	else if(roll == ROLL_FAILURE)
		to_chat(owner, span_warning("You fail to control the shadows!"))
		deactivate()
	else if(roll == ROLL_BOTCH)
		owner.apply_damage(60, BRUTE) // 2 levels of lethal damage on a botch
		to_chat(owner, span_danger("The shadows lash out at you as you fail to fuse with them!"))
		deactivate()

/datum/discipline_power/obtenebration/black_metamorphosis/deactivate()
	. = ..()
	if(!successful)
		return
	to_chat(owner, span_notice("The shadows fall away from your body."))
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	owner.physiology.damage_resistance -= 60
	animate(owner, color = initial(owner.color), time = 1 SECONDS, loop = 1)

// **************************************************************** TENEBROUS FORM *************************************************************
/datum/discipline_power/obtenebration/tenebrous_form
	name = "Tenebrous Form"
	desc = "Become a shadow and resist all but fire, sunlight, and magic!"

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	vitae_cost = 0
	duration_length = 999 SCENES
	toggled = TRUE

	violates_masquerade = TRUE

	cooldown_length = 1 TURNS
	var/activating = FALSE
	var/saved_brute_mod = 1
	var/saved_clone_mod = 1
	var/saved_stamina_mod = 1
	var/saved_brain_mod = 1
	var/saved_density

/datum/discipline_power/obtenebration/tenebrous_form/pre_activation_checks()
	. = ..()
	if(activating) // Prevent multi-activation while the do_after is ongoing
		to_chat(owner, span_warning("You are already attempting to activate Tenebrous Form!"))
		return FALSE
	else if(!activating)
		if(owner.bloodpool >= 3)
			owner.bloodpool -= 3 // Pay the cost here to prevent spending more from multi-activation attempts
		else
			to_chat(owner, span_warning("You do not have enough vitae to activate Tenebrous Form!"))
			return FALSE

	// do_after timer based on generation; gen 9 and below can spend more BP per turn, so it activates faster
	if(owner.generation >= 10)
		activating = TRUE
		to_chat(owner, span_warning("Your body slowly starts to turn into an inky blot of shadow..."))
		if(do_after(owner, 3 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM)))
			return TRUE
	else if(owner.generation == 9)
		activating = TRUE
		to_chat(owner, span_warning("Your body starts to turn into an inky blot of shadow..."))
		if(do_after(owner, 2 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM)))
			return TRUE
	else if(owner.generation <= 8)
		activating = TRUE
		to_chat(owner, span_warning("Your body rapidly starts to turn into an inky blot of shadow..."))
		if(do_after(owner, 1 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM)))
			return TRUE

/datum/discipline_power/obtenebration/tenebrous_form/activate()
	. = ..()
	activating = FALSE
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	saved_brute_mod = owner.physiology.brute_mod
	owner.physiology.brute_mod = 0
	saved_clone_mod = owner.physiology.clone_mod
	owner.physiology.clone_mod = 0
	saved_stamina_mod = owner.physiology.stamina_mod
	owner.physiology.stamina_mod = 0
	saved_brain_mod = owner.physiology.brain_mod
	owner.physiology.brain_mod = 0
	animate(owner, color = "#000000", time = 1 SECONDS, loop = 1)

	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_PACIFISM, MAGIC_TRAIT) // Can't physically attack while in this form
	ADD_TRAIT(owner, TRAIT_MOVE_FLYING, MAGIC) // Flying to simulate being unaffected by gravity
	ADD_TRAIT(owner, TRAIT_PASSDOOR, MAGIC) // Trait to phase through doors
	ADD_TRAIT(owner, TRAIT_PASSTABLE, MAGIC) // Trait to phase through tables

	saved_density = owner.density
	owner.density = FALSE

/datum/discipline_power/obtenebration/tenebrous_form/deactivate()
	. = ..()
	to_chat(owner, span_notice("You return to your normal form."))
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	owner.physiology.brute_mod = saved_brute_mod
	owner.physiology.clone_mod = saved_clone_mod
	owner.physiology.stamina_mod = saved_stamina_mod
	owner.physiology.brain_mod = saved_brain_mod
	animate(owner, color = initial(owner.color), time = 1 SECONDS, loop = 1)

	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_MOVE_FLYING, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_PASSDOOR, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_PASSTABLE, MAGIC)

	owner.density = saved_density

//SHADOWSTEP
/datum/discipline_power/obtenebration/shadowstep
	name = "Shadowstep"
	desc = "Become one with the shadows and move without your physical form."

	level = 6
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	vitae_cost = 0

	violates_masquerade = TRUE

	cooldown_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shadowwalk/shadowstep

/datum/discipline_power/obtenebration/shadowstep/activate()
	. = ..()
	if (!shadowstep)
		shadowstep = new

	shadowstep.cast(user = owner)

// **************************************************************** ACTIONS ****************************************************************

// Aggro mode control for Arms of the Abyss
/datum/action/aggro_mode
	name = "Tentacle Control"
	desc = "Switches the aggro mode of your Arms of the Abyss"
	icon_icon = 'icons/hud/screen_glass.dmi'
	button_icon_state = "harm"
	var/current_mode = "Aggressive"

/datum/action/aggro_mode/New()
	..()
	button.name = name
	update_icon_state()

/datum/action/aggro_mode/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/mob/user = owner
	if(!isliving(user))
		return
	var/mob/living/Tuser = user
	var/list/options = list(
		"Aggressive" = "Aggressive (grab and damage targets)",
		"Control" = "Control (grab and restrain without damage)",
		"Passive" = "Passive (don't attack or grab)"
	)

	var/select = tgui_input_list(user, "Select tentacle behaviour", "Tentacle Mode", options)
	if(!select || !Tuser)
		return
	current_mode = select
	Tuser.tentacle_aggro_mode = select

	var/tentacles = 0
	for(var/mob/living/simple_animal/hostile/abyss_tentacle/T in world)
		if(T.owner == Tuser)
			T.aggro_mode = select
			tentacles++

	if(tentacles)
		to_chat(Tuser, span_notice("You set your tentacle[tentacles == 1 ? "" : "s"] to [select] mode."))
		update_icon_state()

/datum/action/aggro_mode/proc/update_icon_state()
	if(button)
		button.overlays.Cut()
		button.icon = null
		button.icon_state = ""

	switch(current_mode)
		if("Aggressive")
			button_icon_state = "harm"
		if("Control")
			button_icon_state = "grab"
		if("Passive")
			button_icon_state = "disarm"

	if(button)
		button.icon = icon_icon
		button.icon_state = button_icon_state

// Shadow removal button for Shadow Play
/datum/action/clear_shadows
	name = "Clear Shadows"
	desc = "Clears all currently active Shadow Play shadows"
	icon_icon = 'icons/effects/genetics.dmi'
	button_icon_state = "shadow_portal"
	var/datum/discipline_power/obtenebration/shadow_play/power

/datum/action/clear_shadows/New(Target)
	. = ..()
	power = Target

/datum/action/clear_shadows/Trigger(trigger_flags)
	. = ..()
	if(.)
		power.remove_all_shadows()
