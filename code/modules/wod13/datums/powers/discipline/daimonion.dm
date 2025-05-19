/datum/discipline/daimonion
	name = "Daimonion"
	desc = "Draw power from the demons and infernal nature of Hell. Use subtle power to manipulate people and when you must, draw upon fire itself and protect yourself."
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
	if(target.get_total_social() <= 2)
		to_chat(owner, span_notice("Victim is not social or influencing."))
	if(target.get_total_mentality() <= 2)
		to_chat(owner, span_notice("Victim lacks appropiate willpower."))
	if(target.get_total_physique() <= 2)
		to_chat(owner, span_notice("Victim's body is weak and feeble."))
	if(target.get_total_dexterity() <= 2)
		to_chat(owner, span_notice("Victim's lacks coordination."))
	if(isgarou(target))
		to_chat(owner, span_notice("Victim's natural banishment is silver..."))
	if(iskindred(target))
		baali_get_moral_failings(target, owner)
		baali_get_stolen_disciplines(target, owner)
	if(isghoul(target))
		var/mob/living/carbon/human/ghoul = target
		if(ghoul.mind.enslaved_to)
			to_chat(owner, span_notice("Victim is addicted to vampiric vitae and its true master is [ghoul.mind.enslaved_to]"))
		else
			to_chat(owner, span_notice("Victim is addicted to vampiric vitae, but is independent and free."))
	if(iscathayan(target))
		if(target.mind.dharma?.Po == "Legalist")
			to_chat(owner, span_notice("[target] hates to be controlled!"))
		if(target.mind.dharma?.Po == "Rebel")
			to_chat(owner, span_notice("[target] doesn't like to be touched."))
		if(target.mind.dharma?.Po == "Monkey")
			to_chat(owner, span_notice("[target] is too focused on money, toys and other sources of easy pleasure."))
		if(target.mind.dharma?.Po == "Demon")
			to_chat(owner, span_notice("[target] is addicted to pain, as well as to inflicting it to others."))
		if(target.mind.dharma?.Po == "Fool")
			to_chat(owner, span_notice("[target] doesn't like to be pointed at!"))
	if(!iskindred(target) && !isghoul(target) && !isgarou(target) && !iscathayan(target))
		to_chat(owner, span_notice("[target] is a feeble worm with no strengths or visible weaknesses, a mere human."))

/datum/discipline_power/daimonion/sense_the_sin/proc/baali_get_moral_failings(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire))
		switch(vampire.clane?.name)
			if("Toreador")
				to_chat(owner, span_notice("[target] is obsessive to a fault."))
				return
			if("Daughters of Cacophony")
				to_chat(owner, span_notice("[target]'s mind is envelopped by nonstopping music."))
			if("Ventrue")
				to_chat(owner, span_notice("[target] finds no pleasure in poor's blood."))
				return
			if("Lasombra")
				to_chat(owner, span_notice("[target] fears change itself evermore."))
				return
			if("Tzimisce")
				to_chat(owner, span_notice("[target] is consumed by a singular desire."))
				return
			if("Gangrel")
				to_chat(owner, span_notice("[target] is unable to control their impulses."))
				return
			if("Malkavian")
				to_chat(owner, span_notice("[target] frightens people near them."))
				return
			if("Brujah")
				to_chat(owner, span_notice("[target] is cursed to anger for their shame at carthage.."))
			if("Nosferatu")
				to_chat(owner, span_notice("[target] is entranced by that which is unknown."))
				return
			if("Tremere")
				to_chat(owner, span_notice("[target] has a sense of perfectionism by their own actions."))
				return
			if("Baali")
				to_chat(owner, span_notice("[target] is scared of the lord's presence."))
				return
			if("Banu Haqim")
				to_chat(owner, span_notice("[target] sees themselves as absolute judgement."))
				return
			if("True Brujah")
				to_chat(owner, span_notice("[target] cant express emotions."))
				return
			if("Salubri")
				to_chat(owner, span_notice("[target] is ruled by consent."))
				return
			if("Giovanni")
				to_chat(owner, span_notice("[target] never considers any action too great for their family."))
				return
			if("Cappadocian")
				to_chat(owner, span_notice("[target] will never escape the appearance of a corpse."))
				return
			if("Kiasyd")
				to_chat(owner, span_notice("[target] is afraid of cold iron."))
				return
			if("Gargoyle")
				to_chat(owner, span_notice("[target]'s mind is a fortress with gates open and unbarred."))
				return
			if("Ministry")
				to_chat(owner, span_notice("[target] believes every stain of sin is a virtue."))
				return

			else
				to_chat(owner, span_notice("[target] has been abandoned by the cold ocean of the night with nobody to keep them afloat."))


