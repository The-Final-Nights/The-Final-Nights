
/datum/discipline/chi_discipline/blood
	name = "Blood Shintai"
	desc = "Channel the flow of Blood through Yin Chi."
	icon_state = "blood"
	power_type = /datum/discipline_power/chi_discipline_power/blood
	discipline_type = "Shintai"
	cost_yin = 1

/datum/discipline_power/chi_discipline_power/blood
	name = "Blood Shintai"
	desc = "Channel the flow of Blood through Yin Chi."
	cost_yin = 1
	activate_sound = 'code/modules/wod13/sounds/bloodshintai_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/bloodshintai_activate.ogg'

/datum/movespeed_modifier/blood_fat
	multiplicative_slowdown = 1

/datum/movespeed_modifier/blood_slim
	multiplicative_slowdown = -0.5


/obj/item/reagent_containers/spray/pepper/kuei_jin
	stream_mode = 1
	stream_range = 5
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/consumable/condensedcapsaicin = 50, /datum/reagent/blood = 20)

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin
	name = "blood splatter"
	desc = "Just a moving blood splatter on the floor..."
	icon = 'icons/effects/blood.dmi'
	icon_state = "floor1"
	icon_living = "floor1"
	speed = 5
	maxHealth = 100
	health = 100
	melee_damage_lower = 1
	melee_damage_upper = 1
	a_intent = INTENT_HELP
	attack_verb_continuous = "splashes"
	attack_verb_simple = "splash"

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin/Initialize()
	. = ..()
	icon_state = "floor[rand(1, 7)]"
	icon_living = "floor[rand(1, 7)]"

/mob/living/simple_animal/hostile/bloodcrawler/kuei_jin/Crossed(atom/movable/O)
	. = ..()
	if(ishuman(O))
		var/mob/living/carbon/C = O
		to_chat(C, "<span class='notice'>You slipped[ O ? " on the [O.name]" : ""]!</span>")
		playsound(C.loc, 'sound/misc/slip.ogg', 50, TRUE)

		SEND_SIGNAL(C, COMSIG_ON_CARBON_SLIP)
		for(var/obj/item/I in C.held_items)
			C.accident(I)

		C.moving_diagonally = 0 //If this was part of diagonal move slipping will stop it.
		C.Knockdown(2 SECONDS)

/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler/kuei_jin
	shapeshift_type = /mob/living/simple_animal/hostile/bloodcrawler/kuei_jin

/obj/item/gun/magic/blood_shintai
	name = "blood spit"
	desc = "Spit blood on your targets."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "leaper"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL | NOBLUDGEON
	flags_1 = NONE
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	ammo_type = /obj/item/ammo_casing/magic/blood_shintai
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_charges = 1
	fire_delay = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	item_flags = DROPDEL

/obj/item/ammo_casing/magic/blood_shintai
	name = "blood spit"
	desc = "A spit."
	projectile_type = /obj/projectile/blood_wave
	caliber = CALIBER_TENTACLE
	firing_effect_type = null
	item_flags = DROPDEL

/obj/item/gun/magic/blood_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/projectile/blood_wave
	name = "blood wave"
	icon_state = "leaper"
	speed = 0.8
	animate_movement = SLIDE_STEPS
	ricochets_max = 5
	ricochet_chance = 100
	ricochet_decay_chance =1
	ricochet_decay_damage = 1

	damage = 75
	damage_type = BRUTE
	armour_penetration = 50
	range = 200 //due to side steps, it basically made the range quadaruple times smaller or 1/4th
	stun = 20
	eyeblur = 20
	dismemberment = 20

	impact_effect_type = /obj/effect/temp_visual/impact_effect

	hit_stunned_targets = TRUE

//BLOOD SHINTAI 1
/datum/discipline_power/chi_discipline_power/blood/one
	name = "Premeate (WIP DOESNT WORK!!)"
	desc = "HChi power description"

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	violates_masquerade = TRUE
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/blood/two,
		/datum/discipline_power/chi_discipline_power/blood/three,
		/datum/discipline_power/chi_discipline_power/blood/four,
		/datum/discipline_power/chi_discipline_power/blood/five
	)

	var/result
	var/matrix/inflating_matrix = matrix()
	var/matrix/initial_inflating = matrix()
	var/matrix/shrinking_matrix = matrix()
	var/matrix/initial_shrinking = matrix()

