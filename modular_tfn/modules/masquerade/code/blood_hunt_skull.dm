/obj/item/blood_hunt
	name = "ominous skull"
	desc = "A stylized skull, made out of marble."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "eye"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/blood_hunt/Initialize(mapload)
	. = ..()
	GLOB.blood_hunt_announcers += src
	AddComponent(/datum/component/violation_observer, FALSE)

/obj/item/blood_hunt/Destroy()
	GLOB.blood_hunt_announcers -= src
	..()

/obj/item/blood_hunt/examine(mob/user)
	. = ..()
	if(iskindred(user))
		. += span_notice("This thaumaturgically-created artifact allows you to announce a Blood Hunt to the city.")
		. += span_notice("It also allows you to pardon a kindred's masquerade violation by <b>interacting</b> with the kindred while holding the skull.")

/obj/item/blood_hunt/attack_self(mob/user)
	. = ..()
	var/chosen_name = tgui_input_text(user, "Write the hunted or forgiven character name:", "Blood Hunt")
	if(!chosen_name)
		return
	chosen_name = sanitize_name(chosen_name)
	var/reason = tgui_input_text(user, "Write the reason of the Blood Hunt:", "Blood Hunt Reason")
	if(!reason)
		return
	reason = sanitize(reason)

	for(var/mob/player_mob in GLOB.kindred_list)
		if(player_mob.real_name == chosen_name)
			if(HAS_TRAIT(player_mob, TRAIT_HUNTED))
				end_hunt(user, player_mob)
				break
			else
				start_hunt(user, player_mob, reason)
				break
	to_chat(user, span_danger("There is no such name in the city!"))

/obj/item/blood_hunt/proc/start_hunt(mob/user, mob/target, reason)
	to_chat(user, span_warning("You add [target] to the Hunted list."))
	RegisterSignals(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED), TYPE_PROC_REF(/mob, clear_blood_hunt))
	log_game("[user] started a bloodhunt on [target] for: [reason]")
	message_admins("[ADMIN_LOOKUPFLW(user)]] started a bloodhunt on [target] for: [reason]")
	target.start_blood_hunt(reason)

/obj/item/blood_hunt/proc/end_hunt(mob/user, mob/target)
	to_chat(user, span_warning("You remove [target] from the Hunted list."))
	UnregisterSignal(target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_LIVING_GIBBED))
	log_game("[user] ended a bloodhunt on [target].")
	message_admins("[ADMIN_LOOKUPFLW(user)]] ended a bloodhunt on [target].")
	target.clear_blood_hunt()

// This code is for reinforcing a player's masquerade.
/obj/item/blood_hunt/pre_attack(atom/A, mob/living/user, params)
	if(!ishuman(A))
		return
	if(!iskindred(A))
		return

	to_chat(user, span_notice("You hold the [src] up to [A]..."))
	if(!do_after(user, 10 SECONDS, A))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	if(SSmasquerade.masquerade_reinforce(src, A, MASQUERADE_REASON_PREFERENCES))
		to_chat(user, span_notice("You pardon [A]'s masquerade breach!"))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	to_chat(user, span_notice("[A]'s masquerade breach isn't worthy enough to be pardoned!"))
	return COMPONENT_CANCEL_ATTACK_CHAIN
