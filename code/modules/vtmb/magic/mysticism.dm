/obj/item/mystic_tome
	name = "mystic tome"
	desc = "The secrets of Abyss Mysticism..."
	icon_state = "mystic"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/list/rituals = list()

/obj/item/mystic_tome/Initialize()
	. = ..()
	for(var/i in subtypesof(/obj/abyssrune))
		if(i)
			var/obj/abyssrune/R = new i(src)
			rituals |= R

/obj/item/mystic_tome/attack_self(mob/user)
	. = ..()
	for(var/obj/abyssrune/R in rituals)
		if(R)
			if(R.sacrifice)
				var/obj/item/I = new R.sacrifice(src)
				to_chat(user, "[R.mystlevel] [R.name] - [R.desc] Requirements: [I].")
				qdel(I)
			else
				to_chat(user, "[R.mystlevel] [R.name] - [R.desc]")

/obj/abyssrune
	name = "Lasombra Rune"
	desc = "Learn the secrets of the Abyss, neonate..."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rune1"
	color = rgb(0,0,0)
	anchored = TRUE
	var/word = "IDI NAH"
	var/activator_bonus = 0
	var/activated = FALSE
	var/mob/living/last_activator
	var/mystlevel = 1
	var/sacrifice

/obj/abyssrune/proc/complete()
	return

/obj/abyssrune/attack_hand(mob/user)
	if(!activated)
		var/mob/living/L = user
		if(L.mysticism_knowledge)
			L.say("[word]")
			L.Immobilize(30)
			last_activator = user
			activator_bonus = L.thaum_damage_plus
			if(sacrifice)
				for(var/obj/item/I in get_turf(src))
					if(I)
						if(istype(I, sacrifice))
							qdel(I)
							complete()
			else
				complete()

/obj/abyssrune/AltClick(mob/user)
	..()
	qdel(src)

/obj/abyssrune/selfgib
	name = "Self Destruction"
	desc = "Meet the Final Death."
	icon_state = "rune2"
	word = "YNT FRM MCHGN FYNV DN THS B'FO"

/obj/abyssrune/selfgib/complete()
	last_activator.death()

/obj/abyssrune/silent_heart
	name = "Silently-Beating Heart"
	desc = "Creates a shadowy abomination to protect the Lasombra and his domain."
	icon_state = "rune1"
	word = "ANI UMRA"
	mystlevel = 3

/obj/abyssrune/silent_heart/complete()
	var/mob/living/carbon/human/H = last_activator
	if(!length(H.beastmaster))
		var/datum/action/beastmaster_stay/E1 = new()
		E1.Grant(last_activator)
		var/datum/action/beastmaster_deaggro/E2 = new()
		E2.Grant(last_activator)
	var/mob/living/simple_animal/hostile/beastmaster/shadow_guard/BG = new(loc)
	BG.beastmaster_owner = last_activator
	H.beastmaster |= BG
	BG.my_creator = last_activator
	BG.melee_damage_lower = BG.melee_damage_lower+activator_bonus
	BG.melee_damage_upper = BG.melee_damage_upper+activator_bonus
	playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	if(length(H.beastmaster) > 3+H.mentality)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(H.beastmaster)
		B.death()
	qdel(src)

/mob/living/simple_animal/hostile/beastmaster/shadow_guard
	name = "shadow abomination"
	desc = "A shadow given life, creature of fathomless..."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "shadow2"
	icon_living = "shadow2"
	del_on_death = 1
	healable = 0
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	speed = 0
	maxHealth = 150
	health = 150

	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "gouges"
	attack_verb_simple = "gouge"
	attack_sound = 'sound/creatures/venus_trap_hit.ogg'
	speak_emote = list("gnashes")

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list(CLAN_LASOMBRA)
	bloodpool = 1
	maxbloodpool = 1

/obj/abyssrune/identification
	name = "Occult Items Identification"
	desc = "Identifies a single occult item"
	icon_state = "rune4"
	word = "WUS'ZAT"

/obj/abyssrune/identification/complete()
	for(var/obj/item/vtm_artifact/VA in loc)
		if(VA)
			VA.identificate()
			playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE)
			qdel(src)
			return

/obj/abyssrune/blackout //not canon wod material, seemed a cool idea.
	name = "Blackout"
	desc = "Destroys every wall light in range of the rune."
	icon_state = "rune7"
	word = "FYU'SES BLO'OUN"
	mystlevel = 2

