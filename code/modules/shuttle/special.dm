// Special objects for shuttle templates go here if nowhere else

// Bar staff, GODMODE mobs(as long as they stay in the shuttle) that just want to make sure people have drinks
// and a good time.

/mob/living/simple_animal/drone/snowflake/bardrone
	name = "Bardrone"
	desc = "A barkeeping drone, a robot built to tend bars."
	hacked = TRUE
	laws = "1. Serve drinks.\n\
		2. Talk to patrons.\n\
		3. Don't get messed up in their affairs."
	unique_name = FALSE // disables the (123) number suffix
	initial_language_holder = /datum/language_holder/universal

/mob/living/simple_animal/drone/snowflake/bardrone/Initialize()
	. = ..()
	access_card.access |= ACCESS_CENT_BAR
	RegisterSignal(src, COMSIG_ENTER_AREA, PROC_REF(check_barstaff_godmode))
	check_barstaff_godmode()

/mob/living/simple_animal/hostile/alien/maid/barmaid
	gold_core_spawnable = NO_SPAWN
	name = "Barmaid"
	desc = "A barmaid, a maiden found in a bar."
	pass_flags = PASSTABLE
	unique_name = FALSE
	AIStatus = AI_OFF
	stop_automated_movement = TRUE
	initial_language_holder = /datum/language_holder/universal

/mob/living/simple_animal/hostile/alien/maid/barmaid/Initialize()
	. = ..()
	access_card = new /obj/item/card/id(src)
	var/datum/job/captain/C = new /datum/job/captain
	access_card.access = C.get_access()
	access_card.access |= ACCESS_CENT_BAR
	ADD_TRAIT(access_card, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	RegisterSignal(src, COMSIG_ENTER_AREA, PROC_REF(check_barstaff_godmode))
	check_barstaff_godmode()

/mob/living/simple_animal/hostile/alien/maid/barmaid/Destroy()
	qdel(access_card)
	. = ..()

/mob/living/simple_animal/proc/check_barstaff_godmode()
	SIGNAL_HANDLER

	if(istype(get_area(loc), /area/shuttle/escape))
		status_flags |= GODMODE
	else
		status_flags &= ~GODMODE

// Bar table, a wooden table that kicks you in a direction if you're not
// barstaff (defined as someone who was a roundstart bartender or someone
// with CENTCOM_BARSTAFF)

/obj/structure/table/wood/bar
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_1 = NODECONSTRUCT_1
	max_integrity = 1000
	var/boot_dir = 1

/obj/structure/table/wood/bar/Crossed(atom/movable/AM)
	var/mob/living/M = AM
	if(istype(M) && !M.incorporeal_move && !is_barstaff(M))
		// No climbing on the bar please
		var/throwtarget = get_edge_target_turf(src, boot_dir)
		M.Paralyze(40)
		M.throw_at(throwtarget, 5, 1)
		to_chat(M, "<span class='notice'>No climbing on the bar please.</span>")
	else
		return ..()

/obj/structure/table/wood/bar/proc/is_barstaff(mob/living/user)
	. = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind && H.mind.assigned_role == "Bartender")
			return TRUE

	var/obj/item/card/id/ID = user.get_idcard(FALSE)
	if(ID && (ACCESS_CENT_BAR in ID.access))
		return TRUE

//Luxury Shuttle Blockers

/obj/machinery/scanner_gate/luxury_shuttle
	name = "luxury shuttle ticket field"
	density = FALSE //allows shuttle airlocks to close, nothing but an approved passenger gets past CanPass
	locked = TRUE
	use_power = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/threshold = 500
	var/static/list/approved_passengers = list()
	var/static/list/check_times = list()
	var/list/payees = list()

/obj/machinery/scanner_gate/luxury_shuttle/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()

	if(mover in approved_passengers)
		set_scanline("scanning", 10)
		if(isvehicle(mover))
			var/obj/vehicle/vehicle = mover
			for(var/mob/living/rat in vehicle.occupants)
				if(!(rat in approved_passengers))
					say("<span class='robot'>Stowaway detected. Please exit the vehicle first.</span>")
					return FALSE
		return TRUE
	if(isitem(mover))
		return TRUE
	if(isstructure(mover))
		var/obj/structure/struct = mover
		for(var/mob/living/rat in struct.contents)
			say("<span class='robot'>Stowaway detected. Please exit the structure first.</span>")
			return FALSE
		return TRUE

	return FALSE

/obj/machinery/scanner_gate/luxury_shuttle/auto_scan(atom/movable/AM)
	return

/obj/machinery/scanner_gate/luxury_shuttle/attackby(obj/item/W, mob/user, params)
	return

/obj/machinery/scanner_gate/luxury_shuttle/emag_act(mob/user)
	return

