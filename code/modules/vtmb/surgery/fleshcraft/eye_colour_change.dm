/datum/surgery/fleshcraft/eye_colour_change
	name = "Change Eye Colour"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/modify_eyes, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_PRECISE_EYES)

//reshape_face
/datum/surgery_step/modify_eyes
	name = "Change Eye Colour"
	accept_hand = TRUE
	time = 20

/datum/surgery_step/modify_eyes/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to alter [target]'s eyes.</span>", "<span class='notice'>You begin to alter [target]'s eyes...</span>")
	display_results(user, target, "<span class='notice'>You begin to alter [target]'s eyes...</span>",
		"<span class='notice'>[user] begins to alter [target]'s eyes.</span>",
		"<span class='notice'>[user] begins to press against [target]'s eyes.</span>")

/datum/surgery_step/modify_eyes/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/new_eye_color = input(user, "Choose [target]'s eye color", "Eye Color", H.eye_color) as color|null
	if(new_eye_color)
		target.eye_color = sanitize_hexcolor(new_eye_color)
		target.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
		target.update_body()
