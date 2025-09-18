// ============================================================================
// About Me: Player Input - Group Management (aboutme_tgui_player_group.dm)
// ----------------------------------------------------------------------------
/datum/component/about_me/proc/prompt_manage_groups(mob/user)
	var/choice = tgui_input_list(user, "What group action?", "Manage Groups", list(
		"My Groups", "Join Group", "Leave Group", "Create Party", "Back"
	), null, 0, GLOB.always_state)
	if (isnull(choice) || choice == "Back") return
	switch(choice)
		if ("My Groups") return src.prompt_manage_groups_my(user)
		if ("Join Group") return src.prompt_manage_groups_join(user)
		if ("Leave Group") return src.prompt_manage_groups_leave(user)
		if ("Create Party") return src.prompt_manage_groups_create(user)

/datum/component/about_me/proc/prompt_manage_groups_my(mob/user)
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	if (!R)
		to_chat(user, "<span class='alert'>Could not retrieve your character record.</span>")
		return src.prompt_manage_groups(user)
	if (!length(R.group_keys))
		to_chat(user, "<span class='notice'>You are not part of any groups.</span>")
		return src.prompt_manage_groups(user)
	var/character_id = R.character_id
	var/list/group_map = list()
	for (var/group_id in R.group_keys)
		var/datum/group/G = GLOB.groups[group_id]
		if (!G) continue
		var/is_leader = (character_id in G.leaders)
		var/is_officer = (character_id in G.officers)
		if ((G.gtype == GROUP_TYPE_CITY || G.gtype == GROUP_TYPE_FACTION) && !is_leader && !is_officer)
			continue
		group_map[G.name] = G
	if (!length(group_map))
		to_chat(user, "<span class='notice'>You are not part of any groups you can interact with.</span>")
		return src.prompt_manage_groups(user)
	while (TRUE)
		var/group_key = tgui_input_list(user, "Select a group to interact with:", "My Groups", group_map)
		if (isnull(group_key)) break
		var/datum/group/G = group_map[group_key]
		if (!istype(G, /datum/group)) break
		src.prompt_my_group_view(user, G, R)

