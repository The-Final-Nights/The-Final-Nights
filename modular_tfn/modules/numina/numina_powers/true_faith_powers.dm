/datum/discipline/numina/true_faith
	name = "True Faith"
	desc = "For the LORD is thy Shepard. True Faith provides the user with numerous blessings dependent on how potent it is. \
	At <b>First Level</b>, you can repel nightcreatures with holy symbols. \
	At <b>Second Level</b>, you can improve your Mentality score by 4 through meditation. \
	At <b>Third Level</b>, you can see through appearances and tell what someone truly is. \
	At <b>Fourth Level</b>, you can soak damage with Faith and are immune to all mental Disciplines. \
	At <b>Fifth Level</b>, you can repulse and damage all nearby nightcreatures."
	icon_state = "truefaith"
	clan_restricted = FALSE
	power_type = /datum/discipline_power/true_faith

//Since disciplines were never designed with a resource other than Vitae in mind, we have to do some fuckery to make it work.
/datum/discipline_power/true_faith
	name = "true_faith power name"
	desc = "true_faith power description"

	vitae_cost = 0
	var/faith_cost = 0

	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_power_small.ogg'
	deactivate_sound = 'modular_tfn/modules/numina/sound/truefaith_deactivate_generic.ogg'

/datum/discipline_power/true_faith/proc/can_afford_faith() //Can't overwrite the parent proc because it throws a fit and refuses to work
	var/mob/living/H = owner
	if(owner == null)
		return //Runtime prevention on game startup
	return (H.faith >= faith_cost)

/datum/discipline_power/true_faith/can_activate_untargeted(alert = FALSE)
	. = .. ()
	if(!can_afford_faith())
		return FALSE

/datum/discipline_power/true_faith/spend_resources()
	if (can_afford_faith())
		owner.faith = owner.faith - src.faith_cost
		owner.update_action_buttons()
		owner.update_faith_hud()
		return TRUE
	else
		to_chat(owner, span_warning("Your faith is too exhausted to use [src]!"))
		return FALSE

/datum/discipline/numina/true_faith/post_gain()
	. = ..()
	owner.faith = 5
	if(level >= 1)
		var/datum/action/numina/truefaith_action/pray/pray = new()
		var/datum/action/numina/truefaith_action/blessing/blessing = new()
		pray.Grant(owner)
		blessing.Grant(owner)
		owner.mind.holy_role = HOLY_ROLE_PRIEST
	if(level >= 4)
		var/datum/action/numina/truefaith_action/miracle/miracle = new()
		owner.resistant_to_disciplines = TRUE
		miracle.Grant(owner)
	if(level >= 5)
		owner.eye_color = "#ffd900"
		owner.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		owner.update_body()
	owner.update_faith_hud()

/datum/action/numina/truefaith_action
	name = "truefaith action"
	desc = "truefaith desc."

	var/faith_cost = 0

/datum/action/numina/truefaith_action/proc/use_resources()
	var/mob/living/carbon/human/H = owner
	if(H.faith < faith_cost)
		to_chat(H, span_warning("Your <b>FAITH</b> is too exhausted to do that! Needs [faith_cost] points of <b>FAITH.</b>"))
		return FALSE
	else
		H.faith -= faith_cost
	H.update_faith_hud()
	return TRUE


/datum/action/numina/truefaith_action/pray
	name = "Prayer"
	desc = "Pray over a holy object to regain certainty in your belief."
	cool_down = 10 SECONDS
	button_icon_state = "prayer"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

	COOLDOWN_DECLARE(prayer)

