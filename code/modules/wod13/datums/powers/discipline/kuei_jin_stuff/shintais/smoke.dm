
/datum/discipline/chi_discipline/smoke
	name = "Smoke Shintai"
	desc = "Chi Discipline smoke."
	icon_state = "smoke"
	power_type = /datum/discipline_power/chi_discipline_power/smoke
	cost_yang = 1
	discipline_type = "Shintai"

/datum/discipline_power/chi_discipline_power/smoke
	name = "Chi power name"
	desc = "Chi power description"
	activate_sound = 'code/modules/wod13/sounds/smokeshintai_activate.ogg'
	deactivate_sound ='code/modules/wod13/sounds/smokeshintai_activate.ogg'

/obj/effect/proc_holder/spell/targeted/shapeshift/smoke_form
	name = "Smoke Form"
	desc = "Take on the shape a Smoke."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/smokecrawler

/obj/effect/proc_holder/spell/targeted/shapeshift/hidden_smoke_form
	name = "Smoke Form"
	desc = "Take on the shape a Smoke."
	charge_max = 50
	cooldown_min = 50
	revert_on_death = TRUE
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/smokecrawler/hidden

/mob/living/simple_animal/hostile/smokecrawler
	name = "Smoke Form"
	desc = "Levitating fumes."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	icon_living = "smoke"
	mob_biotypes = MOB_ORGANIC
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	speak_chance = 0
	speed = 0.5
	maxHealth = 100
	health = 100
	butcher_results = list(/obj/item/stack/human_flesh = 1)
	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 1
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 0
	maxbloodpool = 0

/mob/living/simple_animal/hostile/smokecrawler/hidden
	alpha = 10
	speed = 1

/obj/effect/forcefield/smoke_wall
	desc = "A space wizard's magic wall."
	name = "FORCEWALL"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	density = TRUE
	timeleft = 30 SECONDS //Set to 0 for permanent forcefields (ugh

//SMOKE SHINTAI 1
/datum/discipline_power/chi_discipline_power/smoke/one
	name = "Chi power name 1"
	desc = "HChi power description"

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/smoke/two,
		/datum/discipline_power/chi_discipline_power/smoke/three,
		/datum/discipline_power/chi_discipline_power/smoke/four,
		/datum/discipline_power/chi_discipline_power/smoke/five
	)

/datum/discipline_power/chi_discipline_power/smoke/one/activate()
	. = ..()
	var/datum/effect_system/smoke_spread/bad/smoke = new
	smoke.set_up(discipline.level+1, owner)
	smoke.start()
	playsound(get_turf(owner), 'sound/effects/smoke.ogg', 50, TRUE)

/datum/discipline_power/chi_discipline_power/smoke/one/deactivate()
	. = ..()


//SMOKE SHINTAI 2
/datum/discipline_power/chi_discipline_power/smoke/two
	name = "Smoke Shintai 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cooldown_length = 5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/smoke/one,
		/datum/discipline_power/chi_discipline_power/smoke/three,
		/datum/discipline_power/chi_discipline_power/smoke/four,
		/datum/discipline_power/chi_discipline_power/smoke/five
	)
	var/list/available_turfs = list()

/datum/discipline_power/chi_discipline_power/smoke/two/activate()
	. = ..()
	for(var/turf/open/O in view(7, owner))
		if(O)
			available_turfs += O
	if(length(available_turfs))
		var/turf/to_move = pick(available_turfs)
		var/atom/movable/visual1 = new (get_turf(owner))
		visual1.density = FALSE
		visual1.anchored = TRUE
		visual1.layer = ABOVE_ALL_MOB_LAYER
		visual1.icon = 'code/modules/wod13/icons.dmi'
		visual1.icon_state = "puff"
		playsound(get_turf(owner), 'sound/effects/smoke.ogg', 50, TRUE)
		owner.forceMove(to_move)
		var/atom/movable/visual2 = new (to_move)
		visual2.density = FALSE
		visual1.anchored = TRUE
		visual2.layer = ABOVE_ALL_MOB_LAYER
		visual2.icon = 'code/modules/wod13/icons.dmi'
		visual2.icon_state = "puff"
		spawn(2 SECONDS)
			qdel(visual1)
			qdel(visual2)