/datum/component/about_me/proc/prompt_my_group_view(mob/user, datum/group/this_group, datum/aboutme_record/R)
	if (!this_group || !R?.character_id) return
	var/character_id = R.character_id
	var/is_leader = (character_id in this_group.leaders)
	var/is_officer = (character_id in this_group.officers)
	while (TRUE)
		var/datum/relationships/my_rel = null
		for (var/rid in R.relationship_keys)
			if (rid in this_group.get_relationship_keys_for_owner(character_id))
				var/datum/relationships/test_rel = SSroleplay_management.get_relationship_by_key(rid)
				if (test_rel?.target == character_id && test_rel?.target == this_group.id)
					my_rel = test_rel
					break
		var/strength = my_rel?.intensity || 0
		var/list/options = list("(Member) Loyalty: Raise", "(Member) Loyalty: Lower", "(Member) Promote Officer Vote")
		if (is_officer || is_leader)
			options += list("(Officer) Review Group Loyalty", "(Officer) Invite Member", "(Officer) Promote Leader Vote")
		if (is_leader)
			options += list("(Leader) Set Orders", "(Leader) Promote Member", "(Leader) Demote Member", "(Leader) Remove Member")
		options += "Back"
		var/selection = tgui_input_list(user, "[this_group.name] — Loyalty: [strength]", "Group View", options)
		if (isnull(selection) || selection == "Back") break
		switch(selection)
			if ("(Member) Loyalty: Raise", "(Member) Loyalty: Lower")
				var/delta = (selection == "(Member) Loyalty: Raise") ? 10 : -10
				var/reason = tgui_input_text(user, "Why are you adjusting loyalty?", "Adjust Loyalty", encode = FALSE)
				if (isnull(reason)) continue
				if (!my_rel || !(!(my_rel.id in this_group.get_relationship_keys_for_owner(character_id))))
					to_chat(user, "<span class='alert'>Could not update loyalty — invalid relationship binding.</span>")
					continue
				my_rel.intensity = clamp(my_rel.intensity + delta, 0, 100)
				to_chat(user, "<span class='notice'>Loyalty to [this_group.name] is now [my_rel.intensity].</span>")

			if ("(Member) Promote Officer Vote")
				var/list/candidates = list()
				for (var/key in this_group.members)
					if (!(key in this_group.leaders) && !(key in this_group.officers))
						candidates[this_group.members[key] || key] = key
				if (!length(candidates))
					to_chat(user, "<span class='warning'>No eligible candidates found to promote.</span>")
					continue
				var/candidate_choice = tgui_input_list(user, "Who do you want to nominate for officer?", "Propose Vote", candidates)
				if (!candidate_choice || !istext(candidate_choice)) continue
				var/target_key = candidates[candidate_choice]
				var/datum/group_vote/V = this_group.start_vote("promote officer", target_key, character_id)
				if (!V)
					to_chat(user, "<span class='alert'>Failed to start a vote.</span>")
					continue
				to_chat(user, "<span class='notice'>Vote to promote [candidate_choice] to officer started.</span>")
				message_admins("[key_name(user)] started a vote to promote [candidate_choice] in [this_group.name].")

			if ("(Officer) Promote Leader Vote")
				var/list/candidates = list()
				for (var/key in this_group.officers)
					if (!(key in this_group.leaders))
						candidates[this_group.members[key] || key] = key
				if (!length(candidates))
					to_chat(user, "<span class='warning'>No eligible officers available for promotion to leader.</span>")
					continue
				var/candidate_choice = tgui_input_list(user, "Which officer do you want to nominate for leader?", "Promote Leader Vote", candidates)
				if (!candidate_choice || !istext(candidate_choice)) continue
				var/target_key = candidates[candidate_choice]
				var/datum/group_vote/V = this_group.start_vote("promote leader", target_key, character_id)
				if (!V)
					to_chat(user, "<span class='alert'>Failed to start a vote for leader promotion.</span>")
					continue
				to_chat(user, "<span class='notice'>Vote to promote [candidate_choice] to leader started.</span>")
				message_admins("[key_name(user)] started a vote to promote [candidate_choice] to Leader in [this_group.name].")

			if ("(Officer) Invite Member")
				var/list/valid_targets = list()
				for (var/target_key in GLOB.aboutme_records)
					if (this_group.members && (target_key in this_group.members))
						continue
					var/datum/component/about_me/C = SSroleplay_management.find_aboutme_component_by_character_id(target_key)
					if (!C?.owner || !ismob(C.owner)) continue
					var/mob/living/carbon/human/M = C.owner
					var/display_name = M.true_real_name || M.real_name || target_key
					valid_targets[display_name] = target_key
				if (!length(valid_targets))
					to_chat(user, "<span class='warning'>No valid players found to invite.</span>")
					continue
				var/choice = tgui_input_list(user, "Invite which character?", "Invite Member", valid_targets)
				if (!choice || !istext(choice)) continue
				var/target_key = valid_targets[choice]
				var/officer_key = R.character_id
				var/datum/component/about_me/TargetC = SSroleplay_management.find_aboutme_component_by_character_id(target_key)
				if (!TargetC?.owner || !ismob(TargetC.owner))
					to_chat(user, "<span class='warning'>Could not find target's mob to send invite.</span>")
					continue
				this_group.invite_member_prompt(officer_key, target_key)
				to_chat(user, "<span class='notice'>Sent invite to [choice].</span>")
				message_admins("[key_name(user)] sent an invite to [choice] for [this_group.name].")

			if ("(Officer) Review Group Loyalty")
				var/list/all_keys = this_group.all_rel_keys()
				var/list/loyalty_report = list()
				for (var/rid in all_keys)
					var/datum/relationships/rel = SSroleplay_management.get_relationship_by_key(rid)
					if (!rel) continue
					var/owner = rel.owner
					var/role = ((owner in this_group.leaders)  ? "Leader" : (owner in this_group.officers) ? "Officer" : (owner in this_group.members)  ? "Member" : "Guest")
					var/name = this_group.members[owner] || owner
					loyalty_report += "[name] ([role]) — [rel.intensity]"

			if ("(Leader) Promote Member")
				var/list/promote_candidates = list()
				for (var/key in this_group.members)
					if (!(key in this_group.officers) && !(key in this_group.leaders))
						promote_candidates[this_group.members[key] || key] = key
				if (!length(promote_candidates))
					to_chat(user, "<span class='warning'>No valid candidates to promote.</span>")
					continue
				var/promote_choice = tgui_input_list(user, "Promote to Officer", "Select Member", promote_candidates)
				if (!promote_choice) continue
				var/target_key = promote_candidates[promote_choice]
				this_group.add_officer(target_key, this_group.members[target_key])
				to_chat(user, "<span class='notice'>Promoted [promote_choice] to Officer.</span>")
				message_admins("[key_name(user)] promoted [promote_choice] to Officer in [this_group.name].")

			if ("(Leader) Demote Member")
				var/list/demote_targets = list()
				for (var/key in this_group.officers)
					if (!(key in this_group.leaders))
						demote_targets[this_group.members[key] || key] = key
				if (!length(demote_targets))
					to_chat(user, "<span class='warning'>No officers available to demote.</span>")
					continue
				var/demote_choice = tgui_input_list(user, "Demote Officer", "Select Officer", demote_targets)
				if (!demote_choice) continue
				var/target_key = demote_targets[demote_choice]
				this_group.demote_officer(target_key)
				to_chat(user, "<span class='notice'>Demoted [demote_choice] to Member.</span>")
				message_admins("[key_name(user)] demoted [demote_choice] to Member in [this_group.name].")

			if ("(Leader) Remove Member")
				var/list/remove_targets = list()
				for (var/key in this_group.members + this_group.officers + this_group.leaders)
					if (key != character_id)
						remove_targets[this_group.members[key] || key] = key
				if (!length(remove_targets))
					to_chat(user, "<span class='warning'>No members available to remove.</span>")
					continue
				var/remove_choice = tgui_input_list(user, "Remove Member", "Select Member", remove_targets)
				if (!remove_choice) continue
				var/target_key = remove_targets[remove_choice]
				this_group.remove_member_key(target_key)
				to_chat(user, "<span class='notice'>Removed [remove_choice] from [this_group.name].</span>")
				message_admins("[key_name(user)] removed [remove_choice] from [this_group.name].")

