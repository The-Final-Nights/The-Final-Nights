/mob/living/carbon/werewolf/examine(mob/living/user)
	. = ..()

	if (!isgarou(user) && !iswerewolf(user))
		return

	var/isknown = FALSE
	var/same_tribe = FALSE
	var/truescent = FALSE

	var/list/honorr = list("claim to good conduct", "claim to honor", "claim to chivalry")
	var/list/wisdomm = list("claim to insight", "claim to wisdom", "claim to sagacity")
	var/list/gloryy = list("claim to bravery", "claim to valor", "claim to glory")

	if(HAS_TRAIT(user, TRAIT_SCENTTRUEFORM))
		truescent = TRUE

	if(user.auspice?.tribe.name == auspice?.tribe.name)
		same_tribe = TRUE
		if(user.auspice.tribe.name == "Black Spiral Dancers")
			honorr = list("strength and will", "complete defeat of [p_their()] enemies", "awesome destruction in service of the Wyrm")
			wisdomm = list("knowledge of twisted machinations", "ability to turn [p_their()] enemies against themselves", "brilliantly depraved plots in service of the Wyrm")
			gloryy = list("trials in service of the Wyrm", "many victories in name of the Wyrm", "great conquests in the Wyrm's service")

	switch(renownrank)
		if(1)
			if(same_tribe || truescent)
				. += "<b>You know [p_them()] as \a [RankName(src.renownrank, src.auspice.tribe.name)] of the [auspice.tribe.name].</b>"
				isknown = TRUE
		if(2)
			if(same_tribe || truescent)
				. += "<b>You know [p_them()] as \a [RankName(src.renownrank, src.auspice.tribe.name)] of the [auspice.tribe.name].</b>"
				isknown = TRUE
		if(3,4,5,6)
			. += "<b>You know [p_them()] as \a [RankName(src.renownrank, src.auspice.tribe.name)] [auspice.name] of the [auspice.tribe.name].</b>"
			isknown = TRUE
	if(isknown)
		switch(honor)
			if(4,5,6)
				. += "<i>In the local Garou, you have heard of [p_their()] [honorr[1]].</i>"
			if(7,8,9)
				. += "<i>In the local Garou, you have heard of [p_their()] [honorr[2]].</i>"
			if(10)
				. += "<i>In the local Garou, you have heard of [p_their()] [honorr[3]].</i>"
		switch(wisdom)
			if(4,5,6)
				. += "<i>In the local Garou, you have heard of [p_their()] [wisdomm[1]].</i>"
			if(7,8,9)
				. += "<i>In the local Garou, you have heard of [p_their()] [wisdomm[2]].</i>"
			if(10)
				. += "<i>In the local Garou, you have heard of [p_their()] [wisdomm[3]].</i>"
		switch(glory)
			if(4,5,6)
				. += "<i>In the local Garou, you have heard of [p_their()] [gloryy[1]].</i>"
			if(7,8,9)
				. += "<i>In the local Garou, you have heard of [p_their()] [gloryy[2]].</i>"
			if(10)
				. += "<i>In the local Garou, you have heard of [p_their()] [gloryy[3]].</i>"
