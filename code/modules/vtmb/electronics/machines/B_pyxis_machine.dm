
#define PYXIS_SOUND_LOGIN 'sound/machines/terminal_success.ogg'
#define PYXIS_SOUND_LOGOUT 'sound/machines/terminal_off.ogg'
#define PYXIS_SOUND_DISPENSE 'sound/machines/terminal_insert_disc.ogg'
#define PYXIS_SOUND_RESTOCK 'sound/machines/click.ogg'
#define PYXIS_SOUND_MONEY 'sound/machines/ping.ogg'
#define PYXIS_SOUND_ERROR 'sound/machines/buzz-sigh.ogg'
#define PYXIS_SOUND_WARNING 'sound/machines/warning-buzzer.ogg'

#define PYXIS_SESSION_TIMEOUT (5 MINUTES)
#define PYXIS_MAX_STOCK 15
#define PYXIS_RESTOCK_AMOUNT 5
#define PYXIS_BULK_DISCOUNT 0.9
#define PYXIS_LOW_STOCK_THRESHOLD 5

/obj/clinic_machine
	name = "clinic machine"
	desc = "A medical facility machine."
	icon = 'code/modules/wod13/props.dmi'
	density = TRUE
	anchored = TRUE

/obj/clinic_machine/Initialize(mapload)
	. = ..()


/obj/clinic_machine/pyxis
	name = "Pyxis MedStation - St. John's Community Clinic"
	desc = "An automated medication and supply dispensing terminal. For authorized clinical use only."
	icon_state = "pyxis"
	var/logged_in = FALSE
	var/obj/item/card/id/scan = null
	var/mob/living/current_user = null
	var/session_started = 0
	var/user_access = 0
	var/list/machine_stock = list()
	var/list/cart = list()
	var/stored_money = 0
	var/list/transaction_log = list()
	var/list/access_override_log = list()
	var/list/emergency_mode_log = list()
	var/emergency_mode = FALSE
	var/selected_category = CLINIC_CATEGORY_MEDICAL
	var/selected_reason = null
	var/dispensing_notes = ""
	var/patient_name = ""
	var/list/category_overrides = list()
	var/list/ui_messages = list()
	var/static/list/icon_cache = list()

/obj/clinic_machine/pyxis/Initialize(mapload)
	. = ..()
	machine_stock = GLOB.CLINIC_stock.Copy()
	START_PROCESSING(SSobj, src)

/obj/clinic_machine/pyxis/process(seconds_per_tick)
	if(logged_in && (world.time - session_started) > PYXIS_SESSION_TIMEOUT)
		logout_user()

/obj/clinic_machine/pyxis/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	ui_interact(user)

/obj/clinic_machine/pyxis/proc/validate_user_action(require_login = TRUE, require_access_level = 0)
	if(require_login && !logged_in)
		add_message("User authentication required.", TRUE)
		return FALSE

	if(require_access_level && user_access < require_access_level)
		add_message("Insufficient access level for this operation.", TRUE)
		return FALSE

	return TRUE

/obj/clinic_machine/pyxis/proc/validate_stock_item(category, id)
	if(!category || !machine_stock[category])
		return FALSE

	var/item_id = istext(id) ? text2num(id) : id
	if(item_id < 1 || item_id > length(machine_stock[category]))
		return FALSE

	return item_id

/obj/clinic_machine/pyxis/proc/add_message(message, is_error = FALSE)
	var/formatted_message = is_error ? "System Alert: [message]" : message
	ui_messages += formatted_message
	playsound(src, is_error ? PYXIS_SOUND_ERROR : 'sound/machines/click.ogg', 30, TRUE)

// Creates a standardized log entry
/obj/clinic_machine/pyxis/proc/create_log_entry(type, extra_data = null)
	var/list/entry = list(
		"timestamp" = SScity_time.timeofnight,
		"type" = type,
		"user" = scan?.registered_name || "Unknown",
		"user_job" = get_obfuscated_job(scan?.assignment)
	)

	if(extra_data)
		entry += extra_data

	return entry

// Adds transaction log and handles special log types
/obj/clinic_machine/pyxis/proc/log_transaction(type, extra_data = null)
	var/list/entry = create_log_entry(type, extra_data)
	transaction_log += list(entry)