/datum/component/about_me/proc/prompt_manage_groups_join(mob/user)
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	if (!R) return
	var/character_id = src.character_id
	var/display_name = src.owner?.true_real_name || src.owner?.name || character_id
	var/list/join_options = list()
	for (var/group_id in GLOB.groups)
		var/datum/group/G = GLOB.groups[group_id]
		if (!G || G.is_public == TRUE || (group_id in R.group_keys))
			continue
		if (G.gtype == GROUP_TYPE_PARTY)
			join_options["Join Party: [G.name]"] = G.id
		else if (G.gtype == GROUP_TYPE_ORGANIZATION)
			join_options["Apply to Organization: [G.name]"] = G.id
	if (!length(join_options))
		return to_chat(user, "<span class='notice'>No public organizations or parties are currently available to join.</span>")
	var/choice = tgui_input_list(user, "Select a group to join or apply to:", "Available Public Groups", join_options)
	if (!choice || !istext(choice)) return
	var/group_id = join_options[choice]
	var/datum/group/G = GLOB.groups[group_id]
	if (!G || (group_id in R.group_keys))
		to_chat(user, "<span class='alert'>Unable to join [G?.name || "selected group"].</span>")
		return src.prompt_manage_groups(user)
	if (G.gtype == GROUP_TYPE_PARTY)
		G.add_member_key(character_id, display_name)
		R.group_keys += group_id
		to_chat(user, "<span class='notice'>You have joined party/coterie/hosted-event: [G.name].</span>")
		message_admins("[key_name(user)] joined public party group: [G.name] ([group_id]).")
	else if (G.gtype == GROUP_TYPE_ORGANIZATION)
		to_chat(user, "<span class='notice'>Your application has been sent to [G.name]'s leadership. Please speak with them IC to complete the process.</span>")
		for (var/key in G.leaders + G.officers)
			var/datum/component/about_me/C = SSroleplay_management.find_aboutme_component_by_character_id(key)
			if (C?.owner && ismob(C.owner))
				to_chat(C.owner, "<span class='alert'>[display_name] has applied to join your organization: [G.name].</span>")
		message_admins("[key_name(user)] applied to join public organization group: [G.name] ([group_id]).")
	return src.prompt_manage_groups(user)

