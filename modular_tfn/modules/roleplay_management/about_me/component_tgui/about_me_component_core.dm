// ==============================================================================
// ABOUT ME COMPONENT (aboutme_core.dm)
// ------------------------------------------------------------------------------
/datum/component/about_me
	var/mob/living/carbon/human/owner = null // quick reference to current owning runtime mob
	var/character_id = null // unique per-character identifier, (ckey)_(character_real_name)_id

/datum/component/about_me/Initialize()
	..()
	owner = parent
	var/datum/action/about_me/button = new(owner)
	button.Grant(parent)

/datum/component/about_me/Destroy()
	if (character_id)
		SSroleplay_management.unregister_aboutme_component(src)
	owner = null
	..()

/datum/component/about_me/proc/UpdateCharacterId()
	var/ckey = owner.client.ckey || "unknown"
	var/name_part = lowertext(replacetext(owner.true_real_name, " ", "_"))
	character_id = SSroleplay_management.about_me_new_id("[ckey]_[name_part]")

/datum/component/about_me/proc/get_aboutme_record(id_override = null)
	var/id = id_override ? id_override : character_id
	return SSroleplay_management.get_aboutme_record(id)

/datum/component/about_me/proc/get_full_payload()
	if(!character_id)
		UpdateCharacterId()
	if (!(src in GLOB.aboutme_components))
		SSroleplay_management.register_aboutme_component(src)
	var/datum/aboutme_record/R = get_aboutme_record()
	if (!R)
		R = SSroleplay_management.ensure_aboutme_record_for_id(character_id, owner)
	return R.GetFormattedUI(owner)

/datum/component/about_me/proc/build_overview_data()
	var/datum/aboutme_record/aboutme_record = get_aboutme_record()
	return aboutme_record.get_ui_overview_data(owner)

/datum/component/about_me/proc/get_groups_for_ui()
	var/datum/aboutme_record/aboutme_record = get_aboutme_record()
	return aboutme_record.get_ui_groups(owner)

/datum/component/about_me/proc/get_memories_by_category()
	var/datum/aboutme_record/aboutme_record = get_aboutme_record()
	return aboutme_record.get_ui_memories_by_tag(owner)

//takes in an active group vote, and prompts the owners of this component to vote on it. Change to status effect.
/datum/component/about_me/proc/prompt_vote_on_group(datum/group_vote/group_vote)
	var/datum/group/group = SSroleplay_management.get_group_by_id(group_vote.group_id)
	if (!group || !owner || !ismob(owner) || group_vote.has_voted(character_id))
		return
	var/vote_target = group.members[group_vote.target_character_key] || group_vote.target_character_key
	var/player_choice = tgui_input_list(
		owner,
		"Do you vote YES or NO to [group_vote.vote_type] [vote_target]?",
		"Vote in [group.name]: [group_vote.vote_type]",
		list("Yes", "No")
	)
	if (isnull(player_choice))
		return
	group_vote.add_vote(character_id, player_choice == "Yes")
	to_chat(owner, span_notice("Your vote for [vote_target] has been recorded."))

// Action button (single entry point for player to access About Me UI)
/datum/action/about_me
	name = "About Me"
	desc = "Press to view your About Me Menu."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/datum/component/about_me/about_me_component

/datum/action/about_me/Trigger(trigger_flags)
	about_me_component = owner.GetComponent(/datum/component/about_me)
	if (about_me_component)
		about_me_component.ui_interact(owner)
