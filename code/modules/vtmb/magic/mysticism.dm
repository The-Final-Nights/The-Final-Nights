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

/datum/crafting_recipe/mystome
	name = "Abyss Mysticism Tome"
	time = 10 SECONDS
	reqs = list(/obj/item/paper = 3, /obj/item/reagent_containers/blood = 1)
	result = /obj/item/mystic_tome
	always_available = FALSE
	category = CAT_MISC

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
	var/cost = 0

/datum/action/mysticism
	name = "Mysticism"
	desc = "Abyss Mysticism rune drawing."
	button_icon_state = "mysticism"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/drawing = FALSE
	var/level = 1

/datum/action/mysticism/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(drawing)
		return

	var/list/rituals = list()
	for(var/i in subtypesof(/obj/abyssrune))
		var/obj/abyssrune/R = new i(owner)
		if(R.mystlevel <= level)
			rituals[R.name] = list("name" = i, "cost" = R.cost)
		qdel(R)

	var/ritual

	if(istype(H.get_active_held_item(), /obj/item/mystic_tome))
		ritual = tgui_input_list(owner, "Choose rune to draw:", "Mysticism", rituals, null)
	else
		ritual = tgui_input_list(owner, "Choose rune to draw (You need a Mystic Tome to reduce random):", "Mysticism", list("???"))
		if(ritual)
			ritual = pick(rituals)

	if(!ritual)
		return

	var/rtype = rituals[ritual]
	var/rname = rtype["name"]
	var/rcost = rtype["cost"]

	if(H.bloodpool >= rcost)
		drawing = TRUE
		if(do_after(H, 3 SECONDS * max(1, 5 - H.st_get_stat(STAT_OCCULT)), H))
			drawing = FALSE
			new rname(H.loc)
			H.bloodpool = max(H.bloodpool - rcost, 0)
			SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)
	else
		to_chat(H, span_warning("You need more <b>BLOOD</b> to do that!"))
		drawing = FALSE
		return

	drawing = FALSE

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

// **************************************************************** SELFGIB *************************************************************
/obj/abyssrune/selfgib
	name = "Self Destruction"
	desc = "Meet the Final Death."
	icon_state = "rune2"
	word = "YNT FRM MCHGN FYNV DN THS B'FO"
	cost = 1

/obj/abyssrune/selfgib/complete()
	last_activator.death()

// **************************************************************** HEART THAT BEATS IN SILENCE *************************************************************
/obj/abyssrune/heart_that_beats_in_silence
	name = "The Heart That Beats in Silence"
	desc = "Creates a shadowy abomination to protect the Lasombra and his domain."
	icon_state = "rune1"
	word = "ANI UMRA"
	mystlevel = 2
	cost = 1

/obj/abyssrune/heart_that_beats_in_silence/complete()
	var/mob/living/carbon/human/H = last_activator
	var/dice = (last_activator.st_get_stat(STAT_INTELLIGENCE) + last_activator.st_get_stat(STAT_OCCULT))

	var/roll = SSroll.storyteller_roll(dice, 6, FALSE, last_activator)
	last_activator.apply_damage(30, CLONE)

	if(roll == ROLL_SUCCESS)
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
		if(length(H.beastmaster) > H.st_get_stat(STAT_OCCULT))
			var/mob/living/simple_animal/hostile/beastmaster/B = pick(H.beastmaster)
			B.death()
		qdel(src)

	else if(roll == ROLL_FAILURE)
		qdel(src)

	else if(roll == ROLL_BOTCH)
		to_chat(last_activator, span_warning("You lose control over the ritual!"))
		last_activator.apply_damage(30, CLONE)
		qdel(src)

/mob/living/simple_animal/hostile/beastmaster/shadow_guard
	name = "Heart of Silence"
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
	maxHealth = 150 // 5 Willpower, Health Levels = Willpower, 5*30 = 150
	health = 150

	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 40 // Heart of Silence creatures can use Arms of Ahriman for free; strength + 1 brute damage, strength = 2 (they should have more functionality)
	melee_damage_upper = 40
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

// **************************************************************** IDENTIFICATION *************************************************************
/obj/abyssrune/identification
	name = "Occult Items Identification"
	desc = "Identifies a single occult item"
	icon_state = "rune4"
	word = "WUS'ZAT"
	cost = 1

/obj/abyssrune/identification/complete()
	for(var/obj/item/vtm_artifact/VA in loc)
		if(VA)
			VA.identificate()
			playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE)
			qdel(src)
			return

// **************************************************************** BLACKOUT *************************************************************
/obj/abyssrune/blackout //not canon wod material, seemed a cool idea.
	name = "Blackout"
	desc = "Destroys every wall light in range of the rune."
	icon_state = "rune7"
	word = "FYU'SES BLO'OUN"
	mystlevel = 2
	cost = 1

//actual function of the rune
/obj/abyssrune/blackout/complete()
	for(var/obj/machinery/light/light_to_kill in range(7, src)) //for every light in a range of 7 (called i)
		if(light_to_kill != LIGHT_BROKEN) //if it aint broke
			light_to_kill.break_light_tube(0) //break it
	playsound(get_turf(src), 'sound/magic/voidblink.ogg', 50, FALSE) //make the funny void sound
	qdel(src) //delete the rune

