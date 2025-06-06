
/datum/discipline/chi_discipline/jade
	name = "Jade Shintai"
	desc = "Channel the Earth through Yang Chi"
	icon_state = "jade"
	power_type = /datum/discipline_power/chi_discipline_power/jade
	discipline_type = "Shintai"
	cost_yang = 1

/datum/discipline_power/chi_discipline_power/jade
	name = "Jade Shintai"
	desc = "Channel the Earth through Yang Chi"
	activate_sound = 'code/modules/wod13/sounds/jadeshintai_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/jadeshintai_activate.ogg'

/obj/item/melee/powerfist/stone
	name = "stone-fist"
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "stonefist"
	desc = "A stone gauntlet to punch someone."
	item_flags = DROPDEL
	fisto_setting = 2

/datum/movespeed_modifier/wall_passing
	multiplicative_slowdown = 5

//JADE 1
/datum/discipline_power/chi_discipline_power/jade/one
	name = "Stand Upon The Dragon's Back"
	desc = "HChi power description"

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	cooldown_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/jade/two,
		/datum/discipline_power/chi_discipline_power/jade/three,
		/datum/discipline_power/chi_discipline_power/jade/four,
		/datum/discipline_power/chi_discipline_power/jade/five
	)

/datum/discipline_power/chi_discipline_power/jade/one/activate()
	. = ..()
	var/obj/structure/bury_pit/burial_pit = new (get_turf(owner))
	burial_pit.icon_state = "pit0"
	owner.forceMove(burial_pit)

//JADE 2
/datum/discipline_power/chi_discipline_power/jade/two
	name = "Tread The Thrashing Dragon's Tail"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/jade/one,
		/datum/discipline_power/chi_discipline_power/jade/three,
		/datum/discipline_power/chi_discipline_power/jade/four,
		/datum/discipline_power/chi_discipline_power/jade/five
	)

/datum/discipline_power/chi_discipline_power/jade/two/activate()
	. = ..()
	owner.pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	owner.athletics += 5
	ADD_TRAIT(owner, TRAIT_SUPERNATURAL_DEXTERITY, "jade shintai 2")

/datum/discipline_power/chi_discipline_power/jade/two/deactivate()
	. = ..()
	owner.pass_flags = initial(owner.pass_flags)
	owner.athletics -= 5
	REMOVE_TRAIT(owner, TRAIT_SUPERNATURAL_DEXTERITY, "jade shintai 2")

//JADE 3
/datum/discipline_power/chi_discipline_power/jade/three
	name = "Placate the Earth Dragon"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/jade/one,
		/datum/discipline_power/chi_discipline_power/jade/two,
		/datum/discipline_power/chi_discipline_power/jade/four,
		/datum/discipline_power/chi_discipline_power/jade/five
	)

/datum/discipline_power/chi_discipline_power/jade/three/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_PASS_THROUGH_WALLS, "jade shintai 3")
	owner.alpha = 100
	owner.add_movespeed_modifier(/datum/movespeed_modifier/wall_passing)

/datum/discipline_power/chi_discipline_power/jade/three/deactivate()
	. = ..()
	owner.alpha = 255
	REMOVE_TRAIT(owner, TRAIT_PASS_THROUGH_WALLS, "jade shintai 3")
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/wall_passing)

//JADE 4
/datum/discipline_power/chi_discipline_power/jade/four
	name = "Harnessing the Dragon's Breath"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_LYING

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/jade/one,
		/datum/discipline_power/chi_discipline_power/jade/two,
		/datum/discipline_power/chi_discipline_power/jade/three,
		/datum/discipline_power/chi_discipline_power/jade/five
	)

/datum/discipline_power/chi_discipline_power/jade/four/activate()
	. = ..()
	owner.dna.species.ToggleFlight(owner)

/datum/discipline_power/chi_discipline_power/jade/four/deactivate()
	. = ..()
	owner.dna.species.ToggleFlight(owner)

//JADE 5
/datum/discipline_power/chi_discipline_power/jade/five
	name = "Jade Servant of the August Personage"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/jade/one,
		/datum/discipline_power/chi_discipline_power/jade/two,
		/datum/discipline_power/chi_discipline_power/jade/three,
		/datum/discipline_power/chi_discipline_power/jade/four
	)

/datum/discipline_power/chi_discipline_power/jade/five/activate()
	. = ..()
	owner.remove_overlay(POTENCE_LAYER)
	var/mutable_appearance/fortitude_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "[owner.base_body_mod]rock", -POTENCE_LAYER)
	owner.overlays_standing[POTENCE_LAYER] = fortitude_overlay
	owner.apply_overlay(POTENCE_LAYER)
	owner.physiology.armor.melee += 50
	owner.physiology.armor.bullet += 50
	owner.drop_all_held_items()
	owner.put_in_r_hand(new /obj/item/melee/powerfist/stone(owner))
	owner.put_in_l_hand(new /obj/item/melee/powerfist/stone(owner))
	ADD_TRAIT(owner, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)

/datum/discipline_power/chi_discipline_power/jade/five/deactivate()
	. = ..()
	owner.physiology.armor.melee -= 50
	owner.physiology.armor.bullet -= 50
	owner.remove_overlay(POTENCE_LAYER)
	REMOVE_TRAIT(owner, TRAIT_NONMASQUERADE, TRAUMA_TRAIT)
	for(var/obj/item/melee/powerfist/stone/fister in owner.contents)
		qdel(fister)
