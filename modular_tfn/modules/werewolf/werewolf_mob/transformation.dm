// this is evil
/datum/werewolf_holder/transformation
	var/datum/weakref/human_form
	var/datum/weakref/crinos_form
	var/datum/weakref/lupus_form
	var/datum/weakref/corax_form // the corax's crinos form.
	var/datum/weakref/corvid_form // the corax's raven form
	var/transformating = FALSE
	var/given_quirks = FALSE

/datum/werewolf_holder/transformation/New()
	var/mob/living/carbon/werewolf/crinos/crinos = new()
	crinos_form = WEAKREF(crinos)
	crinos = crinos_form.resolve()
	crinos?.transformator = src

	var/mob/living/carbon/werewolf/lupus/lupus = new()
	lupus_form = WEAKREF(lupus)
	lupus = lupus_form.resolve()
	lupus?.transformator = src

	var/mob/living/carbon/werewolf/corax/corax_crinos/corax = new()
	corax_form = WEAKREF(corax)
	corax = corax_form.resolve()
	corax?.transformator = src

	var/mob/living/carbon/werewolf/lupus/corvid/corvid = new()
	corvid_form = WEAKREF(corvid)
	corvid = corvid_form.resolve()
	corvid?.transformator = src

	corax?.moveToNullspace()
	corvid?.moveToNullspace()
	crinos?.moveToNullspace()
	lupus?.moveToNullspace()

/datum/werewolf_holder/transformation/Destroy()
	human_form = null
	crinos_form = null
	lupus_form = null
	corax_form = null
	corvid_form = null

	return ..()

/datum/werewolf_holder/transformation/proc/transfer_damage_and_traits(mob/living/carbon/transfer_from, mob/living/carbon/transfer_to)
	transfer_to.masquerade_score = transfer_from.masquerade_score

	var/division_parameter = transfer_from.maxHealth / transfer_to.maxHealth

	var/target_brute_damage = ceil(transfer_from.getBruteLoss() / division_parameter)
	transfer_to.setBruteLoss(target_brute_damage)
	var/target_fire_damage = ceil(transfer_from.getFireLoss() / division_parameter)
	transfer_to.setFireLoss(target_fire_damage)
	var/target_toxin_damage = ceil(transfer_from.getToxLoss() / division_parameter)
	transfer_to.setToxLoss(target_toxin_damage)
	var/target_clone_damage = ceil(transfer_from.getCloneLoss() / division_parameter)
	transfer_to.setCloneLoss(target_clone_damage)

	transfer_from.fire_stacks = transfer_to.fire_stacks
	transfer_from.on_fire = transfer_to.on_fire

	// Will kill or revive forms on transformation as necessary
	transfer_to.set_stat(transfer_from.stat)
	transfer_to.update_health_hud()

	// Transfer resting or standing between forms
	transfer_to.set_resting(transfer_from.resting)
	if(transfer_to.body_position != STANDING_UP && !transfer_to.resting && !transfer_to.buckled && !HAS_TRAIT(transfer_to, TRAIT_FLOORED))
		transfer_to.get_up(TRUE)

	transfer_organ_states(transfer_from, transfer_to)

/**
 * Transfers the state of one form's organs to those in what they're
 * transforming into. Organs that are missing will be deleted in
 * the new form, organs that were restored will be created in the
 * new form, and organ damage and flags will transfer between all
 * organs.
 *
 * Arguments:
 * * transfer_from - The mob organ states are being brought over from
 * * transfer_to - The mob receiving the old form's organ states
 */
/datum/werewolf_holder/transformation/proc/transfer_organ_states(mob/living/carbon/transfer_from, mob/living/carbon/transfer_to)
	// Organ slots the transforming mob has, but the new mob doesn't (to be added)
	var/list/surplus_organs = assoc_list_strip_value(transfer_from.internal_organs_slot) - assoc_list_strip_value(transfer_to.internal_organs_slot)
	// Organ slots the transforming mob doesn't have, but the new mob does (to be removed)
	var/list/missing_organs = assoc_list_strip_value(transfer_to.internal_organs_slot) - assoc_list_strip_value(transfer_from.internal_organs_slot)

	// Create existing organs in the new mob
	for (var/organ_slot in surplus_organs)
		var/obj/item/organ/transfer_from_organ = transfer_from.internal_organs_slot[organ_slot]

		var/adding_organ_type = transfer_from_organ.type
		var/obj/item/organ/new_organ = new adding_organ_type
		new_organ.Insert(transfer_to, TRUE)

	// Remove missing organs in the new mob
	for (var/organ_slot in missing_organs)
		var/obj/item/organ/transfer_to_organ = transfer_to.internal_organs_slot[organ_slot]
		qdel(transfer_to_organ)

	// Replicate organ condition to the new mob
	for (var/organ_slot in transfer_from.internal_organs_slot)
		var/obj/item/organ/transfer_from_organ = transfer_from.internal_organs_slot[organ_slot]
		var/obj/item/organ/transfer_to_organ = transfer_to.internal_organs_slot[organ_slot]

		// Set new organ's damage and status to old organ's damage and status
		transfer_to_organ.setOrganDamage(transfer_from_organ.damage)
		transfer_to_organ.organ_flags = transfer_from_organ.organ_flags

