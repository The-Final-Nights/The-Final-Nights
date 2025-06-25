/datum/component/butchering
	/// Time in deciseconds taken to butcher something
	var/speed = 8 SECONDS
	/// Percentage effectiveness; numbers above 100 yield extra drops
	var/effectiveness = 100
	/// Percentage increase to bonus item chance
	var/bonus_modifier = 0
	/// Sound played when butchering
	var/butcher_sound = 'sound/effects/butcher.ogg'
	/// Whether or not this component can be used to butcher currently. Used to temporarily disable butchering
	var/butchering_enabled = TRUE
	/// Whether or not this component is compatible with blunt tools.
	var/can_be_blunt = FALSE

/datum/component/butchering/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt)
	if(_speed)
		speed = _speed
	if(_effectiveness)
		effectiveness = _effectiveness
	if(_bonus_modifier)
		bonus_modifier = _bonus_modifier
	if(_butcher_sound)
		butcher_sound = _butcher_sound
	if(disabled)
		butchering_enabled = FALSE
	if(_can_be_blunt)
		can_be_blunt = _can_be_blunt
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(onItemAttack))

/datum/component/butchering/proc/onItemAttack(obj/item/source, mob/living/M, mob/living/user)
	SIGNAL_HANDLER

	if(M.stat == DEAD && (M.butcher_results || M.guaranteed_butcher_results)) //can we butcher it?
		if(butchering_enabled && (can_be_blunt || source.get_sharpness()))
			INVOKE_ASYNC(src, PROC_REF(startButcher), source, M, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN

	if(ishuman(M) && source.force && source.get_sharpness())
		var/mob/living/carbon/human/H = M
		if((user.pulling == H && user.grab_state >= GRAB_AGGRESSIVE) && user.zone_selected == BODY_ZONE_HEAD) // Only aggressive grabbed can be sliced.
			if(!H.has_status_effect(/datum/status_effect/neck_slice))
				INVOKE_ASYNC(src, PROC_REF(startNeckSlice), source, H, user)
				return COMPONENT_CANCEL_ATTACK_CHAIN
			INVOKE_ASYNC(src, PROC_REF(start_decap), source, H, user)
			return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/butchering/proc/startButcher(obj/item/source, mob/living/M, mob/living/user)
	to_chat(user, "<span class='notice'>You begin to butcher [M]...</span>")
	playsound(M.loc, butcher_sound, 50, TRUE, -1)
	if(do_mob(user, M, speed) && M.Adjacent(source))
		Butcher(user, M)

/datum/component/butchering/proc/startNeckSlice(obj/item/source, mob/living/carbon/human/H, mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, H))
		to_chat(user, "<span class='warning'>You're already interacting with [H]!</span>")
		return

	user.visible_message("<span class='danger'>[user] is slitting [H]'s throat!</span>", \
					"<span class='danger'>You start slicing [H]'s throat!</span>", \
					"<span class='hear'>You hear a cutting noise!</span>", ignored_mobs = H)
	H.show_message("<span class='userdanger'>Your throat is being slit by [user]!</span>", MSG_VISUAL, \
					"<span class = 'userdanger'>Something is cutting into your neck!</span>", NONE)
	log_combat(user, H, "starts slicing the throat of")

	playsound(H.loc, butcher_sound, 50, TRUE, -1)
	if(do_mob(user, H, clamp(500 / source.force, 30, 100)) && H.Adjacent(source))
		if(H.has_status_effect(/datum/status_effect/neck_slice))
			user.show_message("<span class='warning'>[H]'s neck has already been already cut, you can't make the bleeding any worse!</span>", MSG_VISUAL, \
							"<span class='warning'>Their neck has already been already cut, you can't make the bleeding any worse!</span>")
			return

		H.visible_message("<span class='danger'>[user] slits [H]'s throat!</span>", \
					"<span class='userdanger'>[user] slits your throat...</span>")
		log_combat(user, H, "finishes slicing the throat of")
		H.apply_damage(source.force, BRUTE, BODY_ZONE_HEAD, wound_bonus=CANT_WOUND) // easy tiger, we'll get to that in a sec
		var/obj/item/bodypart/slit_throat = H.get_bodypart(BODY_ZONE_HEAD)
		if(slit_throat)
			var/datum/wound/slash/critical/screaming_through_a_slit_throat = new
			screaming_through_a_slit_throat.apply_wound(slit_throat)
		H.apply_status_effect(/datum/status_effect/neck_slice)

