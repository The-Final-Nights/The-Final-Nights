/obj/item/storage/backpack/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_backpack_pickup))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_backpack_dropped))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_backpack_moved))

/obj/item/storage/backpack/proc/on_backpack_pickup(datum/source, mob/user)
	SIGNAL_HANDLER
	notify_artifacts_of_change()

/obj/item/storage/backpack/proc/on_backpack_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(notify_artifacts_of_change)), 1)

/obj/item/storage/backpack/proc/on_backpack_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(notify_artifacts_of_change)), 1)

/obj/item/storage/backpack/proc/notify_artifacts_of_change()
	for(var/obj/item/vtm_artifact/artifact in contents)
		if(artifact.identified)
			artifact.check_ownership_change()

/obj/item/vtm_artifact/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/obj/item/vtm_artifact/proc/on_pickup(datum/source, mob/user)
	SIGNAL_HANDLER
	if(!identified)
		return

	var/mob/current_holder = get_current_holder()
	if(current_holder && current_holder != owner)
		set_new_owner(current_holder)

/obj/item/vtm_artifact/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	if(!identified)
		return

	addtimer(CALLBACK(src, PROC_REF(check_ownership_change)), 1)

/obj/item/vtm_artifact/proc/on_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	if(!identified)
		return

	addtimer(CALLBACK(src, PROC_REF(check_ownership_change)), 1)

/obj/item/vtm_artifact/proc/check_ownership_change()
	var/mob/current_holder = get_current_holder()

	if(current_holder != owner)
		if(current_holder)
			set_new_owner(current_holder)
		else
			remove_ownership()

/obj/item/vtm_artifact/proc/get_current_holder()

	// artifacts only work if in a backpack
	if(istype(loc, /obj/item/storage/backpack))
		var/obj/item/storage/backpack/backpack = loc
		if(ismob(backpack.loc))
			return backpack.loc

	return null

/obj/item/vtm_artifact/proc/set_new_owner(mob/new_owner)
	if(owner == new_owner)
		return

	if(owner)
		remove_powers()

	owner = new_owner
	update_owned_amount(1)
	get_powers()

/obj/item/vtm_artifact/proc/remove_ownership()
	if(owner)
		remove_powers()
		update_owned_amount(-1)
		owner = null

/obj/item/vtm_artifact
	name = "unidentified occult fetish"
	desc = "Who knows what secrets it could contain..."
	icon_state = "arcane"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	is_magic = TRUE
	var/research_value = 0
	var/mob/living/owner
	var/true_name = "artifact"
	var/true_desc = "Debug"
	var/identified = FALSE
	var/gained_boosts = FALSE

/obj/item/vtm_artifact/proc/update_owned_amount(change)
	if(!owner || !identified)
		return

	if(!istype(owner.artifact_owned_amounts, /list))
		owner.artifact_owned_amounts = list()

	var/list/owned_amounts = owner.artifact_owned_amounts
	var/artifact_type = type

	var/current_amount = owned_amounts[artifact_type] || 0

	// Update the amount
	current_amount += change
	current_amount = max(0, current_amount)

	// Store the new amount
	owned_amounts[artifact_type] = current_amount

	// Clean up if amount reaches 0
	if(current_amount <= 0)
		owned_amounts -= artifact_type

/obj/item/vtm_artifact/proc/get_owned_amount()
	if(!owner || !identified)
		return 0

	if(!istype(owner.artifact_owned_amounts, /list))
		return 0

	var/list/owned_amounts = owner.artifact_owned_amounts
	return owned_amounts[type] || 0

/obj/item/vtm_artifact/proc/calculate_stacked_value(base_value)
	var/owned_count = get_owned_amount()
	if(owned_count <= 0)
		return 0

	var/total_value = 0
	var/current_value = base_value

	for(var/i = 1; i <= owned_count; i++)
		total_value += current_value
		current_value *= 0.2

	// Return this artifact's share of the total
	return total_value / owned_count

/obj/item/vtm_artifact/proc/identificate()
	if(!identified)
		name = true_name
		desc = true_desc
		identified = TRUE

/obj/item/vtm_artifact/proc/get_powers()
	if(!identified)
		return

/obj/item/vtm_artifact/proc/remove_powers()
	if(!identified)
		return

/obj/item/vtm_artifact/examine(mob/user)
	.=..()
	if(HAS_TRAIT(user,TRAIT_THAUMATURGY_KNOWLEDGE))
		. += "You estimate that this Artifact can be given to the archives to retrieve [research_value] research points."

