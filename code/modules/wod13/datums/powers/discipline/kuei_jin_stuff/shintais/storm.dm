
/datum/discipline/chi_discipline/storm
	name = "Storm Shintai"
	desc = "RIDE THE LIGHTNING!!!."
	icon_state = "storm"
	power_type = /datum/discipline_power/chi_discipline_power/storm
	discipline_type = "Shintai"

/datum/discipline_power/chi_discipline_power/storm
	name = "Storm Shintai"
	desc = "RIDE THE LIGHTNING!!!."

	cost_yang = 1
	activate_sound = 'code/modules/wod13/sounds/stormshintai_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/stormshintai_activate.ogg'

/obj/item/melee/touch_attack/storm_shintai
	name = "Storm touch"
	desc = "Feel that electric buzz~"
	catchphrase = null
	on_use_sound = 'code/modules/wod13/sounds/lightning.ogg'
	icon_state = "zapper"
	inhand_icon_state = "zapper"

/obj/item/melee/touch_attack/storm_shintai/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user)) //getting hard after touching yourself would also be bad
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>You can't reach out!</span>")
		return
	var/mob/living/human_target = target
	if(human_target.anti_magic_check())
		to_chat(user, "<span class='warning'>The spell can't seem to affect [human_target]!</span>")
		to_chat(human_target, "<span class='warning'>You feel nothing but a tingle on you!</span>")
		..()
		return
	human_target.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)
	return ..()

/obj/item/gun/magic/hook/storm_shintai
	name = "electric hand"
	ammo_type = /obj/item/ammo_casing/magic/hook/storm_shintai
	icon_state = "zapper"
	inhand_icon_state = "zapper"
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	fire_sound = 'code/modules/wod13/sounds/lightning.ogg'
	max_charges = 1
	item_flags = DROPDEL | NOBLUDGEON
	force = 18

/obj/item/ammo_casing/magic/hook/storm_shintai
	name = "lightning"
	desc = "Electricity."
	projectile_type = /obj/projectile/storm_shintai
	caliber = CALIBER_HOOK
	icon_state = "hook"

/obj/item/gun/magic/hook/storm_shintai/process_fire()
	. = ..()
	if(charges == 0)
		qdel(src)

/obj/projectile/storm_shintai
	name = "lightning"
	icon_state = "spell"
	pass_flags = PASSTABLE
	damage = 0
	stamina = 20
	hitsound = 'code/modules/wod13/sounds/lightning.ogg'
	var/chain
	var/knockdown_time = (0.5 SECONDS)

/obj/projectile/storm_shintai/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state="lightning[rand(1,12)]")
		if(iscathayan(firer))
			var/mob/living/carbon/human/H = firer
			if(H.CheckEyewitness(H, H, 7, FALSE))
				H.AdjustMasquerade(-1)
	..()

/obj/projectile/storm_shintai/on_hit(atom/target)
	. = ..()
	if(ismovable(target))
		var/atom/movable/A = target
		if(A.anchored)
			return
		A.visible_message("<span class='danger'>[A] is snagged by lightning!</span>")
		playsound(get_turf(target), 'code/modules/wod13/sounds/lightning.ogg', 100, FALSE)
		if (isliving(target))
			var/mob/living/L = target
			L.Stun(1 SECONDS)
			L.electrocute_act(50, src, siemens_coeff = 1, flags = NONE)
			return

/obj/projectile/storm_shintai/Destroy()
	qdel(chain)
	return ..()


//STORM 1
/datum/discipline_power/chi_discipline_power/storm/one
	name = "Conjure the Duke of Wind"
	desc = "Conjure great winds around you to push everyone off away"

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 12 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/storm/two,
		/datum/discipline_power/chi_discipline_power/storm/three,
		/datum/discipline_power/chi_discipline_power/storm/four,
		/datum/discipline_power/chi_discipline_power/storm/five
	)
	var/wind_aura = FALSE
	effect_sound = 'code/modules/wod13/sounds/stormshintai_activate.ogg'

