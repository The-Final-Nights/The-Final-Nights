/datum/auspice
	var/name = "Loh"
	var/desc = "Furry ebaka"
	var/level = 1
	var/start_rage = 1
	var/rage = 1
	var/start_gnosis = 1
	var/gnosis = 1
	var/breed_form = FORM_HOMID
	var/datum/garou_tribe/tribe = new /datum/garou_tribe/galestalkers()
	var/list/gifts = list()
	var/force_abomination = FALSE

/datum/auspice/proc/on_gain(mob/living/carbon/C)
	C.update_rage_hud()

	var/mob/living/carbon/werewolf/lupus/lupus = C.transformator.lupus_form?.resolve()
	var/mob/living/carbon/werewolf/crinos/crinos = C.transformator.crinos_form?.resolve()
	var/mob/living/carbon/werewolf/corax/corax_crinos/cor_crinos = C.transformator.corax_form?.resolve()
	var/mob/living/carbon/werewolf/lupus/corvid/corvid = C.transformator.corvid_form?.resolve()
	lupus?.auspice = src
	crinos?.auspice = src
	cor_crinos?.auspice = src
	ADD_TRAIT(cor_crinos, TRAIT_CORAX, tribe )
	corvid?.auspice = src
	ADD_TRAIT(corvid, TRAIT_CORAX, tribe)

	// Register signals to gain Rage from
	RegisterSignals(C, list(COMSIG_ATOM_HITBY, COMSIG_ATOM_BULLET_ACT), PROC_REF(handle_rage_trigger))
	RegisterSignals(lupus, list(COMSIG_ATOM_HITBY, COMSIG_ATOM_BULLET_ACT), PROC_REF(handle_rage_trigger))
	RegisterSignals(crinos, list(COMSIG_ATOM_HITBY, COMSIG_ATOM_BULLET_ACT), PROC_REF(handle_rage_trigger))
	RegisterSignals(cor_crinos, list(COMSIG_ATOM_HITBY, COMSIG_ATOM_BULLET_ACT), PROC_REF(handle_rage_trigger))
	RegisterSignals(corvid, list(COMSIG_ATOM_HITBY, COMSIG_ATOM_BULLET_ACT), PROC_REF(handle_rage_trigger))

	rage = start_rage
	if(length(gifts)) // This grants the auspice gifts, I believe
		for(var/i in gifts)
			var/datum/action/A1 = new i()
			A1.Grant(C)
			var/datum/action/A2 = new i()
			A2.Grant(lupus)
			var/datum/action/A3 = new i()
			A3.Grant(crinos)
			var/datum/action/A4 = new i()
			A4.Grant(cor_crinos)
			var/datum/action/A5 = new i()
			A5.Grant(corvid)

	for(var/i in 1 to level) // This grants the tribe-specific gifts, linked to the werewolf "power" stat
		var/zalupa
		zalupa = tribe.tribal_gifts[i]
		var/datum/action/A = new zalupa()
		A.Grant(C)
		var/datum/action/A1 = new zalupa()
		A1.Grant(lupus)
		var/datum/action/A2 = new zalupa()
		A2.Grant(crinos)
		var/datum/action/A3 = new zalupa()
		A3.Grant(cor_crinos)
		var/datum/action/A4 = new zalupa()
		A4.Grant(corvid)

	if(tribe.tribe_keys)
		C.put_in_hands(new tribe.tribe_keys(C))
	if(tribe.tribe_trait==TRAIT_CORAX)
		ADD_TRAIT(C,TRAIT_CORAX, tribe)

	RegisterSignal(src, COMSIG_CHARACTER_GENERATED, PROC_REF(add_recipe_klaive))

/**
 * On gaining crafting recipes for garou klaives
 *
 * This grants a specific silver klaive crafting recipe depending on tribe.
 * Disabled for the time being until a good system to share the craftin recipes is found
 */
/datum/auspice/proc/add_recipe_klaive(datum/source, mob/living/user)
	SIGNAL_HANDLER
	/*
	if(tribe.name == "Glass Walkers")
		user.mind.teach_crafting_recipe(/datum/crafting_recipe/klaive/glasswalker)

	if(tribe.name == "Galestalkers")
		user.mind.teach_crafting_recipe(/datum/crafting_recipe/klaive/wendigo)

	if(tribe.name == "Black Spiral Dancers")
		user.mind.teach_crafting_recipe(/datum/crafting_recipe/klaive/bsd)
	*/
	UnregisterSignal(src, COMSIG_CHARACTER_GENERATED)

/**
 * Sets the breed of a shapeshifter, or what form
 * they were born in and naturally stay in. If that
 * form isn't human form, this will also allow them to
 * transform out of human form upon death. Sets Gnosis
 * to the values every breed starts with.
 *
 * Arguments:
 * * breed - Name of the breed being set
 * * owner - Mob whose breed is being set, and whose Auspice this is
 */
