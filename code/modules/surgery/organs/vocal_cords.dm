#define COOLDOWN_STUN 1200
#define COOLDOWN_DAMAGE 600
#define COOLDOWN_MEME 300
#define COOLDOWN_NONE 100

/obj/item/organ/vocal_cords //organs that are activated through speech with the :x/MODE_KEY_VOCALCORDS channel
	name = "vocal cords"
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_VOICE
	gender = PLURAL
	decay_factor = 0	//we don't want decaying vocal cords to somehow matter or appear on scanners since they don't do anything damaged
	healing_factor = 0
	var/list/spans = null

/obj/item/organ/vocal_cords/proc/can_speak_with() //if there is any limitation to speaking with these cords
	return TRUE

/obj/item/organ/vocal_cords/proc/speak_with(message) //do what the organ does
	return

/obj/item/organ/vocal_cords/proc/handle_speech(message) //actually say the message
	owner.say(message, spans = spans, sanitize = FALSE)

/obj/item/organ/adamantine_resonator
	name = "adamantine resonator"
	desc = "Fragments of adamantine exist in all golems, stemming from their origins as purely magical constructs. These are used to \"hear\" messages from their leaders."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_ADAMANTINE_RESONATOR
	icon_state = "adamantine_resonator"

/obj/item/organ/vocal_cords/adamantine
	name = "adamantine vocal cords"
	desc = "When adamantine resonates, it causes all nearby pieces of adamantine to resonate as well. Adamantine golems use this to broadcast messages to nearby golems."
	actions_types = list(/datum/action/item_action/organ_action/use/adamantine_vocal_cords)
	icon_state = "adamantine_cords"

/datum/action/item_action/organ_action/use/adamantine_vocal_cords/Trigger()
	if(!IsAvailable())
		return
	var/message = input(owner, "Resonate a message to all nearby golems.", "Resonate")
	if(QDELETED(src) || QDELETED(owner) || !message)
		return
	owner.say(".x[message]")

/obj/item/organ/vocal_cords/adamantine/handle_speech(message)
	var/msg = "<span class='resonate'><span class='name'>[owner.real_name]</span> <span class='message'>resonates, \"[message]\"</span></span>"
	for(var/m in GLOB.player_list)
		if(iscarbon(m))
			var/mob/living/carbon/C = m
			if(C.getorganslot(ORGAN_SLOT_ADAMANTINE_RESONATOR))
				to_chat(C, msg)
		if(isobserver(m))
			var/link = FOLLOW_LINK(m, owner)
			to_chat(m, "[link] [msg]")

//Colossus drop, forces the listeners to obey certain commands
/obj/item/organ/vocal_cords/colossus
	name = "divine vocal cords"
	desc = "They carry the voice of an ancient god."
	icon_state = "voice_of_god"
	actions_types = list(/datum/action/item_action/organ_action/colossus)
	var/next_command = 0
	var/cooldown_mod = 1
	var/base_multiplier = 1
	spans = list("colossus","yell")

/datum/action/item_action/organ_action/colossus
	name = "Voice of God"
	var/obj/item/organ/vocal_cords/colossus/cords = null

/datum/action/item_action/organ_action/colossus/New()
	..()
	cords = target

/datum/action/item_action/organ_action/colossus/IsAvailable()
	if(world.time < cords.next_command)
		return FALSE
	if(!owner)
		return FALSE
	if(isliving(owner))
		var/mob/living/L = owner
		if(!L.can_speak_vocal())
			return FALSE
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			return FALSE
	return TRUE

/datum/action/item_action/organ_action/colossus/Trigger()
	. = ..()
	if(!IsAvailable())
		if(world.time < cords.next_command)
			to_chat(owner, "<span class='notice'>You must wait [DisplayTimeText(cords.next_command - world.time)] before Speaking again.</span>")
		return
	var/command = input(owner, "Speak with the Voice of God", "Command")
	if(QDELETED(src) || QDELETED(owner))
		return
	if(!command)
		return
	owner.say(".x[command]")

/obj/item/organ/vocal_cords/colossus/can_speak_with()
	if(world.time < next_command)
		to_chat(owner, "<span class='notice'>You must wait [DisplayTimeText(next_command - world.time)] before Speaking again.</span>")
		return FALSE
	if(!owner)
		return FALSE
	if(!owner.can_speak_vocal())
		to_chat(owner, "<span class='warning'>You are unable to speak!</span>")
		return FALSE
	return TRUE

/obj/item/organ/vocal_cords/colossus/handle_speech(message)
	playsound(get_turf(owner), 'sound/magic/clockwork/invoke_general.ogg', 80, TRUE, 5)
	return //voice of god speaks for us

/obj/item/organ/vocal_cords/colossus/speak_with(message)
	var/cooldown = voice_of_god(uppertext(message), owner, spans, base_multiplier)
	next_command = world.time + (cooldown * cooldown_mod)

//////////////////////////////////////
///////////VOICE OF GOD///////////////
//////////////////////////////////////

