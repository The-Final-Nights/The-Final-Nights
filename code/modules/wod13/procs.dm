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
			var/list/existing_color = rgb2num(value, COLORSPACE_HSV)
			existing_color += 255 //FOR SOME REASON THERE ISNT AN ALPHA WHEN YOU DO THE REGULAR rg2num.

			var/hue = existing_color[1]
			if(hue < 0)
				hue = 0
			else if(hue > 60)
				hue = 60

			var/sat = max(existing_color[2] - 20, 0)

			var/val = min(existing_color[3], 100)


			var/list/conv_color = list(hue, sat, val, 255)

			var/hsv_color = rgb(hue = conv_color[1], saturation = conv_color[2], value = conv_color[3], alpha = conv_color[4], space = COLORSPACE_HSV)

			return hsv_color
