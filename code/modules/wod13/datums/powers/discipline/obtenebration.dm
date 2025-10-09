/datum/discipline/obtenebration
	name = "Obtenebration"
	desc = "Controls the darkness around you."
	icon_state = "obtenebration"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/obtenebration

/datum/discipline_power/obtenebration
	name = "Obtenebration power name"
	desc = "Obtenebration power description"

	effect_sound = 'sound/magic/voidblink.ogg'

//SHADOW PLAY
/datum/discipline_power/obtenebration/shadow_play
	name = "Shadow Play"
	desc = "Manipulate shadows to block visibility."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_TURF | TARGET_MOB | TARGET_OBJ | TARGET_SELF
	range = 7
	vitae_cost = 1

	multi_activate = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 5 SECONDS

	var/atom/movable/shadow

/datum/discipline_power/obtenebration/shadow_play/activate(target)
	. = ..()
	shadow = new(target)
	shadow.set_light(discipline.level+2, -10)

/datum/discipline_power/obtenebration/shadow_play/deactivate(target)
	. = ..()
	if (shadow)
		QDEL_NULL(shadow)

//SHROUD OF NIGHT
/datum/discipline_power/obtenebration/shroud_of_night
	name = "Shroud of Night"
	desc = "Turn the shadows into appendages to pull your enemies."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 7

	aggravating = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/obtenebration/shroud_of_night/pre_activation_checks(atom/target)
	if(SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_OCCULT), 7, FALSE, owner))
		return TRUE
	return FALSE

/datum/discipline_power/obtenebration/shroud_of_night/activate(mob/living/target)
	. = ..()
	target.Stun(1 SECONDS)
	var/obj/item/ammo_casing/magic/tentacle/lasombra/casing = new (owner.loc)
	casing.fire_casing(target, owner, null, null, null, ran_zone(), 0,  owner)

//ARMS OF THE ABYSS
/datum/discipline_power/obtenebration/arms_of_the_abyss
	name = "Arms of the Abyss"
	desc = "Use shadows as your arms to harm and grab others from afar."

	level = 3
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 1
	violates_masquerade = TRUE

	toggled = TRUE
	duration_length = 6 TURNS


/datum/discipline_power/obtenebration/arms_of_the_abyss/pre_activation_checks(atom/target)
	if(SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_OCCULT), 7, FALSE, owner))
		return TRUE
	return FALSE

/datum/discipline_power/obtenebration/arms_of_the_abyss/activate()
	. = ..()
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))
	owner.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))

/datum/discipline_power/obtenebration/arms_of_the_abyss/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/knife/gangrel/lasombra/arm in owner.contents)
		qdel(arm)

//BLACK METAMORPHOSIS
/datum/discipline_power/obtenebration/black_metamorphosis
	name = "Black Metamorphosis"
	desc = "Fuse with your inner darkness, gaining shadowy armor."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 2

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/obtenebration/black_metamorphosis/pre_activation_checks(atom/target)
	if(SSroll.storyteller_roll(owner.st_get_stat(STAT_MANIPULATION) + owner.st_get_stat(STAT_COURAGE), 7, FALSE, owner))
		return TRUE
	return FALSE

/datum/discipline_power/obtenebration/black_metamorphosis/activate()
	. = ..()
	owner.physiology.damage_resistance += 60
	animate(owner, color = "#000000", time = 1 SECONDS, loop = 1)

/datum/discipline_power/obtenebration/black_metamorphosis/deactivate()
	. = ..()
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	owner.physiology.damage_resistance -= 60
	animate(owner, color = initial(owner.color), time = 1 SECONDS, loop = 1)

//TENEBROUS FORM
/datum/discipline_power/obtenebration/tenebrous_form
	name = "Tenebrous Form"
	desc = "Become a shadow and resist all but fire, sunlight, and magic!"

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	vitae_cost = 3
	duration_length = 1 TURNS
	toggled = TRUE

	violates_masquerade = TRUE

	cooldown_length = 20 SECONDS
	var/saved_brute_mod = 1
	var/saved_clone_mod = 1
	var/saved_stamina_mod = 1
	var/saved_brain_mod = 1

