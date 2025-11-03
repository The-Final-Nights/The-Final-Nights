

/mob/living/simple_animal/hostile/shapeshift //Only used for Shapeshifting
	speed = -0.50
	maxHealth = 200
	health = 200
	harm_intent_damage = 20
	melee_damage_lower = 24
	melee_damage_upper = 30
	melee_damage_type = CLONE
	damage_coeff = list(BRUTE = 0.5, BURN = 2, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 0)
	name = "dog"
	desc = "Woof-woof."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "dog"
	icon_living = "dog"
	icon_dead = "dog_dead"
	del_on_death = 1
	footstep_type = FOOTSTEP_MOB_CLAW
	mob_biotypes = MOB_ORGANIC
	speak_chance = 0
	turns_per_move = 1
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/dog.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	bloodpool = 2
	maxbloodpool = 2
	loot = list()
	AIStatus = AI_OFF

/mob/living/simple_animal/hostile/shapeshift/dog
	name = "Black Dog"
	desc = "Woof."
	icon = 'code/modules/wod13/werewolf_lupus.dmi'
	icon_state = "black"
	icon_living = "black"
	icon_dead = "black_rest"

/mob/living/simple_animal/hostile/shapeshift/dog/gray
	name = "Grey Dog"
	desc = "Standing strong despite its age."
	icon_state = "gray"
	icon_living = "gray"
	icon_dead = "gray_rest"

/mob/living/simple_animal/hostile/shapeshift/dog/red
	name = "Red Dog"
	desc = "You feel like it wants to be collared."
	icon_state = "red"
	icon_living = "red"
	icon_dead = "red_rest"

/mob/living/simple_animal/hostile/shapeshift/dog/white
	name = "Albino Dog"
	desc = "Fur sleek as snow."
	icon_state = "white"
	icon_living = "white"
	icon_dead = "white_rest"

/mob/living/simple_animal/hostile/shapeshift/dog/ginger
	name = "Ginger Dog"
	desc = "You see no souls in its eyes."
	icon_state = "ginger"
	icon_living = "ginger"
	icon_dead = "ginger_rest"

/mob/living/simple_animal/hostile/shapeshift/dog/brown
	name = "Brown Wolf"
	desc = "Howling and Snarling."
	icon_state = "brown"
	icon_living = "brown"
	icon_dead = "brown_rest"


/mob/living/simple_animal/hostile/shapeshift/wolf
	name = "Black Wolf"
	desc = "Howling and Snarling."
	icon = 'code/modules/wod13/tfn_lupus.dmi'
	icon_state = "black"
	icon_living = "black"
	icon_dead = "black_rest"

/mob/living/simple_animal/hostile/shapeshift/wolf/gray
	name = "Gray Wolf"
	desc = "Howling and Snarling."
	icon_state = "gray"
	icon_living = "gray"
	icon_dead = "gray_rest"

/mob/living/simple_animal/hostile/shapeshift/wolf/red
	name = "Red Wolf"
	desc = "Howling and Snarling."
	icon_state = "red"
	icon_living = "red"
	icon_dead = "red_rest"

/mob/living/simple_animal/hostile/shapeshift/wolf/white
	name = "White Wolf"
	desc = "The Most Malicious Wolf."
	icon_state = "white"
	icon_living = "white"
	icon_dead = "white_rest"

/mob/living/simple_animal/hostile/shapeshift/wolf/ginger
	name = "Ginger Wolf"
	desc = "You see no souls in its eyes."
	icon_state = "ginger"
	icon_living = "ginger"
	icon_dead = "ginger_rest"

/mob/living/simple_animal/hostile/shapeshift/wolf/brown
	name = "Brown Wolf"
	desc = "Howling and Snarling."
	icon_state = "brown"
	icon_living = "brown"
	icon_dead = "brown_rest"

/datum/action/fly_toggle
	name = "Fly"
	desc = "Take to the skies or land on the ground."
	button_icon_state = "fly"  // Change to appropriate icon
	button_icon = 'code/modules/wod13/UI/actions.dmi'
	background_icon_state = "gift"
	icon_icon = 'icons/hud/actions.dmi'
	check_flags = AB_CHECK_CONSCIOUS
	var/is_flying = FALSE

