/datum/surgery/fleshcraft/eye_colour_change
	name = "Change Eye Colour"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/modify_eyes, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_PRECISE_EYES)
	level_req = 2
	replaced_by = null

//reshape_face
/datum/surgery_step/modify_eyes
	name = "Change Eye Colour"
	accept_hand = TRUE
	time = 20
	repeatable = TRUE

/datum/surgery_step/modify_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to reshape [target]'s eyes..."),
		span_notice("[user] begins to manipulate [target]'s eyes in truly horrific ways!"))

/datum/surgery_step/modify_eyes/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/new_eye_color = input(user, "Choose [target]'s eye color", "Eye Color", target.eye_color) as color|null
	if(new_eye_color)
		target.eye_color = sanitize_hexcolor(new_eye_color)
		target.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		target.update_body()
	return TRUE
