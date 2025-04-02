/datum/surgery/fleshcraft/cosmetic
	name = "Cosmetic Fleshcrafting"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/add_flesh,
				/datum/surgery_step/close)

	replaced_by = null
	level_req = 2//technically I don't need to put this here, since it's 2 by default, but this is a good example of a surgery so I'll leave it

/datum/surgery_step/add_flesh
	name = "Add Flesh"
	implements = list(/obj/item/stack/human_flesh = 100)
	repeatable = TRUE//lets the fleshcrafter try out the options, should allow for easier experimenting with how things look
	time = 64

/datum/surgery_step/add_flesh/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to reshape [target]..."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"))

/datum/surgery_step/add_flesh/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("You finish reshaping [target]!"),
		span_notice("[user] changes [target] into something... new."),
		span_notice("[user] finishes."))
	var/mob/living/carbon/human/victim = target
	var/list/changes = list("spines", "spines_slim", "animal_skull", "nothing")
	var/chosen = tgui_input_list(user, "How shall we change them?", "Cosmetics selection", changes)
	if(isnull(chosen))
		return TRUE//It's repeatable anyways just return true without doing anything and let us repeat the step
	if(chosen == "nothing")
		victim.remove_overlay(UNICORN_LAYER)
		victim.overlays_standing[UNICORN_LAYER] = null
		return TRUE
	var/mutable_appearance/cosmetic = mutable_appearance('code/modules/wod13/icons.dmi', chosen, -UNICORN_LAYER)
	victim.remove_overlay(UNICORN_LAYER)
	victim.overlays_standing[UNICORN_LAYER] = cosmetic
	victim.apply_overlay(UNICORN_LAYER)
	tool.use(1)
	return TRUE
