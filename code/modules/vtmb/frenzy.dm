//Here's things for future madness

//add_client_colour(/datum/client_colour/glass_colour/red)
//remove_client_colour(/datum/client_colour/glass_colour/red)
/client/Click(object,location,control,params)
	if(isatom(object))
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			if(H.in_frenzy)
				return
	..()

/mob/living/carbon/proc/rollfrenzy(frenzyoverride = 0)
	if(client)
		var/mob/living/carbon/human/H
		if(ishuman(src))
			H = src
		if(isgarou(src) || iswerewolf(src))
			to_chat(src, "I'm full of <span class='danger'><b>ANGER</b></span>, and I'm about to flare up in <span class='danger'><b>RAGE</b></span>. Rolling...")
		else if(iskindred(src))
			to_chat(src, "I need <span class='danger'><b>BLOOD</b></span>. The <span class='danger'><b>BEAST</b></span> is calling. Rolling...")
		else if(iscathayan(src))
			to_chat(src, "My <span class='danger'><b>P'o</b></span> is awakening. Rolling...")
		else
			to_chat(src, "I'm too <span class='danger'><b>AFRAID</b></span> to continue doing this. Rolling...")
		SEND_SOUND(src, sound('code/modules/wod13/sounds/bloodneed.ogg', 0, 0, 50))
		var/check
		var/frenzydicepool = 1
		var/frenzydiff = 4
		if(iscathayan(src))
			frenzydicepool = max(1, mind.dharma.Hun)
			frenzydiff = max(frenzy_hardness, (mind.dharma.level*2)-max_demon_chi)
		else if(iskindred(src))
			frenzydicepool = max(1, round(H.morality_path.score/2))
			frenzydiff = frenzy_hardness
		else if(isgarou(src) || iswerewolf(src))
			frenzydicepool = max(1, max(round(wisdom/2),renownrank))
			frenzydiff = frenzy_hardness
		if(frenzyoverride)
			frenzydiff = frenzyoverride
		check = SSroll.storyteller_roll(frenzydicepool, difficulty = frenzydiff, mobs_to_show_output = src)
		switch(check)
			if(ROLL_FAILURE)
				src.enter_frenzymod()
				if(iskindred(src))
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 100*H.clane.frenzymod)
					SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN)
				else
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 100)
				frenzy_hardness = initial(src.frenzy_hardness)
			if(ROLL_BOTCH)
				src.enter_frenzymod()
				if(iskindred(src))
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 200*H.clane.frenzymod)
					SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN)
				else
					addtimer(CALLBACK(src, PROC_REF(exit_frenzymod)), 200)
				frenzy_hardness = initial(src.frenzy_hardness)
			else
				frenzy_hardness = min(10, src.frenzy_hardness+1)

/mob/living/carbon/proc/enter_frenzymod()
	if (in_frenzy)
		return

	SEND_SOUND(src, sound('code/modules/wod13/sounds/frenzy.ogg', 0, 0, 50))
	in_frenzy = TRUE
	add_client_colour(/datum/client_colour/glass_colour/red)
	demon_chi = 0
	if(isgarou(src) || iswerewolf(src))
		adjust_rage(-10, src, TRUE)
	GLOB.frenzy_list += src

/mob/living/carbon/proc/exit_frenzymod()
	if (!in_frenzy)
		return

	in_frenzy = FALSE
	mind?.dharma?.Po_combat = FALSE
	remove_client_colour(/datum/client_colour/glass_colour/red)
	GLOB.frenzy_list -= src

/mob/living/carbon/proc/CheckFrenzyMove()
	if(stat >= SOFT_CRIT)
		return TRUE
	if(IsSleeping())
		return TRUE
	if(IsUnconscious())
		return TRUE
	if(IsParalyzed())
		return TRUE
	if(IsKnockdown())
		return TRUE
	if(IsStun())
		return TRUE
	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		return TRUE

