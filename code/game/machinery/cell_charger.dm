/obj/machinery/cell_charger
	name = "cell charger"
	desc = "It charges power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger"
	use_power = IDLE_POWER_USE
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = AREA_USAGE_EQUIP
	circuit = /obj/item/circuitboard/machine/cell_charger
	pass_flags = PASSTABLE
	var/obj/item/stock_parts/cell/charging = null
	var/charge_rate = 250

/obj/machinery/cell_charger/update_overlays()
	. = ..()

	if(!charging)
		return

	. += image(charging.icon, charging.icon_state)
	. += "ccharger-on"
	if(!(machine_stat & (BROKEN|NOPOWER)))
		var/newlevel = 	round(charging.percent() * 4 / 100)
		. += "ccharger-o[newlevel]"

/obj/machinery/cell_charger/examine(mob/user)
	. = ..()
	. += "There's [charging ? "a" : "no"] cell in the charger."
	if(charging)
		. += "Current charge: [round(charging.percent(), 1)]%."
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Charging power: <b>[charge_rate]W</b>.</span>"

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell) && !panel_open)
		if(machine_stat & BROKEN)
			to_chat(user, "<span class='warning'>[src] is broken!</span>")
			return
		if(!anchored)
			to_chat(user, "<span class='warning'>[src] isn't attached to the ground!</span>")
			return
		if(charging)
			to_chat(user, "<span class='warning'>There is already a cell in the charger!</span>")
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, "<span class='warning'>[src] blinks red as you try to insert the cell!</span>")
				return
			if(!user.transferItemToLoc(W,src))
				return

			charging = W
			user.visible_message("<span class='notice'>[user] inserts a cell into [src].</span>", "<span class='notice'>You insert a cell into [src].</span>")
			update_appearance()
	else
		if(!charging && default_deconstruction_screwdriver(user, icon_state, icon_state, W))
			return
		if(default_deconstruction_crowbar(W))
			return
		if(!charging && default_unfasten_wrench(user, W))
			return
		return ..()

/obj/machinery/cell_charger/deconstruct()
	if(charging)
		charging.forceMove(drop_location())
	return ..()

/obj/machinery/cell_charger/Destroy()
	QDEL_NULL(charging)
	return ..()

/obj/machinery/cell_charger/proc/removecell()
	charging.update_appearance()
	charging = null
	update_appearance()

/obj/machinery/cell_charger/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!charging)
		return

	user.put_in_hands(charging)
	charging.add_fingerprint(user)

	user.visible_message("<span class='notice'>[user] removes [charging] from [src].</span>", "<span class='notice'>You remove [charging] from [src].</span>")

	removecell()


/obj/machinery/cell_charger/attack_tk(mob/user)
	if(!charging)
		return

	charging.forceMove(loc)
	to_chat(user, "<span class='notice'>You telekinetically remove [charging] from [src].</span>")

	removecell()
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/machinery/cell_charger/attack_ai(mob/user)
	return

/obj/machinery/cell_charger/emp_act(severity)
	. = ..()

	if(machine_stat & (BROKEN|NOPOWER) || . & EMP_PROTECT_CONTENTS)
		return

	if(charging)
		charging.emp_act(severity)

/obj/machinery/cell_charger/RefreshParts()
	charge_rate = 250
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		charge_rate *= C.rating

/obj/machinery/cell_charger/process(delta_time)
	if(!charging || !anchored || (machine_stat & (BROKEN|NOPOWER)))
		return

	if(charging.percent() >= 100)
		return

	var/main_draw = use_power_from_net(charge_rate * delta_time, take_any = TRUE) //Pulls directly from the Powernet to dump into the cell
	if(!main_draw)
		return
	charging.give(main_draw)
	use_power(charge_rate / 100) //use a small bit for the charger itself, but power usage scales up with the part tier

	update_appearance()
