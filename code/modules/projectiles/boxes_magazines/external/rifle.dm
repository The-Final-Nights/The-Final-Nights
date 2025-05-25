/obj/item/ammo_box/magazine/m10mm/rifle
	name = "rifle magazine (10mm)"
	desc = "A well-worn magazine fitted for the surplus rifle."
	icon_state = "75-8"
	base_icon_state = "75"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 10

/obj/item/ammo_box/magazine/m10mm/rifle/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[ammo_count() ? "8" : "0"]"

/obj/item/ammo_box/magazine/m556
	name = "toploader magazine (5.56mm)"
	icon_state = "5.56m"
	ammo_type = /obj/item/ammo_casing/a556
	caliber = CALIBER_A556
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m556/phasic
	name = "toploader magazine (5.56mm Phasic)"
	ammo_type = /obj/item/ammo_casing/a556/phasic

/obj/item/ammo_box/magazine/m556/bleeder
	name = "toploader magazine (5.56mm Bleeder)"
	ammo_type = /obj/item/ammo_casing/a556/bleeder

/obj/item/ammo_box/magazine/m556/compound
	name = "toploader magazine (5.56mm Compound)"
	ammo_type = /obj/item/ammo_casing/a556/compound

/obj/item/ammo_box/magazine/m556/hod
	name = "toploader magazine (5.56mm Hod)"
	ammo_type = /obj/item/ammo_casing/a556/hod

/obj/item/ammo_box/magazine/m556/incendiary
	name = "toploader magazine (5.56mm Incendiary)"
	ammo_type = /obj/item/ammo_casing/a556/incendiary

/obj/item/ammo_box/magazine/m556/silver
	name = "toploader magazine (5.56mm Silver)"
	ammo_type = /obj/item/ammo_casing/a556/silver