/mob/living/carbon/proc/do_frenzy_bite(target)
	if(frenzy_target.client)
		return
	if(!frenzy_target?.bloodpool)
		return
	if(!COOLDOWN_FINISHED(src, frenzy_bite_cooldown))
		return

	COOLDOWN_START(src, frenzy_bite_cooldown, rand(6 SECONDS, 12 SECONDS))
	frenzy_target.grabbedby(src)
	if(ishuman(frenzy_target))
		var/mob/living/carbon/human/humie = frenzy_target
		frenzy_target.emote("scream")
		humie.add_bite_animation()
	var/mob/living/carbon/human/vamp = src
	if(CheckEyewitness(frenzy_target, vamp, 7, FALSE))
		vamp.AdjustMasquerade(-1)
	playsound(src, 'code/modules/wod13/sounds/drinkblood1.ogg', 50, TRUE)
	frenzy_target?.visible_message(span_warning("<b>[src] bites [frenzy_target]'s neck!</b>"), span_warning("<b>[src] bites your neck!</b></span>"))
	vamp.drinksomeblood(frenzy_target)
	vamp.Immobilize(5 SECONDS) //ai like to move around, so hold still

/mob/living/carbon/proc/try_frenzy_bite(target)
	frenzy_target = target
	if(get_dist(frenzy_target, src) > 1) //check again to avoid biting people from 2 tiles away in some cases
		return
	if(frenzy_target.stat != DEAD && !HAS_TRAIT(frenzy_target, TRAIT_DEATHCOMA))
		if(prob(75)) //prevent AIs from having frame perfect attacks every tick
			face_atom(frenzy_target)
			do_frenzy_bite(frenzy_target)
	else //target died, let go of them
		frenzy_target = null
		stop_pulling()

/mob/living/carbon/proc/frenzystep()
	if(!isturf(loc) || CheckFrenzyMove())
		return
	if(m_intent == MOVE_INTENT_WALK)
		toggle_move_intent(src)
	set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))

	var/atom/fear
	for(var/obj/effect/fire/F in GLOB.fires_list)
		if(get_dist(src, F) < 7 && F.z == src.z)
			fear = F
	if(fear)
		step_away(src,fear,99)
		if(prob(25))
			emote("scream")
		return
	a_intent = INTENT_HARM
	if(get_dist(frenzy_target, src) <= 1)
		if(iskindred(src))
			try_frenzy_bite(frenzy_target)
		if(!COOLDOWN_FINISHED(src, frenzy_attack_cooldown))
			return
		COOLDOWN_START(src, frenzy_attack_cooldown, 1 SECONDS)
		UnarmedAttack(frenzy_target)
	else
		if(prob(50))
			jump(frenzy_target)
		step_to(src,frenzy_target,0)
		face_atom(frenzy_target)

/mob/living/carbon/proc/get_frenzy_targets()
	var/list/ignore_list = list(
	/mob/living/carbon/human/npc/shop,
	/mob/living/carbon/human/npc/sabbat,
	/mob/living/simple_animal/hostile
	)
	var/list/targets = list()
	for(var/mob/living/L in oviewers(7, src))
		if(is_type_in_list(L, ignore_list))
			continue
		if(L.stat == DEAD || HAS_TRAIT(L, TRAIT_DEATHCOMA))
			continue
		targets += L

	if(length(targets) > 0)
		if(frenzy_target)
			if(get_dist(src, frenzy_target) > 7)
				targets -= frenzy_target
				frenzy_target = null
				return pick(targets)
			else
				return frenzy_target
		else
			return pick(targets)
	else
		return null

/mob/living/carbon/proc/handle_automated_frenzy()
	for(var/mob/living/carbon/human/npc/NPC in oviewers(5, src))
		NPC.Aggro(src)
	if(frenzy_target)
		var/datum/cb = CALLBACK(src, PROC_REF(frenzystep))
		var/reqsteps = SSfrenzypool.wait/total_multiplicative_slowdown()
		for(var/i in 1 to reqsteps)
			addtimer(cb, (i - 1)*total_multiplicative_slowdown())
	else
		frenzy_target = get_frenzy_targets()
		if(!CheckFrenzyMove())
			var/turf/T = get_step(loc, pick(NORTH, SOUTH, WEST, EAST))
			face_atom(T)
			Move(T)

