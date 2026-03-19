// **************************************************************** flameskull *************************************************************

/obj/necrorune/flameskull
	name = "Ammorsus Vicarius"
	desc = "Create a floating skull to do thy bidding.."
	icon_state = "rune3"
	word = "OR-IRI O FLAM-MEUM CERE-BRUM"
	necrolevel = 3
	sacrifices = list(/obj/item/corspestore/skull)
	var/duration_length = 10 SECONDS

/obj/necrorune/flameskull/complete()
	var/mob/living/carbon/human/H = last_activator
	if(!length(H.beastmaster))
		var/datum/action/beastmaster_stay/E1 = new()
		E1.Grant(last_activator)
		var/datum/action/beastmaster_deaggro/E2 = new()
		E2.Grant(last_activator)
	var/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/flamingskull/BG = new(loc)
	BG.beastmaster_owner = last_activator
	H.beastmaster |= BG
	BG.my_creator = last_activator
	BG.melee_damage_lower = BG.melee_damage_lower+activator_bonus
	BG.melee_damage_upper = BG.melee_damage_upper+activator_bonus
	playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)
	if(length(H.beastmaster) > H.st_get_stat(STAT_OCCULT))
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(H.beastmaster)
		B.death()
	qdel(src)

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/flamingskull
	name = "floating skull"
	desc = "A skull with burning red eyes and rotting flesh draping its cranium."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "legion_head"
	icon_living = "legion_head"
	del_on_death = 1
	healable = 0
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	can_be_held = TRUE
	density = FALSE
	anchored = FALSE
	speed = 0
	maxHealth = 30
	health = 30

	harm_intent_damage = 5
	obj_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "bites"
	attack_verb_simple = "chomps"
	attack_sound = 'sound/weapons/pierce.ogg'
	speak_emote = list("gnashes")

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	bloodpool = 1
	maxbloodpool = 1
