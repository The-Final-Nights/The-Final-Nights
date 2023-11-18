/// Checks for RIGHT_CLICK in modifiers and runs resolve_right_click_attack if so. Returns TRUE if normal chain blocked.
/mob/living/proc/right_click_attack_chain(atom/target, list/modifiers)
	if (!LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	var/secondary_result = resolve_right_click_attack(target, modifiers)

	if (secondary_result == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || secondary_result == SECONDARY_ATTACK_CONTINUE_CHAIN)
		return TRUE
	else if (secondary_result != SECONDARY_ATTACK_CALL_NORMAL)
		CRASH("resolve_right_click_attack (probably attack_hand_secondary) did not return a SECONDARY_ATTACK_* define.")

/**
 * Checks if this mob is in a valid state to punch someone.
 */
/mob/living/proc/can_unarmed_attack()
	return !HAS_TRAIT(src, TRAIT_HANDS_BLOCKED)

/mob/living/carbon/can_unarmed_attack()
	. = ..()
	if(!.)
		return FALSE

	if(!has_active_hand()) //can't attack without a hand.
		var/obj/item/bodypart/check_arm = get_active_hand()
		if(check_arm?.bodypart_disabled)
			to_chat(src, span_warning("Your [check_arm.name] is in no condition to be used."))
			return FALSE

		to_chat(src, span_notice("You look at your arm and sigh."))
		return FALSE

	return TRUE

/mob/living/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	// The sole reason for this signal needing to exist is making FotNS incompatible with Hulk.
	// Note that it is send before [proc/can_unarmed_attack] is called, keep this in mind.
	var/sigreturn = SEND_SIGNAL(src, COMSIG_LIVING_EARLY_UNARMED_ATTACK, attack_target, modifiers)
	if(sigreturn & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(sigreturn & COMPONENT_SKIP_ATTACK)
		return FALSE

	if(!can_unarmed_attack())
		return FALSE

	sigreturn = SEND_SIGNAL(src, COMSIG_LIVING_UNARMED_ATTACK, attack_target, proximity_flag, modifiers)
	if(sigreturn & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(sigreturn & COMPONENT_SKIP_ATTACK)
		return FALSE

	if(!right_click_attack_chain(attack_target, modifiers))
		resolve_unarmed_attack(attack_target, modifiers)
	return TRUE

/mob/living/carbon/human/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	// Humans can always check themself regardless of having their hands blocked or w/e
	if(src == attack_target && !combat_mode && HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		check_self_for_injuries()
		return TRUE

	return ..()

/mob/living/carbon/resolve_unarmed_attack(atom/attack_target, list/modifiers)
	return attack_target.attack_paw(src, modifiers)

/mob/living/carbon/human/resolve_unarmed_attack(atom/attack_target, list/modifiers)
	if(!ISADVANCEDTOOLUSER(src))
		return ..()

	return attack_target.attack_hand(src, modifiers)

		if (secondary_result == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN || secondary_result == SECONDARY_ATTACK_CONTINUE_CHAIN)
			return
		else if (secondary_result != SECONDARY_ATTACK_CALL_NORMAL)
			CRASH("attack_hand_secondary did not return a SECONDARY_ATTACK_* define.")

	A.attack_hand(src, modifiers)

/// Return TRUE to cancel other attack hand effects that respect it. Modifiers is the assoc list for click info such as if it was a right click.
/atom/proc/attack_hand(mob/user, modifiers)
	. = FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND))
		add_fingerprint(user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		. = TRUE
	if(interaction_flags_atom & INTERACT_ATOM_ATTACK_HAND)
		. = _try_interact(user)

/// When the user uses their hand on an item while holding right-click
/// Returns a SECONDARY_ATTACK_* value.
/atom/proc/attack_hand_secondary(mob/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND_SECONDARY, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return SECONDARY_ATTACK_CALL_NORMAL

//Return a non FALSE value to cancel whatever called this from propagating, if it respects it.
/atom/proc/_try_interact(mob/user)
	if(isAdminGhostAI(user))		//admin abuse
		return interact(user)
	if(can_interact(user))
		return interact(user)
	return FALSE

/atom/proc/can_interact(mob/user)
	if(!user.can_interact_with(src))
		return FALSE
	if((interaction_flags_atom & INTERACT_ATOM_REQUIRES_DEXTERITY) && !ISADVANCEDTOOLUSER(user))
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return FALSE
	if(!(interaction_flags_atom & INTERACT_ATOM_IGNORE_INCAPACITATED) && user.incapacitated((interaction_flags_atom & INTERACT_ATOM_IGNORE_RESTRAINED), !(interaction_flags_atom & INTERACT_ATOM_CHECK_GRAB)))
		return FALSE
	return TRUE

/atom/ui_status(mob/user)
	. = ..()
	if(!can_interact(user))
		. = min(., UI_UPDATE)

/atom/movable/can_interact(mob/user)
	. = ..()
	if(!.)
		return
	if(!anchored && (interaction_flags_atom & INTERACT_ATOM_REQUIRES_ANCHORED))
		return FALSE

/atom/proc/interact(mob/user)
	if(interaction_flags_atom & INTERACT_ATOM_NO_FINGERPRINT_INTERACT)
		add_hiddenprint(user)
	else
		add_fingerprint(user)
	if(interaction_flags_atom & INTERACT_ATOM_UI_INTERACT)
		return ui_interact(user)
	return FALSE


/mob/living/carbon/human/RangedAttack(atom/A, modifiers)
	. = ..()
	if(.)
		return
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0,modifiers)) // for magic gloves
			return TRUE

	if(isturf(A) && get_dist(src,A) <= 1)
		Move_Pulled(A)
		return TRUE

/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	A.attack_animal(src)

/**
 * Called when the unarmed attack hasn't been stopped by the LIVING_UNARMED_ATTACK_BLOCKED macro or the right_click_attack_chain proc.
 * This will call an attack proc that can vary from mob type to mob type on the target.
 */
/mob/living/proc/resolve_unarmed_attack(atom/attack_target, list/modifiers)
	attack_target.attack_animal(src, modifiers)

/**
 * Called when an unarmed attack performed with right click hasn't been stopped by the LIVING_UNARMED_ATTACK_BLOCKED macro.
 * This will call a secondary attack proc that can vary from mob type to mob type on the target.
 * Sometimes, a target is interacted differently when right_clicked, in that case the secondary attack proc should return
 * a SECONDARY_ATTACK_* value that's not SECONDARY_ATTACK_CALL_NORMAL.
 * Otherwise, it should just return SECONDARY_ATTACK_CALL_NORMAL. Failure to do so will result in an exception (runtime error).
 */
/mob/living/proc/resolve_right_click_attack(atom/target, list/modifiers)
	return target.attack_animal_secondary(src, modifiers)

/**
 * Called when a simple animal is unarmed attacking / clicking on this atom.
 */
/atom/proc/attack_animal(mob/user, list/modifiers)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_ANIMAL, user)

///Attacked by monkey
/atom/proc/attack_paw(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_PAW, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE


/*
	Aliens
	Defaults to same as monkey in most places
*/
/mob/living/carbon/alien/resolve_unarmed_attack(atom/attack_target, list/modifiers)
	attack_target.attack_alien(src, modifiers)

/mob/living/carbon/alien/resolve_right_click_attack(atom/target, list/modifiers)
	return target.attack_alien_secondary(src, modifiers)

/atom/proc/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	return attack_paw(user, modifiers)

/**
 * Called when an alien right clicks an atom.
 * Returns a SECONDARY_ATTACK_* value.
 */
/atom/proc/attack_alien_secondary(mob/living/carbon/alien/user, list/modifiers)
	return SECONDARY_ATTACK_CALL_NORMAL

// Babby aliens
/mob/living/carbon/alien/larva/UnarmedAttack(atom/A)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	A.attack_larva(src)

/atom/proc/attack_larva(mob/user)
	return

/*
	Slimes
	Nothing happening here
*/
/mob/living/simple_animal/slime/UnarmedAttack(atom/A)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(isturf(A))
		return ..()
	A.attack_slime(src)

/atom/proc/attack_slime(mob/user)
	return


/*
	Drones
*/
/mob/living/simple_animal/drone/UnarmedAttack(atom/A)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	A.attack_drone(src)

/atom/proc/attack_drone(mob/living/simple_animal/drone/user)
	attack_hand(user) //defaults to attack_hand. Override it when you don't want drones to do same stuff as humans.


/*
	Brain
*/

/mob/living/brain/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return


/*
	pAI
*/

/mob/living/silicon/pai/UnarmedAttack(atom/A)//Stops runtimes due to attack_animal being the default
	return


/*
	Simple animals
*/

/mob/living/simple_animal/UnarmedAttack(atom/A, proximity)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(!dextrous)
		return ..()
	if(!ismob(A))
		A.attack_hand(src)
		update_inv_hands()


/mob/living/carbon/werewolf/crinos/UnarmedAttack(atom/A, proximity)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	if(A)
		if(a_intent == INTENT_HARM)
			if(istype(A, /mob/living))
				var/mob/living/target = A
				target.adjustCloneLoss(2)
				if(src.tox_damage_plus)
					target.adjustToxLoss(src.tox_damage_plus)
					to_chat(src, "<span class='notice'>Your toxic claws seep into [target]'s flesh!</span>")
				if(src.agg_damage_plus)
					target.adjustCloneLoss(src.agg_damage_plus)
					to_chat(src, "<span class='notice'>Your razor sharp claws rip through [target]'s flesh!</span>")
			return ..()
		A.attack_hand(src)
		update_inv_hands()

/atom/proc/attack_crinos(mob/user)
	return


/*
	Hostile animals
*/

/mob/living/simple_animal/hostile/UnarmedAttack(atom/A)
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		return
	target = A
	if(dextrous && !ismob(A))
		..()
	else
		AttackingTarget(A)


/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/dead/new_player/ClickOn()
	return