// Gets cached icon for item type
/obj/clinic_machine/pyxis/proc/get_item_icon(item_path)
	if(!icon_cache[item_path])
		var/atom/temp = new item_path
		icon_cache[item_path] = icon2base64(icon(temp.icon, temp.icon_state))
		qdel(temp)
	return icon_cache[item_path]

// Logs out user and resets session
/obj/clinic_machine/pyxis/proc/logout_user()
	if(!logged_in)
		return

	if(scan)
		log_transaction("logout")

	reset_session_state()
	playsound(src, PYXIS_SOUND_LOGOUT, 30, TRUE)

// Resets all session variables
/obj/clinic_machine/pyxis/proc/reset_session_state()
	logged_in = FALSE
	current_user = null
	scan = null
	session_started = 0
	user_access = 0
	selected_reason = null
	dispensing_notes = ""
	patient_name = ""
	cart.Cut()
	category_overrides.Cut()

// Checks category access
/obj/clinic_machine/pyxis/proc/has_category_access(category)
	if(!scan?.assignment)
		return emergency_mode
	return CLINIC_has_category_access(scan.assignment, category) || emergency_mode || (category in category_overrides)

// Gets available tabs based on user access
/obj/clinic_machine/pyxis/proc/get_available_tabs()
	var/list/tabs = list()

	// Requisition tab - always available when logged in
	tabs += list(list("key" = "requisition", "label" = "Requisition"))

	// Logs tab - available for medical access and above
	if(user_access >= CLINIC_ACCESS_MEDICAL)
		tabs += list(list("key" = "logs", "label" = "Logs"))

	// Restock tab - available for full access and above
	if(user_access >= CLINIC_ACCESS_FULL)
		tabs += list(list("key" = "restock", "label" = "Restock"))

	// Admin tab - available for admin access only
	if(user_access >= CLINIC_ACCESS_ADMIN)
		tabs += list(list("key" = "admin", "label" = "Admin"))

	return tabs

// Checks if dispensing should be disabled
/obj/clinic_machine/pyxis/proc/is_dispense_disabled()
	if(!length(cart))
		return TRUE
	if(has_controlled_in_cart() && (!selected_reason || !patient_name))
		return TRUE
	return FALSE

/obj/clinic_machine/pyxis/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/card/id))
		handle_id_scan(item, user)
		return
	if(istype(item, /obj/item/stack/dollar))
		handle_money_deposit(item, user)
		return
	return ..()

// Handles ID card authentication
/obj/clinic_machine/pyxis/proc/handle_id_scan(obj/item/card/id/id_card, mob/user)
	var/job = id_card.assignment
	if(!GLOB.CLINIC_job_access[job])
		add_message("User authentication failed. Authorized clinical staff only.", TRUE)
		ui_interact(user)
		return

	scan = id_card
	current_user = user
	logged_in = TRUE
	session_started = world.time
	user_access = GLOB.CLINIC_job_access[job]

	add_message("Authentication successful. Welcome, [scan.registered_name]. Pyxis MedStation ready for use.")
	playsound(src, PYXIS_SOUND_LOGIN, 30, TRUE)
	log_transaction("login")
	ui_interact(user)

// Handles money deposits
/obj/clinic_machine/pyxis/proc/handle_money_deposit(obj/item/stack/dollar/dollars, mob/user)
	stored_money += dollars.amount
	add_message("[dollars.amount] dollars added to MedStation account. Current balance: [stored_money] dollars.")
	playsound(src, PYXIS_SOUND_MONEY, 30, TRUE)

	log_transaction("deposit", list("amount" = dollars.amount, "balance" = stored_money))
	qdel(dollars)
	ui_interact(user)

/obj/clinic_machine/pyxis/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Pyxis", name)
		ui.open()

