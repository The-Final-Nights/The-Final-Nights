/atom/proc/attack_werewolf(mob/living/carbon/werewolf/user, list/modifiers)
	attack_hand(user, modifiers)

/obj/item/attack_werewolf(mob/living/carbon/werewolf/user, list/modifiers)
	if (!user.can_hold_items(src))
		if (user.contents.Find(src))
			user.dropItemToGround(src)
		// Lupus and Corvids can only hold small and tiny items respectively
		if (iscorvid(user))
			to_chat(user, span_warning("\The [src] is too large to hold in your beak!"))
		else if (islupus(user))
			to_chat(user, span_warning("\The [src] is too large to hold in your mouth!"))

		return

	attack_hand(user, modifiers)

/obj/attack_werewolf(mob/living/carbon/werewolf/user, list/modifiers)
	if (!user.combat_mode)
		return ..()

	if(!user.melee_damage_upper && !user.obj_damage)
		user.emote("custom", message = "[user.friendly_verb_continuous] [src].")
		return FALSE
	else
		var/play_soundeffect = TRUE
		if(user.environment_smash)
			play_soundeffect = FALSE
		if(user.obj_damage)
			. = attack_generic(user, user.obj_damage, user.melee_damage_type, MELEE, play_soundeffect, user.armour_penetration)
		else
			. = attack_generic(user, rand(user.melee_damage_lower,user.melee_damage_upper), user.melee_damage_type, MELEE, play_soundeffect, user.armour_penetration)
		if(. && !play_soundeffect)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)

/obj/structure/vampdoor/attack_werewolf(mob/living/carbon/werewolf/user, list/modifiers)
	if (!user.combat_mode || !closed || !iscrinos(user))
		return ..()

	break_door(user)

/mob/living/attack_werewolf(mob/living/carbon/werewolf/user, list/modifiers)
	attack_paw(user)