// ---------------------------------------------WEEKAPAUG THISTLE-----------------------------------------------------------
/obj/item/vtm_artifact/weekapaug_thistle
	true_name = "Weekapaug Thistle"
	true_desc = "Increases combat defense."
	icon_state = "w_thistle"
	research_value = 10

/obj/item/vtm_artifact/weekapaug_thistle/get_powers()
	..()
	var/mob/living/carbon/human/H = owner
	// Base armor value of 10, with diminishing returns
	var/armor_bonus = calculate_stacked_value(10)

	H.physiology.armor.melee += armor_bonus
	H.physiology.armor.bullet += armor_bonus

	to_chat(owner, span_notice("Your armor increases by [armor_bonus] (you own [get_owned_amount()] weekapaug thistles)."))

/obj/item/vtm_artifact/weekapaug_thistle/remove_powers()
	..()
	var/mob/living/carbon/human/H = owner
	var/armor_bonus = calculate_stacked_value(10)

	H.physiology.armor.melee -= armor_bonus
	H.physiology.armor.bullet -= armor_bonus

/obj/item/vtm_artifact/tarulfang
	true_name = "Tarulfang"
	true_desc = "Decreases chance of frenzy."
	icon_state = "tarulfang"

/obj/item/vtm_artifact/tarulfang/get_powers()
	..()
	owner.frenzy_chance_boost = 5

/obj/item/vtm_artifact/tarulfang/remove_powers()
	..()
	owner.frenzy_chance_boost = 10

// ---------------------------------------------MUMMYWRAP FETISH-----------------------------------------------------------
/obj/item/vtm_artifact/mummywrap_fetish
	true_name = "Mummywrap Fetish"
	true_desc = "Passive health regeneration."
	icon_state = "m_fetish"
	research_value = 10

	COOLDOWN_DECLARE(regen_cooldown)

/obj/item/vtm_artifact/mummywrap_fetish/get_powers()
	. = ..()
	to_chat(owner, span_green("The mummywrap fetish mends your wounds every minute. ([get_owned_amount()] fetishes)."))
	if(identified && owner)
		addtimer(CALLBACK(src, PROC_REF(do_regeneration)), 40 SECONDS, TIMER_LOOP)

/obj/item/vtm_artifact/mummywrap_fetish/proc/do_regeneration()
	if(!owner || !identified)
		return

	if(!COOLDOWN_FINISHED(src, regen_cooldown))
		return

	COOLDOWN_START(src, regen_cooldown, 60 SECONDS)

	// Base healing of 15, with diminishing returns
	var/heal_amount = calculate_stacked_value(15)

	owner.adjustBruteLoss(-heal_amount)
	owner.adjustFireLoss(-heal_amount)

/obj/item/vtm_artifact/saulocept
	true_name = "Saulocept"
	true_desc = "More experience points."
	icon_state = "saulocept"

/obj/item/vtm_artifact/saulocept/get_powers()
	..()
	owner.experience_plus = 10

/obj/item/vtm_artifact/saulocept/remove_powers()
	..()
	owner.experience_plus = 0

// ---------------------------------------------GALDJUM-----------------------------------------------------------
/obj/item/vtm_artifact/galdjum
	true_name = "Galdjum"
	true_desc = "Increases disciplines duration."
	icon_state = "galdjum"
	research_value = 10

/obj/item/vtm_artifact/galdjum/get_powers()
	..()
	// Base discipline time of 25, with diminishing returns
	var/time_bonus = calculate_stacked_value(25)
	owner.discipline_time_plus += time_bonus

	to_chat(owner, span_notice("Your discipline duration increases by [time_bonus] (you own [get_owned_amount()] galdjum)."))

/obj/item/vtm_artifact/galdjum/remove_powers()
	..()
	var/time_bonus = calculate_stacked_value(25)
	owner.discipline_time_plus -= time_bonus

// ---------------------------------------------FAE CHARM-----------------------------------------------------------
/datum/movespeed_modifier/fae_charm
	multiplicative_slowdown = -0.20

/obj/item/vtm_artifact/fae_charm
	true_name = "Fae Charm"
	true_desc = "Faster movement speed."
	icon_state = "fae_charm"
	research_value = 35
	var/applied_speed_bonus = 0

