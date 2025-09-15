/datum/aboutme_record/proc/get_ui_overview_data(mob/living/carbon/human/owner)
	var/list/general = list(
		"name" = (edit_display_name && edit_display_name != "") ? edit_display_name : (owner?.real_name || "Unknown"),
		"role" = owner?.mind?.assigned_role || "Unknown",
		"species" = owner?.dna?.species?.name || "Unknown",
		"gender" = edit_gender || "",
		"physical_desc" = edit_physical_desc || "",
		"goals" = edit_goals || "",
		"personal_quote" = edit_personal_quote || ""
	)
	if (owner?.bank_id && islist(GLOB.bank_account_list))
		var/datum/vtm_bank_account/account = null
		for (var/datum/vtm_bank_account/A in GLOB.bank_account_list)
			if (A?.bank_id == owner.bank_id)
				account = A
				break
		if (account && account?.account_owner == owner.real_name && account?.code)
			general["bank_account_code"] = account.code
		else
			general["bank_account_code"] = "N/A"
	var/role = general["role"]
	var/obj/keypad/armory/armory = find_keypad(/obj/keypad/armory)
	if (armory && (role in list("Prince", "Sheriff", "Seneschal")))
		general["armory_code"] = armory.pincode
	var/obj/keypad/panic_room/panic = find_keypad(/obj/keypad/panic_room)
	if (panic && (role in list("Prince", "Seneschal")))
		general["panic_room_code"] = panic.pincode
	var/obj/structure/vaultdoor/pincode/bank/bankdoor = find_door_pin(/obj/structure/vaultdoor/pincode/bank)
	if (bankdoor && role == "Capo")
		general["bank_vault_code"] = bankdoor.pincode
	var/list/stats = list()
	if (hascall(owner, "get_total_physique"))    stats["Physique"]    = owner.get_total_physique()
	if (hascall(owner, "get_total_dexterity"))   stats["Dexterity"]   = owner.get_total_dexterity()
	if (hascall(owner, "get_total_social"))      stats["Social"]      = owner.get_total_social()
	if (hascall(owner, "get_total_mentality"))   stats["Mentality"]   = owner.get_total_mentality()
	if (hascall(owner, "get_total_athletics"))   stats["Athletics"]   = owner.get_total_athletics()
	if (hascall(owner, "get_total_lockpicking")) stats["Lockpicking"] = owner.get_total_lockpicking()
	if (hascall(owner, "get_total_blood"))       stats["Cruelty"]     = owner.get_total_blood()
	general["stats"] = stats

	// Species
	var/list/species_block = list()
	if (iskindred(owner))
		species_block = get_species_ui_kindred(owner)
	if (isgarou(owner))
		species_block = get_species_ui_garou(owner)
	if (isghoul(owner))
		species_block = get_species_ui_ghoul(owner)
	if (iscathayan(owner))
		species_block = get_species_ui_cathayan(owner)
	return list("general" = general, "species" = species_block)

/// Kindred
/datum/aboutme_record/proc/get_species_ui_kindred(mob/living/carbon/human/owner)
	var/list/species_block = list()
	var/datum/vampire_clan/clan = owner.clan
	species_block["clan"] = clan?.name || "Unknown"
	if (clan)
		species_block["clan_desc"] = clan.desc
		species_block["clan_curse"] = clan.curse
	species_block["generation"] = owner.generation || "Unknown"
	species_block["masquerade"] = "[owner.masquerade_score]"
	species_block["morality_path"] = owner.morality_path?.name || ""
	species_block["morality_score"] = owner.morality_path?.score || ""
	species_block["disciplines"] = list()
	var/datum/species/kindred/K = owner.dna?.species
	if (K && islist(K.disciplines))
		for (var/datum/discipline/D in K.disciplines)
			species_block["disciplines"] += list(list(
				"name" = D.name, "level" = D.level, "desc" = D.desc || ""
			))
	return species_block

/// Garou
/datum/aboutme_record/proc/get_species_ui_garou(mob/living/carbon/human/owner)
	var/list/species_block = list()
	var/datum/auspice/a = owner.auspice
	species_block["masquerade"] = "[owner.masquerade_score]"
	species_block["tribe"] = a?.tribe?.name || "Unknown"
	species_block["auspice"] = a?.name || "Unknown"
	//species_block["base_breed"] = a?.base_breed || "Unknown" //Genetic base form.
	species_block["gnosis"] = a?.gnosis || a?.start_gnosis || 0
	species_block["rage"] = a?.rage || a?.start_rage || 0
	species_block["honor"] = owner.honor || 0
	species_block["glory"] = owner.glory || 0
	species_block["wisdom"] = owner.wisdom || 0
	species_block["rank"] = RankName(owner.renownrank) || "Cub"
	species_block["gifts"] = list()
	if (a && islist(a.gifts))
		for (var/gift_path in a.gifts)
			var/datum/action/gift/G = locate(gift_path)
			species_block["gifts"] += list(list(
				"name" = G?.name || "[gift_path]", "desc" = G?.desc || ""
			))
	return species_block

/// Ghoul
/datum/aboutme_record/proc/get_species_ui_ghoul(mob/living/carbon/human/owner)
	var/list/species_block = list()
	var/datum/species/ghoul/GS = owner.dna?.species
	if (GS?.master)
		var/datum/species/kindred/MK = GS.master.dna?.species
		var/datum/vampire_clan/MC = MK?.clan
		species_block["regnant"] = GS.master.real_name || "Unknown"
		species_block["regnant_clan"] = MC?.name || "Unknown"
	else
		species_block["regnant"] = ""
		species_block["regnant_clan"] = ""
	species_block["masquerade"] = "[owner.masquerade_score]"
	species_block["generation"] = owner.generation || 13
	species_block["disciplines"] = list()
	if (GS && islist(GS.disciplines))
		for (var/datum/discipline/D in GS.disciplines)
			species_block["disciplines"] += list(list(
				"name" = D.name, "level" = D.level, "desc" = D.desc || ""
			))
	if (owner.bloodpool || owner.maxbloodpool)
		species_block["bloodpool"] = "[owner.bloodpool || 0] / [owner.maxbloodpool || 0]"
	return species_block

/// Cathayan
/datum/aboutme_record/proc/get_species_ui_cathayan(mob/living/carbon/human/owner)
	var/list/species_block = list()
	var/datum/dharma/D = owner?.mind?.dharma
	species_block["dharma"] = D?.name || ""
	species_block["dharma_level"] = D?.level || ""
	species_block["dharma_flavor"] = D?.desc || ""
	species_block["tenets"] = islist(D?.tenets) ? D.tenets : list()
	species_block["fails"] = islist(D?.fails) ? D.fails : list()
	species_block["po"] = D?.Po || ""
	species_block["hun"] = D?.Hun || ""
	species_block["animated"] = D?.animated || ""
	species_block["initial_skin_color"] = D?.initial_skin_color || ""
	species_block["max_yin_chi"] = owner.max_yin_chi || 0
	species_block["yin_chi"] = owner.yin_chi || 0
	species_block["max_yang_chi"] = owner.max_yang_chi || 0
	species_block["yang_chi"] = owner.yang_chi || 0
	species_block["max_demon_chi"] = owner.max_demon_chi || 0
	species_block["demon_chi"] = owner.demon_chi || 0
	species_block["masquerade"] = "[owner.masquerade_score]"
	return species_block