/obj/clinic_machine/pyxis/ui_data(mob/user)
	var/list/data = list(
		"banner" = "<b>Pyxis MedStation</b><br>St. John's Community Clinic<br><i>Automated Medication & Supply Dispensing</i>",
		"reminder" = "This system is for authorized clinical use only. All transactions are logged. Please return unused items to inventory.",
		"logged_in" = logged_in,
		"emergency_mode" = emergency_mode,
		"stored_money" = stored_money,
		"messages" = ui_messages.Copy()
	)

	if(!logged_in)
		return data

	// User info
	if(scan)
		data["user_name"] = scan.registered_name
		data["user_job"] = get_obfuscated_job(scan.assignment)
		data["user_access"] = user_access
	else
		data["user_name"] = "Unknown"
		data["user_job"] = "Unknown"
		data["user_access"] = 0

	// Available tabs based on access
	data["available_tabs"] = get_available_tabs()

	// Categories and items
	data["categories"] = build_categories_list()
	data["selected_category"] = selected_category
	data["items"] = build_items_list()
	data["category_access"] = has_category_access(selected_category)

	// Cart
	data["cart"] = build_cart_list()
	data["has_controlled"] = has_controlled_in_cart()
	data["reasons"] = GLOB.CLINIC_reasons
	data["selected_reason"] = selected_reason
	data["notes"] = dispensing_notes
	data["patient_name"] = patient_name
	data["dispense_disabled"] = is_dispense_disabled()

	// Admin
	data["is_admin"] = (user_access == CLINIC_ACCESS_ADMIN)
	data["restock_items"] = build_restock_list()

	// Logs - formatted for UI
	data["logs"] = build_formatted_logs()

	// Access override
	data["category_overrides"] = category_overrides
	data["can_override"] = (logged_in && scan && user_access >= CLINIC_ACCESS_BASIC)
	data["category_access_override"] = (selected_category in category_overrides)

	return data

// Builds categories list - JSX will handle icons
/obj/clinic_machine/pyxis/proc/build_categories_list()
	var/list/categories = list()

	for(var/category in machine_stock)
		categories += list(list("name" = category))

	return categories

// Builds items list for selected category
/obj/clinic_machine/pyxis/proc/build_items_list()
	var/list/items = list()

	if(!selected_category || !machine_stock[selected_category])
		return items

	var/has_access = has_category_access(selected_category)

	for(var/item_index in 1 to length(machine_stock[selected_category]))
		var/list/item_data = machine_stock[selected_category][item_index]
		var/stock = item_data["stock"]
		items += list(list(
			"id" = item_index,
			"name" = item_data["name"],
			"stock" = stock,
			"restricted" = (GLOB.CLINIC_category_access[selected_category] > CLINIC_ACCESS_BASIC),
			"path" = item_data["path"],
			"has_access" = has_access,
			"disabled" = (stock <= 0 || !has_access),
			"icon" = get_item_icon(item_data["path"])
		))

	return items

// Builds cart list
/obj/clinic_machine/pyxis/proc/build_cart_list()
	var/list/cart_data = list()

	for(var/cart_index in 1 to length(cart))
		var/list/cart_item = cart[cart_index]
		cart_data += list(list(
			"id" = cart_index,
			"name" = cart_item["name"],
			"category" = cart_item["category"],
			"amount" = cart_item["amount"],
			"icon" = get_item_icon(cart_item["path"])
		))

	return cart_data

// Builds restock list
/obj/clinic_machine/pyxis/proc/build_restock_list()
	var/list/restock_data = list()
	var/unique_id = 1

	for(var/category in machine_stock)
		for(var/item_index in 1 to length(machine_stock[category]))
			var/list/item_data = machine_stock[category][item_index]
			var/current_stock = item_data["stock"]
			if(current_stock < PYXIS_LOW_STOCK_THRESHOLD)
				var/restock_amount = min(PYXIS_RESTOCK_AMOUNT, PYXIS_MAX_STOCK - current_stock)
				var/cost = calculate_restock_cost(category, item_index, current_stock)
				restock_data += list(list(
					"id" = unique_id,
					"item_index" = item_index,
					"name" = item_data["name"],
					"category" = category,
					"stock" = current_stock,
					"cost" = cost,
					"base_cost" = item_data["cost"],
					"restock_amount" = restock_amount,
					"disabled" = (stored_money < cost || restock_amount <= 0),
					"icon" = get_item_icon(item_data["path"])
				))
				unique_id++

	return restock_data

// Builds formatted logs for UI
/obj/clinic_machine/pyxis/proc/build_formatted_logs()
	var/list/formatted_logs = list()
	var/list/all_logs = list()

	for(var/entry in transaction_log)
		var/list/log_entry = list(
			"timestamp" = entry["timestamp"],
			"user" = "[entry["user"]] ([entry["user_job"]])",
			"type" = entry["type"],
			"details" = format_log_details(entry)
		)
		all_logs += list(log_entry)

	formatted_logs["all"] = all_logs
	return formatted_logs

