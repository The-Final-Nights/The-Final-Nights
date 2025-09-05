/datum/discipline/valeren_warrior
	name = "Warrior Valeren"
	desc = "Use your third eye in warding and delivering retribution."
	icon_state = "valeren"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/valeren_warrior


/datum/discipline/valeren_warrior/post_gain()
	. = ..()
	if(level >= 2)
		ADD_TRAIT(owner, TRAIT_SALUBRI_EYE, TRAIT_GENERIC)
		owner.update_body()



/datum/discipline_power/valeren_warrior
	name = "Valeren power name"
	desc = "Valeren power description"

	activate_sound = 'code/modules/wod13/sounds/valeren.ogg'

/datum/discipline_power/valeren_warrior/can_activate_untargeted(alert)
	. = ..()
	if(level >=3 && !(HAS_TRAIT_FROM(owner, TRAIT_SALUBRI_EYE_OPEN, SALUBRI_EYE_TRAIT)))
		if(alert)
			to_chat(owner, span_warning("You can only use this ability with your third eye open!"))
		return FALSE


//SENSE DEATH
/datum/discipline_power/valeren_warrior/sense_death
	name = "Sense Death"
	desc = "Detect at a glance the extent of your foe's defenses, as well as their vitae reserves."

	level = 1
	vitae_cost = 0
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	target_type = TARGET_LIVING
	range = 7

	cooldown_length = 5 SECONDS

/datum/discipline_power/valeren_warrior/sense_death/activate(mob/living/carbon/human/target)
	. = ..()
	if(ishuman(target))
		var/armor_melee_addon = 0
		var/armor_bullet_addon = 0
		var/armor_fire_addon = 0
		if(target.wear_suit)
			var/obj/item/clothing/suit/protec = target.wear_suit
			armor_melee_addon += protec.armor.melee
			armor_bullet_addon += protec.armor.bullet
			armor_fire_addon += protec.armor.fire
		var/melee_armor = target.physiology.armor.melee + armor_melee_addon
		var/bullet_armor = 	target.physiology.armor.bullet + armor_bullet_addon
		var/fire_armor =  target.physiology.armor.fire + armor_fire_addon
		to_chat(owner, "<b>[target]</b> has a defense rating of <b>[num2text(melee_armor)]</b> against melee attacks ")
		to_chat(owner, "<b>[target]</b> has a defense rating of <b>[num2text(bullet_armor)]</b> against ranged attacks ")
		to_chat(owner, "<b>[target]</b> has a defense rating of <b>[num2text(fire_armor)]</b> against fire")
	if(iskindred(target) || isghoul(target))
		to_chat(owner, "<b>[target]</b> has <b>[num2text(target.bloodpool)]/[target.maxbloodpool]</b> blood points.")
		for(var/datum/action/discipline/D in target.actions)
			if(D.discipline.name == "Fortitude")
				to_chat(owner, "<b>[target]</b> has a Fortitude rating of [D.discipline.level]")


//MORPHEAN BLOW
/datum/discipline_power/valeren_warrior/morphean_blow
	name = "Morphean Blow"
	desc = "Blunt the sensation of your own wounds, drive foes into slumber."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND
	target_type = TARGET_SELF | TARGET_LIVING
	range = 1

	aggravating = TRUE
	hostile = TRUE

	cooldown_length = 10 SECONDS
	duration_length = 1 MINUTES
	var/morphean_check

/datum/discipline_power/valeren_warrior/morphean_blow/activate(mob/living/target)
	. = ..()
	if(target == owner)
		ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
		ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)

		morphean_check = TRUE
		return
	if (ishumanbasic(target))
		target.SetSleeping(15 SECONDS)
	else
		target.add_confusion(5)
		target.drowsyness += 4

/datum/discipline_power/valeren_warrior/morphean_blow/deactivate(atom/target, direct)
	. = ..()
	if(morphean_check == TRUE)
		REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
		REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)

//BURNING TOUCH
/datum/discipline_power/valeren_warrior/burning_touch
	name = "Burning Touch"
	desc = "Inflict grievous pain on a target for as long as you touch them."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 1

	aggravating = TRUE
	hostile = TRUE

	cooldown_length = 10 SECONDS

/datum/discipline_power/valeren_warrior/burning_touch/activate(mob/living/carbon/target)
	. = ..()
	target.grabbedby(owner)
	target.grippedby(owner, instant = TRUE)
	target.apply_status_effect(STATUS_EFFECT_BURNING_TOUCH, owner)

//ARMOR OF CAINE'S FURY
/datum/discipline_power/valeren_warrior/armor_of_caines_fury
	name = "Armor of Caine's Fury"
	desc = "Flare open your third eye, shrouding yourself in a protective crimson halo."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	vitae_cost = 2

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 1 SCENES
	cooldown_length = 30 SECONDS
	var/lastmypower

/datum/discipline_power/valeren_warrior/armor_of_caines_fury/activate()
	. = ..()
	var/fortitudelevel
	var/totaldice
	for(var/datum/action/discipline/Disc in owner.actions)
		if(Disc.discipline.name == "Fortitude")
			fortitudelevel = Disc.discipline.level
	totaldice = (owner.get_total_physique() + fortitudelevel)
	var/mypower = SSroll.storyteller_roll(totaldice, difficulty = 7, mobs_to_show_output = owner, numerical = TRUE)
	mypower = clamp(mypower, 1, 5)
	owner.physiology.armor.melee += (10*mypower)
	owner.physiology.armor.bullet += (10*mypower)
	animate(owner, color = "#b86262", time = 1 SECONDS, loop = 1)
	lastmypower = mypower

/datum/discipline_power/valeren_warrior/armor_of_caines_fury/deactivate()
	. = ..()
	playsound(owner.loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	owner.physiology.armor.melee -= (15*lastmypower)
	owner.physiology.armor.bullet -= (15*lastmypower)
	animate(owner, color = initial(owner.color), time = 1 SECONDS, loop = 1)

//SAMIEL'S VENGEANCE
/datum/discipline_power/valeren_warrior/samiels_vengeance
	name = "Samiel's Vengeance"
	desc = "Open your third eye and let it guide your weapon, striking with unerring accuracy and lethality."
	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	vitae_cost = 3 //Basically can't miss, hence same cost as tabletop.
	target_type = TARGET_LIVING
	range = 1

	aggravating = TRUE
	hostile = TRUE

	cooldown_length = 10 SECONDS

/datum/discipline_power/valeren_warrior/samiels_vengeance/activate(mob/target)
	. = ..()
	var/obj/item/I = owner.get_active_held_item()
	if(!I)
		owner.dna.species.punchdamagelow += 100
		owner.dna.species.punchdamagehigh += 100
		owner.visible_message(span_bolddanger("[owner]'s third eye flashes open, delivering a masterful unarmed strike to [target]!"))
		owner.set_combat_mode(TRUE)
		owner.dna.species.harm(owner, target)
		if(!ishuman(target))
			target.attack_hand(owner)
		owner.dna.species.punchdamagelow -= 100
		owner.dna.species.punchdamagehigh -= 100
	else
		owner.dna.species.meleemod += 3 //4x damage baseline, additive.
		owner.visible_message(span_bolddanger("[owner]'s third eye flashes open, delivering a masterful blow to [target] with [I]!"))
		playsound(target.loc, I.hitsound, 100, FALSE)
		target.attacked_by(I, owner)
		owner.dna.species.meleemod -= 3
