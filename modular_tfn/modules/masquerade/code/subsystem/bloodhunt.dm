SUBSYSTEM_DEF(bloodhunt)
	name = "Blood Hunt"
	init_order = INIT_ORDER_DEFAULT
	wait = 600
	priority = FIRE_PRIORITY_VERYLOW

	var/list/hunted

/datum/controller/subsystem/bloodhunt/Initialize(start_timeofday)
	hunted = list()
	..()

/datum/controller/subsystem/bloodhunt/fire()
	update_alert()

/datum/controller/subsystem/bloodhunt/proc/update_alert()
	set waitfor = FALSE
	for(var/mob/kindred in GLOB.kindred_list)
		if(length(hunted))
			kindred.throw_alert("bloodhunt", /atom/movable/screen/alert/bloodhunt)
		else
			kindred.clear_alert("bloodhunt")

/atom/movable/screen/alert/bloodhunt
	name = "Blood Hunt"
	icon_state = "bloodhunt"

/atom/movable/screen/alert/bloodhunt/Click()
	. = ..()
	for(var/mob/hunted_mob as anything in SSbloodhunt.hunted)
		var/area/A = get_area(hunted_mob)
		to_chat(owner, "[icon2html(getFlatIcon(hunted_mob), owner)][hunted_mob.real_name], [hunted_mob.mind ? hunted_mob.mind.assigned_role : "Citizen"]. Was last seen at [A.name]")
