/datum/surgery/fleshcraft/reinforce_limb
	name = "Reinforce Limb"
	desc = "A surgical procedure which reinforces the limb it's performed on, reducing damage taken to that specific limb."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/reinforce_limb,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_R_LEG,BODY_ZONE_L_LEG,BODY_ZONE_CHEST,BODY_ZONE_HEAD)
	level_req = 4
	replaced_by = null

/datum/surgery_step/reinforce_limb
	name = "reinforce_limb"
	implements = list(/obj/item/stack/human_flesh = 100) //A stack, made from several bodies, can't quite reinforce one body. 
	time = 125

/datum/surgery_step/reinforce_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You start wrapping muscle and bone to reinforce [target]'s limbs."),
		span_notice("[user] starts doing something inside [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] starts manipulating [target]'s [parse_zone(target_zone)]."))
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		if(target_limb.wound_damage_multiplier == 0.5)
			display_results(user, target, span_notice("You can't reinforce [target]'s limbs any further!"),
				span_notice("[user] starts doing something inside [target]'s [parse_zone(target_zone)]."))
	return ..()

/datum/surgery_step/reinforce_limb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("You reinforce [target]'s limbs, reinforcing the interior as much as possible!"),
		span_notice("[user] finishes manipulating [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] finishes manipulating [target]'s [parse_zone(target_zone)]."))
	if(surgery.operated_bodypart)
		var/obj/item/bodypart/target_limb = surgery.operated_bodypart
		target_limb.wound_damage_multiplier = 0.5 //Just sets it once, so you can't stack it infinitely.
	tool.use(5)
	return ..()
