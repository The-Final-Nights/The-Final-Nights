/obj/item/papercutter
	name = "paper cutter"
	desc = "Standard office equipment. Precisely cuts paper using a large blade."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "papercutter"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	pass_flags = PASSTABLE

	/// The paper currently loaded inside the cutter
	var/obj/item/paper/stored_paper

	/// The blade currently loaded inside the cutter
	var/obj/item/hatchet/cutterblade/stored_blade

	/// Whether the cutter blade is secured or not.
	var/blade_secured = TRUE

	/// The chance for a clumsy person to cut themselves on the blade
	/// Should probably be low-ish to prevent people spamming it quite so easily
	var/cut_self_chance = 5

/obj/item/papercutter/Initialize(mapload)
	. = ..()
	stored_blade = new /obj/item/hatchet/cutterblade(src)
	update_icon()

/obj/item/papercutter/Destroy(force)
	if(!isnull(stored_paper))
		QDEL_NULL(stored_paper)
	if(!isnull(stored_blade))
		QDEL_NULL(stored_blade)
	return ..()

/obj/item/papercutter/deconstruct(disassembled)
	..()
	if(!disassembled)
		return

	if(!isnull(stored_paper))
		stored_paper.forceMove(drop_location())
	if(!isnull(stored_blade))
		stored_blade.forceMove(drop_location())

/obj/item/papercutter/Exited(atom/movable/leaving, direction)
	if(leaving == stored_paper)
		stored_paper = null
	if(leaving == stored_blade)
		stored_blade = null
	return ..()

/obj/item/papercutter/suicide_act(mob/living/user)
	if(iscarbon(user) && stored_blade)
		var/mob/living/carbon/carbon_user = user
		var/obj/item/bodypart/user_head = carbon_user.get_bodypart(BODY_ZONE_HEAD)
		if(isnull(user_head)) // So no head?
			user.visible_message(span_suicide("[user] tries to behead [user.p_them()]self with [src], but [user.p_they()] [user.p_were()] already missing it! How embarassing!"))
			return SHAME
		user.visible_message(span_suicide("[user] is beheading [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
		user_head.drop_limb()
		playsound(loc, "desecration", 50, TRUE, -1)
		return BRUTELOSS
	// If we have no blade, just beat ourselves up
	user.visible_message(span_suicide("[user] repeatedly bashes [src] against [user.p_them()]self! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/items/gavel.ogg', 50, TRUE, -1)
	return BRUTELOSS

/obj/item/papercutter/update_overlays()
	. = ..()
	if(!isnull(stored_paper))
		. += "paper"
	if(!isnull(stored_blade))
		. += "cutter_overlay"

/obj/item/papercutter/screwdriver_act(mob/living/user, obj/item/tool)
	if(!stored_blade && !blade_secured)
		balloon_alert(user, "no blade!")
		return

	tool.play_tool_sound(src)
	balloon_alert(user, "[blade_secured ? "un" : ""]secured")
	blade_secured = !blade_secured
	return TRUE

/obj/item/papercutter/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!stored_blade)
		balloon_alert(user, "no blade!")
	else if(!blade_secured)
		balloon_alert(user, "blade unsecured!")
	else if(!stored_paper)
		balloon_alert(user, "nothing to cut!")
	else
		cut_paper(user)

	return TRUE

/obj/item/papercutter/attackby(obj/item/inserted_item, mob/user, params)
	if(istype(inserted_item, /obj/item/paper))
		if(is_type_in_list(inserted_item, list(
			/obj/item/paper/paperslip, /obj/item/paper/pamphlet)
			))
			balloon_alert(user, "won't fit!")
			return
		if(stored_paper)
			balloon_alert(user, "already paper inside!")
			return
		if(!user.transferItemToLoc(inserted_item, src))
			return
		playsound(loc, "page_turn", 60, TRUE)
		balloon_alert(user, "paper inserted")
		stored_paper = inserted_item

	if(istype(inserted_item, /obj/item/hatchet/cutterblade))
		if(stored_blade)
			balloon_alert(user, "already a blade inside!")
			return
		if(!user.transferItemToLoc(inserted_item, src))
			return
		balloon_alert(user, "blade inserted")
		inserted_item.forceMove(src)
		stored_blade = inserted_item

	update_icon()

	return ..()

/obj/item/papercutter/AltClick(mob/user)
	if(!user.Adjacent(src))
		return ..()

	// can only remove one at a time; paper goes first, as its most likely what players will want to be taking out
	if(!isnull(stored_paper))
		user.put_in_hands(stored_paper)
	else if(!isnull(stored_blade) && !blade_secured)
		user.put_in_hands(stored_blade)
	update_icon()

/obj/item/papercutter/proc/cut_paper(mob/user)
	playsound(src.loc, 'sound/weapons/slash.ogg', 50, TRUE)
	var/clumsy = (iscarbon(user) && HAS_TRAIT(user, TRAIT_CLUMSY) && prob(cut_self_chance))
	to_chat(user, span_userdanger("You neatly cut [stored_paper][clumsy ? "... and your finger in the process!" : "."]"))
	if(clumsy)
		var/obj/item/bodypart/finger = user.get_active_hand()
		var/datum/wound/slash/moderate/papercut = new
		papercut.apply_wound(finger)
	stored_paper = null
	qdel(stored_paper)
	new /obj/item/paper/paperslip(get_turf(src))
	new /obj/item/paper/paperslip(get_turf(src))
	update_icon()

/obj/item/papercutter/MouseDrop(atom/over_object)
	. = ..()
	var/mob/user = usr
	if(user.incapacitated() || !Adjacent(user))
		return

	if(over_object == user)
		user.put_in_hands(src)

	else if(istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/target_hand = over_object
		user.putItemFromInventoryInHandIfPossible(src, target_hand.held_index)
	add_fingerprint(user)

/obj/item/paper/paperslip
	name = "paper slip"
	desc = "A little slip of paper left over after a larger piece was cut. Whoa."
	icon_state = "paperslip"
	inhand_icon_state = "silver_id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	grind_results = list(/datum/reagent/cellulose = 1.5) //It's a normal paper sheet divided in 2. 3 divided by 2 equals 1.5, this way you can't magically dupe cellulose

/obj/item/paper/paperslip/corporate //More fancy and sturdy paper slip which is a "plastic card", used for things like spare ID safe code
	name = "corporate plastic card"
	desc = "A plastic card for confidential corporate matters. Can be written on with pen somehow."
	icon_state = "corppaperslip"
	grind_results = list(/datum/reagent/plastic_polymers = 1.5) //It's a plastic card after all
	max_integrity = 130 //Slightly more sturdy because of being made out of a plastic
	drop_sound = 'sound/items/handling/disk_drop.ogg'
	pickup_sound = 'sound/items/handling/disk_pickup.ogg'
	throw_range = 6
	throw_speed = 2

/obj/item/hatchet/cutterblade
	name = "paper cutter blade"
	desc = "The blade of a paper cutter. Most likely removed for polishing or sharpening."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "cutterblade"
	inhand_icon_state = "knife"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
