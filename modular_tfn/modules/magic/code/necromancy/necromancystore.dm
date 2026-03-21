/mob/living/simple_animal/corpsestore
	name = "corpsestore"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "bat_dead"
	bloodquality = BLOOD_QUALITY_LOW
	maxHealth = 1
	health = 1

/mob/living/simple_animal/corpsestore/corpse1
	name = "bat corpse"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "bat_dead"
	maxHealth = 15
	health = 1
	stat = DEAD

/mob/living/simple_animal/corpsestore/corpse2
	name = "dog corpse"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "dog_dead"
	maxHealth = 30
	health = 1
	stat = DEAD

/mob/living/simple_animal/corpsestore/corpse3
	name = "bone pile"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "skeleton_dead"
	maxHealth = 60
	health = 1
	stat = DEAD

/mob/living/simple_animal/corpsestore/corpse4
	name = "rotting corpse"
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "zombieup_dead"
	maxHealth = 120
	health = 1
	stat = DEAD

/mob/living/simple_animal/corpsestore/corpse5
	name = "bear corpse"
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "bear_dead"
	maxHealth = 500
	health = 1
	stat = DEAD

/obj/item/corpsestore
	name = "corpsestore"
	icon_state = "legion_skull"

/obj/item/corspestore/skull
	name = "empty skull"
	desc = "A skull, empty and void of life."
	icon = 'icons/obj/lavaland/artefacts.dmi'
	icon_state = "legion_skull"

/obj/item/coin/oboli
	name = "Oboli"
	desc = "A coin made from a strange gray metal like iron. It's cold to the touch, about 4 inches in diameter, and has a marking of a ferryman on a boat."
	icon = 'icons/obj/economy.dmi'
	icon_state = "coin"
	color = "#808080"
	force = 1
	throwforce = 2
	material_flags = NONE
	w_class = WEIGHT_CLASS_TINY

/obj/item/coin/oboli/Initialize()
	. = ..()
	coinflip = pick(sideslist)
	icon_state = "coin_[coinflip]"
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8
	AddComponent(/datum/component/selling, 300, "Oboli", TRUE, -1, 4)

/obj/item/melee/vampirearms/knife/soulsteel
	name = "soulsteel dagger"
	desc = "A dagger made from soulsteel."
	icon = 'icons/obj/eldritch.dmi'
	icon_state = "rune_carver"
	color = "#808080"
	force = 30
	wound_bonus = -5
	bare_wound_bonus = 5
	throwforce = 15
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/weapons/slash.ogg'
	armour_penetration = 35
	block_chance = 5
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FIRE_PROOF
	is_iron = FALSE
