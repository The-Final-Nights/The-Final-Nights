// ============================================================================
// About Me: Player Input - Mutual Relationship Management (aboutme_tgui_player_relationship.dm)
// ----------------------------------------------------------------------------
// Handles creation and removal of mutual player-to-player relationships.
// - Only for character ↔ character (mutual) ties, not group affiliations.
// - Group relationships are handled separately in the Groups tab/UI.
// - Procs here are called from the Relationships tab in About Me.
// ============================================================================

/**
 * Main entry point: Opens the mutual relationship management menu for the player.
 * Lets the player choose to create or remove a mutual relationship.
 */
/datum/component/about_me/proc/prompt_change_relationship(mob/user)
	message_admins("[key_name(user)] opened the Relationship editor.")
	var/list/options = list(
		"Create Mutual Relationship",
		"Remove Relationship",
		"Back"
	)
	var/choice = tgui_input_list(user, "Choose a relationship action:", "Manage Relationships", options, null, 0, GLOB.always_state)
	if (isnull(choice) || choice == "Back") return
	switch(choice)
		if ("Create Mutual Relationship") return src.prompt_add_mutual_relationship(user)
		if ("Remove Relationship")        return src.prompt_remove_personal_relationship(user)
	return TRUE

/**
 * Allows the player to propose and create a new mutual relationship with another character.
 * Handles target selection, relationship type, loyalty/strength, tag, and confirmation.
 */
/datum/component/about_me/proc/prompt_add_mutual_relationship(mob/user)
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	if (!R) return
	// Build valid targets: no self, no duplicate relationships, only live players.
	var/list/char_options = list()
	for (var/target in GLOB.aboutme_records)
		if (target == src.character_id) continue
		if (src.has_relationship_with(target)) continue // Prevent duplicates
		var/datum/component/about_me/C = SSroleplay_management.find_aboutme_component_by_character_id(target)
		if (!C?.owner || !ismob(C.owner)) continue
		var/mob/living/carbon/human/M = C.owner
		var/display_name = M.true_real_name || M.real_name || target
		char_options[display_name] = target
	if (!length(char_options))
		to_chat(user, "<span class='warning'>No valid characters available to form a new relationship with.</span>")
		return src.prompt_change_relationship(user)
	// Target selection
	var/char_choice = tgui_input_list(user, "Choose a character:", "Character", char_options)
	if (!char_choice || !istext(char_choice)) return src.prompt_change_relationship(user)
	var/target = char_options[char_choice]
	// Relationship type selection
	var/list/type_choices = list()
	for (var/t in RELATIONSHIP_TYPE_KEYS)
		if (t != "group") type_choices += t
	var/rtype = tgui_input_list(user, "Select relationship type:", "Relationship Type", type_choices)
	if (isnull(rtype)) return src.prompt_change_relationship(user)
	// Loyalty/strength selection
	var/list/strength_options = list(
		"-100: Nemesis/Hatred" = -100,
		"-75: Enemy" = -75,
		"-50: Rival" = -50,
		"-25: Distrusted" = -25,
		"0: Neutral" = 0,
		"25: Acquaintance" = 25,
		"50: Neutral/Friendly" = 50,
		"75: Close/Bonded" = 75,
		"100: Deep Loyalty" = 100
	)
	var/strength = tgui_input_list(user, "Choose the loyalty/strength of this relationship (negative for enemies):", "Loyalty", strength_options)
	if (isnull(strength)) return src.prompt_change_relationship(user)
	// Find display label for summary
	var/strength_label = ""
	for (var/L in strength_options)
		if (strength_options[L] == strength) strength_label = L; break
	// Pick tag (one only)
	var/tag = tgui_input_list(user, "Select relationship tag.", "Tag", RELATIONSHIP_TAGS_ALLOWED)
	var/list/taglist = tag ? list(tag) : list()
	// Confirmation summary shown to target
	var/summary = "[user.name] wants to form a mutual relationship with you.\n"
	summary += "Type: [rtype]\n"
	summary += "Loyalty/Strength: [strength_label]\n"
	if (taglist.len)
		summary += "Tag: [jointext(taglist, ", ")]\n"
	// Find and confirm with target
	var/datum/component/about_me/TargetC = SSroleplay_management.find_aboutme_component_by_character_id(target)
	if (!TargetC?.owner || !ismob(TargetC.owner))
		to_chat(user, "<span class='warning'>Could not find target to send request.</span>")
		return src.prompt_change_relationship(user)
	var/mob/living/carbon/human/Target = TargetC.owner
	var/accepted = tgui_alert(
		Target,
		summary,
		"Mutual Relationship Request",
		list("Accept", "Decline")
	)
	if (accepted != "Accept") {
		to_chat(user, "<span class='alert'>[Target.name] declined the relationship.</span>")
		return src.prompt_change_relationship(user)
	}
	// Create shared relationship datum
	src.create_mutual_relationship(target, rtype, strength, taglist, user, Target)
	// Notify both players and log for staff
	to_chat(user, "<span class='notice'>Mutual relationship created with [Target.name].</span>")
	to_chat(Target, "<span class='notice'>You accepted a mutual relationship with [user.name].</span>")
	message_admins("[key_name(user)] and [key_name(Target)] created a mutual relationship (type: [rtype], loyalty: [strength]).")
	return src.prompt_change_relationship(user)