/datum/auspice/proc/set_breed(breed, mob/living/carbon/human/owner)
	// Apply breed-specific stats
	switch (breed)
		if (BREED_HOMID)
			owner.auspice.gnosis = 1
			owner.auspice.start_gnosis = 1
			breed_form = FORM_HOMID
		if (BREED_LUPUS)
			owner.auspice.gnosis = 5
			owner.auspice.start_gnosis = 5
			breed_form = FORM_LUPUS
		if (BREED_METIS)
			owner.auspice.gnosis = 3
			owner.auspice.start_gnosis = 3
			breed_form = FORM_CRINOS
		if (BREED_CORVID)
			owner.auspice.gnosis = 5
			owner.auspice.start_gnosis = 5
			breed_form = FORM_CORVID

	// Reverting to Homid form is handled elsewhere, this is specifically to transform out of Homid
	if (breed != BREED_HOMID)
		RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(handle_death))

/datum/auspice/proc/handle_death(mob/living/carbon/human/source, gibbed)
	SIGNAL_HANDLER

	if (gibbed)
		return

	source.transformator?.transform(source, breed_form, TRUE)

/datum/auspice/proc/handle_rage_trigger(mob/living/carbon/source)
	SIGNAL_HANDLER

	source.do_rage_from_attack()

/datum/auspice/ahroun
	name = "Ahroun"
	desc = "The Ahroun is the archetype of the werewolf as murderous beast, though they range from unapologetic berserkers to hardened veterans tempering their Rage with discipline. Their high levels of Rage put them on the edge at all times - the Full Moon's blessing is a hair trigger, among other things. Those closer to the waxing moon tend to exult in the glory of the war, while those closer to the waning moon are more viciously pragmatic, ruthless in their bloodthirst. Every Ahroun is a dangerous individual to be around, but when the forces of the Wyrm attack, their packmates are glad to have a Full Moon warrior at the front of the charge."
	start_rage = 5
	gifts = list(/datum/action/gift/falling_touch, /datum/action/gift/inspiration, /datum/action/gift/razor_claws)

/datum/auspice/galliard
	name = "Galliard"
	desc = "Where the Philodox is stoic, the Galliard is a creature of unbridled passion. The Gibbous Moon is a fiery muse, and stirs its children into great heights and depths of emotion. While all Galliards are prone to immense mirth and immense melancholy, those born under a waning moon fall more readily into dark, consuming passions; they are the tragedians of the Garou, mastering tales of doom, ruin, sacrifice and loss. Conversely, their waxing-moon cousins sing of triumph and conquest, of the pounding heart and the love of life. They tend to be the soul of their pack's morale - when the Galliard is willing to go on, so too are all the others."
	start_rage = 4
	gifts = list(/datum/action/gift/beast_speech, /datum/action/gift/call_of_the_wyld, /datum/action/gift/mindspeak)

/datum/auspice/philodox
	name = "Philodox"
	desc = "Buried so heavily in his role as impartial judge and jury, the Philodox may seem aloof, even surprisingly cold-blooded for a werewolf. Those born under the waxing Half Moon may seem unusually serene and disaffected, their emotions only emerging when their Rage comes to a boil. The waning-moon Philodox is more incisive and judgmental, his all-seeing eye always carefully watching his packmates and colleagues for any departure from the expected. The Half Moons' opinions are somewhat feared, yet highly respected - a word of praise or condemnation means much coming from those born to see both sides of every struggle."
	start_rage = 3
	gifts = list(/datum/action/gift/resist_pain, /datum/action/gift/scent_of_the_true_form, /datum/action/gift/truth_of_gaia)

/datum/auspice/theurge
	name = "Theurge"
	desc = "The Crescent Moons can be strange and enigmatic, prone to falling into the convoluted symbolic logic of the spirits they truck with rather than the more familiar logic of humanity. Those Theurges born under the waning moon frequently have a harsher, more adversarial relationship with the spirit world - they tend to excel at binding and forcing spirits to their will, and are more vicious when battling spirits. Theurges born under the waxing moon tend to be more generous and open with the spirits, charming and cajoling rather than intimidating and threatening."
	start_rage = 2
	gifts = list(/datum/action/gift/mothers_touch, /datum/action/gift/sense_wyrm, /datum/action/gift/spirit_speech)

/datum/auspice/ragabash
	name = "Ragabash"
	desc = "The Ragabash born under the waxing new moon is usually light-hearted and capricious, while one born under the waning new moon has a slightly more wicked and ruthless streak. It's a rare Ragabash indeed that lacks a keen wit and the capacity to find some humor in any situation, no matter how bleak. Many other werewolves are slow to take the Ragabash seriously, though, as it's difficult to tell the difference between a New Moon's mockery that points out a grievous flaw in a plan and similar mockery that simply amuses him. Sometimes a Ragabash points out that the emperor has no clothes - but sometimes they're the first to cry wolf, so to speak."
	start_rage = 1
	gifts = list(/datum/action/gift/blur_of_the_milky_eye, /datum/action/gift/open_seal, /datum/action/gift/infectious_laughter)
