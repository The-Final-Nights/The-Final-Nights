/datum/discipline/necromancy
	name = "Necromancy"
	desc = "Offers control over another, undead reality."
	icon_state = "necromancy"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/necromancy

/datum/discipline/necromancy/post_gain()
	. = ..()

	owner.faction |= CLAN_GIOVANNI
	var/datum/action/necroritualism/ritualist = new()
	owner.necromancy_knowledge = TRUE
	ritualist.Grant(owner)
	ritualist.level = level
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/necrotome)


/datum/discipline_power/necromancy
	name = "Necromancy power name"
	desc = "Necromancy power description"


//SHROUDSIGHT
/datum/discipline_power/necromancy/shroudsight
	name = "Shroudsight"
	desc = "See in darkness clearly and see ghosts present."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

	activate_sound = 'code/modules/wod13/sounds/necromancy1on.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/necromancy1off.ogg'

	toggled = TRUE


/datum/discipline_power/necromancy/shroudsight/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_NIGHT_VISION, NECROMANCY_TRAIT)
	ADD_TRAIT(owner, TRAIT_GHOST_VISION, NECROMANCY_TRAIT)

	owner.update_sight()

	to_chat(owner, span_notice("You peek beyond the Shroud."))

/datum/discipline_power/necromancy/shroudsight/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_NIGHT_VISION, NECROMANCY_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_GHOST_VISION, NECROMANCY_TRAIT)

	owner.see_override = initial(owner.see_override)

	owner.update_sight()

	to_chat(owner, span_warning("Your vision returns to the mortal realm."))

//ETHEREAL HORDE
/datum/discipline_power/necromancy/ethereal_horde
	name = "Ethereal Horde"
	desc = "Summon a pair of Drones from the Shadowlands to defend you."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	vitae_cost = 1

	effect_sound = 'code/modules/wod13/sounds/necromancy2.ogg'

	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/necromancy/ethereal_horde/activate()
	. = ..()

	var/limit = 2 + owner.social + owner.more_companions - 1
	var/diff = limit - length(owner.beastmaster)
	if(diff <= 0)
		to_chat(owner, span_warning("The vitae cools - you cannot extend your will to any more followers."))
		return

	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/stay = new()
		stay.Grant(owner)
		var/datum/action/beastmaster_deaggro/deaggro = new()
		deaggro.Grant(owner)

	owner.visible_message(span_warning("Wailing shades step forth from [owner]'s shadow."))
	var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie1 = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level1(owner.loc)
	zombie1.my_creator = owner
	owner.beastmaster |= zombie1
	zombie1.beastmaster = owner
	if(diff != 1)
		var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie2 = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level1(owner.loc)
		zombie2.my_creator = owner
		owner.beastmaster |= zombie2
		zombie2.beastmaster = owner


//ASHES TO ASHES
/datum/discipline_power/necromancy/ashes_to_ashes
	name = "Ashes to Ashes"
	desc = "Dissolve a corpse to gain its lifeforce, or steal such from a wraith."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB | TARGET_GHOST
	range = 3 //to not wallbang people mid-surgery at the hospital
	vitae_cost = 0

	activate_sound = 'code/modules/wod13/sounds/necromancy3.ogg'

	violates_masquerade = TRUE

	cooldown_length = 10 SECONDS

/datum/discipline_power/necromancy/ashes_to_ashes/activate(mob/target)
	. = ..()

	if(isavatar(target))
		to_chat(owner, span_warning("This spirit is yet linked to a corporeal form.")) //can't suck from non-ghosts
		return
	if (isobserver(target))
		to_chat(target, span_notice("[owner] siphons your plasm; [owner.p_they()] steal from your being to sustain [owner.p_their()] own."))
		to_chat(owner, span_warning("You've slaked your Hunger on a wraith's passion. You gain <b>BLOOD</b>."))
		owner.bloodpool = min(owner.bloodpool + 1, owner.maxbloodpool) //1 point per ghost sip.
		return
	if (isliving(target) && target.stat == DEAD)
		var/mob/living/dusted = target
		owner.visible_message(span_warning("[owner] motions towards [target]."))
		dusted.visible_message(span_danger("[target]'s body dissolves into dust before your very eyes!"))
		to_chat(owner, span_warning("You've absorbed the body's residual lifeforce. You gain <b>BLOOD</b>."))
		dusted.dust()
		owner.bloodpool = min(owner.bloodpool + 2, owner.maxbloodpool) //2 points per body. works on simplemobs for now.
	else
		to_chat(owner, span_warning("Death has not yet claimed this one - there is nothing to pillage."))


