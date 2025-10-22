/mob/living/simple_animal/hostile/bear/wod13
	name = "bear"
	desc = "IS THAT A FUCKING BEAR-"
	icon = 'code/modules/wod13/64x64.dmi'
	emote_hear = list("roars.")
	emote_see = list("shakes its head.", "stomps.")
	attack_sound = 'code/modules/wod13/sounds/werewolf_bite.ogg'
	butcher_results = list(/obj/item/food/meat/slab = 7)
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "gently pushes"
	response_disarm_simple = "gently push"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"


	bloodquality = BLOOD_QUALITY_LOW
	bloodpool = 20
	maxbloodpool = 20
	maxHealth = 850
	health = 850
	cached_multiplicative_slowdown = 2

	melee_damage_lower = 35
	melee_damage_upper = 40 //Good luck lol



/mob/living/simple_animal/hostile/bear/wod13/vampire
	bloodquality = BLOOD_QUALITY_HIGH
	melee_damage_type = CLONE
	damage_coeff = list(BRUTE = 0.5, BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 0)
