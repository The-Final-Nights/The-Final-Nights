/datum/surgery/fleshcraft/skin_colour_change
	name = "Change Skin Colour"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/modify_skin, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	level_req = 2
	replaced_by = null

//Modify Skin Tone
/datum/surgery_step/modify_skin
	name = "Change Skin Colour"
	accept_hand = TRUE
	time = 64
	repeatable = TRUE

/datum/surgery_step/modify_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to alter [target]'s skin..."),
		span_notice("[user] begins to alter [target]'s skin."),
		span_notice("[user] begins to press against [target]'s skin."))

/datum/surgery_step/modify_skin/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/list/skin_tones = GLOB.skin_tones
	var/new_s_tone = tgui_input_list(user, "Choose [target]'s skin tone:", "Skin Tone Change", skin_tones)
	if(new_s_tone)
		target.skin_tone = new_s_tone
		target.dna.update_ui_block(DNA_SKIN_TONE_BLOCK)
		target.update_body()
	return TRUE
