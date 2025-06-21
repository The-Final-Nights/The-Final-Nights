// this is evil
// todo: use a datum or something instead lol
/datum/werewolf_holder/transformation
	var/datum/weakref/human_form
	var/datum/weakref/crinos_form
	var/datum/weakref/lupus_form
	var/datum/weakref/corax_form // the corax's crinos form.
	var/datum/weakref/corvid_form // the corax's raven form
	var/transformating = FALSE
	var/given_quirks = FALSE

// we should really initialize on creation always
// if this were a datum we'd just use New()
// but since it's an atom subtype we have to use INITIALIZE_IMMEDIATE
/datum/werewolf_holder/transformation/New()
	var/mob/living/simple_animal/werewolf/crinos/crinos = new()
	crinos_form = WEAKREF(crinos)
	crinos = crinos_form.resolve()
	crinos?.transformator = src

	var/mob/living/simple_animal/werewolf/lupus/lupus = new()
	lupus_form = WEAKREF(lupus)
	lupus = lupus_form.resolve()
	lupus?.transformator = src

	var/mob/living/simple_animal/werewolf/corax/corax_crinos/corax = new()
	corax_form = WEAKREF(corax)
	corax = corax_form.resolve()
	corax?.transformator = src

	var/mob/living/simple_animal/werewolf/lupus/corvid/corvid = new()
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

/datum/werewolf_holder/transformation/proc/transfer_damage(mob/living/first, mob/living/second)
	second.masquerade = first.masquerade


	var/division_parameter = first.maxHealth / second.maxHealth

	var/target_brute_damage = ceil(first.getBruteLoss() / division_parameter)
	second.setBruteLoss(target_brute_damage)
	var/target_fire_damage = ceil(first.getFireLoss() / division_parameter)
	second.setFireLoss(target_fire_damage)
	var/target_toxin_damage = ceil(first.getToxLoss() / division_parameter)
	second.setToxLoss(target_toxin_damage)
	var/target_clone_damage = ceil(first.getCloneLoss() / division_parameter)
	second.setCloneLoss(target_clone_damage)

	first.fire_stacks = second.fire_stacks
	first.on_fire = second.on_fire

	second.update_stat()
	if(second.stat == CONSCIOUS)
		second.get_up(TRUE)

/datum/werewolf_holder/transformation/proc/transform(mob/living/trans, form, bypass)
	if(trans.stat == DEAD && !bypass)
		return
	if(transformating)
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

	if(trans.transformation_blocked > 0)
		to_chat(trans, "You can't seem to focus enough to transform!")
		return
	if(trans.auspice.rage == 0 && form != trans.auspice.base_breed)
		to_chat(trans, "Not enough rage to transform into anything but [trans.auspice.base_breed].")
		return
	if(trans.in_frenzy)
		to_chat(trans, "You can't transform while in frenzy.")
		return

	trans.inspired = FALSE
	if(ishuman(trans))
		var/mob/living/carbon/human/human_transformation = trans
		var/datum/species/garou/G = human_transformation.dna.species
		if(G.glabro)
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
		if("Lupus")
			for(var/spoken_language in garou_lang.spoken_languages)
				garou_lang.remove_language(spoken_language, FALSE, TRUE)

			garou_lang.grant_language(/datum/language/primal_tongue, TRUE, TRUE)
			garou_lang.grant_language(/datum/language/garou_tongue, TRUE, TRUE)
			if(iscrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(ishuman(trans))
				ntransform.Scale(1, 0.75)
		if("Crinos")
			for(var/spoken_language in garou_lang.spoken_languages)
				garou_lang.remove_language(spoken_language, FALSE, TRUE)

			garou_lang.grant_language(/datum/language/primal_tongue, TRUE, TRUE)
			garou_lang.grant_language(/datum/language/garou_tongue, TRUE, TRUE)
			if(islupus(trans))
				var/mob/living/simple_animal/werewolf/lupus/lupor = trans
				if(lupor.hispo)
					ntransform.Scale(0.95, 1.25)
				else
					ntransform.Scale(1, 1.75)
			if(ishuman(trans))
				ntransform.Scale(1.25, 1.5)
		if("Corvid")
			if(iscoraxcrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(ishuman(trans))
				ntransform.Scale(1, 0.75)
		if("Corax Crinos")
			if(iscorvid(trans))
				ntransform.Scale(1, 1.75)
			if(ishuman(trans))
				ntransform.Scale(1.25, 1.5)

		if("Homid")
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
		if("Lupus")
			if(islupus(trans))
				transformating = FALSE
				return
			if(!lupus_form)
				return
			var/mob/living/simple_animal/werewolf/lupus/lupus = lupus_form.resolve()
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
		if("Crinos")
			if(iscrinos(trans))
				transformating = FALSE
				return
			if(!crinos_form)
				return
			var/mob/living/simple_animal/werewolf/crinos/crinos = crinos_form.resolve()
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

		if("Corvid")
			if(iscorvid(trans))
				transformating = FALSE
				return
			if(!corvid_form)
				return
			var/mob/living/simple_animal/werewolf/lupus/corvid/corvid = corvid_form.resolve()
			if(!corvid)
				corvid_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/corax_transform.ogg', 100, FALSE)

			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_corvid), trans, corvid), 3 SECONDS)
		if("Corax Crinos")
			if(iscoraxcrinos(trans))
				transformating = FALSE
				return
			if(!corax_form)
				return
			var/mob/living/simple_animal/werewolf/corax/corax_crinos/cor_crinos = corax_form.resolve()
			if(!cor_crinos)
				corax_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/corax_transform.ogg', 100, FALSE)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_cor_crinos), trans, cor_crinos), 3 SECONDS)

		if("Homid")
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

