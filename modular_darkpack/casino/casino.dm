// who wants to be a millionaire?

/obj/structure/casino/slotmachine
	name = "slot machine"
	desc = "Wheel... of money!"
	icon = 'modular_darkpack/casino/icons/casino.dmi'
	icon_state = "slots0"
	anchored = TRUE
	density = TRUE
	var/spinning = FALSE
	var/list/last_reels = list("seven", "seven", "seven")
	var/last_payout = 0
	var/last_result = "Insert chips and pull the lever!"
	var/credits = 0
	var/force_jackpot = FALSE
	var/hacked = FALSE
	var/symbol_glyphs = list("seven" = " 7 ", "diamond" = " 💎 ", "bell" = " 🔔 ", "bar" = " BAR ", "cherry" = " 🍒 ")
	var/alert = ""
	var/payout_multiplier = 0

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

	// reel stop delays set at init
	var/reel_delay_1 = 1
	var/reel_delay_2 = 1
	var/reel_delay_3 = 1
	var/finish_delay = 9 SECONDS

	// bet sizes
	var/bet_size = 1
	var/list/bet_sizes = list(1, 5, 10, 25)

/obj/structure/casino/slotmachine/Initialize()
	. = ..()
	reel_delay_1 = pick(3 SECONDS, 4 SECONDS)
	reel_delay_2 = pick(5 SECONDS, 6 SECONDS)
	reel_delay_3 = pick(7 SECONDS, 8 SECONDS) //the reelspin.ogg sound is 7 seconds long, so probably dont go any higher than 8

// a more expensive slot machine
/obj/structure/casino/slotmachine/deluxe
	name = "deluxe slot machine"
	desc = "Higher stakes, higher rewards!"
	// dice rolls for each symbol
	sevenroll = 8
	diamondroll = 20
	bellroll = 40
	barroll = 55

	// payouts for each symbol based on the result
	seven_payout = 77
	diamond_payout = 30
	bell_payout = 15
	bar_payout = 10
	cherry_payout = 6

	// bet sizes
	bet_size = 25
	bet_sizes = list(25, 50, 100, 250)

/obj/structure/casino/slotmachine/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/casino/slotmachine/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/stack/casino/chip))
		var/obj/item/stack/casino/chip/chip = used_item
		credits += chip.value
		balloon_alert_to_viewers("inserted a chip!", "You insert a [chip] into [src].")
		playsound(loc, 'modular_darkpack/casino/sounds/coininsert.ogg', pick(30, 40), TRUE)
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
	data["bet_size"] = bet_size
	data["bet_sizes"] = bet_sizes
	data["paytable"] = list(
	list("symbols" = list("seven",   "seven",   "seven"),  "payout" = seven_payout,   "jackpot" = TRUE),
	list("symbols" = list("diamond", "diamond", "diamond"), "payout" = diamond_payout),
	list("symbols" = list("bell",    "bell",    "bell"),    "payout" = bell_payout),
	list("symbols" = list("bar",     "bar",     "bar"),     "payout" = bar_payout),
	list("symbols" = list("cherry",  "cherry",  "cherry"),  "payout" = cherry_payout),
	list("symbols" = list(null,      null,      null),      "payout" = 2, "pair" = TRUE)
	)

	return data

/obj/structure/casino/slotmachine/proc/spin_reel(mob/living/user)
	if(force_jackpot)
		return "seven"
	var/roll = rand(1, 100) //+ user.mind.prefs.donator * 10 // donators are a tiny bit luckier
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
	payout_multiplier = 0
	var/reelone = reels[1]
	var/reeltwo = reels[2]
	var/reelthree = reels[3]

	if(reelone == reeltwo && reeltwo == reelthree)
		switch(reelone)
			if("seven")
				payout_multiplier = seven_payout
			if("diamond")
				payout_multiplier = diamond_payout
			if("bell")
				payout_multiplier = bell_payout
			if("bar")
				payout_multiplier = bar_payout
			if("cherry")
				payout_multiplier = cherry_payout
	else if(reelone == reeltwo || reelone == reelthree || reeltwo == reelthree)
		payout_multiplier = 2 // any pair pays 2x the bet

	for(var/symbol in reels)
		if(symbol == "diamond")
			payout_multiplier *= 2 // each diamond multiplies payout by 2

	return CEILING(payout_multiplier, 1) // round up just incase

