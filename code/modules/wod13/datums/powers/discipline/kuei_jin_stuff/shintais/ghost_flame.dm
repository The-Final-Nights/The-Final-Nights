
/datum/discipline/chi_discipline/ghost_flame
	name = "Ghost Flame Shintai"
	desc = "Channel your Chi and stoke your Righteous Fury into true Flames."
	icon_state = "ghostfire"
	cost_yang = 1
	power_type = /datum/discipline_power/chi_discipline_power/ghost_flame
	discipline_type = "Shintai"

/datum/discipline_power/chi_discipline_power/ghost_flame
	name = "Ghost Flame Shintai"
	desc = "Channel your Chi and stoke your Righteous Fury into true Flames."
	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/ghostflameshintai_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/ghostflameshintai_activate.ogg'

//Stuff for Ghost Flame
/mob/living/simple_animal/hostile/beastmaster/fireball
	name = "fireball"
	desc = "FIREBALL!!"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fireball"
	icon_living = "fireball"
	del_on_death = TRUE
	attack_verb_continuous = "burns"
	attack_verb_simple = "burn"
	attack_sound = 'sound/effects/wounds/sizzle2.ogg'
	speak_chance = 0
	turns_per_move = 3
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_UNDEAD
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	bloodpool = 0
	maxbloodpool = 0
	maxHealth = 30
	health = 30
	yang_chi = 2
	max_yang_chi = 2
	yin_chi = 0
	max_yin_chi = 0
	harm_intent_damage = 10
	melee_damage_lower = 20
	melee_damage_upper = 30
	melee_damage_type = BURN
	speed = 2
	dodging = TRUE

/obj/item/gun/magic/ghostflame_shintai
	name = "fire spit"
	desc = "Spit fire on your targets."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fireball"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/ghostflame_shintai
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/ghostflame_shintai
	name = "fire spit"
	desc = "A spit."
	projectile_type = /obj/projectile/magic/aoe/fireball/firebreath
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/ghostflame_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)


// GhostFlame 1
/datum/discipline_power/chi_discipline_power/ghost_flame/one
	name = "Goblin Face"
	desc = "Push your Yang Chi through your body to create an immense heat hot enough around you to create light"

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS
	var/burn_loop = FALSE

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/ghost_flame/two,
		/datum/discipline_power/chi_discipline_power/ghost_flame/three,
		/datum/discipline_power/chi_discipline_power/ghost_flame/four,
		/datum/discipline_power/chi_discipline_power/ghost_flame/five
	)

/datum/discipline_power/chi_discipline_power/ghost_flame/one/activate()
	. = ..()
	owner.overlay_fullscreen("ghostflame", /atom/movable/screen/fullscreen/see_through_darkness)
	owner.update_sight()
	owner.set_light(2,8,"#ff8c00")
	burn_loop = TRUE
	while(burn_loop)
		for(var/mob/living/carbon/burned_mob in oviewers(4, owner))
			burned_mob.adjustFireLoss(10, TRUE)
			burned_mob.adjust_bodytemperature(15)
		sleep(1 SECONDS)


/datum/discipline_power/chi_discipline_power/ghost_flame/one/deactivate()
	. = ..()
	owner.clear_fullscreen("ghostflame", 5)
	owner.set_light(0)
	burn_loop = FALSE
	owner.update_sight()

//GhostFlame 2
/datum/discipline_power/chi_discipline_power/ghost_flame/two
	name = "Goblin Spark"
	desc = "Summon a Fireball to attack your enemies."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS
	violates_masquerade = TRUE
	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/ghost_flame/one,
		/datum/discipline_power/chi_discipline_power/ghost_flame/three,
		/datum/discipline_power/chi_discipline_power/ghost_flame/four,
		/datum/discipline_power/chi_discipline_power/ghost_flame/five
	)

