// **************************************************************** DEATH *************************************************************

/obj/necrorune/death
	name = "Death"
	desc = "Instantly transport yourself to the Shadowlands."
	icon_state = "rune2"
	word = "Y'HO 'LLOH"

/obj/necrorune/death/complete()
	last_activator.death()
	qdel(src)