/obj/structure/casino/slotmachine/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("spin")
			if(hacked && prob(50))
				do_sparks(5, prob(50), src)
				playsound(loc, get_sfx("sparks"), 25, TRUE, -3)
			balloon_alert_to_viewers("Lever pulled!", "You pull the lever!")
			playsound(loc, pick('modular_darkpack/casino/sounds/slotmusic1.ogg','modular_darkpack/casino/sounds/slotmusic2.ogg','modular_darkpack/casino/sounds/slotmusic3.ogg'), pick(30, 40), hacked)
			if(credits < bet_size)
				balloon_alert_to_viewers("Not enough credits!")
				return FALSE
			icon_state = "slots2"
			credits -= bet_size
			playsound(loc, 'modular_darkpack/casino/sounds/reelspin.ogg', pick(75, 85), FALSE, use_reverb = TRUE)
			last_reels = list("", "", "")
			alert = ""
			addtimer(CALLBACK(src, PROC_REF(reveal_reel), 1, usr), reel_delay_1)
			addtimer(CALLBACK(src, PROC_REF(reveal_reel), 2, usr), reel_delay_2)
			addtimer(CALLBACK(src, PROC_REF(reveal_reel), 3, usr), reel_delay_3)
			addtimer(CALLBACK(src, PROC_REF(finish_spin)), finish_delay)
			return TRUE
		if("set_bet")
			var/new_bet = text2num(params["bet"])
			bet_size = new_bet
			playsound(loc, 'sound/machines/terminal_button01.ogg', pick(75, 85), TRUE, use_reverb = TRUE)
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
			last_result = " "
			icon_state = "slots0"
			playsound(loc, 'modular_darkpack/casino/sounds/shortpayout.ogg', pick(25, 35), TRUE, use_reverb = TRUE)
			return TRUE

/obj/structure/casino/slotmachine/proc/reveal_reel(index, mob/living/user)
	last_reels[index] = spin_reel(user)
	alert += symbol_glyphs[last_reels[index]]
	balloon_alert_to_viewers(alert)
	SStgui.update_uis(src) // without this the click sound will play before the reel updates, and it looks like the symbol changed last second. woe
	addtimer(CALLBACK(src, PROC_REF(play_reel_click)), 2)

/obj/structure/casino/slotmachine/proc/play_reel_click()
	playsound(loc, 'modular_darkpack/casino/sounds/reelclick.ogg', pick(75, 85), TRUE, use_reverb = TRUE)

/obj/structure/casino/slotmachine/proc/finish_spin()
	var/base_payout = calculate_payout(last_reels)
	last_payout = base_payout * bet_size
	if(last_payout > 0)
		credits += last_payout
		if(base_payout >= seven_payout)
			last_result = "JACKPOT! +$[last_payout]!"
			visible_message(span_warning("JACKPOT!!!"))
			balloon_alert_to_viewers("JACKPOT!!!")
			playsound(loc, 'modular_darkpack/casino/sounds/jackpotpayout.ogg', 50, TRUE, use_reverb = TRUE)
			force_jackpot = FALSE
		else
			last_result = "+$[last_payout]!"
			playsound(loc, 'modular_darkpack/casino/sounds/shortpayout.ogg', pick(25, 35), TRUE, use_reverb = TRUE)
	else
		last_result = " "
	icon_state = "slots1"

/obj/item/stack/casino/chip
	icon = 'modular_darkpack/casino/icons/casino.dmi'
	name = "casino chip"
	singular_name = "$1 casino chip"
	desc = "A heavy casino chip. Made from real metals!"
	icon_state = "coin_heads"
	flags_1 = CONDUCT_1
	amount = 1
	max_amount = 100
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/bronze = 1)
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	var/string_attached
	var/list/sideslist = list("heads","tails")
	var/cooldown = 0
	var/value = 1
	var/coinflip
	item_flags = NO_MAT_REDEMPTION

/obj/item/stack/casino/chip/Initialize()
	. = ..()
	coinflip = pick(sideslist)
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8
	if(!QDELETED(src) && type == /obj/item/stack/casino/chip)
		AddComponent(/datum/component/selling/casino, 1, "casino_chips")


/obj/item/stack/casino/chip/update_icon_state()
	. = ..()
	var/amount = get_amount()
	switch(amount)
		if(100 to INFINITY)
			icon_state = "coin3"
		if(50 to 100)
			icon_state = "coin2"
		if(25 to 50)
			icon_state = "coin1"
		else
			icon_state = "coin_heads"

