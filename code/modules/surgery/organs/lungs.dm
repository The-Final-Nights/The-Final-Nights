/obj/item/organ/lungs
	var/failed = FALSE
	var/operated = FALSE //whether we can still have our damages fixed through surgery
	name = "lungs"
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY * 0.9 // fails around 16.5 minutes, lungs are one of the last organs to die (of the ones we have)

	low_threshold_passed = "<span class='warning'>You feel short of breath.</span>"
	high_threshold_passed = "<span class='warning'>You feel some sort of constriction around your chest as your breathing becomes shallow and rapid.</span>"
	now_fixed = "<span class='warning'>Your lungs seem to once again be able to hold air.</span>"
	low_threshold_cleared = "<span class='info'>You can breathe normally again.</span>"
	high_threshold_cleared = "<span class='info'>The constriction around your chest loosens as your breathing calms down.</span>"


	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/medicine/salbutamol = 5)

	//Breath damage
	//These thresholds are checked against what amounts to total_mix_pressure * (gas_type_mols/total_mols)

	var/safe_oxygen_min = 16 // Minimum safe partial pressure of O2, in kPa
	var/safe_oxygen_max = 0
	var/safe_nitro_min = 0
	var/safe_nitro_max = 0
	var/safe_co2_min = 0
	var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
	var/safe_toxins_min = 0
	///How much breath partial pressure is a safe amount of toxins. 0 means that we are immune to toxins.
	var/safe_toxins_max = 0.05
	var/SA_para_min = 1 //Sleeping agent
	var/SA_sleep_min = 5 //Sleeping agent
	var/BZ_trip_balls_min = 1 //BZ gas
	var/BZ_brain_damage_min = 10 //Give people some room to play around without killing the station
	var/gas_stimulation_min = 0.002 //Nitryl, Stimulum and Freon
	///Minimum amount of healium to make you unconscious for 4 seconds
	var/healium_para_min = 3
	///Minimum amount of healium to knock you down for good
	var/healium_sleep_min = 6

	var/cold_message = "your face freezing and an icicle forming"
	var/cold_level_1_threshold = 260
	var/cold_level_2_threshold = 200
	var/cold_level_3_threshold = 120
	var/cold_level_1_damage = COLD_GAS_DAMAGE_LEVEL_1 //Keep in mind with gas damage levels, you can set these to be negative, if you want someone to heal, instead.
	var/cold_level_2_damage = COLD_GAS_DAMAGE_LEVEL_2
	var/cold_level_3_damage = COLD_GAS_DAMAGE_LEVEL_3
	var/cold_damage_type = BURN

	var/hot_message = "your face burning and a searing heat"
	var/heat_level_1_threshold = 360
	var/heat_level_2_threshold = 400
	var/heat_level_3_threshold = 1000
	var/heat_level_1_damage = HEAT_GAS_DAMAGE_LEVEL_1
	var/heat_level_2_damage = HEAT_GAS_DAMAGE_LEVEL_2
	var/heat_level_3_damage = HEAT_GAS_DAMAGE_LEVEL_3
	var/heat_damage_type = BURN

	var/crit_stabilizing_reagent = /datum/reagent/medicine/epinephrine

/obj/item/organ/lungs/proc/check_breath(mob/living/carbon/human/breather)
	if(breather.status_flags & GODMODE)
		breather.failed_last_breath = FALSE //clear oxy issues
		breather.clear_alert("not_enough_oxy")
		return
	if(HAS_TRAIT(breather, TRAIT_NOBREATH))
		return

	if(breather.health >= breather.crit_threshold)
		breather.adjustOxyLoss(-5)
		breather.clear_alert("not_enough_oxy")

	handle_breath_temperature(breather)
	return TRUE


/obj/item/organ/lungs/proc/handle_too_little_breath(mob/living/carbon/human/suffocator = null, breath_pp = 0, safe_breath_min = 0, true_pp = 0)
	. = 0
	if(!suffocator || !safe_breath_min) //the other args are either: Ok being 0 or Specifically handled.
		return FALSE

	if(prob(20))
		suffocator.emote("gasp")
	if(breath_pp > 0)
		var/ratio = safe_breath_min/breath_pp
		suffocator.adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS)) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!
		suffocator.failed_last_breath = TRUE
		. = true_pp*ratio/6
	else
		suffocator.adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		suffocator.failed_last_breath = TRUE


