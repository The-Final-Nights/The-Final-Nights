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
