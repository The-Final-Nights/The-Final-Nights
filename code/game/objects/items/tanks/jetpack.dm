/obj/item/jetpack
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	icon = 'icons/obj/tank.dmi'
	inhand_icon_state = "jetpack"
	lefthand_file = 'icons/mob/inhands/equipment/jetpacks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/jetpacks_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	actions_types = list(/datum/action/item_action/set_internals, /datum/action/item_action/toggle_jetpack, /datum/action/item_action/jetpack_stabilization)
	var/on = FALSE
	var/stabilizers = FALSE
	var/full_speed = TRUE // If the jetpack will have a speedboost in space/nograv or not
	var/datum/effect_system/trail_follow/ion/ion_trail
	var/tank_holder_icon_state = "holder_generic"

/obj/item/jetpack/Initialize()
	. = ..()
	ion_trail = new
	ion_trail.auto_process = FALSE
	ion_trail.set_up(src)
	AddComponent(/datum/component/container_item/tank_holder, tank_holder_icon_state)

/obj/item/jetpack/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_jetpack))
		cycle(user)
	else if(istype(action, /datum/action/item_action/jetpack_stabilization))
		if(on)
			stabilizers = !stabilizers
			to_chat(user, "<span class='notice'>You turn the jetpack stabilization [stabilizers ? "on" : "off"].</span>")

/obj/item/jetpack/proc/cycle(mob/user)
	if(user.incapacitated())
		return

	if(!on)
		turn_on(user)
		to_chat(user, "<span class='notice'>You turn the jetpack on.</span>")
	else
		turn_off(user)
		to_chat(user, "<span class='notice'>You turn the jetpack off.</span>")
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()


/obj/item/jetpack/proc/turn_on(mob/user)
	if(!allow_thrust(0.01, user))
		return
	on = TRUE
	icon_state = "[initial(icon_state)]-on"
	ion_trail.start()
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(move_react))
	RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(pre_move_react))
	if(full_speed)
		user.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)

/obj/item/jetpack/proc/turn_off(mob/user)
	on = FALSE
	stabilizers = FALSE
	icon_state = initial(icon_state)
	ion_trail.stop()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)
	user.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)

/obj/item/jetpack/proc/move_react(mob/user)
	if(!on)//If jet dont work, it dont work
		return
	if(!user || !user.client)//Don't allow jet self using
		return
	if(!isturf(user.loc))//You can't use jet in nowhere or from mecha/closet
		return
	if(!(user.movement_type & FLOATING) || user.buckled)//You don't want use jet in gravity or while buckled.
		return
	if(user.pulledby)//You don't must use jet if someone pull you
		return
	if(user.throwing)//You don't must use jet if you thrown
		return
	if(length(user.client.keys_held & user.client.movement_keys))//You use jet when press keys. yes.
		allow_thrust(0.01, user)

/obj/item/jetpack/proc/pre_move_react(mob/user)
	ion_trail.oldposition = get_turf(src)

/obj/item/jetpack/proc/allow_thrust(num, mob/living/user)
	return TRUE

/obj/item/jetpack/suicide_act(mob/user)
	if (istype(user, /mob/living/carbon/human/))
		var/mob/living/carbon/human/H = user
		H.say("WHAT THE FUCK IS CARBON DIOXIDE?")
		H.visible_message("<span class='suicide'>[user] is suffocating [user.p_them()]self with [src]! It looks like [user.p_they()] didn't read what that jetpack says!</span>")
		return (OXYLOSS)
	else
		..()

/obj/item/jetpack/improvised
	name = "improvised jetpack"
	desc = "A jetpack made from two air tanks, a fire extinguisher and some atmospherics equipment. It doesn't look like it can hold much."
	icon_state = "jetpack-improvised"
	inhand_icon_state = "jetpack-improvised"
	worn_icon = null
	worn_icon_state = "jetpack-improvised"
	full_speed = FALSE //moves at hardsuit jetpack speeds

/obj/item/jetpack/improvised/allow_thrust(num, mob/living/user)
	if(rand(0,250) == 0)
		to_chat(user, "<span class='notice'>You feel your jetpack's engines cut out.</span>")
		turn_off(user)
		return
	return ..()

/obj/item/jetpack/void
	name = "void jetpack"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	inhand_icon_state =  "jetpack-void"

/obj/item/jetpack/suit
	name = "hardsuit jetpack upgrade"
	desc = "A modular, compact set of thrusters designed to integrate with a hardsuit. It is fueled by a tank inserted into the suit's storage compartment."
	icon_state = "jetpack-mining"
	inhand_icon_state = "jetpack-black"
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(/datum/action/item_action/toggle_jetpack, /datum/action/item_action/jetpack_stabilization)
	slot_flags = null
	full_speed = FALSE
	var/mob/living/carbon/human/cur_user

/obj/item/jetpack/suit/Initialize()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/jetpack/suit/attack_self()
	return

/obj/item/jetpack/suit/turn_on(mob/user)
	if(!istype(loc, /obj/item/clothing/suit/space/hardsuit) || !ishuman(loc.loc) || loc.loc != user)
		return
	START_PROCESSING(SSobj, src)
	cur_user = user
	..()

/obj/item/jetpack/suit/turn_off(mob/user)
	STOP_PROCESSING(SSobj, src)
	cur_user = null
	..()

/obj/item/jetpack/suit/process()
	if(!istype(loc, /obj/item/clothing/suit/space/hardsuit) || !ishuman(loc.loc))
		turn_off(cur_user)
		return
	..()


//Return a jetpack that the mob can use
//Back worn jetpacks, hardsuit internal packs, and so on.
//Used in Process_Spacemove() and wherever you want to check for/get a jetpack

/mob/proc/get_jetpack()
	return

/mob/living/carbon/get_jetpack()
	var/obj/item/jetpack/J = back
	if(istype(J))
		return J

/mob/living/carbon/human/get_jetpack()
	var/obj/item/jetpack/J = ..()
	if(!istype(J) && istype(wear_suit, /obj/item/clothing/suit/space/hardsuit))
		var/obj/item/clothing/suit/space/hardsuit/C = wear_suit
		J = C.jetpack
	return J

/obj/item/jetpack/oxygen/captain

/obj/item/jetpack/oxygen

/obj/item/jetpack/oxygen/harness
