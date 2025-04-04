/// Subsystem for character sheet management, other persistence features related to it. [key: UID -> value: sheet owner] for future reference
SUBSYSTEM_DEF(sheet_manager)
	name = "Sheet Manager"
	flags = SS_NO_INIT | SS_NO_FIRE
	var/datum/character_sheet/character_sheet
