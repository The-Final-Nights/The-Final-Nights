/mob/living/carbon/human/register_init_signals()
	. = ..()
	RegisterSignals(src, list(SIGNAL_ADDTRAIT(TRAIT_SALUBRI_EYE), SIGNAL_REMOVETRAIT(TRAIT_SALUBRI_EYE)), PROC_REF(on_salubri_eye))
	RegisterSignals(src, list(SIGNAL_ADDTRAIT(TRAIT_DWARF), SIGNAL_REMOVETRAIT(TRAIT_DWARF)), PROC_REF(on_dwarf_trait))


/mob/living/carbon/human/proc/on_salubri_eye()
	SIGNAL_HANDLER


	if(HAS_TRAIT(src, TRAIT_SALUBRI_EYE))
		var/obj/item/organ/eyes/salubri/salubri_eye = new()
		salubri_eye.Insert(src, TRUE, FALSE)
	else
		var/obj/item/organ/eyes/salubri/salubri_eyes = getorganslot(ORGAN_SLOT_EYES)
		salubri_eyes.Remove(src)

/// Gaining or losing [TRAIT_DWARF] updates our height
/mob/living/carbon/human/proc/on_dwarf_trait(datum/source)
	SIGNAL_HANDLER

	// We need to regenerate everything for height
	regenerate_icons()
	// Toggle passtable
	if(HAS_TRAIT(src, TRAIT_DWARF))
		passtable_on(src, TRAIT_DWARF)
	else
		passtable_off(src, TRAIT_DWARF)
