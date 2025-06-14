/atom/movable/screen/bloodpower
	name = "Bloodpower"
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "bloodpower"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/bloodpower/Click()
	SEND_SOUND(usr, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))
	if(ishuman(usr))
		var/mob/living/carbon/human/BD = usr
		if(world.time < BD.last_bloodpower_use+110)
			return
		if(world.time < BD.last_bloodpower_click+10)
			return
		BD.last_bloodpower_click = world.time
		var/plus = 0
		if(HAS_TRAIT(BD, TRAIT_HUNGRY))
			plus = 1
		if(BD.bloodpool >= 3+plus)
			playsound(usr, 'code/modules/wod13/sounds/bloodhealing.ogg', 50, FALSE)
			BD.last_bloodpower_use = world.time
			BD.bloodpool = max(0, BD.bloodpool-(3+plus))
			icon_state = "[initial(icon_state)]-on"
			to_chat(BD, "<span class='notice'>You use blood to become more powerful.</span>")
			BD.dna.species.punchdamagehigh = BD.dna.species.punchdamagehigh+5
			BD.physiology.armor.melee = BD.physiology.armor.melee+15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet+15
			if(!HAS_TRAIT(BD, TRAIT_IGNORESLOWDOWN))
				ADD_TRAIT(BD, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
			BD.update_blood_hud()
			addtimer(CALLBACK(src, PROC_REF(end_bloodpower)), 100+BD.discipline_time_plus+BD.bloodpower_time_plus)
		else
			SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
			to_chat(BD, "<span class='warning'>You don't have enough <b>BLOOD</b> to become more powerful.</span>")

/atom/movable/screen/bloodpower/proc/end_bloodpower()
	if(ishuman(usr))
		var/mob/living/carbon/human/BD = usr
		to_chat(BD, "<span class='warning'>You feel like your <b>BLOOD</b>-powers slowly decrease.</span>")
		if(BD.dna.species)
			BD.dna.species.punchdamagehigh = BD.dna.species.punchdamagehigh-5
			BD.physiology.armor.melee = BD.physiology.armor.melee-15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet-15
			if(HAS_TRAIT(BD, TRAIT_IGNORESLOWDOWN))
				REMOVE_TRAIT(BD, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
	icon_state = initial(icon_state)