//actual function of the rune
/obj/abyssrune/blackout/complete()
	for(var/obj/machinery/light/light_to_kill in range(7, src)) //for every light in a range of 7 (called i)
		if(light_to_kill != LIGHT_BROKEN) //if it aint broke
			light_to_kill.break_light_tube(0) //break it
	playsound(get_turf(src), 'sound/magic/voidblink.ogg', 50, FALSE) //make the funny void sound
	qdel(src) //delete the rune

/obj/abyssrune/comforting_darkness
	name = "Comforting Darkness"
	desc = "Use the power of the abyss to mend the wounds of yourself and others."
	icon_state = "rune8"
	word = "KEYUR'AGA"
	mystlevel = 3

/obj/abyssrune/comforting_darkness/complete()
	var/list/heal_targets = list()
	var/turf/rune_location = get_turf(src)
	var/mob/living/carbon/human/invoker = last_activator

	if(TIMER_COOLDOWN_CHECK(invoker, COOLDOWN_RITUAL_INVOKE))
		to_chat(invoker, span_notice("The abyssal energies in the area must settle first!"))
		return

	for(var/mob/living/carbon/human/target in rune_location) //for every living mob in the same space as the rune
		if(iskindred(target))
			heal_targets |= target

	// Include the invoker in the heal whether they were on the rune or not
	heal_targets |= invoker

	for(var/mob/living/carbon/human/target in heal_targets)
		target.heal_ordered_damage(90, list(BRUTE, TOX, OXY, STAMINA))
		target.heal_ordered_damage(30, list(BURN, CLONE))

	TIMER_COOLDOWN_START(invoker, COOLDOWN_RITUAL_INVOKE, 30 SECONDS)
	playsound(rune_location, 'sound/magic/voidblink.ogg', 50, FALSE)
	qdel(src)

/obj/abyssrune/reflections_of_hollow_revelation
	name = "Reflections of Hollow Revelation"
	desc = "Use a conjured Nocturne to spy on a target through nearby shadows"
	icon_state = "teleport"
	word = ""
	mystlevel = 4
	var/datum/action/close_window/end_action
	var/mob/living/nocturne_user
	var/obj/shadow_window/shadow_window
	var/mob/living/carbon/human/window_target
	var/isactive = FALSE

/obj/abyssrune/reflections_of_hollow_revelation/complete()
	var/mob/living/user = usr
	if(!user)
		return

	if(isactive)
		to_chat(user, span_warning("This Nocturne is already in use!"))
		return

	// Target input
	var/target_name = tgui_input_text(user, "Choose target name:", "Reflections of Hollow Revelation")
	if(!target_name || !user.Adjacent(src))
		to_chat(user, span_warning("You must specify a target and remain close to the rune!"))
		return

	user.say("VISTA'DE'SOMBRA")

	// Find the target
	for(var/mob/living/carbon/human/targ in GLOB.player_list)
		if(targ.real_name == target_name)
			window_target = targ
			break

	if(!window_target)
		to_chat(user, span_warning("[target_name] not found."))
		return

	// Roll for success; Mentality + Social in place of Perception + Occult
	var/mypower = (user.get_total_mentality() + user.get_total_social())
	var/roll_result = SSroll.storyteller_roll(mypower, 7, FALSE, user)
	if (roll_result == ROLL_SUCCESS)
		scry_target(window_target, user)
		playsound(user, 'sound/magic/voidblink.ogg', 50, FALSE)
		isactive = TRUE
	else if(roll_result == ROLL_FAILURE)
		qdel(src)
		to_chat(user, span_warning("The Nocturne collapses!"))
	else if(roll_result == ROLL_BOTCH)
		qdel(src)
		to_chat(user, span_warning("You feel drained..."))
		user.additional_athletics -= 2
		user.additional_blood -= 2
		user.additional_dexterity -= 2
		user.additional_lockpicking -= 2
		user.additional_mentality -= 2
		user.additional_social -=2
		addtimer(CALLBACK(src, PROC_REF(restore_stats), user), 1 SCENES)

/obj/abyssrune/reflections_of_hollow_revelation/proc/restore_stats(mob/living/user)
	if(user)
		user.additional_athletics += 2
		user.additional_blood += 2
		user.additional_dexterity += 2
		user.additional_lockpicking += 2
		user.additional_mentality += 2
		user.additional_social +=2