/datum/action/numina/truefaith_action/pray/Trigger(trigger_flags)
	. = ..()
	if (!COOLDOWN_FINISHED(src, prayer))
		to_chat(owner, span_warning("Praying again will do little for another [DisplayTimeText(COOLDOWN_TIMELEFT(src, prayer))]."))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/owner_held_item = H.get_active_held_item()
	if(!is_type_in_typecache(owner_held_item, GLOB.TFNITEMS_HOLY))
		to_chat(owner, span_warning("You require a holy object to channel your prayer!"))
		return FALSE
	to_chat(owner, span_slime("You look within..."))
	if(!do_after(owner, 5 SECONDS))
		to_chat(owner, span_warning("Your prayer is interrupted!"))
		return
	if(H.faith < 10)
		H.faith = clamp(H.faith+2, 0, 10)
	to_chat(owner, span_slime("You feel your resolve strengthen."))
	COOLDOWN_START(src, prayer, cool_down)
	H.update_faith_hud()

/datum/action/numina/truefaith_action/blessing
	name = "Sanctify"
	desc = "Call upon the powers that be to temporarily empower an object of holy significance."
	cool_down = 1 MINUTES
	button_icon_state = "blessing"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

	faith_cost = 2

	COOLDOWN_DECLARE(blessing)

/datum/action/numina/truefaith_action/blessing/Trigger(trigger_flags)
	. = ..()
	if(!use_resources())
		return
	if (!COOLDOWN_FINISHED(src, blessing))
		to_chat(owner, span_warning("You can't empower anything for another [DisplayTimeText(COOLDOWN_TIMELEFT(src, blessing))]!"))
		return
	var/hand_object
	var/mob/living/carbon/human/H = owner
	var/obj/item/owner_held_item = H.get_active_held_item()
	if(!is_type_in_typecache(owner_held_item, GLOB.TFNITEMS_HOLY))
		to_chat(owner, span_warning("You require a holy object to channel your prayer!"))
		return FALSE
	switch(owner_held_item.type)
		if(/obj/item/clothing/neck/vampire/prayerbeads)
			hand_object = new /obj/item/blessed_object/blessed_prayer_beads(H.drop_location())
			qdel(owner_held_item)
			H.put_in_active_hand(hand_object)
		if(/obj/item/storage/book/bible)
			hand_object = new /obj/item/blessed_object/blessed_bible(H.drop_location())
			qdel(owner_held_item)
			H.put_in_active_hand(hand_object)
		if(/obj/item/vampirebook/quran, /obj/item/quran)
			hand_object = new /obj/item/blessed_object/blessed_quran(H.drop_location())
			qdel(owner_held_item)
			H.put_in_active_hand(hand_object)
		if(/obj/item/card/id/hunter)
			hand_object = new /obj/item/blessed_object/blessed_cross_necklace(H.drop_location())
			qdel(owner_held_item)
			H.put_in_active_hand(hand_object)
		else
			to_chat(owner, span_notice("Nothing happens."))
			return

	playsound(H.loc, 'modular_tfn/modules/numina/sound/truefaith_power_small.ogg', 50, FALSE)
	to_chat(owner, span_slime("[owner_held_item] begins to glow softly..."))
	COOLDOWN_START(src, blessing, cool_down)

/datum/action/numina/truefaith_action/miracle
	name = "Miracle"
	desc = "Through faith, give the wounded a push to survive."
	button_icon_state = "faithheal"
	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS

	cool_down = 2 MINUTES
	COOLDOWN_DECLARE(miracle)

	faith_cost = 4

/datum/action/numina/truefaith_action/miracle/Trigger(trigger_flags)
	. = ..()
	if(!use_resources())
		return
	if (!COOLDOWN_FINISHED(src, miracle))
		to_chat(owner, span_warning("You can't perform a miracle for another [DisplayTimeText(COOLDOWN_TIMELEFT(src, miracle))]!"))
		return
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		H.put_in_active_hand(new /obj/item/melee/touch_attack/truefaith_heal(H))
	COOLDOWN_START(src, miracle, cool_down)

////////////
/// WARD ///
////////////
// WARD sends away supernatural splats and applies confusion, giving the caster breathing room.

