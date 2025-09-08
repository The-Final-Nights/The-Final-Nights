/datum/quirk/eat_food
	name = "Eat Food"
	desc = "Can consume food but still with no nourishment."
	value = 1
	gain_text = "<span class='notice'>You could go for some real food.</span>"
	lose_text = "<span class='notice'>You don't want any more real food.</span>"
	mob_trait = TRAIT_CAN_EAT
	allowed_species = list("Vampire")

/datum/quirk/eat_food/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.dna.species.toxic_food = NONE
