// **************************************************************** INSIGHT *************************************************************

/obj/necrorune/insight
	name = "Insight"
	desc = "Determine a cadaver's passing by questioning its soul."
	icon_state = "rune6"
	word = "IH'DET ULYSS RES'SAR"
	necrolevel = 2

/obj/necrorune/insight/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("You cannot invoke this ritual upon yourself."))
			return
		else if(targetbody.stat == DEAD)
			valid_bodies += targetbody
		else
			to_chat(usr, span_warning("The target lives still! Ask them yourself!"))
			return

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("There is no body that can undergo this Ritual."))
		return

	playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)

	var/mob/living/carbon/victim = pick(valid_bodies)

	var/mob/dead/observer/victim_ghost = victim.last_mind

	var/permission = null

	if(isnpc(victim))
		to_chat(last_activator, span_notice("[victim.name] is a waning, base Drone. There is no greater knowledge to gleam from this one."))
		to_chat(last_activator, span_notice("<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]"))
		to_chat(last_activator, span_notice("Last melee attacker: [victim.lastattacker]"))
		qdel(src)
		return

	if(victim_ghost)
		permission = tgui_input_list(victim_ghost, "[last_activator.real_name] wishes to know of your passing. Will you give answers?", "Select", list("Yes","No","I don't recall"), "No", 1 MINUTES)

	if(permission == "Yes" && victim_ghost)
		to_chat(last_activator, span_ghostalert("[victim.name]'s haunting whispers flood your mind..."))
		var/deathdesc = tgui_input_text(victim_ghost, "", "How did you die?", "", 300, TRUE, TRUE, 5 MINUTES)
		if(deathdesc == "")
			to_chat(last_activator, span_warning("The Shroud is too thick, their whispers too raving to gleam anything useful."))
		else
			to_chat(last_activator, span_ghostalert("<i>[deathdesc]</i>"))
			//discount scanner
			to_chat(last_activator, span_notice("<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]"))
			to_chat(last_activator, span_notice("Last melee attacker: [victim.lastattacker]")) //guns behave weirdly
			qdel(src)

	else if(permission == "No")
		to_chat(last_activator, span_danger("The wraith turns from you. It will not surrender its secrets."))
