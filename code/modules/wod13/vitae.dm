/datum/reagent/blood/vitae
	name = "Vitae"
	description = "It seems to be slightly glowing blood."
	reagent_state = LIQUID
	color = "#fc0000"

/datum/reagent/blood/vitae/on_mob_life(mob/living/carbon/human/victim)
	//Cant use a switch here since isblank checks dont have proper syntax.
	if(isghoul(victim) || iskindred(victim))
		if(current_cycle >= 10)
			victim.bloodpool = min(victim.maxbloodpool, victim.bloodpool+1)
			victim.update_blood_hud()
	if(ishumanbasic(victim))
		victim.set_species(/datum/species/ghoul)
		if(victim.mind.enslaved_to != data["donor"])
			victim.mind.enslave_mind_to_creator(data["donor"])
			to_chat(victim, span_userdanger("<b>AS PRECIOUS VITAE ENTER YOUR MOUTH, YOU NOW ARE IN THE BLOODBOND OF [data["donor"]]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b>"))
			
			victim.clane = null
			var/response_g = input(victim, "Do you wish to keep being a ghoul on your save slot? (Yes will be a permanent choice and you can't go back)") in list("Yes", "No")
			victim.roundstart_vampire = FALSE
			var/datum/species/ghoul/ghoul = victim.dna.species
			ghoul.master = data["donor"]
			ghoul.last_vitae = world.time
			var/save_data_g = FALSE
			if(response_g == "Yes")
				save_data_g = TRUE
			else
				save_data_g = FALSE
			if(save_data_g)
				var/datum/preferences/thrall_prefs_g = victim.client.prefs
				if(thrall_prefs_g.discipline_types.len == 3)
					for (var/i in 1 to 3)
						var/removing_discipline = thrall_prefs_g.discipline_types[1]
						if (removing_discipline)
							var/index = thrall_prefs_g.discipline_types.Find(removing_discipline)
							thrall_prefs_g.discipline_types.Cut(index, index + 1)
							thrall_prefs_g.discipline_levels.Cut(index, index + 1)
				thrall_prefs_g.pref_species.name = "Ghoul"
				thrall_prefs_g.pref_species.id = "ghoul"
				//thrall_prefs_g.regnant = ghoul.master
				thrall_prefs_g.save_character()
			return TRUE
	return ..()
