/mob/living/carbon/human/death()
	. = ..()

	if(iskindred(src))
		SSmasquerade.dead_level = min(1000, SSmasquerade.dead_level+50)
	else
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type == "masquerade")
				SSmasquerade.dead_level = max(0, SSmasquerade.dead_level-25)

	if(bloodhunted)
		SSbloodhunt.hunted -= src
		bloodhunted = FALSE
		SSbloodhunt.update_shit()
	var/witness_count
	for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, usr))
		if(NEPIC && NEPIC.stat != DEAD)
			witness_count++
		if(witness_count > 1)
			for(var/obj/item/police_radio/radio in GLOB.police_radios)
				radio.announce_crime("murder", get_turf(src))
			for(var/obj/machinery/p25transceiver/police/radio in GLOB.p25_tranceivers)
				if(radio.p25_network == "police")
					radio.announce_crime("murder", get_turf(src))
					break
	GLOB.masquerade_breakers_list -= src
	GLOB.sabbatites -= src

	//So upon death the corpse is filled with yin chi
	yin_chi = min(max_yin_chi, yin_chi+yang_chi)
	yang_chi = 0

	if(iskindred(src) || iscathayan(src))
		can_be_embraced = FALSE

		if(in_frenzy)
			exit_frenzymod()
		SEND_SOUND(src, sound('code/modules/wod13/sounds/final_death.ogg', 0, 0, 50))

		//annoying code that depends on clan doesn't work for Kuei-jin
		if (iscathayan(src))
			return

		var/years_undead = chronological_age - age
		switch (years_undead)
			if (-INFINITY to 10) //normal corpse
				return
			if (10 to 50)
				clane.rot_body(1) //skin takes on a weird colouration
				visible_message("<span class='notice'>[src]'s skin loses some of its colour.</span>")
				update_body()
				update_body() //this seems to be necessary due to stuff being set on update_body() and then only refreshing with a new call
			if (50 to 100)
				clane.rot_body(2) //looks slightly decayed
				visible_message("<span class='notice'>[src]'s skin rapidly decays.</span>")
				update_body()
				update_body()
			if (100 to 150)
				clane.rot_body(3) //looks very decayed
				visible_message("<span class='warning'>[src]'s body rapidly decomposes!</span>")
				update_body()
				update_body()
			if (150 to 200)
				clane.rot_body(4) //mummified skeletonised corpse
				visible_message("<span class='warning'>[src]'s body rapidly skeletonises!</span>")
				update_body()
				update_body()
			if (200 to INFINITY)
				if (iskindred(src))
					playsound(src, 'code/modules/wod13/sounds/burning_death.ogg', 80, TRUE)
				else if (iscathayan(src))
					playsound(src, 'code/modules/wod13/sounds/vicissitude.ogg', 80, TRUE)
				lying_fix()
				dir = SOUTH
				spawn(1 SECONDS)
					dust(TRUE, TRUE) //turn to ash
