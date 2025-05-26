/datum/buildmode_mode/throwing
	key = "throw"

	var/atom/movable/throw_atom = null

/datum/buildmode_mode/throwing/Destroy()
	throw_atom = null
	return ..()

/datum/buildmode_mode/throwing/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		"[span_bold("Select")] -> Left Mouse Button on turf/obj/mob\n\
		[span_bold("Throw")] -> Right Mouse Button on turf/obj/mob"))
	)

/datum/buildmode_mode/throwing/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(left_click)
		if(isturf(object))
			return
		throw_atom = object
		to_chat(c, "Selected object '[throw_atom]'")
	if(right_click)
		if(throw_atom)
			throw_atom.throw_at(object, 10, 1, c.mob)
			log_admin("Build Mode: [key_name(c)] threw [throw_atom] at [object] ([AREACOORD(object)])")
