/obj/item/assembly/control
	name = "blast door controller"
	desc = "A small electronic device able to control a blast door remotely."
	icon_state = "control"
	/// The ID of the blast door electronics to match to the ID of the blast door being used.
	var/id = null
	/// Cooldown of the door's controller. Updates when pressed (activate())
	var/cooldown = FALSE
	var/sync_doors = TRUE

/obj/item/assembly/control/examine(mob/user)
	. = ..()
	if(id)
		. += span_notice("Its channel ID is '[id]'.")

/obj/item/assembly/control/multitool_act(mob/living/user)
	var/change_id = tgui_input_number(user, "Set the door controllers ID", "Door ID", id, 100)
	if(!change_id || QDELETED(user) || QDELETED(src) || !usr.canUseTopic(src, no_tk = TRUE))
		return
	id = change_id
	balloon_alert(user, "id changed")
	to_chat(user, span_notice("You change the ID to [id]."))

/obj/item/assembly/control/activate()
	var/openclose
	if(cooldown)
		return
	cooldown = TRUE
	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if(M.id == src.id)
			if(openclose == null || !sync_doors)
				openclose = M.density
			INVOKE_ASYNC(M, openclose ? TYPE_PROC_REF(/obj/machinery/door/poddoor, open) : TYPE_PROC_REF(/obj/machinery/door/poddoor, close))
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 1 SECONDS)

/obj/item/assembly/control/curtain
	name = "curtain controller"
	desc = "A small electronic device able to control a mechanical curtain remotely."

/obj/item/assembly/control/curtain/examine(mob/user)
	. = ..()
	if(id)
		. += span_notice("Its channel ID is '[id]'.")

/obj/item/assembly/control/curtain/activate()
	var/openclose
	if(cooldown)
		return
	cooldown = TRUE
	for(var/obj/structure/curtain/cloth/fancy/mechanical/M in GLOB.curtains)
		if(M.id == src.id)
			if(openclose == null || !sync_doors)
				openclose = M.density
			INVOKE_ASYNC(M, openclose ? TYPE_PROC_REF(/obj/structure/curtain/cloth/fancy/mechanical, open) : TYPE_PROC_REF(/obj/structure/curtain/cloth/fancy/mechanical, close))
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 0.5 SECONDS)


/obj/item/assembly/control/airlock
	name = "airlock controller"
	desc = "A small electronic device able to control an airlock remotely."
	id = "badmin" // Set it to null for MEGAFUN.
	var/specialfunctions = OPEN
	/*
	Bitflag, 1= open (OPEN)
				2= idscan (IDSCAN)
				4= bolts (BOLTS)
				8= shock (SHOCK)
				16= door safties (SAFE)
	*/

/obj/item/assembly/control/airlock/activate()
	if(cooldown)
		return
	cooldown = TRUE
	var/doors_need_closing = FALSE
	var/list/obj/machinery/door/airlock/open_or_close = list()
	for(var/obj/machinery/door/airlock/D in GLOB.airlocks)
		if(D.id_tag == src.id)
			if(specialfunctions & OPEN)
				open_or_close += D
				if(!D.density)
					doors_need_closing = TRUE
			if(specialfunctions & IDSCAN)
				D.aiDisabledIdScanner = !D.aiDisabledIdScanner
			if(specialfunctions & BOLTS)
				if(!D.wires.is_cut(WIRE_BOLTS) && D.hasPower())
					if(D.locked)
						D.unlock()
					else
						D.lock()
					D.update_appearance()
			if(specialfunctions & SHOCK)
				if(D.secondsElectrified)
					D.set_electrified(MACHINE_ELECTRIFIED_PERMANENT, usr)
				else
					D.set_electrified(MACHINE_NOT_ELECTRIFIED, usr)
			if(specialfunctions & SAFE)
				D.safe = !D.safe

	for(var/D in open_or_close)
		INVOKE_ASYNC(D,  doors_need_closing ? TYPE_PROC_REF(/obj/machinery/door/airlock, close) : TYPE_PROC_REF(/obj/machinery/door/airlock, open))

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 1 SECONDS)


