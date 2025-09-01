/mob/living/carbon/werewolf/lupus
	name = "wolf"
	icon_state = "black"
	icon = 'code/modules/wod13/tfn_lupus.dmi'
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	butcher_results = list(/obj/item/food/meat/slab = 5)
	limb_destroyer = 1
	has_limbs = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	//armour_penetration = 35
	health = 150
	maxHealth = 150
	werewolf_armor = 10

	default_num_hands = 1
	held_items = list(null)

	var/hispo = FALSE

/mob/living/carbon/werewolf/lupus/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 0.5, -11)
	if(!iscorvid(src))
		var/datum/action/gift/hispo/hispo = new()
		hispo.Grant(src)
	else
		var/datum/action/innate/togglecorvidflight/toggleflight = new()
		toggleflight.Grant(src)
		var/datum/action/fly_upper/fly_up = new()
		fly_up.Grant(src)

/mob/living/carbon/werewolf/lupus/can_hold_items(obj/item/I)
	return ((I.w_class <= WEIGHT_CLASS_SMALL) && ..())

/datum/movespeed_modifier/lupusform
	multiplicative_slowdown = -0.7

/mob/living/carbon/werewolf/lupus/update_icons()
	cut_overlays()

	var/laid_down = FALSE

	if(stat == UNCONSCIOUS || IsSleeping() || stat == HARD_CRIT || stat == SOFT_CRIT || IsParalyzed() || stat == DEAD || body_position == LYING_DOWN)
		icon_state = HAS_TRAIT(src, TRAIT_WYRMTAINTED) ? "spiral[sprite_color]_rest" : "[sprite_color]_rest"
		laid_down = TRUE
	else
		icon_state = HAS_TRAIT(src, TRAIT_WYRMTAINTED) ? "spiral[sprite_color]" : "[sprite_color]"
	if(HAS_TRAIT(src, TRAIT_MOVE_FLYING))
		icon_state = HAS_TRAIT(src, TRAIT_WYRMTAINTED) ? "spiral[sprite_color]_flying" :"[sprite_color]_flying"

	switch(getFireLoss()+getBruteLoss())
		if(25 to 75)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage1[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)
		if(75 to 150)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage2[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)
		if(150 to INFINITY)
			var/mutable_appearance/damage_overlay = mutable_appearance(icon, "damage3[laid_down ? "_rest" : ""]")
			add_overlay(damage_overlay)

	var/mutable_appearance/eye_overlay = mutable_appearance(icon, "eyes[laid_down ? "_rest" : HAS_TRAIT(src, TRAIT_MOVE_FLYING) ? "_flying" : ""]")
	eye_overlay.color = sprite_eye_color
	eye_overlay.plane = ABOVE_LIGHTING_PLANE
	eye_overlay.layer = ABOVE_LIGHTING_LAYER
	add_overlay(eye_overlay)
	. = ..()

/mob/living/carbon/werewolf/lupus/regenerate_icons()
	if(!..())
		update_transform()

/mob/living/carbon/werewolf/lupus/update_transform() //The old method of updating lying/standing was update_icons(). Aliens still expect that.
	. = ..()
	update_icons()

/mob/living/carbon/werewolf/lupus/Life()
	if((HAS_TRAIT(src, TRAIT_DOGWOLF) || (iscorvid(src) && !HAS_TRAIT(src, TRAIT_WYRMTAINTED)))) // ravens don't spook people
		. = ..()
		return
	SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)
	. = ..()

/mob/living/carbon/werewolf/lupus/corvid // yes, this is a subtype of lupus, god help us all
	name = "corvid"
	icon_state = "black"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	verb_say = "caws"
	verb_exclaim = "squawks"
	verb_yell = "shrieks"
	melee_damage_lower = 10
	melee_damage_upper = 20 // less damage for silly ravens
	health = 100
	maxHealth = 100 // I predict that the sprites will be hell to click, no extra HP compared to homid

/mob/living/carbon/werewolf/lupus/corvid/can_hold_items(obj/item/I)
	// Look at them, do you think they can pick up flashlights?
	return ((I.w_class <= WEIGHT_CLASS_TINY) && ..())

/datum/action/innate/togglecorvidflight // this action handles corvid forms toggle their flight, and swaps their sprite to be of the relevant type, I'm making it a gift because it's also what Hispo is under
	name = "Toggle Flight"
	desc = "Unfurl or withdraw your wings, toggling your ability to fly"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_IMMOBILE
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/innate/togglecorvidflight/Trigger(trigger_flags)
	var/mob/living/carbon/werewolf/lupus/corvid/corvid = owner
	if (!(corvid.movement_type & FLYING))
		to_chat(corvid, span_notice("You beat your wings and begin to hover gently above the ground..."))
		corvid.set_resting(FALSE, TRUE)
		ADD_TRAIT(corvid, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT) // sadly, "is flying animal" does not give us flying traits when life() is called, only during VV or upon Init. We're doing this the hard way.
		ADD_TRAIT(corvid, TRAIT_NO_FLOATING_ANIM, SPECIES_FLIGHT_TRAIT) // the corax sprites already animate up-and-down bobbing, no need to float
		corvid.icon_state = HAS_TRAIT(corvid, TRAIT_WYRMTAINTED) ?  "spiral[corvid.sprite_color]_flying"  : "[corvid.sprite_color]_flying" // we set this while we wait for the icons to update, otherwise there is latency
	else
		to_chat(corvid, span_notice("You settle gently back onto the ground..."))
		REMOVE_TRAIT(corvid, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)
		REMOVE_TRAIT(corvid, TRAIT_NO_FLOATING_ANIM, SPECIES_FLIGHT_TRAIT)
		corvid.icon_state = HAS_TRAIT(corvid, TRAIT_WYRMTAINTED) ? "spiral[corvid.sprite_color]" : "[corvid.sprite_color]"

	corvid.cut_overlays()
	var/mutable_appearance/flight_overlay = mutable_appearance(corvid.icon, "eyes[HAS_TRAIT(corvid, TRAIT_MOVE_FLYING) ? "_flying" : ""]")
	flight_overlay.color = corvid.sprite_eye_color
	flight_overlay.plane = ABOVE_LIGHTING_PLANE
	flight_overlay.layer = ABOVE_LIGHTING_LAYER
	corvid.add_overlay(flight_overlay)
