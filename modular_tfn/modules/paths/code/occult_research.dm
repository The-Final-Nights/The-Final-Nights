SUBSYSTEM_DEF(occult_research)
	name = "Occult Research"
	flags = SS_BACKGROUND
	wait = 60 SECONDS // How often to process research points
	var/base_research_rate = 0.5 // Base points per tick
	var/necromancy_bonus = 0.5
	var/obtenebration_bonus = 0.5
	var/list/collected_blood = list()
	COOLDOWN_DECLARE(research_notification_cooldown)

/datum/controller/subsystem/occult_research/fire(resumed = FALSE)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.client)
			continue
		if(H.stat >= HARD_CRIT)
			continue
		if(!HAS_TRAIT(H, TRAIT_THAUMATURGY_KNOWLEDGE))
			continue

		process_research_points(H)

/datum/controller/subsystem/occult_research/proc/process_research_points(mob/living/carbon/human/user)
	var/research_gain = base_research_rate

	// Check what disciplines the user has
	for(var/datum/action/discipline/D in user.actions)
		if(!D || !D.discipline)
			continue

		switch(D.discipline.name)
			if("Necromancy")
				research_gain += necromancy_bonus
			if("Obtenebration")
				research_gain += obtenebration_bonus

		user.research_points += research_gain

	if(COOLDOWN_FINISHED(src, research_notification_cooldown))
		COOLDOWN_START(src, research_notification_cooldown, 10 MINUTES)
		to_chat(user, span_notice("Your occult studies have yielded [research_gain] research points. Total: [user.research_points]"))

/mob/living/carbon/human/verb/check_research_points()
	set name = "Check Research Points"
	set category = "IC"
	set desc = "Check your current research point balance."

	if(!HAS_TRAIT(src, TRAIT_THAUMATURGY_KNOWLEDGE) && !necromancy_knowledge)
		to_chat(src, span_alert("You lack occult knowledge."))
		return

	to_chat(src, span_notice("You currently have [research_points] research points."))


// Check if blood sample has been collected and award research points
/datum/controller/subsystem/occult_research/proc/process_blood_collection(mob/living/carbon/human/caster, datum/reagent/blood/blood_sample)
	if(!blood_sample || !blood_sample.data)
		return

	var/blood_data = blood_sample.data
	var/blood_species = blood_data["species"]
	var/blood_name = blood_data["real_name"]

	var/list/allowed_species = list("Vampire", "Garou", "Ghoul", "Kuei-Jin")
	if(!(blood_species in allowed_species))
		return

	var/blood_identifier = "[blood_name]_[blood_species]"

	// check if the bloods already been collected
	if(blood_identifier in collected_blood)
		to_chat(caster, span_notice("This blood was already identified."))
		return

	collected_blood += blood_identifier

	var/research_award = 0
	var/species_name = ""
	var/research_message = ""

	switch(lowertext(blood_species))
		if("vampire")
			var/generation = blood_data["generation"]
			var/clan = blood_data["clan"]
			research_award = (14 - generation) * 5
			species_name = "Kindred"
			research_message = "You gain new insights into the [species_name] from clan [clan]! You gain [research_award] research points."
		if("garou")
			research_award = 30
			species_name = "Garou"
			research_message = "You gain [research_award] research points."
		if("ghoul")
			research_award = 5
			species_name = "Ghoul"
			research_message = "You gain [research_award] research points."
		if("kuei-jin")
			research_award = 15
			species_name = "Kuei-Jin"
			research_message = "You gain [research_award] research points."

	caster.research_points += research_award
	to_chat(caster, span_notice("[research_message]"))
