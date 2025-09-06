

//removed some keywords as they don't fit mental domination
var/static/regex/stun_words = regex("stop|wait|stand still|hold on|halt|cease")
var/static/regex/knockdown_words = regex("drop|fall|trip|knockdown")
var/static/regex/sleep_words = regex("sleep|slumber|rest")
var/static/regex/vomit_words = regex("vomit|throw up|sick")
var/static/regex/silence_words = regex("shut up|silence|be silent|ssh|quiet|hush")
//var/static/regex/hallucinate_words = regex("see the truth|hallucinate")
var/static/regex/wakeup_words = regex("wake up|awaken")
//var/static/regex/heal_words = regex("live|heal|survive|mend|life|heroes never die")
//var/static/regex/hurt_words = regex("die|suffer|hurt|pain|death")
//var/static/regex/bleed_words = regex("bleed|there will be blood")
//var/static/regex/burn_words = regex("burn|ignite")
//var/static/regex/hot_words = regex("heat|hot|hell")
//var/static/regex/cold_words = regex("cold|cool down|chill|freeze")
var/static/regex/repulse_words = regex("shoo|go away|leave me alone|begone|flee|fus ro dah|get away|repulse")
var/static/regex/attract_words = regex("come here|come to me|get over here|attract")
var/static/regex/whoareyou_words = regex("who are you|say your name|state your name|identify")
var/static/regex/saymyname_words = regex("say my name|who am i|whoami")
var/static/regex/knockknock_words = regex("knock knock")
var/static/regex/move_words = regex("move|walk")
var/static/regex/left_words = regex("left|west|port")
var/static/regex/right_words = regex("right|east|starboard")
var/static/regex/up_words = regex("up|north|fore")
var/static/regex/down_words = regex("down|south|aft")
var/static/regex/walk_words = regex("slow down")
var/static/regex/run_words = regex("run")
var/static/regex/throwmode_words = regex("throw|catch")
var/static/regex/flip_words = regex("flip|rotate|revolve|roll|somersault")
var/static/regex/speak_words = regex("speak|say something")
var/static/regex/getup_words = regex("get up")
var/static/regex/sit_words = regex("sit")
var/static/regex/stand_words = regex("stand")
var/static/regex/dance_words = regex("dance")
var/static/regex/jump_words = regex("jump")
var/static/regex/salute_words = regex("salute")
var/static/regex/deathgasp_words = regex("play dead")
var/static/regex/clap_words = regex("clap|applaud")
var/static/regex/multispin_words = regex("like a record baby|right round")

