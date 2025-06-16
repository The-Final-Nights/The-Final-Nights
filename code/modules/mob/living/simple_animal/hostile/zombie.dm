/mob/living/simple_animal/hostile/zombie
	name = "Shambling Corpse"
	desc = "When there is no more room in Hell, the dead will walk on Earth."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "zombie"
	icon_living = "zombie"
	mob_biotypes = MOB_UNDEAD
	speak_chance = 0
	stat_attack = HARD_CRIT //braains
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	melee_damage_lower = 21
	melee_damage_upper = 21
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/zombuzi.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	status_flags = CANPUSH
	del_on_death = 1
	bloodpool = 0
	maxbloodpool = 0
	speed = 1
	AIStatus = AI_OFF
	var/mob/living/target_to_zombebe

/mob/living/simple_animal/hostile/zombie/Destroy()
	. = ..()
	SSgraveyard.alive_zombies = max(0, SSgraveyard.alive_zombies-1)
	GLOB.zombie_list -= src

/mob/living/simple_animal/hostile/zombie/Initialize()
	. = ..()
	GLOB.zombie_list += src

/mob/living/simple_animal/hostile/zombie/proc/handle_automated_patriotification()
	if(target_to_zombebe)
		if(get_dist(src, target_to_zombebe) > 7)
			target_to_zombebe = null
		else
			var/totalshit = 1
			if(total_multiplicative_slowdown() > 0)
				totalshit = total_multiplicative_slowdown()

			var/reqsteps = round((SSzombiepool.next_fire-world.time)/totalshit)
			walk_to(src, target_to_zombebe, reqsteps+1, total_multiplicative_slowdown())
			if(get_dist(src, target_to_zombebe) <= 1)
				ClickOn(target_to_zombebe)
			//code to attack pepol
	else
		//code to find target
		for(var/mob/living/L in oviewers(6, src))
			if(!iszomboid(L))
				target_to_zombebe = L
		//else, if we have no target :((( NO ONE TO BITE... BRAAAAAAAAAHH(ins)... FUCK IM LOOKING FOR GATE TO BRRRRRRR
		if(!target_to_zombebe)
			if(GLOB.vampgate)
				var/obj/structure/vampgate/V = GLOB.vampgate
				if(get_area(V) == get_area(src))
					var/totalshit = 1
					if(total_multiplicative_slowdown() > 0)
						totalshit = total_multiplicative_slowdown()
					var/reqsteps = round((SSzombiepool.next_fire-world.time)/totalshit)
					walk_to(src, V, reqsteps, total_multiplicative_slowdown())
					if(get_dist(V, src) <= 1)
						if(!V.density)
							if(prob(20))
								for(var/mob/living/carbon/human/L in GLOB.player_list)
									if(L)
										if(L.mind)
											if(L.mind.assigned_role == "Graveyard Keeper")
												if(L.client)
													if(istype(get_area(L), /area/vtm/graveyard))
														L.AdjustMasquerade(-1)
														SSgraveyard.total_bad += 1
								qdel(src)
						else
							V.punched()
							do_attack_animation(V)

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie
	name = "Shambling Corpse"
	desc = "When there is no more room in hell, the dead will walk on Earth."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "zombie"
	icon_living = "zombie"
	icon_dead = "zombie_dead"
	mob_biotypes = MOB_UNDEAD
	speak_chance = 0
	stat_attack = HARD_CRIT //braains
	maxHealth = 35 //Threshold to be killed by one sword hit, as it used to.
	health = 35
	speed = 1
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	status_flags = CANPUSH
	faction = list(CLAN_GIOVANNI)
	bloodpool = 0
	maxbloodpool = 0

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level1 //Low health, low damage distraction unit.
	name = "drone"
	desc = "A mindless, tormented wraith."
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	icon_living = "ghost"
	mob_biotypes = MOB_UNDEAD
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	a_intent = INTENT_HARM
	healable = 0
	speed = 2
	maxHealth = 60
	health = 60
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15  // Keep in mind most characters will take up to half less damage from such mobs due to brutemods.
	del_on_death = 1
	emote_see = list("weeps silently", "groans", "mumbles")
	attack_verb_continuous = "grips"
	attack_verb_simple = "grip"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	speak_emote = list("weeps")
	deathmessage = "wails, disintegrating into a pile of ectoplasm!"
	loot = list(/obj/item/ectoplasm)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	is_flying_animal = TRUE
	light_system = MOVABLE_LIGHT
	light_range = 1 // same glowing as visible player ghosts
	light_power = 2

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level2 //Fragile, low-damage harrass, rat equivalent. This and onward are dot5 summons. Maxhealth to summon: under 20
	name = "parassita"
	desc = "A skittering something of a myriad digits and small, sharp teeth."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "ratzombie"
	icon_living = "ratzombie"
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "shoos away"
	response_help_simple = "shoo away"
	response_disarm_continuous = "knocks aside"
	response_disarm_simple = "knock aside"
	response_harm_continuous = "stamps"
	response_harm_simple = "stamp"
	can_be_held = TRUE
	density = FALSE
	anchored = FALSE
	footstep_type = FOOTSTEP_MOB_CLAW
	a_intent = INTENT_HARM
	speed = 0
	maxHealth = 20
	health = 20
	harm_intent_damage = 10
	melee_damage_lower = 8
	melee_damage_upper = 14
	emote_see = list("chitters menacingly", "rubs its digit-limbs together", "squeaks")
	attack_verb_continuous = "nibbles"
	attack_verb_simple = "nibble"
	attack_sound = 'code/modules/wod13/sounds/rat.ogg'
	speak_emote = list("squeaks")
	deathmessage = "rapidly shrivels up!"

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level2/Initialize()
	. = ..()
	pixel_w = rand(-8, 8)
	pixel_z = rand(-8, 8)

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level3 //Middling dog-level threat. Maxhealth to summon: 20 to 70
	name = "compagno"
	desc = "Four legs and a menacing set of jaws is all this shambling thing shares with a canine."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "dogzombie"
	icon_living = "dogzombie"
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "drags aside"
	response_disarm_simple = "drag aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	footstep_type = FOOTSTEP_MOB_CLAW
	a_intent = INTENT_HARM
	speed = 0
	maxHealth = 80 //Two attacks with a dedicated melee weapon or 4 9mm bullets
	health = 80
	harm_intent_damage = 15
	melee_damage_lower = 20
	melee_damage_upper = 30
	emote_see = list("snarls", "dribbles with saliva", "wheezes")
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'code/modules/wod13/sounds/dog.ogg'
	speak_emote = list("borks")
	deathmessage = "falls apart in a pile of fur and bones!"

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level4 //Tanky, but slowed bruiser. Maxhealth to summon: 70 to 150
	name = "verme"
	desc = "Husk of a man, puppeteered by some sadistic force."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "manzombie"
	icon_living = "manzombie"
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "shakes hands with"
	response_help_simple = "shake hands with"
	response_disarm_continuous = "pushes away"
	response_disarm_simple = "push away"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	a_intent = INTENT_HARM
	speed = 1.5 //the tankier, the slower
	maxHealth = 120 //three attacks with a dedicated melee weapon or 6 9mm bullets
	health = 120
	harm_intent_damage = 15
	melee_damage_lower = 25
	melee_damage_upper = 35
	emote_see = list("shambles", "stumbles in place", "groans")
	attack_verb_continuous = "batters"
	attack_verb_simple = "batter"
	attack_sound = 'code/modules/wod13/sounds/zombuzi.ogg'
	speak_emote = list("rasps")
	deathmessage = "decays away into fine paste!"