/obj/item/organ/lungs/proc/handle_breath_temperature(mob/living/carbon/human/breather) // called by human/life, handles temperatures
	var/breath_temperature = get_temperature()

	if(!HAS_TRAIT(breather, TRAIT_RESISTCOLD)) // COLD DAMAGE
		var/cold_modifier = breather.dna.species.coldmod
		if(breath_temperature < cold_level_3_threshold)
			breather.apply_damage(cold_level_3_damage * cold_modifier, cold_damage_type, spread_damage = TRUE)
		if(breath_temperature > cold_level_3_threshold && breath_temperature < cold_level_2_threshold)
			breather.apply_damage(cold_level_2_damage * cold_modifier, cold_damage_type, spread_damage = TRUE)
		if(breath_temperature > cold_level_2_threshold && breath_temperature < cold_level_1_threshold)
			breather.apply_damage(cold_level_1_damage * cold_modifier, cold_damage_type, spread_damage = TRUE)
		if(breath_temperature < cold_level_1_threshold)
			if(prob(20))
				to_chat(breather, "<span class='warning'>You feel [cold_message] in your [name]!</span>")

	if(!HAS_TRAIT(breather, TRAIT_RESISTHEAT)) // HEAT DAMAGE
		var/heat_modifier = breather.dna.species.heatmod
		if(breath_temperature > heat_level_1_threshold && breath_temperature < heat_level_2_threshold)
			breather.apply_damage(heat_level_1_damage*heat_modifier, heat_damage_type, spread_damage = TRUE)
		if(breath_temperature > heat_level_2_threshold && breath_temperature < heat_level_3_threshold)
			breather.apply_damage(heat_level_2_damage*heat_modifier, heat_damage_type, spread_damage = TRUE)
		if(breath_temperature > heat_level_3_threshold)
			breather.apply_damage(heat_level_3_damage*heat_modifier, heat_damage_type, spread_damage = TRUE)
		if(breath_temperature > heat_level_1_threshold)
			if(prob(20))
				to_chat(breather, "<span class='warning'>You feel [hot_message] in your [name]!</span>")

/obj/item/organ/lungs/on_life(delta_time, times_fired)
	. = ..()
	if(failed && !(organ_flags & ORGAN_FAILING))
		failed = FALSE
		return
	if(damage >= low_threshold)
		var/do_i_cough = DT_PROB((damage < high_threshold) ? 2.5 : 5, delta_time) // between : past high
		if(do_i_cough)
			owner.emote("cough")
	if(organ_flags & ORGAN_FAILING && owner.stat == CONSCIOUS)
		owner.visible_message("<span class='danger'>[owner] grabs [owner.p_their()] throat, struggling for breath!</span>", "<span class='userdanger'>You suddenly feel like you can't breathe!</span>")
		failed = TRUE

/obj/item/organ/lungs/get_availability(datum/species/owner_species)
	return !(TRAIT_NOBREATH in owner_species.inherent_traits)

/obj/item/organ/lungs/plasmaman
	name = "plasma filter"
	desc = "A spongy rib-shaped mass for filtering plasma from the air."
	icon_state = "lungs-plasma"

	safe_oxygen_min = 0 //We don't breath this
	safe_toxins_min = 16 //We breath THIS!
	safe_toxins_max = 0

/obj/item/organ/lungs/slime
	name = "vacuole"
	desc = "A large organelle designed to store oxygen and other important gasses."

	safe_toxins_max = 0 //We breathe this to gain POWER.

/obj/item/organ/lungs/cybernetic
	name = "basic cybernetic lungs"
	desc = "A basic cybernetic version of the lungs found in traditional humanoid entities."
	icon_state = "lungs-c"
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = STANDARD_ORGAN_THRESHOLD * 0.5

	var/emp_vulnerability = 80 //Chance of permanent effects if emp-ed.

/obj/item/organ/lungs/cybernetic/tier2
	name = "cybernetic lungs"
	desc = "A cybernetic version of the lungs found in traditional humanoid entities. Allows for greater intakes of oxygen than organic lungs, requiring slightly less pressure."
	icon_state = "lungs-c-u"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	safe_oxygen_min = 13
	emp_vulnerability = 40

/obj/item/organ/lungs/cybernetic/tier3
	name = "upgraded cybernetic lungs"
	desc = "A more advanced version of the stock cybernetic lungs. Features the ability to filter out lower levels of toxins and carbon dioxide."
	icon_state = "lungs-c-u2"
	safe_toxins_max = 20
	safe_co2_max = 20
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	safe_oxygen_min = 13
	emp_vulnerability = 20

	cold_level_1_threshold = 200
	cold_level_2_threshold = 140
	cold_level_3_threshold = 100

/obj/item/organ/lungs/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		owner.losebreath += 20
		COOLDOWN_START(src, severe_cooldown, 30 SECONDS)
	if(prob(emp_vulnerability/severity)) //Chance of permanent effects
		organ_flags |= ORGAN_SYNTHETIC_EMP //Starts organ faliure - gonna need replacing soon.
