/datum/discipline/thaumaturgy
	name = "Thaumaturgy"
	desc = "Opens the secrets of blood magic and how you use it, allows to steal other's blood. Violates Masquerade."
	icon_state = "thaumaturgy"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/thaumaturgy

/datum/discipline/thaumaturgy/post_gain()
	. = ..()
	owner.faction |= CLAN_TREMERE
	if(level >= 1)
		var/datum/action/thaumaturgy/thaumaturgy = new()
		thaumaturgy.Grant(owner)
		thaumaturgy.level = level
		owner.thaumaturgy_knowledge = TRUE
		owner.mind.teach_crafting_recipe(/datum/crafting_recipe/arctome)
	if(level >= 3)
		var/datum/action/bloodshield/bloodshield = new()
		bloodshield.Grant(owner)
/datum/discipline_power/thaumaturgy
	name = "Thaumaturgy power name"
	desc = "Thaumaturgy power description"

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 7

	activate_sound = 'code/modules/wod13/sounds/thaum.ogg'
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	multi_activate = TRUE

//A TASTE FOR BLOOD
/obj/effect/projectile/tracer/thaumaturgy
	name = "blood beam"
	icon_state = "cult"

/obj/effect/projectile/muzzle/thaumaturgy
	name = "blood beam"
	icon_state = "muzzle_cult"

/obj/effect/projectile/impact/thaumaturgy
	name = "blood beam"
	icon_state = "impact_cult"

/obj/projectile/thaumaturgy
	name = "blood beam"
	icon_state = "thaumaturgy"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 5
	damage_type = BURN
	//hitsound = 'code/modules/wod13/sounds/bloodbeam.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = LASER
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 1
	light_color = COLOR_SOFT_RED
	ricochets_max = 0
	ricochet_chance = 0
	tracer_type = /obj/effect/projectile/tracer/thaumaturgy
	muzzle_type = /obj/effect/projectile/muzzle/thaumaturgy
	impact_type = /obj/effect/projectile/impact/thaumaturgy
	var/level = 1

/obj/projectile/thaumaturgy/on_hit(atom/target, blocked = FALSE, pierce_hit)
	if(ishuman(firer))
		var/mob/living/carbon/human/VH = firer
		if(isliving(target))
			var/mob/living/VL = target
			if(isgarou(VL))
				if(VL.bloodpool >= 1 && VL.stat != DEAD)
					var/sucked = min(VL.bloodpool, 2)
					VL.bloodpool = max(VL.bloodpool - sucked, 0)
					VL.apply_damage(45, BURN)
					VL.visible_message(span_danger("[target]'s wounds spray boiling hot blood!"), span_userdanger("Your blood boils!"))
					VL.add_splatter_floor(get_turf(target))
					VL.add_splatter_floor(get_turf(get_step(target, target.dir)))
				if(!iskindred(target))
					if(VL.bloodpool >= 1 && VL.stat != DEAD)
						var/sucked = min(VL.bloodpool, 2)
						VL.bloodpool = max(VL.bloodpool - sucked, 0)
					if(ishuman(VL))
						if(VL.bloodpool >= 1 && VL.stat != DEAD)
							var/mob/living/carbon/human/VHL = VL
							VHL.bloodpool = max(VHL.bloodpool - 1, 0)
			else
				if(VL.bloodpool >= 1)
					var/sucked = min(VL.bloodpool, level)
					VL.bloodpool = max(VL.bloodpool - sucked, 0)
					VH.bloodpool = min(VH.bloodpool + sucked, VH.maxbloodpool)

/datum/discipline_power/thaumaturgy/a_taste_for_blood
	name = "A Taste for Blood"
	desc = "Touch the blood of a subject and gain information about their bloodline."

	level = 1

	cooldown_length = 3 SECONDS

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/a_taste_for_blood/activate(mob/living/target)
	. = ..()
	var/turf/start = get_turf(owner)
	var/obj/projectile/thaumaturgy/H = new(start)
	H.firer = owner
	H.preparePixelProjectile(target, start)
	H.fire(direct_target = target)

