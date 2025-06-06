
/datum/discipline/chi_discipline/equilibrium
	name = "Equilibrium"
	desc = "Channel the flow of the Chis not only within you but in others as well"
	icon_state = "equilibrium"
	cost_yang = 1
	cost_yin = 1
	discipline_type = "Chi"
	power_type = /datum/discipline_power/chi_discipline_power/equilibrium

/datum/discipline/chi_discipline/equilibrium/post_gain()
	. = ..()
	if (level >= 3)
		var/datum/action/rebalance/rebalance = new()
		rebalance.Grant(owner)


/datum/discipline_power/chi_discipline_power/equilibrium
	name = "Equilibrium"
	desc = "Chi power description"
	cost_yang = 1
	cost_yin = 1
	activate_sound = 'code/modules/wod13/sounds/equilibrium.ogg'

//Equilibrium 1
/datum/discipline_power/chi_discipline_power/equilibrium/chi_boost
	name = "Master Flow"
	desc = "Use the Chi within you to push yourself even further"

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 3 TURNS //Can't use the Bloodpower_time_plus since can't use owner.bloodpower_time_plus so a static increase to 3 TURNS should be okay

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/equilibrium/shift_chi,
		/datum/discipline_power/chi_discipline_power/equilibrium/group_chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/aggravate_chi,
		/datum/discipline_power/chi_discipline_power/equilibrium/area_feed
	)

/datum/discipline_power/chi_discipline_power/equilibrium/chi_boost/activate()
	. = ..()
	owner.dna.species.punchdamagehigh += 5
	owner.physiology.armor.melee += 15
	owner.physiology.armor.bullet += 15
	owner.dexterity += 2
	owner.athletics += 2
	owner.lockpicking += 2
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
	owner.do_jitter_animation(1 SECONDS)

/datum/discipline_power/chi_discipline_power/equilibrium/chi_boost/deactivate()
	. = ..()
	owner.dna.species.punchdamagehigh -= 5
	owner.physiology.armor.melee -= 15
	owner.physiology.armor.bullet -= 15
	owner.dexterity -= 2
	owner.athletics -= 2
	owner.lockpicking -= 2
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)

//Equilibrium 2
/datum/discipline_power/chi_discipline_power/equilibrium/shift_chi
	name = "Adjust Balance"
	desc = "Shift the Chi within you, from yin to yang, as well as to fuel or to derive your demon chi"

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS

	cost_yang = 0
	cost_yin = 0
	cooldown_length = 5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/equilibrium/chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/group_chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/aggravate_chi,
		/datum/discipline_power/chi_discipline_power/equilibrium/area_feed

	)

/datum/discipline_power/chi_discipline_power/equilibrium/shift_chi/activate()
	. = ..()	//Redeeming for the shift
	var/yang_shift = input(owner, "Where do you want to shift your Yang Chi?", "Chi Shift") as null|anything in list("Yin Pool", "Demon Pool", "Nowhere")
	if(yang_shift == "Yin Pool")
		var/init_yin = owner.yin_chi
		var/actually_shifted = min(min(owner.max_yin_chi, owner.yin_chi + owner.yang_chi) - init_yin, owner.yang_chi)
		owner.yang_chi -= actually_shifted
		owner.yin_chi += actually_shifted
		to_chat(owner, "<span class='warning'>You put your Yang into your Yin.</span>")
	if(yang_shift == "Demon Pool")
		var/init_demon = owner.demon_chi
		var/actually_shifted = min(min(owner.max_demon_chi, owner.demon_chi + owner.yang_chi) - init_demon, owner.yang_chi)
		owner.yang_chi -= actually_shifted
		owner.demon_chi += actually_shifted
		to_chat(owner, "<span class='warning'>You put your Yang into your Demon.</span>")

	var/yin_shift = input(owner, "Where do you want to shift your Yin Chi?", "Chi Shift") as null|anything in list("Yang Pool", "Demon Pool", "Nowhere")
	if(yin_shift == "Yang Pool")
		var/init_yang = owner.yang_chi
		var/actually_shifted = min(min(owner.max_yang_chi, owner.yang_chi + owner.yin_chi) - init_yang, owner.yin_chi)
		owner.yin_chi -= actually_shifted
		owner.yang_chi += actually_shifted
		to_chat(owner, "<span class='warning'>You put your Yin into your Yang.</span>")
	if(yin_shift == "Demon Pool")
		var/init_demon = owner.demon_chi
		var/actually_shifted = min(min(owner.max_demon_chi, owner.demon_chi + owner.yin_chi) - init_demon, owner.yin_chi)
		owner.yin_chi -= actually_shifted
		owner.demon_chi += actually_shifted
		to_chat(owner, "<span class='warning'>You put your Yin into your Demon.</span>")

	var/demon_shift = input(owner, "Where do you want to shift your Demon Chi?", "Chi Shift") as null|anything in list("Yin Pool", "Yang Pool", "Nowhere")
	if(demon_shift == "Yin Pool")
		var/init_yin = owner.yin_chi
		var/actually_shifted = min(min(owner.max_yin_chi, owner.yin_chi + owner.demon_chi) - init_yin, owner.demon_chi)
		owner.demon_chi -= actually_shifted
		owner.yin_chi += actually_shifted
		to_chat(owner, "<span class='warning'>You put your Demon into your Yin.</span>")
	if(demon_shift == "Yang Pool")
		var/init_yang = owner.yang_chi
		var/actually_shifted = min(min(owner.max_yang_chi, owner.yang_chi + owner.demon_chi) - init_yang, owner.demon_chi)
		owner.demon_chi -= actually_shifted
		owner.yang_chi += actually_shifted
		to_chat(owner, "<span class='warning'>You put your Demon into your Yang.</span>")