/datum/component/about_me/proc/prompt_manage_groups_leave(mob/user)
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	if (!R) return
	var/character_id = src.character_id
	var/list/leave_options = list()
	for (var/group_id in R.group_keys)
		var/datum/group/G = GLOB.groups[group_id]
		if (!G) continue
		var/gtype = G.gtype
		var/strength = SSroleplay_management.get_relationship_strength(character_id, group_id)
		// Core groups, or those with high loyalty, cannot be left
		if (gtype == GROUP_TYPE_CITY)
			leave_options["(Cannot Leave) [G.name] - You have to walk out of the city, just reside here, or die."] = null
			continue
		if (gtype == GROUP_TYPE_FACTION)
			leave_options["(Cannot Leave) [G.name] - You can not stop being what you are, can you?"] = null
			continue
		if (gtype == GROUP_TYPE_CLAN || gtype == GROUP_TYPE_TRIBE)
			leave_options["(Cannot Leave) [G.name] - Your blood doesn't forget."] = null
			continue
		if (gtype == GROUP_TYPE_SECT && (isnull(strength) || strength > 10))
			leave_options["(Cannot Leave) [G.name] - Too loyal to abandon your sect [strength] > 10."] = null
			continue
		if (gtype == GROUP_TYPE_ORGANIZATION && (isnull(strength) || strength >= 30))
			leave_options["(Cannot Leave) [G.name] - Loyalty too high to leave [strength] > 30."] = null
			continue
		leave_options["Leave [G.name] ([G.gtype])"] = G
	if (!length(leave_options))
		return to_chat(user, "<span class='notice'>No eligible groups to leave.</span>")
	var/choice = tgui_input_list(user, "Choose group to leave:", "Leave Group", leave_options)
	if (!choice || !istext(choice)) return
	var/datum/group/selected_group = leave_options[choice]
	if (!selected_group) return
	var/group_id = selected_group.id
	// If private party and player is the last leader, disband group
	if (selected_group.gtype == GROUP_TYPE_PARTY && selected_group.is_public == FALSE && (character_id in selected_group.leaders))
		if (length(selected_group.leaders) == 1)
			to_chat(user, "<span class='alert'>You were the only leader of [selected_group.name]. The party has been disbanded.</span>")
			message_admins("[key_name(user)] disbanded party group [selected_group.name] ([group_id]) by leaving as last leader.")
			GLOB.groups -= group_id
			SSroleplay_management.unregister_group(selected_group)
			R.group_keys -= group_id
			return src.prompt_manage_groups(user)
	// Normal leave (remove all roles)
	selected_group.members -= character_id
	selected_group.leaders -= character_id
	selected_group.officers -= character_id
	selected_group.members -= character_id
	R.group_keys -= group_id
	to_chat(user, "<span class='notice'>Left [selected_group.name].</span>")
	message_admins("[key_name(user)] left group [selected_group.name] ([group_id]).")

	return src.prompt_manage_groups(user)

/datum/component/about_me/proc/prompt_manage_groups_create(mob/user)
	var/datum/aboutme_record/R = SSroleplay_management.get_aboutme_record(src.character_id)
	if (!R) return
	var/character_id = src.character_id
	var/display_name = src.owner?.true_real_name || src.owner?.name || character_id
	for (var/group_id in R.group_keys)
		var/datum/group/G = GLOB.groups[group_id]
		if (!G) continue
		if (G.istype(/datum/group/party) && (character_id in G.leaders))
			to_chat(user, "<span class='alert'>You already lead a party group: [G.name]. You cannot create another.</span>")
			return src.prompt_manage_groups(user)
	var/group_name = tgui_input_text(user, "Enter a name for your new party group:", "Create Party Group", encode = FALSE)
	if (isnull(group_name) || !length(group_name)) return
	var/safe_id = "party_[lowertext(replacetext(group_name, " ", "_"))]_[world.time]"
	if (GLOB.groups[safe_id])
		return
	var/datum/group/party/G = new /datum/group/party()
	G.is_public = FALSE
	G.name = group_name
	G.id = safe_id
	G.leaders += character_id
	G.members += character_id
	G.members[character_id] = display_name
	GLOB.groups[G.id] = G
	SSroleplay_management.register_group(G)
	R.group_keys += G.id
	SSroleplay_management.ensure_group_relationship(character_id, G, 100)
	to_chat(user, "<span class='notice'>You have created and joined a new party: [G.name]</span>")
	message_admins("[key_name(user)] created party group: [G.name] ([G.id])")
	return src.prompt_manage_groups(user)

