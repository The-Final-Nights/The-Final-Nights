/obj/machinery/mineral/equipment_vendor/fastfood/occult
	owner_needed = FALSE
	desc = "Use your occult research to reap the benefits of safeguarded knowledge and artifacts."
	dispenses_dollars = FALSE

	// Stock tracking - each item starts with 2 in stock
	var/list/item_stock = list()

	prize_list = list(
	// SPELLBOOKS
	new /datum/data/mining_equipment("Lure of Flames Spellbook (Level I)",	/obj/item/path_spellbook/lure_of_flames/level1,	130),
	new /datum/data/mining_equipment("Lure of Flames Spellbook (Level II)",	/obj/item/path_spellbook/lure_of_flames/level2,	180),
	new /datum/data/mining_equipment("Lure of Flames Spellbook (Level III)",	/obj/item/path_spellbook/lure_of_flames/level3,	210),
	new /datum/data/mining_equipment("Lure of Flames Spellbook (Level IV)",	/obj/item/path_spellbook/lure_of_flames/level4,	240),
	new /datum/data/mining_equipment("Lure of Flames Spellbook (Level V)",	/obj/item/path_spellbook/lure_of_flames/level5,	270),

	new /datum/data/mining_equipment("Levinbolt Spellbook (Level I)",	/obj/item/path_spellbook/levinbolt/level1,	130),
	new /datum/data/mining_equipment("Levinbolt Spellbook (Level II)",	/obj/item/path_spellbook/levinbolt/level2,	180),
	new /datum/data/mining_equipment("Levinbolt Spellbook (Level III)",	/obj/item/path_spellbook/levinbolt/level3,	210),
	new /datum/data/mining_equipment("Levinbolt Spellbook (Level IV)",	/obj/item/path_spellbook/levinbolt/level4,	240),
	new /datum/data/mining_equipment("Levinbolt Spellbook (Level V)",	/obj/item/path_spellbook/levinbolt/level5, 270),

	// ARTIFACTS
	// Lower tier artifacts
	new /datum/data/mining_equipment("Weekapaug Thistle", /obj/item/vtm_artifact/weekapaug_thistle, 75),
	new /datum/data/mining_equipment("Mummywrap Fetish", /obj/item/vtm_artifact/mummywrap_fetish, 70),
	new /datum/data/mining_equipment("Galdjum", /obj/item/vtm_artifact/galdjum, 70),
	new /datum/data/mining_equipment("Bloodstar", /obj/item/vtm_artifact/bloodstar, 70),

	// Mid tier artifacts
	new /datum/data/mining_equipment("Fae Charm", /obj/item/vtm_artifact/fae_charm, 120),
	new /datum/data/mining_equipment("Daimonori", /obj/item/vtm_artifact/daimonori, 120),
	new /datum/data/mining_equipment("Key of Alamut", /obj/item/vtm_artifact/key_of_alamut, 130),
	new /datum/data/mining_equipment("Heart of Eliza", /obj/item/vtm_artifact/heart_of_eliza, 140),
	new /datum/data/mining_equipment("Bloodstone", /obj/item/vtm_artifact/bloodstone, 140),

	// High tier artifacts
	new /datum/data/mining_equipment("Odious Chalice", /obj/item/vtm_artifact/odious_chalice, 180),

	// Random artifact - priced as mid-tier since it's random
	new /datum/data/mining_equipment("Random Occult Artifact (50% chance of nothing)", /obj/item/vtm_artifact/rand, 60)
)

/obj/machinery/mineral/equipment_vendor/fastfood/occult/New()
	. = ..()
	//each item starts with 2 in stock
	for(var/datum/data/mining_equipment/prize in prize_list)
		item_stock[prize.equipment_path] = 2

