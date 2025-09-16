/datum/surgery/fleshcraft
	name = "Fleshcraft"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/close)//These literally don't matter for the base type so keep it simple

	possible_locs = list(BODY_ZONE_CHEST)
	self_operable = TRUE
	replaced_by = /datum/surgery
	var/level_req = 2

/datum/surgery/fleshcraft/can_start(mob/user, mob/living/carbon/target)
	if(replaced_by == /datum/surgery)//This hides the surgery, easier to change this on children and have the can_start check here
		return FALSE
	if(!ishuman(target))//Here to prevent werewolf fuckery mostly I guess? It seemed a sane precaution
		return FALSE
	if(!iskindred(user))//So that we're not running a get_discipline check on a species that doesn't have disciplines
		return FALSE
	var/mob/living/carbon/human/surgeon = user
	var/datum/species/kindred/surgeon_species = surgeon?.dna.species
	var/datum/discipline/surgeon_vicissitude = surgeon_species?.get_discipline(/datum/discipline/vicissitude)
	if(!surgeon_vicissitude)//If the surgeon doesn't have vicissitude, they don't get to do vicissitude things
		return FALSE
	if(surgeon_vicissitude.level >= level_req)//Checks if we have at least 2 vicissitude, the level necessary for fleshcrafting
		return TRUE
	return FALSE
