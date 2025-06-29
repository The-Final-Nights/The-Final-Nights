/mob/living/carbon/human/npc/sabbat/shovelhead
	name = "Shovelhead"
	hostile = TRUE
	fights_anyway = TRUE
	old_movement = TRUE //dont start pathing down the sidewalk
	var/datum/action/blood_heal_action
	var/list/untargeted_disciplines = list()
	var/list/targeted_disciplines = list()
	var/list/possible_clan = list(/datum/vampire_clan/toreador, /datum/vampire_clan/brujah, /datum/vampire_clan/malkavian, /datum/vampire_clan/gangrel)
	var/datum/action/discipline/activated_action //mostly for debugging purposes, this stores the npc's last activated discipline action
//============================================================
// subtypes of shovelhead, each with a different clan
/mob/living/carbon/human/npc/sabbat/shovelhead/toreador
	possible_clan = list(/datum/vampire_clan/toreador)
/mob/living/carbon/human/npc/sabbat/shovelhead/brujah
	possible_clan = list(/datum/vampire_clan/brujah)
/mob/living/carbon/human/npc/sabbat/shovelhead/malkavian
	possible_clan = list(/datum/vampire_clan/malkavian)
/mob/living/carbon/human/npc/sabbat/shovelhead/gangrel
	possible_clan = list(/datum/vampire_clan/gangrel)
//============================================================

/mob/living/carbon/human/npc/sabbat/shovelhead/LateInitialize()
	. = ..()
	//assign their special stuff. species, clan, etc
	set_species(/datum/species/kindred)
	var/random_clan = pick(possible_clan)
	clan = new random_clan()
	create_disciplines(FALSE, clan.clan_disciplines)
	generation = 12
	ADD_TRAIT(src, TRAIT_MESSY_EATER, "sabbat_shovelhead")
	is_criminal = TRUE

	//dress them, name them
	AssignSocialRole(pick(/datum/socialrole/usualmale, /datum/socialrole/usualfemale))

	AddElement(/datum/element/point_of_interest)

	//store actions to use later based on what we rolled for disciplines
	for(var/datum/action/discipline/action in actions)
		if(action.discipline.name == "Bloodheal")
			blood_heal_action = action
			continue // we don't want to add this to the targeted/untargeted lists
		else if(action.discipline.name == "Auspex")
			continue // or this. everything else should be OK
		var/datum/discipline_power/power = action.discipline.current_power
		if(power.target_type == NONE) //build our list of targeted and untargeted disciplines
			untargeted_disciplines += action
		else
			targeted_disciplines += action

	//bloody their clothes
	if(wear_mask)
		wear_mask.add_mob_blood(src)
		update_inv_wear_mask()
	if(head)
		head.add_mob_blood(src)
		update_inv_head()
	if(wear_suit)
		wear_suit.add_mob_blood(src)
		update_inv_wear_suit()
	if(w_uniform)
		w_uniform.add_mob_blood(src)
		update_inv_w_uniform()

/mob/living/carbon/human/npc/sabbat/shovelhead/death(gibbed)
	. = ..()
	dust(TRUE)

/mob/living/carbon/human/npc/sabbat/shovelhead/torpor(source)
	dust(TRUE)
//============================================================
/mob/living/carbon/human/npc/sabbat/shovelhead/AssignSocialRole(datum/socialrole/S, var/dont_random = FALSE)
	. = ..()
	real_name = pick("Shovelhead","Mass-embraced Lunatic", "Reanimated Psycho")
	name = real_name
	dna.real_name = real_name

/mob/living/carbon/human/toggle_resting()
	..()
	update_shadow()

/mob/living/carbon/human/npc/sabbat/shovelhead/attack_hand(mob/living/attacker)
	if(!attacker)
		return
	for(var/mob/living/carbon/human/npc/sabbat/shovelhead/NEPIC in oviewers(7, src))
		NEPIC.Aggro(attacker)
	Aggro(attacker, TRUE)
	..()

/mob/living/carbon/human/npc/sabbat/shovelhead/on_hit(obj/projectile/P)
	. = ..()
	if(!P || !P.firer)
		return
	for(var/mob/living/carbon/human/npc/sabbat/shovelhead/NEPIC in oviewers(7, src))
		NEPIC.Aggro(P.firer)
	Aggro(P.firer, TRUE)

/mob/living/carbon/human/npc/sabbat/shovelhead/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	. = ..()
	if(throwingdatum?.thrower && (AM.throwforce > 5 || (AM.throwforce && src.health < src.maxHealth)))
		Aggro(throwingdatum.thrower, TRUE)

/mob/living/carbon/human/npc/sabbat/shovelhead/attackby(obj/item/W, mob/living/attacker, params)
	. = ..()
	if(!attacker)
		return
	if(W.force > 5 || (W.force && src.health < src.maxHealth))
		for(var/mob/living/carbon/human/npc/sabbat/shovelhead/NEPIC in oviewers(7, src))
			NEPIC.Aggro(attacker)
		Aggro(attacker, TRUE)

/mob/living/carbon/human/npc/sabbat/shovelhead/EmoteAction()
	return

/mob/living/carbon/human/npc/sabbat/shovelhead/StareAction()
	return

/mob/living/carbon/human/npc/sabbat/shovelhead/SpeechAction()
	return

/mob/living/carbon/human/npc/sabbat/shovelhead/ghoulificate(mob/owner)
	return FALSE