/world/New()
	. = ..()
	GLOB.vending_products[/obj/item/path_spellbook/lure_of_flames/level1] = 1
	GLOB.vending_products[/obj/item/path_spellbook/lure_of_flames/level2] = 1
	GLOB.vending_products[/obj/item/path_spellbook/lure_of_flames/level3] = 1
	GLOB.vending_products[/obj/item/path_spellbook/lure_of_flames/level4] = 1
	GLOB.vending_products[/obj/item/path_spellbook/lure_of_flames/level5] = 1
	GLOB.vending_products[/obj/item/path_spellbook/levinbolt/level1] = 1
	GLOB.vending_products[/obj/item/path_spellbook/levinbolt/level2] = 1
	GLOB.vending_products[/obj/item/path_spellbook/levinbolt/level3] = 1
	GLOB.vending_products[/obj/item/path_spellbook/levinbolt/level4] = 1
	GLOB.vending_products[/obj/item/path_spellbook/levinbolt/level5] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/rand] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/odious_chalice] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/key_of_alamut] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/daimonori] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/bloodstar] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/heart_of_eliza] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/fae_charm] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/galdjum] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/mummywrap_fetish] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/weekapaug_thistle] = 1
	GLOB.vending_products[/obj/item/vtm_artifact/bloodstone] = 1

// Helper proc to check if the user isnt an Antitribu thaumaturge
/obj/machinery/mineral/equipment_vendor/fastfood/occult/proc/has_purchase_privileges(role)
	return (role in list("Chantry Regent", "Chantry Archivist", "Hound", "Sheriff", "Seneschal", "Prince"))

// Helper proc to find current Regent
/obj/machinery/mineral/equipment_vendor/fastfood/occult/proc/find_regent()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind?.assigned_role == "Chantry Regent")
			return H
	return null

// Helper proc to find all Archivists
/obj/machinery/mineral/equipment_vendor/fastfood/occult/proc/find_archivists()
	var/list/archivists = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind?.assigned_role == "Chantry Archivist")
			archivists += H
	return archivists

// Non-Chantry non-Camarilla Tremeres, when spending their research points, give 30% of their purchase to the Regent, or distributed among all archivists
/obj/machinery/mineral/equipment_vendor/fastfood/occult/proc/distribute_research_points(amount, purchaser_name, item_name)
	var/tribute_amount = round(amount * 0.3)
	var/mob/living/carbon/human/regent = find_regent()

	if(regent)
		regent.research_points += tribute_amount
		to_chat(regent, span_notice("The Archives channel [tribute_amount] research points to you from [purchaser_name]'s purchase of [item_name]."))
		return

	var/list/archivists = find_archivists()
	if(archivists.len > 0)
		var/points_per_archivist = round(tribute_amount / archivists.len)
		var/remaining_points = tribute_amount - (points_per_archivist * archivists.len)

		for(var/mob/living/carbon/human/archivist in archivists)
			var/points_to_give = points_per_archivist
			if(remaining_points > 0)
				points_to_give++
				remaining_points--
			archivist.research_points += points_to_give
			to_chat(archivist, span_notice("The Archives distribute [points_to_give] research points to you from [purchaser_name]'s purchase of [item_name]."))

// Proc to increase stock when an item is donated
/obj/machinery/mineral/equipment_vendor/fastfood/occult/proc/increment_stock(item_path)
	if(item_path in item_stock)
		item_stock[item_path]++
	else
		// Check if this item type should be tracked
		for(var/datum/data/mining_equipment/prize in prize_list)
			if(prize.equipment_path == item_path)
				item_stock[item_path] = 1
				break

// SpellbookVendor.jsx in tgui/interfaces
/obj/machinery/mineral/equipment_vendor/fastfood/occult/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpellbookVendor", name)
		ui.open()

