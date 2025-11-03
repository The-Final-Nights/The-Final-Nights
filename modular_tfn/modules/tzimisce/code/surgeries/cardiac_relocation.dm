/datum/surgery/fleshcraft/cardiac_relocation
	name = "Cardiac Relocation"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/relocate_heart,
		/datum/surgery_step/close
		)

	replaced_by = null
	level_req = 5

/datum/surgery_step/relocate_heart
	name = "Relocate Heart"
	accept_hand = TRUE
	time = 200 //Takes a long while, you've got to be careful!

/datum/surgery_step/relocate_heart/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to very, very carefully relocate [target]'s heart..."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!"))

/datum/surgery_step/relocate_heart/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	new /datum/bioware/relocated_heart(target)
	return ..()

/datum/bioware/relocated_heart
	name = "Relocated Heart"
	desc = "The circulatory system has been completely reworked, and the heart moved into a new location!"
	mod_type = BIOWARE_CIRCULATION

/datum/bioware/relocated_heart/on_gain()
	..()
	owner.stakeimmune = TRUE

/datum/bioware/relocated_heart/on_lose()
	..()
	owner.stakeimmune = FALSE
