/datum/discipline/daimonion
	name = "Daimonion"
	desc = "Get a help from the Hell creatures, resist THE FIRE, transform into an imp. Violates Masquerade."
	icon_state = "daimonion"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/daimonion

/datum/discipline_power/daimonion
	name = "Daimonion power name"
	desc = "Daimonion power description"

	activate_sound = 'code/modules/wod13/sounds/protean_activate.ogg'
	deactivate_sound = 'code/modules/wod13/sounds/protean_deactivate.ogg'

//SENSE THE SIN
/datum/discipline_power/daimonion/sense_the_sin
	name = "Sense the Sin"
	desc = "Become supernaturally resistant to fire."

	target_type = TARGET_HUMAN
	range = 12
	level = 1

	cancelable = TRUE

/datum/discipline_power/daimonion/sense_the_sin/activate(mob/living/carbon/human/target)
	. = ..()
	if(target.get_total_social() <= 3)
		to_chat(owner, "Victim is not social or influencing.")
	if(target.get_total_mentality() <= 3)
		to_chat(owner, "Victim lacks appropiate willpower.")
	if(target.get_total_physique() <= 3)
		to_chat(owner, "Victim's body is weak and feeble.")
	if(target.get_total_dexterity() <= 3)
		to_chat(owner, "Victim's lacks coordination.")
	if(isgarou(target))
		to_chat(owner, "Victim's natural banishment is silver...")
	if(iskindred(target))
		baali_get_clan_weakness(target, owner)
		baali_get_stolen_disciplines(target, owner)
		if(target.generation >= 10)
			to_chat(owner, "Victim's vitae is weak and thin. You can clearly see their fear for fire, it seems that's a kindred.")
		else
			to_chat(owner, "Victim's vitae is thick and strong. You can clearly see their fear for fire, it seems that's a kindred.")
	if(isghoul(target))
		var/mob/living/carbon/human/ghoul = target
		if(ghoul.mind.enslaved_to)
			to_chat(owner, "Victim is addicted to vampiric vitae and its true master is [ghoul.mind.enslaved_to]")
		else
			to_chat(owner, "Victim is addicted to vampiric vitae, but is independent and free.")
	if(iscathayan(target))
		if(target.mind.dharma?.Po == "Legalist")
			to_chat(owner, "[target] hates to be controlled!")
		if(target.mind.dharma?.Po == "Rebel")
			to_chat(owner, "[target] doesn't like to be touched.")
		if(target.mind.dharma?.Po == "Monkey")
			to_chat(owner, "[target] is too focused on money, toys and other sources of easy pleasure.")
		if(target.mind.dharma?.Po == "Demon")
			to_chat(owner, "[target] is addicted to pain, as well as to inflicting it to others.")
		if(target.mind.dharma?.Po == "Fool")
			to_chat(owner, "[target] doesn't like to be pointed at!")
	if(!iskindred(target) && !isghoul(target) && !isgarou(target) && !iscathayan(target))
		to_chat(owner, "[target] is a feeble worm with no strengths or visible weaknesses, a mere human.")