/datum/discipline_power/true_faith/ward
	name = "Exile the Night"
	desc = "Brandish a holy symbol, empowered with prayer, to terrify your enemies."
	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_ward.ogg'

	level = 1
	faith_cost = 1

	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN

	cooldown_length = 8 SECONDS
	duration_length = 7 SECONDS
	range = 7
	var/banish_succeed = FALSE

/datum/discipline_power/true_faith/ward/proc/ward_check(mob/living/carbon/human/owner, mob/living/target, base_difficulty = 4, banish_succeed = FALSE)
	var/owner_held_item = owner.get_active_held_item()
	owner.face_atom(target)
	if(!is_type_in_typecache(owner_held_item, GLOB.TFNITEMS_HOLY))
		to_chat(owner, span_warning("You require a holy object to channel your prayer!"))
		return FALSE

	if(!ishuman(target))
		return FALSE

	if(!iskindred(target))
		to_chat(owner, span_warning("[target] is unaffected by your gesture."))
		return FALSE

	var/mypower = SSroll.storyteller_roll(owner.get_total_mentality(), difficulty = base_difficulty, mobs_to_show_output = owner, numerical = TRUE)
	var/theirpower = SSroll.storyteller_roll(target.get_total_mentality(), difficulty = 6, mobs_to_show_output = target, numerical = TRUE)

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if((human_target.morality_path?.alignment != MORALITY_HUMANITY) && (human_target.morality_path?.score >= 4))
			theirpower -= round(human_target.morality_path?.score / 2)

	return (mypower > theirpower)

/datum/discipline_power/true_faith/ward/pre_activation_checks(mob/living/target)
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire) && (vampire.clan?.name == CLAN_BAALI)) //Per the Baali curse, Ward will always take effect and be much more punishing.
		return TRUE
	if(iskindred(target) && (vampire.morality_path?.alignment == MORALITY_HUMANITY) && (vampire.morality_path?.score >= 8))
		to_chat(owner, span_warning("[target] is unaffected by your gesture."))
		do_cooldown(cooldown_length)
		return FALSE
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
		to_chat(target, span_userlove("You feel a searing pain. An all-consuming terror courses through your being. You have to get away from here!"))

		var/datum/cb = CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
		for(var/i in 1 to 30)
			addtimer(cb, (i - 1) * target.total_multiplicative_slowdown())
		if(target.clan?.name == CLAN_BAALI)
			target.emote("scream")
			target.set_confusion(20 SECONDS)
			target.do_jitter_animation(60 SECONDS)
			target.adjust_blurriness(60 SECONDS)
			target.take_overall_damage(burn = 30)
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

///////////////////
/// SIXTH SENSE ///
//////////////////
// SIXTH SENSE allows the user to see past appearances and ascertain what someone truly is.

/datum/discipline_power/true_faith/sixth_sense
	name = "Sixth Sense"
	desc = "Peer past the veneer and see someone for what they truly are."
	deactivate_sound = null

	target_type = TARGET_HUMAN
	faith_cost = 2

	range = 12
	level = 2

	cancelable = TRUE

/datum/discipline_power/true_faith/sixth_sense/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, span_slime("You start to focus in on [target]..."))
	owner.face_atom(target)
	if(!do_after(owner, 7 SECONDS, NONE, NONE))
		to_chat(owner, span_warning("You have to focus to get a read on [target]."))
		return
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
		sixth_sense_humanity_assessment(target, owner)
	if(isghoul(target))
		to_chat(owner, span_notice("They occasionally twitch and shiver, hungry for something."))
	if(!iskindred(target) && !isghoul(target) && !isgarou(target))
		sixth_sense_numina_assessment(target, owner)

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
			if(CLAN_OLD_TZIMISCE)
				to_chat(owner, span_warning("[target] fills you with an unearthly dread."))
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
			if(CLAN_SALUBRI_WARRIOR)
				to_chat(owner, span_notice("[target] looks like they're stewing on something."))
				return
			if(CLAN_GIOVANNI)
				to_chat(owner, span_notice("[target] has a very peculiar last name..."))
				return
			if(CLAN_CAPPADOCIAN)
				to_chat(owner, span_warning("[target] smells of rot."))
				return
			if(CLAN_KIASYD)
				to_chat(owner, span_notice("[target] has a whimsical air about them."))
				return
			if(CLAN_GARGOYLE)
				to_chat(owner, span_notice("[target] moves with a strangely rigid gait."))
				return
			if(CLAN_SETITES)
				to_chat(owner, span_warning("[target] fills you with disgust."))
				return
			if(CLAN_NAGARAJA)
				to_chat(owner, span_warning("[target] smells of iron and rust."))
				return

			else
				to_chat(owner, span_notice("[target] doesn't seem all that special."))

