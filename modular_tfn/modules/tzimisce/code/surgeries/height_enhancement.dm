/datum/surgery/fleshcraft/height_enhancement
	name = "Height Enhancement"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/extend_spine,
		/datum/surgery_step/close
		)

	replaced_by = null
	level_req = 3

/datum/surgery_step/extend_spine
	name = "Extend Spine"
	accept_hand = TRUE
	time = 100
	repeatable = TRUE

/datum/surgery_step/extend_spine/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to stretch out [target]'s spine like taffy."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!"))

/datum/surgery_step/extend_spine/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if (target.has_quirk(/datum/quirk/dwarf))
		target.remove_quirk(/datum/quirk/dwarf)
		display_results(user, target, span_notice("You sucessfully make [target] normal height! You'll need to do it again to make them huge."))
	else if (!target.has_quirk(/datum/quirk/tower))
		target.add_quirk(/datum/quirk/tower)
		display_results(user, target, span_notice("You sucessfully make [target] huge! You can't make them any taller for now!"))
	else 
		display_results(user, target, span_notice("You can't find a way to make [target] any taller!"))
	display_results(user, target, span_notice("[user] stretches out [target]'s flesh in truly horrific ways!"))
	return TRUE
