/mob/living/simple_animal/werewolf/lupus
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
	armour_penetration = 35
	health = 150
	maxHealth = 150
	werewolf_armor = 10
	dextrous = FALSE
	var/hispo = FALSE

/mob/living/simple_animal/werewolf/lupus/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 0.5, -11)
	if(!iscorvid(src))
		var/datum/action/gift/hispo/hispo = new()
		hispo.Grant(src)

/mob/living/simple_animal/werewolf/lupus/corvid // yes, this is a subtype of lupus, god help us all
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

/datum/movespeed_modifier/lupusform
	multiplicative_slowdown = -1.7

/mob/living/simple_animal/werewolf/lupus/update_icons()
	cut_overlays()

	var/laid_down = FALSE

	if(stat == UNCONSCIOUS || IsSleeping() || stat == HARD_CRIT || stat == SOFT_CRIT || IsParalyzed() || stat == DEAD || body_position == LYING_DOWN)
		icon_state = "[sprite_color]_rest"
		laid_down = TRUE
	else
		icon_state = "[sprite_color]"

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
	..()

/mob/living/simple_animal/werewolf/lupus/regenerate_icons()
	if(!..())
	//	update_icons() //Handled in update_transform(), leaving this here as a reminder
		update_transform()

/mob/living/simple_animal/werewolf/lupus/update_transform() //The old method of updating lying/standing was update_icons(). Aliens still expect that.
	. = ..()
	update_icons()

/mob/living/simple_animal/werewolf/lupus/Life()
	if(hispo)
		if(CheckEyewitness(src, src, 7, FALSE))
			adjust_veil(-1,random = -1)
	else
		if(!(HAS_TRAIT(src, TRAIT_DOGWOLF) || !iscorax(src))) // ravens don't spook people
			if(CheckEyewitness(src, src, 4, FALSE))
				adjust_veil(-1,threshold = 4)
	..()