/obj/item/vtm_artifact/fae_charm/get_powers()
	..()
	// Calculate total speed bonus with diminishing returns
	applied_speed_bonus = calculate_stacked_value(0.20)

	// Remove any existing modifier first
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/fae_charm)

	// Create and apply new modifier with calculated bonus
	var/datum/movespeed_modifier/fae_charm/speed_mod = new
	speed_mod.multiplicative_slowdown = -applied_speed_bonus
	owner.add_movespeed_modifier(speed_mod)

	to_chat(owner, span_notice("Your movement speed increases by [applied_speed_bonus] (you own [get_owned_amount()] fae charms)."))

/obj/item/vtm_artifact/fae_charm/remove_powers()
	..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/fae_charm)

// ---------------------------------------------HEART OF ELIZA-----------------------------------------------------------
/obj/item/vtm_artifact/heart_of_eliza
	true_name = "Heart of Eliza"
	true_desc = "Melee damage boost."
	icon_state = "h_eliza"
	research_value = 30

/obj/item/vtm_artifact/heart_of_eliza/get_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna)
		// Base melee bonus of 0.5, with diminishing returns
		var/melee_bonus = calculate_stacked_value(0.3)
		H.dna.species.meleemod += melee_bonus

		to_chat(owner, span_notice("Your melee damage increases by [melee_bonus] (you own [get_owned_amount()] hearts of eliza)."))

/obj/item/vtm_artifact/heart_of_eliza/remove_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna)
		var/melee_bonus = calculate_stacked_value(0.5)
		H.dna.species.meleemod -= melee_bonus

//// ---------------------------------------------BLOODSTAR-----------------------------------------------------------
/obj/item/vtm_artifact/bloodstar
	true_name = "Bloodstar"
	true_desc = "Increases Bloodpower duration."
	icon_state = "bloodstar"
	research_value = 10

/obj/item/vtm_artifact/bloodstar/get_powers()
	..()
	// Base bloodpower time of 50, with diminishing returns
	var/time_bonus = calculate_stacked_value(50)
	owner.bloodpower_time_plus += time_bonus

	to_chat(owner, span_notice("Your bloodpower duration increases by [time_bonus] (you own [get_owned_amount()] bloodstars)."))

/obj/item/vtm_artifact/bloodstar/remove_powers()
	..()
	var/time_bonus = calculate_stacked_value(50)
	owner.bloodpower_time_plus -= time_bonus


// ---------------------------------------------DAIMONORI-----------------------------------------------------------
/obj/item/vtm_artifact/daimonori
	true_name = "Daimonori"
	true_desc = "Increases thaumaturgy damage."
	icon_state = "daimonori"
	research_value = 20

/obj/item/vtm_artifact/daimonori/get_powers()
	..()
	// Base thaumaturgy damage of 10, with diminishing returns
	var/thaum_bonus = calculate_stacked_value(10)
	owner.thaum_damage_plus += thaum_bonus

	to_chat(owner, span_notice("Your thaumaturgy damage increases by [thaum_bonus] (you own [get_owned_amount()] of these artifacts)."))

/obj/item/vtm_artifact/daimonori/remove_powers()
	..()
	var/thaum_bonus = calculate_stacked_value(10)
	owner.thaum_damage_plus -= thaum_bonus


// ---------------------------------------------KEY OF ALAMUT-----------------------------------------------------------
/obj/item/vtm_artifact/key_of_alamut
	true_name = "Key of Alamut"
	true_desc = "Decreases incoming damage."
	icon_state = "k_alamut"
	research_value = 30

/obj/item/vtm_artifact/key_of_alamut/get_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna)
		// Base damage reduction of 0.2, with diminishing returns
		var/damage_reduction = calculate_stacked_value(0.2)

		// Ensure we don't go below minimum damage taken
		var/new_brutemod = max(0.1, H.dna.species.brutemod - damage_reduction)
		var/new_burnmod = max(0.1, H.dna.species.burnmod - damage_reduction)

		var/actual_brute_reduction = H.dna.species.brutemod - new_brutemod
		var/actual_burn_reduction = H.dna.species.burnmod - new_burnmod

		H.dna.species.brutemod = new_brutemod
		H.dna.species.burnmod = new_burnmod

		to_chat(owner, span_notice("Your damage resistance increases by [actual_brute_reduction] brute/[actual_burn_reduction] burn (you own [get_owned_amount()] keys of alamut)."))

/obj/item/vtm_artifact/key_of_alamut/remove_powers()
	..()
	var/mob/living/carbon/human/H = owner
	if(H.dna)
		var/damage_reduction = calculate_stacked_value(0.2)

		// Restore damage values, capped at reasonable maximums
		H.dna.species.brutemod = min(2.0, H.dna.species.brutemod + damage_reduction)
		H.dna.species.burnmod = min(2.0, H.dna.species.burnmod + damage_reduction)

