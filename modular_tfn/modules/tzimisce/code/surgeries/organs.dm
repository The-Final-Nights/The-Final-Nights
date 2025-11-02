/obj/item/organ/cyberimp/chest/nutriment/tzimisce
	name = "Secondary Stomach"
	desc = "This secondary stomach is capable of highly efficient digestion of stored biomatter reserves."
	icon_state = "stomach-x"
	hunger_threshold = NUTRITION_LEVEL_HUNGRY
	poison_amount = 0
	slot = ORGAN_SLOT_STOMACH_AID

/obj/item/organ/cyberimp/chest/nutriment/tzimisce/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)

/obj/item/organ/cyberimp/chest/reviver/tzimisce
	name = "Second Heart"
	desc = "This organ will automatically restart a cardiac system upon cessation of vital functions, alongside releasing mild regenerative chemicals. Implanted in the chest."
	icon_state = "heart-tzi"
	slot = ORGAN_SLOT_HEART_AID

/obj/item/organ/cyberimp/chest/reviver/tzimisce/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)

/obj/item/organ/eyes/thermal
	name = "thermal eyes"
	desc = "Augmented eyes capable of seeing thermal signatures."
	icon_state = "ling_thermal"
	sight_flags = SEE_MOBS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	flash_protect = FLASH_PROTECTION_SENSITIVE
	see_in_dark = 8
