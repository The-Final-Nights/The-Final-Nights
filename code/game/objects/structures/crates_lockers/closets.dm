/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "generic"
	density = TRUE
	drag_slowdown = 1.5		// Same as a prone mob
	max_integrity = 200
	integrity_failure = 0.25
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 70, ACID = 60)

	var/icon_door = null
	var/icon_door_override = FALSE //override to have open overlay use icon different to its base's
	var/secure = FALSE //secure locker or not, also used if overriding a non-secure locker with a secure door overlay to add fancy lights
	var/opened = FALSE
	var/welded = FALSE
	var/locked = FALSE
	var/large = TRUE
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/breakout_time = 1200
	var/message_cooldown
	var/can_weld_shut = TRUE
	var/horizontal = FALSE
	var/allow_objects = FALSE
	var/allow_dense = FALSE
	var/dense_when_open = FALSE //if it's dense when open or not
	var/max_mob_size = MOB_SIZE_HUMAN //Biggest mob_size accepted by the container
	var/mob_storage_capacity = 3 // how many human sized mob/living can fit together inside a closet.
	var/storage_capacity = 30 //This is so that someone can't pack hundreds of items in a locker/crate then open it in a populated area to crash clients.
	var/cutting_tool = /obj/item/weldingtool
	var/open_sound = 'sound/machines/closet_open.ogg'
	var/close_sound = 'sound/machines/closet_close.ogg'
	var/open_sound_volume = 35
	var/close_sound_volume = 50
	var/material_drop = /obj/item/stack/sheet/metal
	var/material_drop_amount = 2
	var/delivery_icon = "deliverycloset" //which icon to use when packagewrapped. null to be unwrappable.
	var/anchorable = TRUE
	var/icon_welded = "welded"
	/// Whether a skittish person can dive inside this closet. Disable if opening the closet causes "bad things" to happen or that it leads to a logical inconsistency.
	var/divable = TRUE


/obj/structure/closet/Initialize(mapload)
	if(mapload && !opened)		// if closed, any item at the crate's loc is put in the contents
		addtimer(CALLBACK(src, PROC_REF(take_contents)), 0)
	. = ..()
	update_appearance()
	PopulateContents()

//USE THIS TO FILL IT, NOT INITIALIZE OR NEW
/obj/structure/closet/proc/PopulateContents()
	return

/obj/structure/closet/Destroy()
	dump_contents()
	return ..()

/obj/structure/closet/update_appearance(updates=ALL)
	. = ..()
	if(opened || broken || !secure)
		luminosity = 0
		return
	luminosity = 1

/obj/structure/closet/update_appearance()
	. = ..()
	if(istype(src, /obj/structure/closet/supplypod))
		return

	layer = opened ? BELOW_OBJ_LAYER : OBJ_LAYER

/obj/structure/closet/update_overlays()
	. = ..()
	closet_update_overlays(.)

/obj/structure/closet/proc/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(opened)
		. += "[icon_door_override ? icon_door : icon_state]_open"
		return

	. += "[icon_door || icon_state]_door"
	if(welded)
		. += icon_welded

	if(broken || !secure)
		return
	//Overlay is similar enough for both that we can use the same mask for both
	SSvis_overlays.add_vis_overlay(src, icon, "locked", EMISSIVE_LAYER, EMISSIVE_PLANE, dir, alpha)
	. += locked ? "locked" : "unlocked"

/obj/structure/closet/examine(mob/user)
	. = ..()
	if(welded)
		. += "<span class='notice'>It's welded shut.</span>"
	if(anchored)
		. += "<span class='notice'>It is <b>bolted</b> to the ground.</span>"
	if(opened)
		. += "<span class='notice'>The parts are <b>welded</b> together.</span>"
	else if(secure && !opened)
		. += "<span class='notice'>Right-click to [locked ? "unlock" : "lock"].</span>"

	if(HAS_TRAIT(user, TRAIT_SKITTISH) && divable)
		. += "<span class='notice'>If you bump into [p_them()] while running, you will jump inside.</span>"

/obj/structure/closet/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(wall_mounted)
		return TRUE

