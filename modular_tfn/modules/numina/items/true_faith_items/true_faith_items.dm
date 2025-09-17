/obj/item/blessed_object
	name = "generic blessed object"
	desc = "Perfectly generic."
	icon_state = "quran"
	icon = 'modular_tfn/modules/numina/icons/blessed_objects.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_GIGANTIC //To prevent people from trying to store them
	var/burn_damage = 25
	var/agg_damage = 25
	var/base_object = /obj/item/quran

	var/dupe_protection = FALSE //Fuck it.

/obj/item/blessed_object/attack(mob/target, mob/living/user)
	. = ..()
	if(target == user && isliving(target))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	var/mob/living/M = target
	if(M.anti_magic_check())
		return COMPONENT_CANCEL_ATTACK_CHAIN
	if(!iskindred(target) && !isgarou(target))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	var/mob/living/carbon/human/vampire = target
	if(iskindred(vampire) && (vampire.morality_path?.alignment == MORALITY_HUMANITY) && (vampire.morality_path?.score >= 8))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	if(iskindred(vampire) && (vampire.clan?.name == CLAN_BAALI)) //Baali Moment
		M.do_jitter_animation(10 SECONDS)
		M.adjust_blurriness(1 SECONDS)
		M.adjust_fire_stacks(2)
		M.IgniteMob()
	M.apply_damage(burn_damage, BURN, user.zone_selected)
	M.apply_damage(agg_damage, CLONE, user.zone_selected)
	playsound(target, 'modular_tfn/modules/numina/sound/skin_sizzle.ogg', 25, TRUE, 3)
	return

/obj/item/blessed_object/proc/dispel(mob/user)
	playsound(src, 'modular_tfn/modules/numina/sound/truefaith_deactivate_generic.ogg', 25, FALSE)
	src.visible_message(span_notice("The strange aura surrounding [src] dissipates..."))
	//Originally this proc handled a lot more, but it resulted in item dupes.
	//It being here at least still means im not repeating a bunch of sound and message procs. Small victories, right?

/obj/item/blessed_object/dropped(mob/user)
	. = ..()
	if(!dupe_protection) //FUCK IT. WE'LL DO IT LIVE.
		new base_object(user.drop_location())
		dispel()
		qdel(src)

/obj/item/blessed_object/pickup(mob/user)
	. = ..()
	dispel()
	dupe_protection = TRUE
	var/obj/item/hand_object = new base_object(user.drop_location())
	user.put_in_active_hand(hand_object)
	qdel(src)
	return

/obj/item/blessed_object/attack_self(mob/user)
	. = ..()
	dispel()
	dupe_protection = TRUE
	var/obj/item/hand_object = new base_object(user.drop_location()) //God is dead. Which is ironic, considering what this is for.
	qdel(src)
	user.put_in_active_hand(hand_object)
	return

/obj/item/blessed_object/blessed_prayer_beads
	name = "glowing prayer beads"
	desc = "For the Lord is my shepard."
	icon_state = "beads"
	burn_damage = 5
	agg_damage = 3
	base_object = /obj/item/clothing/neck/vampire/prayerbeads

/obj/item/blessed_object/blessed_cross_necklace
	name = "glowing cross"
	desc = "Though I walk through the valley of death, I shall fear no evil."
	icon_state = "id11"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	burn_damage = 10
	agg_damage = 10
	base_object = /obj/item/card/id/hunter

/obj/item/blessed_object/blessed_bible
	name = "glowing bible"
	desc = "You will know them by their works."
	icon_state = "bible"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	burn_damage = 20
	agg_damage = 15
	base_object = /obj/item/storage/book/bible

/obj/item/blessed_object/blessed_quran
	name = "glowing quran"
	desc = "Do not despair of the mercy of Allāh."
	icon_state = "quran"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	burn_damage = 20
	agg_damage = 15
	base_object = /obj/item/quran