/obj/item/stack/casino/chip/examine(mob/user)
	. = ..()
	. += span_info("Total worth: $[value * amount] dollars.")

/obj/item/stack/casino/chip/attack_self(mob/user)
	if(cooldown < world.time && amount == 1)
		cooldown = world.time + 15
		flick("coin_[coinflip]_flip", src)
		coinflip = pick(sideslist)
		icon_state = "coin_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', pick(50, 60), TRUE)
		var/oldloc = loc
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message(span_notice("[user] flips [src]. It lands on [coinflip]"), \
				span_notice("You flip [src]. It lands on [coinflip]"), \
				span_hear("You hear the clattering of chips"))
	return TRUE

/obj/item/stack/casino/chip/onehundred
	name = "$100 casino chip"
	singular_name = "$100 casino chip"
	custom_materials = list(/datum/material/gold = 1)
	value = 100

/obj/item/stack/casino/chip/onehundred/Initialize()
	. = ..()
	if(!QDELETED(src))
		AddComponent(/datum/component/selling/casino, 100, "casino_chips")

/obj/item/stack/casino/chip/onethousand
	name = "$1,000 casino chip"
	singular_name = "$1,000 casino chip"
	custom_materials = list(/datum/material/diamond = 1)
	value = 1000

/obj/item/stack/casino/chip/onethousand/Initialize()
	. = ..()
	if(!QDELETED(src))
		AddComponent(/datum/component/selling/casino, 1000, "casino_chips")

// job stuff
/datum/job/vamp/casino/casinoemployee
	title = "Casino Employee"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Casino Manager")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the casino."
	selection_color = "#bd3327"
	exp_type = EXP_TYPE_CASINO

	outfit = /datum/outfit/job/casino

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM) // See /datum/job/officer/get_access()
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_CASINO
	bounty_types = CIV_JOB_SEC
	known_contacts = list("Casino Employee", "Casino Manager")
	allowed_species = list("Ghoul", "Human", "Vampire")
	allowed_bloodlines = list(CLAN_TRUE_BRUJAH, CLAN_DAUGHTERS_OF_CACOPHONY, CLAN_BRUJAH, CLAN_TREMERE, CLAN_VENTRUE, CLAN_NOSFERATU, CLAN_GANGREL, CLAN_TOREADOR, CLAN_MALKAVIAN, CLAN_BANU_HAQIM, CLAN_LASOMBRA, CLAN_GARGOYLE, CLAN_KIASYD, CLAN_CAPPADOCIAN, CLAN_TZIMISCE)
	v_duty = "You work for the local casino run by the elusive Setites, who you know as 'management'. Ensure your mortal coworkers stay in the dark of any supernatural happenings, and keep up the facade to the outside world while ensuring the casino stays profitable. The casino is one of many fronts for their operations, so you might find yourself doing some tasks that are a bit more... unconventional, but as long as you keep your head down and do your job, you should be fine. Just remember, the casino is a business, and you are an employee, so act like it and everything will be fine."
	duty = "You work directly for the casino and its administrative staff in a variety of ways, you may even be a personal retainer of one of the managers, to the point that any oddities that you may see over night or hear are either things you are already aware or you simply laugh them off and try not to think about it. This job pays great, so why ask questions? Just do your job and collect your paycheck. You may even get some perks if you are a good employee, like getting to keep some of the chips you find on the floor or maybe even a small cut of the profits if you really impress the higher ups. Just remember, the casino is a business, and you are an employee, so act like it and everything will be fine."
	minimal_masquerade = 4
	experience_addition = 10

/datum/outfit/job/casino
	name = "Casino Employee"
	jobtype = /datum/job/vamp/casino/casinoemployee
	id = /obj/item/card/id/chunk/casino/employee
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/setite
	l_pocket = /obj/item/vamp/phone/casino_employee
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard/rich=1)
	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/datum/outfit/job/casino/manager
	name = "Casino Manager"
	id = /obj/item/card/id/chunk/casino/manager


/datum/outfit/job/casinoemployee/pre_equip(mob/living/carbon/human/H)
	..()

/obj/effect/landmark/start/casinoemployee
	name = "Casino Employee"
	icon_state = "Bartender"

/obj/effect/landmark/start/casinomanager
	name = "Casino Manager"
	icon_state = "Bartender"

