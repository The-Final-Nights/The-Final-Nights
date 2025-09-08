/datum/discipline/visceratika
	name = "Visceratika"
	desc = "The Discipline of Visceratika is the exclusive possession of the Gargoyle bloodline and is an extension of their natural affinity for stone, earth, and things made thereof."
	icon_state = "visceratika"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/visceratika

/datum/discipline_power/visceratika
	name = "Visceratika power name"
	desc = "Visceratika power description"

	activate_sound = 'code/modules/wod13/sounds/visceratika.ogg'

/datum/discipline/visceratika/post_gain()
	. = ..()
	if(level >= 4)
		owner.dna?.species.brutemod *= 0.8 // Netresult 0.4 Brute
		owner.dna?.species.burnmod *= 0.5 // Net result 1 Burn
		owner.physiology.clone_mod *= 0.9 // Net result 0.9 Clone
		ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
		ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)
		if(owner.clan?.name != CLAN_GARGOYLE)
			ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, TRAIT_CLAN)
		owner.skin_tone = "albino"
		owner.set_body_sprite("gargoyle")
		owner.update_body_parts()
		owner.update_body()


//WHISPERS OF THE CHAMBER
/datum/discipline_power/visceratika/whispers_of_the_chamber
	name = "Whispers of the Chamber"
	desc = "Sense everyone in the same area as you."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	cooldown_length = 1 SECONDS

/datum/discipline_power/visceratika/whispers_of_the_chamber/activate()
	. = ..()
	for(var/mob/living/player in GLOB.player_list)
		if(get_area(player) == get_area(owner))
			var/their_name = player.name
			if(ishuman(player))
				var/mob/living/carbon/human/human_player = player
				their_name = human_player.real_name
			to_chat(owner, "- [their_name]")

//SCRY THE HEARTHSTONE
/datum/discipline_power/visceratika/scry_the_hearthstone
	name = "Scry the Hearthstone"
	desc = "Sense the exact locations of individuals around you."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	vitae_cost = 1
	toggled = TRUE
	var/area/starting_area

/datum/discipline_power/visceratika/scry_the_hearthstone/activate()
	. = ..()
	starting_area = get_area(owner)
	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, "Visceratika Scry the Hearthstone")
	owner.update_sight()
	//visceratika 2 gives a gargoyle a heatmap of all living people in a building. if they leave the building, they need to re-cast it.
	RegisterSignal(owner, COMSIG_EXIT_AREA, PROC_REF(on_area_exited))

/datum/discipline_power/visceratika/scry_the_hearthstone/deactivate()
	. = ..()
	starting_area = null
	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, "Visceratika Scry the Hearthstone")
	owner.update_sight()
	UnregisterSignal(owner, COMSIG_EXIT_AREA)

/datum/discipline_power/visceratika/scry_the_hearthstone/proc/on_area_exited(atom/movable/source, area/old_area)
	SIGNAL_HANDLER

	to_chat(owner, span_warning("You lose your connection to the hearthstone as you leave the area."))
	try_deactivate()

//BOND WITH THE MOUNTAIN
/datum/discipline_power/visceratika/bond_with_the_mountain
	name = "Bond with the Mountain"
	desc = "Merge with your surroundings and become difficult to see."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	cancelable = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/visceratika/bond_with_the_mountain/activate()
	. = ..()
	owner.alpha = 10

/datum/discipline_power/visceratika/bond_with_the_mountain/deactivate()
	. = ..()
	owner.alpha = 255



//ARMOR OF TERRA
/datum/discipline_power/visceratika/armor_of_terra
	name = "Armor of Terra"
	desc = "Solidify into stone and become invulnerable."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	vitae_cost = 0

/datum/discipline_power/visceratika/armor_of_terra/activate()
	. = ..()
	to_chat(owner, span_danger("This is a passive ability. The Effects are already active"))


//FLOW WITHIN THE MOUNTAIN
/datum/discipline_power/visceratika/flow_within_the_mountain
	name = "Flow Within the Mountain"
	desc = "Merge with solid stone, and move through it without disturbing it."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/visceratika/flow_within_the_mountain/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_PASS_THROUGH_WALLS, "Visceratika Flow Within the Mountain")
	owner.alpha = 10

/datum/discipline_power/visceratika/flow_within_the_mountain/deactivate()
	. = ..()
	owner.alpha = 255
	REMOVE_TRAIT(owner, TRAIT_PASS_THROUGH_WALLS, "Visceratika Flow Within the Mountain")

/turf/closed/Enter(atom/movable/mover, atom/oldloc)
	if(isliving(mover))
		var/mob/living/moving_mob = mover
		if(HAS_TRAIT(moving_mob, TRAIT_PASS_THROUGH_WALLS) && (get_area(moving_mob) == get_area(src)))
			return TRUE
	return ..()