// Formats log entry details for display
/obj/clinic_machine/pyxis/proc/format_log_details(list/entry)
	switch(entry["type"])
		if("login")
			return "Logged in"
		if("logout")
			return "Logged out"
		if("dispense")
			var/list/items = entry["items"]
			var/details = "Items dispensed for patient: [entry["patient"]]"
			if(entry["reason"])
				details += " - Reason: [entry["reason"]]"
			if(length(items))
				details += " - Items: "
				for(var/item_index in 1 to length(items))
					var/list/item = items[item_index]
					details += "[item["amount"]]x [item["name"]]"
					if(item_index < length(items))
						details += ", "
			return details
		if("restock")
			return "Restocked [entry["item"]] ([entry["old_stock"]] → [entry["new_stock"]]) - $[entry["cost"]]"
		if("deposit")
			return "Added $[entry["amount"]]. New balance: $[entry["balance"]]"
		if("override")
			var/details = "Override for [entry["category"]] by [entry["physician"]] - Reason: [entry["reason"]]"
			if(entry["deactivated"])
				details += " (Deactivated by [entry["deactivated_by"]] at [entry["deactivated_time"]])"
			return details
		if("emergency_mode")
			var/details = "Emergency mode [entry["status"] || "activated"]"
			if(entry["deactivated"])
				details += " (Deactivated by [entry["deactivated_by"]] at [entry["deactivated_time"]])"
			return details
		else
			return "Unknown action"

// Calculates restock cost
/obj/clinic_machine/pyxis/proc/calculate_restock_cost(category, id, current_stock, restock_amount = PYXIS_RESTOCK_AMOUNT)
	var/item_id = validate_stock_item(category, id)
	if(!item_id)
		return 0

	var/list/item_data = machine_stock[category][item_id]
	var/actual_restock = min(restock_amount, PYXIS_MAX_STOCK - current_stock)

	if(actual_restock <= 0)
		return 0

	var/discount_factor = actual_restock >= PYXIS_RESTOCK_AMOUNT ? PYXIS_BULK_DISCOUNT : 1.0
	return round(item_data["cost"] * actual_restock * discount_factor)

// Checks for controlled substances in cart
/obj/clinic_machine/pyxis/proc/has_controlled_in_cart()
	for(var/item in cart)
		if(item["category"] == CLINIC_CATEGORY_CONTROLLED)
			return TRUE
	return FALSE

// Gets obfuscated job title
/obj/clinic_machine/pyxis/proc/get_obfuscated_job(job_title)
	if(!job_title)
		return "Unknown"
	if(job_title == "Malkavian Primogen")
		return "Patron"
	return job_title

// UI Actions handler
/obj/clinic_machine/pyxis/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	// Reset session timeout
	if(logged_in)
		session_started = world.time

	switch(action)
		if("logout")
			logout_user()
			return TRUE
		if("select_category")
			selected_category = params["category"]
			return TRUE
		if("add_to_cart")
			return handle_add_to_cart(params)
		if("remove_from_cart")
			return handle_remove_from_cart(params)
		if("clear_cart")
			cart.Cut()
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 20, TRUE)
			return TRUE
		if("select_reason")
			selected_reason = params["reason"]
			return TRUE
		if("set_notes")
			dispensing_notes = params["notes"]
			return TRUE
		if("set_patient_name")
			patient_name = params["name"]
			return TRUE
		if("dispense")
			return handle_dispense()
		if("restock")
			return handle_restock(params)
		if("toggle_emergency")
			return handle_toggle_emergency()
		if("scan_id")
			return handle_scan_id()
		if("set_access_override")
			return handle_access_override(params)
		if("deactivate_override")
			return handle_deactivate_override(params)
		if("acknowledge_messages")
			ui_messages.Cut()
			return TRUE

// Handles adding items to cart
/obj/clinic_machine/pyxis/proc/handle_add_to_cart(list/params)
	if(!validate_user_action())
		return FALSE

	var/category = selected_category
	var/item_id = validate_stock_item(category, params["id"])
	if(!item_id)
		return FALSE

	if(!has_category_access(category))
		add_message("Access denied to [category]. User not authorized for dispensing.", TRUE)
		return FALSE

	var/list/item = machine_stock[category][item_id]
	if(item["stock"] < 1)
		add_message("[item["name"]] is out of stock. Please request restock from inventory manager.", TRUE)
		return FALSE

	// Add to cart or increment existing
	for(var/cart_item in cart)
		if(cart_item["name"] == item["name"] && cart_item["category"] == category)
			cart_item["amount"]++
			playsound(src, 'sound/machines/click.ogg', 20, TRUE)
			return TRUE

	cart += list(list(
		"name" = item["name"],
		"path" = item["path"],
		"category" = category,
		"amount" = 1
	))
	playsound(src, 'sound/machines/click.ogg', 20, TRUE)
	return TRUE

