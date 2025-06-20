// Honker

/obj/projectile/bullet/honker
	name = "banana"
	damage = 0
	movement_type = FLYING
	projectile_piercing = ALL
	nodamage = TRUE
	hitsound = 'sound/items/bikehorn.ogg'
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "banana"
	range = 200
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/honker/Initialize()
	. = ..()
	SpinAnimation()

/obj/projectile/bullet/honker/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/M = target
	if(istype(M))
		M.slip(100, M.loc, GALOSHES_DONT_HELP|SLIDE, 0, FALSE)

// Mime

/obj/projectile/bullet/mime
	damage = 40

/obj/projectile/bullet/mime/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.silent = max(M.silent, 10)

/obj/projectile/bullet/bleeder //Base object here, split off pistol/rifle/sniper variants, etc.
	name = "bleeder round"
	damage = 25  //Variants should deal less base damage than their equivalents.
	armour_penetration = 30
	wound_bonus = -40
	speed = 0.1			//Amount of deciseconds it takes for projectile to travel
	var/bloodloss = 1

/obj/projectile/bullet/bleeder/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iskindred(target) || isghoul(target))
		var/mob/living/carbon/human/H = target
		if(H.bloodpool == 0)
			to_chat(H, span_warning("You have been bled dry!"))
			return
		H.bloodpool = max(H.bloodpool - bloodloss, 0)
		to_chat(H, span_warning("You feel the round tear away your blood stores!"))

/obj/projectile/bullet/compound //Base object here, split off pistol/rifle/sniper variants, etc.
	name = "compound round"
	damage = 25 //Variants should deal less base damage than their equivalents.
	armour_penetration = 30
	wound_bonus = -40
	speed = 0.1
	var/supernaturalbonus = 30

/obj/projectile/bullet/compound/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iskindred(target) || isghoul(target) || iscathayan(target) || isgarou(target) || iswerewolf(target))
		var/mob/living/carbon/C = target
		C.adjustFireLoss(supernaturalbonus)
		to_chat(C, span_warning("You feel the round burning as it hits you!"))

/obj/projectile/bullet/hod //Base object here, split off pistol/rifle/sniper variants, etc.
	name = "hod round"
	damage = 25 //Variants should deal less base damage than their equivalents.
	armour_penetration = 30
	wound_bonus = -40
	speed = 0.1
	var/paralysetime = 100 //How long should the round paralyse vamps for? In ticks, so approximately 10 to a second.

/obj/projectile/bullet/hod/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/human/H = target
	if(!H.IsParalyzed() && iskindred(H) && !H.stakeimmune)
		if(HAS_TRAIT(target, TRAIT_STAKE_RESISTANT))
			to_chat(H, span_warning("the round splinters as it touches [H]'s heart!"))
			REMOVE_TRAIT(H, TRAIT_STAKE_RESISTANT, MAGIC_TRAIT)
			qdel(src)
		else
			to_chat(H, span_warning("The round splits apart in [H]'s torso!"))
			H.Paralyze(paralysetime)
			H.Sleeping(paralysetime)
			qdel(src)


