/mob/living/proc/check_veil_adjust()
	if(istype(get_area(src), /area/vtm/interior/penumbra))
		SEND_SIGNAL(SSmasquerade, COMSIG_PLAYER_MASQUERADE_REINFORCE, src)
		return

	switch(auspice.tribe.name)
		if("Galestalkers", "Ghost Council", "Hart Wardens", "Get of Fenris", "Black Furies", "Silent Striders", "Red Talons", "Silver Fangs", "Stargazers", "Corax")
			if(istype(get_area(src), /area/vtm/forest))
				SEND_SIGNAL(SSmasquerade, COMSIG_PLAYER_MASQUERADE_REINFORCE, src)

		if("Bone Gnawers", "Children of Gaia", "Shadow Lords", "Corax")
			if(istype(get_area(src), /area/vtm/interior/cog/caern))
				SEND_SIGNAL(SSmasquerade, COMSIG_PLAYER_MASQUERADE_REINFORCE, src)

		if("Glass Walkers", "Corax")
			if(istype(get_area(src), /area/vtm/interior/glasswalker))
				SEND_SIGNAL(SSmasquerade, COMSIG_PLAYER_MASQUERADE_REINFORCE, src)

		if("Black Spiral Dancers")
			if(istype(get_area(src), /area/vtm/interior/endron_facility))
				SEND_SIGNAL(SSmasquerade, COMSIG_PLAYER_MASQUERADE_REINFORCE, src)


/datum/species/garou/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE) || HAS_TRAIT(src, TRAIT_WYRMTAINTED) || glabro)
		SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)

	if(COOLDOWN_FINISHED(H, bloodpool_restore))
		COOLDOWN_START(H, bloodpool_restore, GAROU_BP_REGEN)
		H.bloodpool = min(H.maxbloodpool, H.bloodpool+1)

/mob/living/carbon/werewolf/crinos/Life()
	. = ..()
	SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)

/mob/living/carbon/werewolf/corax/corax_crinos/Life() // realizing I screwed myself over by not making this a subtype, oh well.
	. = ..()
	SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)


/mob/living/carbon/werewolf/handle_status_effects()
	..()
	//natural reduction of movement delay due to stun.
	if(move_delay_add > 0)
		move_delay_add = max(0, move_delay_add - rand(1, 2))

/mob/living/proc/adjust_renown(attribute, amount, threshold, mob/living/vessel)
	if(!GLOB.canon_event)
		return
	if(!is_special_character(src))
		if(!vessel)
			vessel = src

		var/current_value
		switch(attribute)
			if("honor")
				current_value = honor
			if("glory")
				current_value = glory
			if("wisdom")
				current_value = wisdom
			else
				return

		if(amount < 0)
			if(threshold && current_value <= threshold)
				return
			if(current_value + amount <= threshold)
				amount = (threshold - current_value)
			to_chat(vessel, span_userdanger("You feel [get_negative_emotion(attribute)]!"))
			current_value = max(0, current_value + amount)
			if(renownrank > AuspiceRankCheck(src))
				renownrank = AuspiceRankCheck(src)
				to_chat(vessel, span_userdanger("You are now ai  [RankName(src.renownrank)]."))

		if(amount > 0)
			if(threshold && current_value >= threshold)
				return
			if(current_value + amount >= threshold)
				amount = (threshold - current_value)
			to_chat(vessel, span_bold("You feel [get_positive_emotion(attribute)]!"))
			current_value = min(10, current_value + amount)
			if(renownrank < AuspiceRankCheck(src))
				renownrank = AuspiceRankCheck(src)
				to_chat(vessel, span_boldnotice("You are now a [RankName(src.renownrank)]."))

		switch(attribute)
			if("honor")
				honor = current_value
			if("glory")
				glory = current_value
			if("wisdom")
				wisdom = current_value

		var/datum/preferences/P = GLOB.preferences_datums[ckey(key)]
		if(P)
			switch(attribute)
				if("honor")
					P.honor = honor
				if("glory")
					P.glory = glory
				if("wisdom")
					P.wisdom = wisdom

			P.renownrank = renownrank
			P.save_character()
			P.save_preferences()



/mob/living/proc/get_negative_emotion(attribute)
	switch(attribute)
		if("honor")
			return "ashamed"

		if("glory")
			return "humiliated"

		if("wisdom")
			return "foolish"

	return "unsure"

/mob/living/proc/get_positive_emotion(attribute)
	switch(attribute)

		if("honor")
			return "vindicated"

		if("glory")
			return "brave"

		if("wisdom")
			return "clever"

	return "confident"

/mob/living/proc/AuspiceRankCheck(mob/living/carbon/user)
	switch(auspice.name)
		if("Ahroun")
			if(glory >= 10 && honor >= 9 && wisdom >= 4) return 5
			if(glory >= 9 && honor >= 4 && wisdom >= 2) return 4
			if(glory >= 6 && honor >= 3 && wisdom >= 1) return 3
			if(glory >= 4 && honor >= 1 && wisdom >= 1) return 2
			if(glory >= 2 || honor >= 1) return 1
			return FALSE

		if("Galliard")
			if(glory >= 9 && honor >= 5 && wisdom >= 9) return 5
			if(glory >= 7 && honor >= 2 && wisdom >= 6) return 4
			if(glory >= 4 && honor >= 2 && wisdom >= 4) return 3
			if(glory >= 4 && wisdom >= 2) return 2
			if(glory >= 2 && wisdom >= 1) return 1
			return FALSE

		if("Philodox")
			if(glory >= 4 && honor >= 10 && wisdom >= 9) return 5
			if(glory >= 3 && honor >= 8 && wisdom >= 4) return 4
			if(glory >= 2 && honor >= 6 && wisdom >= 2) return 3
			if(glory >= 1 && honor >= 4 && wisdom >= 1) return 2
			if(honor >= 3) return 1
			return FALSE

		if("Theurge")
			if(glory >= 4 && honor >= 9 && wisdom >= 10) return 5
			if(glory >= 4 && honor >= 2 && wisdom >= 9) return 4
			if(glory >= 2 && honor >= 1 && wisdom >= 7) return 3
			if(glory >= 1 && wisdom >= 5) return 2
			if(wisdom >= 3) return 1
			return FALSE

		if("Ragabash")
			if((glory+honor+wisdom) >= 25) return 5
			if((glory+honor+wisdom) >= 19) return 4
			if((glory+honor+wisdom) >= 13) return 3
			if((glory+honor+wisdom) >= 7) return 2
			if((glory+honor+wisdom) >= 3) return 1
			return FALSE

	return FALSE