// ---------------------------------------------ODIOUS CHALICE-----------------------------------------------------------
/obj/item/vtm_artifact/odious_chalice
	true_name = "Odious Chalice"
	true_desc = "Stores blood from every attack."
	icon_state = "o_chalice"
	var/stored_blood = 0
	research_value = 30

/obj/item/vtm_artifact/odious_chalice/examine(mob/user)
	. = ..()
	. += "[src] contains [stored_blood] blood points..."

/obj/item/vtm_artifact/odious_chalice/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!iskindred(M))
		return
	if(!stored_blood)
		return
	if(!identified)
		return
	M.adjustBruteLoss(-5*stored_blood, TRUE)
	M.adjustFireLoss(-5*stored_blood, TRUE)
	M.update_damage_overlays()
	M.update_health_hud()
	M.update_blood_hud()
	stored_blood -= floor(stored_blood * 0.10)
	playsound(M.loc,'sound/items/drink.ogg', 50, TRUE)
	return

// ---------------------------------------------BLOODSTONE-----------------------------------------------------------
/datum/action/bloodstone_track
	name = "Track Bloodstone"
	desc = "Sense the location of your bound bloodstone."
	button_icon = 'modular_tfn/modules/paths/icons/bloodstone_artifact.dmi'
	button_icon_state = "bloodstone_track"
	check_flags = AB_CHECK_CONSCIOUS
	var/obj/item/vtm_artifact/bloodstone/tracked_stone

/datum/action/bloodstone_track/New(Target, obj/item/vtm_artifact/bloodstone/stone)
	..()
	tracked_stone = stone

/datum/action/bloodstone_track/Trigger(trigger_flags)
	if(!tracked_stone)
		to_chat(owner, span_warning("The bloodstone bond has been severed."))
		Remove(owner)
		return FALSE

	var/turf/stone_turf = get_turf(tracked_stone)
	if(!stone_turf)
		to_chat(owner, span_warning("You cannot sense the bloodstone's location."))
		return FALSE

	var/area/stone_area = get_area(tracked_stone)
	to_chat(owner, span_notice("The bloodstone whispers its location: [stone_area.name] ([stone_turf.x], [stone_turf.y])"))
	return TRUE

/datum/action/bloodstone_track/IsAvailable(feedback = FALSE)
	if(!tracked_stone)
		return FALSE
	return ..()

/obj/item/vtm_artifact/bloodstone
	true_name = "Bloodstone"
	true_desc = "A pulsing crimson stone that creates a mystical bond with its identifier."
	icon = 'modular_tfn/modules/paths/icons/bloodstone_artifact.dmi'
	onflooricon = 'modular_tfn/modules/paths/icons/bloodstone_artifact.dmi'
	icon_state = "bloodstone"
	var/mob/living/carbon/human/bound_identifier // Who identified it first
	var/datum/action/bloodstone_track/tracking_action
	research_value = 15


/obj/item/vtm_artifact/bloodstone/identificate()
	..()
	if(identified && !bound_identifier)
		var/mob/living/carbon/human/user = usr
		if(ishuman(user))
			bound_identifier = user
			to_chat(user, span_warning("The bloodstone pulses with dark energy as it bonds to your essence. You will always know its location."))

			tracking_action = new /datum/action/bloodstone_track(user, src)
			tracking_action.Grant(user)

/obj/item/vtm_artifact/bloodstone/Destroy()
	if(tracking_action)
		tracking_action.Remove(bound_identifier)
		QDEL_NULL(tracking_action)
	return ..()


/obj/item/vtm_artifact/rand
	icon_state = "art_rand"

/obj/item/vtm_artifact/rand/Initialize()
	. = ..()
	if (prob(50)) //50% chance of spawning something
		var/spawn_artifact = pick(/obj/item/vtm_artifact/odious_chalice, /obj/item/vtm_artifact/key_of_alamut,
									/obj/item/vtm_artifact/daimonori, /obj/item/vtm_artifact/bloodstar,
									/obj/item/vtm_artifact/heart_of_eliza, /obj/item/vtm_artifact/fae_charm,
									/obj/item/vtm_artifact/galdjum, /obj/item/vtm_artifact/mummywrap_fetish,
									/obj/item/vtm_artifact/weekapaug_thistle, /obj/item/vtm_artifact/bloodstone,
									/obj/item/occult_book/veneficorum_artum_sanguis, /obj/item/occult_book/das_tiefe_geheimnis)
		new spawn_artifact(loc)
	qdel(src)