#define LUXURY_MESSAGE_COOLDOWN 100
/obj/machinery/scanner_gate/luxury_shuttle/Bumped(atom/movable/AM)
	///If the atom entering the gate is a vehicle, we store it here to add to the approved list to enter/leave the scanner gate.
	var/obj/vehicle/vehicle
	///We store the driver of vehicles seperately so that we can add them to the approved list once payment is fully processed.
	var/mob/living/driver_holdout
	if(!isliving(AM) && !isvehicle(AM))
		alarm_beep()
		return ..()

	var/datum/bank_account/account
	if(istype(AM.pulling, /obj/item/card/id))
		var/obj/item/card/id/I = AM.pulling
		if(I.registered_account)
			account = I.registered_account
		else if(!check_times[AM] || check_times[AM] < world.time) //Let's not spam the message
			to_chat(AM, "<span class='notice'>This ID card doesn't have an owner associated with it!</span>")
			check_times[AM] = world.time + LUXURY_MESSAGE_COOLDOWN
	else if(isliving(AM))
		var/mob/living/L = AM
		account = L.get_bank_account()

	else if(isvehicle(AM))
		vehicle = AM
		for(var/passenger in vehicle.occupants)
			if(!isliving(passenger))
				continue
			var/mob/living/rider = passenger
			if(vehicle.is_driver(rider))
				driver_holdout = rider
				var/obj/item/card/id/id = rider.get_idcard(TRUE)
				account = id?.registered_account
				break

	if(account)
		if(account.account_balance < threshold - payees[AM])
			account.adjust_money(-account.account_balance)
			payees[AM] += account.account_balance
		else
			var/money_owed = threshold - payees[AM]
			account.adjust_money(-money_owed)
			payees[AM] += money_owed

	//Here is all the possible paygate payment methods.
	var/list/counted_money = list()
	for(var/obj/item/coin/C in AM.GetAllContents()) //Coins.
		if(payees[AM] >= threshold)
			break
		payees[AM] += C.value
		counted_money += C
	for(var/obj/item/stack/spacecash/S in AM.GetAllContents()) //Paper Cash
		if(payees[AM] >= threshold)
			break
		payees[AM] += S.value * S.amount
		counted_money += S
	for(var/obj/item/holochip/H in AM.GetAllContents()) //Holocredits
		if(payees[AM] >= threshold)
			break
		payees[AM] += H.credits
		counted_money += H

	if(payees[AM] < threshold && istype(AM.pulling, /obj/item/coin)) //Coins(Pulled).
		var/obj/item/coin/C = AM.pulling
		payees[AM] += C.value
		counted_money += C

	else if(payees[AM] < threshold && istype(AM.pulling, /obj/item/stack/spacecash)) //Cash(Pulled).
		var/obj/item/stack/spacecash/S = AM.pulling
		payees[AM] += S.value * S.amount
		counted_money += S

	else if(payees[AM] < threshold && istype(AM.pulling, /obj/item/holochip)) //Holocredits(pulled).
		var/obj/item/holochip/H = AM.pulling
		payees[AM] += H.credits
		counted_money += H

	if(payees[AM] < threshold) //Suggestions for those with no arms/simple animals.
		var/armless
		if(!ishuman(AM) && !istype(AM, /mob/living/simple_animal/slime))
			armless = TRUE
		else
			var/mob/living/carbon/human/H = AM
			if(!H.get_bodypart(BODY_ZONE_L_ARM) && !H.get_bodypart(BODY_ZONE_R_ARM))
				armless = TRUE

		if(armless)
			if(!AM.pulling || !iscash(AM.pulling) && !istype(AM.pulling, /obj/item/card/id))
				if(!check_times[AM] || check_times[AM] < world.time) //Let's not spam the message
					to_chat(AM, "<span class='notice'>Try pulling a valid ID, space cash, holochip or coin into \the [src]!</span>")
					check_times[AM] = world.time + LUXURY_MESSAGE_COOLDOWN

	if(payees[AM] >= threshold)
		for(var/obj/I in counted_money)
			qdel(I)
		payees[AM] -= threshold

		var/change = FALSE
		if(payees[AM] > 0)
			change = TRUE
			var/obj/item/holochip/HC = new /obj/item/holochip(AM.loc) //Change is made in holocredits exclusively.
			HC.credits = payees[AM]
			HC.name = "[HC.credits] credit holochip"
			if(istype(AM, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = AM
				if(!H.put_in_hands(HC))
					AM.pulling = HC
			else
				AM.pulling = HC
			payees[AM] -= payees[AM]

		say("<span class='robot'>Welcome to first class, [driver_holdout ? "[driver_holdout]" : "[AM]" ]![change ? " Here is your change." : ""]</span>")
		approved_passengers |= AM
		if(vehicle)
			approved_passengers |= vehicle
		if(driver_holdout)
			approved_passengers |= driver_holdout

		check_times -= AM
		return
	else if (payees[AM] > 0)
		for(var/obj/I in counted_money)
			qdel(I)
		if(!check_times[AM] || check_times[AM] < world.time) //Let's not spam the message
			to_chat(AM, "<span class='notice'>[payees[AM]] cr received. You need [threshold-payees[AM]] cr more.</span>")
			check_times[AM] = world.time + LUXURY_MESSAGE_COOLDOWN
		alarm_beep()
		return ..()
	else
		alarm_beep()
		return ..()

/mob/living/simple_animal/hostile/bear/fightpit
	name = "fight pit bear"
	desc = "This bear's trained through ancient Russian secrets to fear the walls of its glass prison."
	environment_smash = ENVIRONMENT_SMASH_NONE

/obj/effect/decal/hammerandsickle
	name = "hammer and sickle"
	desc = "Communism powerful force."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "communist"
	layer = ABOVE_OPEN_TURF_LAYER
	pixel_x = -32
	pixel_y = -32

/obj/effect/decal/hammerandsickle/shuttleRotate(rotation)
	setDir(angle2dir(rotation+dir2angle(dir))) // No parentcall, rest of the rotate code breaks the pixel offset.
