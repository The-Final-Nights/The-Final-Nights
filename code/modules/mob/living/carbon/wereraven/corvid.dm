// Wereraven code? In my corax folder?! Are you insane?!
// this is a copy of the lupus.dm code, tweaked to hopefullygive the ravens a hand and overall tweak their values.

/mob/living/carbon/corax/corvid
	name = "corvid"
	icon_state = "black"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	butcher_results = list(/obj/item/food/meat/slab = 2)
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, INTENT_HARM)
	hud_type = /datum/hud/corax
	AddElement(/datum/element/waddling) // try not to look silly challenge
	limb_destroyer = 1
	has_limbs = 1
	dextrous = FALSE // As funny as a raven shooting a gun is, I don't think this is something we want. Prevents them from using phones, sadly.
	melee_damage_lower = 15
	melee_damage_upper = 20
	health = 150
	maxHealth = 150
	corax_armor = 10
	bodyparts = /obj/item/bodypart/r_arm/corvid_corax // a singular hand, to pick up items with.
	var/obj/item/r_store = null
	var/hispo = FALSE


/datum/movespeed_modifier/corvidform
	multiplicative_slowdown = 0 // Ravens move at regular pace while landed.

/mob/living/carbon/corax/corvid/update_icons()
	cut_overlays()

	var/laid_down = FALSE
	var/flying = FALSE

	if(stat == UNCONSCIOUS || IsSleeping() || stat == HARD_CRIT || stat == SOFT_CRIT || IsParalyzed() || stat == DEAD || body_position == LYING_DOWN)
		icon_state = "[sprite_color]_rest"
		laid_down = TRUE
	else
		icon_state = "[sprite_color]"

	// if(!HAS_TRAIT_FROM(src, TRAIT_INCAPACITATED, STAMINA)) //If we are flying, show the flying sprite.

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

	var/mutable_appearance/eye_overlay = mutable_appearance(icon, "eyes[laid_down ? "_rest" : ""]")
	eye_overlay.color = sprite_eye_color
	eye_overlay.plane = ABOVE_LIGHTING_PLANE
	eye_overlay.layer = ABOVE_LIGHTING_LAYER
	add_overlay(eye_overlay)

/mob/living/carbon/corax/corvid/regenerate_icons()
	if(!..())
	//	update_icons() //Handled in update_transform(), leaving this here as a reminder
		update_transform()

/mob/living/carbon/corax/corvid/update_transform() //The old method of updating lying/standing was update_icons(). Aliens still expect that.
	. = ..()
	update_icons()

/mob/living/carbon/corax/corvid/Life()
	..() // you do not breach the veil by being a bird in a city, probably a redundant self-call though.
