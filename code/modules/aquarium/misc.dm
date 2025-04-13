#define AQUARIUM_COMPANY "Aquatech Ltd."

// Fish feed can
/obj/item/fish_feed
	name = "fish feed can"
	desc = "Autogenerates nutritious fish feed based on sample inside."
	icon = 'icons/obj/aquarium.dmi'
	icon_state = "fish_feed"
	w_class = WEIGHT_CLASS_TINY

/obj/item/fish_feed/Initialize()
	. = ..()
	create_reagents(5, OPENCONTAINER)
	reagents.add_reagent(/datum/reagent/consumable/nutriment, 1) //Default fish diet

// Stasis fish case container for moving fish between aquariums safely.
/obj/item/storage/fish_case
	name = "stasis fish case"
	desc = "A small case keeping the fish inside in stasis."
	icon_state = "fishbox"

	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

	component_type = /datum/component/storage/concrete/fish_case

/obj/item/storage/fish_case/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_FISH_SAFE_STORAGE, TRAIT_GENERIC)

/// Fish case with single random fish inside.
/obj/item/storage/fish_case/random/PopulateContents()
	. = ..()
	generate_fish(src, select_fish_type())

/obj/item/storage/fish_case/random/proc/select_fish_type()
	return random_fish_type()

/obj/item/storage/fish_case/random/freshwater/select_fish_type()
	return random_fish_type(required_fluid=AQUARIUM_FLUID_FRESHWATER)

/obj/item/aquarium_kit
	name = "DIY Aquarium Construction Kit"
	desc = "Everything you need to build your own aquarium.(Raw materials sold separately)"
	icon = 'icons/obj/aquarium.dmi'
	icon_state = "construction_kit"
	w_class = WEIGHT_CLASS_TINY

/obj/item/aquarium_kit/attack_self(mob/user)
	. = ..()
	to_chat(user,"<span class='notice'>There's instruction and tools necessary to build aquarium inside. All you need is to start crafting.</span>")


/obj/item/aquarium_prop
	name = "generic aquarium prop"
	desc = "very boring"
	w_class = WEIGHT_CLASS_TINY

/obj/item/storage/box/aquarium_props
	name = "aquarium props box"
	desc = "All you need to make your aquarium look good"

/obj/item/storage/box/aquarium_props/PopulateContents()
	for(var/prop_type in subtypesof(/datum/aquarium_behaviour/prop))
		generate_fish(src, prop_type, /obj/item/aquarium_prop)

/obj/item/storage/box/fish_debug
	name = "box full of fish"

/obj/item/storage/box/fish_debug/PopulateContents()
	for(var/fish_type in subtypesof(/datum/aquarium_behaviour/fish))
		generate_fish(src,fish_type)

#undef AQUARIUM_COMPANY
