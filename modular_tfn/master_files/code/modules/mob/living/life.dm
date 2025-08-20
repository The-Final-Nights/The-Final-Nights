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
				if(auspice.breed_form == FORM_CRINOS)
					gaining_rage = FALSE
			if(islupus(src))
				if(auspice.breed_form == FORM_LUPUS)
					gaining_rage = FALSE
			if(ishuman(src))
				if(auspice.breed_form == FORM_HOMID || HAS_TRAIT(src, TRAIT_CORAX)) // Corvid-born Corax don't generate rage when in homid passively, the hope is to make talking more relaxed and the Corax weaker in combat.
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

#undef RAGE_LIFE_COOLDOWN