/proc/apply_voice_of_god_effects(message, mob/living/user, list/listeners, power_multiplier)
	var/cooldown = 0
	var/i = 0

	//STUN
	if(findtext(message, stun_words))
		cooldown = COOLDOWN_STUN
		for(var/V in listeners)
			var/mob/living/L = V
			L.Stun(60 * power_multiplier)

	//KNOCKDOWN
	else if(findtext(message, knockdown_words))
		cooldown = COOLDOWN_STUN
		for(var/V in listeners)
			var/mob/living/L = V
			L.Paralyze(60 * power_multiplier)

	//SLEEP
	else if(findtext(message, sleep_words))
		cooldown = COOLDOWN_STUN
		for(var/mob/living/carbon/C in listeners)
			C.Sleeping(40 * power_multiplier)

	//VOMIT
	else if(findtext(message, vomit_words))
		cooldown = COOLDOWN_STUN
		for(var/mob/living/carbon/C in listeners)
			C.vomit(10 * power_multiplier, distance = power_multiplier)

	//SILENCE
	else if(findtext(message, silence_words))
		cooldown = COOLDOWN_STUN
		for(var/mob/living/carbon/C in listeners)
			if(user.mind && (user.mind.assigned_role == "Curator" || user.mind.assigned_role == "Mime"))
				power_multiplier *= 3
			C.silent += (10 * power_multiplier)

	//HALLUCINATE (commented out)
	/*
	else if(findtext(message, hallucinate_words))
		cooldown = COOLDOWN_MEME
		for(var/mob/living/carbon/C in listeners)
			new /datum/hallucination/delusion(C, TRUE, null, 150 * power_multiplier, 0)
	*/

	//WAKE UP
	else if(findtext(message, wakeup_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			L.SetSleeping(0)

	//HEAL (commented out)
	/*
	else if(findtext(message, heal_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			L.heal_overall_damage(10 * power_multiplier, 10 * power_multiplier)
	*/

	//BRUTE DAMAGE (commented out)
	/*
	else if(findtext(message, hurt_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			L.apply_damage(15 * power_multiplier, def_zone = BODY_ZONE_CHEST, wound_bonus = CANT_WOUND)
	*/

	//BLEED (commented out)
	/*
	else if(findtext(message, bleed_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/mob/living/carbon/human/H in listeners)
			var/obj/item/bodypart/BP = pick(H.bodyparts)
			BP.generic_bleedstacks += 5
	*/

	//FIRE (commented out)
	/*
	else if(findtext(message, burn_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			L.adjust_fire_stacks(1 * power_multiplier)
			L.IgniteMob()
	*/

	//HOT (commented out)
	/*
	else if(findtext(message, hot_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			L.adjust_bodytemperature(50 * power_multiplier)
	*/

	//COLD (commented out)
	/*
	else if(findtext(message, cold_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			L.adjust_bodytemperature(-50 * power_multiplier)
	*/

	//REPULSE
	else if(findtext(message, repulse_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			var/throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(L, user)))
			L.throw_at(throwtarget, 3 * power_multiplier, 1 * power_multiplier)

	//ATTRACT
	else if(findtext(message, attract_words))
		cooldown = COOLDOWN_DAMAGE
		for(var/V in listeners)
			var/mob/living/L = V
			L.throw_at(get_step_towards(user, L), 3 * power_multiplier, 1 * power_multiplier)

	//WHO ARE YOU?
	else if(findtext(message, whoareyou_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/atom/movable, say), L.real_name), 5 * i)
			i++

	//SAY MY NAME
	else if(findtext(message, saymyname_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/atom/movable, say), user.name), 5 * i)
			i++

	//KNOCK KNOCK
	else if(findtext(message, knockknock_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/atom/movable, say), "Who's there?"), 5 * i)
			i++

	//MOVE
	else if(findtext(message, move_words))
		cooldown = COOLDOWN_MEME
		var/direction
		if(findtext(message, up_words))
			direction = NORTH
		else if(findtext(message, down_words))
			direction = SOUTH
		else if(findtext(message, left_words))
			direction = WEST
		else if(findtext(message, right_words))
			direction = EAST
		for(var/iter in 1 to 5 * power_multiplier)
			for(var/V in listeners)
				var/mob/living/L = V
				addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(_step), L, direction ? direction : pick(GLOB.cardinals)), 10 * (iter - 1))

	//WALK
	else if(findtext(message, walk_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			if(L.m_intent != MOVE_INTENT_WALK)
				L.toggle_move_intent()

	//RUN
	else if(findtext(message, run_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			if(L.m_intent != MOVE_INTENT_RUN)
				L.toggle_move_intent()

	//THROW/CATCH
	else if(findtext(message, throwmode_words))
		cooldown = COOLDOWN_MEME
		for(var/mob/living/carbon/C in listeners)
			C.throw_mode_on()

	//FLIP
	else if(findtext(message, flip_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			L.emote("flip")

	//SPEAK
	else if(findtext(message, speak_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/atom/movable, say), pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage")), 5 * i)
			i++

	//GET UP
	else if(findtext(message, getup_words))
		cooldown = COOLDOWN_DAMAGE //because stun removal
		for(var/V in listeners)
			var/mob/living/L = V
			L.set_resting(FALSE)
			L.SetAllImmobility(0)

	//SIT
	else if(findtext(message, sit_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			for(var/obj/structure/chair/chair in get_turf(L))
				chair.buckle_mob(L)
				break

	//STAND UP
	else if(findtext(message, stand_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			if(L.buckled && istype(L.buckled, /obj/structure/chair))
				L.buckled.unbuckle_mob(L)

	//DANCE
	else if(findtext(message, dance_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/, emote), "dance"), 5 * i)
			i++

	//JUMP
	else if(findtext(message, jump_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			if(prob(25))
				addtimer(CALLBACK(L, TYPE_PROC_REF(/atom/movable, say), "HOW HIGH?!!"), 5 * i)
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/, emote), "jump"), 5 * i)
			i++

	//SALUTE
	else if(findtext(message, salute_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/, emote), "salute"), 5 * i)
			i++

	//PLAY DEAD
	else if(findtext(message, deathgasp_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/, emote), "deathgasp"), 5 * i)
			i++

	//PLEASE CLAP
	else if(findtext(message, clap_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/, emote), "clap"), 5 * i)
			i++

	//RIGHT ROUND
	else if(findtext(message, multispin_words))
		cooldown = COOLDOWN_MEME
		for(var/V in listeners)
			var/mob/living/L = V
			L.SpinAnimation(speed = 10, loops = 5)

	else
		cooldown = COOLDOWN_NONE

	return cooldown
