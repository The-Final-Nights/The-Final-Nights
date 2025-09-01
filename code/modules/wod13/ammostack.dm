/obj/projectile/beam/beam_rifle/vampire
	name = "bullet"
	icon = null
	damage = 20
	pass_flags = PASSTABLE
	damage_type = BRUTE
	nodamage = FALSE
	flag = BULLET
	reflectable = NONE
	ricochets_max = 0
	hitsound = 'sound/weapons/pierce.ogg'
	hitsound_wall = "ricochet"
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=15, fall_chance=2, jostle_chance=0, ignore_throwspeed_threshold=TRUE, pain_stam_pct=0.5, pain_mult=3, rip_time=10)
	wound_falloff_tile = -5
	embed_falloff_tile = -5
	range = 50
	eyeblur = 0
	light_range = 0
	light_power = 0
	icon_state = ""
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/tracer/beam_rifle/vampire

/obj/projectile/beam/beam_rifle/vampire/generate_hitscan_tracers(cleanup = TRUE, duration = 5, impacting = TRUE, highlander)
	set waitfor = FALSE
	if(isnull(highlander))
		highlander = TRUE
	if(highlander && istype(gun))
		QDEL_LIST(gun.current_tracers)
		for(var/datum/point/p in beam_segments)
			gun.current_tracers += generate_tracer_between_points(p, beam_segments[p], tracer_type, color, 0, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity)
	else
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity)
	if(cleanup)
		QDEL_LIST(beam_segments)
		beam_segments = null
		QDEL_NULL(beam_index)

/obj/projectile/beam/beam_rifle/vampire/vamp9mm
	name = "9mm bullet"
	damage = 20
	bare_wound_bonus = 10

/obj/projectile/beam/beam_rifle/vampire/vamp9mm/plus
	name = "9mm HV bullet"
	damage = 23
	armour_penetration = 10

/obj/projectile/beam/beam_rifle/vampire/vamp45acp
	name = ".45 ACP bullet"
	damage = 24

/obj/projectile/beam/beam_rifle/vampire/vamp45acp/HP
	name = "45acp hollow point bullet"
	damage = 25
	armour_penetration = 0
	bare_wound_bonus = 5
	wound_bonus = 5

/obj/projectile/beam/beam_rifle/vampire/vamp44
	name = ".44 bullet"
	damage = 30
	armour_penetration = 15
	bare_wound_bonus = -5
	wound_bonus = 10

/obj/projectile/beam/beam_rifle/vampire/vamp46mm
	name = "4.6mm"
	damage = 18
	armour_penetration = 35

/obj/projectile/beam/beam_rifle/vampire/vamp762x51mm
	name = "7.62x51mm bullet"
	damage = 55
	armour_penetration = 25
	bare_wound_bonus = -5
	wound_bonus = 5

/obj/projectile/beam/beam_rifle/vampire/vamp50
	name = ".50 bullet"
	damage = 70
	armour_penetration = 20
	bare_wound_bonus = 5
	wound_bonus = 5

/obj/projectile/beam/beam_rifle/vampire/vamp556mm
	name = "5.56mm bullet"
	damage = 40
	armour_penetration = 25
	bare_wound_bonus = -5
	wound_bonus = 5

/obj/projectile/beam/beam_rifle/vampire/vamp545mm
	name = "5.45mm bullet"
	damage = 40
	armour_penetration = 30
	bare_wound_bonus = 5
	wound_bonus = -5

/obj/projectile/beam/beam_rifle/vampire/vamp12g
	name = "12g shotgun slug"
	damage = 70
	armour_penetration = 15
	bare_wound_bonus = 10
	wound_bonus = 5

/obj/projectile/beam/beam_rifle/vampire/rubber
	name = "12g shotgun rubber shot"
	damage = 5
	stamina = 25

/obj/projectile/beam/beam_rifle/vampire/incap
	name = "12g shotgun incapacitation shot"
	damage = 15
	stamina = 60

/obj/projectile/beam/beam_rifle/vampire/vamp12g
	name = "12g shotgun slug"

/obj/projectile/beam/beam_rifle/vampire/vamp12g/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/hit_person = target
		if(SSroll.storyteller_roll(
			dice = hit_person.get_total_physique() + min(hit_person.get_total_dexterity(), hit_person.get_total_athletics()),
			difficulty = 3 + (!isnull(firer) ? rand(1,2) : 0),
			mobs_to_show_output = target
		) == ROLL_FAILURE)
			hit_person.Knockdown(20)
			to_chat(hit_person, "<span class='danger'>The force of a projectile sends you sprawling!</span>")


