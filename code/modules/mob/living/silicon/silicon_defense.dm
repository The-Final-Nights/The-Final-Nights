
/mob/living/silicon/grippedby(mob/living/user, instant = FALSE)
	return //can't upgrade a simple pull into a more aggressive grab.

/mob/living/silicon/get_ear_protection()//no ears
	return 2

/mob/living/silicon/attack_alien(mob/living/carbon/alien/humanoid/user, list/modifiers)
	if(..()) //if harm or disarm intent
		var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
		if (prob(90))
			log_combat(user, src, "attacked")
			playsound(loc, 'sound/weapons/slash.ogg', 25, TRUE, -1)
			visible_message("<span class='danger'>[user] slashes at [src]!</span>", \
							"<span class='userdanger'>[user] slashes at you!</span>", null, null, user)
			to_chat(user, "<span class='danger'>You slash at [src]!</span>")
			if(prob(8))
				flash_act(affect_silicon = 1)
			log_combat(user, src, "attacked")
			adjustBruteLoss(damage)
			updatehealth()
		else
			playsound(loc, 'sound/weapons/slashmiss.ogg', 25, TRUE, -1)
			visible_message("<span class='danger'>[user]'s swipe misses [src]!</span>", \
							"<span class='danger'>You avoid [user]'s swipe!</span>", null, null, user)
			to_chat(user, "<span class='warning'>Your swipe misses [src]!</span>")

/mob/living/silicon/attack_animal(mob/living/simple_animal/user, list/modifiers)
	. = ..()
	var/damage_received = .
	if(prob(damage_received))
		for(var/mob/living/buckled in buckled_mobs)
			buckled.Paralyze(2 SECONDS)
			unbuckle_mob(buckled)
			buckled.visible_message(
				span_danger("[buckled] is knocked off of [src] by [user]!"),
				span_userdanger("You're knocked off of [src] by [user]!"),
				ignored_mobs = user,
			)
			to_chat(user, span_danger("You knock [buckled] off of [src]!"))

/mob/living/silicon/attack_paw(mob/living/user, list/modifiers)
	return attack_hand(user, modifiers)

/mob/living/silicon/attack_larva(mob/living/carbon/alien/larva/L, list/modifiers)
	if(!L.combat_mode)
		visible_message("<span class='notice'>[L.name] rubs its head against [src].</span>")

/mob/living/silicon/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	adjustBruteLoss(rand(10, 15))
	playsound(loc, "punch", 25, TRUE, -1)
	visible_message("<span class='danger'>[user] punches [src]!</span>", \
					"<span class='userdanger'>[user] punches you!</span>", null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, "<span class='danger'>You punch [src]!</span>")

//ATTACK HAND IGNORING PARENT RETURN VALUE
/mob/living/silicon/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = FALSE
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_HAND, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		. = TRUE
	if(has_buckled_mobs() && !user.combat_mode)
		user_unbuckle_mob(buckled_mobs[1], user)
	else
		if(user.combat_mode)
			user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			playsound(src.loc, 'sound/effects/bang.ogg', 10, TRUE)
			visible_message(span_danger("[user] punches [src], but doesn't leave a dent!"), \
							span_warning("[user] punches you, but doesn't leave a dent!"), null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_danger("You punch [src], but don't leave a dent!"))
		else
			visible_message(span_notice("[user] pets [src]."), \
							span_notice("[user] pets you."), null, null, user)
			to_chat(user, span_notice("You pet [src]."))

/mob/living/silicon/check_block(atom/hitby, damage, attack_text, attack_type, armour_penetration, damage_type, attack_flag)
	. = ..()
	if(.)
		return TRUE
	if(damage_type == BRUTE && attack_type == UNARMED_ATTACK && attack_flag == MELEE && damage <= 10)
		playsound(src, 'sound/effects/bang.ogg', 10, TRUE)
		visible_message(span_danger("[attack_text] doesn't leave a dent on [src]!"), vision_distance = COMBAT_MESSAGE_RANGE)
		return TRUE
	return FALSE

/mob/living/silicon/attack_drone(mob/living/simple_animal/drone/M)
	if(M.combat_mode)
		return
	return ..()

/mob/living/silicon/attack_drone_secondary(mob/living/simple_animal/drone/M)
	if(M.combat_mode)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

/mob/living/silicon/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	if(buckled_mobs)
		for(var/mob/living/M in buckled_mobs)
			unbuckle_mob(M)
			M.electrocute_act(shock_damage/100, source, siemens_coeff, flags)	//Hard metal shell conducts!
	return 0 //So borgs they don't die trying to fix wiring

/mob/living/silicon/emp_act(severity)
	. = ..()
	to_chat(src, "<span class='danger'>Warning: Electromagnetic pulse detected.</span>")
	if(. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			src.take_bodypart_damage(20)
		if(2)
			src.take_bodypart_damage(10)
	to_chat(src, "<span class='userdanger'>*BZZZT*</span>")
	for(var/mob/living/M in buckled_mobs)
		if(prob(severity*50))
			unbuckle_mob(M)
			M.Paralyze(40)
			M.visible_message("<span class='boldwarning'>[M] is thrown off of [src]!</span>")
	flash_act(affect_silicon = 1)

/mob/living/silicon/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	SEND_SIGNAL(src, COMSIG_ATOM_BULLET_ACT, Proj, def_zone)
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		adjustBruteLoss(Proj.damage)
		if(prob(Proj.damage*1.5))
			for(var/mob/living/M in buckled_mobs)
				M.visible_message("<span class='boldwarning'>[M] is knocked off of [src]!</span>")
				unbuckle_mob(M)
				M.Paralyze(40)
	if(Proj.stun || Proj.knockdown || Proj.paralyze)
		for(var/mob/living/M in buckled_mobs)
			unbuckle_mob(M)
			M.visible_message("<span class='boldwarning'>[M] is knocked off of [src] by the [Proj]!</span>")
	Proj.on_hit(src, 0, piercing_hit)
	return BULLET_ACT_HIT

/mob/living/silicon/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash/static)
	if(affect_silicon)
		return ..()