/**
 * Actually creates and registers the shared relationship datum between two characters.
 * Registers to both the owner and the target as valid keys.
 */
/datum/component/about_me/proc/create_mutual_relationship(target, kind, intensity, mob/living/carbon/human/user, mob/living/carbon/human/Target)
    var/datum/relationships/rel = new
    rel.owner = src.character_id
    rel.target = target
    rel.kind = kind
    rel.intensity = intensity
    rel.label = "[user.name] ↔ [Target.name]"
    rel.status = "Active"
    rel.visibility = TRUE
    // (Optional: add mutual flag if you want to track that separately)
    // rel.mutual = TRUE

    var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
    var/datum/aboutme_record/TargetR = SSroleplay_management.get_aboutme_record(target)
    if (R) R.relationship_keys += rel.id
    if (TargetR) TargetR.relationship_keys += rel.id

    SSroleplay_management.register_relationship(rel)

/**
 * Returns the mirrored character relationship relationship or null.
 * Used to create the mutual counterpart when forming a new relationship.
 */
/datum/relationships/proc/ensure_mutual()
	var/mirror_id = "[target]_character_[owner]_[rand(1,1000000)]"
	var/datum/relationships/mirror = new
	mirror.id = mirror_id
	mirror.owner = target
	mirror.target = owner
	mirror.kind = kind
	mirror.intensity = intensity
	mirror.label = label
	mirror.notes = notes
	mirror.status = status
	mirror.visibility = visibility
	return mirror

/**
 * Returns a map of all personal (non-group) relationships this player is part of.
 * Keyed by display name. Used for editing/removal UI.
 */
/datum/component/about_me/proc/get_personal_relationships(mob/user)
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	var/list/edit_map = list()
	if (!R || !length(R.relationship_keys)) return edit_map
	for (var/key in R.relationship_keys)
		var/datum/relationships/rel = SSroleplay_management.get_relationship_by_key(key)
		if (!rel || !rel.is_visible_to(user, src.character_id)) continue
		if (rel.target) continue // skip group relationships
		var/label = "[rel.label] (Character)"
		edit_map[label] = rel
	return edit_map

/**
 * Prompts the player to pick a mutual relationship to remove.
 * Handles all removal logic, including notifications and admin logging.
 */
/datum/component/about_me/proc/prompt_remove_personal_relationship(mob/user)
	message_admins("Relationship Remove: [key_name(user)] opened the remove relationship menu.")

	// Build map: label => rel.id, and id => rel object
	var/list/edit_map = list()
	var/list/rel_by_id = list()
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	if (!R || !length(R.relationship_keys))
		message_admins("Relationship Remove: No relationships available for [key_name(user)].")
		to_chat(user, "<span class='notice'>No personal relationships are visible to you.</span>")
		return src.prompt_change_relationship(user)
	for (var/key in R.relationship_keys)
		var/datum/relationships/rel = SSroleplay_management.get_relationship_by_key(key)
		if (!rel || !rel.is_visible_to(user, src.character_id)) continue
		if (rel.target) continue
		var/label = "[rel.label] (Character)"
		edit_map[label] = rel.id
		rel_by_id[rel.id] = rel

	if (!length(edit_map))
		message_admins("Relationship Remove: No personal relationships are visible to you (final map empty) for [key_name(user)].")
		to_chat(user, "<span class='notice'>No personal relationships are visible to you.</span>")
		return src.prompt_change_relationship(user)

	message_admins("Relationship Remove: [key_name(user)] can choose from: [jointext(edit_map, ", ")]")
	var/choice = tgui_input_list(user, "Choose a relationship to remove:", "Remove Personal Relationship", edit_map)
	if (isnull(choice) || !istext(choice) || !(choice in rel_by_id))
		message_admins("Relationship Remove: No valid selection made by [key_name(user)], returning to menu. Got: [choice]")
		return src.prompt_change_relationship(user)
	var/datum/relationships/rel = rel_by_id[choice]
	var/source_key = src.character_id
	var/target = rel.target
	message_admins("Relationship Remove: Attempting removal for rel.id=[rel.id] ([rel.label]) between [source_key] and [target]")

	// Call the core removal logic (removes from both records and GLOB)
	SSroleplay_management.clear_personal_relationship(source_key, target)

	// Notify both users if possible
	var/datum/component/about_me/OtherComp = SSroleplay_management.find_aboutme_component_by_character_id(target)
	if (OtherComp && ismob(OtherComp.parent))
		to_chat(OtherComp.parent, "<span class='alert'>[user.name] has removed the relationship with you.</span>")
	to_chat(user, "<span class='alert'>You have removed the relationship with [rel.label].</span>")
	message_admins("[key_name(user)] deleted mutual relationship [rel.id].")

	return src.prompt_change_relationship(user)

/**
 * Checks if there is already a mutual relationship between this character and another key.
 * Returns TRUE if found, FALSE if not.
 */
/datum/component/about_me/proc/has_relationship_with(other_key)
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	for (var/rel_id in R.relationship_keys)
		var/datum/relationships/rel = SSroleplay_management.get_relationship_by_key(rel_id)
		if (!rel) continue
		if ((rel.owner == src.character_id && rel.target == other_key) || (rel.owner == other_key && rel.target == src.character_id))
			return TRUE
	return FALSE
