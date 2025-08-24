/mob/living/carbon/werewolf/attack_paw(mob/living/carbon/user, list/modifiers)
	if(..())
		if(user.combat_mode)
			do_rage_from_attack(user)
			return apply_damage(rand(user.melee_damage_lower, user.melee_damage_upper))

/mob/living/carbon/werewolf/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)	//to allow surgery to return properly.
		return FALSE

	if(user.combat_mode)
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, "<span class='warning'>You don't want to hurt [src]!</span>")
			return
		user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
		visible_message("<span class='danger'>[user] punches [src]!</span>",\
						"<span class='userdanger'>[user] punches you!</span>", null, COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='danger'>You punch [src]!</span>")
		apply_damage((rand(user.dna.species.punchdamagelow, user.dna.species.punchdamagehigh) / 3) * user.get_total_physique())
		playsound(loc, user.dna.species.attack_sound, 25, TRUE, -1)
		log_combat(user, src, "attacked")
		updatehealth()
		return TRUE
	else
		help_shake_act(user)

/mob/living/carbon/werewolf/attack_animal(mob/living/simple_animal/M)
	. = ..()
	do_rage_from_attack()
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		switch(M.melee_damage_type)
			if(BRUTE)
				adjustBruteLoss(damage)
			if(BURN)
				adjustFireLoss(damage)
			if(TOX)
				adjustToxLoss(damage)
			if(OXY)
				adjustOxyLoss(damage)
			if(CLONE)
				adjustCloneLoss(damage)
			if(STAMINA)
				adjustStaminaLoss(damage)

/mob/living/carbon/werewolf/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/spacevine_mutation) && isvineimmune(src))
		return
	. = ..()
	if(QDELETED(src))
		return
	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			gib()
			return

		if (EXPLODE_HEAVY)
			take_overall_damage(60, 60)
			if(ears)
				ears.adjustEarDamage(30,120)

		if(EXPLODE_LIGHT)
			take_overall_damage(30,0)
			if(prob(50))
				Unconscious(20)
			if(ears)
				ears.adjustEarDamage(15,60)

/mob/living/carbon/werewolf/getarmor(def_zone, type)
	if (type == "melee" || type == "bullet")
		return werewolf_armor
	else
		return 0

/mob/living/carbon/werewolf/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	return 0

/mob/living/carbon/werewolf/crinos/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW
	. = ..()

/mob/living/carbon/werewolf/corax/corax_crinos/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW
	. = ..()

/mob/living/carbon/werewolf/lupus/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_BITE
	. = ..()

/mob/living/carbon/werewolf/lupus/corvid/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect)
	if(!no_effect && !visual_effect_icon)
		visual_effect_icon = ATTACK_EFFECT_CLAW // Ravens attack with their claw, or somesuch.
	. = ..()