//BLOOD RAGE
/datum/discipline_power/thaumaturgy/blood_rage
	name = "Blood Rage"
	desc = "Impose your will on another Kindred's vitae and force them to spend it as you wish."

	level = 2

	cooldown_length = 2.5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/blood_rage/activate(mob/living/target)
	. = ..()
	var/turf/start = get_turf(owner)
	var/obj/projectile/thaumaturgy/H = new(start)
	H.firer = owner
	H.damage = 10 + owner.thaum_damage_plus + owner.get_total_mentality()
	H.preparePixelProjectile(target, start)
	H.level = 2
	H.fire(direct_target = target)
	H.cruelty_multiplier = 1.1
	to_chat(target, span_danger("A bolt of boiling blood flies toward you!"))


//BLOOD OF POTENCY
/datum/discipline_power/thaumaturgy/blood_of_potency
	name = "Blood of Potency"
	desc = "Supernaturally thicken your vitae as if you were of a lower Generation."

	level = 3

	cooldown_length = 1 SECONDS

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/blood_of_potency/activate(mob/living/target)
	. = ..()
	var/turf/start = get_turf(owner)
	var/obj/projectile/thaumaturgy/H = new(start)
	H.firer = owner
	H.damage = 15 + owner.thaum_damage_plus + owner.get_total_mentality()
	H.preparePixelProjectile(target, start)
	H.level = 2
	H.fire(direct_target = target)
	H.cruelty_multiplier = 1.1
	to_chat(target, span_danger("A bolt of boiling blood flies toward you!"))


//THEFT OF VITAE
/mob/living/proc/tremere_gib()
	Stun(5 SECONDS)
	new /obj/effect/temp_visual/tremere(loc, "gib")
	animate(src, pixel_y = 16, color = "#ff0000", time = 5 SECONDS, loop = 1)

	spawn(5 SECONDS)
		if(stat != DEAD)
			death()
		var/list/items = list()
		items |= get_equipped_items(TRUE)
		for(var/obj/item/I in items)
			dropItemToGround(I)
		drop_all_held_items()
		spawn_gibs()
		spawn_gibs()
		spawn_gibs()
		qdel(src)

/datum/discipline_power/thaumaturgy/theft_of_vitae
	name = "Theft of Vitae"
	desc = "Draw your target's blood to you, supernaturally absorbing it as it flies."

	level = 4

	effect_sound = 'code/modules/wod13/sounds/vomit.ogg'

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/theft_of_vitae/activate(mob/living/target)
	. = ..()
	if(iscarbon(target))
		target.visible_message(span_danger("[target] throws up!"), span_userdanger("You throw up!"))
		target.add_splatter_floor(get_turf(target))
		target.add_splatter_floor(get_turf(get_step(target, target.dir)))
		if(target.bloodpool >= 2)
			target.bloodpool -= 2
			owner.bloodpool = min(owner.bloodpool + 3, owner.maxbloodpool) // costs 1 bp to cast so this nets 2 bps
	else
		owner.bloodpool = min(owner.bloodpool + target.bloodpool, owner.maxbloodpool)
		if(!istype(target, /mob/living/simple_animal/hostile/megafauna))
			target.tremere_gib()

//CAULDRON OF BLOOD
/datum/discipline_power/thaumaturgy/cauldron_of_blood
	name = "Cauldron of Blood"
	desc = "Boil your target's blood in their body, killing almost anyone."

	cooldown_length = 15.0 SECONDS
	level = 5

	//effect_sound = 'code/modules/wod13/sounds/bloodcauldron.ogg'

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/theft_of_vitae
	)

/datum/discipline_power/thaumaturgy/cauldron_of_blood
	name = "Cauldron of Blood"
	desc = "Boil your target's blood in their body, killing almost anyone."

	level = 5

	//effect_sound = 'code/modules/wod13/sounds/bloodcauldron.ogg'

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/blood_of_potency,
		/datum/discipline_power/thaumaturgy/theft_of_vitae
	)

