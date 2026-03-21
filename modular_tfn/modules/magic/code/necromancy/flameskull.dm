// **************************************************************** flameskull *************************************************************

/obj/necrorune/flameskull
	name = "Ammorsus Vicarius"
	desc = "Create a animated skull which can be used as a weapon or trap."
	icon_state = "rune3"
	word = "OR-IRI O FLAM-MEUM CERE-BRUM"
	necrolevel = 3
	sacrifices = list(/obj/item/corspestore/skull)

/obj/necrorune/flameskull/complete()
	new /obj/item/restraints/legcuffs/beartrap/skull(loc)
	playsound(loc, 'code/modules/wod13/sounds/necromancy2.ogg', 50, FALSE)
	qdel(src)

/obj/item/restraints/legcuffs/beartrap/skull
	name = "Animated Skull"
	desc = "Animated skull which activates once one steps within its range."
	throw_speed = 1
	throw_range = 5
	icon = 'modular_tfn/modules/magic/code/necromancy/flameskull.dmi'
	icon_state = "legion_skull"
	inhand_icon_state = "skull_helmet"
	lefthand_file = 'icons/mob/inhands/clothing/hats_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/hats_righthand.dmi'
	lefthand
	force = 30
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
	damtype = CLONE

/obj/item/restraints/legcuffs/beartrap/skull/close_trap()
	armed = FALSE
	playsound(src, 'code/modules/wod13/sounds/werewolf_bite.ogg', 50, TRUE)
