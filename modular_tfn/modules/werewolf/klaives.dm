// Start of garou klaive code
// The idea with this weapon is something less powerful than a katana that is bane to garou
// Gnosis can be used to briefly turn this into a monster of a melee weapon that deals aggravated (clone) damage to everything
/obj/item/melee/vampirearms/klaive
	name = "klaive"
	desc = "A Garou's ritual blade, as rare as it is deadly."
	icon = 'code/modules/wod13/48x32weapons.dmi'
	icon_state = "klaive"
	flags_1 = CONDUCT_1
	item_flags = WEREWOLF_HOLDABLE
	obj_flags = UNIQUE_RENAME
	force = 45
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	block_chance = 40
	armour_penetration = 15 // Silver weapon, shouldn't pen that much
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/rapierhit.ogg'
	wound_bonus = 5
	bare_wound_bonus = 25
	pixel_w = -8
	resistance_flags = FIRE_PROOF
	cost = 250
	var/aggravate = FALSE // Unique variable used for spending gnosis and giving the weapon bonuses
	var/awakened_force = 70
	var/awakened_penetration = 40
	var/aggravate_damage = 20
	var/parried = FALSE

// I wish there was another way
// This code listens for a signal that is sent when there is a successful automatic weapon parry
// It sets a variable to true that will cancel the after_attack of klaives
/obj/item/melee/vampirearms/klaive/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_BLOCK_SUCCESS, PROC_REF(on_klaive_parried))

/obj/item/melee/vampirearms/klaive/proc/on_klaive_parried(datum/source)
	SIGNAL_HANDLER
	parried = TRUE

// Klaive descriptions
/obj/item/melee/vampirearms/klaive/glasswalker
	name = "modern klaive"
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "glassklaive"
	desc = "A heavy military knife expertly forged out of silver. Solid and sharp, a reliable weapon."

/obj/item/melee/vampirearms/klaive/wendigo
	name = "tribal klaive"
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "wendiklaive"
	desc = "A large tribal blade wrought out of silver with a leather grip. Remind them of the old ways."

/obj/item/melee/vampirearms/klaive/bsd
	name = "spiral dancer klaive"
	icon = 'code/modules/wod13/weapons.dmi'
	icon_state = "bsdklaive"
	desc = "An oversized, wicked dagger fashioned from silver. Eerie runes are engraved along its length."

// This code allows a garou to spend 1 gnosis to buff the klaive and allow it to deal aggravated damage (clone damage) to non-supernatural beings
// This lasts for 10 seconds, and while it is active you cannot activate it again to prevent spam
/obj/item/melee/vampirearms/klaive/attack_self(mob/user)
	if(aggravate)
		to_chat(user, "[src]'s spirit is already awake!")
		return
	if((isgarou(user) || iscrinos(user)))
		awaken(user)
	else
		to_chat(user, "[src]'s is just a dead piece of silver.")

/obj/item/melee/vampirearms/klaive/proc/awaken(mob/living/carbon/wolf)
	if(wolf.auspice.gnosis > 0)
		to_chat(wolf, "You beckon [src]'s spirit, you can feel it answer your call.")
		adjust_gnosis(-1, wolf)
		aggravate = TRUE
		force = awakened_force
		armour_penetration = awakened_penetration
		addtimer(CALLBACK(src, PROC_REF(slumber), wolf), 10 SECONDS)
	else
		to_chat(wolf, "You beckon [src]'s spirit, but all that answers is silence and indifference.")

/obj/item/melee/vampirearms/klaive/proc/slumber(mob/user)
	aggravate = FALSE
	force = initial(force)
	armour_penetration = initial(armour_penetration)
	to_chat(user, "[src]'s spirit slumbers once more.")

// Code here is for dealing special damage and effects to garou, as well as the extra damage if the glaive is active
// The non-active if(!aggravate) deals the same clone damage as a silver bullet, as well as some of its debuffs
// The active if(aggravate) deals extra clone damage to the garou, and also deals clone damage to all carbons and vampires
/obj/item/melee/vampirearms/klaive/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isgarou(target) || iswerewolf(target))
		var/mob/living/carbon/wolf = target
		if(wolf.blocking || wolf.parrying) //This is so a blocked or parried klaive does not deal clone damage
			return

		//Chance to remove gnosis from target werewolf
		if(wolf.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, wolf)

		if(!aggravate)
			wolf.apply_damage(aggravate_damage, CLONE)
		else
			wolf.apply_damage(aggravate_damage + 15, CLONE)

		wolf.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

	else if(iscarbon(target) || isvampire(target))
		var/mob/living/carbon/human = target
		if(human.blocking || human.parrying) //This is so a blocked or parried klaive does not deal clone damage
			return
		if(aggravate)
			human.apply_damage(aggravate_damage, CLONE)

// These are the crafting recipes for each klaive
// They are currently unused, no one has the CAT_GAROU category nor the recipes themselves
/datum/crafting_recipe/klaive
	category = CAT_GAROU
	always_available = FALSE

/datum/crafting_recipe/klaive/glasswalker
	name = "Modern Klaive"
	result = /obj/item/melee/vampirearms/klaive/glasswalker
	reqs = list(/obj/item/silverbar = 2, /obj/item/melee/vampirearms/knife = 1)
	time = 30

/datum/crafting_recipe/klaive/wendigo
	name = "Tribal Klaive"
	result = /obj/item/melee/vampirearms/klaive/wendigo
	reqs = list(/obj/item/silverbar = 2, /obj/item/vampire_stake = 1)
	time = 30

/datum/crafting_recipe/klaive/bsd
	name = "Spiral Dancer Klaive"
	result = /obj/item/melee/vampirearms/klaive/bsd
	reqs = list(/obj/item/silverbar = 2, /obj/item/reagent_containers/blood = 1)
	time = 30

// Fancy adminspawn only item, this thing is a monstrous weapon. Doubly so in a garou's hands
/obj/item/melee/vampirearms/klaive/grand
	name = "grand klaive"
	desc = "A legend's supremely deadly blade. Its wielder's deeds weigh heavy in your hand. Its ancient spirit demands you hunt."
	force = 60
	throwforce = 20
	block_chance = 60
	armour_penetration = 35
	awakened_force = 120
	awakened_penetration = 60
	aggravate_damage = 30

//End of Garou klaive code

// Silver bar object item for crafting, dunno where to put it
/obj/item/silverbar
	name = "silver bar"
	desc = "A shiny bar of precious metal."
	icon_state = "silverbar"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | ACID_PROOF