/datum/species/kindred/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(H.clane?.name == "Baali")
		if(istype(get_area(H), /area/vtm/church))
			if(prob(25))
				to_chat(H, "<span class='warning'>You don't belong here!</span>")
				H.adjustFireLoss(20)
				H.adjust_fire_stacks(6)
				H.IgniteMob()
	//FIRE FEAR
	if(H.antifrenzy || HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
		return
	var/fearstack = 0
	for(var/obj/effect/fire/F in GLOB.fires_list)
		if(get_dist(F, H) < 5 && F.z == H.z)
			fearstack += F.stage
	for(var/mob/living/carbon/human/U in viewers(7, H))
		if(U.on_fire)
			fearstack += 1

	fearstack = min(fearstack, 20)

	if(fearstack)
		H.do_jitter_animation(10)
		H.apply_status_effect(STATUS_EFFECT_FEAR)
	if(fearstack > 10 && prob(5))
		if(!H.in_frenzy)
			H.rollfrenzy()

	if(!fearstack && H.has_status_effect(STATUS_EFFECT_FEAR))
		H.remove_status_effect(STATUS_EFFECT_FEAR)

	//masquerade violations due to unnatural appearances
	if(H.is_face_visible() && H.clane?.violating_appearance)
		switch(H.clane.alt_sprite)
			if ("kiasyd")
				//masquerade breach if eyes are uncovered, short range
				if (!H.is_eyes_covered())
					if (H.CheckEyewitness(H, H, 3, FALSE))
						H.AdjustMasquerade(-1)
			if ("rotten3")
				//slightly less range than if fully decomposed
				if (H.CheckEyewitness(H, H, 5, FALSE))
					H.AdjustMasquerade(-1)
			else
				//gargoyles, nosferatu, skeletons, that kind of thing
				if (H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)

	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.AdjustMasquerade(-1)
	if(HAS_TRAIT(H, TRAIT_NONMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.AdjustMasquerade(-1)

	if(H.hearing_ghosts)
		H.bloodpool = max(0, H.bloodpool-1)
		to_chat(H, "<span class='warning'>Necromancy Vision reduces your blood points too sustain itself.</span>")

	if(H.clane?.name == "Tzimisce" || H.clane?.name == "Old Clan Tzimisce")
		var/datum/vampireclane/tzimisce/TZ = H.clane
		if(TZ.heirl)
			if(!(TZ.heirl in H.GetAllContents()))
				if(prob(5))
					to_chat(H, "<span class='warning'>You are missing your home soil...</span>")
					H.bloodpool = max(0, H.bloodpool-1)
	if(H.clane?.name == "Kiasyd")
		var/datum/vampireclane/kiasyd/kiasyd = H.clane
		for(var/obj/item/I in H.contents)
			if(I?.is_iron)
				if (COOLDOWN_FINISHED(kiasyd, cold_iron_frenzy))
					COOLDOWN_START(kiasyd, cold_iron_frenzy, 10 SECONDS)
					H.rollfrenzy()
					to_chat(H, "<span class='warning'>[I] is <b>COLD IRON</b>!")

	if(H.key && (H.stat <= HARD_CRIT))
		var/datum/preferences/P = GLOB.preferences_datums[ckey(H.key)]
		if(P)
			if(P.path_score != H.morality_path.score)
				P.path_score = H.morality_path.score
				P.save_preferences()
				P.save_character()
			if(P.masquerade != H.masquerade)
				P.masquerade = H.masquerade
				P.save_preferences()
				P.save_character()
			if(!H.antifrenzy)
				if(P.path_score < 1)
					H.enter_frenzymod()
					to_chat(H, "<span class='userdanger'>You have lost control of the Beast within you, and it has taken your body. Be more [H.client.prefs.is_enlightened ? "Enlightened" : "humane"] next time.</span>")
					H.ghostize(FALSE)
					P.reason_of_death = "Lost control to the Beast ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."

	if(H.clane && !H.antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
		if(H.clane.name == "Banu Haqim")
			if(H.mind)
				if(H.mind.enslaved_to)
					if(get_dist(H, H.mind.enslaved_to) > 10)
						if((H.last_frenzy_check + 40 SECONDS) <= world.time)
							to_chat(H, "<span class='warning'><b>As you are far from [H.mind.enslaved_to], you feel the desire to drink more vitae!<b></span>")
							H.last_frenzy_check = world.time
							H.rollfrenzy()
					else if(H.bloodpool > 1 || H.in_frenzy)
						H.last_frenzy_check = world.time
		else
			if(H.bloodpool > 1 || H.in_frenzy)
				H.last_frenzy_check = world.time

	if(!H.antifrenzy && !HAS_TRAIT(H, TRAIT_KNOCKEDOUT))
		if(H.bloodpool <= 1 && !H.in_frenzy)
			if((H.last_frenzy_check + 40 SECONDS) <= world.time)
				H.last_frenzy_check = world.time
				H.rollfrenzy()
