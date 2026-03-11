/mob/living/carbon/human/npc
	var/datum/action/blood_heal_action
	var/list/untargeted_disciplines = list()
	var/list/targeted_disciplines = list()
	var/datum/action/discipline/activated_action //mostly for debugging purposes, this stores the npc's last activated discipline action

/mob/living/carbon/human/npc/sabbat/shovelhead
	name = "Shovelhead"
	hostile = TRUE
	fights_anyway = TRUE
	old_movement = TRUE //dont start pathing down the sidewalk
	var/list/possible_clan = null
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
	make_shovelhead(possible_clan)

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

/mob/living/carbon/human/npc/death(gibbed)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		dust(TRUE)

/mob/living/carbon/human/npc/torpor(source)
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		dust(TRUE)
		return
	return ..()
//============================================================

/mob/living/carbon/human/npc/proc/make_shovelhead(clan)
	set_species(/datum/species/kindred)
	var/list/sabbat_clans = list(/datum/vampire_clan/toreador, /datum/vampire_clan/brujah, /datum/vampire_clan/malkavian, /datum/vampire_clan/gangrel)
	var/chosen_clan = clan ? pick(clan) : pick(sabbat_clans)
	real_name = pick("Shovelhead","Mass-embraced Lunatic", "Reanimated Psycho")
	name = real_name
	dna.real_name = real_name
	var/datum/vampire_clan/random_clan = new chosen_clan()
	var/datum/species/kindred/species = dna.species
	species.clan = random_clan
	create_disciplines(FALSE, random_clan.clan_disciplines)
	generation = 12
	ADD_TRAIT(src, TRAIT_MESSY_EATER, "sabbat_shovelhead")
	ADD_TRAIT(src, TRAIT_SABBATIST, "sabbat_shovelhead")
	is_criminal = TRUE
	storyteller_stat_holder.randomize_abilities()
	st_set_stat(STAT_STAMINA, pick(5,10))
	st_set_stat(STAT_STRENGTH, pick(3,5))
	st_set_stat(STAT_DEXTERITY, pick(3,5))
	st_set_stat(STAT_BRAWL, pick(3,5))
	can_be_spooked = FALSE // not afraid of blood anymore, are we fledgeling?
	qdel(GetComponent(/datum/component/violation_observer)) // so they wont masq violate people

/mob/living/carbon/human/toggle_resting()
	..()
	update_shadow()

/mob/living/carbon/human/npc/attack_hand(mob/living/attacker)
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return ..()
	if(!attacker || is_sabbatist(attacker))
		return ..()
	for(var/mob/living/carbon/human/npc/nearby_npc in oviewers(7, src))
		if(HAS_TRAIT(nearby_npc, TRAIT_SABBATIST))
			nearby_npc.Aggro(attacker) // GET EM BOYS
	Aggro(attacker, TRUE)
	..()

/mob/living/carbon/human/npc/on_hit(obj/projectile/P)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	if(!P || !P.firer || is_sabbatist(P.firer))
		return
	for(var/mob/living/carbon/human/npc/nearby_npc in oviewers(7, src))
		if(HAS_TRAIT(nearby_npc, TRAIT_SABBATIST))
			nearby_npc.Aggro(P.firer)
	Aggro(P.firer, TRUE)

/mob/living/carbon/human/npc/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	if(is_sabbatist(throwingdatum?.thrower))
		return
	if(throwingdatum?.thrower && (AM.throwforce > 5 || (AM.throwforce && src.health < src.maxHealth)))
		Aggro(throwingdatum.thrower, TRUE)

/mob/living/carbon/human/npc/attackby(obj/item/W, mob/living/attacker, params)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	if(!attacker && !is_sabbatist(attacker))
		return
	if(W.force > 5 || (W.force && src.health < src.maxHealth))
		for(var/mob/living/carbon/human/npc/nearby_npc in oviewers(7, src))
			if(HAS_TRAIT(nearby_npc, TRAIT_SABBATIST))
				nearby_npc.Aggro(attacker)
		Aggro(attacker, TRUE)

/mob/living/carbon/human/npc/EmoteAction()
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	return ..()

/mob/living/carbon/human/npc/StareAction()
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	return ..()

/mob/living/carbon/human/npc/SpeechAction()
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	return ..()

/mob/living/carbon/human/npc/ghoulificate(mob/owner)
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		return FALSE
	return ..()

var/list/shovelhead_idle_phrases = list(
	"Guh...",
	"Ghhhh...",
	"Nnngh...",
	"Hrrrk...",
	"Nhh...",
	"Hhhhh...",
	"My head...",
	"Hurts...",
	"Cold...",
	"Dark...",
	"Hungry...",
	"So hungry...",
	"Can't...",
	"Stop...",
	"No...",
	"Mmmph...",
	"Khhh...",
	"Rrrgh...",
	"Blood...",
	"Need...",
	"Off... get it off...",
	"Ugh...",
	"Hnngh..."
)

var/list/shovelhead_attack_phrases = list(
	"HRRGH!",
	"GHHH!",
	"RAAAAGH!",
	"NNGH!",
	"GRAAAH!",
	"HAAAAH!",
	"GUH!!",
	"KHHHHK!",
	"RRRGH!",
	"HRAAAAK!",
	"GAHHH!",
	"NNNNGH!",
	"GRRR!",
	"HHHK!",
	"RGHK!"
)

/mob/living/carbon/human/npc/Annoy(atom/source)
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	return ..()

/mob/living/carbon/human/npc/Aggro(mob/victim, attacked = FALSE)
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return ..()
	if(CheckMove())
		return
	if(HAS_TRAIT(victim, TRAIT_SABBATIST) || is_sabbatist(victim))
		return
	if(frenzy_target != victim)
		frenzy_target = victim
		RealisticSay(pick(shovelhead_attack_phrases)) //dialogue when we switch targets

/mob/living/carbon/human/npc/proc/try_use_discipline(mob/target)
	if(frenzy_target)
		frenzy_target = target
	else if(!target)
		return
	if(can_see(src, target, 7) && (bloodpool > 2))
		if(prob(50) && length(untargeted_disciplines))
			activated_action = pick(untargeted_disciplines)
			if(activated_action)
				activated_action.Trigger()
				visible_message(span_warning("[src] uses [activated_action.discipline.name]!"))
		else if(length(targeted_disciplines) > 0)
			activated_action = pick(targeted_disciplines)
			var/datum/discipline_power/queued_power = activated_action.discipline.current_power
			if(activated_action && queued_power.can_activate(target, FALSE))
				activated_action.targeting = TRUE
				activated_action.handle_click(src, target)
				visible_message(span_warning("[src] uses [activated_action.discipline.name]!"))

/mob/living/carbon/human/npc/handle_automated_movement()
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return ..()
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
		visible_message(span_warning("[src]'s wounds heal with unnatural speed!"))
	if(!frenzy_target)
		return
	if(prob(50))
		try_use_discipline(frenzy_target)

/mob/living/carbon/human/npc/ChoosePath()
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return ..()
	return

/mob/living/carbon/human/npc/canBeHandcuffed()
	if(HAS_TRAIT(src, TRAIT_SABBATIST))
		return FALSE
	return ..()

/mob/living/carbon/human/npc/Life()
	if(stat == DEAD)
		return
	..()
	if(!HAS_TRAIT(src, TRAIT_SABBATIST))
		return
	if(CheckMove())
		return
	if(!frenzy_target)
		return
	if(prob(5))
		RealisticSay(pick(shovelhead_idle_phrases))