/obj/projectile/beam/beam_rifle/vampire/shotpellet
	name = "12g shotgun pellet"
	damage = 10
	range = 22 //range of where you can see + one screen after
	armour_penetration = 15
	bare_wound_bonus = 5
	wound_bonus = 0

/obj/projectile/beam/beam_rifle/vampire/shotpellet/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.Stun(4)

/obj/projectile/beam/beam_rifle/vampire/vamp762x51mm/incendiary
	armour_penetration = 5 //Big ass bullet
	damage = 50
	var/fire_stacks = 3 //This one comes in Semi-automatics

/obj/projectile/beam/beam_rifle/vampire/vamp762x51mm/incendiary/on_hit(atom/target, blocked = FALSE)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks, 10) //Let's see, if it gets bad I'll change it.
		M.IgniteMob()

/obj/projectile/beam/beam_rifle/vampire/vamp556mm/incendiary
	armour_penetration = 0
	damage = 35
	var/fire_stacks = 2 //These always come in guns that fire in bursts.

/obj/projectile/beam/beam_rifle/vampire/vamp556mm/incendiary/on_hit(atom/target, blocked = FALSE)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks, 5) //No more than one roll.
		M.IgniteMob()

/obj/projectile/bullet/crossbow_bolt
	name = "bolt"
	damage = 30
	armour_penetration = 75
	sharpness = SHARP_POINTY

/obj/item/ammo_casing/vampire
	icon = 'code/modules/wod13/ammo.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	var/base_iconstate

/obj/item/ammo_casing/vampire/c9mm
	name = "9mm bullet casing"
	desc = "A 9mm bullet casing."
	caliber = CALIBER_9MM
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp9mm
	icon_state = "9"
	base_iconstate = "9"

/obj/item/ammo_casing/vampire/c9mm/plus
	name = "9mm HV bullet casing"
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp9mm/plus
	caliber = CALIBER_9MM

/obj/item/ammo_casing/vampire/c45acp
	name = ".45 ACP bullet casing"
	desc = "A .45 ACP bullet casing."
	caliber = CALIBER_45
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp45acp
	icon_state = "45"
	base_iconstate = "45"

/obj/item/ammo_casing/vampire/c45acp/HP
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp45acp/HP

/obj/item/ammo_casing/vampire/c44
	name = ".44 bullet casing"
	desc = "A .44 bullet casing."
	caliber = CALIBER_44
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp44
	icon_state = "44"
	base_iconstate = "44"

/obj/item/ammo_casing/vampire/c46mm
	name = "4.6mm bullet casing"
	desc = "A 4.6mm bullet casing."
	caliber = CALIBER_46
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp46mm
	icon_state = "46"
	base_iconstate = "46"

/obj/item/ammo_casing/vampire/c50
	name = ".50 bullet casing"
	desc = "A .50 bullet casing."
	caliber = CALIBER_50
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp50
	icon_state = "50"
	base_iconstate = "50"

/obj/item/ammo_casing/vampire/c762x51mm
	name = "7.62x51mm bullet casing"
	desc = "A 7.62x51mm bullet casing."
	caliber = CALIBER_762
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp762x51mm
	icon_state = "762"
	base_iconstate = "762"

/obj/item/ammo_casing/vampire/c556mm
	name = "5.56mm bullet casing"
	desc = "A 5.56mm bullet casing."
	caliber = CALIBER_556
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp556mm
	icon_state = "556"
	base_iconstate = "556"

/obj/item/ammo_casing/vampire/c545mm
	name = "5.45mm bullet casing"
	desc = "A 5.45mm bullet casing."
	caliber = CALIBER_545
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp545mm
	icon_state = "545"
	base_iconstate = "545"

/obj/item/ammo_casing/vampire/c556mm/incendiary
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp556mm/incendiary

/obj/item/ammo_casing/vampire/c762x51mm/incendiary
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp762x51mm/incendiary

/obj/item/ammo_casing/vampire/c12g
	name = "12g shell casing"
	desc = "A 12g shell casing."
	caliber = CALIBER_12G
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp12g
	icon_state = "12"
	base_iconstate = "12"

/obj/item/ammo_casing/vampire/c12g/buck
	desc = "A 12g shell casing (00 buck)."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/shotpellet
	pellets = 8
	variance = 25

/obj/item/ammo_casing/vampire/c12g/rubber
	name = "12g shell casing"
	desc = "A 12g shell casing."
	caliber = CALIBER_12G
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/rubber
	icon_state = "12r"
	base_iconstate = "12r"

