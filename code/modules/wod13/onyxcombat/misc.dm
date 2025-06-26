/atom/movable/screen/addinv
	plane = HUD_PLANE

/atom/MouseEntered(location,control,params)
	if(isturf(src) || ismob(src) || isobj(src))
		if(loc && isliving(usr))
			var/mob/living/H = usr
			if(H.combat_mode)
				if(!H.IsSleeping() && !H.IsUnconscious() && !H.IsParalyzed() && !H.IsKnockdown() && !H.IsStun() && !HAS_TRAIT(H, TRAIT_RESTRAINED))
					H.face_atom(src)
					H.harm_focus = H.dir

/mob/living/carbon/Move(atom/newloc, direct, glide_size_override)
	. = ..()
	if(combat_mode && client)
		setDir(harm_focus)
	else
		harm_focus = dir

/mob/living/carbon/human/Life()
	if(!iskindred(src) && !iscathayan(src))
		if(prob(5))
			adjustCloneLoss(-5, TRUE)
	update_blood_hud()
	update_zone_hud()
	update_rage_hud()
	update_shadow()
	handle_vampire_music()
	update_auspex_hud()
	..()
