/datum/surgery/fleshcraft/clan_curse
	name = "Cursed Appearance"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/add_curse,
				/datum/surgery_step/close)

	replaced_by = null
	level_req = 3

/datum/surgery_step/add_curse
	name = "Modify Appearance"
	implements = list(/obj/item/stack/human_flesh = 100)
	repeatable = TRUE//lets the fleshcrafter try out the options, should allow for easier experimenting with how things look
	time = 120

/datum/surgery_step/add_flesh/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to reshape [target]..."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"))

/datum/surgery_step/add_flesh/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if((target.clan?.name == CLAN_NOSFERATU) || (clan?.name == CLAN_KIASYD) || (clan?.name == CLAN_CAPPADOCIAN) || (clan?.name == CLAN_GARGOYLE)) //Clan check, since otherwise this would prevent you reverting appearance for those you curse afterwards.
		addtimer(CALLBACK(target, PROC_REF(revert_to_cursed_form)), 6 INGAME_HOURS) //Won't last all night, but takes a good while to heal, given how it's a pain to perform.
		display_results(user, target, span_notice("[target]'s curse is already attempting to revert them to their cursed original form, it won't last much more than a few hours!"))
	display_results(user, target, span_notice("You finish reshaping [target]!"),
		span_notice("[user] changes [target] into something... new."),
		span_notice("[user] finishes."))
	var/list/changes = list("Nosferatu", "Kiasyd", "Cappadocian", "Gargoyle", "None")
	var/chosen = tgui_input_list(user, "How shall we change them?", "Curse selection", changes)
	switch(chosen)
		if("None")
			target.set_body_sprite()
			target.remove_overlay(UNICORN_LAYER)
			target.overlays_standing[UNICORN_LAYER] = null
		if("Nosferatu")
			target.set_body_sprite("nosferatu")
			target.remove_overlay(UNICORN_LAYER)
			target.overlays_standing[UNICORN_LAYER] = null
		if("Kiasyd")
			target.set_body_sprite("kiasyd")
			target.remove_overlay(UNICORN_LAYER)
			target.overlays_standing[UNICORN_LAYER] = null
		if("Cappadocian")
			target.set_body_sprite("rotten1")
			target.remove_overlay(UNICORN_LAYER)
			target.overlays_standing[UNICORN_LAYER] = null
			var/list/decay = list("Fresh", "Decaying", "Rotten", "Skeleton")
			var/selected_age = tgui_input_list(user, "How decayed should they look?", "Decay level selection", decay)
			switch(selected_age)
				if("Fresh")
					target.rot_body(1)
				if("Decaying")
					target.rot_body(2)
				if("Rotten")
					target.rot_body(3)
				if("Skeleton")
					target.rot_body(4)
		if("Gargoyle")
			target.set_body_sprite("gargoyle")
			target.remove_overlay(UNICORN_LAYER)
			target.overlays_standing[UNICORN_LAYER] = null
	tool.use(1)
	return TRUE
