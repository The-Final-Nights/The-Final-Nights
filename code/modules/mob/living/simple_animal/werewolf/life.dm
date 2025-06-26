#define UMBRA_VEIL_COOLDOWN 40 MINUTES
#define CAERN_VEIL_COOLDOWN 60 MINUTES
#define GAROU_BP_REGEN 60 SECONDS
#define VEIL_COOLDOWN 20 SECONDS
#define RAGE_LIFE_COOLDOWN 30 SECONDS

/mob/living/Life()
	. = ..()
	update_icons()
	update_rage_hud()

	if(isgarou(src) || iswerewolf(src))
		if(key && stat <= HARD_CRIT)
			var/datum/preferences/P = GLOB.preferences_datums[ckey(key)]
			if(P)
				if(P.masquerade != masquerade)
					P.masquerade = masquerade
					P.save_preferences()
					P.save_character()

		if(stat != DEAD)
			var/gaining_rage = TRUE
			for(var/obj/structure/werewolf_totem/W in GLOB.totems)
				if(W.totem_health)
					if(W.tribe == auspice.tribe.name)
						if(get_area(W) == get_area(src) && client)
							gaining_rage = FALSE
							if(last_gnosis_buff+300 < world.time)
								last_gnosis_buff = world.time
								adjust_gnosis(1, src, TRUE)
			if(iscrinos(src))
				if(auspice.base_breed == "Crinos")
					gaining_rage = FALSE
			if(islupus(src))
				if(auspice.base_breed == "Lupus")
					gaining_rage = FALSE
			if(ishuman(src))
				if(auspice.base_breed == "Homid" || HAS_TRAIT(src, TRAIT_CORAX)) // Corvid-born Corax don't generate rage when in homid passively, the hope is to make talking more relaxed and the Corax weaker in combat.
					gaining_rage = FALSE
			if (iscorvid(src))
				gaining_rage = FALSE // Corax will ideally be talking a lot, not having passive rage generation should also make them weaker in combat.
			if (iscoraxcrinos(src))
				gaining_rage = TRUE // Corax have no Metis, Crinos is uneasy no matter your breed, no "buts" about it.

			if(gaining_rage && client)
				if(((last_rage_gain + RAGE_LIFE_COOLDOWN) < world.time) && (auspice.rage <= 6))
					last_rage_gain = world.time
					adjust_rage(1, src, TRUE)

			if(masquerade == 0)
				if(!is_special_character(src))
					if(auspice.gnosis)
						to_chat(src, "<span class='warning'>My Veil is too low to connect with the spirits of the Umbra!</span>")
						adjust_gnosis(-1, src, FALSE)

			if(auspice.rage >= 9)
				if(!in_frenzy)
					if((last_frenzy_check + 40 SECONDS) <= world.time)
						last_frenzy_check = world.time
						rollfrenzy()

			if(last_veil_restore == 0 || (last_veil_restore + UMBRA_VEIL_COOLDOWN) < world.time)
				if(masquerade < 5)
					check_veil_adjust()

// currently being in your caern restores veil to max because theres no other way of doing. remember to cap it to THREE once shame rituals are back

/mob/living/proc/check_veil_adjust()

	if(istype(get_area(src), /area/vtm/interior/penumbra))
		if((last_veil_restore + UMBRA_VEIL_COOLDOWN) < world.time)
			adjust_veil(1, random = -1)
			last_veil_restore = world.time
			return

	switch(auspice.tribe.name)
		if("Galestalkers", "Ghost Council", "Hart Wardens", "Get of Fenris", "Black Furies", "Silent Striders", "Red Talons", "Silver Fangs", "Stargazers", "Corax")
			if(istype(get_area(src), /area/vtm/sanbruno))
				adjust_veil(1, random = -1)
				last_veil_restore = world.time

		if("Bone Gnawers", "Children of Gaia", "Shadow Lords", "Corax")
			if(istype(get_area(src), /area/vtm/interior/cog/caern))
				adjust_veil(1, random = -1)
				last_veil_restore = world.time

		if("Glass Walkers", "Corax")
			if(istype(get_area(src), /area/vtm/interior/glasswalker))
				adjust_veil(1, random = -1)
				last_veil_restore = world.time

		if("Black Spiral Dancers")
			if(istype(get_area(src), /area/vtm/interior/endron_facility) && masquerade < 5)
				adjust_veil(1, random = -1)
				last_veil_restore = world.time

