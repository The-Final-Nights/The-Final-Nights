/datum/action/give_vitae
	name = "Give Vitae"
	desc = "Give your vitae to someone, make the Blood Bond."
	button_icon_state = "vitae"
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_IMMOBILE | AB_CHECK_LYING | AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/giving = FALSE

/datum/action/give_vitae/Trigger()
	if(!iskindred(owner))
		return
	var/mob/living/carbon/human/vampire = owner
	if(vampire.bloodpool < 2)
		to_chat(owner, span_warning("You don't have enough <b>BLOOD</b> to do that!"))
		return
	if(isanimal(vampire.pulling))
		var/mob/living/animal = vampire.pulling
		animal.bloodpool = min(animal.maxbloodpool, animal.bloodpool+2)
		vampire.bloodpool = max(0, vampire.bloodpool-2)
		animal.adjustBruteLoss(-25)
		animal.adjustFireLoss(-25)
	if(ishuman(vampire.pulling))
		var/mob/living/carbon/human/grabbed_victim = vampire.pulling
		if(iscathayan(grabbed_victim))
			to_chat(owner, span_warning("[grabbed_victim] vomits the vitae back!"))
			return
		if(!grabbed_victim.client && !isnpc(vampire.pulling))
			to_chat(owner, span_warning("You need [grabbed_victim]'s attention to do that!"))
			return
		if(grabbed_victim.stat == DEAD)
			if(!grabbed_victim.key)
				to_chat(owner, span_warning("You need [grabbed_victim]'s mind to Embrace!"))
				return
			message_admins("[ADMIN_LOOKUPFLW(vampire)] is Embracing [ADMIN_LOOKUPFLW(grabbed_victim)]!")
		if(giving)
			return
		giving = TRUE
		owner.visible_message(span_warning("[owner] tries to feed [grabbed_victim] with their own blood!"), span_notice("You started to feed [grabbed_victim] with your own blood."))
		// Embraces or ghouls the grabbed victim after 10 seconds.
		if(do_mob(owner, grabbed_victim, 10 SECONDS))
			vampire.bloodpool = max(0, vampire.bloodpool-2)
			giving = FALSE

			var/mob/living/carbon/human/childe = grabbed_victim
			var/mob/living/carbon/human/sire = vampire

			var/new_master = FALSE
			childe.drunked_of |= "[sire.dna.real_name]"

			if(childe.stat == DEAD && !iskindred(childe))
				if(!childe.can_be_embraced)
					to_chat(sire, span_notice("[childe.name] doesn't respond to your Vitae."))
					return
					// If they've been dead for more than 5 minutes, then nothing happens.
				if(childe.mind.damned)
					to_chat(sire, span_notice("[childe.name] doesn't respond to your Vitae."))
					return
				if((childe.timeofdeath + 5 MINUTES) > world.time)
					if(childe.auspice?.level) //here be Abominations
						if(childe.auspice.force_abomination)
							to_chat(sire, span_danger("Something terrible is happening."))
							to_chat(childe, span_userdanger("Gaia has forsaken you."))
							message_admins("[ADMIN_LOOKUPFLW(sire)] has turned [ADMIN_LOOKUPFLW(childe)] into an Abomination through an admin setting the force_abomination var.")
							log_game("[key_name(sire)] has turned [key_name(childe)] into an Abomination through an admin setting the force_abomination var.")
						else
							switch(SSroll.storyteller_roll(childe.auspice.level))
								if(ROLL_BOTCH)
									to_chat(sire, span_danger("Something terrible is happening."))
									to_chat(childe, span_userdanger("Gaia has forsaken you."))
									message_admins("[ADMIN_LOOKUPFLW(sire)] has turned [ADMIN_LOOKUPFLW(childe)] into an Abomination.")
									log_game("[key_name(sire)] has turned [key_name(childe)] into an Abomination.")
								if(ROLL_FAILURE)
									childe.visible_message(span_warning("[childe.name] convulses in sheer agony!"))
									childe.Shake(15, 15, 5 SECONDS)
									playsound(childe.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE)
									childe.can_be_embraced = FALSE
									return
								if(ROLL_SUCCESS)
									to_chat(sire, span_notice("[childe.name] does not respond to your Vitae..."))
									childe.can_be_embraced = FALSE
									return

					log_game("[key_name(sire)] has Embraced [key_name(childe)].")
					message_admins("[ADMIN_LOOKUPFLW(sire)] has Embraced [ADMIN_LOOKUPFLW(childe)].")
					giving = FALSE
					var/save_data_v = FALSE
					if(childe.revive(full_heal = TRUE, admin_revive = TRUE))
						childe.grab_ghost(force = TRUE)
						to_chat(childe, span_userdanger("You rise with a start, you're alive! Or not... You feel your soul going somewhere, as you realize you are embraced by a vampire..."))
						var/response_v = input(childe, "Do you wish to keep being a vampire on your save slot?(Yes will be a permanent choice and you can't go back!)") in list("Yes", "No")
						if(response_v == "Yes")
							save_data_v = TRUE
						else
							save_data_v = FALSE

					childe.roundstart_vampire = FALSE
					childe.set_species(/datum/species/kindred)
					childe.clane = null
					childe.generation = sire.generation+1

					childe.skin_tone = get_vamp_skin_color(childe.skin_tone)
					childe.update_body()

					if(childe.generation <= 13)
						childe.clane = new sire.clane.type()
						childe.clane.on_gain(childe)
						childe.clane.post_gain(childe)
					else
						childe.clane = new /datum/vampireclane/caitiff()

					if(childe.clane.alt_sprite)
						childe.skin_tone = "albino"
						childe.update_body()

					//Gives the Childe the Sire's first three Disciplines

					var/list/disciplines_to_give = list()
					for (var/i in 1 to min(3, sire.client.prefs.discipline_types.len))
						disciplines_to_give += sire.client.prefs.discipline_types[i]
					childe.create_disciplines(FALSE, disciplines_to_give)
					// TODO: Rework the max blood pool calculations.
					childe.maxbloodpool = 10+((13-min(13, childe.generation))*3)
					childe.clane.is_enlightened = sire.clane.is_enlightened

					//Verify if they accepted to save being a vampire
					if(iskindred(childe) && save_data_v)
						var/datum/preferences/childe_prefs_v = childe.client.prefs

						childe_prefs_v.pref_species.id = "kindred"
						childe_prefs_v.pref_species.name = "Vampire"
						childe_prefs_v.clane = childe.clane
						// If the childe is somehow 15th gen, reset to 14th.
						if(childe.generation <= 14)
							childe_prefs_v.generation = childe.generation
						else
							childe_prefs_v.generation = 14

						childe_prefs_v.skin_tone = get_vamp_skin_color(childe.skin_tone)
						childe_prefs_v.clane.is_enlightened = sire.clane.is_enlightened

						//Rarely the new mid round vampires get the 3 brujah skil(it is default)
						//This will remove if it happens
						// Or if they are a ghoul with abunch of disciplines
						if(childe_prefs_v.discipline_types.len > 0)
							for (var/i in 1 to childe_prefs_v.discipline_types.len)
								var/removing_discipline = childe_prefs_v.discipline_types[1]
								if (removing_discipline)
									var/index = childe_prefs_v.discipline_types.Find(removing_discipline)
									childe_prefs_v.discipline_types.Cut(index, index + 1)
									childe_prefs_v.discipline_levels.Cut(index, index + 1)

						if(childe_prefs_v.discipline_types.len == 0)
							for (var/i in 1 to 3)
								childe_prefs_v.discipline_types += childe_prefs_v.clane.clane_disciplines[i]
								childe_prefs_v.discipline_levels += 1

						childe_prefs_v.save_character()
				else
					to_chat(owner, span_notice("[childe] is totally <b>DEAD</b>!"))
					giving = FALSE
					return
			// Ghouling
			else
				var/mob/living/carbon/human/thrall = grabbed_victim
				var/mob/living/carbon/human/regnant = vampire

				if(thrall.has_status_effect(STATUS_EFFECT_BLOOD_BONDED))
					thrall.remove_status_effect(STATUS_EFFECT_BLOOD_BONDED)
				thrall.apply_status_effect(STATUS_EFFECT_BLOOD_BONDED, owner)
				to_chat(owner, "<span class='notice'>You successfuly fed [thrall] with vitae.</span>")
				to_chat(thrall, "<span class='userlove'>You feel good when you drink this <b>BLOOD</b>...</span>")

				message_admins("[ADMIN_LOOKUPFLW(regnant)] has bloodbonded [ADMIN_LOOKUPFLW(thrall)].")
				if(HAS_TRAIT(thrall,TRAIT_UNBONDABLE))
					log_game("[key_name(regnant)] has bloodbonded [key_name(thrall)].")
				else
					log_game("[key_name(regnant)] has attempted to bloodbond [key_name(thrall)] (UNBONDABLE).")

				if(length(regnant.reagents?.reagent_list))
					regnant.reagents.trans_to(thrall, min(10, regnant.reagents.total_volume), transfered_by = regnant, methods = VAMPIRE)
				thrall.adjustBruteLoss(-25, TRUE)
				if(length(thrall.all_wounds))
					var/datum/wound/W = pick(thrall.all_wounds)
					W.remove_wound()
				thrall.adjustFireLoss(-25, TRUE)
				thrall.bloodpool = min(thrall.maxbloodpool, thrall.bloodpool+2)
				giving = FALSE

				if(iskindred(thrall))
					var/datum/species/kindred/species = thrall.dna.species
					if(HAS_TRAIT(thrall, TRAIT_TORPOR) && COOLDOWN_FINISHED(species, torpor_timer))
						thrall.untorpor()

				if(!isghoul(thrall) && istype(thrall, /mob/living/carbon/human/npc))
					var/mob/living/carbon/human/npc/NPC = thrall
					if(NPC.ghoulificate(owner))
						new_master = TRUE
						NPC.roundstart_vampire = FALSE
				if(thrall.mind)
					if(thrall.mind.enslaved_to != owner && !HAS_TRAIT(thrall,TRAIT_UNBONDABLE))
						thrall.mind.enslave_mind_to_creator(owner)
						to_chat(thrall, "<span class='userdanger'><b>AS PRECIOUS VITAE ENTER YOUR MOUTH, YOU NOW ARE IN THE BLOODBOND OF [regnant]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b></span>")
						new_master = TRUE
					if(HAS_TRAIT(thrall,TRAIT_UNBONDABLE))
						to_chat(thrall, "<span class='danger'><i>Precious vitae enters your mouth, an addictive drug. But for you, you feel no loyalty to the source; only the substance.</i></span>")
				if(isghoul(thrall))
					var/datum/species/ghoul/ghoul = thrall.dna.species
					ghoul.master = owner
					ghoul.last_vitae = world.time
					if(new_master)
						ghoul.changed_master = TRUE
				else if(!iskindred(thrall) && !isnpc(thrall))
					var/save_data_g = FALSE
					thrall.set_species(/datum/species/ghoul)
					thrall.clane = null
					var/response_g = input(thrall, "Do you wish to keep being a ghoul on your save slot?(Yes will be a permanent choice and you can't go back)") in list("Yes", "No")
					thrall.roundstart_vampire = FALSE
					var/datum/species/ghoul/ghoul = thrall.dna.species
					ghoul.master = owner
					ghoul.last_vitae = world.time
					if(new_master)
						ghoul.changed_master = TRUE
					if(response_g == "Yes")
						save_data_g = TRUE
					else
						save_data_g = FALSE
					if(save_data_g)
						var/datum/preferences/thrall_prefs_g = thrall.client.prefs
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
		else
			giving = FALSE
