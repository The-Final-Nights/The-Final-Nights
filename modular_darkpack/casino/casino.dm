// who wants to be a millionaire?

/obj/structure/casino/slotmachine
	name = "slot machine"
	desc = "Wheel... of money!"
	icon = 'icons/obj/economy.dmi'
	icon_state = "slots0"
	anchored = TRUE
	density = TRUE
	var/win_prob = 5
	var/spinning = FALSE //track if the machine is currently spinning to update the sprite
	var/list/last_reels = list("seven", "seven", "seven")
	var/last_payout = 0
	var/last_result = "Insert chips and pull the lever!"
	var/credits = 0

	// dice rolls for each symbol
	var/sevenroll = 5
	var/diamondroll = 15
	var/bellroll = 35
	var/barroll = 60

	// payouts for each symbol based on the result
	var/seven_payout = 77
	var/diamond_payout = 25
	var/bell_payout = 10
	var/bar_payout = 5
	var/cherry_payout = 3

	// reel stop delays in deciseconds. SlotMachine.jsx runs at 100ms (1 ds = 100ms).
	var/reel_delay_1 = 50
	var/reel_delay_2 = 65
	var/reel_delay_3 = 70
	var/finish_delay = 75

/obj/structure/casino/slotmachine/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/casino/slotmachine/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/stack/casino/chip))
		var/obj/item/stack/casino/chip/chip = used_item
		credits += chip.value
		balloon_alert_to_viewers("inserted a chip!", "You insert a [chip] into [src].")
		playsound(loc, 'modular_darkpack/casino/sound/coininsert.ogg', 25, TRUE)
		if(chip.amount > 1)
			chip.amount -= 1
		else
			qdel(used_item)
		. = TRUE
	else
		return ..()

/obj/structure/casino/slotmachine/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SlotMachine")
		ui.open()

/obj/structure/casino/slotmachine/ui_data(mob/user)
	var/list/data = list()
	data["reels"] = last_reels
	data["payout"] = last_payout
	data["result"] = last_result
	data["credits"] = credits
	data["reel_delays"] = list(reel_delay_1, reel_delay_2, reel_delay_3)
	data["finish_delay"] = finish_delay
	data["paytable"] = list(
	list("symbols" = list("seven",   "seven",   "seven"),  "payout" = seven_payout,   "jackpot" = TRUE),
	list("symbols" = list("diamond", "diamond", "diamond"), "payout" = diamond_payout),
	list("symbols" = list("bell",    "bell",    "bell"),    "payout" = bell_payout),
	list("symbols" = list("bar",     "bar",     "bar"),     "payout" = bar_payout),
	list("symbols" = list("cherry",  "cherry",  "cherry"),  "payout" = cherry_payout),
	list("symbols" = list("cherry",  "cherry",  null),      "payout" = 1)
	)

	return data

/obj/structure/casino/slotmachine/proc/spin_reel()
	playsound(loc, 'modular_darkpack/casino/sound/reelclick.ogg', 50, TRUE)
	var/roll = rand(1, 100)
	if(roll <= sevenroll)
		return "seven"
	if(roll <= diamondroll)
		return "diamond"
	if(roll <= bellroll)
		return "bell"
	if(roll <= barroll)
		return "bar"
	return "cherry"

/obj/structure/casino/slotmachine/proc/calculate_payout(list/reels)
	var/reelone = reels[1]
	var/reeltwo = reels[2]
	var/reelthree = reels[3]

	if(reelone == reeltwo && reeltwo == reelthree)
		switch(reelone)
			if("seven")
				return seven_payout
			if("diamond")
				return diamond_payout
			if("bell")
				return bell_payout
			if("bar")
				return bar_payout
			if("cherry")
				return cherry_payout

	var/cherries = 0
	for(var/s in reels)
		if(s == "cherry") cherries++
	if(cherries >= 2) return cherry_payout * cherries

	return 0