/datum/discipline_power/chi_discipline_power/storm/one/activate()
	. = ..()
	owner.remove_overlay(FORTITUDE_LAYER)
	var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "tornado", -FORTITUDE_LAYER)
	fortitude_overlay.alpha = 128
	owner.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
	owner.apply_overlay(FORTITUDE_LAYER)
	wind_aura = TRUE
	while(wind_aura)
		for(var/mob/living/pushed_by_wind in oviewers(2, owner))
			step_away(pushed_by_wind, owner)
		sleep(0.5 SECONDS)

/datum/discipline_power/chi_discipline_power/storm/one/deactivate()
	. = ..()
	owner.remove_overlay(FORTITUDE_LAYER)
	wind_aura = FALSE


//STORM 2
/datum/discipline_power/chi_discipline_power/storm/two
	name = "Thunderbolt's Kiss"
	desc = "Funny Electric Stun Hand."

	level = 2

	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/storm/one,
		/datum/discipline_power/chi_discipline_power/storm/three,
		/datum/discipline_power/chi_discipline_power/storm/four,
		/datum/discipline_power/chi_discipline_power/storm/five
	)

/datum/discipline_power/chi_discipline_power/storm/two/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/melee/touch_attack/storm_shintai(owner))


//STORM 3
/datum/discipline_power/chi_discipline_power/storm/three
	name = "Thunderbolt's Caress"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/storm/one,
		/datum/discipline_power/chi_discipline_power/storm/two,
		/datum/discipline_power/chi_discipline_power/storm/four,
		/datum/discipline_power/chi_discipline_power/storm/five
	)

/datum/discipline_power/chi_discipline_power/storm/three/activate()
	. = ..()
	owner.put_in_active_hand(new /obj/item/gun/magic/hook/storm_shintai(owner))

//STORM 4
/datum/discipline_power/chi_discipline_power/storm/four
	name = "Cloud Chariot"
	desc = "Fly in the Air for the Clouds carry you."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	toggled = TRUE
	duration_length = 12 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/storm/one,
		/datum/discipline_power/chi_discipline_power/storm/two,
		/datum/discipline_power/chi_discipline_power/storm/three,
		/datum/discipline_power/chi_discipline_power/storm/five
	)

/datum/discipline_power/chi_discipline_power/storm/four/activate()
	. = ..()
	owner.dna.species.ToggleFlight(owner)
	owner.remove_overlay(FORTITUDE_LAYER)
	var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "tornado", -FORTITUDE_LAYER)
	fortitude_overlay.pixel_y = -16
	owner.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
	owner.apply_overlay(FORTITUDE_LAYER)

/datum/discipline_power/chi_discipline_power/storm/four/deactivate()
	. = ..()
	owner.dna.species.ToggleFlight(owner)
	owner.remove_overlay(FORTITUDE_LAYER)

//STORM 5
/datum/discipline_power/chi_discipline_power/storm/five
	name = "The Flight of the Dragons"
	desc = "Unleash lightning all around you."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 12 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/storm/one,
		/datum/discipline_power/chi_discipline_power/storm/two,
		/datum/discipline_power/chi_discipline_power/storm/three,
		/datum/discipline_power/chi_discipline_power/storm/four
	)
	var/storm_loop = FALSE

/datum/discipline_power/chi_discipline_power/storm/five/activate()
	. = ..()
	owner.remove_overlay(FORTITUDE_LAYER)
	var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "puff_const", -FORTITUDE_LAYER)
	fortitude_overlay.alpha = 128
	owner.overlays_standing[FORTITUDE_LAYER] = fortitude_overlay
	owner.apply_overlay(FORTITUDE_LAYER)
	storm_loop = TRUE

	while(storm_loop)
		for(var/mob/living/shocked_mob in oviewers(5, owner))
			var/turf/lightning_source = get_turf(owner)
			lightning_source.Beam(shocked_mob, icon_state="lightning[rand(1,12)]", time = 0.5 SECONDS)
			shocked_mob.electrocute_act(10, src, siemens_coeff = 1, flags = NONE)
			playsound(get_turf(shocked_mob), 'code/modules/wod13/sounds/lightning.ogg', 100, FALSE)

		sleep(5 SECONDS)


/datum/discipline_power/chi_discipline_power/storm/five/deactivate()
	. = ..()
	owner.remove_overlay(FORTITUDE_LAYER)
	storm_loop = FALSE
