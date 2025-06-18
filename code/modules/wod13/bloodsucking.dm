/mob/living/carbon/human/proc/add_bite_animation()
	remove_overlay(BITE_LAYER)
	var/mutable_appearance/bite_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "bite", -BITE_LAYER)
	overlays_standing[BITE_LAYER] = bite_overlay
	apply_overlay(BITE_LAYER)
	spawn(15)
		if(src)
			remove_overlay(BITE_LAYER)

/proc/get_needed_difference_between_numbers(number1, number2)
	if(number1 > number2)
		return number1 - number2
	else if(number1 < number2)
		return number2 - number1
	else
		return 1

/mob/living/carbon/human/proc/drinksomeblood(mob/living/mob)
	if(HAS_TRAIT(src, TRAIT_BABY_TEETH))
		to_chat(usr, span_warning("You're fangs won't manage to pierce the skin let alone suck in their state."))
		return FALSE
	var/bloodgain = max(1, mob.bloodquality-1)
	var/fumbled = FALSE
	last_drinkblood_use = world.time
	if(client)
		client.images -= suckbar
	qdel(suckbar)
	suckbar_loc = mob
	suckbar = image('code/modules/wod13/bloodcounter.dmi', suckbar_loc, "[round(14*(mob.bloodpool/mob.maxbloodpool))]", HUD_LAYER)
	suckbar.pixel_z = 40
	suckbar.plane = ABOVE_HUD_PLANE
	suckbar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	if(client)
		client.images += suckbar
	var/sound/heartbeat = sound('code/modules/wod13/sounds/drinkblood2.ogg', repeat = TRUE)
	if(HAS_TRAIT(src, TRAIT_BLOODY_SUCKER))
		src.emote("moan")
		Immobilize(30, TRUE)
	playsound_local(src, heartbeat, 75, 0, channel = CHANNEL_BLOOD, use_reverb = FALSE)
	if(isnpc(mob))
		var/mob/living/carbon/human/npc/NPC = mob
		NPC.danger_source = null
		mob.Stun(40) //NPCs don't get to resist

	if(mob.bloodpool <= 1 && mob.maxbloodpool > 1)
		to_chat(src, span_warning("You feel only a sliver of <b>BLOOD</b> in your victim."))
		if(iskindred(mob) && iskindred(src))
			if(!mob.client || !mob.key)
				to_chat(src, "<span class='warning'>You need [mob]'s attention to do that...</span>")
				last_drinkblood_use = 0
				if(client)
					client.images -= suckbar
					qdel(suckbar)
				stop_sound_channel(CHANNEL_BLOOD)
				return
			message_admins("[ADMIN_LOOKUPFLW(src)] is attempting to Diablerize [ADMIN_LOOKUPFLW(mob)]")
			log_attack("[key_name(src)] is attempting to Diablerize [key_name(mob)].")
			if(!GLOB.canon_event)
				to_chat(src, span_warning("It's not a canon event!"))
				return
			to_chat(src, span_userdanger("YOU TRY TO COMMIT DIABLERIE ON [mob]."))

	if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
		if(CheckEyewitness(src, src, 7, FALSE))
			AdjustMasquerade(-1)
	if(do_after(src, 30, target = mob, timed_action_flags = NONE, progress = FALSE))
		mob.bloodpool = max(0, mob.bloodpool-1)
		suckbar.icon_state = "[round(14*(mob.bloodpool/mob.maxbloodpool))]"
		if(ishuman(mob))
			var/mob/living/carbon/human/H = mob
			drunked_of |= "[H.dna.real_name]"
			if(!iskindred(mob))
				if(isnpc(src))
					H.blood_volume = max(H.blood_volume-50, 150)
				else // players die less from being succed
					H.blood_volume = max(H.blood_volume-20, 150)
			if(iscathayan(src))
				if(mob.yang_chi > 0 || mob.yin_chi > 0)
					if(mob.yang_chi > mob.yin_chi)
						mob.yang_chi = mob.yang_chi-1
						yang_chi = min(yang_chi+1, max_yang_chi)
						to_chat(src, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
					else
						mob.yin_chi = mob.yin_chi-1
						yin_chi = min(yin_chi+1, max_yin_chi)
						to_chat(src, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")
					COOLDOWN_START(mob, chi_restore, 30 SECONDS)
					update_chi_hud()
				else
					to_chat(src, "<span class='warning'>The <b>BLOOD</b> feels tasteless...</span>")
			if(H.reagents)
				if(length(H.reagents.reagent_list))
					if(prob(50))
						H.reagents.trans_to(src, min(10, H.reagents.total_volume), transfered_by = mob, methods = VAMPIRE)
		if(clane)
			if(clane.name == "Giovanni")
				mob.adjustBruteLoss(20, TRUE)
			if(clane.name == "Ventrue" && mob.bloodquality < BLOOD_QUALITY_NORMAL)	//Ventrue can suck on normal people, but not homeless people and animals. BLOOD_QUALITY_LOV - 1, BLOOD_QUALITY_NORMAL - 2, BLOOD_QUALITY_HIGH - 3. Blue blood gives +1 to suction
				to_chat(src, "<span class='warning'>You are too privileged to drink that awful <b>BLOOD</b>. Go get something better.</span>")
				visible_message("<span class='danger'>[src] throws up!</span>", "<span class='userdanger'>You throw up!</span>")
				playsound(get_turf(src), 'code/modules/wod13/sounds/vomit.ogg', 75, TRUE)
				if(isturf(loc))
					add_splatter_floor(loc)
				stop_sound_channel(CHANNEL_BLOOD)
				if(client)
					client.images -= suckbar
				qdel(suckbar)
				return
		if(HAS_TRAIT(src, TRAIT_ORGANOVORE))
			mob.adjustBruteLoss(20, TRUE) // sharp teeth
			to_chat(src, span_warning("You can't drink this disgusting <b>BLOOD</b>. Go find something meatier!"))
			visible_message(span_danger("[src] throws up!"), span_userdanger("You throw up!"))
			playsound(get_turf(src), 'code/modules/wod13/sounds/vomit.ogg', 75, TRUE)
			if(isturf(loc))
				add_splatter_floor(loc)
			stop_sound_channel(CHANNEL_BLOOD)
			if(client)
				client.images -= suckbar
			qdel(suckbar)
			return
		if(clane.name == "Salubri Warrior" && (ishumanbasic(mob) || isghoul(mob))) //passes by if it's not a supernatural
			if( (!HAS_TRAIT_FROM(mob, TRAIT_INCAPACITATED, STAMINA)) && mob.stat < SOFT_CRIT) //Needs to be KO'd to feed on
				to_chat(src, span_warning("I HAVE NOT BESTED THIS ONE IN COMBAT!! I FEED ON WARRIORS, NOT CATTLE!!"))
				stop_sound_channel(CHANNEL_BLOOD)
				if(client)
					client.images -= suckbar
				qdel(suckbar)
				return
		if(iskindred(mob))
			to_chat(src, "<span class='userlove'>[mob]'s blood tastes HEAVENLY...</span>")
			adjustBruteLoss(-25, TRUE)
			adjustFireLoss(-6, TRUE)
		else
			to_chat(src, "<span class='warning'>You sip some <b>BLOOD</b> from your victim. It feels good.</span>")
		if(HAS_TRAIT(src, TRAIT_MESSY_EATER))
			if(prob(33)) // One third chance.
				fumbled = TRUE
		if(fumbled)
			to_chat(src, "<span class='warning'>Some blood dribbles around your mouth, spilling down your front.</span>")
			fumbled = FALSE
			src.add_mob_blood(mob)
			if(isturf(loc))
				add_splatter_floor(loc)
		else
			bloodpool = min(maxbloodpool, bloodpool+bloodgain)
			adjustBruteLoss(-10, TRUE)
			update_damage_overlays()
			update_health_hud()
			update_blood_hud()
		if(mob.bloodpool <= 0)
			if(ishuman(mob))
				var/mob/living/carbon/human/K = mob
				if(iskindred(mob) && iskindred(src))
					var/datum/preferences/P = GLOB.preferences_datums[ckey(key)]
					var/datum/preferences/P2 = GLOB.preferences_datums[ckey(mob.key)]
					var/confirmation = tgui_alert(src, "Attempt to diablerize [mob]?", "Diablerize", buttons = list("Yes", "No"))
					if(confirmation == "Yes")
						SEND_SIGNAL(src, COMSIG_PATH_HIT, PATH_SCORE_DOWN, 0)
						AdjustMasquerade(-1)
						if(do_after(src, 60 SECONDS, mob))
							if(K.generation >= generation)
								message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(mob)]")
								log_attack("[key_name(src)] successfully Diablerized [key_name(mob)].")
								if(K.client)
									var/datum/brain_trauma/special/imaginary_friend/trauma = gain_trauma(/datum/brain_trauma/special/imaginary_friend)
									trauma.friend.key = K.key
								mob.death()
								if(P2)
									P2.reason_of_death =  "Diablerized by [true_real_name ? true_real_name : real_name] ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
								apply_status_effect(STATUS_EFFECT_DIABLERIE_HIGH)
								adjustBruteLoss(-50, TRUE)
								adjustFireLoss(-50, TRUE)
								if(key)
									if(P)
										P.diablerist = 1
									diablerist = 1
							else
								var/start_prob = 10
								if(prob(min(99, start_prob+((generation-K.generation)*10))))
									to_chat(src, span_userdanger("[K]'s SOUL OVERCOMES YOURS AND GAIN CONTROL OF YOUR BODY."))
									message_admins("[ADMIN_LOOKUPFLW(src)] tried to Diablerize [ADMIN_LOOKUPFLW(mob)] and was overtaken.")
									log_attack("[key_name(src)] tried to Diablerize [key_name(mob)] and was overtaken.")
									generation = min(13, P.generation+1)
									death()
									if(P)
										P.reason_of_death = "Failed the Diablerie ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
								else
									message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(mob)]")
									log_attack("[key_name(src)] successfully Diablerized [key_name(mob)].")
									if(P)
										P.diablerist = 1
										if(mob.generation + 3 < generation)
											P.generation = max(P.generation - 2, 7)
										else
											P.generation = max(P.generation - 1, 7)
										generation = P.generation
									diablerist = 1
									if(K.client)
										var/datum/brain_trauma/special/imaginary_friend/trauma = gain_trauma(/datum/brain_trauma/special/imaginary_friend)
										trauma.friend.key = K.key
									mob.death()
									if(P2)
										P2.reason_of_death = "Diablerized by [true_real_name ? true_real_name : real_name] ([time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")])."
							if(client)
								client.images -= suckbar
							qdel(suckbar)
							return
				else
					K.blood_volume = 0
			if(ishuman(mob) && !iskindred(mob))
				if(mob.stat != DEAD)
					if(isnpc(mob))
						var/mob/living/carbon/human/npc/Npc = mob
						Npc.last_attacker = null
						killed_count = killed_count+1
						if(killed_count >= 5)
							SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
							to_chat(src, "<span class='userdanger'><b>POLICE ASSAULT IN PROGRESS</b></span>")
					SEND_SOUND(src, sound('code/modules/wod13/sounds/feed_failed.ogg', 0, 0, 75))
					to_chat(src, "<span class='warning'>This sad sacrifice for your own pleasure affects something deep in your mind.</span>")
					AdjustMasquerade(-1)
					SEND_SIGNAL(src, COMSIG_PATH_HIT, PATH_SCORE_DOWN)
					mob.death()
			if(!ishuman(mob))
				if(mob.stat != DEAD)
					mob.death()
			stop_sound_channel(CHANNEL_BLOOD)
			last_drinkblood_use = 0
			if(client)
				client.images -= suckbar
			qdel(suckbar)
			return
		if(grab_state >= GRAB_PASSIVE)
			stop_sound_channel(CHANNEL_BLOOD)
			drinksomeblood(mob)
	else
		last_drinkblood_use = 0
		if(client)
			client.images -= suckbar
		qdel(suckbar)
		stop_sound_channel(CHANNEL_BLOOD)
		if(!(SEND_SIGNAL(mob, COMSIG_MOB_VAMPIRE_SUCKED, mob) & COMPONENT_RESIST_VAMPIRE_KISS))
			mob.SetSleeping(50)