/obj/structure/casino/slotmachine/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("spin")
			balloon_alert_to_viewers("pulls the lever!", "You pull the lever!")
			playsound(loc, pick('modular_darkpack/casino/sound/slotmusic1.ogg','modular_darkpack/casino/sound/slotmusic2.ogg','modular_darkpack/casino/sound/slotmusic3.ogg'), 25)
			if(credits < 1)
				balloon_alert_to_viewers("Insert chips first!")
				return FALSE
			icon_state = "slots2"
			credits -= 1
			playsound(loc, 'modular_darkpack/casino/sound/reelspin.ogg', 50, TRUE)
			last_reels = list("", "", "")
			addtimer(CALLBACK(src, PROC_REF(reveal_reel), 1), reel_delay_1)
			addtimer(CALLBACK(src, PROC_REF(reveal_reel), 2), reel_delay_2)
			addtimer(CALLBACK(src, PROC_REF(reveal_reel), 3), reel_delay_3)
			addtimer(CALLBACK(src, PROC_REF(finish_spin)), finish_delay)
			return TRUE
		if("cashout")
			if(credits <= 0)
				return FALSE
			var/remaining = credits
			var/thousands = round(remaining / 1000)
			remaining -= thousands * 1000
			var/hundreds = round(remaining / 100)
			remaining -= hundreds * 100
			if(thousands > 0)
				new /obj/item/stack/casino/chip/onethousand(get_turf(src), thousands)
			if(hundreds > 0)
				new /obj/item/stack/casino/chip/onehundred(get_turf(src), hundreds)
			if(remaining > 0)
				new /obj/item/stack/casino/chip(get_turf(src), remaining)
			credits = 0
			last_result = "Thanks for playing!"
			icon_state = "slots0"
			playsound(loc, 'modular_darkpack/casino/sound/shortpayout.ogg', 25, TRUE)
			return TRUE

/obj/structure/casino/slotmachine/proc/reveal_reel(index)
	last_reels[index] = spin_reel()

/obj/structure/casino/slotmachine/proc/finish_spin()
	last_payout = calculate_payout(last_reels)
	if(last_payout > 0)
		credits += last_payout
		if(last_payout >= seven_payout)
			last_result = "JACKPOT! +$[last_payout]!"
			visible_message(span_warning("Someone hits the JACKPOT on [src]! $[last_payout] won!"))
			playsound(loc, 'modular_darkpack/casino/sound/jackpotpayout.ogg', 50, TRUE)
		else
			last_result = "+$[last_payout]!"
			playsound(loc, 'modular_darkpack/casino/sound/shortpayout.ogg', 25, TRUE)
	else
		last_result = pick("Wheel... of money!","Wheel. Of. Money!", "Wheel of money!")
	icon_state = "slots1"

/obj/item/stack/casino/chip
	icon = 'icons/obj/economy.dmi'
	name = "$1 casino chip"
	desc = "A heavy casino chip. Made from real metals!"
	icon_state = "coin_heads"
	flags_1 = CONDUCT_1
	amount = 1
	force = 1
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/bronze = 1)
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_GREYSCALE | MATERIAL_AFFECT_STATISTICS
	var/string_attached
	var/list/sideslist = list("heads","tails")
	var/cooldown = 0
	var/value = 1
	var/coinflip
	item_flags = NO_MAT_REDEMPTION

/obj/item/stack/casino/chip/Initialize()
	. = ..()
	coinflip = pick(sideslist)
	icon_state = "coin_[coinflip]"
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/stack/casino/chip/update_icon_state()
	. = ..()
	var/amount = get_amount()
	switch(amount)
		if(100 to INFINITY)
			icon_state = "coin"
		if(50 to 100)
			icon_state = "coin"
		if(2 to 50)
			icon_state = "coin"
			name = "stack of [name]s"
		else
			icon_state = "coin"

/obj/item/stack/casino/chip/examine(mob/user)
	. = ..()
	. += span_info("Total worth: $[value * amount] dollars.")

/obj/item/stack/casino/chip/attack_self(mob/user)
	if(cooldown < world.time)
		cooldown = world.time + 15
		flick("coin_[coinflip]_flip", src)
		coinflip = pick(sideslist)
		icon_state = "coin_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, TRUE)
		var/oldloc = loc
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message(span_notice("[user] flips [src]. It lands on [coinflip]"), \
				span_notice("You flip [src]. It lands on [coinflip]"), \
				span_hear("You hear the clattering of chips"))
	return TRUE

/obj/item/stack/casino/chip/onehundred
	name = "$100 casino chip"
	custom_materials = list(/datum/material/gold = 1)
	value = 100

/obj/item/stack/casino/chip/onethousand
	name = "$1,000 casino chip"
	custom_materials = list(/datum/material/diamond = 1)
	value = 1000
