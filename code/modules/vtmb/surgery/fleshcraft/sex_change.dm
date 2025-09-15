/datum/surgery/fleshcraft/sex_change
	name = "Sex Change"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/sex_change,
				/datum/surgery_step/close)

	replaced_by = null
	level_req = 4 //Very delicate work.

/datum/surgery_step/sex_change
	name = "Sex Change"
	accept_hand = TRUE
	time = 180
	repeatable = TRUE

/datum/surgery_step/sex_change/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to reshape [target]..."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"))

/datum/surgery_step/sex_change/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("You finish changing [target]'s sex!"),
		span_notice("[user] changes [target] into something... new."),
		span_notice("[user] finishes."))
	var/mob/living/carbon/human/H = target
	var/list/changes = list("Male", "Female", "Plural")
	var/chosen = tgui_input_list(user, "How shall we change them?", "Sex selection", changes)
	if(isnull(chosen))
		return TRUE//It's repeatable anyways just return true without doing anything and let us repeat the step
	if(chosen == "Male")
		H.gender = MALE
		H.body_type = MALE
	if(chosen == "Female")
		H.gender = FEMALE
		H.body_type = FEMALE
	if(chosen == "Plural")
		H.gender = PLURAL
		H.body_type = PLURAL
	H.dna.update_ui_block(DNA_GENDER_BLOCK)
	H.update_body()
	H.update_mutations_overlay()
	return TRUE