/datum/discipline_power/daimonion/sense_the_sin/proc/baali_get_clan_weakness(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire))
		var/datum/species/kindred/clan = vampire.dna.species
		if(vampire.clane?.name)
			if(vampire.clane?.name == "Toreador")
				to_chat(owner, "[target] is too clingy to the art.")
				return
			if(vampire.clane?.name == "Daughters of Cacophony")
				to_chat(owner, "[target]'s mind is envelopped by nonstopping music.")
			if(vampire.clane?.name == "Ventrue")
				to_chat(owner, "[target] finds no pleasure in poor's blood.")
				return
			if(vampire.clane?.name == "Lasombra")
				to_chat(owner, "[target] is afraid of modern technology.")
				return
			if(vampire.clane?.name == "Tzimisce")
				to_chat(owner, "[target] is tied to its domain.")
				return
			if(vampire.clane?.name == "Gangrel")
				to_chat(owner, "[target] is a feral being used to the nature.")
				return
			if(vampire.clane?.name == "Malkavian")
				to_chat(owner, "[target] is unstable, the mind is ill.")
				return
			if(vampire.clane?.name == "Brujah")
				to_chat(owner, "[target] is full of uncontrollable rage.")
			if(vampire.clane?.name == "Nosferatu")
				to_chat(owner, "[target] is ugly and nothing will save them.")
				return
			if(vampire.clane?.name == "Tremere")
				to_chat(owner, "[target] is weak to kindred blood and vulnerable to blood bonds.")
				return
			if(vampire.clane?.name == "Baali")
				to_chat(owner, "[target] is afraid of holy.")
				return
			if(vampire.clane?.name == "Banu Haqim")
				to_chat(owner, "[target] is addicted to kindred vitae...")
				return
			if(vampire.clane?.name == "True Brujah")
				to_chat(owner, "[target] cant express emotions.")
				return
			if(vampire.clane?.name == "Salubri")
				to_chat(owner, "[target] is unable to feed on unwilling.")
				return
			if(vampire.clane?.name == "Giovanni")
				to_chat(owner, "[target]'s bite inflicts too much harm.")
				return
			if(vampire.clane?.name == "Cappadocian")
				to_chat(owner, "[target]'s skin will stay pale and lifeless no matter what.")
				return
			if(vampire.clane?.name == "Kiasyd")
				to_chat(owner, "[target] is afraid of cold iron.")
				return
			if(vampire.clane?.name == "Gargoyle")
				to_chat(owner, "[target] is too dependent on its masters, its mind is feeble.")
				return
			if(vampire.clane?.name == "Ministry")
				to_chat(owner, "[target] is afraid of bright lights.")
				return

			to_chat(owner, "[target] is shunned by most as it lacks a clan.")


/datum/daimonion/proc/baali_get_stolen_disciplines(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire))
		var/datum/species/kindred/clan = vampire.dna.species
		if(clan.get_discipline("Quietus") && vampire.clane?.name != "Banu Haqim")
			to_chat(owner, "[target] fears that the fact they stole Banu Haqim's Quietus will be known.")
		if(clan.get_discipline("Protean") && vampire.clane?.name != "Gangrel")
			to_chat(owner, "[target] fears that the fact they stole Gangrel's Protean will be known.")
		if(clan.get_discipline("Serpentis") && vampire.clane?.name != "Ministry")
			to_chat(owner, "[target] fears that the fact they stole Ministry's Serpentis will be known.")
		if(clan.get_discipline("Necromancy") && vampire.clane?.name != "Giovanni" || clan.get_discipline("Necromancy") && vampire.clane?.name != "Cappadocian")
			to_chat(owner, "[target] fears that the fact they stole Giovanni's Necromancy will be known.")
		if(clan.get_discipline("Obtenebration") && vampire.clane?.name != "Lasombra" || clan.get_discipline("Obtenebration") && vampire.clane?.name != "Baali")
			to_chat(owner, "[target] fears that the fact they stole Lasombra's Obtenebration will be known.")
		if(clan.get_discipline("Dementation") && vampire.clane?.name != "Malkavian")
			to_chat(owner, "[target] fears that the fact they stole Malkavian's Dementation will be known.")
		if(clan.get_discipline("Vicissitude") && vampire.clane?.name != "Tzimisce")
			to_chat(owner, "[target] fears that the fact they stole Tzimisce's Vicissitude will be known.")
		if(clan.get_discipline("Melpominee") && vampire.clane?.name != "Daughters of Cacophony")
			to_chat(owner, "[target] fears that the fact they stole Daughters of Cacophony's Melpominee will be known.")
		if(clan.get_discipline("Daimonion") && vampire.clane?.name != "Baali")
			to_chat(owner, "[target] fears that the fact they stole Baali's Daimonion will be known.")
		if(clan.get_discipline("Temporis") && vampire.clane?.name != "True Brujah")
			to_chat(owner, "[target] fears that the fact they stole True Brujah's Temporis will be known.")
		if(clan.get_discipline("Valeren") && vampire.clane?.name != "Salubri")
			to_chat(owner, "[target] fears that the fact they stole Salubri's Valeren will be known.")
		if(clan.get_discipline("Mytherceria") && vampire.clane?.name != "Kiasyd")
			to_chat(owner, "[target] fears that the fact they stole Kiasyd's Mytherceria will be known.")
//FEAR OF THE VOID BELOW
/datum/discipline_power/daimonion/fear_of_the_void_below
	name = "Fear of the Void Below"
	desc = "Induce fear in a target."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS

	target_type = TARGET_HUMAN
	range = 7

	duration_length = 3 SECONDS

