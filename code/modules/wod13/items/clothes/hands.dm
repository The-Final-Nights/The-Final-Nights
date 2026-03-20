//GLOVES

//GLOVES

//GLOVES

/obj/item/clothing/gloves/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	inhand_icon_state = "fingerless"
	undyeable = TRUE
	body_worn = TRUE

/obj/item/clothing/gloves/vampire/leather
	name = "leather gloves"
	desc = "Looks dangerous. Provides some kind of protection."
	icon_state = "leather"
	transfer_prints = TRUE
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 15, BULLET = 15, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 30)

/obj/item/clothing/gloves/vampire/work
	name = "work gloves"
	desc = "Provides fire protection for working in extreme environments."
	icon_state = "work"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 30, BULLET = 15, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 70, ACID = 30)

/obj/item/clothing/gloves/vampire/investigator
	name = "investigator gloves"
	desc = "Standard issue FBI workgloves tailored for investigators. Made out of latex outer lining and padded for acid and fire protection."
	icon_state = "work"
	permeability_coefficient = 0.5
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list(MELEE = 30, BULLET = 20, LASER = 5, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 70, ACID = 70)

/obj/item/clothing/gloves/vampire/cleaning
	name = "cleaning gloves"
	desc = "Provides acid protection."
	icon_state = "cleaning"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 70)

/obj/item/clothing/gloves/vampire/latex
	name = "latex gloves"
	desc = "Provides acid protection."
	icon_state = "latex"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 70)

/obj/item/clothing/gloves/vampire/white
	name = "white gloves"
	desc = "A pair of fine, white gloves, a symbol of of cleanliness and quality, and not much else. Getting them dirty shows how unprofessional you are."
	icon_state = "white_gloves"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/vampire/brassknuckles
	name = "brass knuckles"
	desc = "A set of tarnished brass rings fused together to create a cruel weapon for back-alley brawls. Illegal in most places."
	icon_state = "brassknuckles"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/gloves/vampire/brassknuckles/equipped(mob/living/carbon/human/user, slot)
	..()
	if(ishuman(user) && slot == ITEM_SLOT_GLOVES)
		user.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
		user.dna.species.punchdamagelow += 10		//low of ~20 (base human/kindred/etc)
		user.dna.species.punchdamagehigh += 10		//high of ~30 (base human/kindred/etc)
		to_chat(user, span_notice("You fit your fingers into the brass knuckle's loops.."))

/obj/item/clothing/gloves/vampire/brassknuckles/dropped(mob/living/carbon/human/user, slot)
	..()
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		user.dna.species.attack_sound = initial(user.dna.species.attack_sound)
		user.dna.species.punchdamagelow -= 10
		user.dna.species.punchdamagehigh -= 10
		to_chat(user, span_notice("You take off the bass knuckles."))

/obj/item/clothing/gloves/vampire/spikedknuckles
	name = "spiked steel knuckles"
	desc = "A set of tarnished steel rings fused together and topped with piercing metal spikes. Illegal in most places."
	icon_state = "spikedknuckles"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0)

/obj/item/clothing/gloves/vampire/spikedknuckles/equipped(mob/living/carbon/human/user, slot)
	..()
	if(ishuman(user) && slot == ITEM_SLOT_GLOVES)
		user.dna.species.attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
		user.dna.species.sharpness = SHARP_POINTY
		user.dna.species.punchdamagelow += 10		//low of ~20 (base human/kindred/etc)
		user.dna.species.punchdamagehigh += 10		//high of ~30 (base human/kindred/etc)
		to_chat(user, span_notice("You fit your fingers into the spiked knuckle's loops.."))

/obj/item/clothing/gloves/vampire/spikedknuckles/dropped(mob/living/carbon/human/user, slot)
	..()
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		user.dna.species.attack_sound = initial(user.dna.species.attack_sound)
		user.dna.species.sharpness = initial(user.dna.species.sharpness)
		user.dna.species.punchdamagelow -= 10
		user.dna.species.punchdamagehigh -= 10
		to_chat(user, span_notice("You take off the spiked knuckles."))