/datum/discipline_power/daimonion/sense_the_sin/proc/baali_get_stolen_disciplines(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire))
		var/datum/species/kindred/clan = vampire.dna.species
		if(clan.get_discipline("Quietus") && vampire.clane?.name != "Banu Haqim")
			to_chat(owner, span_notice("[target] fears that the fact they stole Banu Haqim's Quietus will be known."))
		if(clan.get_discipline("Protean") && vampire.clane?.name != "Gangrel")
			to_chat(owner, span_notice("[target] fears that the fact they stole Gangrel's Protean will be known."))
		if(clan.get_discipline("Serpentis") && vampire.clane?.name != "Ministry")
			to_chat(owner, span_notice("[target] fears that the fact they stole Ministry's Serpentis will be known."))
		if(clan.get_discipline("Necromancy") && vampire.clane?.name != "Giovanni" || clan.get_discipline("Necromancy") && vampire.clane?.name != "Cappadocian")
			to_chat(owner, span_notice("[target] fears that the fact they stole Giovanni's Necromancy will be known."))
		if(clan.get_discipline("Obtenebration") && vampire.clane?.name != "Lasombra")
			to_chat(owner, span_notice("[target] fears that the fact they stole Lasombra's Obtenebration will be known."))
		if(clan.get_discipline("Dementation") && vampire.clane?.name != "Malkavian")
			to_chat(owner, span_notice("[target] fears that the fact they stole Malkavian's Dementation will be known."))
		if(clan.get_discipline("Vicissitude") && vampire.clane?.name != "Tzimisce")
			to_chat(owner, span_notice("[target] fears that the fact they stole Tzimisce's Vicissitude will be known."))
		if(clan.get_discipline("Melpominee") && vampire.clane?.name != "Daughters of Cacophony")
			to_chat(owner, span_notice("[target] fears that the fact they stole Daughters of Cacophony's Melpominee will be known."))
		if(clan.get_discipline("Daimonion") && vampire.clane?.name != "Baali")
			to_chat(owner, span_notice("[target] fears that the fact they stole Baali's Daimonion will be known."))
		if(clan.get_discipline("Temporis") && vampire.clane?.name != "True Brujah")
			to_chat(owner, span_notice("[target] fears that the fact they stole True Brujah's Temporis will be known."))
		if(clan.get_discipline("Valeren") && vampire.clane?.name != "Salubri")
			to_chat(owner, span_notice("[target] fears that the fact they stole Salubri's Valeren will be known."))
		if(clan.get_discipline("Mytherceria") && vampire.clane?.name != "Kiasyd")
			to_chat(owner, span_notice("[target] fears that the fact they stole Kiasyd's Mytherceria will be known."))

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
	if(SSroll.storyteller_roll(owner.get_total_social(), target.get_total_mentality(), mobs_to_show_output = owner) == !ROLL_SUCCESS)
		to_chat(owner, span_warning("[target] has too much willpower to induce fear into them!"))
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/fear_of_the_void_below/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, span_warning("Your mind is enveloped by your greatest fear!"))
	if(prob(50)) // Stuns/Sleeps target
		target.Paralyze(6 SECONDS)
	else
		target.Sleeping(6 SECONDS)

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
	if(SSroll.storyteller_roll(owner.get_total_mentality(), 6, mobs_to_show_output = owner) == ROLL_SUCCESS)
		to_chat(target, span_boldwarning("You hear an infernal laugh!"))
		new /datum/hallucination/baali(target, TRUE)
		return TRUE

	to_chat(owner, "<span class='warning'>[target] has too much willpower to induce fear into them!</span>")
	return FALSE

//CONDEMNTATION
/datum/discipline_power/daimonion/condemnation
	name = "Condemnation"
	desc = "Condemn a soul to suffering."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7
	violates_masquerade = TRUE

	var/initialized_curses = FALSE //can't do this in new since it wouldn't have assigned owner yet. this will do.
	var/list/curse_names = list()
	var/list/curses = list()

/datum/discipline_power/daimonion/condemnation/activate(mob/living/target)
	. = ..()
	if(LAZYLEN(GLOB.cursed_characters) == 0 || LAZYLEN(GLOB.cursed_characters) > 0 && !(GLOB.cursed_characters.Find(target)))
		if(!initialized_curses)
			for(var/i in subtypesof(/datum/curse/daimonion))
				var/datum/curse/daimonion/daimonion_curse = new i
				curses += daimonion_curse
				if(owner.generation <= daimonion_curse.genrequired)
					curse_names += initial(daimonion_curse.name)
				initialized_curses = TRUE

		to_chat(owner, span_userdanger("The greatest of curses come with the greatest of costs. Are you willing to take the risk of total damnation?"))
		var/chosencurse = tgui_input_list(owner, "Pick a curse to bestow:", "Daimonion", curse_names)
		if(!chosencurse)
			return
		for(var/datum/curse/daimonion/C in curses)
			if(C.name == chosencurse)
				if(SSroll.storyteller_roll(owner.get_total_social(), target.get_total_mentality(), mobs_to_show_output = owner) == !ROLL_SUCCESS)
					to_chat(owner, span_warning("Your mind fails to pierce their mind!"))
					to_chat(target, span_warning("You resists something that tried to pierce your mind."))
					return
				C.activate(target)
				owner.maxbloodpool -= C.bloodcurse
				if(owner.bloodpool > owner.maxbloodpool)
					owner.bloodpool = owner.maxbloodpool
				GLOB.cursed_characters += target
	else
		to_chat(owner, span_warning("This one is already cursed!"))

