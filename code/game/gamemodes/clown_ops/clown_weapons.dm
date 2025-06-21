/obj/item/reagent_containers/spray/waterflower/lube
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist. A <i>slippery</i> twist."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "sunflower"
	inhand_icon_state = "sunflower"
	amount_per_transfer_from_this = 3
	spray_range = 1
	stream_range = 1
	volume = 30
	list_reagents = list(/datum/reagent/lube = 30)

//COMBAT CLOWN SHOES
//Clown shoes with combat stats and noslip. Of course they still squeak.
/obj/item/clothing/shoes/clown_shoes/combat
	name = "combat clown shoes"
	desc = "advanced clown shoes that protect the wearer and render them nearly immune to slipping on their own peels. They also squeak at 100% capacity."
	clothing_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN
	armor = list(MELEE = 25, BULLET = 25, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 10, RAD = 0, FIRE = 70, ACID = 50)
	strip_delay = 70
	resistance_flags = NONE
	permeability_coefficient = 0.05
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes

/// Recharging rate in PPS (peels per second)
#define BANANA_SHOES_RECHARGE_RATE 17
#define BANANA_SHOES_MAX_CHARGE 3000

//The super annoying version
/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat
	name = "mk-honk combat shoes"
	desc = "The culmination of years of clown combat research, these shoes leave a trail of chaos in their wake. They will slowly recharge themselves over time, or can be manually charged with bananium."
	slowdown = SHOES_SLOWDOWN
	armor = list(MELEE = 25, BULLET = 25, LASER = 25, ENERGY = 25, BOMB = 50, BIO = 10, RAD = 0, FIRE = 70, ACID = 50)
	strip_delay = 70
	resistance_flags = NONE
	permeability_coefficient = 0.05
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	always_noslip = TRUE

/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat/Initialize()
	. = ..()
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	bananium.insert_amount_mat(BANANA_SHOES_MAX_CHARGE, /datum/material/bananium)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat/process(delta_time)
	var/datum/component/material_container/bananium = GetComponent(/datum/component/material_container)
	var/bananium_amount = bananium.get_material_amount(/datum/material/bananium)
	if(bananium_amount < BANANA_SHOES_MAX_CHARGE)
		bananium.insert_amount_mat(min(BANANA_SHOES_RECHARGE_RATE * delta_time, BANANA_SHOES_MAX_CHARGE - bananium_amount), /datum/material/bananium)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat/attack_self(mob/user)
	ui_action_click(user)

#undef BANANA_SHOES_RECHARGE_RATE
#undef BANANA_SHOES_MAX_CHARGE

//BOMBANANA

/obj/item/food/grown/banana/bombanana
	trash_type = /obj/item/grown/bananapeel/bombanana
	bite_consumption = 1
	seed = null
	tastes = list("explosives" = 10)
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)

/obj/item/grown/bananapeel/bombanana
	desc = "A peel from a banana. Why is it beeping?"
	seed = null
	var/det_time = 50
	var/obj/item/grenade/syndieminibomb/bomb

/obj/item/grown/bananapeel/bombanana/Initialize()
	. = ..()
	bomb = new /obj/item/grenade/syndieminibomb(src)
	bomb.det_time = det_time
	if(iscarbon(loc))
		to_chat(loc, "<span class='danger'>[src] begins to beep.</span>")
	bomb.arm_grenade(loc, null, FALSE)

/obj/item/grown/bananapeel/bombanana/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, det_time)

/obj/item/grown/bananapeel/bombanana/Destroy()
	. = ..()
	QDEL_NULL(bomb)

/obj/item/grown/bananapeel/bombanana/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is deliberately slipping on the [src.name]! It looks like \he's trying to commit suicide.</span>")
	playsound(loc, 'sound/misc/slip.ogg', 50, TRUE, -1)
	bomb.arm_grenade(user, 0, FALSE)
	return (BRUTELOSS)

//TEARSTACHE GRENADE

/obj/item/grenade/chem_grenade/teargas/moustache
	name = "tear-stache grenade"
	desc = "A handsomely-attired teargas grenade."
	icon_state = "moustacheg"
	clumsy_check = GRENADE_NONCLUMSY_FUMBLE

/obj/item/grenade/chem_grenade/teargas/moustache/detonate(mob/living/lanced_by)
	var/myloc = get_turf(src)
	. = ..()
	for(var/mob/living/carbon/M in view(6, myloc))
		if(!istype(M.wear_mask, /obj/item/clothing/mask/gas/clown_hat) && !istype(M.wear_mask, /obj/item/clothing/mask/gas/mime) )
			if(!M.wear_mask || M.dropItemToGround(M.wear_mask))
				var/obj/item/clothing/mask/fakemoustache/sticky/the_stash = new /obj/item/clothing/mask/fakemoustache/sticky()
				M.equip_to_slot_or_del(the_stash, ITEM_SLOT_MASK, TRUE, TRUE, TRUE, TRUE)

/obj/item/clothing/mask/fakemoustache/sticky
	var/unstick_time = 600

/obj/item/clothing/mask/fakemoustache/sticky/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_MOUSTACHE_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(unstick)), unstick_time)

/obj/item/clothing/mask/fakemoustache/sticky/proc/unstick()
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_MOUSTACHE_TRAIT)

//DARK H.O.N.K. AND CLOWN MECH WEAPONS

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana
	name = "bombanana mortar"
	desc = "Equipment for clown exosuits. Launches exploding banana peels."
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/grown/bananapeel/bombanana
	projectiles = 8
	projectile_energy_cost = 1000

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana/can_attach(obj/vehicle/sealed/mecha/combat/honker/M)
	if(..())
		if(istype(M))
			return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache
	name = "\improper HONKeR-6 grenade launcher"
	desc = "A weapon for combat exosuits. Launches primed tear-stache grenades."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/grenade/chem_grenade/teargas/moustache
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 60
	det_time = 20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache/can_attach(obj/vehicle/sealed/mecha/combat/honker/M)
	if(..())
		if(istype(M))
			return TRUE
	return FALSE

/obj/vehicle/sealed/mecha/combat/honker/dark
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. This one has been painted black for maximum fun. HONK!"
	name = "\improper Dark H.O.N.K"
	icon_state = "darkhonker"
	max_integrity = 300
	deflect_chance = 15
	armor = list(MELEE = 40, BULLET = 40, LASER = 50, ENERGY = 35, BOMB = 20, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	max_temperature = 35000
	operation_req_access = list(ACCESS_SYNDICATE)
	internals_req_access = list(ACCESS_SYNDICATE)
	wreckage = /obj/structure/mecha_wreckage/honker/dark
	max_equip = 4

/obj/vehicle/sealed/mecha/combat/honker/dark/add_cell(obj/item/stock_parts/cell/C)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/stock_parts/cell/hyper(src)

/obj/vehicle/sealed/mecha/combat/honker/dark/loaded/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/thrusters/ion(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/honker()
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana()//Needed more offensive weapons.
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/flashbang/tearstache()//The mousetrap mortar was not up-to-snuff.
	ME.attach(src)

/obj/structure/mecha_wreckage/honker/dark
	name = "\improper Dark H.O.N.K wreckage"
	icon_state = "darkhonker-broken"