/obj/item/card/id/chunk/casino/employee
	name = "Casino Employee ID"
	id_type_name = "Security ID"
	desc = "An ID showing employment with the Casino."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id2"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id2"

/obj/item/card/id/chunk/casino/manager
	name = "Casino Manager ID"
	id_type_name = "Security ID"
	desc = "An ID showing employment with the Casino."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id2"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id2"

/obj/item/vamp/phone/casino_employee
	exchange_num = 485
	contact_networks_pre_init = list(
		list(CASINO_NETWORK, "Casino Employee", TRUE)
		)

/datum/job/vamp/casino/casinomanager
	title = "Casino Manager"
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Casino Manager")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	exp_requirements = 500
	supervisors = "the clan."
	selection_color = "#bd3327"
	exp_type = EXP_TYPE_CASINO

	outfit = /datum/outfit/job/casino/manager

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_FORENSICS_LOCKERS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_WEAPONS, ACCESS_MECH_SECURITY, ACCESS_MINERAL_STOREROOM) // See /datum/job/officer/get_access()
	paycheck = PAYCHECK_HARD
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_CASINO
	bounty_types = CIV_JOB_SEC
	known_contacts = list("Casino Employee", "Casino Manager")
	allowed_species = list("Vampire")
	allowed_bloodlines = list(CLAN_SETITES)
	v_duty = "You help run the local casino owned by your clan, which serves as a front for your operations. You may have various responsibilities, from managing the mortal employees to overseeing the more... sensitive aspects of the business. The casino is a lucrative venture, and as long as you keep it running smoothly and profitably, you should have no issues. Just remember, the casino is a business, and while you are a manager, you are also expected to be an employee where needed. Ensure noone gets too curious about the inner workings of the place, and if any problems arise, deal with them quickly and quietly. The less unwanted attention drawn to the casino, the better."
	minimal_masquerade = 4
	experience_addition = 10


// NPC Cashier
/obj/machinery/mineral/equipment_vendor/fastfood/casino/cashier
	owner_needed = 0
	prize_list = list(
		new /datum/data/mining_equipment("$1 casino chip", /obj/item/stack/casino/chip, 1),
		new /datum/data/mining_equipment("$100 casino chip", /obj/item/stack/casino/chip/onehundred, 100),
		new /datum/data/mining_equipment("$1,000 casino chip", /obj/item/stack/casino/chip/onethousand, 1000),
	)

/datum/component/selling/casino
	cost = 1
	object_category = "casino_chips"

/obj/lombard/casino
	name = "casino chip exchange"
	desc = "Exchange casino chips for money"
	var/active = TRUE // whether or not this sell point is available. allows casino employees to disable the sell point and man the counter manually by using the sell point in the back

/obj/lombard/casino/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/card/id/chunk/casino))
		active = !active
		if(active)
			icon_state = "sell"
			to_chat(user, span_notice("The casino chip exchange is now open."))
		else
			icon_state = "sell_d"
			to_chat(user, span_notice("The casino chip exchange is now closed."))
		return
	var/datum/component/selling/selling_component = W.GetComponent(/datum/component/selling/casino)
	if(!selling_component)
		to_chat(user, span_notice("The casino won't exchange cash for that."))
		return
	if(active)
		sell_one_item(W, user)
	else
		to_chat(user, span_notice("The automated casino chip exchange is currently closed. Please see a casino employee to exchange your chips."))

/obj/lombard/casino/sell_one_item(obj/item/stack/sold, mob/living/user)
	var/datum/component/selling/sold_sc = sold.GetComponent(/datum/component/selling)
	// var/fee = (user.client.prefs.donator) ? 0 : round(sold_sc.cost * 0.07) // 7% fee for non-donators, 0% fee for donators. the donator check isnt on this branch as its a diff testmerge rn but it will be added in later
	var/fee = round(sold_sc.cost * 0.07)
	var/amount = (sold_sc.cost - fee) * sold.amount
	var/chip_amount = sold.amount > 1 ? " for [sold.amount] chips" : ""
	if(fee)
		sold_sc.cost -= fee
		to_chat(user, span_notice("The casino deducts a $[fee] fee per chip. You receive $[amount][chip_amount]."))
	else
		to_chat(user, span_notice("The casino waives the $[fee] fee. You receive $[amount][chip_amount]."))
	generate_money(sold, user)
	playsound(loc, 'modular_darkpack/casino/sounds/singlepayout.ogg', pick(50, 60), TRUE)
	qdel(sold)
