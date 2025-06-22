/mob/living/carbon/human/proc/Parry(mob/M)
	if(!pulledby && !parrying && world.time-parry_cd >= 30 && M != src)
		parrying = M
		if(blocking)
			SwitchBlocking()
		visible_message("<span class='warning'>[src] prepares to parry [M]'s next attack.</span>", "<span class='warning'>You prepare to parry [M]'s next attack.</span>")
		playsound(src, 'code/modules/wod13/sounds/parry.ogg', 70, TRUE)
		remove_overlay(FIGHT_LAYER)
		var/mutable_appearance/parry_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "parry", -FIGHT_LAYER)
		overlays_standing[FIGHT_LAYER] = parry_overlay
		apply_overlay(FIGHT_LAYER)
		parry_cd = world.time
		addtimer(CALLBACK(src, PROC_REF(clear_parrying)), 10)

/mob/living/carbon/human/proc/clear_parrying()
	if(parrying)
		parrying = null
		remove_overlay(FIGHT_LAYER)
		to_chat(src, "<span class='warning'>You lower your defense.</span>")

/mob/living/carbon/human/ranged_secondary_attack(atom/target, modifiers)
	. = ..()
	if(!combat_mode)
		return
	if(getStaminaLoss() < 50 && !CheckFrenzyMove())
		var/obj/item/W = get_active_held_item()
		parry_class = W.w_class
		Parry(src)