/datum/discipline_power/chi_discipline_power/smoke/two/deactivate()
	. = ..()

//SMOKE SHINTAI 3
/datum/discipline_power/chi_discipline_power/smoke/three
	name = "Smoke Shintai 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cooldown_length = 10 SECONDS
	multi_activate = TRUE

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/smoke/one,
		/datum/discipline_power/chi_discipline_power/smoke/two,
		/datum/discipline_power/chi_discipline_power/smoke/four,
		/datum/discipline_power/chi_discipline_power/smoke/five
	)

/datum/discipline_power/chi_discipline_power/smoke/three/activate()
	. = ..()
	var/obj/effect/forcefield/smoke_wall/smoke_wall

	smoke_wall = new (get_step(owner, owner.dir))

	smoke_wall = new (get_step(get_step(owner, owner.dir), turn(owner.dir, 90)))

	smoke_wall = new (get_step(get_step(owner, owner.dir), turn(owner.dir, -90)))

	playsound(get_turf(owner), 'sound/effects/smoke.ogg', 50, TRUE)

/datum/discipline_power/chi_discipline_power/smoke/three/deactivate()
	. = ..()

//SMOKE SHINTAI 4
/datum/discipline_power/chi_discipline_power/smoke/four
	name = "Smoke Shintai 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 30 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/smoke/one,
		/datum/discipline_power/chi_discipline_power/smoke/two,
		/datum/discipline_power/chi_discipline_power/smoke/three,
		/datum/discipline_power/chi_discipline_power/smoke/five
	)
	var/obj/effect/proc_holder/spell/targeted/shapeshift/smoke_form/smoke_shapeshift

/datum/discipline_power/chi_discipline_power/smoke/four/activate()
	. = ..()
	if(!smoke_shapeshift)
		smoke_shapeshift = new(owner)
	smoke_shapeshift.Shapeshift(owner)
	var/mob/living/simple_animal/hostile/host = smoke_shapeshift.myshape
	host.my_creator = null
	playsound(get_turf(owner), 'sound/effects/smoke.ogg', 50, TRUE)

/datum/discipline_power/chi_discipline_power/smoke/four/deactivate()
	. = ..()
	smoke_shapeshift.Restore(smoke_shapeshift.myshape)
	owner.Stun(1 SECONDS)
	owner.do_jitter_animation(15)

//SMOKE SHINTAI 5
/datum/discipline_power/chi_discipline_power/smoke/five
	name = "Smoke Shintai 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_SPEAK

	cancelable = TRUE
	duration_length = 30 SECONDS
	cooldown_length = 30 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/smoke/one,
		/datum/discipline_power/chi_discipline_power/smoke/two,
		/datum/discipline_power/chi_discipline_power/smoke/three,
		/datum/discipline_power/chi_discipline_power/smoke/four
	)
	var/obj/effect/proc_holder/spell/targeted/shapeshift/hidden_smoke_form/hidden_smoke_shapeshift

/datum/discipline_power/chi_discipline_power/smoke/five/activate()
	. = ..()
	if(!hidden_smoke_shapeshift)
		hidden_smoke_shapeshift = new(owner)
	hidden_smoke_shapeshift.Shapeshift(owner)
	var/mob/living/simple_animal/hostile/host = hidden_smoke_shapeshift.myshape
	host.my_creator = null
	playsound(get_turf(owner), 'sound/effects/smoke.ogg', 50, TRUE)


/datum/discipline_power/chi_discipline_power/smoke/five/deactivate()
	. = ..()
	hidden_smoke_shapeshift.Restore(hidden_smoke_shapeshift.myshape)
	owner.Stun(1 SECONDS)
	owner.do_jitter_animation(15)