/datum/werewolf_holder/transformation/proc/transform_lupus(mob/living/trans, mob/living/simple_animal/werewolf/lupus/lupus)
	PRIVATE_PROC(TRUE)

	if(trans.stat == DEAD || !trans.client) // [ChillRaccoon] - preventing non-player transform issues
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
	lupus.masquerade = trans.masquerade
	lupus.nutrition = trans.nutrition
	if(trans.auspice.tribe.name == "Black Spiral Dancers" || HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		lupus.wyrm_tainted = 1
	lupus.mind = trans.mind
	lupus.update_blood_hud()
	transfer_damage(trans, lupus)
	lupus.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	lupus.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	lupus.update_icons()
	ADD_TRAIT(lupus, TRAIT_NO_HANDS, "lupus")
	if(lupus.hispo)
		lupus.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
		lupus.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
		lupus.update_simplemob_varspeed()
	lupus.mind.current = lupus

/datum/werewolf_holder/transformation/proc/transform_crinos(mob/living/trans, mob/living/simple_animal/werewolf/crinos/crinos)
	PRIVATE_PROC(TRUE)

	if(trans.stat == DEAD)
		animate(trans, transform = null, color = "#FFFFFF")
		return
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
	crinos.bloodpool = trans.bloodpool
	crinos.masquerade = trans.masquerade
	crinos.nutrition = trans.nutrition
	if(trans.auspice.tribe.name == "Black Spiral Dancers" || HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		crinos.wyrm_tainted = 1
	crinos.mind = trans.mind
	crinos.update_blood_hud()
	crinos.physique = crinos.physique+3
	transfer_damage(trans, crinos)
	crinos.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	crinos.update_simplemob_varspeed()
	crinos.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	crinos.update_icons()
	crinos.mind.current = crinos

/datum/werewolf_holder/transformation/proc/transform_cor_crinos(mob/living/trans, mob/living/simple_animal/werewolf/corax/corax_crinos/cor_crinos)
	PRIVATE_PROC(TRUE)

	if(trans.stat == DEAD)
		animate(trans, transform = null, color = "#FFFFFF")
		return
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
	cor_crinos.bloodpool = trans.bloodpool
	cor_crinos.masquerade = trans.masquerade
	cor_crinos.nutrition = trans.nutrition
	if(HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		cor_crinos.wyrm_tainted = 1
	cor_crinos.mind = trans.mind
	cor_crinos.update_blood_hud()
	cor_crinos.physique = cor_crinos.physique+3
	transfer_damage(trans, cor_crinos)
	cor_crinos.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	cor_crinos.update_simplemob_varspeed()
	cor_crinos.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	cor_crinos.update_icons()
	cor_crinos.mind.current = cor_crinos

/datum/werewolf_holder/transformation/proc/transform_homid(mob/living/trans, mob/living/carbon/human/homid, bypass)
	PRIVATE_PROC(TRUE)

	if(((trans.stat == DEAD) || !trans.client) && !bypass) // [ChillRaccoon] - preventing non-player transform issues
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
	homid.bloodpool = trans.bloodpool
	homid.masquerade = trans.masquerade
	homid.nutrition = trans.nutrition
	homid.mind = trans.mind
	homid.update_blood_hud()
	transfer_damage(trans, homid)
	if(bypass)
		homid.adjustBruteLoss(200) //Carbon humans also have crit, and crinos + lupus dont, so if you're dead in those, add an extra 200 damage homids to make sure they are dead and dont spontaneously come back to life
	homid.remove_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	homid.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	homid.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	homid.update_body()
	homid.mind.current = homid

/datum/werewolf_holder/transformation/proc/transform_corvid(mob/living/trans, mob/living/simple_animal/werewolf/lupus/corvid/corvid)
	PRIVATE_PROC(TRUE)

	if(trans.stat == DEAD || !trans.client) // [ChillRaccoon] - preventing non-player transform issues
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
	corvid.bloodpool = trans.bloodpool
	corvid.masquerade = trans.masquerade
	corvid.nutrition = trans.nutrition
	if(HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		corvid.wyrm_tainted = 1
	corvid.mind = trans.mind
	corvid.update_blood_hud()
	transfer_damage(trans, corvid)
	corvid.add_movespeed_modifier(/datum/movespeed_modifier/lupusform)
	corvid.update_sight()
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	corvid.update_icons()
	if(corvid.hispo) // shouldn't ever be called, but you know..
		corvid.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
		corvid.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
		corvid.update_simplemob_varspeed()
	corvid.mind.current = corvid
