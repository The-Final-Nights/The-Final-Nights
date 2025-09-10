/datum/surgery/fleshcraft/clan_curse
	name = "Cursed Appearance"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/add_curse,
				/datum/surgery_step/close)

	replaced_by = null
	level_req = 3

/datum/surgery_step/add_curse
	name = "Add Flesh"
	implements = list(/obj/item/stack/human_flesh = 100)
	repeatable = TRUE//lets the fleshcrafter try out the options, should allow for easier experimenting with how things look
	time = 64

/datum/surgery_step/add_flesh/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to reshape [target]..."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"))

/datum/surgery_step/add_flesh/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if (!NORMAL_BODY_SPRITE(owner))
		addtimer(CALLBACK(target, PROC_REF(revert_to_cursed_form)), 6 INGAME_HOURS) //Won't last all night, but takes a good while to heal, given how it's a pain to perform.
		display_results(user, target, span_notice("[target]'s curse is already attempting to revert them to their cursed original form, it won't last much more than a few hours!"))
	display_results(user, target, span_notice("You finish reshaping [target]!"),
		span_notice("[user] changes [target] into something... new."),
		span_notice("[user] finishes."))
	var/list/changes = list("Nosferatu", "Kiasyd", "Cappadochian", "Gargoyle", "None")
	var/chosen = tgui_input_list(user, "How shall we change them?", "Curse selection", changes)
	if(isnull(chosen))
		return TRUE//It's repeatable anyways just return true without doing anything and let us repeat the step
	if(chosen == "None")
		victim.remove_overlay(UNICORN_LAYER)
		victim.overlays_standing[UNICORN_LAYER] = null
		return TRUE
	var/mutable_appearance/cosmetic = mutable_appearance('code/modules/wod13/icons.dmi', chosen, -UNICORN_LAYER)
	victim.remove_overlay(UNICORN_LAYER)
	victim.overlays_standing[UNICORN_LAYER] = cosmetic
	victim.apply_overlay(UNICORN_LAYER)
	tool.use(1)
	return TRUE

/datum/surgery/fleshcraft/proc/revert_to_cursed_form((mob/user, mob/living/carbon/human/target)
	if (!is_shapeshifted)
		return
	owner.set_body_sprite(original_body_sprite)

	to_chat(owner, span_warning("Your cursed appearance reasserts itself!"))
