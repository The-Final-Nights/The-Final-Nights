/*
 * Anesthetic
 */
/obj/item/anesthetic_tank
	name = "anesthetic tank"
	desc = "A tank of anesthesia."
	icon_state = "anesthetic"
	icon = 'icons/obj/tank.dmi'
	inhand_icon_state = "an_tank"
	var/tank_holder_icon_state = "holder_oxygen_anesthetic"
	force = 10

/obj/item/anesthetic_tank/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/container_item/tank_holder, tank_holder_icon_state)

/obj/item/anesthetic_tank/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] starts applying \the [src] to themselves!"), \
						 span_notice("You start to anaesthetize yourself..."))
	if(do_after(user, 1 SECONDS, user))
		user.SetSleeping(30 SECONDS)

/obj/item/anesthetic_tank/attack(mob/living/M, mob/living/user)
	user.visible_message(span_warning("[user] starts applying \the [src] to [M]!"), \
						 span_notice("You start to anaesthetize [M]..."))
	if(do_after(user, 5 SECONDS, M))
		M.SetSleeping(30 SECONDS)
