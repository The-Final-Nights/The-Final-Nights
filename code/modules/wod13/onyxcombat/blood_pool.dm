/atom/movable/screen/blood
	name = "bloodpool"
	icon = 'code/modules/wod13/UI/bloodpool.dmi'
	icon_state = "blood0"
	plane = HUD_PLANE


/atom/movable/screen/blood/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/human/BD = usr
		BD.update_blood_hud()
		if(BD.bloodpool > 0)
			to_chat(BD, "<span class='notice'>You've got [BD.bloodpool]/[BD.maxbloodpool] blood points.</span>")
		else
			to_chat(BD, "<span class='warning'>You've got [BD.bloodpool]/[BD.maxbloodpool] blood points.</span>")
	..()

/mob/living/proc/update_blood_hud()
	if(!client || !hud_used)
		return
	if(hud_used.blood_icon)
		var/emm = round((bloodpool/maxbloodpool)*10)
		if(emm > 10)
			hud_used.blood_icon.icon_state = "blood10"
		if(emm < 0)
			hud_used.blood_icon.icon_state = "blood0"
		else
			hud_used.blood_icon.icon_state = "blood[emm]"

