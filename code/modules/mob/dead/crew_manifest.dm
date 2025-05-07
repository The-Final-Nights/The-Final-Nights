/datum/crew_manifest

/datum/crew_manifest/ui_state(mob/user)
	return GLOB.always_state

/datum/crew_manifest/ui_status(mob/user, datum/ui_state/state)
	return (isnewplayer(user) || isobserver(user) || isAI(user) || ispAI(user)) ? UI_INTERACTIVE : UI_CLOSE

/datum/crew_manifest/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CrewManifest")
		ui.open()

/datum/crew_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if (..())
		return

/datum/crew_manifest/ui_data(mob/user)
	var/list/positions = list(
		"Camarilla" = 0,
		"Primogen Council" = 0,
		"Tremere" = 0,
		"Anarch" = 0,
		"Giovanni" = 0,
		"Clan Tzimisce" = 0,
		"Law Enforcement" = 0,
		"Warehouse" = 0,
		"Triad" = 0
	)
	var/list/departments = list(
		list("flag" = DEPARTMENT_CAMARILLA, "name" = "Camarilla"),
		list("flag" = DEPARTMENT_PRIMOGEN_COUNCIL, "name" = "Primogen Council"),
		list("flag" = DEPARTMENT_TREMERE, "name" = "Tremere"),
		list("flag" = DEPARTMENT_ANARCH, "name" = "Anarch"),
		list("flag" = DEPARTMENT_GIOVANNI, "name" = "Giovanni"),
		list("flag" = DEPARTMENT_CLAN_TZIMISCE, "name" = "Clan Tzimisce"),
		list("flag" = DEPARTMENT_LAW_ENFORCEMENT, "name" = "Law Enforcement"),
		list("flag" = DEPARTMENT_WAREHOUSE, "name" = "Warehouse"),
		list("flag" = DEPARTMENT_TRIAD, "name" = "Triad"),
	)

	for(var/job in SSjob.occupations)
		for(var/department in departments)
			// Check if the job is part of a department using its flag
			// Will return true for Research Director if the department is Science or Command, for example
			if(job["departments"] & department["flag"])
				// Add open positions to current department
				positions[department["name"]] += (job["total_positions"] - job["current_positions"])

	return list(
		"manifest" = GLOB.data_core.get_manifest(),
		"positions" = positions
	)