/datum/action/fly_toggle/Trigger(trigger_flags)
	. = ..()
	if(!isliving(owner))
		return

	var/mob/living/simple_animal/hostile/shapeshift/bird/flying/bird = owner
	if(!istype(bird))
		return

	if(is_flying)
		// Land
		REMOVE_TRAIT(bird, TRAIT_MOVE_FLYING, MAGIC_TRAIT)
		bird.icon_state = bird.icon_living
		bird.update_appearance()
		is_flying = FALSE
		name = "Fly"
		desc = "Take to the skies."
		to_chat(bird, span_notice("You land on the ground."))
	else
		// Take off
		ADD_TRAIT(bird, TRAIT_MOVE_FLYING, MAGIC_TRAIT)
		var/flying_state = "[bird.icon_living]_flying"
		bird.icon_state = flying_state
		bird.update_appearance()
		is_flying = TRUE
		name = "Land"
		desc = "Return to the ground."
		to_chat(bird, span_notice("You take flight!"))

/mob/living/simple_animal/hostile/shapeshift/bird/flying/Initialize()
	. = ..()
	var/datum/action/fly_toggle/fly_action = new(src)
	fly_action.Grant(src)

/mob/living/simple_animal/hostile/shapeshift/bird/flying/Destroy()
	for(var/datum/action/fly_toggle/fly_action in actions)
		fly_action.Remove(src)
	return ..()

/mob/living/simple_animal/hostile/shapeshift/bird/flying
	name = "A bird"
	desc = "It's a bird. First time seeing one?"
	icon = 'code/modules/wod13/corax_corvid.dmi'
	icon_state = "brown"
	icon_living = "brown"
	icon_dead = "brown_rest"
	speed = -0.8
	attack_sound = 'code/modules/wod13/sounds/werewolf_bite.ogg'

/mob/living/simple_animal/hostile/shapeshift/bird/flying/black
	name = "A black bird"
	desc = "Nevermore."
	icon_state = "black"
	icon_living = "black"
	icon_dead = "black_rest"

/mob/living/simple_animal/hostile/shapeshift/bird/flying/white
	name = "A white bird"
	desc = "No, it's not a dove."
	icon_state = "white"
	icon_living = "white"
	icon_dead = "white_rest"

/mob/living/simple_animal/hostile/shapeshift/bird/flying/gray
	name = "A gray bird"
	desc = "At first glance, it looks like a pigeon..."
	icon_state = "gray"
	icon_living = "gray"
	icon_dead = "gray_rest"

/mob/living/simple_animal/hostile/shapeshift/bird/flying/red
	name = "A red bird"
	desc = "A cardinal! No wait..."
	icon_state = "red"
	icon_living = "red"
	icon_dead = "red_rest"

/mob/living/simple_animal/hostile/shapeshift/cat
	name = "black cat"

	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "cat1"
	icon_living = "cat1"
	icon_dead = "cat1_dead"
	attack_sound = 'code/modules/wod13/sounds/cat.ogg'

/mob/living/simple_animal/hostile/shapeshift/cat/gray
	name = "gray cat"
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"

/mob/living/simple_animal/hostile/shapeshift/cat/brown
	name = "brown cat"
	icon_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"

/mob/living/simple_animal/hostile/shapeshift/cat/white
	name = "white cat"
	icon_state = "cat4"
	icon_living = "cat4"
	icon_dead = "cat4_dead"

/mob/living/simple_animal/hostile/shapeshift/cat/browntabby
	name = "brown tabby cat"
	icon_state = "cat5"
	icon_living = "cat5"
	icon_dead = "cat5_dead"

/mob/living/simple_animal/hostile/shapeshift/cat/graytabby
	name = "gray tabby cat"
	icon_state = "cat6"
	icon_living = "cat6"
	icon_dead = "cat6_dead"

/mob/living/simple_animal/hostile/shapeshift/cat/blacktabby
	name = "black tabby cat"
	icon_state = "cat7"
	icon_living = "cat7"
	icon_dead = "cat7_dead"
