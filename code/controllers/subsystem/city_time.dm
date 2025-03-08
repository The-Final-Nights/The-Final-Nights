SUBSYSTEM_DEF(city_time)
	name = "City Time"
	init_order = INIT_ORDER_DEFAULT
	wait = 150
	priority = FIRE_PRIORITY_DEFAULT

	var/hour = 21
	var/minutes = 0

	var/timeofnight = "21:00"

/proc/get_next_hour(var/number)
	if(number == 23)
		return 0
	else
		return number+1

/proc/get_watch_number(var/number)
	if(number < 10)
		return "0[number]"
	else
		return "[number]"

/datum/controller/subsystem/city_time/fire()
	if(minutes == 59)
		minutes = 0
		hour =  get_next_hour(hour)
	else
		minutes = max(0, minutes+1)

	timeofnight = "[get_watch_number(hour)]:[get_watch_number(minutes)]"
	// TFN EDIT REFACTOR START
	if(hour == 0 && minutes == 0)
		for(var/mob/living/carbon/werewolf/W in GLOB.player_list)
			if(W?.stat != DEAD && W?.key)
				var/datum/preferences/char_sheet = GLOB.preferences_datums[ckey(W.key)]
				char_sheet?.add_experience(3)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H?.stat != DEAD && H?.key)
				var/datum/preferences/char_sheet = GLOB.preferences_datums[ckey(H.key)]
				if(char_sheet)
					char_sheet.add_experience(3)

					var/role = H.mind?.assigned_role

					if(role in list("Prince", "Sheriff", "Seneschal", "Chantry Regent", "Baron", "Dealer"))
						char_sheet.add_experience(3)

					if(!HAS_TRAIT(H, TRAIT_NON_INT))
						if(H.total_erp > 1500)
							char_sheet.add_experience(2)
							H.total_erp = 0
						if(H.total_cleaned > 25)
							char_sheet.add_experience(1)
							H.total_cleaned = 0
							call_dharma("cleangrow", H)
						if(role == "Graveyard Keeper")
							if(SSgraveyard.total_good > SSgraveyard.total_bad)
								char_sheet.add_experience(1)

					char_sheet.save_preferences()
					char_sheet.save_character()

	if(hour == 3 && minutes == 0)
		for(var/mob/living/carbon/werewolf/W in GLOB.player_list)
			if(W?.stat != DEAD && W?.key)
				var/datum/preferences/char_sheet = GLOB.preferences_datums[ckey(W.key)]
				char_sheet?.add_experience(3)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H?.stat != DEAD && H?.key)
				var/datum/preferences/char_sheet = GLOB.preferences_datums[ckey(H.key)]
				if(char_sheet)
					char_sheet.add_experience(3)

					var/role = H.mind?.assigned_role

					if(role in list("Prince", "Sheriff", "Seneschal", "Chantry Regent", "Baron", "Dealer"))
						char_sheet.add_experience(2)

					if(!HAS_TRAIT(H, TRAIT_NON_INT))
						if(H.total_erp > 1500)
							char_sheet.add_experience(2)
							H.total_erp = 0
						if(H.total_cleaned > 25)
							char_sheet.add_experience(1)
							H.total_cleaned = 0
							call_dharma("cleangrow", H)
						if(role == "Graveyard Keeper")
							if(SSgraveyard.total_good > SSgraveyard.total_bad)
								char_sheet.add_experience(1)

					char_sheet.save_preferences()
					char_sheet.save_character()
	// TFN EDIT REFACTOR END
	if(hour == 5 && minutes == 30)
		to_chat(world, "<span class='ghostalert'>The night is ending...</span>")

	if(hour == 5 && minutes == 45)
		to_chat(world, "<span class='ghostalert'>First rays of the sun illuminate the sky...</span>")

	if(hour == 6 && minutes == 0)
		to_chat(world, "<span class='ghostalert'>THE NIGHT IS OVER.</span>")
		SSticker.force_ending = 1
		SSticker.current_state = GAME_STATE_FINISHED
		toggle_ooc(TRUE) // Turn it on
		toggle_dooc(TRUE)
		SSticker.declare_completion(SSticker.force_ending)
		Master.SetRunLevel(RUNLEVEL_POSTGAME)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			var/area/vtm/V = get_area(H)
			if(iskindred(H) && V.upper)
				H.death()
			if(iscathayan(H) && V.upper)
				H.death()
