#define COMBAT_COOLDOWN_LENGTH 45 SECONDS

/datum/discipline/chi_discipline/yin_prana
	name = "Yin Prana"
	desc = "Master the Flow of your Yin Chi."
	icon_state = "yin_prana"
	power_type = /datum/discipline_power/chi_discipline_power/yin_prana
	discipline_type = "Chi"
	cost_yin = 2

/datum/discipline_power/chi_discipline_power/yin_prana
	name = "Yin Prana"
	desc = "Master the Flow of your Yin Chi."
	activate_sound = 'code/modules/wod13/sounds/yin_prana.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/yin_prana.ogg'
	cost_yin = 2

/obj/item/melee/touch_attack/yin_touch
	name = "Shadow Touch"
	desc = "The cold static touch of Yin manifested upon your palm."
	icon = 'code/modules/wod13/weapons.dmi'
	catchphrase = null
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "quietus"
	color = "#343434"
	inhand_icon_state = "mansus"

/obj/item/melee/touch_attack/yin_touch/afterattack(atom/target, mob/living/carbon/owner, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/structure/vampdoor))
		var/obj/structure/vampdoor/door = target
		if (door.lockpick_difficulty > 10)
			to_chat(owner, "<span class='warning'> This door is too strong to burn down </span>")
			return ..()
		playsound(get_turf(target), 'code/modules/wod13/sounds/get_bent.ogg', 100, FALSE)
		var/obj/item/shield/door/door_item = new(get_turf(target))
		door_item.icon_state = door.baseicon
		var/atom/throw_target = get_edge_target_turf(target, owner.dir)
		door_item.throw_at(throw_target, rand(2, 4), 4, src)
		qdel(target)
	if(isliving(target))
		var/mob/living/target_mob = target
		target_mob.adjustCloneLoss(20 * owner.dna.species.meleemod)
		target_mob.AdjustKnockdown(2 SECONDS)
	return ..()


//Yin Prana 1
/datum/discipline_power/chi_discipline_power/yin_prana/one
	name = "Shrouded Moon"
	desc = "Shround yourself in invisiblity with Yin Chi"

	level = 1
	cost_yin = 2
	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yin_prana/two,
		/datum/discipline_power/chi_discipline_power/yin_prana/three,
		/datum/discipline_power/chi_discipline_power/yin_prana/four,
		/datum/discipline_power/chi_discipline_power/yin_prana/five
	)

	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_MOB_ATTACKED_HAND,
		COMSIG_MOB_MELEE_SWING,
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOB_THREW_MOVABLE,
		COMSIG_MOB_ATTACKING_MELEE,
		COMSIG_MOB_ATTACKED_BY_MELEE,
		COMSIG_PROJECTILE_PREHIT,
	)

/datum/discipline_power/chi_discipline_power/yin_prana/one/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Shadows fades away as you reveal yourself!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/discipline_power/chi_discipline_power/yin_prana/one/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)

	for(var/mob/living/carbon/human/npc/NPC in GLOB.npc_list)
		if (NPC.danger_source == owner)
			NPC.danger_source = null
	ADD_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

/datum/discipline_power/chi_discipline_power/yin_prana/one/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)

	REMOVE_TRAIT(owner, TRAIT_OBFUSCATED, OBFUSCATE_TRAIT)

//Yin Prana 2
/datum/discipline_power/chi_discipline_power/yin_prana/two
	name = "Yin Mantle (1 Yin)"
	desc = "Let the shadows protect you by casting the area around you heavily in darkness."

	level = 2
	cost_yin = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS


	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yin_prana/one,
		/datum/discipline_power/chi_discipline_power/yin_prana/three,
		/datum/discipline_power/chi_discipline_power/yin_prana/four,
		/datum/discipline_power/chi_discipline_power/yin_prana/five
	)

/datum/discipline_power/chi_discipline_power/yin_prana/two/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC) //Needed cause it would be so lame to be blinded by your own darkness
	owner.set_light(discipline.level+2, -10)
	owner.update_sight()

/datum/discipline_power/chi_discipline_power/yin_prana/two/deactivate()
	. = ..()
	owner.set_light(0)
	REMOVE_TRAIT(owner, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	owner.update_sight()

//Yin Prana 3
/datum/discipline_power/chi_discipline_power/yin_prana/three
	name = "Bone Dance"
	desc = "With a burst of Yin chi, let all around you feel the crippling death-like sensation of Yin overload."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = FALSE
	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yin_prana/one,
		/datum/discipline_power/chi_discipline_power/yin_prana/two,
		/datum/discipline_power/chi_discipline_power/yin_prana/four,
		/datum/discipline_power/chi_discipline_power/yin_prana/five
	)

/datum/discipline_power/chi_discipline_power/yin_prana/three/activate()
	. = ..()
	for(var/mob/living/affected_mob in oviewers(5, owner))
		affected_mob.AdjustKnockdown(1 SECONDS * discipline.level)
		affected_mob.adjustStaminaLoss((20 * discipline.level), TRUE)
	var/matrix/double_size = matrix()
	double_size.Scale(2, 2)
	for (var/i in 1 to 3)
		var/obj/effect/celerity/celerity_effect = new(get_turf(owner))
		celerity_effect.appearance = owner.appearance
		celerity_effect.dir = owner.dir
		celerity_effect.color = "#000000"
		animate(celerity_effect, pixel_x = pick(-16, 0, 16), pixel_y = pick(-16, 0, 16), alpha = 0, transform = double_size, time = 2 SECONDS)

//Yin Prana 4
/datum/discipline_power/chi_discipline_power/yin_prana/four
	name = "Eightfold Yin Mantle"
	desc = "Concentrate a burst of Yin Chi around your hand, whether to attack enemies or break down doors."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_FREE_HAND
	cooldown_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yin_prana/one,
		/datum/discipline_power/chi_discipline_power/yin_prana/two,
		/datum/discipline_power/chi_discipline_power/yin_prana/three,
		/datum/discipline_power/chi_discipline_power/yin_prana/five
	)

/datum/discipline_power/chi_discipline_power/yin_prana/four/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/melee/touch_attack/yin_touch(owner))

//Yin Prana 5
/datum/discipline_power/chi_discipline_power/yin_prana/five
	name = "Semblance of the Ebon Dragon"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/yin_prana/one,
		/datum/discipline_power/chi_discipline_power/yin_prana/two,
		/datum/discipline_power/chi_discipline_power/yin_prana/three,
		/datum/discipline_power/chi_discipline_power/yin_prana/four
	)
	var/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/jaunt

/datum/discipline_power/chi_discipline_power/yin_prana/five/activate()
	. = ..()
	if(!jaunt)
		jaunt = new(owner)
	jaunt.cast(list(owner), owner)

#undef COMBAT_COOLDOWN_LENGTH
