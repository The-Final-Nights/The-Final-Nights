GLOBAL_LIST_EMPTY(pagers)

/obj/item/pager
	name = "Medical Pager"
	desc = "An old timey fashioned pager, used for medical communication."
	icon = 'icons/obj/radio.dmi'
	icon_state = "pager"
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	worn_icon = "blank" // needed so that weird pink default thing doesn't show up
	worn_icon_state = "blank" // needed so that weird pink default thing doesn't show up
	var/pager_id

/obj/item/pager/Initialize()
	. = ..()
	pager_id = rand(1, 1000)
	name = "[name] ([pager_id])"
	GLOB.pagers += src

/obj/item/pager/Destroy()
	GLOB.pagers -= src
	return ..()

/obj/item/pager/examine(mob/user)
	. = ..()
	. += span_notice("You can [span_bold("Alt-Click")] the [src] to send a pager to a specified pager ID.")

/obj/item/pager/AltClick(mob/user)
	. = ..()
	var/list/pager_ids = list()
	for(var/obj/item/pager/P in GLOB.pagers)
		pager_ids += P.pager_id
	var/chosen_pager = tgui_input_list(user, "Send Pager", "Select a Pager ID to page.", pager_ids)
	if(!chosen_pager)
		return
	to_chat(user, span_notice("You page the [chosen_pager] pager."))

	for(var/obj/item/pager/P in GLOB.pagers)
		if(P.pager_id == chosen_pager)
			P.receive_pager()

/obj/item/pager/proc/receive_pager()
	balloon_alert_to_viewers("beep!")
	audible_message(span_warning("The [src] beeps loudly."))
	playsound(src, 'sound/weapons/gun/general/empty_alarm.ogg', 50, TRUE)

