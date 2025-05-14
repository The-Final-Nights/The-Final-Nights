/datum/curse/daimonion
	var/genrequired
	//Amount of blood to permanently tithe
	var/bloodcurse = 1

/datum/curse/daimonion/proc/activate(var/mob/living/target)
	return

/datum/curse/daimonion/lying_weakness
	name = "No Lying Tongue"
	genrequired = 13

/datum/curse/daimonion/physical_weakness
	name = "Baby Strength"
	genrequired = 12
	bloodcurse = 2

/datum/curse/daimonion/mental_weakness
	name = "Reap Mentality"
	genrequired = 11
	bloodcurse = 3

/datum/curse/daimonion/offspring_weakness
	name = "Sterile Vitae"
	genrequired = 10
	bloodcurse = 4

/datum/curse/daimonion/success_weakness
	name = "The Mark Of Doom"
	genrequired = 10
	bloodcurse = 5

/datum/curse/daimonion/lying_weakness/activate(mob/living/carbon/human/target)
	. = ..()
	target.gain_trauma(/datum/brain_trauma/mild/mind_echo, TRAUMA_RESILIENCE_ABSOLUTE)
	to_chat(target, span_userdanger(span_bold("You feel like a great curse was placed on you!")))

/datum/curse/daimonion/physical_weakness/activate(mob/living/target)
	. = ..()
	if(target.physique >= 5)
		target.physique = 4
	var/mob/living/carbon/human/vampire = target
	for (var/datum/action/blood_power/blood_power in vampire.actions)
		blood_power.Remove(vampire)
	to_chat(target, span_userdanger(span_bold("You feel like a great curse was placed on you!")))

/datum/curse/daimonion/mental_weakness/activate(mob/living/target)
	. = ..()
	if(target.social >= 5)
		target.social = 4
	if(target.mentality >= 5)
		target.mentality = 4
	to_chat(target, span_userdanger(span_bold("You feel like a great curse was placed on you!")))

/datum/curse/daimonion/offspring_weakness/activate(mob/living/target)
	. = ..()
	var/mob/living/carbon/human/vampire = target
	for (var/datum/action/give_vitae/give_vitae in vampire.actions)
		give_vitae.Remove(vampire)
	to_chat(target, span_userdanger(span_bold("You feel like a great curse was placed on you!")))

/datum/curse/daimonion/success_weakness/activate(mob/living/target)
	. = ..()
	target.add_quirk(/datum/quirk/slowpoke)
	target.add_quirk(/datum/quirk/lazy)
	target.add_quirk(/datum/quirk/hungry)
	to_chat(target, span_userdanger(span_bold("You feel like a great curse was placed on you!")))
