
/atom/movable/screen/disciplines
	plane = HUD_PLANE
	var/datum/discipline/dscpln
	var/last_discipline_click = 0
	var/last_discipline_use = 0
	var/main_state = ""
	var/active = FALSE
	var/obj/effect/overlay/level2
	var/obj/effect/overlay/level3
	var/obj/effect/overlay/level4
	var/obj/effect/overlay/level5

/atom/movable/screen/disciplines/Initialize()
	. = ..()
	level2 = new(src)
	level2.icon = 'code/modules/wod13/disciplines.dmi'
	level2.icon_state = "2"
	level2.plane = HUD_PLANE
	level3 = new(src)
	level3.icon = 'code/modules/wod13/disciplines.dmi'
	level3.icon_state = "3"
	level3.plane = HUD_PLANE
	level4 = new(src)
	level4.icon = 'code/modules/wod13/disciplines.dmi'
	level4.icon_state = "4"
	level4.plane = HUD_PLANE
	level5 = new(src)
	level5.icon = 'code/modules/wod13/disciplines.dmi'
	level5.icon_state = "5"
	level5.plane = HUD_PLANE