/obj/item/card/id/tapster
	name = "bartender badge"
	id_type_name = "bartender badge"
	desc = "A badge displaying a beverage glass."
	icon = 'modular_tfn/modules/anarch_bartender/tapster.dmi'
	icon_state = "tapster_badge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "bruiser_badge"
	registered_name_is_public = FALSE

/obj/item/vamp/phone/tapster
	contact_networks_pre_init = list(
		list(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Bartender", USE_JOB_TITLE = FALSE))

/obj/item/vamp/keys/anarch_limited
	name = "Barkeeper keys"
	accesslocks = list(
		"biker_bar"
	)
	color = "#434343"
