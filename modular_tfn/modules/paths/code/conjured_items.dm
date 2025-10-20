// Mystically conjured items subclassed as lighters to emit light
/obj/item/lighter/conjured
	lit = TRUE
	light_system = MOVABLE_LIGHT
	light_on = TRUE
	damtype = BURN
	item_flags = DROPDEL
	icon = 'modular_tfn/modules/paths/icons/paths.dmi'
	lefthand_file = 'modular_tfn/modules/paths/icons/paths_inhand_lefthand.dmi'
	righthand_file = 'modular_tfn/modules/paths/icons/paths_inhand_righthand.dmi'

// Override parent behavior so that they can't be turned off
/obj/item/lighter/conjured/attack_self(mob/user)
	to_chat(user, span_notice("The supernatural flame cannot be extinguished by normal means."))
	return

// Keep the flame always lit
/obj/item/lighter/conjured/set_lit(new_lit)
	if(!new_lit)
		return // Cannot be extinguished
	return ..()

/obj/item/lighter/conjured/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	attack_speed = CLICK_CD_MELEE
	set_light_on(TRUE)

// Lure of flames conjured weapons
/obj/item/lighter/conjured/flame
	light_range = 3
	light_power = 1
	light_color = COLOR_ORANGE

// afterattack for flame items - includes ignition chance
/obj/item/lighter/conjured/flame/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	if(proximity_flag && isliving(target))
		var/mob/living/L = target
		// Chance to ignite target - and yourself!
		if(prob(25))
			L.adjust_fire_stacks(1)
			L.IgniteMob()
		if(prob(5))
			user.adjust_fire_stacks(1)
			user.IgniteMob()
		playsound(src, 'modular_tfn/modules/paths/sounds/fireball.ogg', 25, TRUE)

	return ..()

// Lure of Flames items
/obj/item/lighter/conjured/flame/candle
	name = "Lure of Flames - Candle"
	desc = "From your finger sprouts out the small flame of a candle."
	icon_state = "candle"
	inhand_icon_state = "candle"
	force = 10

/obj/item/lighter/conjured/flame/palm_of_flame
	name = "hand of flame"
	desc = "Your hand burns with supernatural fire."
	icon_state = "flame"
	inhand_icon_state = "flame"
	force = 25
	fancy = FALSE

// Levinbolt items
/obj/item/lighter/conjured/levinbolt_arm
	name = "Illuminate"
	desc = "Your arm surges with electricity!"
	icon_state = "illuminate"
	inhand_icon_state = "illuminate"
	force = 15
	light_range = 2
	light_power = 1
	light_color = COLOR_WHITE