/datum/discipline_power/chi_discipline_power/ghost_flame/two/activate()
	. = ..()
	var/limit = min(2, level) + owner.social + owner.more_companions - 1
	if(length(owner.beastmaster) >= limit)
		var/mob/living/simple_animal/hostile/beastmaster/fireball/fireball = pick(owner.beastmaster)
		fireball.death()
	if(!length(owner.beastmaster))
		var/datum/action/beastmaster_stay/stay_action = new()
		stay_action.Grant(owner)
		var/datum/action/beastmaster_deaggro/deaggro_action = new()
		deaggro_action.Grant(owner)
	var/mob/living/simple_animal/hostile/beastmaster/fireball/living_fireball = new(get_turf(owner))
	living_fireball.my_creator = owner
	owner.beastmaster |= living_fireball
	living_fireball.beastmaster = owner

//GhostFlame 3
/datum/discipline_power/chi_discipline_power/ghost_flame/three
	name = "Goblin Scorch"
	desc = "Create a fireball on your hand that you can throw to create a fire that can spread to flammable tiles."

	level = 3
	violates_masquerade = TRUE
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND

	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/ghost_flame/one,
		/datum/discipline_power/chi_discipline_power/ghost_flame/two,
		/datum/discipline_power/chi_discipline_power/ghost_flame/four,
		/datum/discipline_power/chi_discipline_power/ghost_flame/five
	)

/datum/discipline_power/chi_discipline_power/ghost_flame/three/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/gun/magic/ghostflame_shintai(owner))

//GhostFlame 4
/datum/discipline_power/chi_discipline_power/ghost_flame/four
	name = "Goblin Sword"
	desc = "Refinde your Firey Ghost Flames into a Katana made out of Fire."

	level = 4
	violates_masquerade = TRUE
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/ghost_flame/one,
		/datum/discipline_power/chi_discipline_power/ghost_flame/two,
		/datum/discipline_power/chi_discipline_power/ghost_flame/three,
		/datum/discipline_power/chi_discipline_power/ghost_flame/five
	)

/datum/discipline_power/chi_discipline_power/ghost_flame/four/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/melee/vampirearms/katana/fire(owner))
	owner.set_light(2,8,"#ff8c00")

/datum/discipline_power/chi_discipline_power/ghost_flame/four/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/katana/fire/firekatana in owner.contents)
		qdel(firekatana)
	owner.set_light(0)

//GhostFlame 5
/datum/discipline_power/chi_discipline_power/ghost_flame/five
	name = "Goblin lantern"
	desc = "Light yourself on fire with your own burning Chi while being immune to its damage and fire all around. Your equipment isn't as immune though."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS
	violates_masquerade = TRUE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/ghost_flame/one,
		/datum/discipline_power/chi_discipline_power/ghost_flame/two,
		/datum/discipline_power/chi_discipline_power/ghost_flame/three,
		/datum/discipline_power/chi_discipline_power/ghost_flame/four
	)

/datum/discipline_power/chi_discipline_power/ghost_flame/five/activate()
	. = ..()
	owner.dna.species.burnmod = 0
	ADD_TRAIT(owner, TRAIT_PERMANENTLY_ONFIRE, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_RESISTHEAT, MAGIC_TRAIT)
	owner.set_fire_stacks(10)
	owner.IgniteMob()
	owner.set_light(2,8,"#ff8c00")

/datum/discipline_power/chi_discipline_power/ghost_flame/five/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_PERMANENTLY_ONFIRE, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_RESISTHEAT, MAGIC_TRAIT)
	owner.extinguish_mob()
	if(owner.mind.dharma)
		switch(owner.mind.dharma.animated)
			if("Yang")
				owner.dna.species.burnmod = 0.5
			if("Yin")
				owner.dna.species.burnmod = initial(owner.dna.species.burnmod)
	else
		owner.dna.species.burnmod = initial(owner.dna.species.burnmod)
	owner.bodytemperature = BODYTEMP_NORMAL
	owner.coretemperature = BODYTEMP_NORMAL
	owner.set_light(0)
