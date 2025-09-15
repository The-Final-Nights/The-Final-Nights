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
	possible_locs = list(BODY_ZONE_HEAD)

/datum/surgery_step/add_curse
	name = "Modify Appearance"
	implements = list(/obj/item/stack/human_flesh = 100)
	repeatable = TRUE//lets the fleshcrafter try out the options, should allow for easier experimenting with how things look
	time = 120

/datum/surgery_step/add_curse/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("You begin to reshape [target]..."),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"),
		span_notice("[user] begins to manipulate [target]'s flesh in truly horrific ways!</span>"))

/datum/surgery_step/add_curse/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(target.clan?.name == CLAN_NOSFERATU || target.clan?.name == CLAN_KIASYD || target.clan?.name == CLAN_CAPPADOCIAN || target.clan?.name == CLAN_GARGOYLE) //Clan check, since otherwise this would prevent you reverting appearance for those you curse afterwards.
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, revert_to_cursed_form)), 6 INGAME_HOURS)//Won't last all night, but takes a good while to heal, given how it's a pain to perform.
		display_results(user, target, span_notice("[target]'s curse is already attempting to revert them to their cursed original form, it won't last much more than a few hours!"))
	display_results(user, target, span_notice("You finish reshaping [target]!"),
		span_notice("[user] changes [target] into something... new."),
		span_notice("[user] finishes."))
	target.remove_overlay(UNICORN_LAYER)
	target.overlays_standing[UNICORN_LAYER] = null
	target.remove_overlay(UPPER_EARS_LAYER)
	target.overlays_standing[UPPER_EARS_LAYER] = null
	target.remove_overlay(MARKS_LAYER)
	target.overlays_standing[MARKS_LAYER] = null
	if (HAS_TRAIT(target, TRAIT_MASQUERADE_VIOLATING_FACE))
		REMOVE_TRAIT(target, TRAIT_MASQUERADE_VIOLATING_FACE, CLAN_TRAIT)
	if (HAS_TRAIT(target, TRAIT_MASQUERADE_VIOLATING_EYES))
		REMOVE_TRAIT(target, TRAIT_MASQUERADE_VIOLATING_EYES, CLAN_TRAIT)
	var/mutable_appearance/bodypart_overlay
	var/list/changes = list("Nosferatu", "Kiasyd", "Cappadocian", "Gargoyle", "Gangrel", "None")
	var/chosen = tgui_input_list(user, "How shall we change them?", "Curse selection", changes)
	switch(chosen)
		if("None")
			target.set_body_sprite("human")
		if("Nosferatu")
			target.set_body_sprite("nosferatu")
			ADD_TRAIT(target, TRAIT_MASQUERADE_VIOLATING_FACE, CLAN_TRAIT)
			var/list/ears = list("Normal", "Nosferatu")
			var/selected_ears = tgui_input_list(user, "What type of ears should they have?", "Appearance Customisation", ears)
			switch(selected_ears)
				if("Nosferatu")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "nosferatu_ears", -UPPER_EARS_LAYER)
					target.overlays_standing[UPPER_EARS_LAYER] = bodypart_overlay
					target.apply_overlay(UPPER_EARS_LAYER)
		if("Kiasyd")
			target.set_body_sprite("kiasyd")
			ADD_TRAIT(target, TRAIT_MASQUERADE_VIOLATING_EYES, CLAN_TRAIT)
			var/list/ears = list("Normal", "Kiasyd")
			var/selected_ears = tgui_input_list(user, "What type of ears should they have?", "Appearance Customisation", ears)
			switch(selected_ears)
				if("Kiasyd")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "fae_ears", -UPPER_EARS_LAYER)
					target.overlays_standing[UPPER_EARS_LAYER] = bodypart_overlay
					target.apply_overlay(UPPER_EARS_LAYER)
		if("Cappadocian")
			target.set_body_sprite("rotten1")
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
			ADD_TRAIT(target, TRAIT_MASQUERADE_VIOLATING_FACE, CLAN_TRAIT)
			var/list/gargoyle = list("None", "Full", "Left", "Right", "Broken", "Round", "Devil", "Oni")
			var/gargoyle_trait = tgui_input_list(user, "What type of horns should they have?", "Appearance Customisation", gargoyle)
			switch(gargoyle_trait)
				if("Full")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_full", -UNICORN_LAYER)
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
				if("Left")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_left", -UNICORN_LAYER)
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
				if("Right")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_right", -UNICORN_LAYER)
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
				if("Broken")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_broken", -UNICORN_LAYER)
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
				if("Round")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_round", -UNICORN_LAYER)
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
				if("Devil")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_devil", -UNICORN_LAYER)
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
				if("Oni")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "gargoyle_oni", -UNICORN_LAYER)
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
		if("Gangrel")
			target.set_body_sprite("human")
			var/list/gangrel = list("None", "Beast Legs", "Beast Tail", "Beast Legs and Tail")
			var/gangrel_trait = tgui_input_list(user, "What type of Gangrel mark should they have?", "Appearance Customisation", gangrel)
			switch(gangrel_trait)
				if("Beast Legs")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "beast_legs", -MARKS_LAYER)
					target.overlays_standing[MARKS_LAYER] = bodypart_overlay
					target.apply_overlay(MARKS_LAYER)
				if("Beast Tail")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "beast_tail", -UNICORN_LAYER) //Not sure why this isn't marks too, but that's how it's set for Gangrel.
					target.overlays_standing[UNICORN_LAYER] = bodypart_overlay
					target.apply_overlay(UNICORN_LAYER)
				if("Beast Legs and Tail")
					bodypart_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "beast_tail_and_legs", -MARKS_LAYER)
					target.overlays_standing[MARKS_LAYER] = bodypart_overlay
					target.apply_overlay(MARKS_LAYER)
	tool.use(1)
	return TRUE