/obj/structure/closet/proc/can_open(mob/living/user, force = FALSE)
	if(force)
		return TRUE
	if(welded || locked)
		return FALSE
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		if(L.anchored || horizontal && L.mob_size > MOB_SIZE_TINY && L.density)
			if(user)
				to_chat(user, "<span class='danger'>There's something large on top of [src], preventing it from opening.</span>" )
			return FALSE
	return TRUE

/obj/structure/closet/proc/can_close(mob/living/user)
	var/turf/T = get_turf(src)
	for(var/obj/structure/closet/closet in T)
		if(closet != src && !closet.wall_mounted)
			return FALSE
	for(var/mob/living/L in T)
		if(L.anchored || horizontal && L.mob_size > MOB_SIZE_TINY && L.density)
			if(user)
				to_chat(user, "<span class='danger'>There's something too large in [src], preventing it from closing.</span>")
			return FALSE
	return TRUE

/obj/structure/closet/dump_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		if(throwing) // you keep some momentum when getting out of a thrown closet
			step(AM, dir)
	if(throwing)
		throwing.finalize(FALSE)

/obj/structure/closet/proc/take_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in L)
		if(AM != src && insert(AM) == -1) // limit reached
			break
	for(var/i in reverse_range(L.GetAllContents()))
		var/atom/movable/thing = i
		SEND_SIGNAL(thing, COMSIG_TRY_STORAGE_HIDE_ALL)

/obj/structure/closet/proc/open(mob/living/user, force = FALSE)
	if(!can_open(user, force))
		return
	if(opened)
		return
	welded = FALSE
	locked = FALSE
	playsound(loc, open_sound, open_sound_volume, TRUE, -3)
	opened = TRUE
	if(!dense_when_open)
		density = FALSE
	dump_contents()
	update_appearance()
	after_open(user, force)
	return TRUE

///Proc to override for effects after opening a door
/obj/structure/closet/proc/after_open(mob/living/user, force = FALSE)
	return

/obj/structure/closet/proc/insert(atom/movable/AM)
	if(contents.len >= storage_capacity)
		return -1
	if(insertion_allowed(AM))
		AM.forceMove(src)
		return TRUE
	else
		return FALSE

/obj/structure/closet/proc/insertion_allowed(atom/movable/AM)
	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or camera mobs inside closets...
			return FALSE
		var/mob/living/L = AM
		if(L.anchored || L.buckled || L.incorporeal_move || L.has_buckled_mobs())
			return FALSE
		if(L.mob_size > MOB_SIZE_TINY) // Tiny mobs are treated as items.
			if(horizontal && L.density)
				return FALSE
			if(L.mob_size > max_mob_size)
				return FALSE
			var/mobs_stored = 0
			for(var/mob/living/M in contents)
				if(++mobs_stored >= mob_storage_capacity)
					return FALSE
		L.stop_pulling()

	else if(istype(AM, /obj/structure/closet))
		return FALSE
	else if(isobj(AM))
		if((!allow_dense && AM.density) || AM.anchored || AM.has_buckled_mobs())
			return FALSE
		else if(isitem(AM) && !HAS_TRAIT(AM, TRAIT_NODROP))
			return TRUE
		else if(!allow_objects && !istype(AM, /obj/effect/dummy/chameleon))
			return FALSE
	else
		return FALSE

	return TRUE

/obj/structure/closet/proc/close(mob/living/user)
	if(!opened || !can_close(user))
		return FALSE
	take_contents()
	playsound(loc, close_sound, close_sound_volume, TRUE, -3)
	opened = FALSE
	density = TRUE
	update_appearance()
	after_close(user)
	return TRUE

///Proc to override for effects after closing a door
/obj/structure/closet/proc/after_close(mob/living/user)
	return


/obj/structure/closet/proc/toggle(mob/living/user)
	if(opened)
		return close(user)
	else
		return open(user)

/obj/structure/closet/deconstruct(disassembled = TRUE)
	if(ispath(material_drop) && material_drop_amount && !(flags_1 & NODECONSTRUCT_1))
		new material_drop(loc, material_drop_amount)
	qdel(src)

/obj/structure/closet/atom_break(damage_flag)
	. = ..()
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		bust_open()