/datum/werewolf_holder/transformation/proc/transform(mob/living/carbon/trans, form, bypass)
	if(trans.stat == DEAD && !bypass)
		return

	if(transformating)
		// Only voluntary transformations trigger the alert
		if (!bypass)
			trans.balloon_alert(trans, "already transforming!")
		return
	if(!given_quirks)
		given_quirks = TRUE
		if(HAS_TRAIT(trans, TRAIT_DANCER))
			var/datum/action/dance/DA = new()
			DA.Grant(lupus_form)
			var/datum/action/dance/NE = new()
			NE.Grant(crinos_form)

	var/matrix/ntransform = matrix(trans.transform) //aka transform.Copy()

	if(trans.auspice.rage == 0 && form != trans.auspice.breed_form)
		to_chat(trans, "Not enough rage to transform into anything but [trans.auspice.breed_form].")
		return
	if(trans.in_frenzy)
		to_chat(trans, "You can't transform while in frenzy.")
		return

	trans.inspired = FALSE
	if(ishuman(trans))
		var/mob/living/carbon/human/human_transformation = trans
		var/datum/species/garou/G = human_transformation.dna.species
		if(G.glabro)
			if(!HAS_TRAIT(human_transformation, TRAIT_FAIR_GLABRO))
				human_transformation.remove_overlay(PROTEAN_LAYER)
			G.punchdamagelow = G.punchdamagelow-15
			G.punchdamagehigh = G.punchdamagehigh-15
			human_transformation.physique = human_transformation.physique-2
			human_transformation.physiology.armor.melee = human_transformation.physiology.armor.melee-15
			human_transformation.physiology.armor.bullet = human_transformation.physiology.armor.bullet-15
			var/matrix/M = matrix()
			M.Scale(1)
			human_transformation.transform = M
			G.glabro = FALSE
			human_transformation.update_icons()

	var/datum/language_holder/garou_lang = trans.get_language_holder()
	switch(form)
		if(FORM_LUPUS)
			for(var/spoken_language in garou_lang.spoken_languages)
				garou_lang.remove_language(spoken_language, FALSE, TRUE)

			garou_lang.grant_language(/datum/language/primal_tongue, TRUE, TRUE)
			garou_lang.grant_language(/datum/language/garou_tongue, TRUE, TRUE)
			if(iscrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(ishuman(trans))
				ntransform.Scale(1, 0.75)
		if(FORM_CRINOS)
			for(var/spoken_language in garou_lang.spoken_languages)
				garou_lang.remove_language(spoken_language, FALSE, TRUE)

			garou_lang.grant_language(/datum/language/primal_tongue, TRUE, TRUE)
			garou_lang.grant_language(/datum/language/garou_tongue, TRUE, TRUE)
			if(islupus(trans))
				var/mob/living/carbon/werewolf/lupus/lupor = trans
				if(lupor.hispo)
					ntransform.Scale(0.95, 1.25)
				else
					ntransform.Scale(1, 1.75)
			if(ishuman(trans))
				ntransform.Scale(1.25, 1.5)
		if(FORM_CORVID)
			if(iscoraxcrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(ishuman(trans))
				ntransform.Scale(1, 0.75)
		if(FORM_CORAX_CRINOS)
			if(iscorvid(trans))
				ntransform.Scale(1, 1.75)
			if(ishuman(trans))
				ntransform.Scale(1.25, 1.5)

		if(FORM_HOMID)
			for(var/spoken_language in garou_lang.understood_languages)
				garou_lang.grant_language(spoken_language, TRUE, TRUE)
			garou_lang.remove_language(/datum/language/primal_tongue, FALSE, TRUE)
			if(iscrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(iscoraxcrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(islupus(trans))
				ntransform.Scale(1, 1.5)
			if(iscorvid(trans))
				ntransform.Scale(1, 1.5)

	switch(form)
		if(FORM_LUPUS)
			if(islupus(trans))
				transformating = FALSE
				return
			if(!lupus_form)
				return
			var/mob/living/carbon/werewolf/lupus/lupus = lupus_form.resolve()
			if(!lupus)
				lupus_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)

			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				if(B)
					qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_lupus), trans, lupus), 3 SECONDS)
		if(FORM_CRINOS)
			if(iscrinos(trans))
				transformating = FALSE
				return
			if(!crinos_form)
				return
			var/mob/living/carbon/werewolf/crinos/crinos = crinos_form.resolve()
			if(!crinos)
				crinos_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				if(B)
					qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_crinos), trans, crinos), 3 SECONDS)

		if(FORM_CORVID)
			if(iscorvid(trans))
				transformating = FALSE
				return
			if(!corvid_form)
				return
			var/mob/living/carbon/werewolf/lupus/corvid/corvid = corvid_form.resolve()
			if(!corvid)
				corvid_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/corax_transform.ogg', 100, FALSE)

			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_corvid), trans, corvid), 3 SECONDS)
		if(FORM_CORAX_CRINOS)
			if(iscoraxcrinos(trans))
				transformating = FALSE
				return
			if(!corax_form)
				return
			var/mob/living/carbon/werewolf/corax/corax_crinos/cor_crinos = corax_form.resolve()
			if(!cor_crinos)
				corax_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/corax_transform.ogg', 100, FALSE)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_cor_crinos), trans, cor_crinos), 3 SECONDS)

		if(FORM_HOMID)
			if(ishuman(trans))
				transformating = FALSE
				return
			if(!human_form)
				return
			var/mob/living/carbon/human/homid = human_form.resolve()
			if(!homid)
				human_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				if(B)
					qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_homid), trans, homid, bypass), 3 SECONDS)

