// this is evil
// todo: use a datum or something instead lol
/datum/werewolf_holder/transformation
	var/datum/weakref/human_form
	var/datum/weakref/corax_form // the corax's crinos form.
	var/datum/weakref/corvid_form

	var/transformating = FALSE
	var/given_quirks = FALSE

// we should really initialize on creation always
// if this were a datum we'd just use New()
// but since it's an atom subtype we have to use INITIALIZE_IMMEDIATE

/datum/werewolf_holder/transformation/New()
	var/mob/living/carbon/werewolf/corax/crinos/crinos = new()
	corax_form = WEAKREF(corax)
	corax = corax_form.resolve()
	corax?.transformator = src

	var/mob/living/carbon/wereraven/corax/corvid/corvid = new()
	corvid_form = WEAKREF(corvid)
	corvid = corvid_form.resolve()
	corvid?.transformator = src

	corax?.moveToNullspace()
	corvid?.moveToNullspace()

/datum/werewolf_holder/transformation/Destroy() // Making this in it's own datum to avoid messing with Garou players
	human_form = null
	corax_form = null
	corvid_form = null

	return ..()

/datum/werewolf_holder/transformation/proc/transfer_damage(mob/living/carbon/first, mob/living/carbon/second)
	second.masquerade = first.masquerade
	var/percentage = (100/first.maxHealth)*second.maxHealth
	second.adjustBruteLoss(round((first.getBruteLoss()/100)*percentage)-second.getBruteLoss())
	second.adjustFireLoss(round((first.getFireLoss()/100)*percentage)-second.getFireLoss())
	second.adjustToxLoss(round((first.getToxLoss()/100)*percentage)-second.getToxLoss())
	second.adjustCloneLoss(round((first.getCloneLoss()/100)*percentage)-second.getCloneLoss())

/datum/werewolf_holder/transformation/proc/transform(mob/living/carbon/trans, form) //The old proc was named "trans_gender". This is a subtle reference to the devs being unfunny.
	if(trans.stat == DEAD)
		return
	if(transformating)
		trans.balloon_alert(trans, "already transforming!")
		return
	if(!given_quirks)
		given_quirks = TRUE
		if(HAS_TRAIT(trans, TRAIT_DANCER))
			var/datum/action/dance/DA = new()
			DA.Grant(corvid_form)
			var/datum/action/dance/NE = new()
			NE.Grant(corax_form)

	var/matrix/ntransform = matrix(trans.transform) //aka transform.Copy()

	if(trans.auspice.rage == 0 && form != trans.auspice.base_breed)
		to_chat(trans, "Not enough rage to transform into anything but [trans.auspice.base_breed].")
		return
	if(trans.in_frenzy)
		to_chat(trans, "You can't transform while in frenzy.")
		return

	trans.inspired = FALSE
	if(ishuman(trans))
		var/datum/species/garou/G = trans.dna.species
		var/mob/living/carbon/human/H = trans
	var/datum/language_holder/garou_lang = trans.get_language_holder()
	switch(form)
		if("Corvid")
			/*for(var/spoken_language in garou_lang.spoken_languages)
				garou_lang.remove_language(spoken_language, FALSE, TRUE) // We do not remove known languages from were-ravens, their whole shtick is "talking".

			garou_lang.grant_language(/datum/language/primal_tongue, TRUE, TRUE)
			garou_lang.grant_language(/datum/language/garou_tongue, TRUE, TRUE)*/
			if(iscoraxcrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(ishuman(trans))
				ntransform.Scale(1, 0.75)
		if("Corax Crinos")
			/*for(var/spoken_language in garou_lang.spoken_languages)
				garou_lang.remove_language(spoken_language, FALSE, TRUE)

			garou_lang.grant_language(/datum/language/primal_tongue, TRUE, TRUE)
			garou_lang.grant_language(/datum/language/garou_tongue, TRUE, TRUE)*/
			if(iscorvid(trans))
				var/mob/living/carbon/wereraven/corvid/corvid = trans
					ntransform.Scale(1, 1.75)
			if(ishuman(trans))
				ntransform.Scale(1.25, 1.5)
		if("Homid")
			for(var/spoken_language in garou_lang.understood_languages)
				garou_lang.grant_language(spoken_language, TRUE, TRUE)
			garou_lang.remove_language(/datum/language/primal_tongue, FALSE, TRUE)
			if(iscrinos(trans))
				ntransform.Scale(0.75, 0.75)
			if(iscorvid(trans))
				ntransform.Scale(1, 1.5)

	switch(form)
		if("Corvid")
			if(iscorvid(trans))
				transformating = FALSE
				return
			if(!corvid_form)
				return
			var/mob/living/carbon/wereraven/corvid/corvid = corvid_form.resolve()
			if(!corvid)
				corvid_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)

			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				if(B)
					qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_corvid), trans, corvid), 30 DECISECONDS)
		if("Corax Crinos")
			if(iscoraxcrinos(trans))
				transformating = FALSE
				return
			if(!corax_form)
				return
			var/mob/living/carbon/wereraven/crinos/crinos = corax_form.resolve()
			if(!crinos)
				corax_form = null
				return

			transformating = TRUE

			animate(trans, transform = ntransform, color = "#000000", time = 30)
			playsound(get_turf(trans), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
			for(var/mob/living/simple_animal/hostile/beastmaster/B in trans.beastmaster)
				if(B)
					qdel(B)

			addtimer(CALLBACK(src, PROC_REF(transform_crinos), trans, crinos), 30 DECISECONDS)
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

			addtimer(CALLBACK(src, PROC_REF(transform_homid), trans, homid), 30 DECISECONDS)

/datum/werewolf_holder/transformation/proc/transform_corvid(mob/living/carbon/trans, mob/living/carbon/wereraven/corvid/corvid)
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
	/*if(trans.auspice.tribe.name == "Black Spiral Dancers" || HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		corvid.wyrm_tainted = 1*/ //Buzzards will come later, maybe. No promises.
	corvid.mind = trans.mind
	corvid.update_blood_hud()
	transfer_damage(trans, corvid)
	corvid.add_movespeed_modifier(/datum/movespeed_modifier/corvidform)
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	corvid.update_icons()
	/*if(lupus.hispo)
		lupus.remove_movespeed_modifier(/datum/movespeed_modifier/lupusform)
		lupus.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)*/ // shouldn't ever be in hispo as Corax

/datum/werewolf_holder/transformation/proc/transform_crinos(mob/living/carbon/trans, mob/living/carbon/wereraven/crinos/crinos)
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
	/*if(trans.auspice.tribe.name == "Black Spiral Dancers" || HAS_TRAIT(trans, TRAIT_WYRMTAINTED))
		crinos.wyrm_tainted = 1*/ // no wyrm taint handling yet, out of scope for this.
	crinos.mind = trans.mind
	crinos.update_blood_hud()
	crinos.physique = crinos.physique+3
	transfer_damage(trans, crinos)
	crinos.add_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	crinos.update_icons()

/datum/werewolf_holder/transformation/proc/transform_homid(mob/living/carbon/trans, mob/living/carbon/human/homid)
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
	homid.remove_movespeed_modifier(/datum/movespeed_modifier/crinosform)
	homid.remove_movespeed_modifier(/datum/movespeed_modifier/corvidform)
	transformating = FALSE
	animate(trans, transform = null, color = "#FFFFFF", time = 1)
	homid.update_body()