/datum/discipline_power/thaumaturgy/cauldron_of_blood/activate(mob/living/target)
	. = ..()
	if(iscarbon(target))
		new /obj/effect/temp_visual/tremere(target.loc, "gib")

		target.visible_message(span_danger("[target] reddens and quakes!"), span_userdanger("Your veins feel like they're on fire!"))

		var/dice = clamp(target.get_total_physique(), 1, 8)
		var/successes = SSroll.storyteller_roll(dice, difficulty = 5, mobs_to_show_output = target, numerical = TRUE)

		if(successes <= 1)
			// All stages (fail completely)
			animate(target, pixel_y = 16, color = "#ff0000", time = 5 SECONDS, loop = 1)
			addtimer(CALLBACK(src, /datum/discipline_power/thaumaturgy/cauldron_of_blood/proc/reset_target_appearance, target), 5 SECONDS)
			addtimer(CALLBACK(src, .proc/blood_burn_stage1, target), 0)
			addtimer(CALLBACK(src, .proc/blood_burn_stage2, target), 2.5 SECONDS)
			addtimer(CALLBACK(src, .proc/blood_burn_stage3, target), 5 SECONDS)

		else if(successes == 2)
			// Stages 1 & 2
			animate(target, pixel_y = 16, color = "#ff0000", time = 2.5 SECONDS, loop = 1)
			addtimer(CALLBACK(src, /datum/discipline_power/thaumaturgy/cauldron_of_blood/proc/reset_target_appearance, target), 2.5 SECONDS)
			addtimer(CALLBACK(src, .proc/blood_burn_stage1, target), 0)
			addtimer(CALLBACK(src, .proc/blood_burn_stage2, target), 2.5 SECONDS)

		else if(successes == 3)
			animate(target, pixel_y = 16, color = "#ff0000", time = 1 SECONDS, loop = 1)
			addtimer(CALLBACK(src, /datum/discipline_power/thaumaturgy/cauldron_of_blood/proc/reset_target_appearance, target), 1 SECONDS)
			// Stage 1 only
			addtimer(CALLBACK(src, .proc/blood_burn_stage1, target), 0)

		else
			// Resisted completely
			to_chat(target, span_notice("You steel yourself as the blood begins to churn—but your will holds firm."))

	else
		owner.bloodpool = min(owner.bloodpool + target.bloodpool, owner.maxbloodpool)
		if(!istype(target, /mob/living/simple_animal/hostile/megafauna))
			target.tremere_gib()

/datum/discipline_power/thaumaturgy/cauldron_of_blood/proc/blood_burn_stage1(mob/living/target)
	if(!target) return
	target.Stun(2.5 SECONDS)
	target.apply_damage(20, BURN, owner.zone_selected)
	target.emote("twitch")
	target.visible_message(span_warning("[target] begins to violently shake!"), span_userdanger("You feel yourself trembling uncontrollably!"))
	playsound(target, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)

/datum/discipline_power/thaumaturgy/cauldron_of_blood/proc/blood_burn_stage2(mob/living/target)
	if(!target) return
	target.apply_damage(20, BURN, owner.zone_selected)
	target.emote("scream")
	target.emote("twitch")
	target.visible_message(span_warning("[target] howls in agony, their whole body convulsing!"), span_userdanger("You scream in anguish as your blood boils!"))

/datum/discipline_power/thaumaturgy/cauldron_of_blood/proc/blood_burn_stage3(mob/living/target)
	if(!target) return
	target.Stun(2.5 SECONDS)
	target.apply_damage(30, BURN, owner.zone_selected)
	target.visible_message(span_warning("[target] collapses to the floor, thrashing in torment!"), span_userdanger("IT BURNS! IT BURNS!! IT BURNS!!!"))
	target.emote("collapse")


