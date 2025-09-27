/datum/surgery/fleshcraft/hair
	name = "Change Hair Colour"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/modify_hair, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)
	level_req = 2
	replaced_by = null

//reshape_face
/datum/surgery_step/modify_hair
	name = "Change Hair Colour"
	accept_hand = TRUE
	time = 20

/datum/surgery_step/modify_hair/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to reshape [target]'s hair..."),
		span_notice("[user] begins to manipulate [target]'s head in truly horrific ways!"))

/datum/surgery_step/modify_hair/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/list/changes = list("Style", "Colour")
	var/hairchoice = tgui_input_list(user, "Hairstyle or hair color?", "Change Hair", changes)
	if(hairchoice == "Style")
		var/list/style = GLOB.hairstyles_list
		var/new_style = tgui_input_list(user, "Select a hairstyle", "Grooming", style)
		if(new_style)
			target.hairstyle = new_style
		if(target.gender == "male")
			var/list/facial_style = GLOB.facial_hairstyles_list
			var/new_facial_style = tgui_input_list(user, "Select a facial hairstyle", "Grooming", facial_style)
			if(new_facial_style)
				target.facial_hairstyle = new_facial_style
		else
			target.facial_hairstyle = "Shaved"
	else
		var/new_hair_color = input(user, "Choose [target]'s hair color", "Hair Color", target.hair_color) as color|null
		if(new_hair_color)
			target.hair_color = sanitize_hexcolor(new_hair_color)
			target.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
		if(target.gender == "male")
			var/new_face_color = input(user, "Choose [target]'s facial hair color", "Hair Color", target.facial_hair_color) as color|null
			if(new_face_color)
				target.facial_hair_color = sanitize_hexcolor(new_face_color)
				target.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
	target.update_hair()
	return TRUE