/datum/discipline_power/obtenebration/tenebrous_form/activate()
	. = ..()
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	saved_brute_mod = owner.physiology.brute_mod
	owner.physiology.brute_mod = 0
	saved_clone_mod = owner.physiology.clone_mod
	owner.physiology.clone_mod = 0
	saved_stamina_mod = owner.physiology.stamina_mod
	owner.physiology.stamina_mod = 0
	saved_brain_mod = owner.physiology.brain_mod
	owner.physiology.brain_mod = 0
	animate(owner, color = "#000000", time = 1 SECONDS, loop = 1)

	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, MAGIC_TRAIT)
	for(var/obj/stuff in owner.contents)
		ADD_TRAIT(stuff, TRAIT_NODROP, MAGIC)

/datum/discipline_power/obtenebration/tenebrous_form/deactivate()
	. = ..()
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	owner.physiology.brute_mod = saved_brute_mod
	owner.physiology.clone_mod = saved_brute_mod
	owner.physiology.stamina_mod = saved_brute_mod
	owner.physiology.brain_mod = saved_brute_mod
	animate(owner, color = initial(owner.color), time = 1 SECONDS, loop = 1)

	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, MAGIC_TRAIT)
	for(var/obj/item/stuff in owner.contents)
		REMOVE_TRAIT(stuff, TRAIT_NODROP, MAGIC)

/datum/discipline_power/obtenebration/tenebrous_form/post_gain()
	. = ..()
	var/datum/action/mysticism/mystic = new()
	owner.mysticism_knowledge = TRUE
	mystic.Grant(owner)
	mystic.level = level
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/mystome)

/datum/crafting_recipe/mystome
	name = "Abyss Mysticism Tome"
	time = 10 SECONDS
	reqs = list(/obj/item/paper = 3, /obj/item/reagent_containers/blood = 1)
	result = /obj/item/mystic_tome
	always_available = FALSE
	category = CAT_MISC

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
	if(H.bloodpool < 2)
		to_chat(H, span_warning("You need more <b>BLOOD</b> to do that!"))
		return
	if(drawing)
		return

	if(istype(H.get_active_held_item(), /obj/item/mystic_tome))
		var/list/rituals = list()
		for(var/i in subtypesof(/obj/abyssrune))
			var/obj/abyssrune/R = new i(owner)
			if(R.mystlevel <= level)
				rituals += i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw:", "Mysticism", rituals, null)
		if(ritual)
			drawing = TRUE
			if(do_after(H, 3 SECONDS * max(1, 5 - H.st_get_stat(STAT_OCCULT)), H))
				drawing = FALSE
				new ritual(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)
			else
				drawing = FALSE
	else
		var/list/rituals = list()
		for(var/i in subtypesof(/obj/abyssrune))
			var/obj/abyssrune/R = new i(owner)
			if(R.mystlevel <= level)
				rituals += i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw (You need a Mystic Tome to reduce random):", "Mysticism", list("???"))
		if(ritual)
			drawing = TRUE
			if(do_after(H, 30*max(1, 5-H.st_get_stat(STAT_OCCULT)), H))
				drawing = FALSE
				var/rune = pick(rituals)
				new rune(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)
			else
				drawing = FALSE

//SHADOWSTEP
/datum/discipline_power/obtenebration/shadowstep
	name = "Shadowstep"
	desc = "Become one with the shadows and move without your physical form."

	level = 6
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING
	vitae_cost = 0

	violates_masquerade = TRUE

	cooldown_length = 20 SECONDS

	var/obj/effect/proc_holder/spell/targeted/shadowwalk/shadowstep

/datum/discipline_power/obtenebration/shadowstep/activate()
	. = ..()
	if (!shadowstep)
		shadowstep = new

	shadowstep.cast(user = owner)