/datum/werewolf_holder/transformation/proc/transform_lupus(mob/living/trans, mob/living/carbon/werewolf/lupus/lupus)
	PRIVATE_PROC(TRUE)

	if(!trans.client) // [ChillRaccoon] - preventing non-player transform issues
		animate(trans, transform = null, color = "#FFFFFF")
		return
	var/items = trans.get_contents()
	for(var/obj/item/item_worn in items)
		if(item_worn)
			if(!ismob(item_worn.loc))
				continue
			trans.dropItemToGround(item_worn, TRUE)
	var/turf/current_loc = get_turf(trans)
	lupus.color = "#000000"
	lupus.forceMove(current_loc)
	animate(lupus, color = "#FFFFFF", time = 10)
	lupus.key = trans.key
	trans.moveToNullspace()
	lupus.bloodpool = trans.bloodpool
	lupus.glory = trans.glory
	lupus.wisdom = trans.wisdom
	lupus.honor = trans.honor
	lupus.renownrank = trans.renownrank
	lupus.masquerade_score = trans.masquerade_score
	lupus.nutrition = trans.nutrition
	if(trans.auspice.tribe.name == "Black Spiral Dancers" || HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		ADD_TRAIT(lupus, TRAIT_WYRMTAINTED, "wyrm_tainted")
	lupus.mind = trans.mind
	lupus.gender = trans.gender
	lupus.update_blood_hud()
	transfer_damage_and_traits(trans, lupus)
	lupus.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	lupus.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	lupus.update_icons()
	ADD_TRAIT(lupus, TRAIT_NO_HANDS, FORM_LUPUS)
	if(lupus.hispo)
		lupus.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
		lupus.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	lupus.mind.current = lupus

/datum/werewolf_holder/transformation/proc/transform_crinos(mob/living/trans, mob/living/carbon/werewolf/crinos/crinos)
	PRIVATE_PROC(TRUE)

	var/items = trans.get_contents()
	for(var/obj/item/item_worn in items)
		if(item_worn)
			if(!ismob(item_worn.loc))
				continue
			trans.dropItemToGround(item_worn, TRUE)
	var/turf/current_loc = get_turf(trans)
	crinos.color = "#000000"
	crinos.forceMove(current_loc)
	animate(crinos, color = "#FFFFFF", time = 10)
	crinos.key = trans.key
	trans.moveToNullspace()
	crinos.glory = trans.glory
	crinos.wisdom = trans.wisdom
	crinos.honor = trans.honor
	crinos.renownrank = trans.renownrank
	crinos.bloodpool = trans.bloodpool
	crinos.masquerade_score = trans.masquerade_score
	crinos.nutrition = trans.nutrition
	if(trans.auspice.tribe.name == "Black Spiral Dancers" || HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		ADD_TRAIT(crinos, TRAIT_WYRMTAINTED, "wyrm_tainted")
	crinos.mind = trans.mind
	crinos.gender = trans.gender
	crinos.update_blood_hud()
	crinos.physique = crinos.physique+3
	transfer_damage_and_traits(trans, crinos)
	crinos.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	crinos.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	crinos.update_icons()
	crinos.mind.current = crinos

/datum/werewolf_holder/transformation/proc/transform_cor_crinos(mob/living/trans, mob/living/carbon/werewolf/corax/corax_crinos/cor_crinos)
	PRIVATE_PROC(TRUE)

	var/items = trans.get_contents()
	for(var/obj/item/item_worn in items)
		if(item_worn)
			if(!ismob(item_worn.loc))
				continue
			trans.dropItemToGround(item_worn, TRUE)

	var/turf/current_loc = get_turf(trans)
	cor_crinos.color = "#000000"
	cor_crinos.forceMove(current_loc)
	animate(cor_crinos, color = "#FFFFFF", time = 10)
	cor_crinos.key = trans.key
	trans.moveToNullspace()
	cor_crinos.glory = trans.glory
	cor_crinos.wisdom = trans.wisdom
	cor_crinos.honor = trans.honor
	cor_crinos.renownrank = trans.renownrank
	cor_crinos.bloodpool = trans.bloodpool
	cor_crinos.masquerade_score = trans.masquerade_score
	cor_crinos.nutrition = trans.nutrition
	if(HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		ADD_TRAIT(cor_crinos, TRAIT_WYRMTAINTED, "wyrm_tainted")
	cor_crinos.mind = trans.mind
	cor_crinos.gender = trans.gender
	cor_crinos.update_blood_hud()
	cor_crinos.physique = cor_crinos.physique+3
	transfer_damage_and_traits(trans, cor_crinos)
	cor_crinos.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	cor_crinos.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	cor_crinos.update_icons()
	cor_crinos.mind.current = cor_crinos

/datum/werewolf_holder/transformation/proc/transform_homid(mob/living/trans, mob/living/carbon/human/homid, bypass)
	PRIVATE_PROC(TRUE)

	if(!trans.client && !bypass) // [ChillRaccoon] - preventing non-player transform issues
		animate(trans, transform = null, color = "#FFFFFF")
		return
	var/items = trans.get_contents()
	for(var/obj/item/item_worn in items)
		if(item_worn)
			if(!ismob(item_worn.loc))
				continue
			trans.dropItemToGround(item_worn, TRUE)
	var/turf/current_loc = get_turf(trans)
	homid.color = "#000000"
	homid.forceMove(current_loc)
	animate(homid, color = "#FFFFFF", time = 10)
	homid.key = trans.key
	trans.moveToNullspace()
	homid.glory = trans.glory
	homid.wisdom = trans.wisdom
	homid.honor = trans.honor
	homid.renownrank = trans.renownrank
	homid.bloodpool = trans.bloodpool
	homid.masquerade_score = trans.masquerade_score
	homid.nutrition = trans.nutrition
	homid.mind = trans.mind
	homid.gender = trans.gender
	homid.update_blood_hud()
	transfer_damage_and_traits(trans, homid)
	homid.remove_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	homid.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	homid.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	homid.update_body()
	homid.mind.current = homid

/datum/werewolf_holder/transformation/proc/transform_corvid(mob/living/trans, mob/living/carbon/werewolf/lupus/corvid/corvid)
	PRIVATE_PROC(TRUE)

	if(!trans.client) // [ChillRaccoon] - preventing non-player transform issues
		animate(trans, transform = null, color = "#FFFFFF")
		return
	var/items = trans.get_contents()
	for(var/obj/item/item_worn in items)
		if(item_worn)
			if(!ismob(item_worn.loc))
				continue
			trans.dropItemToGround(item_worn, TRUE)
	var/turf/current_loc = get_turf(trans)
	corvid.color = "#000000"
	corvid.forceMove(current_loc)
	animate(corvid, color = "#FFFFFF", time = 10)
	corvid.key = trans.key
	trans.moveToNullspace()
	corvid.glory = trans.glory
	corvid.wisdom = trans.wisdom
	corvid.honor = trans.honor
	corvid.renownrank = trans.renownrank
	corvid.bloodpool = trans.bloodpool
	corvid.masquerade_score = trans.masquerade_score
	corvid.nutrition = trans.nutrition
	corvid.mind = trans.mind
	corvid.gender = trans.gender
	corvid.update_blood_hud()
	transfer_damage_and_traits(trans, corvid)
	corvid.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	corvid.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	corvid.update_icons()
	if(corvid.hispo) // shouldn't ever be called, but you know..
		corvid.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
		corvid.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	corvid.mind.current = corvid