//Equilibrium 3
/datum/discipline_power/chi_discipline_power/equilibrium/group_chi_boost
	name = "Master Flow of Others"
	desc = "Channel the Chi of your peers and strengthen them further."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/equilibrium/chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/shift_chi,
		/datum/discipline_power/chi_discipline_power/equilibrium/aggravate_chi,
		/datum/discipline_power/chi_discipline_power/equilibrium/area_feed
	)

/datum/discipline_power/chi_discipline_power/equilibrium/group_chi_boost/activate()
	. = ..()
	for(var/mob/living/carbon/human/affected_mob in oviewers(5, owner))
		affected_mob.dna.species.punchdamagehigh += 5
		affected_mob.physiology.armor.melee += 15
		affected_mob.physiology.armor.bullet += 15
		affected_mob.dexterity += 2
		affected_mob.athletics += 2
		affected_mob.lockpicking += 2
		ADD_TRAIT(affected_mob, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)

/datum/discipline_power/chi_discipline_power/equilibrium/group_chi_boost/deactivate()
	. = ..()
	for(var/mob/living/carbon/human/affected_mob in oviewers(5, owner))
		if(affected_mob)
			affected_mob.dna.species.punchdamagehigh -= 5
			affected_mob.physiology.armor.melee -= 15
			affected_mob.physiology.armor.bullet -= 15
			affected_mob.dexterity -= 2
			affected_mob.athletics -= 2
			affected_mob.lockpicking -= 2
			REMOVE_TRAIT(affected_mob, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)

//Equilibrium 4
/datum/discipline_power/chi_discipline_power/equilibrium/aggravate_chi
	name = "Chi Interrupt"
	desc = "Disrupt the flow of your Enemies' Chi and make them writhe in pain."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS

	cooldown_length = 10 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/equilibrium/chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/shift_chi,
		/datum/discipline_power/chi_discipline_power/equilibrium/group_chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/area_feed
	)

/datum/discipline_power/chi_discipline_power/equilibrium/aggravate_chi/activate()
	. = ..()
	for(var/mob/living/affected_mob in oviewers(5, owner))
		affected_mob.AdjustKnockdown(4 SECONDS, TRUE)
		affected_mob.emote("scream")
		playsound(get_turf(affected_mob), 'code/modules/wod13/sounds/vicissitude.ogg', 75, FALSE)
		step_away(affected_mob, owner)

//Equilibrium 5
/datum/discipline_power/chi_discipline_power/equilibrium/area_feed
	name = "Mimicry of a Mandarin's Diet"
	desc = "Do a facisimile of an Elder's feed on the ambient area's chi and feed upon it with your mastery of the flow of Chi"

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	cost_yang = 0
	cost_yin = 0
	cooldown_length = 5 SECONDS

	grouped_powers = list(
		/datum/discipline_power/chi_discipline_power/equilibrium/chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/shift_chi,
		/datum/discipline_power/chi_discipline_power/equilibrium/group_chi_boost,
		/datum/discipline_power/chi_discipline_power/equilibrium/aggravate_chi
	)

/datum/discipline_power/chi_discipline_power/equilibrium/area_feed/activate()
	. = ..()
	var/area/current_area = get_area(owner)
	if(current_area.yang_chi)
		owner.yang_chi = min(owner.yang_chi + current_area.yang_chi, owner.max_yang_chi)
		to_chat(owner, "<span class='engradio'>Some <b>Yang</b> Chi energy enters you...</span>")
	if(current_area.yin_chi)
		owner.yin_chi = min(owner.yin_chi + current_area.yin_chi, owner.max_yin_chi)
		to_chat(owner, "<span class='medradio'>Some <b>Yin</b> Chi energy enters you...</span>")
	if(current_area.demon_chi > 0)
		owner.yin_chi = min(owner.yin_chi + current_area.demon_chi, owner.max_demon_chi)
		to_chat(owner, "<span class='syndradio'>Some <b>Demon</b> Chi energy enters you...</span>")
	if(current_area.demon_chi < 0)
		owner.yin_chi = min(owner.yin_chi + current_area.demon_chi, owner.max_demon_chi)
		to_chat(owner, "<span class='yellowteamradio'>This area takes away some of your <b>Demon</b> Chi energy away..</span>")


