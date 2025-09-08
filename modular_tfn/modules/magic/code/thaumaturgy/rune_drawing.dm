
//RUNE DRAWING
/datum/action/thaumaturgy
	name = "Thaumaturgy"
	desc = "Blood magic rune drawing."
	button_icon_state = "thaumaturgy"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_IMMOBILE | AB_CHECK_LYING | AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/drawing = FALSE
	var/level = 1

/datum/action/thaumaturgy/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(H, span_warning("You need more <b>BLOOD</b> to do that!"))
		return
	if(drawing)
		return

	if(istype(H.get_active_held_item(), /obj/item/arcane_tome))
		var/list/rune_names = list()
		for(var/i in subtypesof(/obj/ritualrune))
			var/obj/ritualrune/R = new i(owner)
			if(R.thaumlevel <= level)
				rune_names[R.name] = i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw:", "Thaumaturgy", rune_names)
		if(ritual)
			drawing = TRUE
			if(do_after(H, 3 SECONDS * max(1, 5 - H.get_total_mentality()), H))
				drawing = FALSE
				var/ritual_type = rune_names[ritual]
				new ritual_type(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)
			else
				drawing = FALSE
	else
		var/list/shit = list()
		for(var/i in subtypesof(/obj/ritualrune))
			var/obj/ritualrune/R = new i(owner)
			if(R.thaumlevel <= level)
				shit += i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw (You need an Arcane Tome to reduce random):", "Thaumaturgy", list("???"))
		if(ritual)
			drawing = TRUE
			if(do_after(H, 3 SECONDS * max(1, 5 - H.get_total_mentality()), H))
				drawing = FALSE
				var/rune = pick(shit)
				new rune(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)
			else
				drawing = FALSE
