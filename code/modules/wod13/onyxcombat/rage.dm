/mob/living/Initialize()
	. = ..()
	gnosis = new(src)
	gnosis.icon = 'code/modules/wod13/48x48.dmi'
	gnosis.plane = ABOVE_HUD_PLANE
	gnosis.layer = ABOVE_HUD_LAYER

/mob/living/simple_animal/werewolf/Life()
	. = ..()
	update_blood_hud()
	update_rage_hud()
	update_auspex_hud()
	update_sensewyrm_hud()

/mob/living/proc/update_rage_hud()
	if(!client || !hud_used)
		return
	if(isgarou(src) || iswerewolf(src))
		if(hud_used.rage_icon)
			hud_used.rage_icon.overlays -= gnosis
			var/mob/living/carbon/C = src
			hud_used.rage_icon.icon_state = "rage[C.auspice.rage]"
			gnosis.icon_state = "gnosis[C.auspice.gnosis]"
			hud_used.rage_icon.overlays |= gnosis
		if(hud_used.auspice_icon && last_moon_look != 0)
			hud_used.auspice_icon.icon_state = "[GLOB.moon_state]"

