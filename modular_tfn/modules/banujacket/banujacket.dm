/obj/item/clothing/suit/vampire/jacket/banu
	name = "studded leather jacket"
	icon = 'modular_tfn/modules/banujacket/icons/banujacket.dmi'
	icon_state = "bhp_clothing"
	onflooricon = 'modular_tfn/modules/banujacket/icons/banujacket.dmi'
	onflooricon_state = "bhp_onfloor"
	worn_icon = 'modular_tfn/modules/banujacket/icons/banujacket.dmi'
	worn_icon_state = "bhp_worn"
	desc = "Punk clothing for any Assamite. Provides some kind of protection."
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 40, BOMB = 50, BIO = 0, RAD = 0, FIRE = 40, ACID = 10, WOUND = 35)
	body_parts_covered = CHEST | GROIN | ARMS
	max_integrity = 1000;
	allowed = list(
		/obj/item/card/id,
		/obj/item/flashlight,
	)
