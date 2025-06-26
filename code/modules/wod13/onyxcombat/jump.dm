
/atom/movable/screen/jump
	name = "jump"
	icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	icon_state = "act_jump_off"
	plane = HUD_PLANE

/atom/movable/screen/jump/Click()
	var/mob/living/L = usr
	if(!L.prepared_to_jump)
		L.prepared_to_jump = TRUE
		icon_state = "act_jump_on"
		to_chat(usr, "<span class='notice'>You prepare to jump.</span>")
	else
		L.prepared_to_jump = FALSE
		icon_state = "act_jump_off"
		to_chat(usr, "<span class='notice'>You are not prepared to jump anymore.</span>")
	..()

/atom/Click()
	. = ..()
	if(isliving(usr) && usr != src)
		var/mob/living/L = usr
		if(L.prepared_to_jump)
			L.jump(src)