/obj/item/ammo_casing/vampire/c12g/incap
	name = "12g shell casing"
	desc = "A 12g shell casing."
	caliber = CALIBER_12G
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/incap
	icon_state = "12i"
	base_iconstate = "12i"

/obj/item/ammo_box/vampire
	icon = 'code/modules/wod13/ammo.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_NORMAL

///9mm/////////////

/obj/item/ammo_box/vampire/c9mm
	name = "ammo box (9mm)"
	icon_state = "9box"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm
	max_ammo = 100

/obj/item/ammo_box/vampire/c9mm/plus
	name = "ammo box (9mm, +P)"
	desc = "a box of High Velocity (HV) ammo."
	ammo_type = /obj/item/ammo_casing/vampire/c9mm/plus

/obj/item/ammo_box/vampire/c9mm/moonclip
	name = "ammo clip (9mm)"
	desc = "a 3 round clip to hold 9mm rounds. For once, calling it a clip is accurate."
	icon_state = "9moonclip"
	max_ammo = 3
	w_class = WEIGHT_CLASS_TINY
	multiple_sprites = AMMO_BOX_PER_BULLET

//////////////////

/obj/item/ammo_box/vampire/c46mm
	name = "ammo box (4.6X30mm)"
	icon_state = "46box"
	ammo_type = /obj/item/ammo_casing/vampire/c46mm
	max_ammo = 120

/obj/item/ammo_box/vampire/c45acp
	name = "ammo box (.45 ACP)"
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp
	max_ammo = 100

/obj/item/ammo_box/vampire/c45acp/HP
	name = "ammo box (.45 ACP HP)"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp/HP
	max_ammo = 100

/obj/item/ammo_box/vampire/c44
	name = "ammo box (.44)"
	icon_state = "44box"
	ammo_type = /obj/item/ammo_casing/vampire/c44
	max_ammo = 60

/obj/item/ammo_box/vampire/c50
	name = "ammo box (.50)"
	icon_state = "50box"
	ammo_type = /obj/item/ammo_casing/vampire/c50
	max_ammo = 20

/obj/item/ammo_box/vampire/c556
	name = "ammo box (5.56)"
	icon_state = "556box"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm
	max_ammo = 60

/obj/item/ammo_box/vampire/c545
	name = "ammo box (5.45)"
	icon_state = "545box"
	ammo_type = /obj/item/ammo_casing/vampire/c545mm
	max_ammo = 60

/obj/item/ammo_box/vampire/c762x51mm
	name = "ammo box (7.62x51mm)"
	icon_state = "762box"
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm
	max_ammo = 80

/obj/item/ammo_box/vampire/c556/incendiary
	name = "incendiary ammo box (5.56)"
	icon_state = "incendiary"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/incendiary

/obj/item/ammo_box/vampire/c762x51mm/incendiary
	name = "incendiary ammo box (7.62x51)"
	icon_state = "762box-incendiary"
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm/incendiary

/obj/item/ammo_box/vampire/c12g
	name = "ammo box (12g)"
	icon_state = "12box"
	ammo_type = /obj/item/ammo_casing/vampire/c12g
	max_ammo = 30

/obj/item/ammo_box/vampire/c12g/buck
	name = "ammo box (12g, 00 buck)"
	icon_state = "12box_buck"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/buck

/obj/item/ammo_box/vampire/c12g/rubber
	name = "ammo box (12g, rubber shot)"
	icon_state = "12box_rubber"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/rubber

/obj/item/ammo_box/vampire/c12g/incap
	name = "ammo box (12g, High Impact Incapacitation Round)"
	icon_state = "12box_incap"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/incap

/obj/item/ammo_box/vampire/arrows
	name = "ammo box (arrows)"
	icon_state = "arrows"
	ammo_type = /obj/item/ammo_casing/caseless/bolt
	max_ammo = 30

/obj/projectile/beam/beam_rifle/vampire/vamp556mm/silver
	name = "5.56mm silver bullet"
	armour_penetration = 20

