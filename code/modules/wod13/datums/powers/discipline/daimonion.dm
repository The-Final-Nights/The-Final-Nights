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
	if(isgarou(target))
		to_chat(owner, "Victim's natural banishment is silver...")
	if(iskindred(target))
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
	if(!iskindred(target) && !isghoul(target) && !isgarou(target))
		to_chat(owner, "Victim is a feeble worm with no strengths or visible weaknesses.")


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
	created_fireball.fire(direct_target = target)

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
					owner.cursed_bloodpool += C.bloodcurse
	else
		to_chat(owner, span_warning("This one is already cursed!"))

