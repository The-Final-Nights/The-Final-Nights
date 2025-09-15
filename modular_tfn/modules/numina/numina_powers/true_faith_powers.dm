/datum/discipline/numina/true_faith
	name = "True Faith"
	desc = "For the LORD is thy Shepard. (PUT DETAILS HERE WHEN POWERS ARE DONE)"
	icon_state = "truefaith"
	clan_restricted = FALSE
	power_type = /datum/discipline_power/true_faith

/datum/discipline_power/true_faith
	name = "true_faith power name"
	desc = "true_faith power description"

	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_power_small.ogg'
	deactivate_sound = 'modular_tfn/modules/numina/sound/truefaith_deactivate_generic.ogg'

/datum/discipline/numina/true_faith/post_gain()
	. = ..()
	if(level == 1)
		var/datum/action/blessing/blessing = new()
		blessing.Grant(owner)
	if(level >= 1)
		blessing.Grant(owner)
		owner.mind.holy_role = HOLY_ROLE_PRIEST
	if(level >= 3)
		var/datum/action/greater_blessing/greater_blessing = new()
		greater_blessing.Grant(owner)
	if(level >= 4)
		var/datum/action/blessing/miracle = new()
		miracle.Grant(owner)
		owner.resistant_to_disciplines = TRUE
	if(level >= 5)
		owner.eye_color = "#ffc65b"
		owner.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		owner.update_body()

/datum/action/blessing
	name = "Blessing"
	desc = "Call upon the powers that be to bless an object of holy significance."
	button_icon_state = "bloodshield"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/blessing/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE) //This is all TODO

/datum/action/greater_blessing
	name = "Sanctify"
	desc = "Call upon the powers that be to empower an object of holy significance."
	button_icon_state = "bloodshield"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/blessing/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE) //This is all TODO

/datum/action/miracle
	name = "Miracle"
	desc = "Through faith, give the wounded a push to survive."
	button_icon_state = "bloodshield"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

/datum/action/blessing/Trigger(trigger_flags)
	. = ..()
	var/mob/living/carbon/human/H = owner
	playsound(H.loc, 'code/modules/wod13/sounds/thaum.ogg', 50, FALSE) //This is all TODO

////////////
/// WARD ///
////////////
// WARD sends away supernatural splats and applies confusion, giving the caster breathing room.

/datum/discipline_power/true_faith/ward
	name = "Exile the Night"
	desc = "Brandish a holy symbol, empowered with prayer, to terrify your enemies."
	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_ward.ogg'

	level = 1
	vitae_cost = 0

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN

	cooldown_length = 15 SECONDS
	duration_length = 7 SECONDS
	range = 12
	var/banish_succeed = FALSE

/datum/discipline_power/true_faith/proc/ward_check(mob/living/carbon/human/owner, mob/living/target, base_difficulty = 4, var/banish_succeed = FALSE)

	var/owner_held_item = owner.get_active_held_item()
	if(!is_type_in_typecache(owner_held_item, GLOB.TFNITEMS_HOLY))
		to_chat(owner, span_warning("You require a holy object to channel your prayer!"))
		return FALSE

	if(!ishuman(target))
		return FALSE

	var/mypower = SSroll.storyteller_roll(owner.get_total_mentality(), difficulty = base_difficulty, mobs_to_show_output = owner, numerical = TRUE)
	var/theirpower = SSroll.storyteller_roll(target.get_total_mentality(), difficulty = 6, mobs_to_show_output = target, numerical = TRUE)

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.clan?.name == CLAN_GARGOYLE)
			theirpower -= 2


	return (mypower > theirpower)

/datum/discipline_power/true_faith/ward/pre_activation_checks(mob/living/target)

	if(!iskindred(target) && !iswerewolf(target))
		return FALSE

	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire) && (vampire.clan?.name == CLAN_BAALI)) //Per the Baali curse, Ward will always take effect and be much more punishing.
		return TRUE
	banish_succeed = ward_check(owner, target, base_difficulty = 4)
	if(banish_succeed)
		return TRUE
	else
		do_cooldown(cooldown_length)
		to_chat(owner, span_warning("[target] is unaffected by your gesture."))
		to_chat(target, span_warning("An overwhelming aura radiates from [owner], scorching hot. However, you manage to steel yourself."))
		return FALSE

/datum/discipline_power/true_faith/ward/activate(mob/living/carbon/human/target) //This is basically the same as the Presence "LEAVE" command.
	. = ..()

	if(banish_succeed)
		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("You've banished [target]!"))
		to_chat(target, span_userlove("You feel a searing pain!"))

		var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
		for(var/i in 1 to 30)
			addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
		if(target.clan?.name == CLAN_BAALI)
			target.emote("scream")
			target.set_confusion(20 SECONDS)
			target.do_jitter_animation(60 SECONDS)
			target.adjust_blurriness(60 SECONDS)
		else
			target.emote("scream")
			target.do_jitter_animation(10 SECONDS)
			target.adjust_blurriness(10 SECONDS)
		SEND_SOUND(target, sound('modular_tfn/modules/numina/sound/truefaith_ward.ogg'))
	else
		to_chat(owner, span_warning("[target] is unaffected by your gesture."))
		return