/obj/item/assembly/control/massdriver
	name = "mass driver controller"
	desc = "A small electronic device able to control a mass driver."

/obj/item/assembly/control/massdriver/activate()
	if(cooldown)
		return
	cooldown = TRUE
	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/door/poddoor, open))

	addtimer(CALLBACK(src, PROC_REF(activate_stage2)), 1 SECONDS)

/obj/item/assembly/control/massdriver/proc/activate_stage2()
	for(var/obj/machinery/mass_driver/M in GLOB.machines)
		if(M.id == src.id)
			M.drive()

	addtimer(CALLBACK(src, PROC_REF(activate_stage3)), 6 SECONDS)

/obj/item/assembly/control/massdriver/proc/activate_stage3()
	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/door/poddoor, close))

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 1 SECONDS)


/obj/item/assembly/control/igniter
	name = "ignition controller"
	desc = "A remote controller for a mounted igniter."

/obj/item/assembly/control/igniter/activate()
	if(cooldown)
		return
	cooldown = TRUE
	for(var/obj/machinery/sparker/M in GLOB.machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/sparker, ignite))

	for(var/obj/machinery/igniter/M in GLOB.machines)
		if(M.id == src.id)
			M.use_power(50)
			M.on = !M.on
			M.icon_state = "igniter[M.on]"

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 30)
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 3 SECONDS)

/obj/item/assembly/control/flasher
	name = "flasher controller"
	desc = "A remote controller for a mounted flasher."

/obj/item/assembly/control/flasher/activate()
	if(cooldown)
		return
	cooldown = TRUE
	for(var/obj/machinery/flasher/M in GLOB.machines)
		if(M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/flasher, flash))

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS)


/obj/item/assembly/control/crematorium
	name = "crematorium controller"
	desc = "An evil-looking remote controller for a crematorium."

/obj/item/assembly/control/crematorium/activate()
	if(cooldown)
		return
	cooldown = TRUE
	for (var/obj/structure/bodycontainer/crematorium/C in GLOB.crematoriums)
		if (C.id == id)
			C.cremate(usr)

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS)

//how long it spends on each floor when moving somewhere, so it'd take 4 seconds to reach you if it had to travel up 2 floors
#define FLOOR_TRAVEL_TIME 2 SECONDS
/obj/item/assembly/control/elevator
	name = "elevator controller"
	desc = "A small device used to call elevators to the current floor."

/obj/item/assembly/control/elevator/activate()
	if(cooldown)
		return
	cooldown = TRUE
	var/obj/structure/industrial_lift/lift
	for(var/l in GLOB.lifts)
		var/obj/structure/industrial_lift/possible_lift = l
		if(possible_lift.id != id || possible_lift.z == z || possible_lift.controls_locked)
			continue
		lift = possible_lift
		break
	if(!lift)
		addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 2 SECONDS)
		return
	lift.visible_message("<span class='notice'>[src] clinks and whirrs into automated motion, locking controls.</span")
	lift.lift_master_datum.set_controls(LOCKED)
	///The z level to which the elevator should travel
	var/targetZ = (abs(loc.z)) //The target Z (where the elevator should move to) is not our z level (we are just some assembly in nullspace) but actually the Z level of whatever we are contained in (e.g. elevator button)
	///The amount of z levels between the our and targetZ
	var/difference = abs(targetZ - lift.z)
	///Direction (up/down) needed to go to reach targetZ
	var/direction = lift.z < targetZ ? UP : DOWN
	///How long it will/should take us to reach the target Z level
	var/travel_duration = FLOOR_TRAVEL_TIME * difference //100 / 2 floors up = 50 seconds on every floor, will always reach destination in the same time
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), travel_duration)
	for(var/i in 1 to difference)
		sleep(FLOOR_TRAVEL_TIME)//hey this should be alright... right?
		if(QDELETED(lift) || QDELETED(src))//elevator control or button gone = don't go up anymore
			return
		lift.lift_master_datum.MoveLift(direction, null)
	lift.visible_message("<span class='notice'>[src] clicks, ready to be manually operated again.</span")
	lift.lift_master_datum.set_controls(UNLOCKED)

#undef FLOOR_TRAVEL_TIME
