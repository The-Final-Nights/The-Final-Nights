/obj/item/aicard
	name = "intelliCard"
	desc = "A storage device for AIs. Patent pending."
	icon = 'icons/obj/aicards.dmi'
	icon_state = "aicard" // aicard-full
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	item_flags = NOBLUDGEON
	var/flush = FALSE
	var/mob/living/silicon/ai/AI

/obj/item/aicard/aitater
	name = "intelliTater"
	desc = "A stylish upgrade (?) to the intelliCard."
	icon_state = "aitater"

/obj/item/aicard/aispook
	name = "intelliLantern"
	desc = "A spoOoOoky upgrade to the intelliCard."
	icon_state = "aispook"

/obj/item/aicard/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is trying to upload [user.p_them()]self into [src]! That's not going to work out well!</span>")
	return BRUTELOSS

/obj/item/aicard/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !target)
		return
	if(AI) //AI is on the card, implies user wants to upload it.
		log_combat(user, AI, "uploaded", src, "to [target].")
		target.transfer_ai(AI_TRANS_FROM_CARD, user, AI, src)
	else //No AI on the card, therefore the user wants to download one.
		target.transfer_ai(AI_TRANS_TO_CARD, user, null, src)
		if(AI)
			log_combat(user, AI, "carded", src)
	update_appearance() //Whatever happened, update the card's state (icon, name) to match.

/obj/item/aicard/update_icon_state()
	if(!AI)
		name = initial(name)
		icon_state = initial(icon_state)
		return ..()
	name = "[initial(name)] - [AI.name]"
	icon_state = "[initial(icon_state)][AI.stat == DEAD ? "-404" : "-full"]"
	AI.cancel_camera()
	return ..()

/obj/item/aicard/update_overlays()
	. = ..()
	if(!AI?.control_disabled)
		return
	. += "[initial(icon_state)]-on"

/obj/item/aicard/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/aicard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Intellicard", name)
		ui.open()

/obj/item/aicard/ui_data()
	var/list/data = list()
	if(AI)
		data["name"] = AI.name
		data["laws"] = AI.laws.get_law_list(include_zeroth = TRUE, render_html = FALSE)
		data["health"] = (AI.health + 100) / 2
		data["wireless"] = !AI.control_disabled //todo disabled->enabled
		data["radio"] = AI.radio_enabled
		data["isDead"] = AI.stat == DEAD
		data["isBraindead"] = AI.client ? FALSE : TRUE
	data["wiping"] = flush
	return data

/obj/item/aicard/ui_act(action,params)
	. = ..()
	if(.)
		return
	switch(action)
		if("wipe")
			if(flush)
				flush = FALSE
			else
				var/confirm = alert("Are you sure you want to wipe this card's memory?", name, "Yes", "No")
				if(confirm == "Yes" && !..())
					flush = TRUE
					if(AI && AI.loc == src)
						to_chat(AI, "<span class='userdanger'>Your core files are being wiped!</span>")
						while(AI.stat != DEAD && flush)
							AI.adjustOxyLoss(5)
							AI.updatehealth()
							sleep(5)
						flush = FALSE
			. = TRUE
		if("wireless")
			AI.control_disabled = !AI.control_disabled
			if(!AI.control_disabled)
				AI.interaction_range = null
			else
				AI.interaction_range = 0
			to_chat(AI, span_warning("[src]'s wireless port has been [AI.control_disabled ? "disabled" : "enabled"]!"))
			. = TRUE
		if("radio")
			AI.radio_enabled = !AI.radio_enabled
			to_chat(AI, "<span class='warning'>Your Subspace Transceiver has been [AI.radio_enabled ? "enabled" : "disabled"]!</span>")
			. = TRUE
	update_appearance()
