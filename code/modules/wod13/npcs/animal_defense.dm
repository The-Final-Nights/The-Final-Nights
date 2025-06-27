/mob/living/simple_animal/attack_hand(mob/living/carbon/human/user, list/modifiers)
	// so that martial arts don't double dip
	if (..())
		return TRUE

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		user.do_attack_animation(src, ATTACK_EFFECT_DISARM)
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
		var/shove_dir = get_dir(user, src)
		if(!Move(get_step(src, shove_dir), shove_dir))
			log_combat(user, src, "shoved", "failing to move it")
			user.visible_message("<span class='danger'>[user.name] shoves [src]!</span>",
				"<span class='danger'>You shove [src]!</span>", "<span class='hear'>You hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, list(src))
			to_chat(src, "<span class='userdanger'>You're shoved by [user.name]!</span>")
			return TRUE
		log_combat(user, src, "shoved", "pushing it")
		user.visible_message("<span class='danger'>[user.name] shoves [src], pushing [p_them()]!</span>",
			"<span class='danger'>You shove [src], pushing [p_them()]!</span>", "<span class='hear'>You hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, list(src))
		to_chat(src, "<span class='userdanger'>You're pushed by [user.name]!</span>")
		return TRUE

	if(!user.combat_mode)
		if (stat == DEAD)
			return
		visible_message("<span class='notice'>[user] [response_help_continuous] [src].</span>", \
						"<span class='notice'>[user] [response_help_continuous] you.</span>", null, null, user)
		to_chat(user, "<span class='notice'>You [response_help_simple] [src].</span>")
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
		if(pet_bonus)
			funpet(user)
	else
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, "<span class='warning'>You don't want to hurt [src]!</span>")
			return
		user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		visible_message("<span class='danger'>[user] [response_harm_continuous] [src]!</span>",\
						"<span class='userdanger'>[user] [response_harm_continuous] you!</span>", null, COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='danger'>You [response_harm_simple] [src]!</span>")
		playsound(loc, attacked_sound, 25, TRUE, -1)
		apply_damage(harm_intent_damage)
		log_combat(user, src, "attacked")
		updatehealth()
		return TRUE

/**
*This is used to make certain mobs (pet_bonus == TRUE) emote when pet, make a heart emoji at their location, and give the petter a moodlet.
*
*/
/mob/living/simple_animal/proc/funpet(mob/petter)
	new /obj/effect/temp_visual/heart(loc)
	if(prob(33))
		manual_emote("[pet_bonus_emote]")
	SEND_SIGNAL(petter, COMSIG_ADD_MOOD_EVENT, src, /datum/mood_event/pet_animal, src)

/mob/living/simple_animal/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	playsound(loc, "punch", 25, TRUE, -1)
	visible_message("<span class='danger'>[user] punches [src]!</span>", \
					"<span class='userdanger'>You're punched by [user]!</span>", null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, "<span class='danger'>You punch [src]!</span>")
	adjustBruteLoss(15)

/mob/living/simple_animal/attack_paw(mob/living/carbon/human/user, list/modifiers)
	if(..())
		if(stat != DEAD)
			return apply_damage(rand(user.melee_damage_lower, user.melee_damage_upper))
	if (!user.combat_mode)
		if (health > 0)
			visible_message("<span class='notice'>[user.name] [response_help_continuous] [src].</span>", \
							"<span class='notice'>[user.name] [response_help_continuous] you.</span>", null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='notice'>You [response_help_simple] [src].</span>")
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)


/mob/living/simple_animal/attack_alien(mob/living/carbon/alien/humanoid/user, list/modifiers)
	if(..()) //if harm or disarm intent.
		if(LAZYACCESS(modifiers, RIGHT_CLICK))
			playsound(loc, 'sound/weapons/pierce.ogg', 25, TRUE, -1)
			visible_message("<span class='danger'>[user] [response_disarm_continuous] [name]!</span>", \
							"<span class='userdanger'>[user] [response_disarm_continuous] you!</span>", null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='danger'>You [response_disarm_simple] [name]!</span>")
			log_combat(user, src, "disarmed")
		else
			var/damage = rand(15, 30)
			visible_message("<span class='danger'>[user] slashes at [src]!</span>", \
							"<span class='userdanger'>You're slashed at by [user]!</span>", null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, "<span class='danger'>You slash at [src]!</span>")
			playsound(loc, 'sound/weapons/slice.ogg', 25, TRUE, -1)
			apply_damage(damage)
			log_combat(user, src, "attacked")
		return 1

/mob/living/simple_animal/attack_larva(mob/living/carbon/alien/larva/L)
	. = ..()
	if(. && stat != DEAD) //successful larva bite
		var/damage_done = apply_damage(rand(L.melee_damage_lower, L.melee_damage_upper), BRUTE)
		if(damage_done > 0)
			L.amount_grown = min(L.amount_grown + damage_done, L.max_grown)

/mob/living/simple_animal/attack_drone(mob/living/simple_animal/drone/M)
	if(M.combat_mode) //No kicking dogs even as a rogue drone. Use a weapon.
		return
	return ..()

/mob/living/carbon/human/Bump(atom/Obstacle)
	. = ..()
	var/mob/living/simple_animal/animal = locate() in get_turf(Obstacle)
	if(animal)
		if(animal.name == "Cain")
			return //cain will never hate you.
		if(HAS_TRAIT(src, TRAIT_ANIMAL_REPULSION))
			adjustBruteLoss(3)
			visible_message("<span class='danger'>[animal] bites at [name]!</span>", \
							"<span class='userdanger'>[animal] bites you!</span>", null, COMBAT_MESSAGE_RANGE, src)

/mob/living/simple_animal/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	..()
	if(QDELETED(src))
		return
	var/bomb_armor = getarmor(null, BOMB)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			if(prob(bomb_armor))
				adjustBruteLoss(500)
			else
				gib()
				return
		if (EXPLODE_HEAVY)
			var/bloss = 60
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

		if(EXPLODE_LIGHT)
			var/bloss = 30
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			adjustBruteLoss(bloss)

/mob/living/simple_animal/blob_act(obj/structure/blob/B)
	adjustBruteLoss(20)
	return

/mob/living/simple_animal/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()