// Handles removing items from cart
/obj/clinic_machine/pyxis/proc/handle_remove_from_cart(list/params)
	var/id = text2num(params["id"])
	if(id < 1 || id > length(cart))
		return FALSE

	var/list/item = cart[id]
	if(item["amount"] > 1)
		item["amount"]--
	else
		cart.Cut(id, id + 1)

	playsound(src, 'sound/machines/click.ogg', 20, TRUE)
	return TRUE

// Handles dispensing items
/obj/clinic_machine/pyxis/proc/handle_dispense()
	if(!validate_user_action() || !current_user)
		return FALSE

	if(!length(cart))
		add_message("Cart is empty. Please add items before dispensing.", TRUE)
		return FALSE

	var/has_controlled = has_controlled_in_cart()
	if(has_controlled && (!selected_reason || !patient_name))
		add_message("Dispensing of controlled substances requires a reason and patient name.", TRUE)
		return FALSE

	if(dispense_items())
		playsound(src, PYXIS_SOUND_DISPENSE, 40, TRUE)
		return TRUE
	return FALSE

// Dispenses cart items
/obj/clinic_machine/pyxis/proc/dispense_items()
	var/list/dispensed_items = list()

	for(var/cart_item in cart)
		var/item_name = cart_item["name"]
		var/item_path = cart_item["path"]
		var/item_category = cart_item["category"]
		var/amount = cart_item["amount"]

		// Find and update stock
		for(var/stock_item in machine_stock[item_category])
			if(stock_item["name"] == item_name)
				amount = min(amount, stock_item["stock"])
				if(amount <= 0)
					continue
				stock_item["stock"] -= amount
				dispensed_items += list(list(
					"name" = item_name,
					"amount" = amount,
					"category" = item_category
				))
				// Spawn items
				for(var/spawn_index in 1 to amount)
					new item_path(get_step(src, src.dir))
				break

	// Log and reset
	log_transaction("dispense", list(
		"items" = dispensed_items,
		"patient" = patient_name,
		"reason" = selected_reason,
		"notes" = dispensing_notes,
		"override" = (selected_category in category_overrides) ? category_overrides[selected_category] : null
	))

	cart.Cut()
	selected_reason = null
	dispensing_notes = ""
	patient_name = ""
	add_message("Dispensation complete. Please remove items from MedStation tray.")
	return TRUE

// Handles restocking
/obj/clinic_machine/pyxis/proc/handle_restock(list/params)
	if(!validate_user_action())
		return FALSE

	var/restock_id = text2num(params["id"])
	if(!restock_id)
		return FALSE

	// Find the restock item by its unique ID
	var/list/restock_items = build_restock_list()
	var/list/target_item = null

	for(var/restock_item in restock_items)
		if(restock_item["id"] == restock_id)
			target_item = restock_item
			break

	if(!target_item)
		add_message("Restock item not found.", TRUE)
		return FALSE

	var/category = target_item["category"]
	var/item_index = target_item["item_index"]
	var/list/item_data = machine_stock[category][item_index]
	var/current_stock = item_data["stock"]
	var/cost = target_item["cost"]

	if(stored_money < cost)
		add_message("Insufficient funds to restock [item_data["name"]].", TRUE)
		return FALSE

	var/restock_amount = min(PYXIS_RESTOCK_AMOUNT, PYXIS_MAX_STOCK - current_stock)
	if(restock_amount <= 0)
		add_message("[item_data["name"]] already at maximum stock level.", TRUE)
		return FALSE

	// Update stock and money
	var/old_stock = current_stock
	item_data["stock"] += restock_amount
	stored_money -= cost

	log_transaction("restock", list(
		"item" = item_data["name"],
		"category" = category,
		"old_stock" = old_stock,
		"new_stock" = item_data["stock"],
		"amount" = restock_amount,
		"cost" = cost,
		"base_cost" = item_data["cost"]
	))

	add_message("Restocked [restock_amount] [item_data["name"]] for [cost] dollars. Inventory updated.")
	playsound(src, PYXIS_SOUND_RESTOCK, 30, TRUE)
	return TRUE