/proc/voice_of_god(message, mob/living/user, list/span_list, base_multiplier = 1, include_speaker = FALSE, message_admins = TRUE)
	var/cooldown = 0

	if(!user || !user.can_speak() || user.stat)
		return 0 //no cooldown

	//patch up an RCE exploit by sanitizing input
	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))

	var/log_message = uppertext(message)
	if(!span_list || !span_list.len)
		if(iscultist(user))
			span_list = list("narsiesmall")
		else
			span_list = list()

	user.say(message, spans = span_list, sanitize = FALSE)

	message = lowertext(message)
	var/list/mob/living/listeners = list()
	for(var/mob/living/L in get_hearers_in_view(8, user))
		if(L.can_hear() && !L.anti_magic_check(FALSE, TRUE) && L.stat != DEAD)
			var/dominate_me = FALSE
			var/conditioner

			if(L == user && !include_speaker)
				continue

			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				conditioner = H.conditioner?.resolve()
				if(H.clane?.name == "Gargoyle")
					dominate_me = TRUE
				if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
					continue

			if(user.generation > L.generation && !dominate_me)
				continue

			var/mypower = SSroll.storyteller_roll(user.get_total_social(), difficulty = 6, mobs_to_show_output = user, numerical = 1)
			var/theirpower = SSroll.storyteller_roll(L.get_total_mentality(), difficulty = 6, mobs_to_show_output = L, numerical = 1)

			if(conditioner && user != conditioner)
				theirpower += 3

			if(user != conditioner)
				if((theirpower >= mypower) && !dominate_me)
					to_chat(L, span_warning("Your ears ring with the undeniable authority of [user]'s voice. For a moment, you nearly obey… but your will breaks through the illusion."))
					continue

			if(L.resistant_to_disciplines)
				continue

			listeners += L

	if(!listeners.len)
		cooldown = COOLDOWN_NONE
		return cooldown

	var/power_multiplier = base_multiplier

	//not applicable to WoD13
	/*
	if(user.mind)
		//Chaplains are very good at speaking with the voice of god
		if(user.mind.assigned_role == "Chaplain")
			power_multiplier *= 2
		//Command staff has authority
		if(user.mind.assigned_role in GLOB.command_positions)
			power_multiplier *= 1.4
		//Why are you speaking
		if(user.mind.assigned_role == "Mime")
			power_multiplier *= 0.5


	//Cultists are closer to their gods and are more powerful, but they'll give themselves away
	if(iscultist(user))
		power_multiplier *= 2
	*/

	//Try to check if the speaker specified a name or a job to focus on
	var/list/specific_listeners = list()
	var/found_string = null

	//Get the proper job titles
	message = get_full_job_name(message)

	for(var/V in listeners)
		var/mob/living/L = V
		if(findtext(message, L.real_name, 1, length(L.real_name) + 1))
			specific_listeners += L //focus on those with the specified name
			//Cut out the name so it doesn't trigger commands
			found_string = L.real_name

		else if(findtext(message, L.first_name(), 1, length(L.first_name()) + 1))
			specific_listeners += L //focus on those with the specified name
			//Cut out the name so it doesn't trigger commands
			found_string = L.first_name()

		else if(L.mind && L.mind.assigned_role && findtext(message, L.mind.assigned_role, 1, length(L.mind.assigned_role) + 1))
			specific_listeners += L //focus on those with the specified job
			//Cut out the job so it doesn't trigger commands
			found_string = L.mind.assigned_role

	if(specific_listeners.len)
		listeners = specific_listeners
		power_multiplier *= (1 + (1/specific_listeners.len)) //2x on a single guy, 1.5x on two and so on
		message = copytext(message, length(found_string) + 1)

	for(var/affected in listeners)
		if(ishuman(affected))
			var/mob/living/carbon/human/dominate_target = affected
			dominate_target.remove_overlay(MUTATIONS_LAYER)
			var/mutable_appearance/dominate_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dominate", -MUTATIONS_LAYER)
			dominate_overlay.pixel_z = 2
			dominate_target.overlays_standing[MUTATIONS_LAYER] = dominate_overlay
			dominate_target.apply_overlay(MUTATIONS_LAYER)
			addtimer(CALLBACK(dominate_target, TYPE_PROC_REF(/mob/living/carbon/human, post_dominate_checks), dominate_target), 2 SECONDS)

	cooldown = apply_voice_of_god_effects(message, user, listeners, power_multiplier)


	if(message_admins)
		message_admins("[ADMIN_LOOKUPFLW(user)] has said '[log_message]' with a Voice of God, affecting [english_list(listeners)], with a power multiplier of [power_multiplier].")
	log_game("[key_name(user)] has said '[log_message]' with a Voice of God, affecting [english_list(listeners)], with a power multiplier of [power_multiplier].")
	SSblackbox.record_feedback("tally", "voice_of_god", 1, log_message)

	return cooldown