// **************************************************************** COMFORTING DARKNESS *************************************************************
/obj/abyssrune/comforting_darkness
	name = "Comforting Darkness"
	desc = "Use the power of the abyss to mend the wounds of yourself and others."
	icon_state = "rune8"
	word = "KEYUR'AGA"
	mystlevel = 2
	cost = 0

/obj/abyssrune/comforting_darkness
	name = "Comforting Darkness"
	desc = "Use the power of the abyss to mend the wounds of yourself and others."
	icon_state = "rune8"
	word = ""
	mystlevel = 2
	cost = 0
	var/static/list/roll_cache = list()

/obj/abyssrune/comforting_darkness/complete()
	var/list/heal_targets = list()
	var/turf/rune_location = get_turf(src)
	var/mob/living/carbon/human/invoker = last_activator
	var/dice = (invoker.st_get_stat(STAT_STAMINA) + invoker.st_get_stat(STAT_OCCULT))
	var/ckey = invoker.ckey

	// Can't use the ritual again until the debt is paid
	if(invoker.has_status_effect(/datum/status_effect/blood_debt))
		to_chat(invoker, span_notice("The Abyss demands payment before you can draw on its power again!"))
		return

	for(var/mob/living/carbon/human/target in rune_location)
		if(iskindred(target))
			heal_targets |= target

	heal_targets |= invoker

	var/roll
	var/spent_points
	var/list/bpoptions = list()

	// Prevents the player from rerolling for free; initial roll is stored until the ritual is invoked
	if(ckey in roll_cache)
		roll = roll_cache[ckey]
	else
		roll = SSroll.storyteller_roll(dice, 8, TRUE, invoker)
		roll_cache[ckey] = roll

	if(roll >= 1)
		for(var/i in 1 to roll)
			if(i <= invoker.bloodpool)
				bpoptions += i
		spent_points = tgui_input_list(invoker, "How many blood points would you like to spend? (60 healing per)", "Blood Points", bpoptions, null)
		if(!spent_points)
			return
		invoker.bloodpool = max(invoker.bloodpool - spent_points, 0)
		invoker.apply_status_effect(/datum/status_effect/blood_debt, 2 * spent_points) // Apply debuff with debt amount
		for(var/mob/living/carbon/human/target in heal_targets)
			target.heal_ordered_damage(60 * spent_points, list(BRUTE, TOX, OXY, STAMINA)) // Heals 2 levels of lethal/bashing per point spent
			target.heal_ordered_damage(30 * spent_points, list(BURN, CLONE)) // Heals aggravated at half effectiveness, TTRPG-inaccurate implementation but necessary

	else if(roll == 0)
		invoker.bloodpool = max(invoker.bloodpool - 1, 0)
		qdel(src)

	else if(roll <= -1)
		to_chat(invoker, span_warning("You lose focus, failing to control the darkness as it burns you!"))
		invoker.bloodpool = max(invoker.bloodpool - 1, 0)
		invoker.apply_damage(30, CLONE)
		qdel(src)

	playsound(rune_location, 'sound/magic/voidblink.ogg', 50, FALSE)
	invoker.say("SANA'OSCURA") // Spanish for something along the lines of 'healing dark', spoken upon actual invocation of the rune.

	roll_cache -= ckey
	qdel(src)

// **************************************************************** REFLECTIONS OF HOLLOW REVELATION *************************************************************
/obj/abyssrune/reflections_of_hollow_revelation
	name = "Reflections of Hollow Revelation"
	desc = "Use a conjured Nocturne to spy on a target through nearby shadows"
	icon_state = "teleport"
	word = ""
	mystlevel = 4
	cost = 1
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

	var/mypower = (user.st_get_stat(STAT_PERCEPTION) + user.st_get_stat(STAT_OCCULT))
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
		for(var/datum/st_stat/stat as anything in subtypesof(/datum/st_stat))
			user.st_add_stat_mod(stat, -2, "reflections_of_hollow_revelation")
		addtimer(CALLBACK(src, PROC_REF(restore_stats), user), 1 SCENES)

/obj/abyssrune/reflections_of_hollow_revelation/proc/restore_stats(mob/living/user)
	for(var/datum/st_stat/stat as anything in subtypesof(/datum/st_stat))
		user.st_remove_stat_mod(stat, "reflections_of_hollow_revelation")

/obj/abyssrune/reflections_of_hollow_revelation/proc/scry_target(mob/living/carbon/human/target, mob/living/user)
	// If the target has Obtenebration or Auspex, roll to see if they detect the shadows
	if(iskindred(target))
		var/datum/species/kindred/vampire = target.dna?.species
		if(vampire && (vampire.get_discipline("Obtenebration") || vampire.get_discipline("Auspex")))
			var/theirpower = (user.st_get_stat(STAT_PERCEPTION) + user.st_get_stat(STAT_OCCULT))
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