/datum/discipline_power/true_faith/sixth_sense/proc/sixth_sense_humanity_assessment(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire))
		if(vampire.morality_path?.alignment == MORALITY_HUMANITY)
			switch(vampire.morality_path?.score)
				if(0)
					to_chat(owner, span_ghostalert("Whoever they were is no longer here."))
					return
				if(1 to 3)
					to_chat(owner, span_cult("[target] is possessed by something terrible."))
					return
				if(4)
					to_chat(owner, span_warning("[target] has fallen from grace."))
					return
				if(5 to 9)
					return
				if(10)
					to_chat(owner, span_greenteamradio("[target] may yet be saved."))
					return
				else
					return
		if(vampire.morality_path?.alignment != MORALITY_HUMANITY)
			switch(vampire.morality_path?.score)
				if(0)
					to_chat(owner, span_ghostalert("Whoever they were is no longer here."))
					return
				if(1 to 3)
					to_chat(owner, span_alertwarning("[target] teeters on the brink of self destruction."))
					return
				if(4)
					to_chat(owner, span_warning("[target] has lost their way."))
					return
				if(5 to 9)
					to_chat(owner, span_cult("[target] is possessed by something terrible."))
					return
				if(10)
					to_chat(owner, span_phobia("[target] is a shell puppeted by the demonic."))
					return
				else
					return
		else
			return

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
				to_chat(owner, span_notice("[target] seems to have a knack for detail."))
				return
			if("Philodox")
				to_chat(owner, span_notice("[target] seems to be silently judging you."))
				return
			if("Theurge")
				to_chat(owner, span_notice("[target] reminds you of your own spiritual persuasion."))
				return
			if("Ragabash")
				to_chat(owner, span_notice("[target] just seems shifty."))
				return

			else
				to_chat(owner, span_notice("[target] seems lonely."))

/datum/discipline_power/true_faith/sixth_sense/proc/sixth_sense_numina_assessment(target, owner)
	if(!owner || !target)
		return
	var/mob/living/carbon/human/human = target
	if(!iskindred(human)) //Just incase
		switch(human.numina?.name)
			if(NUMINA_FAITH)
				to_chat(owner, span_yellowteamradio("[target] walks in the light."))
				return
			else
				to_chat(owner, span_notice("[target] doesn't seem all that special."))

////////////////
/// MEDITATE ///
///////////////
// MEDITATE allows one with True Faith to resist mental domination and coercion.

/datum/discipline_power/true_faith/meditate
	name = "Fortress of the Mind"
	desc = "With absolute faith comes absolute certainty. Channel your belief to resist mental influences."
	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_meditate.ogg'

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS
	faith_cost = 4

	cooldown_length = 2 MINUTES
	duration_length = 2 MINUTES

/datum/discipline_power/true_faith/meditate/activate()
	. = ..()
	owner.mentality = owner.mentality += 2
	owner.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	owner.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	owner.apply_overlay(MUTATIONS_LAYER)
	addtimer(CALLBACK(src, PROC_REF(clear_halo), owner), 4 SECONDS)