/datum/discipline_power/daimonion/fear_of_the_void_below/pre_activation_checks(mob/living/target)
	var/mypower = owner.get_total_social()
	var/theirpower = target.get_total_mentality()
	if((theirpower >= mypower) || (owner.generation > target.generation))
		to_chat(owner, "<span class='warning'>[target] has too much willpower to induce fear into them!</span>")
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/fear_of_the_void_below/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, span_warning("Your mind is enveloped by your greatest fear!"))
	if(!target.in_frenzy) // Cause target to frenzy
		target.enter_frenzymod()
		target.Paralyze(3 SECONDS)

/datum/discipline_power/daimonion/fear_of_the_void_below/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.exit_frenzymod()

//CONFLAGRATION
/datum/discipline_power/daimonion/conflagration
	name = "Conflagration"
	desc = "Draw out the destructive essence of the Beyond."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

/datum/discipline_power/daimonion/conflagration/activate(mob/living/target)
	. = ..()
	var/turf/start = get_turf(owner)
	var/obj/projectile/magic/aoe/fireball/baali/created_fireball = new(start)
	created_fireball.firer = owner
	created_fireball.preparePixelProjectile(target, start)
	created_fireball.fire()

/datum/discipline_power/daimonion/conflagration/deactivate()
	. = ..()
	for(var/obj/item/melee/vampirearms/knife/gangrel/claws in owner)
		qdel(claws)

/datum/discipline_power/daimonion/conflagration/post_gain()
	. = ..()
	var/obj/effect/proc_holder/spell/aimed/fireball/baali/balefire = new(owner)
	owner.mind.AddSpell(balefire)

/obj/effect/proc_holder/spell/aimed/fireball/baali
	name = "Infernal Fireball"
	desc = "This spell fires an explosive fireball at a target."
	school = "evocation"
	charge_max = 60
	clothes_req = FALSE
	invocation = "FR BRTH"
	invocation_type = INVOCATION_WHISPER
	range = 20
	cooldown_min = 20 //10 deciseconds reduction per rank
	projectile_type = /obj/projectile/magic/aoe/fireball/baali
	base_icon_state = "infernaball"
	action_icon_state = "infernaball0"
	action_background_icon_state = "default"
	sound = 'sound/magic/fireball.ogg'
	active_msg = "You prepare to cast your fireball spell!"
	deactive_msg = "You extinguish your fireball... for now."
	active = FALSE

//PSYCHOMACHIA
/datum/discipline_power/daimonion/psychomachia
	name = "Psychomachia"
	desc = "Bring forth the target's greatest fear."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	target_type = TARGET_LIVING
	range = 7

	violates_masquerade = FALSE

/datum/discipline_power/daimonion/psychomachia/activate(mob/living/target)
	. = ..()
	to_chat(target, span_boldwarning("You hear an infernal laugh!"))
	new /datum/hallucination/baali(target, TRUE)

//CONDEMNTATION
/datum/discipline_power/daimonion/condemnation
	name = "Condemnation"
	desc = "Condemn a soul to suffering."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7
	violates_masquerade = TRUE

	var/list/curse_names = list()
	var/list/curses = list()

/datum/discipline_power/daimonion/condemnation/activate(mob/living/target)
	. = ..()
	if(LAZYLEN(GLOB.cursed_characters) == 0 || LAZYLEN(GLOB.cursed_characters) > 0 && !(GLOB.cursed_characters.Find(target)))
		for(var/i in subtypesof(/datum/curse/daimonion))
			var/datum/curse/daimonion/D = new i
			curses += D
			if(owner.generation <= D.genrequired)
				curse_names += initial(D.name)
		to_chat(owner, span_userdanger("The greatest of curses come with the greatest of costs. Are you willing to take the risk of total damnation?"))
		var/chosencurse = tgui_input_list(owner, "Pick a curse to bestow:", "Daimonion", curse_names)
		if(chosencurse)
			for(var/datum/curse/daimonion/C in curses)
				if(C.name == chosencurse)
					C.activate(target)
					owner.maxbloodpool -= C.bloodcurse
					if(owner.bloodpool > owner.maxbloodpool)
						owner.bloodpool = owner.maxbloodpool
					GLOB.cursed_characters += target
		for(var/datum/curse/daimonion/curse in curses)
			qdel(curse)
	else
		to_chat(owner, span_warning("This one is already cursed!"))

