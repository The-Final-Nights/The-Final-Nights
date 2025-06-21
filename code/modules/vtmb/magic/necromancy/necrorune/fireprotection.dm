// **************************************************************** CHILL OF OBLIVION *************************************************************

/obj/necrorune/fireprotection
	name = "Chill of Oblivion"
	desc = "Invite the cold of the Shadowlands into your soul to undo the body's fire-weakness. This profane blessing <b>taints the recipient's aura</b>."
	icon_state = "rune1"
	word = "DHAI'AD BHA'II DAWH'N"
	necrolevel = 4

/obj/necrorune/fireprotection/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody.stat == DEAD)
			to_chat(usr, span_warning("The target is dead, the cold has long settled inside."))
			return

		else valid_bodies += targetbody

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("The ritual's target must remain over the rune."))
		return

	var/mob/living/carbon/victim = pick(valid_bodies)

	if(victim.fakediablerist)
		to_chat(usr, span_warning("The ritual's target has already been claimed by the cold."))
		return

	playsound(loc, 'sound/effects/ghost.ogg', 50, FALSE)
	victim.emote("shiver")
	victim.Immobilize(4 SECONDS)

	to_chat(victim, span_revendanger("Burning ice bleeds out of your soul and into everything else. Paralyzed, you stand in the cold as death lingers."))
	victim.fakediablerist = TRUE
	if(iskindred(victim) || iscathayan(victim) || iszombie(victim)) //made this a deduction rather than a flat set because of an artifact that independently changes damage mods
		victim.dna.species.burnmod = max(0.5, victim.dna.species.burnmod-1)
	else
		victim.dna.species.burnmod = max(0.5, victim.dna.species.burnmod-0.5)
	qdel(src)