/obj/machinery/mineral/equipment_vendor/fastfood/occult/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		.["user"]["points"] = H.research_points
		.["user"]["name"] = "[H.name]"
		.["user"]["job"] = "[H.mind?.assigned_role]"
		.["user"]["has_thaumaturgy"] = HAS_TRAIT(H, TRAIT_THAUMATURGY_KNOWLEDGE)
		.["user"]["has_necromancy"] = H.necromancy_knowledge
		.["user"]["is_regent"] = (H.mind?.assigned_role == "Chantry Regent")
		.["user"]["has_privileges"] = has_purchase_privileges(H.mind?.assigned_role)
	else
		.["user"]["points"] = 0
		.["user"]["name"] = "Unknown"
		.["user"]["job"] = "Unknown"
		.["user"]["has_thaumaturgy"] = FALSE
		.["user"]["has_necromancy"] = FALSE
		.["user"]["is_regent"] = FALSE
		.["user"]["has_privileges"] = FALSE

	.["tremere_members"] = list()
	for(var/mob/living/carbon/human/tremere_member in GLOB.human_list)
		if(!tremere_member.mind)
			continue
		var/role = tremere_member.mind.assigned_role
		if(role in list("Chantry Archivist", "Chantry Gargoyle", "Chantry Regent"))
			.["tremere_members"] += list(list(
				"name" = tremere_member.name,
				"role" = role,
				"points" = tremere_member.research_points,
				"ref" = "\ref[tremere_member]"
			))


	.["product_records"] = list()
	for(var/datum/data/mining_equipment/prize in prize_list)
		var/stock_count = item_stock[prize.equipment_path] || 0
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.equipment_path]", "/obj/item/", ""), "/", "-"),
			name = prize.equipment_name,
			cost = prize.cost,
			ref = REF(prize),
			stock = stock_count,
			available = (stock_count > 0)
		)
		.["product_records"] += list(product_data)