//RUNE DRAWING
/datum/action/thaumaturgy
	name = "Thaumaturgy"
	desc = "Blood magic rune drawing."
	button_icon_state = "thaumaturgy"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_IMMOBILE | AB_CHECK_LYING | AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/drawing = FALSE
	var/level = 1

/datum/action/thaumaturgy/Trigger()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(H, span_warning("You need more <b>BLOOD</b> to do that!"))
		return
	if(drawing)
		return

	if(istype(H.get_active_held_item(), /obj/item/arcane_tome))
		var/list/rune_names = list()
		for(var/i in subtypesof(/obj/ritualrune))
			var/obj/ritualrune/R = new i(owner)
			if(R.thaumlevel <= level)
				rune_names[R.name] = i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw:", "Thaumaturgy", rune_names)
		if(ritual)
			drawing = TRUE
			if(do_after(H, 3 SECONDS * max(1, 5 - H.get_total_mentality()), H))
				drawing = FALSE
				var/ritual_type = rune_names[ritual]
				new ritual_type(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				if(H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)
			else
				drawing = FALSE
	else
		var/list/shit = list()
		for(var/i in subtypesof(/obj/ritualrune))
			var/obj/ritualrune/R = new i(owner)
			if(R.thaumlevel <= level)
				shit += i
			qdel(R)
		var/ritual = tgui_input_list(owner, "Choose rune to draw (You need an Arcane Tome to reduce random):", "Thaumaturgy", list("???"))
		if(ritual)
			drawing = TRUE
			if(do_after(H, 3 SECONDS * max(1, 5 - H.get_total_mentality()), H))
				drawing = FALSE
				var/rune = pick(shit)
				new rune(H.loc)
				H.bloodpool = max(H.bloodpool - 2, 0)
				if(H.CheckEyewitness(H, H, 7, FALSE))
					H.AdjustMasquerade(-1)
			else
				drawing = FALSE

/datum/action/bloodshield
	name = "Bloodshield"
	desc = "Gain armor with blood."
	button_icon_state = "bloodshield"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/abuse_fix = 0

/datum/action/bloodshield/Trigger()
	. = ..()
	if((abuse_fix + 25 SECONDS) > world.time)
		return
	var/mob/living/carbon/human/H = owner
	if(H.bloodpool < 2)
		to_chat(owner, span_warning("You don't have enough <b>BLOOD</b> to do that!"))
		return
	H.bloodpool = max(H.bloodpool - 2, 0)
	playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
	abuse_fix = world.time
	H.physiology.damage_resistance += 60
	animate(H, color = "#ff0000", time = 10, loop = 1)
	if(H.CheckEyewitness(H, H, 7, FALSE))
		H.AdjustMasquerade(-1)
	spawn(15 SECONDS)
		if(H)
			playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			H.physiology.damage_resistance -= 60
			H.color = initial(H.color)

/*
/datum/discipline/bloodshield
	name = "Blood shield"
	desc = "Boosts armor."
	icon_state = "bloodshield"
	cost = 2
	ranged = FALSE
	delay = 15 SECONDS
	activate_sound = 'code/modules/wod13/sounds/thaum.ogg'

/datum/discipline/bloodshield/activate(mob/living/target, mob/living/carbon/human/owner)
	..()
	var/mod = level_casting
	owner.physiology.armor.melee = owner.physiology.armor.melee+(15*mod)
	owner.physiology.armor.bullet = owner.physiology.armor.bullet+(15*mod)
	animate(owner, color = "#ff0000", time = 1 SECONDS, loop = 1)
//	owner.color = "#ff0000"
	spawn(delay+owner.discipline_time_plus)
		if(owner)
			playsound(owner.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE)
			owner.physiology.armor.melee = owner.physiology.armor.melee-(15*mod)
			owner.physiology.armor.bullet = owner.physiology.armor.bullet-(15*mod)
			owner.color = initial(owner.color)
*/

/datum/discipline_power/thaumaturgy/cauldron_of_blood/proc/reset_target_appearance(mob/living/target)
	if(!target) return
	animate(target, pixel_y = 0, color = null)
