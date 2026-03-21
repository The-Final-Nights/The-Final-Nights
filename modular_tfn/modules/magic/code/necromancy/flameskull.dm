// **************************************************************** flameskull *************************************************************

/obj/necrorune/flameskull
	name = "Ammorsus Vicarius"
	desc = "Create a animated skull which can be used as a weapon or trap."
	icon_state = "rune3"
	word = "OR-IRI O FLAM-MEUM CERE-BRUM"
	necrolevel = 3
	sacrifices = list(/obj/item/corspestore/skull)

/obj/necrorune/flameskull/complete()
	new /obj/item/restraints/legcuffs/skull(loc)
	playsound(loc, 'code/modules/wod13/sounds/necromancy2.ogg', 50, FALSE)
	qdel(src)

/obj/item/restraints/legcuffs/skull
	name = "animated skull"
	desc = "Animated skull which activates once one steps within its range."
	throw_speed = 1
	throw_range = 5
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "legion_skull"
	inhand_icon_state = "skull_helmet"
	lefthand_file = 'icons/mob/inhands/clothing/hats_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/hats_righthand.dmi'
	lefthand
	force = 40
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = null
	block_chance = 20
	armour_penetration = 10
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("chomps", "bites")
	attack_verb_simple = list("chomps", "bites")
	hitsound = 'code/modules/wod13/sounds/werewolf_bite.ogg'
	wound_bonus = 5
	bare_wound_bonus = 10
	masquerade_violating = TRUE
	var/armed = 0
	var/trap_damage = 40

/obj/item/restraints/legcuffs/skull/Initialize()
	. = ..()

/obj/item/restraints/legcuffs/skull/attack_self(mob/user)
	. = ..()
	if(!ishuman(user) || user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return
	armed = !armed
	to_chat(user, span_notice("[src] is now [armed ? "armed" : "disarmed"]"))

/obj/item/restraints/legcuffs/skull/proc/close_trap()
	armed = FALSE
	playsound(src, 'code/modules/wod13/sounds/werewolf_bite.ogg', 50, TRUE)

/obj/item/restraints/legcuffs/skull/Crossed(AM as mob|obj)
	if(armed && isturf(loc))
		if(isliving(AM))
			var/mob/living/L = AM
			var/snap = TRUE
			if(istype(L.buckled, /obj/vehicle))
				var/obj/vehicle/ridden_vehicle = L.buckled
				if(!ridden_vehicle.are_legs_exposed) //close the trap without injuring/trapping the rider if their legs are inside the vehicle at all times.
					close_trap()
					ridden_vehicle.visible_message(span_notice("[ridden_vehicle] triggers \the [src]."))
					return ..()

			if(L.movement_type & (FLYING|FLOATING)) //don't close the trap if they're flying/floating over it.
				snap = FALSE

			var/def_zone = BODY_ZONE_CHEST
			if(snap && iscarbon(L))
				var/mob/living/carbon/C = L
				if(C.body_position == STANDING_UP)
					def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
					if(!C.legcuffed && C.num_legs >= 2) //beartrap can't cuff your leg if there's already a beartrap or legcuffs, or you don't have two legs.
						C.legcuffed = src
						forceMove(C)
						C.update_equipment_speed_mods()
						C.update_inv_legcuffed()
						SSblackbox.record_feedback("tally", "handcuffs", 1, type)
			else if(snap && isanimal(L))
				var/mob/living/simple_animal/SA = L
				if(SA.mob_size <= MOB_SIZE_TINY) //don't close the trap if they're as small as a mouse.
					snap = FALSE
			if(snap)
				close_trap()
				L.visible_message(span_notice("[L] triggers \the [src]."), \
						span_notice("You trigger \the [src]!"))
				L.apply_damage(trap_damage, BRUTE, def_zone)
	..()