/mob/living/simple_animal/hostile/beastmaster/giovanni_zombie/level5  //Chonkmaster, only really Tzimisce mobs can provide material for this. Maxhealth to summon: 150 and onward
	name = "patrigno"
	desc = "A nauseauting mountain of putrid flesh. On its face - a jolly smirk immortalized with rigor mortis."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "fatzombie"
	icon_living = "fatzombie"
	speak_chance = 1
	turns_per_move = 5
	response_help_continuous = "pats down"
	response_help_simple = "pat down"
	response_disarm_continuous = "tries to push"
	response_disarm_simple = "try to push"
	response_harm_continuous = "slaps"
	response_harm_simple = "slap"
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	a_intent = INTENT_HARM
	speed = 3 //really slow
	maxHealth = 300 //six attacks with a dedicated melee weapon or 15 9mm bullets
	health = 300
	harm_intent_damage = 5
	melee_damage_lower = 40
	melee_damage_upper = 50
	emote_see = list("snorts", "guffaws", "gurgles")
	attack_verb_continuous = "slams into"
	attack_verb_simple = "slam into"
	attack_sound = 'code/modules/wod13/sounds/heavypunch.ogg'
	speak_emote = list("gurgles")
	deathmessage = "collapses down into a rancid puddle!"

/mob/living/simple_animal/hostile/giovanni_zombie/proc/give_player()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as summoned ghost?", null, null, null, 50, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, "<span class='ghostalert'>Someone is summoning a ghost!</span>")
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		name = C.name
		key = C.key
		visible_message("<span class='danger'>[src] rises with fresh soul!</span>")
		return TRUE
	visible_message("<span class='warning'>[src] remains unsouled...</span>")
	return FALSE
