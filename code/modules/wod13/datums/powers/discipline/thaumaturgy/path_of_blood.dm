/datum/discipline/thaumaturgy
	name = "Thaumaturgy"
	desc = "Opens the secrets of blood magic and how you use it, allows to steal other's blood. Violates Masquerade."
	icon_state = "thaumaturgy"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/thaumaturgy

/datum/discipline/thaumaturgy/post_gain()
	. = ..()
	owner.faction |= CLAN_TREMERE
	var/datum/action/thaumaturgy/thaumaturgy = new()
	thaumaturgy.Grant(owner)
	thaumaturgy.level = level
	ADD_TRAIT(owner, TRAIT_THAUMATURGY_KNOWLEDGE, DISCIPLINE_TRAIT)
	owner.mind.teach_crafting_recipe(/datum/crafting_recipe/arctome)

/datum/discipline_power/thaumaturgy
	name = "Thaumaturgy power name"
	desc = "Thaumaturgy power description"

	activate_sound = 'code/modules/wod13/sounds/thaum.ogg'

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 1 TURNS
	var/success_count

/datum/discipline_power/thaumaturgy/activate(atom/target)
	. = ..()
	//Thaumaturgy powers have different effects based off the amount of successes. I dont want to copy paste the code, so this is being put here.
	success_count = SSroll.storyteller_roll(dice = owner.st_get_stat(STAT_PERMANENT_WILLPOWER), difficulty = (level + 3), numerical = TRUE, mobs_to_show_output = owner, force_chat_result = TRUE)
	if(success_count < 0)
		thaumaturgy_botch_effect()
		return TRUE
	else if(success_count == 0)
		to_chat(owner, span_notice("Your magic fizzles out!"))
		return TRUE
	return FALSE

/datum/discipline_power/thaumaturgy/proc/thaumaturgy_botch_effect()
	var/random_effect = rand(1, 3)
	switch(random_effect)
		if(1)
			to_chat(owner, span_userdanger("You feel like something snapped inside of you!"))
			for(var/obj/item/bodypart/limb in owner.bodyparts)
				var/type_wound = pick(list(/datum/wound/blunt/critical, /datum/wound/blunt/severe, /datum/wound/blunt/critical, /datum/wound/blunt/severe, /datum/wound/blunt/moderate))
				limb.force_wound_upwards(type_wound)
		if(2)
			to_chat(owner, span_userdanger("You feel like there's a sun inside of you!"))
			owner.adjust_fire_stacks(5)
			owner.IgniteMob()
		if(3)
			to_chat(owner, span_userdanger("You feel slightly less competent!"))
			owner.st_add_stat_mod(STAT_TEMPORARY_WILLPOWER, -1, "thaummaturgy_failure")

//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/a_taste_for_blood
	name = "A Taste for Blood"
	desc = "Touch the blood of a subject and gain information about the subject."

	level = 1
	range = 1
	check_flags = DISC_CHECK_FREE_HAND | DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	target_type = TARGET_OBJ
	aggravating = FALSE
	hostile = FALSE
	violates_masquerade = FALSE

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

// This'd also should show the last time the blood owner's person last fed, but we dont track that and I frankly dont want to.
/datum/discipline_power/thaumaturgy/a_taste_for_blood/activate(atom/target)
	if(..())
		return
	var/datum/reagent/blood/blood = target.reagents.has_reagent(/datum/reagent/blood) || target.reagents.has_reagent(/datum/reagent/blood/vitae)
	if(!blood)
		to_chat(owner, span_notice("This blood tastes bland."))
		return

	var/mob/living/carbon/human/blood_owner = blood.data["donor"]
	if(!blood_owner)
		to_chat(owner, span_notice("This blood tastes bland."))
		return

	var/list/message = list()
	var/is_kindred = TRUE //For if we show the blood points part.

	if(success_count > 1)
		if(iskindred(blood_owner))
			message += span_notice("The blood tastes like a kindred's blood.")
		else
			message += span_danger("The blood doesn't taste like that of a kindred's.")
			is_kindred = FALSE
	else
		message += span_danger("The blood doesn't taste like that of a kindred's.")
		is_kindred = FALSE

	if(!is_kindred)
		to_chat(owner, boxed_message(jointext(message, "\n")))
		return

	if(success_count > 2)
		message += span_notice("This blood tastes like that of the [blood_owner.generation]\th generation.")
	else
		message += span_notice("This blood tastes like that of the [rand(LOWEST_GENERATION_LIMIT, blood_owner.generation)]\th generation.")

	if(success_count > 3)
		message += span_notice("The owner of the blood has [blood_owner.bloodpool] blood points left.")
	else
		message += span_notice("The owner of the blood has [rand(1, blood_owner.bloodpool)] blood points left.")

	if(success_count > 4)
		if(blood_owner.client.prefs.diablerist)
			message += span_danger("The owner of this blood has commmited the act of Diablerie in their past.")
	else if(success_count <= 0) //Botches.
		message += span_danger("The owner of this blood has commmited the act of Diablerie in their past.")

	to_chat(owner, boxed_message(jointext(message, "\n")))

//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/blood_rage
	name = "Blood Rage"
	desc = "Impose your will on another Kindred's vitae and force them to spend it as you wish."

	effect_sound = 'sound/magic/demon_consume.ogg'

	level = 2
	range = 1
	check_flags = DISC_CHECK_FREE_HAND | DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	target_type = TARGET_VAMPIRE | TARGET_SELF
	aggravating = FALSE
	hostile = FALSE
	violates_masquerade = FALSE

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/theft_of_vitae,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

