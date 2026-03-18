/obj/sabbatrune
	name = "Monomacy Rune"
	desc = "Monomacy is the rite of resolving disputes among pack mates. Challenge that curr to a duel!"
	icon = 'icons/effects/crayondecal.dmi'
	icon_state = "rune4"
	color = rgb(64, 64, 64)
	anchored = TRUE
	var/activated = FALSE
	var/mob/living/last_activator
	var/list/sacrifices = list()
	var/MONOMACY_CHALLENGE_COOLDOWN

#define MONOMACY_COOLDOWN_DURATION (10 MINUTES)

/obj/sabbatrune/attack_hand(mob/living/user)
	. = ..()

	if(!COOLDOWN_FINISHED(src, MONOMACY_CHALLENGE_COOLDOWN))
		to_chat(user, span_warning("The rune is still cooling down from the last challenge."))
		return

	last_activator = user
	issue_challenge(user)

/obj/sabbatrune/proc/issue_challenge(mob/living/challenger)
	// Ask for the name of the player to challenge
	var/challenged_name = tgui_input_text(challenger, "Enter the name of the person you wish to challenge to Monomacy:", "Monomacy Challenge")
	if(!challenged_name)
		return

	// Find the target based on the provided name
	var/mob/living/target = null
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		// if the target is not dead, is the challenger isnt targeting themselves, if the target is a sabbatist, and if one of the name datums match the name input
		if(H.stat != DEAD && H != challenger && (findtext(H.real_name, challenged_name) || findtext(H.name, challenged_name)))
			target = H

	if(!target)
		to_chat(challenger, span_cult("Could not find anyone with that name to challenge!"))
		return


	// Notify the challenger
	to_chat(challenger, span_cult("You have challenged [target.real_name] to a duel of Monomacy! As the challenging Cainite, you determine the time and location of the duel, while your rival determines nearly all other factors. The Priest has the right to alter anything about the duel at any point - but the Priest who favors their own candidate is heavily looked down upon."))
	SEND_SOUND(challenger, sound('code/modules/wod13/sounds/announce.ogg'))

	// Notify the target
	to_chat(target, span_cult("[challenger.real_name] challenges you to a duel of Monomacy! Answer the call or lose favor. As the challenged Cainite, you have the right to determine when the duel ends, what weapons shall be used, whether or not disciplines are permitted, as well as any other factors such as both duelists wearing blindfolds. Your Priest has the right to modify these terms at any time, but the Priest who favors their own candidate is looked down upon."))
	SEND_SOUND(target, sound('code/modules/wod13/sounds/announce.ogg'))

	// Announce the challenge to everyone nearby
	for(var/mob/living/carbon/human/M in viewers(7, src))
		if(M != challenger && M != target)
			to_chat(M, span_cult("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy!"))
			SEND_SOUND(M, sound('code/modules/wod13/sounds/announce.ogg'))

	// Notify the priest
	for(var/mob/living/carbon/human/priest in GLOB.player_list)
		if(is_sabbat_priest(priest))
			to_chat(priest, span_cult("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy! Seek them out and ensure the duel is performed honorably. As Priest, you have the right to adjust any of the terms of the duel - you even have the right to declare a monomacy as null and void after the fact, but beware, the Priest who tips the scales in favor of their own candidate is heavily disfavored."))
			SEND_SOUND(priest, sound('code/modules/wod13/sounds/announce.ogg'))

	// Visual and audio effects for the rune itself
	animate(src, color = rgb(192, 192, 192), time = 2) // Flash to a brighter gray
	animate(color = rgb(64, 64, 64), time = 3) // Return to original color
	playsound(src, 'sound/magic/smoke.ogg', 20, TRUE)

	// Set cooldown
	COOLDOWN_START(src, MONOMACY_CHALLENGE_COOLDOWN, MONOMACY_COOLDOWN_DURATION)

	// Log the challenge
	log_game("[key_name(challenger)] has challenged [key_name(target)] to Monomacy via sabbatrune.")


/obj/sabbatrune/proc/reset_cooldown()
	COOLDOWN_RESET(src, MONOMACY_CHALLENGE_COOLDOWN)