//COLD OF THE GRAVE
/datum/discipline_power/necromancy/cold_of_the_grave
	name = "Cold of the Grave"
	desc = "Place a chosen target, including yourself, into a corpse-like state."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_SELF | TARGET_LIVING
	range = 5
	vitae_cost = 1

	effect_sound = 'code/modules/wod13/sounds/necromancy4.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	multi_activate = TRUE
	cooldown_length = 20 SECONDS
	duration_length = 20 SECONDS

/datum/movespeed_modifier/corpsebuff
	multiplicative_slowdown = 0.4

/datum/movespeed_modifier/corpsenerf
	multiplicative_slowdown = 0.8 //lasts for a while

/datum/discipline_power/necromancy/cold_of_the_grave/activate(mob/living/target)
	. = ..()

	owner.visible_message(span_warning("[owner] motions towards [target]."))
	if(iscarbon(target))
		var/mob/living/carbon/human/corpsebuff = target
		if(iskindred(target) || iscathayan(target) || iszombie(target)) //undead become spongier, but move slightly slower
			corpsebuff.visible_message(span_danger("[target]'s body seizes with rigor mortis."), span_danger("Your senses dull to pain and everything else."))
			corpsebuff.dna.species.brutemod = max(0.2, corpsebuff.dna.species.brutemod-0.3) //equivalent of the existing artifact
			ADD_TRAIT(corpsebuff, TRAIT_NOSOFTCRIT, NECROMANCY_TRAIT)
			ADD_TRAIT(corpsebuff, TRAIT_NOHARDCRIT, NECROMANCY_TRAIT)
			ADD_TRAIT(corpsebuff, TRAIT_IGNOREDAMAGESLOWDOWN, NECROMANCY_TRAIT)
			corpsebuff.add_movespeed_modifier(/datum/movespeed_modifier/corpsebuff)
			corpsebuff.do_jitter_animation(2 SECONDS)
		else //everyone else eats tox and CC
			corpsebuff.visible_message(span_danger("[target]'s skin grays, terrible illness gripping [target.p_their()] body."), span_userdanger("You feel terribly sick."))
			corpsebuff.vomit()
			corpsebuff.dizziness += 10
			corpsebuff.add_confusion(10)
			corpsebuff.apply_damage(50, TOX)
			corpsebuff.Stun(3 SECONDS) // ignored by tough flesh and shapeshifted werewolves
			corpsebuff.add_movespeed_modifier(/datum/movespeed_modifier/corpsenerf)
			corpsebuff.do_jitter_animation(2 SECONDS)

	else
		target.apply_damage(100, BRUTE)
		target.visible_message(span_danger("[target] shrivels up and withers!"))

/datum/discipline_power/necromancy/cold_of_the_grave/deactivate(mob/living/target)
	. = ..()

	if(iscarbon(target))
		var/mob/living/carbon/human/corpsebuff = target
		if(iskindred(target) || iscathayan(target))
			corpsebuff.visible_message(span_notice("[target]'s body regains its luster."), span_notice("Feeling comes flooding back into your body."))
			corpsebuff.dna.species.brutemod = initial(corpsebuff.dna.species.brutemod)
			REMOVE_TRAIT(corpsebuff, TRAIT_NOSOFTCRIT, NECROMANCY_TRAIT)
			REMOVE_TRAIT(corpsebuff, TRAIT_NOHARDCRIT, NECROMANCY_TRAIT)
			REMOVE_TRAIT(corpsebuff, TRAIT_IGNOREDAMAGESLOWDOWN, NECROMANCY_TRAIT)
			corpsebuff.remove_movespeed_modifier(/datum/movespeed_modifier/corpsebuff)
		else
			corpsebuff.remove_movespeed_modifier(/datum/movespeed_modifier/corpsenerf)
			corpsebuff.visible_message(span_notice("[target]'s body regains its luster."), span_notice("Your unnatural ailing abates."))


//SHAMBLING HORDE
/datum/discipline_power/necromancy/shambling_horde
	name = "Shambling Horde"
	desc = "Raise savage zombies from corpses, their lethality determined by source material. Attack the living, and rebuild sentient undead."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 5 //less range than thaum, nerf if 2stronk

	effect_sound = 'code/modules/wod13/sounds/necromancy5.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS

