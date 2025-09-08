/datum/reagent/blood/vitae
	name = "Vitae"
	description = "It seems to be slightly glowing blood."
	reagent_state = LIQUID
	color = "#fc0000"
	self_consuming = TRUE
	metabolization_rate = 100 * REAGENTS_METABOLISM // Vitae is supposed to instantly be consumed by the organism.
	can_synth = FALSE
	glass_name = "glass of blood"
	glass_desc = "It seems to be a glass full of slightly glowing blood."

/datum/reagent/blood/vitae/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()

	if(!ishuman(exposed_mob)) //We do not have vitae implementations for non-human mobs.
		return
	var/mob/living/carbon/human/victim = exposed_mob
	if(ishumanbasic(victim)) //Are we a human species?
		if(victim.stat == DEAD) //If the human we are being added to is dead, embrace them.
			var/mob/living/carbon/human/embracer = data["donor"]
			embracer.attempt_embrace_target(victim, (usr == data["donor"]) ? null : usr)
			return
		else //Otherwise, ghoul them, since they aren't dead.
			victim.ghoulificate(data["donor"])
			victim.prompt_permenant_ghouling()
			return
	if(isghoul(victim)) //Are we a ghoul  species?
		if(victim.stat == DEAD) //If the ghoul we are being added to is dead, embrace them.
			var/mob/living/carbon/human/embracer = data["donor"]
			embracer.attempt_embrace_target(exposed_mob, (usr == data["donor"]) ? null : usr)
			return
		else
			victim.bloodpool = min(victim.maxbloodpool, victim.bloodpool + (reac_volume / 50)) //Otherwise, they just consume vitae normally.
			victim.send_ghoul_vitae_consumption_message(data["donor"])
	if(iskindred(victim)) //Are we a kindred species?
		victim.bloodpool = min(victim.maxbloodpool, victim.bloodpool + (reac_volume / 50))
		if(data["donor"])
			victim.blood_bond(data["donor"])
	if(isgarou(victim)) //Are we a garou species?
		victim.rollfrenzy()