/datum/discipline_power/true_faith/ward/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

////////////////
/// MEDITATE ///
///////////////
// MEDITATE allows one with True Faith to resist mental domination and coercion.

/datum/discipline_power/true_faith/meditate
	name = "Fortress of the Mind"
	desc = "With absolute faith comes absolute certainty. Channel your belief to resist mental influences."
	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_meditate.ogg'

	level = 2
	vitae_cost = 0

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

/datum/discipline_power/true_faith/meditate/activate()
	. = ..()
	owner.mentality = max(owner.mentality + 4)
	owner.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	owner.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	owner.apply_overlay(MUTATIONS_LAYER)
	addtimer(CALLBACK(src, PROC_REF(clear_halo), owner), 4 SECONDS)

/datum/discipline_power/true_faith/meditate/deactivate()
	. = ..()
	owner.mentality = max(owner.mentality - 4)
	owner.remove_overlay(MUTATIONS_LAYER)


///////////////////
/// SIXTH SENSE ///
//////////////////
// SIXTH SENSE allows the user to see past appearances and ascertain what someone truly is.

/datum/discipline_power/true_faith/sixth_sense
	name = "Sixth Sense"
	desc = "Peer past the veneer and see someone for what they truly are."

	target_type = TARGET_HUMAN
	range = 12
	level = 3

	vitae_cost = 0

	cancelable = TRUE

/datum/discipline_power/true_faith/sixth_sense/activate(mob/living/carbon/human/target)
	. = ..()
	if(target.get_total_social() <= 2)
		to_chat(owner, span_notice("They have trouble speaking clearly."))
	if(target.get_total_mentality() <= 2)
		to_chat(owner, span_notice("They're not particularly bright."))
	if(target.get_total_physique() <= 2)
		to_chat(owner, span_notice("They don't have much mass to them."))
	if(target.get_total_dexterity() <= 2)
		to_chat(owner, span_notice("They lack coordination."))
	if(isgarou(target))
		to_chat(owner, span_notice("The predatory look in their eyes reminds you of a wild animal."))
		sixth_sense_auspice_assessment(target, owner)
	if(iskindred(target))
		sixth_sense_clan_assessment(target, owner)
	if(isghoul(target))
		to_chat(owner, span_notice("They occasionally twitch and shiver, hungry for something."))
	if(!iskindred(target) && !isghoul(target) && !isgarou(target))
		to_chat(owner, span_notice("[target] doesn't seem all that special."))

/datum/discipline_power/true_faith/sixth_sense/proc/sixth_sense_clan_assessment(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire))
		switch(vampire.clan?.name)
			if(CLAN_TOREADOR)
				to_chat(owner, span_notice("[target] stares at little details."))
				return
			if(CLAN_DAUGHTERS_OF_CACOPHONY)
				to_chat(owner, span_notice("[target]'s is constantly humming to themselves."))
				return
			if(CLAN_VENTRUE)
				to_chat(owner, span_notice("[target] often looks like they're above it all."))
				return
			if(CLAN_LASOMBRA)
				to_chat(owner, span_notice("[target] never seems to look at themselves."))
				return
			if(CLAN_TZIMISCE)
				to_chat(owner, span_warning("[target] gives you a horrific, skin-crawling feeling."))
				return
			if(CLAN_GANGREL)
				to_chat(owner, span_notice("[target] is particularly twitchy."))
				return
			if(CLAN_MALKAVIAN)
				to_chat(owner, span_notice("[target] doesn't seem to be all there."))
				return
			if(CLAN_BRUJAH)
				to_chat(owner, span_notice("[target] has this angry look on their face a lot."))
			if(CLAN_NOSFERATU)
				to_chat(owner, span_notice("[target] is very concerned about appearances."))
				return
			if(CLAN_TREMERE)
				to_chat(owner, span_warning("[target] makes you very, very uneasy."))
				return
			if(CLAN_BAALI)
				to_chat(owner, span_boldwarning("[target] is an abomination before God!"))
				return
			if(CLAN_BANU_HAQIM)
				to_chat(owner, span_notice("[target] looks like they're judging you."))
				return
			if(CLAN_TRUE_BRUJAH)
				to_chat(owner, span_notice("[target] never expresses themselves."))
				return
			if(CLAN_SALUBRI)
				to_chat(owner, span_notice("[target] doesn't seem all that special."))
				return
			if(CLAN_GIOVANNI)
				to_chat(owner, span_notice("[target] has a very peculiar last name..."))
				return
			if(CLAN_CAPPADOCIAN)
				to_chat(owner, span_warning("[target] smells of rot."))
				return
			if(CLAN_KIASYD)
				to_chat(owner, span_notice("[target] is pretty tall."))
				return
			if(CLAN_GARGOYLE)
				to_chat(owner, span_notice("[target] moves with a strangely rigid gait."))
				return
			if(CLAN_SETITES)
				to_chat(owner, span_warning("[target] fills you with disgust."))
				return

			else
				to_chat(owner, span_notice("[target] doesn't seem all that special."))

