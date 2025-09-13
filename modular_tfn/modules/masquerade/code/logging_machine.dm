#define MAX_PAGE_LINES 20

/obj/machinery/logging_machine
	name = "surveillance machine"
	desc = "It seems to be a contraption of sorts that stores a variety of logs. It seems to be connected to the city's mobile phone antenna."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "relay"
	density = TRUE
	var/list/saved_logs
	var/datum/looping_sound/logging_machine/clearing_sound
	COOLDOWN_DECLARE(printing_noise)

/obj/machinery/logging_machine/Initialize()
	. = ..()
	saved_logs = new()
	clearing_sound = new(list(src))
	GLOB.logging_machines += src

/obj/machinery/logging_machine/Destroy()
	GLOB.logging_machines -= src
	QDEL_NULL(clearing_sound)
	saved_logs = null
	..()

/obj/machinery/logging_machine/examine(mob/user)
	. = ..()
	. += span_info(span_bold("Click")) + span_info(" on [src] to print all obtained logs.")
	if(issupernatural(user))
		. += span_info(span_bold("Right Click")) + span_info(" on [src] to clear all obtained logs and clear all phone call breaches.")

/obj/machinery/logging_machine/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(!length(saved_logs))
		balloon_alert_to_viewers("no logs!")
		return
	balloon_alert_to_viewers("clearing logs!")
	do_log_clearing(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/logging_machine/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!length(saved_logs))
		balloon_alert_to_viewers("no logs!")
		return
	balloon_alert_to_viewers("printing logs!")
	do_log_printing(user)

/obj/machinery/logging_machine/proc/do_log_printing(mob/user)
	var/list/log_save_cache = list()
	log_save_cache += saved_logs
	var/pages_to_print = length(log_save_cache) / MAX_PAGE_LINES
	for(var/page in 1 to ceil(pages_to_print))
		if(!do_after(user, 0.5 SECONDS, src))
			break
		var/obj/item/paper/printed_paper = new /obj/item/paper(get_turf(src))

		var/list/page_text = list()
		for(var/page_line in 1 to min(MAX_PAGE_LINES, length(log_save_cache)))
			var/text = log_save_cache[1][1]
			page_text += text
			page_text += "<br>"
			log_save_cache -= list(log_save_cache[1])

		printed_paper.add_raw_text(page_text.Join()) //Print the oldest logs first.
		printed_paper.update_appearance()
		if(!COOLDOWN_FINISHED(src, printing_noise))
			continue
		playsound(src, 'sound/machines/printer.ogg', 50, TRUE)
		COOLDOWN_START(src, printing_noise, 5 SECONDS)

/obj/machinery/logging_machine/proc/do_log_clearing(mob/user)
	clearing_sound.start()
	if(!do_after(user, 7 SECONDS, src))
		addtimer(CALLBACK(src, PROC_REF(stop_sound)), 7 SECONDS)
		return
	for(var/paper in 1 to length(saved_logs))
		if(!do_after(user, 0.5 SECONDS, src))
			stop_sound()
			break
		var/obj/phone = saved_logs[1][2]
		SEND_SIGNAL(phone, COMSIG_ALL_MASQUERADE_REINFORCE)
		saved_logs -= list(saved_logs[1]) //Clear the oldest logs first.
	stop_sound()

/obj/machinery/logging_machine/proc/stop_sound()
	clearing_sound.stop()

#undef MAX_PAGE_LINES
