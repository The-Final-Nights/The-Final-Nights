/atom/movable/screen/drinkblood
	name = "Drink Blood"
	icon = 'code/modules/wod13/disciplines.dmi'
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/drinkblood/Click()
	bite()
	. = ..()

/atom/movable/screen/drinkblood/proc/bite()
	if(ishuman(usr))
		var/mob/living/carbon/human/BD = usr
		BD.update_blood_hud()
		if(world.time < BD.last_drinkblood_use+30)
			return
		if(world.time < BD.last_drinkblood_click+10)
			return
		BD.last_drinkblood_click = world.time
		if(BD.grab_state > GRAB_PASSIVE)
			if(ishuman(BD.pulling))
				var/mob/living/carbon/human/PB = BD.pulling
				if(isghoul(BD))
					if(!iskindred(PB))
						SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
						to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
						return
				if(!isghoul(BD) && !iskindred(BD) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				if(PB.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				if(PB.bloodpool <= 0 && (!iskindred(BD.pulling) || !iskindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(BD.clan)
					var/special_clan = FALSE
					if(BD.clan.name == CLAN_SALUBRI)
						if(!PB.IsSleeping())
							to_chat(BD, "<span class='warning'>You can't drink from aware targets!</span>")
							return
						special_clan = TRUE
						PB.emote("moan")
					if(BD.clan.name == CLAN_GIOVANNI)
						PB.emote("scream")
						special_clan = TRUE
					if(!special_clan)
						PB.emote("groan")
				PB.add_bite_animation()
			if(isliving(BD.pulling))
				if(!iskindred(BD) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				var/mob/living/LV = BD.pulling
				if(LV.bloodpool <= 0 && (!iskindred(BD.pulling) || !iskindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(LV.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				var/skipface = (BD.wear_mask && (BD.wear_mask.flags_inv & HIDEFACE)) || (BD.head && (BD.head.flags_inv & HIDEFACE))
				if(!skipface)
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						playsound(BD, 'code/modules/wod13/sounds/drinkblood1.ogg', 50, TRUE)
						LV.visible_message("<span class='warning'><b>[BD] bites [LV]'s neck!</b></span>", "<span class='warning'><b>[BD] bites your neck!</b></span>")
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						if(BD.CheckEyewitness(LV, BD, 7, FALSE))
							BD.AdjustMasquerade(-1)
					else
						playsound(BD, 'code/modules/wod13/sounds/kiss.ogg', 50, TRUE)
						LV.visible_message("<span class='italics'><b>[BD] kisses [LV]!</b></span>", "<span class='userlove'><b>[BD] kisses you!</b></span>")
					if(iskindred(LV))
						var/mob/living/carbon/human/HV = BD.pulling
						if(HV.stakeimmune)
							to_chat(BD, "<span class='warning'>There is no <b>HEART</b> in this creature.</span>")
							return
					BD.drinksomeblood(LV)
