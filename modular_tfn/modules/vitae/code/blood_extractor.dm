/obj/structure/bloodextractor
	name = "blood extractor"
	desc = "Extract blood in packs."
	icon = 'modular_tfn/modules/vitae/icons/blood_extractor.dmi'
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
	if(iszombie(target))
		to_chat(user, span_warning("[target]'s still, rotten blood cannot be drawn!"))
		return
	if(!COOLDOWN_FINISHED(src, last_extracted))
		to_chat(user, span_warning("The [src] isn't ready yet!"))
		return
	COOLDOWN_START(src, last_extracted, 20 SECONDS)
	if(!do_after(target, 5 SECONDS, src))
		return
	if(iskindred(target))
		if(target.bloodpool < 4)
			to_chat(user, span_warning("The [src] can't find enough blood in [target]'s body!"))
			return
		var/obj/item/reagent_containers/blood/vitae/vitae_bloodpack = new /obj/item/reagent_containers/blood/vitae(get_turf(src))
		generate_blood_pack(target, vitae_bloodpack)
		target.bloodpool = max(0, target.bloodpool - 4)
		return

	if(target.bloodpool < 2)
		to_chat(user, span_warning("The [src] can't find enough blood in [target]'s body!"))
		return
	if(HAS_TRAIT(target, TRAIT_POTENT_BLOOD))
		var/obj/item/reagent_containers/blood/elite/elite_bloodpack = new /obj/item/reagent_containers/blood/elite(get_turf(src))
		generate_blood_pack(target, elite_bloodpack)
	else
		var/obj/item/reagent_containers/blood/empty/bloodpack = new /obj/item/reagent_containers/blood/empty(get_turf(src))
		generate_blood_pack(target, bloodpack)
	target.bloodpool = max(0, target.bloodpool - 2)

/obj/structure/bloodextractor/proc/generate_blood_pack(mob/living/target, obj/item/reagent_containers/blood/blood_pack)
	var/blood_id = target.get_blood_id()
	if(!blood_id)
		return FALSE
	var/list/blood_data = target.get_blood_data(blood_id)
	blood_pack.reagents.add_reagent(blood_id, 200, blood_data)
	blood_pack.update_appearance()
