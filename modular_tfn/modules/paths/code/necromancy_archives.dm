/obj/item/necromancy_tome/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		.["user"]["souls"] = H.collected_souls
		.["user"]["name"] = "[H.name]"
		.["user"]["job"] = "[H.mind?.assigned_role]"
		.["user"]["has_necromancy"] = H.necromancy_knowledge
	else if(isliving(user))
		var/mob/living/L = user
		.["user"]["souls"] = L.collected_souls
		.["user"]["name"] = "[L.name]"
		.["user"]["job"] = "Unknown"
		.["user"]["has_necromancy"] = FALSE
	else
		.["user"]["souls"] = 0
		.["user"]["name"] = "Unknown"
		.["user"]["job"] = "Unknown"
		.["user"]["has_necromancy"] = FALSE

/obj/item/necromancy_tome/ui_act(action, params)
	if(action != "purchase")
		return ..()

	if(!isliving(usr))
		return ..()

	// for now, there are no items in the prize list, but this is ready for future implementation
	to_chat(usr, span_notice("The tome whispers that its pages remain empty, awaiting dark knowledge..."))
	return TRUE


/obj/machinery/mineral/equipment_vendor/fastfood/necromancy
	name = "Necromantic Grimoire"
	desc = "A sinister grimoire that trades necromantic knowledge and artifacts for the souls of the departed."
	icon_state = "mining"
	owner_needed = FALSE
	dispenses_dollars = FALSE
	prize_list = list(
		// Empty for now
	)

// NecromancyVendor.jsx in tgui/interfaces
/obj/machinery/mineral/equipment_vendor/fastfood/necromancy/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NecromancyVendor", name)
		ui.open()

/obj/machinery/mineral/equipment_vendor/fastfood/necromancy/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		.["user"]["souls"] = H.collected_souls
		.["user"]["name"] = "[H.name]"
		.["user"]["job"] = "[H.mind?.assigned_role]"
		.["user"]["has_necromancy"] = H.necromancy_knowledge
	else if(isliving(user))
		var/mob/living/L = user
		.["user"]["souls"] = L.collected_souls
		.["user"]["name"] = "[L.name]"
		.["user"]["job"] = "Unknown"
		.["user"]["has_necromancy"] = FALSE
	else
		.["user"]["souls"] = 0
		.["user"]["name"] = "Unknown"
		.["user"]["job"] = "Unknown"
		.["user"]["has_necromancy"] = FALSE

/obj/machinery/mineral/equipment_vendor/fastfood/necromancy/ui_act(action, params)
	if(action != "purchase")
		return ..()

	if(!isliving(usr))
		return

	var/mob/living/L = usr

	var/datum/data/mining_equipment/prize = locate(params["ref"]) in prize_list
	if(!prize || !(prize in prize_list))
		to_chat(usr, span_alert("Error: Invalid choice!"))
		flick(icon_deny, src)
		return

	if(prize.cost > L.collected_souls)
		to_chat(usr, span_alert("Error: Insufficient souls for [prize.equipment_name]! You need [prize.cost] souls."))
		flick(icon_deny, src)
		return

	// Deduct souls from purchase
	L.collected_souls -= prize.cost
	to_chat(usr, span_notice("The Bone Codex resonates with dark energy as it dispenses [prize.equipment_name]!"))
	new prize.equipment_path(loc)
	SSblackbox.record_feedback("nested tally", "necromancy_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
	return TRUE

// Remove the AltClick dollar dispensing
/obj/machinery/mineral/equipment_vendor/fastfood/necromancy/AltClick(mob/user)
	return

// Future implementation for soul-infused artifacts
/obj/machinery/mineral/equipment_vendor/fastfood/necromancy/attackby(obj/item/W, mob/user, params)
	// Placeholder for future soul artifact trading system
	// Could implement trading necromantic artifacts for souls here
	return ..()