// Handles emergency mode toggle
/obj/clinic_machine/pyxis/proc/handle_toggle_emergency()
	if(!validate_user_action(TRUE, CLINIC_ACCESS_ADMIN))
		return FALSE

	emergency_mode = !emergency_mode
	playsound(src, emergency_mode ? PYXIS_SOUND_WARNING : 'sound/machines/terminal_off.ogg', 50, TRUE)

	if(emergency_mode)
		log_transaction("emergency_mode", list("status" = "activated"))
	else
		// Find the most recent emergency_mode log entry and update it
		for(var/i = length(transaction_log); i >= 1; i--)
			var/list/entry = transaction_log[i]
			if(entry["type"] == "emergency_mode" && !entry["deactivated"])
				entry["deactivated"] = TRUE
				entry["deactivated_by"] = scan?.registered_name || "Unknown"
				entry["deactivated_time"] = SScity_time.timeofnight
				break

	return TRUE

// Handles ID scanning from UI
/obj/clinic_machine/pyxis/proc/handle_scan_id()
	var/mob/user = usr
	if(!user)
		add_message("No user detected.", TRUE)
		return TRUE

	var/obj/item/card/id/id_card = user.get_active_held_item()
	if(!istype(id_card) && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		id_card = human_user.wear_id?.GetID()

	if(!id_card)
		add_message("No ID card detected. Please present a valid ID card.", TRUE)
		return TRUE

	var/job = id_card.assignment
	if(!GLOB.CLINIC_job_access[job])
		add_message("User authentication failed. Authorized clinical staff only.", TRUE)
		return TRUE

	// Set authentication
	user_access = GLOB.CLINIC_job_access[job]
	logged_in = TRUE
	session_started = world.time
	scan = id_card
	current_user = user

	log_transaction("login")
	add_message("Authentication successful. Welcome, [id_card.registered_name]. Pyxis MedStation ready for use.")
	playsound(src, PYXIS_SOUND_LOGIN, 30, TRUE)
	return TRUE

// Handles access override
/obj/clinic_machine/pyxis/proc/handle_access_override(list/params)
	if(!validate_user_action(TRUE, CLINIC_ACCESS_BASIC))
		return FALSE

	var/physician = params["physician"]
	var/reason = params["reason"]
	var/category = params["category"]

	if(!physician || !reason || !category)
		add_message("Authorizing physician name, reason, and category are required for access override.", TRUE)
		return FALSE

	if(category in category_overrides)
		add_message("Access override already active for [category].", TRUE)
		return FALSE

	category_overrides[category] = list("physician" = physician, "reason" = reason)
	log_transaction("override", list("physician" = physician, "reason" = reason, "category" = category))
	add_message("Access override activated for [category]. Authorized by: [physician].")
	playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 30, TRUE)
	return TRUE

// Handles deactivating access override for a specific category
/obj/clinic_machine/pyxis/proc/handle_deactivate_override(list/params)
	if(!validate_user_action(TRUE, CLINIC_ACCESS_BASIC))
		return FALSE

	var/category = params["category"]
	if(!category || !(category in category_overrides))
		add_message("No active override found for [category].", TRUE)
		return FALSE

	// Find the most recent override log entry for this category and update it
	for(var/i = length(transaction_log); i >= 1; i--)
		var/list/entry = transaction_log[i]
		if(entry["type"] == "override" && entry["category"] == category && !entry["deactivated"])
			entry["deactivated"] = TRUE
			entry["deactivated_by"] = scan?.registered_name || "Unknown"
			entry["deactivated_time"] = SScity_time.timeofnight
			break

	category_overrides.Remove(category)
	add_message("Access override deactivated for [category].")
	playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 30, TRUE)
	return TRUE

// Clean up defines
#undef PYXIS_SOUND_LOGIN
#undef PYXIS_SOUND_LOGOUT
#undef PYXIS_SOUND_DISPENSE
#undef PYXIS_SOUND_RESTOCK
#undef PYXIS_SOUND_MONEY
#undef PYXIS_SOUND_ERROR
#undef PYXIS_SOUND_WARNING
#undef PYXIS_SESSION_TIMEOUT
#undef PYXIS_MAX_STOCK
#undef PYXIS_RESTOCK_AMOUNT
#undef PYXIS_BULK_DISCOUNT
#undef PYXIS_LOW_STOCK_THRESHOLD