/obj/abyssrune/reflections_of_hollow_revelation/proc/scry_target(mob/living/carbon/human/target, mob/user)
	// If the target has Obtenebration or Auspex, roll to see if they detect the shadows
	if(iskindred(target))
		var/datum/species/kindred/vampire = target.dna?.species
		if(vampire && (vampire.get_discipline("Obtenebration") || vampire.get_discipline("Auspex")))
			var/theirpower = (target.get_total_mentality() + target.get_total_social()) // Mentality + Social in place of Perception + Occult
			if(SSroll.storyteller_roll(theirpower, 8, FALSE) == ROLL_SUCCESS)
				to_chat(target, span_warning("You notice the nearby shadows flicker... something is watching you."))

	shadowview(target, user)
	to_chat(user, span_notice("You peer through the shadows near [target.name]..."))

	RegisterSignal(user, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_end))
	addtimer(CALLBACK(src, PROC_REF(on_end),user), 1 SCENES) // 3 minute timer, AKA 1 Scene

/obj/abyssrune/reflections_of_hollow_revelation/proc/shadowview(mob/living/target, mob/user)
	nocturne_user = user
	user.notransform = TRUE

	// Create camera
	shadow_window = new(get_turf(target), src)
	user.reset_perspective(shadow_window)

	// Give button to end viewing
	end_action = new(src)
	end_action.Grant(user)

	RegisterSignal(user, COMSIG_MOB_RESET_PERSPECTIVE, PROC_REF(on_end))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(check_target_distance))

	to_chat(user, span_notice("You are now viewing through the shadows. Use the 'End Scrying' action to stop."))

/obj/abyssrune/reflections_of_hollow_revelation/proc/check_target_distance()
	SIGNAL_HANDLER
	if(!window_target || !shadow_window)
		return

	// Window closes when target leaves range
	if(get_dist(window_target, shadow_window) > 7)
		if(nocturne_user)
			to_chat(nocturne_user, span_warning("The window closes as [window_target.name] moves away from the shadows."))
		on_end(nocturne_user)

/obj/abyssrune/reflections_of_hollow_revelation/proc/on_end(mob/user)
	SIGNAL_HANDLER
	if(user == nocturne_user)
		close_window(user)

/obj/abyssrune/reflections_of_hollow_revelation/proc/close_window(mob/user)
	if(!user)
		return

	user.notransform = FALSE

	if(user.client?.eye != user)
		user.reset_perspective()

	if(end_action)
		end_action.Remove(user)
		QDEL_NULL(end_action)

	if(window_target)
		UnregisterSignal(window_target, COMSIG_MOVABLE_MOVED)

	QDEL_NULL(shadow_window)
	qdel(src)
	UnregisterSignal(user, COMSIG_MOB_RESET_PERSPECTIVE)

	nocturne_user = null
	to_chat(user, span_notice("You stop viewing through your summoned Nocturne."))
	playsound(user, 'sound/magic/ethereal_exit.ogg', 50, FALSE)

// Camera object
/obj/shadow_window
	name = "Shadow"
	desc = "A shadow..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shadow"
	invisibility = INVISIBILITY_ABSTRACT
	layer = CAMERA_STATIC_LAYER
	var/obj/abyssrune/reflections_of_hollow_revelation/parent_rune

/obj/shadow_window/Initialize(mapload, obj/abyssrune/reflections_of_hollow_revelation/rune)
	. = ..()
	parent_rune = rune

/obj/shadow_window/Destroy()
	if(parent_rune && parent_rune.shadow_window == src)
		parent_rune.shadow_window = null
	parent_rune = null
	return ..()

// Action button
/datum/action/close_window
	name = "End Scrying"
	desc = "Stop viewing through the shadows"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"
	var/obj/abyssrune/reflections_of_hollow_revelation/parent_rune

/datum/action/close_window/New(obj/abyssrune/reflections_of_hollow_revelation/rune)
	..()
	parent_rune = rune

/datum/action/close_window/Trigger(trigger_flags)
	if(!parent_rune || !usr)
		return
	parent_rune.close_window(usr)

/datum/action/close_window/Remove(mob/user)
	if(parent_rune && parent_rune.end_action == src)
		parent_rune.end_action = null
	parent_rune = null
	. = ..()
	qdel(src)
