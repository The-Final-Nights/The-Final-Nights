/datum/surgery/fleshcraft/fat_reduction
	name = "Fat Reduction"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/remove_fat,
		/datum/surgery_step/close
		)

	replaced_by = null
	level_req = 3

/datum/surgery_step/remove_fat
	name = "Remove Fat"
	accept_hand = TRUE
	time = 20
	repeatable = TRUE

/datum/surgery_step/remove_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to pull out [target]'s body fat."),
	span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!"))

/datum/surgery_step/remove_fat/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if (target.base_body_mod == FAT_BODY_MODEL)
		target.set_body_model(NORMAL_BODY_MODEL)
		var/obj/item/stack/human_flesh/F = new (get_turf(target), 3)
		F.add_fingerprint(user)
		display_results(user, target, span_notice("You sucessfully make [target] normal weight! You'll need to do it again to make them thin."))
	if (target.base_body_mod == NORMAL_BODY_MODEL)
		target.set_body_model(SLIM_BODY_MODEL)
		var/obj/item/stack/human_flesh/F = new (get_turf(target), 3)
		F.add_fingerprint(user)
		display_results(user, target, span_notice("You sucessfully make [target] thin! You can't make them any thinner for now!"))
	else 
		display_results(user, target, span_notice("You can't find a way to make [target] any slimmer!"))
	display_results(user, target, span_notice("[user] pulls out [target]'s flesh in truly horrific ways!</span>"))
	return TRUE