/datum/discipline_power/true_faith/meditate/deactivate()
	. = ..()
	owner.mentality = owner.mentality -= 2
	owner.remove_overlay(MUTATIONS_LAYER)

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
	faith_cost = 5

	cooldown_length = 3 MINUTES
	duration_length = 3 MINUTES

	var/dogma_DR = 25

/datum/discipline_power/true_faith/dogma/activate()
	. = ..()
	owner.physiology.damage_resistance = min(60, (owner.physiology.damage_resistance+dogma_DR) )
	owner.remove_overlay(HALO_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -HALO_LAYER)
	presence_overlay.pixel_z = 1
	owner.overlays_standing[HALO_LAYER] = presence_overlay
	owner.apply_overlay(HALO_LAYER)

/datum/discipline_power/true_faith/dogma/deactivate()
	. = ..()
	owner.physiology.damage_resistance = max(0, (owner.physiology.damage_resistance-dogma_DR) )
	owner.remove_overlay(HALO_LAYER)

/////////////////
/// PERDITION ///
/////////////////
// At this point of True Faith, the individual is so incredibly Holy that they can cause havoc to the undead by their mere presence.

/datum/discipline_power/true_faith/perdition
	name = "Perdition"
	desc = "In flaming fire taking vengeance on them that know not God, and that obey not the gospel: Who shall be punished with everlasting destruction from the presence of the Lord, and from the glory of his power."
	activate_sound = 'modular_tfn/modules/numina/sound/truefaith_power_overwhelming.ogg'

	level = 5
	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	faith_cost = 5

	multi_activate = TRUE
	cooldown_length = 4 MINUTES
	duration_length = 30 SECONDS

/datum/discipline_power/true_faith/perdition/activate()
	. = ..()
	owner.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dominate", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	owner.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	owner.apply_overlay(MUTATIONS_LAYER)
	for(var/mob/living/carbon/human/target in oviewers(7, owner))
		punish_sinner(target, owner)
	addtimer(CALLBACK(src, PROC_REF(clear_halo), owner), 5 SECONDS)