/obj/structure/closet/attackby(obj/item/W, mob/user, params)
	if(user in src)
		return
	if(src.tool_interact(W,user))
		return 1 // No afterattack
	else
		return ..()

/obj/structure/closet/proc/tool_interact(obj/item/W, mob/living/user)//returns TRUE if attackBy call shouldn't be continued (because tool was used/closet was of wrong type), FALSE if otherwise
	. = TRUE
	if(opened)
		if(istype(W, cutting_tool))
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return

				to_chat(user, "<span class='notice'>You begin cutting \the [src] apart...</span>")
				if(W.use_tool(src, user, 40, volume=50))
					if(!opened)
						return
					user.visible_message("<span class='notice'>[user] slices apart \the [src].</span>",
									"<span class='notice'>You cut \the [src] apart with \the [W].</span>",
									"<span class='hear'>You hear welding.</span>")
					deconstruct(TRUE)
				return
			else // for example cardboard box is cut with wirecutters
				user.visible_message("<span class='notice'>[user] cut apart \the [src].</span>", \
									"<span class='notice'>You cut \the [src] apart with \the [W].</span>")
				deconstruct(TRUE)
				return
		if(user.transferItemToLoc(W, drop_location())) // so we put in unlit welder too
			return
	else if(W.tool_behaviour == TOOL_WELDER && can_weld_shut)
		if(!W.tool_start_check(user, amount=0))
			return

		to_chat(user, "<span class='notice'>You begin [welded ? "unwelding":"welding"] \the [src]...</span>")
		if(W.use_tool(src, user, 40, volume=50))
			if(opened)
				return
			welded = !welded
			after_weld(welded)
			user.visible_message("<span class='notice'>[user] [welded ? "welds shut" : "unwelded"] \the [src].</span>",
							"<span class='notice'>You [welded ? "weld" : "unwelded"] \the [src] with \the [W].</span>",
							"<span class='hear'>You hear welding.</span>")
			log_game("[key_name(user)] [welded ? "welded":"unwelded"] closet [src] with [W] at [AREACOORD(src)]")
			update_appearance()
	else if(!user.combat_mode)
		var/item_is_id = W.GetID()
		if(!item_is_id)
			return FALSE
		if(item_is_id || !toggle(user))
			togglelock(user)
	else
		return FALSE

/obj/structure/closet/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(!anchorable)
		balloon_alert(user, "no anchor bolts!")
		return TRUE
	if(isinspace() && !anchored) // We want to prevent anchoring a locker in space, but we should still be able to unanchor it there
		balloon_alert(user, "nothing to anchor to!")
		return TRUE
	set_anchored(!anchored)
	tool.play_tool_sound(src, 75)
	user.balloon_alert_to_viewers("[anchored ? "anchored" : "unanchored"]")
	return TRUE

/obj/structure/closet/proc/after_weld(weld_state)
	return

/obj/structure/closet/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O) || O.anchored || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated() || user.body_position == LYING_DOWN)
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb onto it
		return ..()
	if(!opened)
		return
	if(!isturf(O.loc))
		return

	var/actuallyismob = 0
	if(isliving(O))
		actuallyismob = 1
	else if(!isitem(O))
		return
	var/turf/T = get_turf(src)
	var/list/targets = list(O, src)
	add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] [actuallyismob ? "tries to ":""]stuff [O] into [src].</span>", \
		"<span class='warning'>You [actuallyismob ? "try to ":""]stuff [O] into [src].</span>", \
		"<span class='hear'>You hear clanging.</span>")
	if(actuallyismob)
		if(do_after_mob(user, targets, 40))
			user.visible_message("<span class='notice'>[user] stuffs [O] into [src].</span>", \
				"<span class='notice'>You stuff [O] into [src].</span>", \
				"<span class='hear'>You hear a loud metal bang.</span>")
			var/mob/living/L = O
			if(!issilicon(L))
				L.Paralyze(40)
			if(istype(src, /obj/structure/closet/supplypod/extractionpod))
				O.forceMove(src)
			else
				O.forceMove(T)
				close()
	else
		O.forceMove(T)
	return 1

