/obj/structure/vaultdoor
	name = "Vault Door"
	desc = "A heavy duty door that looks like it could withstand a lot of punishment."
	icon = 'code/modules/wod13/doors.dmi'
	icon_state = "vault-1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	pixel_w = -16
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

	var/id = ""
	var/baseicon = "vault"
	var/brokenicon = "vault_broken"
	var/pincode
	var/closed = TRUE
	var/lock_id = ""
	var/door_moving = FALSE
	var/is_broken = FALSE
	var/door_health = 100

	var/open_sound = 'code/modules/wod13/sounds/vault_door_opening.ogg'
	var/close_sound = 'code/modules/wod13/sounds/vault_door_closing.ogg'
	var/lock_sound = 'code/modules/wod13/sounds/vault_door_lock.ogg'

	var/is_locked = FALSE

/obj/structure/vaultdoor/pincode
	name = "Vault Door"
	desc = "A heavy duty door that looks like it could withstand a lot of punishment."

/obj/structure/vaultdoor/pincode/bank
	name = "Bank Vault Door"
	desc = "A massive reinforced vault door protecting the bank's reserves."
	lock_id = "bank_vault"

/obj/structure/vaultdoor/New()
	..()
	pincode = create_unique_pincode()
	is_locked = TRUE

/obj/structure/vaultdoor/attack_hand(mob/user)
	. = ..()
	if(is_broken)
		return

	if(is_locked)
		ui_interact(user)
		return

	if(closed && !door_moving)
		open_door(user)
	else if (!door_moving)
		close_door(user)

/obj/structure/vaultdoor/proc/break_open()
	if(is_broken)
		return
	is_broken = TRUE
	is_locked = FALSE
	icon_state = "[brokenicon]-1"
	density = FALSE
	opacity = FALSE
	layer = OPEN_DOOR_LAYER
	visible_message("<span class='warning' style='color:red; font-size:20px;'><b>[src] breaks open!</b></span>")

/obj/structure/vaultdoor/proc/open_door(mob/user)
	playsound(src, open_sound, 75, TRUE)
	door_moving = TRUE
	if(do_after(user, 4 SECONDS))
		icon_state = "[baseicon]-0"
		density = FALSE
		opacity = FALSE
		layer = OPEN_DOOR_LAYER
		to_chat(user, span_notice("You open [src]."))
		closed = FALSE
	door_moving = FALSE

/obj/structure/vaultdoor/proc/close_door(mob/user)
	for(var/atom/movable/door_blocker in src.loc)
		if(door_blocker.density)
			to_chat(user, span_warning("[door_blocker] is preventing you from closing [src]."))
			return
	playsound(src, close_sound, 75, TRUE)
	door_moving = TRUE
	if(do_after(user, 4 SECONDS))
		icon_state = "[baseicon]-1"
		density = TRUE
		opacity = TRUE
		layer = ABOVE_ALL_MOB_LAYER
		to_chat(user,span_notice("You close [src]."))
		closed = TRUE
		is_locked = TRUE
		to_chat(user, span_notice("[src] automatically locks."))
		playsound(src, lock_sound, 50, TRUE)
	door_moving = FALSE

/obj/structure/vaultdoor/examine(mob/user)
	. = ..()
	. += span_notice("Door health: [door_health]/100.")

	if(is_locked)
		. += span_warning("[src] is locked.")

	. += span_notice("[src] uses a digital keypad lock.")

/obj/structure/vaultdoor/ui_interact(mob/user, datum/tgui/ui)
	if(is_broken || !is_locked)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VaultDoor")
		ui.open()

/obj/structure/vaultdoor/ui_data(mob/user)
	var/list/data = list()
	data["pincode"] = pincode
	return data

/obj/structure/vaultdoor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "submit_pincode")
		if(params["pincode"] == pincode)
			to_chat(usr, span_notice("ACCESS GRANTED."))
			is_locked = FALSE
			playsound(src, 'sound/machines/terminal_success.ogg', 50, TRUE)
		else
			to_chat(usr, span_warning("ACCESS DENIED."))
			playsound(src, 'sound/machines/terminal_error.ogg', 50, TRUE)
		. = TRUE

/proc/find_door_pin(door_type)
	for(var/obj/structure/vaultdoor/vdoor in world)
		if(istype(vdoor, door_type))
			return vdoor
	return null
