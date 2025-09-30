/obj/structure/musician
	name = "Not A Piano"
	desc = "Something broke, contact coderbus."
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT | INTERACT_ATOM_REQUIRES_DEXTERITY
	var/can_play_unanchored = FALSE
	var/list/allowed_instrument_ids = list("r3grand","r3harpsi","crharpsi","crgrand1","crbright1", "crichugan", "crihamgan","piano")
	var/datum/song/song

/obj/structure/musician/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids)
	allowed_instrument_ids = null

/obj/structure/musician/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/structure/musician/proc/should_stop_playing(mob/user)
	if(!(anchored || can_play_unanchored))
		return TRUE
	if(!user)
		return FALSE
	return !user.canUseTopic(src, FALSE, TRUE, FALSE, FALSE)		//can play with TK and while resting because fun.

/obj/structure/musician/ui_interact(mob/user)
	. = ..()
	song.ui_interact(user)

/obj/structure/musician/wrench_act(mob/living/user, obj/item/I)
	default_unfasten_wrench(user, I, 40)
	return TRUE

//TFN EDIT START - Jazz Club Remap #781 - Renames space minimoog to piano, introduces inverted piano, removes nonfunctional RNG from piano
/obj/structure/musician/piano
	name = "piano"
	icon = 'icons/obj/musician.dmi'
	icon_state = "piano"
	desc = "This is a piano! A lovely instrument. The keys face east."
	anchored = TRUE
	density = TRUE

/obj/structure/musician/piano/unanchored
	anchored = FALSE

/obj/structure/musician/piano/ipiano
	name = "piano"
	desc = "This is a piano! A delightful instrument. The keys face west."
	icon_state = "ipiano"

/obj/structure/musician/minimoog
	name = "minimoog"
	icon_state = "minimoog"
	desc = "This is a minimoog! A cousin of the piano!"
//TFN EDIT END - Jazz Club Remap #781