/datum/species/garou/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.adjust_veil(-1,random = -1)

	if((H.last_bloodpool_restore + GAROU_BP_REGEN) <= world.time)
		H.last_bloodpool_restore = world.time
		H.bloodpool = min(H.maxbloodpool, H.bloodpool+1)
	if(glabro)
		if(H.CheckEyewitness(H, H, 3, FALSE))
			H.adjust_veil(-1,random = -1)

/mob/living/simple_animal/werewolf/crinos/Life()
	. = ..()
	if(CheckEyewitness(src, src, 5, FALSE))
		adjust_veil(-1, honoradj = -1)

/mob/living/simple_animal/werewolf/corax/corax_crinos/Life() // realizing I screwed myself over by not making this a subtype, oh well.
	. = ..()
	if(CheckEyewitness(src, src, 5, FALSE))
		adjust_veil(-1, honoradj = -1)


/mob/living/simple_animal/werewolf/handle_status_effects()
	..()
	//natural reduction of movement delay due to stun.
	if(move_delay_add > 0)
		move_delay_add = max(0, move_delay_add - rand(1, 2))

/mob/living/proc/adjust_veil(amount, threshold, random, honoradj, gloryadj, wisdomadj, mob/living/carbon/vessel, forced)
	if(iswerewolf(src))
		var/mob/living/player = transformator.human_form.resolve()
		player.adjust_veil(amount, threshold, random, honoradj, gloryadj, wisdomadj, src)
	if(!GLOB.canon_event)
		return
	if(next_veil_time >= world.time && !forced)
		return
	if(amount > 0)
		if(HAS_TRAIT(src, TRAIT_VIOLATOR))
			return
	if(amount < 0)
		if(!CheckZoneMasquerade(src) && !forced)
			return
	next_veil_time = world.time + VEIL_COOLDOWN
	if(!is_special_character(src))
		if(!vessel)
			vessel = src
		if(amount < 0)
			if(masquerade > 0 && masquerade > threshold)
				SEND_SOUND(vessel, sound('code/modules/wod13/sounds/veil_violation.ogg', 0, 0, 75))
				to_chat(vessel, "<span class='boldnotice'><b>VEIL VIOLATION</b></span>")
				if(threshold && masquerade+amount < threshold)
					amount = threshold-masquerade
				masquerade = max(0, masquerade+amount)
		if(amount > 0)
			if(masquerade < 5)
				SEND_SOUND(vessel, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
				to_chat(vessel, "<span class='boldnotice'><b>VEIL REINFORCEMENT</b></span>")
				if(threshold && masquerade+amount > threshold)
					amount = threshold-masquerade
				masquerade = min(5, masquerade+amount)
		if(random < 0 || random > 0)
			var/random_renown = pick("Honor","Wisdom","Glory")
			switch(random_renown)
				if("Honor")
					adjust_renown("honor", random, vessel = vessel)
				if("Glory")
					adjust_renown("glory", random, vessel = vessel)
				if("Wisdom")
					adjust_renown("wisdom", random, vessel = vessel)
		else
			if(honoradj)
				adjust_renown("honor", honoradj, vessel = vessel)
			if(gloryadj)
				adjust_renown("glory", gloryadj, vessel = vessel)
			if(wisdomadj)
				adjust_renown("wisdom", wisdomadj, vessel = vessel)

		if(src in GLOB.masquerade_breakers_list)
			if(masquerade > 2)
				GLOB.masquerade_breakers_list -= src
		else if(masquerade < 3)
			GLOB.masquerade_breakers_list |= src

	var/datum/preferences/P = GLOB.preferences_datums[ckey(key)]
	if(P)
		P.masquerade = masquerade
		P.save_character()
		P.save_preferences()


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

#undef UMBRA_VEIL_COOLDOWN
#undef CAERN_VEIL_COOLDOWN
#undef GAROU_BP_REGEN
#undef VEIL_COOLDOWN
#undef RAGE_LIFE_COOLDOWN