var/list/shovelhead_idle_phrases = list(
	"A memory... almost... gone...",
	"Alone... so... alone...",
	"Am I... dreaming?",
	"Can anyone... hear me?",
	"Can't... feel my... hands...",
	"Can't... move...",
	"Can't... remember... my name...",
	"Can't... wake up...",
	"Did I... have a family?",
	"Don't... leave me... here...",
	"End this... please...",
	"Everything... hurts...",
	"Everything... is fading...",
	"Feels like... I'm falling...",
	"Get it... off...",
	"Get me... out...",
	"Help me...",
	"Help me... please...",
	"I can hear... the worms...",
	"I can taste... the dirt...",
	"I don't... want to be this...",
	"I don't... want to die...",
	"I feel... hollow...",
	"I remember... sunshine...",
	"I was... someone...",
	"I'm... still here...",
	"I'm... so afraid...",
	"I'm... so alone...",
	"I'm sorry... for what I am...",
	"Is this... forever?",
	"It's so... dark...",
	"It's so... quiet...",
	"It's still... in me...",
	"Just... let it... end...",
	"Just... one more... sunrise...",
	"Let me... go...",
	"Make it... stop...",
	"Momma...?",
	"My bones... ache...",
	"Please...",
	"Please... kill me...",
	"So... cold...",
	"So... heavy...",
	"Someone... help...",
	"Something... is wrong...",
	"Something... is wearing my skin...",
	"Stay... with me...",
	"The ground... is so cold...",
	"This can't be... real...",
	"This isn't... me...",
	"Trapped...",
	"Was I... good?",
	"What... happened to me?",
	"What have I... become?",
	"Where... am I?",
	"Where is... everyone?",
	"Who... was I?",
	"Why... can't I cry?",
	"Why... is it so dark?"
)

var/list/shovelhead_attack_phrases = list(
	"A little... just a little!",
	"Blood...",
	"Blood... I need blood!",
	"Don't... be afraid...",
	"Don't... fight...",
	"Don't... make me!",
	"Don't hate... me...",
	"Forgive... me...",
	"Get out... of my head!",
	"Give it... to me!",
	"Give me... your blood!",
	"Hold... still!",
	"I can... smell your heart...",
	"I can't... stop it!",
	"I have to...",
	"I hate this... I hate it!",
	"I'm... so... sorry...",
	"I'm not... in control!",
	"It... hurts...",
	"It makes... the pain stop...",
	"It told me... to...",
	"It's the only... way...",
	"Just... a taste...",
	"Let me... have it!",
	"Make it... stop!",
	"Mine!",
	"More...",
	"Must... obey...",
	"No choice...",
	"Not... enough!",
	"Ow...",
	"Please... run...",
	"Run... while you can!",
	"So... hungry...",
	"So... HUNGRY!!",
	"So... warm...",
	"Stay... away!",
	"Stop... it hurts!",
	"Stop... moving!",
	"The hunger... it burns!",
	"This will... only hurt a moment...",
	"This hunger... it's everything...",
	"Warm...",
	"Warm... blood...",
	"Why...?",
	"Why are you... hurting me?",
	"Why did you... come here?",
	"Why me...?",
	"You can... spare some...",
	"You have so... much...",
	"You shouldn't... be here!",
	"Your fault... you're warm!",
	"Your life... so bright..."
)

/mob/living/carbon/human/npc/sabbat/shovelhead/Annoy(atom/source)
	return

/mob/living/carbon/human/npc/sabbat/shovelhead/Aggro(mob/victim, attacked = FALSE)
	if(CheckMove())
		return
	if (istype(victim, /mob/living/carbon/human/npc/sabbat))
		return
	if(frenzy_target != victim)
		frenzy_target = victim
		RealisticSay(pick(shovelhead_attack_phrases)) //dialogue when we switch targets

/mob/living/carbon/human/npc/sabbat/shovelhead/proc/try_use_discipline(mob/target)
	if(frenzy_target)
		frenzy_target = target
	else if(!target)
		return
	if(can_see(src, target, 7) && (bloodpool > 2))
		if(prob(50))
			activated_action = pick(untargeted_disciplines)
			if(activated_action)
				activated_action.Trigger()
				visible_message(
					span_warning("[src] uses [activated_action.discipline.name]!"),
					span_warning("You use [activated_action.discipline.name]!")
				)
		else if(length(targeted_disciplines) > 0)
			activated_action = pick(targeted_disciplines)
			var/datum/discipline_power/queued_power = activated_action.discipline.current_power
			if(activated_action && queued_power.can_activate(target, FALSE))
				activated_action.targeting = TRUE
				activated_action.handle_click(src, target)
				visible_message(
					span_warning("[src] uses [activated_action.discipline.name]!"),
					span_warning("You use [activated_action.discipline.name]!")
				)

/mob/living/carbon/human/npc/sabbat/shovelhead/handle_automated_movement()
	if(CheckMove())
		return
	if(!isturf(loc))
		return
	if(client)
		return
	if(!in_frenzy)
		bloodpool = 5
		enter_frenzymod()
	if(prob(75) && (getBruteLoss() + getFireLoss() >= 60) && (bloodpool > 2))
		blood_heal_action.Trigger() //we are wounded, heal ourselves if we can
		visible_message(
		span_warning("[src]'s wounds heal with unnatural speed!"),
		span_warning("Your wounds visibly heal with unnatural speed!")
		)
	if(!frenzy_target)
		return
	if(prob(50))
		try_use_discipline(frenzy_target)

/mob/living/carbon/human/npc/sabbat/shovelhead/ChoosePath()
	return

/mob/living/carbon/human/npc/sabbat/shovelhead/canBeHandcuffed()
	return FALSE

/mob/living/carbon/human/npc/sabbat/shovelhead/Life()
	if(stat == DEAD)
		return
	..()
	if(CheckMove())
		return
	if(!frenzy_target)
		return
	if(prob(5))
		RealisticSay(pick(shovelhead_idle_phrases))