/datum/discipline_power/true_faith/perdition/proc/punish_sinner(mob/living/target)
	var/mob/living/carbon/human/sinner = target
	var/mob/living/carbon/werewolf/fera = sinner
	var/fera_affected = FALSE

	if(isgarou(sinner))
		fera_affected = TRUE

	var/mutable_appearance/presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "dominate", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	if(!iskindred(sinner) && !isgarou(sinner))
		to_chat(owner, span_warning("[sinner] is unaffected by your power."))
		return
	if(iskindred(sinner) && (sinner.morality_path?.alignment == MORALITY_HUMANITY) && (sinner.morality_path?.score >= 8))
		to_chat(owner, span_warning("[sinner] is unaffected by your power."))
		return

	var/mypower = SSroll.storyteller_roll(owner.get_total_mentality(), difficulty = 7, mobs_to_show_output = owner, numerical = TRUE)
	var/theirpower = SSroll.storyteller_roll(sinner.get_total_mentality(), difficulty = (fera_affected ? 7 : 9), mobs_to_show_output = sinner, numerical = TRUE)

	if(ishuman(sinner))
		if((sinner.morality_path?.alignment != MORALITY_HUMANITY) && (sinner.morality_path?.score >= 4))
			theirpower -= round(sinner.morality_path?.score / 2)

	if((mypower <= theirpower) && (sinner.clan?.name != CLAN_BAALI))
		to_chat(owner, span_warning("[sinner] resists your influence!"))
		return

	sinner.remove_overlay(MUTATIONS_LAYER)
	presence_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	sinner.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	sinner.apply_overlay(MUTATIONS_LAYER)

	var/datum/cb = CALLBACK(sinner, TYPE_PROC_REF(/mob/living/carbon/human, step_away_caster), owner)
	for(var/i in 1 to 30)
		addtimer(cb, (i - 1) * sinner.total_multiplicative_slowdown())
	if(ishuman(sinner))
		if(sinner.clan?.name == CLAN_BAALI)
			sinner.emote("scream")
			sinner.flash_act()
			sinner.set_confusion(60 SECONDS)
			sinner.do_jitter_animation(120 SECONDS)
			sinner.adjust_blurriness(120 SECONDS)
			sinner.take_overall_damage(burn = 85)
			sinner.adjust_fire_stacks(10)
			sinner.IgniteMob()
			playsound(sinner, 'sound/magic/demon_dies.ogg', 50, TRUE, 5)
		if(isgarou(sinner)) //verin said to keep it, so im keeping it.
			fera.flash_act()
			fera.Paralyze(4 SECONDS)
			fera.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)
			//fera.transformator.transform(fera, fera.auspice?.breed_form, TRUE) Lupus is currently bugged to fuck. Uncomment when transformator is fixed.
			fera.auspice?.rage = 0
			fera.auspice?.gnosis = 0
			SEND_SOUND(sinner, sound('modular_tfn/modules/numina/sound/perdition_effect.ogg'))
			addtimer(CALLBACK(src, PROC_REF(deactivate), sinner), 30 SECONDS)
			to_chat(sinner, span_cultlarge("Your body starts to change on its own!"))
			return
		else
			sinner.emote("scream")
			sinner.set_confusion(30 SECONDS)
			sinner.do_jitter_animation(60 SECONDS)
			sinner.adjust_blurriness(30 SECONDS)
			sinner.take_overall_damage(burn = 60)
			sinner.flash_act()
	to_chat(owner, span_warning("[sinner] is rended asunder!"))
	to_chat(sinner, span_cultlarge("OH GOD IT BURNS!"))
	to_chat(sinner, span_userlove("Every part of you shrieks to run! You have to get out of here, <b>now!</b>"))
	SEND_SOUND(sinner, sound('modular_tfn/modules/numina/sound/perdition_effect.ogg'))

	addtimer(CALLBACK(src, PROC_REF(deactivate), sinner), 30 SECONDS)

/datum/discipline_power/true_faith/perdition/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

//this is a general proc to remove the halo for powers that would otherwise keep it too long
/datum/discipline_power/true_faith/proc/clear_halo(mob/living/carbon/human/owner)
	owner.remove_overlay(MUTATIONS_LAYER)

/obj/item/melee/touch_attack/truefaith_heal
	name = "\improper faithful hand"
	desc = "Through the LORD, all things are possible."
	on_use_sound = 'modular_tfn/modules/numina/sound/truefaith_power_small.ogg'
	catchphrase = null
	icon_state = "fleshtostone"
	inhand_icon_state = "fleshtostone"

/obj/item/melee/touch_attack/truefaith_heal/attack(mob/target, mob/living/user)
	. = ..()
	if(target == user && isliving(target))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	var/mob/living/M = target //We still want the healing effects to affect animals and such.
	var/mob/living/carbon/human/H = target
	if(iskindred(H) && ((H.morality_path?.alignment != MORALITY_HUMANITY) || (H.morality_path?.score <= 8)))
		H.do_jitter_animation(10 SECONDS)
		H.apply_damage(10, BURN, user.zone_selected)
		H.apply_damage(25, CLONE, user.zone_selected)
		H.flash_act()
		H.adjust_fire_stacks(1)
		H.IgniteMob()
		playsound(M, 'modular_tfn/modules/numina/sound/skin_sizzle.ogg', 25, TRUE, 3)
		return
	M.adjustBruteLoss(-10, TRUE)
	M.adjustFireLoss(-10, TRUE)
	M.adjustToxLoss(-25, TRUE)
	M.adjustOxyLoss(-25, TRUE)
	M.adjustCloneLoss(-25, TRUE)
	if((ishuman(M)) && (!iskindred(M)))
		M.reagents.add_reagent(/datum/reagent/determination, 10)
	if(isgarou(H))
		H.auspice.rage -= 4
	return
