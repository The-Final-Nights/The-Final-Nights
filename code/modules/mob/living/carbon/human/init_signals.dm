/mob/living/carbon/human/register_init_signals()
	. = ..()
	RegisterSignals(src, list(SIGNAL_ADDTRAIT(TRAIT_SALUBRI_EYE), SIGNAL_REMOVETRAIT(TRAIT_SALUBRI_EYE)), PROC_REF(on_salubri_eye))

/mob/living/carbon/human/proc/on_salubri_eye()
	SIGNAL_HANDLER


	if(HAS_TRAIT(src, TRAIT_SALUBRI_EYE))
		var/obj/item/organ/eyes/salubri/salubri_eye = new()
		salubri_eye.Insert(src, TRUE, FALSE)
	else
		var/obj/item/organ/eyes/salubri/salubri_eyes = getorganslot(ORGAN_SLOT_EYES)
		salubri_eyes.Remove(src)