/obj/machinery/mineral/equipment_vendor/fastfood/occult/ui_act(action, params)
	if(action == "transfer_points")
		return handle_point_transfer(action, params)
	if(action == "seize_points")
		return handle_point_seizure(action, params)
	if(action != "purchase")
		return ..()

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if(istype(H.dna.species, /datum/species/human))
		return

	var/datum/data/mining_equipment/prize = locate(params["ref"]) in prize_list
	if(!prize || !(prize in prize_list))
		to_chat(usr, span_alert("Error: Invalid choice!"))
		return

	// Check stock
	var/current_stock = item_stock[prize.equipment_path] || 0
	if(current_stock <= 0)
		to_chat(usr, span_alert("Error: [prize.equipment_name] is out of stock!"))
		return

	if(prize.cost > H.research_points)
		to_chat(usr, span_alert("Error: Insufficient research points for [prize.equipment_name]! You need [prize.cost] research points."))
		return

	// Deduct research points from purchaser
	H.research_points -= prize.cost

	// Check if user is loyal to the chantry/camarilla - if not, award 30% tribute to leadership
	var/user_role = H.mind?.assigned_role
	var/has_privileges = has_purchase_privileges(user_role)

	if(!has_privileges)
		distribute_research_points(prize.cost, H.name, prize.equipment_name)
		to_chat(usr, span_notice("A portion of your research points flow through the Archives to the Chantry leadership as tribute."))

	// Reduce stock
	item_stock[prize.equipment_path]--

	to_chat(usr, span_notice("The Archives emanate dark energy as it dispenses [prize.equipment_name]!"))
	new prize.equipment_path(loc)
	SSblackbox.record_feedback("nested tally", "mining_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
	return TRUE

//transfer research points
/obj/machinery/mineral/equipment_vendor/fastfood/occult/proc/handle_point_transfer(action, params)
	if(!ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/sender = usr
	var/target_ref = params["target_ref"]
	var/amount = text2num(params["amount"])

	if(!target_ref || !amount || amount <= 0)
		to_chat(sender, span_alert("Error: Invalid transfer parameters!"))
		return FALSE

	if(amount > sender.research_points)
		to_chat(sender, span_alert("Error: You don't have enough research points!"))
		return FALSE

	var/mob/living/carbon/human/target = locate(target_ref)
	if(!target || !ishuman(target))
		to_chat(sender, span_alert("Error: Target not found!"))
		return FALSE

	// Verify target is still a valid Tremere member
	if(!(target.mind?.assigned_role in list("Chantry Archivist", "Chantry Gargoyle", "Chantry Regent")))
		to_chat(sender, span_alert("Error: Target is no longer a valid recipient!"))
		return FALSE

	// Perform the transfer
	sender.research_points -= amount
	target.research_points += amount

	to_chat(sender, span_notice("You transfer [amount] research points to [target.name] through the Archives' dark conduits."))
	to_chat(target, span_notice("The Archives whisper to you... [sender.name] has sent you [amount] research points."))

	return TRUE

//research point seizure
/obj/machinery/mineral/equipment_vendor/fastfood/occult/proc/handle_point_seizure(action, params)
	if(!ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/regent = usr

	if(regent.mind?.assigned_role != "Chantry Regent")
		to_chat(regent, span_alert("Error: Only the Regent may exercise such authority!"))
		return FALSE

	var/target_ref = params["target_ref"]
	var/amount = text2num(params["amount"])

	if(!target_ref || !amount || amount <= 0)
		to_chat(regent, span_alert("Error: Invalid seizure parameters!"))
		return FALSE

	var/mob/living/carbon/human/target = locate(target_ref)
	if(!target || !ishuman(target))
		to_chat(regent, span_alert("Error: Target not found!"))
		return FALSE

	// verify target is a valid Tremere member
	if(!(target.mind?.assigned_role in list("Chantry Archivist", "Chantry Gargoyle", "Chantry Regent")))
		to_chat(regent, span_alert("Error: Target is not a Tremere clan member!"))
		return FALSE

	var/actual_amount = min(amount, target.research_points)

	if(actual_amount <= 0)
		to_chat(regent, span_alert("Error: Target has no research points to seize!"))
		return FALSE

	target.research_points -= actual_amount
	regent.research_points += actual_amount

	to_chat(regent, span_notice("By your authority as Regent, you seize [actual_amount] research points from [target.name] through the Archives."))
	to_chat(target, span_warning("The Archives grow cold... Regent [regent.name] has seized [actual_amount] of your research points by right of authority."))

	return TRUE

// Remove the AltClick dollar dispensing
/obj/machinery/mineral/equipment_vendor/fastfood/occult/AltClick(mob/user)
	return

//offer artifacts to the shop for research points AND increment stock
/obj/machinery/mineral/equipment_vendor/fastfood/occult/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/vtm_artifact))
		var/obj/item/vtm_artifact/artifact = W

		if(!ishuman(user))
			to_chat(user, span_warning("The Archives reject your offering."))
			return

		var/mob/living/carbon/human/H = user

		if(artifact.research_value <= 0)
			to_chat(user, span_warning("The Archives find no value in this artifact."))
			return

		H.research_points += artifact.research_value

		increment_stock(artifact.type)

		//when donating an artifact, increase stock of a random spellbook
		increment_stock(pick(
			/obj/item/path_spellbook/lure_of_flames/level1,
			/obj/item/path_spellbook/lure_of_flames/level2,
			/obj/item/path_spellbook/lure_of_flames/level3,
			/obj/item/path_spellbook/lure_of_flames/level4,
			/obj/item/path_spellbook/lure_of_flames/level5,
			/obj/item/path_spellbook/levinbolt/level1,
			/obj/item/path_spellbook/levinbolt/level2,
			/obj/item/path_spellbook/levinbolt/level3,
			/obj/item/path_spellbook/levinbolt/level4,
			/obj/item/path_spellbook/levinbolt/level5))

		if(artifact.research_value >= 20)
			to_chat(user, span_nicegreen("The Archives hungrily consume the powerful artifact, granting you [artifact.research_value] research points and adding it to their collection!"))
		else if(artifact.research_value >= 10)
			to_chat(user, span_notice("The Archives absorb the artifact's essence, granting you [artifact.research_value] research points and cataloging its knowledge."))
		else
			to_chat(user, span_notice("The Archives reluctantly accept the minor artifact, granting you [artifact.research_value] research points and filing it away."))

		qdel(artifact)
		return TRUE

	if(istype(W, /obj/item/path_spellbook))
		var/obj/item/path_spellbook/spellbook = W

		if(!ishuman(user))
			to_chat(user, span_warning("The Archives reject your offering."))
			return

		var/mob/living/carbon/human/H = user

		var/research_reward = 5 // base reward modified by spellbook
		H.research_points += research_reward

		increment_stock(spellbook.type)

		to_chat(user, span_notice("The Archives accept your spellbook, granting you [research_reward] research points and adding its knowledge to the collection."))

		qdel(spellbook)
		return TRUE

	return ..()