/datum/discipline_power/necromancy/shambling_horde/activate(mob/living/target)
	. = ..()
	var/limit = 2 + owner.social + owner.more_companions - 1
	var/diff = limit - length(owner.beastmaster)
	if (target.stat == DEAD)
		if(diff <= 0)
			to_chat(owner, span_warning("The vitae cools - you cannot extend your will to any more followers."))
			return
		if(!length(owner.beastmaster))
			var/datum/action/beastmaster_stay/stay_action = new()
			stay_action.Grant(owner)
			var/datum/action/beastmaster_deaggro/deaggro_action = new()
			deaggro_action.Grant(owner)

		owner.visible_message(span_warning("[owner] gestures over [target]'s carcass."))
		target.visible_message(span_danger("[target] twitches and rises, puppeteered by an invisible force."))
		if(iscarbon(target))
			var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level4(owner.loc)
			zombie.my_creator = owner
			owner.beastmaster |= zombie
			zombie.beastmaster_owner = owner
			qdel(target)
		else
			switch(target.maxHealth)
				if (-INFINITY to 20) //rats and whatnot
					var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level2(owner.loc)
					zombie.my_creator = owner
					owner.beastmaster |= zombie
					zombie.beastmaster_owner = owner
					qdel(target)
				if (20 to 70) //cats and whatnot
					var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level3(owner.loc)
					zombie.my_creator = owner
					owner.beastmaster |= zombie
					zombie.beastmaster_owner = owner
					qdel(target)
				if (70 to 150) //dogs/biters and whatnot
					var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level4(owner.loc)
					zombie.my_creator = owner
					owner.beastmaster |= zombie
					zombie.beastmaster_owner = owner
					qdel(target)
				if (150 to INFINITY) //szlachta and whatnot
					var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/zombie = new /mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level5(owner.loc)
					zombie.my_creator = owner
					owner.beastmaster |= zombie
					zombie.beastmaster_owner = owner
					qdel(target)

	else if(iszombie(target))
		owner.visible_message(span_warning("[owner] aggressively gestures at [target]!"))
		target.visible_message(span_warning("[target]'s flesh knits together'!"), span_danger("Your rotten flesh reconstitutes!"))
		var/mob/living/carbon/human/zombie = target
		zombie.heal_ordered_damage(120, list(BRUTE, TOX, BURN, CLONE, OXY, BRAIN))
		zombie.bloodpool = min(zombie.maxbloodpool, zombie.bloodpool+3)
		if(length(zombie.all_wounds))
			var/datum/wound/wound = pick(zombie.all_wounds)
			wound.remove_wound()
	else
		owner.visible_message(span_warning("[owner] aggressively gestures at [target]!"))
		target.visible_message(span_warning("[target] is assaulted by necromantic energies!"), span_danger("You feel yourself rot from within!"))
		target.apply_damage(55, CLONE, owner.zone_selected) // 1/5 of a 5-dot "healthbar" in aggravated damage, on level with thaumaturgy's average output
		target.emote("scream")


// RITUALISM

/datum/action/necroritualism
	name = "necroritualism"
	desc = "Draw runes to perform Necromancy Rituals."
	button_icon_state = "necroritualism"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/drawing = FALSE
	var/level = 1

/datum/action/necroritualism/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(H, span_warning("You need more <b>BLOOD</b> to do that!"))
		return

	if(istype(H.get_active_held_item(), /obj/item/necromancy_tome))
		var/list/rune_names = list()
		for(var/i in subtypesof(/obj/necrorune))
			var/obj/necrorune/R = new i(owner)
			if(R.necrolevel <= level)
				rune_names[R.name] = i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw:", "Necromancy", rune_names)
		if(!ritual)
			return
		if(do_after(H, 3 SECONDS * max(1, 5 - H.mentality), H))
			var/ritual_type = rune_names[ritual]
			new ritual_type(H.loc)
			H.bloodpool = max(H.bloodpool - 2, 0)
			SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)

	else
		var/list/rune_names = list()
		for(var/i in subtypesof(/obj/necrorune))
			var/obj/necrorune/R = new i(owner)
			if(R.necrolevel <= level)
				rune_names += i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw:", "necroritualism", list("???"))
		if(!ritual)
			return
		if(do_after(H, 30*max(1, 5-H.mentality), H))
			var/rune = pick(rune_names)
			new rune(H.loc)
			H.bloodpool = max(H.bloodpool - 2, 0)
			SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)
