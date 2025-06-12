// **************************************************************** MINESTRA DI MORTE *************************************************************

/obj/necrorune/locate
	name = "Minestra di Morte"
	desc = "Verify a soul's status and try to divine its location."
	icon_state = "rune5"
	word = "UAH'V OUH'RAN"
	necrolevel = 3
	sacrifices = list(/obj/item/shard)

/obj/necrorune/locate/complete()

	var/chosen_name = tgui_input_text(usr, "Invoke the true name of the soul you seek:", "Minestra di Morte")
	var/target = find_target(chosen_name)

	if(!target)
		to_chat(usr, span_warning("No such soul is present beyond the Shroud, nor here in the Skinlands!"))
		return
	
	var/area/targetarea = get_area(target)

	if(isavatar(target))
		to_chat(usr, span_ghostalert("This soul has bridged the two realities - their astral projection wanders [targetarea.name]."))
		playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)
		qdel(src)
		return

	if(isobserver(target))
		to_chat(usr, span_ghostalert("This soul has departed the realm of the living - they wander [targetarea.name]."))
		playsound(loc, 'code/modules/wod13/sounds/necromancy1off.ogg', 50, FALSE)
		qdel(src)
		return

	if(isliving(target))
		var/mob/living/livetarget = target
		if(livetarget.stat != DEAD)
			to_chat(usr, span_ghostalert("This soul yet persists in the Skinlands at [targetarea.name]."))
			playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)
			
			if(livetarget.stat > SOFT_CRIT)
				to_chat(usr, span_ghostalert("Their connection to this is realm weak, and fading. Death waits for them."))
			if(livetarget.necromancy_knowledge) //other necromancers catch onto it if targeted
				var/area/userarea = get_area(usr)
				to_chat(livetarget, span_notice("A chill and a whisper. A fellow necromancer has sought out your soul - their own calling out from <b>[userarea.name]</b>."))
			qdel(src)
			return

		if (livetarget.stat == DEAD) //for when they haven't ghosted yet
			to_chat(usr, span_ghostalert("This soul remains caged to its perished vessel at [targetarea.name]."))
			qdel(src)
			return

/obj/necrorune/locate/proc/find_target(chosen_name)
	var/mob/target_found
	for(var/mob/target in GLOB.player_list)
		if(target.real_name == chosen_name)
			target_found = target
			break
	return target_found 
