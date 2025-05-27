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
		"Prince" = 0,
		"Primogen Council" = 0,
		"Camarilla" = 0,
		"Chantry" = 0,
		"Clinic" = 0,
		"Police" = 0,
		"Warehouse" = 0,
		"Giovanni" = 0,
		"Manor" = 0,
		"Endron" = 0,
		"Painted City" = 0,
		"Amberglade" = 0,
		"Citizen" = 0
	)
	var/list/departments = list(
		list("flag" = DEPARTMENT_PRINCE, "name" = "Prince"),
		list("flag" = DEPARTMENT_PRIMOGEN_COUNCIL, "name" = "Primogen Council"),
		list("flag" = DEPARTMENT_CAMARILLA, "name" = "Camarilla"),
		list("flag" = DEPARTMENT_TREMERE, "name" = "Chantry"),
		list("flag" = DEPARTMENT_CLINIC, "name" = "Clinic"),
		list("flag" = DEPARTMENT_POLICE, "name" = "Police"),
		list("flag" = DEPARTMENT_WAREHOUSE, "name" = "Warehouse"),
		list("flag" = DEPARTMENT_GIOVANNI, "name" = "Giovanni"),
		list("flag" = DEPARTMENT_MANOR, "name" = "Manor"),
		list("flag" = DEPARTMENT_ENDRON, "name" = "Endron"),
		list("flag" = DEPARTMENT_PAINTED_CITY, "name" = "Painted City"),
		list("flag" = DEPARTMENT_AMBERGLADE, "name" = "Amberglade"),
		list("flag" = DEPARTMENT_CITIZEN, "name" = "Citizen")
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
