/datum/surgery/fleshcraft/fat_enhancement
	name = "Fat Enhancement"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/add_fat,
		/datum/surgery_step/close
		)

	replaced_by = null
	level_req = 3

/datum/surgery_step/add_fat
	name = "Extend Spine
	implements = list(/obj/item/stack/human_flesh = 100)
	time = 20

/datum/surgery_step/add_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to stretch out [target]'s spine like taffy."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"))

/datum/surgery_step/add_fat/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if (target.base_body_mod == SLIM_BODY_MODEL)
		target.set_body_model(NORMAL_BODY_MODEL)
		tool.use(3)
    display_results(user, target, span_notice("You sucessfully make [target] normal weight! You'll need to do it again to make them fat."
	if (target.base_body_mod == NORMAL_BODY_MODEL)
		target.set_body_model(FAT_BODY_MODEL)
		tool.use(3)
    display_results(user, target, span_notice("You sucessfully make [target] fat! You can't make them any larger for now!")
  else 
    display_results(user, target, span_notice("You can't find a way to make [target] any larger!")
	span_notice("[user] stretches out [target]'s flesh in truly horrific ways!</span>"))
	return TRUE

