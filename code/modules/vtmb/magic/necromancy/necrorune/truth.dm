// **************************************************************** CALL UPON THE SHADOW'S GRACE *************************************************************

/obj/necrorune/truth
	name = "Call upon the Shadow's Grace"
	desc = "Bring forth the shadows in your victim's mind and force out their darkest truths."
	icon_state = "rune8"
	word = "MIKHH' AHPP"
	necrolevel = 3

/obj/necrorune/truth/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("You cannot invoke this ritual upon yourself."))
			return
		if(targetbody.stat == DEAD)
			to_chat(usr, span_warning("The target is dead, and has taken its secrets to the grave!"))
			return
		else
			valid_bodies += targetbody

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("The ritual's victim must remain over the rune."))
		return

	var/mob/living/carbon/victim = pick(valid_bodies)
	playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)

	to_chat(usr, span_ghostalert("You sic [victim.name]'s shadow on [victim.p_them()]; [victim.p_they()] cannot lie to you now."))

	playsound(victim,'sound/hallucinations/veryfar_noise.ogg',50,TRUE)
	playsound(victim,'sound/spookoween/ghost_whisper.ogg',50,TRUE)

	victim.emote("scream")
	victim.AdjustKnockdown(2 SECONDS)
	victim.do_jitter_animation(3 SECONDS)

	to_chat(victim, span_revenboldnotice("Your mouth snaps open, and whatever air you take in can't seem to stay."))
	to_chat(victim, span_revenboldnotice("All the dark secrets you harbor come spilling out before you can even recall them."))
	to_chat(victim, span_hypnophrase("YOU CANNOT LIE."))

	visible_message(span_danger("[victim.name]'s shadow thrashes underneath [victim.p_them()], as if a separate being!"))
	addtimer(CALLBACK(victim, TYPE_PROC_REF(/datum/necrorune/truth, wearoff), victim), 2 MINUTES)
	qdel(src)

/datum/necrorune/truth/proc/wearoff(mob/living/carbon/victim)
	if(!victim)
		return
	to_chat(victim, span_notice("The grip on your soul relents, you feel in control over your secrets."))
