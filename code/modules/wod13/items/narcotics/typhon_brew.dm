/obj/item/reagent_containers/drug/typhon_brew
	name = "Typhon's Brew (Full)"
	desc = "A sanquine drink to sate those of vampiric tastes."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "typhon"
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 40) //some of the source chemicals are lost in the process
	resistance_flags = FREEZE_PROOF
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF

	var/empty = FALSE
	var/feeding = FALSE
	var/amount_of_bloodpoints = 4
	var/vitae = FALSE

/obj/item/reagent_containers/drug/typhon_brew/attack(mob/living/M, mob/living/user)
	. = ..()
	if(empty)
		return
	if(isghoul(M) || iskindred(M))
		feeding = TRUE
		if(do_mob(user, src, 3 SECONDS))
			var/obj/item/reagent_containers/drug/typhon_brew/H = new(src) //setting up the drugged bag in question (and its contents) as a variable to be called later
			feeding = FALSE
			empty = TRUE
			icon_state = "typhon-open"
			name = "Typhon's Brew (Empty)"
			if(isghoul(M))
				M.bloodpool = min(M.maxbloodpool, M.bloodpool+(amount_of_bloodpoints*4))
			else
				M.bloodpool = min(M.maxbloodpool, M.bloodpool+amount_of_bloodpoints)
			M.adjustBruteLoss(-20, TRUE)
			M.adjustFireLoss(-20, TRUE)
			M.update_damage_overlays()
			M.update_health_hud()
			if(iskindred(M) || isghoul(M))
				M.update_blood_hud()
				H.reagents.trans_to(M, H.reagents.total_volume, transfered_by = H, methods = VAMPIRE) //calling the earlier variable to transfer to target, M
			playsound(M.loc,'sound/items/drink.ogg', 50, TRUE)
			return
		else
			feeding = FALSE
			return