/obj/structure/closet/relaymove(mob/living/user, direction)
	if(user.stat || !isturf(loc))
		return
	if(locked)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, "<span class='warning'>[src]'s door won't budge!</span>")
		return
	container_resist_act(user)


/obj/structure/closet/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.body_position == LYING_DOWN && get_dist(src, user) > 0)
		return

	if(!toggle(user))
		togglelock(user)


/obj/structure/closet/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/closet/attack_robot(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user)
	if(attack_hand(user))
		return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/structure/closet/verb/verb_toggleopen()
	set src in view(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return

	if(iscarbon(usr) || issilicon(usr) || isdrone(usr))
		return toggle(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

// Objects that try to exit a locker by stepping were doing so successfully,
// and due to an oversight in turf/Enter() were going through walls.  That
// should be independently resolved, but this is also an interesting twist.
/obj/structure/closet/Exit(atom/movable/AM)
	open()
	if(AM.loc == src)
		return FALSE
	return TRUE

/obj/structure/closet/container_resist_act(mob/living/user)
	if(opened)
		return
	if(ismovable(loc))
		user.changeNext_move(CLICK_CD_BREAKOUT)
		user.last_special = world.time + CLICK_CD_BREAKOUT
		var/atom/movable/AM = loc
		AM.relay_container_resist_act(user, src)
		return
	if(!welded && !locked)
		open()
		return

	//okay, so the closet is either welded or locked... resist!!!
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message("<span class='warning'>[src] begins to shake violently!</span>", \
		"<span class='notice'>You lean on the back of [src] and start pushing the door open... (this will take about [DisplayTimeText(breakout_time)].)</span>", \
		"<span class='hear'>You hear banging from [src].</span>")
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || opened || (!locked && !welded) )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting
		user.visible_message("<span class='danger'>[user] successfully broke out of [src]!</span>",
							"<span class='notice'>You successfully break out of [src]!</span>")
		bust_open()
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, "<span class='warning'>You fail to break out of [src]!</span>")

/obj/structure/closet/proc/bust_open()
	welded = FALSE //applies to all lockers
	locked = FALSE //applies to critter crates and secure lockers only
	broken = TRUE //applies to secure lockers only
	open()

/obj/structure/closet/attack_hand_secondary(mob/user, modifiers)
	. = ..()

	if(!user.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return

	if(!opened && secure)
		togglelock(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/closet/proc/togglelock(mob/living/user, silent)
	if(secure && !broken)
		if(allowed(user))
			if(iscarbon(user))
				add_fingerprint(user)
			locked = !locked
			user.visible_message("<span class='notice'>[user] [locked ? null : "un"]locks [src].</span>",
							"<span class='notice'>You [locked ? null : "un"]lock [src].</span>")
			update_appearance()
		else if(!silent)
			to_chat(user, "<span class='alert'>Access Denied.</span>")
	else if(secure && broken)
		to_chat(user, "<span class='warning'>\The [src] is broken!</span>")

/obj/structure/closet/emag_act(mob/user)
	if(secure && !broken)
		if(user)
			user.visible_message("<span class='warning'>Sparks fly from [src]!</span>",
							"<span class='warning'>You scramble [src]'s lock, breaking it open!</span>",
							"<span class='hear'>You hear a faint electrical spark.</span>")
		playsound(src, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		broken = TRUE
		locked = FALSE
		update_appearance()

/obj/structure/closet/get_remote_view_fullscreens(mob/user)
	if(user.stat == DEAD || !(user.sight & (SEEOBJS|SEEMOBS)))
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 1)

/obj/structure/closet/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if (!(. & EMP_PROTECT_CONTENTS))
		for(var/obj/O in src)
			O.emp_act(severity)
	if(secure && !broken && !(. & EMP_PROTECT_SELF))
		if(prob(50 / severity))
			locked = !locked
			update_appearance()
		if(prob(20 / severity) && !opened)
			if(!locked)
				open()
			else
				req_access = list()
				req_access += pick(get_all_accesses())

/obj/structure/closet/contents_explosion(severity, target)
	for(var/thing in contents)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += thing
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += thing
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += thing

/obj/structure/closet/singularity_act()
	dump_contents()
	..()

/obj/structure/closet/AllowDrop()
	return TRUE