/datum/discipline_power/true_faith/sixth_sense/proc/sixth_sense_auspice_assessment(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/werewolf/werewolf = target
	if(isgarou(werewolf))
		switch(werewolf.auspice?.name)
			if("Ahroun")
				to_chat(owner, span_notice("[target] is seemingly always angry."))
				return
			if("Galliard")
				to_chat(owner, span_notice("[target]'s is always listening to the background noise."))
				return
			if("Philodox")
				to_chat(owner, span_notice("[target] seems to have an eye for detail."))
				return
			if("Theurge")
				to_chat(owner, span_notice("[target] reminds you of your own spiritual persuasion."))
				return
			if("Ragabash")
				to_chat(owner, span_notice("[target] commonly has a dumb grin on their face."))
				return

			else
				to_chat(owner, span_notice("[target] seems lonely."))

/////////////
/// DOGMA ///
/////////////
// DOGMA is an adaptation of one of True Faith's MAGE abilities, since resistance to mental effects is accomplished with their DOT 2 ability.
// DOGMA essentially is just a weaker fortitude that allows you to soak some more damage while active. It has no inactive effects.

/datum/discipline_power/true_faith/dogma
	name = "Dogmatic Assurance"
	desc = "Your faith gives you the strength to go on, even in the face of great adversity."

	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_power_greater.ogg'

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 0

	toggled = TRUE
	duration_length = 2 TURNS

	var/dogma_DR = 25

/datum/discipline_power/true_faith/dogma/activate()
	. = ..()
	owner.physiology.damage_resistance = min(60, (owner.physiology.damage_resistance+dogma_DR) )
	owner.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	owner.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	owner.apply_overlay(MUTATIONS_LAYER)
	addtimer(CALLBACK(src, PROC_REF(clear_halo), owner), 4 SECONDS)

/datum/discipline_power/true_faith/dogma/deactivate()
	. = ..()
	owner.physiology.damage_resistance = max(0, (owner.physiology.damage_resistance-dogma_DR) )
	owner.remove_overlay(MUTATIONS_LAYER)

/////////////////
/// PERDITION ///
/////////////////
// At this point of True Faith, the individual is so incredibly Holy that they can cause havoc to the undead by their mere presence.

/datum/discipline_power/true_faith/perdition
	name = "Perdition"
	desc = "In flaming fire taking vengeance on them that know not God, and that obey not the gospel: Who shall be punished with everlasting destruction from the presence of the Lord, and from the glory of his power."
	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_power_overwhelming.ogg'

	level = 5
	vitae_cost = 0

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK

	multi_activate = TRUE
	cooldown_length = 60 SECONDS
	duration_length = 30 SECONDS

	range = 12
	var/banish_succeed = FALSE

/datum/discipline_power/true_faith/perdition/activate()
	. = ..()
	for(var/mob/living/carbon/human/target in oviewers(7, owner))
		if(!iskindred(target) && !iswerewolf(target))
			to_chat(owner, span_warning("[target] is unaffected by your power."))
			return

		var/mypower = SSroll.storyteller_roll(owner.get_total_mentality(), difficulty = 2, mobs_to_show_output = owner, numerical = TRUE)
		var/theirpower = SSroll.storyteller_roll(target.get_total_mentality(), difficulty = 3, mobs_to_show_output = target, numerical = TRUE)

		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			if(human_target.clan?.name == CLAN_GARGOYLE)
				theirpower -= 2
			if(human_target.clan?.name == CLAN_BAALI)
				target.emote("scream")
				playsound(src, 'sound/magic/demon_dies.ogg', 50)
				target.dust()
				return

		if(mypower <= theirpower)
			return


		target.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
		presence_overlay.pixel_z = 1
		target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
		target.apply_overlay(MUTATIONS_LAYER)

		to_chat(owner, span_warning("[target] is rended asunder!"))
		to_chat(target, span_cultlarge("OH GOD IT BURNS!"))

		var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
		for(var/i in 1 to 30)
			addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
		target.emote("scream")
		target.set_confusion(30 SECONDS)
		target.do_jitter_animation(60 SECONDS)
		target.adjust_blurriness(30 SECONDS)
		target.adjustFireLoss(70)
		SEND_SOUND(target, sound('modular_tfn/modules/numina/sound/perdition_effect.ogg'))

		return

/datum/discipline_power/true_faith/perdition/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)


//this is a general proc to remove the halo for powers that would otherwise keep it too long
/datum/discipline_power/true_faith/proc/clear_halo(mob/living/carbon/human/owner)
	owner.remove_overlay(MUTATIONS_LAYER)
