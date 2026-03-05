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

/obj/structure/casino/slotmachine/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/casino/slotmachine/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/stack/casino/chip))
		var/obj/item/stack/casino/chip/chip = used_item
		credits += chip.value
		balloon_alert_to_viewers("inserted a chip!", "You insert a [chip] into [src].")
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

	return data

/obj/structure/casino/slotmachine/proc/spin_reel()
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
			var/mob/user = ui.user
			if(credits < 1)
				balloon_alert_to_viewers("Insert chips first!")
				return FALSE
			icon_state = "slots2"
			credits -= 1
			last_reels = list(spin_reel(), spin_reel(), spin_reel())
			last_payout = calculate_payout(last_reels)
			if(last_payout > 0)
				credits += last_payout
				if(last_payout >= 77)
					last_result = "JACKPOT! +$[last_payout]!"
					visible_message(span_warning("[user] hits the JACKPOT on [src]! $[last_payout] won!"))
					balloon_alert_to_viewers("hits the JACKPOT!", "You hit the JACKPOT! $[last_payout] won!")
				else
					last_result = "+$[last_payout]!"
					balloon_alert_to_viewers("+$[last_payout]!")
			else
				last_result = pick("Wheel... of money!","Wheel. Of. Money!", "Wheel of money!")
			addtimer(CALLBACK(src, PROC_REF(finish_spin)), 75)
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
			return TRUE

/obj/structure/casino/slotmachine/proc/finish_spin() // todo: add sounds
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
