/obj/item/organ/stomach/vampire
	var/capacity = 0 // This is TERRIBLE handling but the alternative is a complete reagent rework.  // TODO: add blush of life check to prevent instant vomiting

/obj/item/organ/stomach/vampire/on_life()
	. = ..()

	if(owner)
		if(HAS_TRAIT(owner, TRAIT_CAN_EAT) && capacity >= 0)
			capacity-- // Eat Food vampires eating good
			return

		if(capacity <= 0)
			owner.clear_alert("stomach")
		if(capacity >= 75) // 1.5 glasses of Alexander or whatever people order
			owner.throw_alert("stomach", /atom/movable/screen/alert/vampire_stomach)
		if(capacity >= 150) // Too full! Hurl immediately.
			owner.vomit(lost_nutrition = 0, blood = TRUE, message = FALSE, harm = TRUE, force = TRUE, purge_ratio = 1)
			capacity = 0
			owner.clear_alert("stomach")

/atom/movable/screen/alert/vampire_stomach
	name = "Full Stomach"
	desc = "Your vampiric stomach is more than half full. Alt-click the alert to purge it's contents. Stand next to a toilet, sink, or trashcan if you don't want to make a mess!"
	icon = 'modular_tfn/master_files/icons/hud/screen_alert.dmi'
	icon_state = "stomach"	// Sprite by Major00 (Paynt)


/atom/movable/screen/alert/vampire_stomach/Click()
	. = ..()

	var/mob/living/carbon/human/L = usr
	var/obj/item/organ/stomach/vampire/stummy = L.getorganslot(ORGAN_SLOT_STOMACH)
	if(!istype(L)|| L != owner) // Lol.
		return
	to_chat(owner, span_warning("You start trying to throw up..."))
	var/list/vomit_targets = list() // Make the list
	var/vomit_location
	for(var/turf/turfs in range(1, L)) // Every nearby turf
		for(var/obj/O in turfs.contents) // What items are on the turf?
			if(istype(O, /obj/structure/toilet) || istype(O, /obj/structure/sink) || istype(O, /obj/structure/closet/crate/bin)) // Can we vomit in here?
				vomit_targets += O

	if(vomit_targets.len) // Did we find any vomitables?
		vomit_location = vomit_targets[1]
		if(do_after(L, 5 SECONDS, vomit_location)) // We found one! Hurl in here.
			L.vomit(lost_nutrition = 0, blood = TRUE, stun = FALSE, distance = 0, harm = FALSE, purge_ratio = 1)
			stummy.capacity = 0
	else if(do_after(L, 5 SECONDS))// Didn't find any. Hurl on the floor.
		L.vomit(lost_nutrition = 0, blood = TRUE, stun = FALSE, harm = FALSE, force = TRUE, purge_ratio = 1)
		stummy.capacity = 0
