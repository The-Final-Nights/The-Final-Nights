/obj/structure/bloodextractor
	name = "blood extractor"
	desc = "Extract blood in packs."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "bloodextractor"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	COOLDOWN_DECLARE(last_extracted)

/obj/structure/bloodextractor/MouseDrop_T(mob/living/target, mob/living/user)
	. = ..()
	if(user.stat != CONSCIOUS || HAS_TRAIT(user, TRAIT_UI_BLOCKED) || !Adjacent(user) || !target.Adjacent(user) || !ishuman(target))
		return
	if(!target.buckled)
		to_chat(user, span_warning("You need to buckle [target] before using the extractor!"))
		return
	if(TIMER_COOLDOWN_CHECK(target, last_extracted))
		to_chat(user, span_warning("The [src] isn't ready yet!"))
		return
	TIMER_COOLDOWN_START(target, last_extracted, 20 SECONDS)

	if(iskindred(src))
		if(target.bloodpool < 4)
			to_chat(user, span_warning("The [src] can't find enough blood in [target]'s body!"))
			return
		new /obj/item/reagent_containers/blood/vitae(src)
		target.bloodpool = max(0, target.bloodpool - 4)
		return

	if(target.bloodpool < 2)
		to_chat(user, span_warning("The [src] can't find enough blood in [target]'s body!"))
		return
	if(HAS_TRAIT(target, TRAIT_POTENT_BLOOD))
		new /obj/item/reagent_containers/blood/elite(src)
	else
		new /obj/item/reagent_containers/blood(src)
	target.bloodpool = max(0, target.bloodpool - 2)