/obj/projectile/beam/beam_rifle/vampire/vamp556mm/silver/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)

		M.apply_damage(20, CLONE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/projectile/beam/beam_rifle/vampire/vamp545mm/silver
	name = "5.45 silver bullet"

/obj/projectile/beam/beam_rifle/vampire/vamp545mm/silver/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)

		M.apply_damage(10, CLONE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/projectile/beam/beam_rifle/vampire/vamp9mm/silver
	name = "9mm silver bullet"

/obj/projectile/beam/beam_rifle/vampire/vamp9mm/silver/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)

		M.apply_damage(10, CLONE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/projectile/beam/beam_rifle/vampire/vamp45acp/silver
	name = ".45 ACP silver bullet"

/obj/projectile/beam/beam_rifle/vampire/vamp45acp/silver/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)

		M.apply_damage(15, CLONE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/projectile/beam/beam_rifle/vampire/vamp44/silver
	name = ".44 silver bullet"
	icon_state = "44"

/obj/projectile/beam/beam_rifle/vampire/vamp44/silver/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)

		M.apply_damage(20, CLONE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/projectile/beam/beam_rifle/vampire/vamp762x51mm/silver
	name = "7.62x51mm silver bullet"

/obj/projectile/beam/beam_rifle/vampire/vamp762x51mm/silver/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)

		M.apply_damage(20, CLONE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/projectile/beam/beam_rifle/vampire/vamp12g/silver
	name = "12g silver buck"

/obj/projectile/beam/beam_rifle/vampire/vamp12g/silver/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iswerewolf(target) || isgarou(target))
		var/mob/living/carbon/M = target
		if(M.auspice.gnosis)
			if(prob(50))
				adjust_gnosis(-1, M)

		M.apply_damage(20, CLONE)
		M.apply_status_effect(STATUS_EFFECT_SILVER_SLOWDOWN)

/obj/item/ammo_casing/vampire/c9mm/silver
	name = "9mm silver bullet casing"
	desc = "A 9mm silver bullet casing."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp9mm/silver
	icon_state = "9"
	base_iconstate = "9"

/obj/item/ammo_casing/vampire/c762x51mm/silver
	name = "7.62x51mm silver bullet casing"
	desc = "A 762x51mm silver bullet casing."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp762x51mm/silver
	icon_state = "s762"
	base_iconstate = "s762"

/obj/item/ammo_casing/vampire/c45acp/silver
	name = ".45 ACP silver bullet casing"
	desc = "A .45 ACP silver bullet casing."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp45acp/silver

/obj/item/ammo_casing/vampire/c44/silver
	name = ".44 silver bullet casing"
	desc = "A .44 silver bullet casing."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp44/silver
	icon_state = "44"
	base_iconstate = "44"

/obj/item/ammo_casing/vampire/c556mm/silver
	name = "5.56mm silver bullet casing"
	desc = "A 5.56mm silver bullet casing."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp556mm/silver
	icon_state = "556"
	base_iconstate = "556"

obj/item/ammo_casing/vampire/c545mm/silver
	name = "5.45mm silver bullet casing"
	desc = "a 5.45mm silver bullet casing."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp545mm/silver
	icon_state = "s545"

/obj/item/ammo_casing/vampire/c12g/silver
	name = "12g silver casing"
	desc = "A 12g silver casing."
	projectile_type = /obj/projectile/beam/beam_rifle/vampire/vamp12g/silver
	icon_state = "s12"
	base_iconstate = "s12"

/obj/item/ammo_box/vampire/c9mm/silver
	name = "ammo box (9mm silver)"
	icon_state = "9box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c9mm/silver
	max_ammo = 100

/obj/item/ammo_box/vampire/c45acp/silver
	name = "ammo box (.45 ACP silver)"
	icon_state = "45box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c45acp/silver
	max_ammo = 100

/obj/item/ammo_box/vampire/c44/silver
	name = "ammo box (.44 silver)"
	icon_state = "44box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c44/silver
	max_ammo = 60

/obj/item/ammo_box/vampire/c556/silver
	name = "ammo box (5.56 silver)"
	icon_state = "556box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c556mm/silver
	max_ammo = 60

/obj/item/ammo_box/vampire/c545/silver
	name = "ammo box (5.45 silver)"
	icon_state = "545box_silver"
	ammo_type = /obj/item/ammo_casing/vampire/c545mm/silver
	max_ammo = 60

/obj/item/ammo_box/vampire/c762x51mm/silver
	name = "ammo box (7.62x51mm silver)"
	icon_state = "762box-silver"
	ammo_type = /obj/item/ammo_casing/vampire/c762x51mm/silver
	max_ammo = 40

/obj/item/ammo_box/vampire/c12g/silver
	name = "ammo box (12g slug silver)"
	icon_state = "s12box-buck"
	ammo_type = /obj/item/ammo_casing/vampire/c12g/silver
	max_ammo = 30