/*
/datum/discipline_power/chi_discipline_power/blood/one/activate()




 I DO NOT KNOW HOW TO MAKE THIS ALL FUCKING WORK!!!!
	. = ..()
	if(result == "Inflate")
		result = "Inflate"
		inflating_matrix.Scale(1.2, 1)
		animate(owner, transform = inflating_matrix, 1 SECONDS)
		owner.physiology.armor.melee += 20
		owner.physiology.armor.bullet += 20
		owner.add_movespeed_modifier(/datum/movespeed_modifier/blood_fat)
	else if(result == "Shrink")
		result = "Shrink"
		shrinking_matrix.Scale(0.8, 1)
		animate(owner, transform = shrinking_matrix, 1 SECONDS)
		owner.add_movespeed_modifier(/datum/movespeed_modifier/blood_slim)
*/
/*
/datum/discipline_power/chi_discipline_power/blood/one/deactivate()



	. = ..()
	if(result == "Inflate")
		var/matrix/initial_matrix = owner.initial(transform)
		animate(owner, transform = initial_matrix , 1 SECONDS)
		owner.physiology.armor.melee -= 20
		owner.physiology.armor.bullet -= 20
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/blood_fat)
	else if(result == "Shrink")
		var/matrix/initial_matrix = owner.initial(transform)
		animate(owner, transform = initial_matrix, 1 SECONDS)
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/blood_slim)
*/


//BLOOD SHINTAI 2
/datum/discipline_power/chi_discipline_power/blood/two
	name = "Blood Atemi"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK
	violates_masquerade = TRUE
	cooldown_length = 5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/blood/one,
		/datum/discipline_power/chi_discipline_power/blood/three,
		/datum/discipline_power/chi_discipline_power/blood/four,
		/datum/discipline_power/chi_discipline_power/blood/five
	)

/datum/discipline_power/chi_discipline_power/blood/two/activate()
	. = ..()
	playsound(get_turf(owner), 'code/modules/wod13/sounds/spit.ogg', 50, FALSE)
	spawn(1 SECONDS)
		var/obj/item/reagent_containers/spray/pepper/kuei_jin/sprayer = new (get_turf(owner))
		//spits the weird pepper spray 3 tiles ahead of the owner
		var/turf/sprayed_at_turf = get_turf(owner)
		for (var/i in 1 to 5)
			sprayed_at_turf = get_step(sprayed_at_turf, owner.dir)
		sprayer.spray(sprayed_at_turf, owner)
		qdel(sprayer)


//BLOOD SHINTAI 3
/datum/discipline_power/chi_discipline_power/blood/three
	name = "Flow Like Blood"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_IMMOBILE | DISC_CHECK_CAPABLE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 10 SECONDS
	cooldown_length = 10 SECONDS


	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/blood/one,
		/datum/discipline_power/chi_discipline_power/blood/two,
		/datum/discipline_power/chi_discipline_power/blood/four,
		/datum/discipline_power/chi_discipline_power/blood/five
	)
	var/obj/effect/proc_holder/spell/targeted/shapeshift/bloodcrawler/kuei_jin/bloodcrawler_shapeshift

/datum/discipline_power/chi_discipline_power/blood/three/activate()
	. = ..()
	owner.add_splatter_floor(get_turf(owner))
	owner.add_splatter_floor(get_turf(get_step(owner, owner.dir)))
	if(!bloodcrawler_shapeshift)
		bloodcrawler_shapeshift = new (owner)
	bloodcrawler_shapeshift.Shapeshift(owner)
	var/mob/living/simple_animal/hostile/host = bloodcrawler_shapeshift.myshape
	host.my_creator = null

/datum/discipline_power/chi_discipline_power/blood/three/deactivate()
	. = ..()
	var/mob/living/simple_animal/hostile/bloodcrawler/current_form = bloodcrawler_shapeshift.myshape
	if(current_form.collected_blood > 1)
		owner.adjustBruteLoss(-5*round(current_form.collected_blood/2), TRUE)
		owner.adjustFireLoss(-5*round(current_form.collected_blood/2), TRUE)
	bloodcrawler_shapeshift.Restore(bloodcrawler_shapeshift.myshape)
	owner.Stun(1.5 SECONDS)
	owner.do_jitter_animation(3 SECONDS)

//BLOOD SHINTAI 4
/datum/discipline_power/chi_discipline_power/blood/four
	name = "Bloodlash"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND

	cooldown_length =  5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/blood/one,
		/datum/discipline_power/chi_discipline_power/blood/two,
		/datum/discipline_power/chi_discipline_power/blood/three,
		/datum/discipline_power/chi_discipline_power/blood/five
	)

/datum/discipline_power/chi_discipline_power/blood/four/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/gun/magic/blood_shintai(owner))


//BLOOD SHINTAI 5
/datum/discipline_power/chi_discipline_power/blood/five
	name = "Blood Blade"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND
	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/blood/one,
		/datum/discipline_power/chi_discipline_power/blood/two,
		/datum/discipline_power/chi_discipline_power/blood/three,
		/datum/discipline_power/chi_discipline_power/blood/four
	)

/datum/discipline_power/chi_discipline_power/blood/five/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/melee/vampirearms/katana/blood(owner))


/datum/discipline_power/chi_discipline_power/blood/five/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/katana/blood/blood_katana in owner.contents)
		qdel(blood_katana)
