/datum/surgery/fleshcraft/appearance_change
	name = "Appearance Change"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/reshape_appearance, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	level_req = 3
	replaced_by = null

//reshape_face
/datum/surgery_step/reshape_appearance
	name = "Reshape Face"
	implements = list(TOOL_SCALPEL = 100, /obj/item/kitchen/knife = 50, TOOL_WIRECUTTER = 35)
	time = 64
	repeatable = TRUE

/datum/surgery_step/reshape_appearance/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to alter [target]'s appearance..."),
		span_notice("[user] begins to alter [target]'s appearance."),
		span_notice("[user] begins to make an incision in [target]'s face!"))

/datum/surgery_step/reshape_appearance/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(HAS_TRAIT_FROM(target, TRAIT_DISFIGURED, TRAIT_GENERIC))
		REMOVE_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
	var/new_appearance = tgui_input_text(usr, "Choose their new name:", "Appearance Change", max_length = MAX_NAME_LEN)
	if(!new_appearance)
		return
	var/oldname = target.real_name
	target.real_name = new_appearance
	var/newname = target.real_name	//something about how the code handles names required that I use this instead of target.real_name
	display_results(user, target, span_notice("You alter [oldname]'s appearance completely, [target.p_they()] is now [newname]!"),
		span_notice("[user] alters [oldname]'s appearance completely, [target.p_they()] is now [newname]!"),
		span_notice("[user] finishes the operation on [target]'s face."))
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.sec_hud_set_ID()
	return ..()
