// This file is in _HELPERS due to load priority. Im sorry.

/mob/proc/swing_attack(mob/living/signal_user, atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /obj/item)) //after attack signal is sent even if you interact with something for SOME REASON so, voila, shitcode.
		return
	if(!signal_user.combat_mode)
		return
	var/obj/item/W = get_active_held_item()
	if(!W)
		swing_attack_unarmed(signal_user, target, user, proximity_flag, click_parameters)
	else
		swing_attack_normal(signal_user, target, user, proximity_flag, click_parameters, W)

// DO NOT CALL THIS PROC DIERECTLY
/mob/proc/swing_attack_normal(signal_user, atom/target, mob/user, proximity_flag, click_parameters, obj/item/W)
	if(!W.force)
		return
	if(target in DirectAccess()) //If the object we are attacking is in an inventory or a hud object.
		return
	play_attack_animation(claw = FALSE)
	changeNext_move(W.attack_speed)
	var/list/turfs_to_attack = get_nearest_attack_turfs()
	var/list/contents_list = new()
	for(var/turf/turf as anything in turfs_to_attack)
		contents_list += turf.GetAllContents()
	for(var/mob/living/possible_victim in contents_list)
		W.attack(possible_victim, src)
		return

// DO NOT CALL THIS PROC DIERECTLY
/mob/proc/swing_attack_unarmed(signal_user, atom/target, mob/user, proximity_flag, click_parameters)
	if(target in DirectAccess()) //If the object we are attacking is in an inventory or a hud object.
		return
	play_attack_animation(claw = TRUE)
	changeNext_move(CLICK_CD_MELEE)
	if(HAS_TRAIT(src, TRAIT_WARRIOR))
		changeNext_move(CLICK_CD_MELEE * 0.5)
	var/list/turfs_to_attack = get_nearest_attack_turfs()
	var/list/contents_list = new()
	for(var/turf/turf as anything in turfs_to_attack)
		contents_list += turf.GetAllContents()
	for(var/mob/living/possible_victim in contents_list)
		INVOKE_ASYNC(signal_user, PROC_REF(UnarmedAttack), possible_victim)
		return


// Simple proc for playing an appropriate attack animation
/mob/proc/play_attack_animation(claw)
	if(claw)
		new /obj/effect/temp_visual/dir_setting/claw_effect(get_turf(src), dir)
	else
		new /obj/effect/temp_visual/dir_setting/swing_effect(get_turf(src), dir)
	playsound(loc, 'code/modules/wod13/sounds/swing.ogg', 50, TRUE)

/mob/proc/get_nearest_attack_turfs()
	var/original_turf = get_open_turf_in_dir(src, dir)
	var/list/turfs = new()
	turfs += original_turf
	turfs += get_open_turf_in_dir(original_turf, turn(dir, -90))
	turfs += get_open_turf_in_dir(original_turf, turn(dir, 90))
	return turfs
