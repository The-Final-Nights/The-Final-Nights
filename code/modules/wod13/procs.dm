/mob/living/carbon/human/proc/AdjustMasquerade(value, forced = FALSE)
	if(!iskindred(src) && !isghoul(src) && !iscathayan(src))
		return
	if(!GLOB.canon_event)
		return
	if (!forced)
		if(value > 0)
			if(HAS_TRAIT(src, TRAIT_VIOLATOR))
				return
		if(!CheckZoneMasquerade(src))
			return
	if(forced || !is_special_character(src))
		if(forced || COOLDOWN_FINISHED(src, last_masquerade_violation))
			COOLDOWN_START(src, last_masquerade_violation, 10 SECONDS)
			if(value < 0)
				if(masquerade > 0)
					masquerade = max(0, masquerade+value)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/masquerade_violation.ogg', 0, 0, 75))
					to_chat(src, "<span class='userdanger'><b>MASQUERADE VIOLATION!</b></span>")
				SSbad_guys_party.next_fire = max(world.time, SSbad_guys_party.next_fire - 2 MINUTES)
			if(value > 0)
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					H.voted_for -= dna.real_name
				if(masquerade < 5)
					masquerade = min(5, masquerade+value)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/general_good.ogg', 0, 0, 75))
					to_chat(src, "<span class='userhelp'><b>MASQUERADE REINFORCED!</b></span>")
				SSbad_guys_party.next_fire = max(world.time, SSbad_guys_party.next_fire + 1 MINUTES)

	if(src in GLOB.masquerade_breakers_list)
		if(masquerade > 2)
			GLOB.masquerade_breakers_list -= src
	else if(masquerade < 3)
		GLOB.masquerade_breakers_list |= src

/mob/living/carbon/human/npc/proc/backinvisible(atom/A)
	switch(dir)
		if(NORTH)
			if(A.y >= y)
				return TRUE
		if(SOUTH)
			if(A.y <= y)
				return TRUE
		if(EAST)
			if(A.x >= x)
				return TRUE
		if(WEST)
			if(A.x <= x)
				return TRUE
	return FALSE

/proc/CheckZoneMasquerade(mob/target)
	if(istype(get_area(target), /area/vtm))
		var/area/vtm/V = get_area(target)
		if(V.zone_type != "masquerade")
			return FALSE
		else
			return TRUE

/mob/living/proc/CheckEyewitness(mob/living/source, mob/attacker, range = 0, affects_source = FALSE)
	var/actual_range = max(1, round(range*(attacker.alpha/255)))
	var/list/seenby = list()
	for(var/mob/living/carbon/human/npc/NPC in oviewers(1, source))
		if(NPC.can_see_masq_breaches())
			if(get_turf(src) != turn(NPC.dir, 180))
				seenby |= NPC
				INVOKE_ASYNC(NPC, TYPE_PROC_REF(/mob/living/carbon/human/npc, Aggro), attacker, FALSE)
	for(var/mob/living/carbon/human/npc/NPC in viewers(actual_range, source))
		if(NPC.can_see_masq_breaches())
			if(affects_source)
				if(NPC == source)
					INVOKE_ASYNC(NPC, TYPE_PROC_REF(/mob/living/carbon/human/npc, Aggro), attacker, TRUE)
					seenby |= NPC
			if(!NPC.pulledby)
				var/turf/LC = get_turf(attacker)
				if(LC.get_lumcount() > 0.25 || get_dist(NPC, attacker) <= 1)
					if(NPC.backinvisible(attacker))
						seenby |= NPC
						INVOKE_ASYNC(NPC, TYPE_PROC_REF(/mob/living/carbon/human/npc, Aggro), attacker, FALSE)
	if(length(seenby) >= 1)
		return TRUE
	return FALSE

/mob/living/carbon/human/npc/proc/can_see_masq_breaches()
	if(key || ghoulificated || conditioned)
		return FALSE // Already a knower, an addict or conditioned into being a placid doll.
	if(stat > SOFT_CRIT)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_BLIND))
		return FALSE
	if(pulledby)
		if(HAS_TRAIT(pulledby, TRAIT_CHARMER))
			return FALSE // Is charmed.
		if(grab_state >= GRAB_AGGRESSIVE && iskindred(pulledby))
			return FALSE // Has bigger problems right now. Likely being fed on.
	return TRUE

/mob/proc/can_respawn()
	if (client?.ckey)
		if (GLOB.respawn_timers[client.ckey])
			if ((GLOB.respawn_timers[client.ckey] + 10 MINUTES) > world.time)
				return FALSE
	return TRUE

/proc/get_vamp_skin_color(value = "albino")
	switch(value)
		if("caucasian1")
			return "vamp1"
		if("caucasian2")
			return "vamp2"
		if("caucasian3")
			return "vamp3"
		if("latino")
			return "vamp4"
		if("mediterranean")
			return "vamp5"
		if("asian1")
			return "vamp6"
		if("asian2")
			return "vamp7"
		if("arab")
			return "vamp8"
		if("indian")
			return "vamp9"
		if("african1")
			return "vamp10"
		if("african2")
			return "vamp11"
		else
			return value