// "Each success forces the subject to spend one blood point immediately in the way the caster desires" -v20 Core Rulebook
/datum/discipline_power/thaumaturgy/blood_rage/activate(mob/living/carbon/human/target)
	if(..())
		return
	var/datum/species/kindred/kindred_species = target.dna.species // Get the vampire's species
	for(var/i in 1 to success_count)
		var/datum/discipline/random_discipline = pick(kindred_species.disciplines) //Choose a random discipline that they have
		var/datum/discipline_power/random_discipline_power = pick(random_discipline.known_powers) //Choose a random level of that discipline
		random_discipline_power.activate(target) //Activate it at themselves.

	target.apply_status_effect(/datum/status_effect/blood_rage, target, success_count)

//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/blood_of_potency
	name = "Blood of Potency"
	desc = "Supernaturally thicken your vitae as if you were of a lower Generation."

	level = 3

	duration_length = 0 // This power's length depends on the amount chosen by the user.
	cooldown_override = TRUE // This power can only be used once per night.

	target_type = NONE
	check_flags = DISC_CHECK_TORPORED
	aggravating = FALSE
	hostile = FALSE
	violates_masquerade = FALSE

	grouped_powers = list()
	var/activated = FALSE

/datum/discipline_power/thaumaturgy/blood_of_potency/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(activated)
		if(alert)
			to_chat(owner, span_warning("You cannot cast [src] more than once per night!"))
		return FALSE
	return TRUE

/datum/discipline_power/thaumaturgy/blood_of_potency/activate()
	if(..())
		return
	if(owner.generation <= 4)
		to_chat(owner, span_warning("You can't make your blood any more powerful!"))
		return
	var/points_to_spend = success_count
	var/chosen_generation
	var/set_time

	var/list/generation_choices = list()
	for(var/i in 1 to points_to_spend)
		generation_choices += clamp((owner.generation - i), 4, HIGHEST_GENERATION_LIMIT) //No becoming an Antediluvian.
	chosen_generation = tgui_input_list(owner, "What Generation would you like to lower your blood's potency to?", "Generation", uniqueList(generation_choices), null)

	if(!chosen_generation)
		chosen_generation = owner.generation - 1

	points_to_spend -= (owner.generation - chosen_generation)

	var/list/time_choices = list()
	for(var/i in 1 to points_to_spend)
		time_choices += i
	set_time = tgui_input_list(owner, "How many hours do you want this to last?", "Time", time_choices, 1)
	if(!set_time)
		set_time = 1

	chosen_generation = max(BLOOD_POTENCY_GENERATION, chosen_generation) //Lowest im gonna let you go is BLOOD_POTENCY_GENERATION bucko
	owner.apply_status_effect(/datum/status_effect/blood_of_potency, chosen_generation, set_time INGAME_HOURS)
	activated = TRUE

/datum/discipline_power/thaumaturgy/blood_of_potency/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/blood_of_potency)

//------------------------------------------------------------------------------------------------

/datum/discipline_power/thaumaturgy/theft_of_vitae
	name = "Theft of Vitae"
	desc = "Draw your target's blood to you, supernaturally absorbing it as it flies."

	level = 4

	vitae_cost = 0 //Since 1 success should give one vitae, balancing.
	effect_sound = 'sound/magic/enter_blood.ogg'
	range = 8 // Within 50 feet (15 meters).
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED | DISC_CHECK_SEE | DISC_CHECK_DIRECT_SEE // The subject must be visible to the thaumaturge
	target_type = TARGET_MOB
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/cauldron_of_blood
	)

/datum/discipline_power/thaumaturgy/theft_of_vitae/activate(mob/living/target)
	if(..())
		return

	owner.Beam(BeamTarget = target, icon_state = "drainbeam", time = 1 SECONDS)
	target.visible_message(span_danger("[target]'s blood streams out in a torrent towards [owner]!"), span_userdanger("Your blood streams out in a torrent towards [owner]!"))
	var/blood_taken = clamp(success_count, 0, target.bloodpool)
	target.bloodpool = max(target.bloodpool - blood_taken, 0)

	var/blood_gained = blood_taken * max(1, target.bloodquality-1)
	owner.bloodpool = min(owner.bloodpool + blood_gained, owner.maxbloodpool)

//------------------------------------------------------------------------------------------------

//CAULDRON OF BLOOD
/datum/discipline_power/thaumaturgy/cauldron_of_blood
	name = "Cauldron of Blood"
	desc = "Boil your target's blood in their body, killing almost anyone."

	level = 5
	range = 1 //The Kindred must touch the subject
	check_flags = DISC_CHECK_FREE_HAND | DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	target_type = TARGET_MOB | TARGET_SELF
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	grouped_powers = list(
		/datum/discipline_power/thaumaturgy/a_taste_for_blood,
		/datum/discipline_power/thaumaturgy/blood_rage,
		/datum/discipline_power/thaumaturgy/theft_of_vitae
	)

/datum/discipline_power/thaumaturgy/cauldron_of_blood/activate(mob/living/target)
	if(..())
		return

	target.visible_message(span_danger("As [owner] touches [target], their body seems to boil!"), span_userdanger("As [owner] touches you, your body feels like it's boiling in a pool of lava!"))
	playsound(target, pick('sound/effects/wounds/sizzle1.ogg', 'sound/effects/wounds/sizzle2.ogg'), 50, TRUE)
	target.bloodpool = max(target.bloodpool - success_count, 0)
	if(isnpc(target))
		target.apply_damage(success_count * 200 + owner.thaum_damage_plus, CLONE) //A single success kills any mortal
	else
		target.apply_damage(success_count * 40 + owner.thaum_damage_plus, CLONE) //8 successes = 320 aggravated damage, however this is diffulty 8 so more than 2 successes is rare.
