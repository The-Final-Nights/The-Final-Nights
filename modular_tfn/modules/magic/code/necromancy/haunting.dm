// **************************************************************** MINESTRA DI MORTE *************************************************************

/obj/necrorune/haunting
	name = "Haunting"
	desc = "Take a wraith's soul from the underworld and force it into a blade."
	icon_state = "rune9"
	word = "LIGA HUN'C SPIRIT'UM"
	necrolevel = 4
	sacrifices = list(/obj/item/melee/vampirearms/katana/kosa)
	var/duration_length = 15 SECONDS

/obj/necrorune/haunting/complete()
	new /obj/item/melee/vampirearms/katana/kosa/possessed(loc)
	playsound(loc, 'code/modules/wod13/sounds/necromancy2.ogg', 50, FALSE)
	qdel(src)

/obj/item/melee/vampirearms/katana/kosa/possessed
	name = "soulsteel scythe"
	desc = "A scythe turned into a prison, this weapon has bound a Wraith within and locked it away from the rest of the world."
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "kosa"
	color = "#808080"
	force = 45
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = null
	block_chance = 12
	armour_penetration = 25
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	wound_bonus = 5
	bare_wound_bonus = 10
	resistance_flags = FIRE_PROOF
	masquerade_violating = TRUE
	var/possessed = FALSE

/obj/item/melee/vampirearms/katana/kosa/possessed/relaymove(mob/living/user, direction)
	return //stops buckled message spam for the ghost.

/obj/item/melee/vampirearms/katana/kosa/possessed/attack_self(mob/living/user)
	if(possessed)
		return
	if(!(GLOB.ghost_role_flags & GHOSTROLE_STATION_SENTIENCE))
		to_chat(user, span_notice("Anomalous otherworldly energies block you from capturing a wraith!"))
		return

	to_chat(user, span_notice("You attempt to trap a wraith into the scythe..."))

	possessed = TRUE

	var/list/mob/dead/observer/candidates = pollGhostCandidates("Do you want to play as the spirit of [user.real_name]'s scythe?", ROLE_PAI, null, FALSE, 100, POLL_IGNORE_POSSESSED_BLADE)

	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		var/mob/living/simple_animal/shade/S = new(src)
		S.ckey = C.ckey
		S.fully_replace_character_name(null, "The spirit of [name]")
		S.status_flags |= GODMODE
		S.copy_languages(user, LANGUAGE_MASTER)	//Make sure the sword can understand and communicate with the user.
		S.update_atom_languages()
		grant_all_languages(FALSE, FALSE, TRUE)	//Grants omnitongue
		var/input = sanitize_name(stripped_input(S,"What are you named?", ,"", MAX_NAME_LEN))

		if(src && input)
			name = input
			S.fully_replace_character_name(null, "The spirit of [input]")
	else
		to_chat(user, span_notice("The scythe is dormant. Maybe you can try again later."))
		possessed = FALSE

/obj/item/melee/vampirearms/katana/kosa/possessed/Destroy()
	for(var/mob/living/simple_animal/shade/S in contents)
		to_chat(S, span_notice("You were destroyed!"))
		qdel(S)
	return ..()