/datum/component/butchering/proc/start_decap(obj/item/source, mob/living/carbon/human/victim, mob/living/user)
	if(DOING_INTERACTION_WITH_TARGET(user, victim))
		to_chat(user, "<span class='warning'>You're already interacting with [victim]!</span>")
		return

	if(!victim.get_bodypart(BODY_ZONE_HEAD))
		user.show_message(
			span_warning("[victim]'s has no neck left to cut!")
			, MSG_VISUAL
			, span_warning("They have no neck left to cut!")
			)

	user.visible_message(
		span_danger("[user] is cutting [victim]'s head off!")
		, span_danger("You start slicing what remains of [victim]'s neck!")
		, span_hear("You hear a sick cutting and crunching noise!")
		, ignored_mobs = victim
		)
	victim.show_message(
		span_userdanger("What remains of your neck is being cut by [user]!")
		, MSG_VISUAL
		, span_userdanger("Something is cutting what remains of your neck!")
		, NONE
		)
	log_combat(user, victim, "starts decapitating")

	playsound(victim.loc, butcher_sound, 50, TRUE, -1)
	if(!do_mob(user, victim, 10 SECONDS) && victim.Adjacent(source))
		return
	if(!victim.get_bodypart(BODY_ZONE_HEAD))
		user.show_message(
			span_warning("[victim] has already been decapitated!")
			, MSG_VISUAL
			, span_warning("Their head has already been already cut off!")
			)
		return

	victim.visible_message(
		span_danger("[user] cuts [victim]'s head off!")
		, span_userdanger("[user] cuts your head off...")
		)
	log_combat(user, victim, "finishes decapitating")
	var/obj/item/bodypart/lost_head = victim.get_bodypart(BODY_ZONE_HEAD)
	lost_head.dismember(BRUTE)

/**
 * Handles a user butchering a target
 *
 * Arguments:
 * - [butcher][/mob/living]: The mob doing the butchering
 * - [meat][/mob/living]: The mob being butchered
 */
/datum/component/butchering/proc/Butcher(mob/living/butcher, mob/living/meat)
	var/list/results = list()
	var/turf/T = meat.drop_location()
	var/final_effectiveness = effectiveness - meat.butcher_difficulty
	var/bonus_chance = max(0, (final_effectiveness - 100) + bonus_modifier) //so 125 total effectiveness = 25% extra chance
	for(var/V in meat.butcher_results)
		var/obj/bones = V
		var/amount = meat.butcher_results[bones]
		for(var/_i in 1 to amount)
			if(!prob(final_effectiveness))
				if(butcher)
					to_chat(butcher, "<span class='warning'>You fail to harvest some of the [initial(bones.name)] from [meat].</span>")
				continue

			if(prob(bonus_chance))
				if(butcher)
					to_chat(butcher, "<span class='info'>You harvest some extra [initial(bones.name)] from [meat]!</span>")
				results += new bones (T)
			results += new bones (T)

		meat.butcher_results.Remove(bones) //in case you want to, say, have it drop its results on gib

	for(var/V in meat.guaranteed_butcher_results)
		var/obj/sinew = V
		var/amount = meat.guaranteed_butcher_results[sinew]
		for(var/i in 1 to amount)
			results += new sinew (T)
		meat.guaranteed_butcher_results.Remove(sinew)

	for(var/obj/item/carrion in results)
		var/list/meat_mats = carrion.has_material_type(/datum/material/meat)
		if(!length(meat_mats))
			continue
		carrion.set_custom_materials((carrion.custom_materials - meat_mats) + list(GET_MATERIAL_REF(/datum/material/meat/mob_meat, meat) = counterlist_sum(meat_mats)))

	if(butcher)
		butcher.visible_message("<span class='notice'>[butcher] butchers [meat].</span>", \
								"<span class='notice'>You butcher [meat].</span>")
	ButcherEffects(meat)
	meat.harvest(butcher)
	meat.gib(FALSE, FALSE, TRUE)

/datum/component/butchering/proc/ButcherEffects(mob/living/meat) //extra effects called on butchering, override this via subtypes
	return

///Special snowflake component only used for the recycler.
/datum/component/butchering/recycler

/datum/component/butchering/recycler/Initialize(_speed, _effectiveness, _bonus_modifier, _butcher_sound, disabled, _can_be_blunt)
	if(!istype(parent, /obj/machinery/recycler)) //EWWW
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	RegisterSignal(parent, COMSIG_MOVABLE_CROSSED, PROC_REF(onCrossed))

/datum/component/butchering/recycler/proc/onCrossed(datum/source, mob/living/L)
	SIGNAL_HANDLER

	if(!istype(L))
		return
	var/obj/machinery/recycler/eater = parent
	if(eater.safety_mode || (eater.machine_stat & (BROKEN|NOPOWER))) //I'm so sorry.
		return

/datum/component/butchering/wearable

/datum/component/butchering/wearable/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(worn_enable_butchering))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(worn_disable_butchering))

/datum/component/butchering/wearable/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED,
	))

///Same as enable_butchering but for worn items
/datum/component/butchering/wearable/proc/worn_enable_butchering(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER
	//check if the item is being not worn
	if(!(slot & source.slot_flags))
		return
	butchering_enabled = TRUE
	RegisterSignal(user, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(butcher_target))

///Same as disable_butchering but for worn items
/datum/component/butchering/wearable/proc/worn_disable_butchering(obj/item/source, mob/user)
	SIGNAL_HANDLER
	butchering_enabled = FALSE
	UnregisterSignal(user, COMSIG_LIVING_UNARMED_ATTACK)

/datum/component/butchering/wearable/proc/butcher_target(mob/user, atom/target, proximity)
	SIGNAL_HANDLER
	if(!isliving(target))
		return NONE
	return onItemAttack(parent, target, user)
