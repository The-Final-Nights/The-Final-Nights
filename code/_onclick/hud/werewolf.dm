/atom/movable/screen/werewolf
	icon = 'icons/hud/screen_midnight.dmi'

/datum/hud/werewolf
	ui_style = 'icons/hud/screen_midnight.dmi'

/atom/movable/screen/rage
	name = "Rage"
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "rage0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_homid
	name = "Homid"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "homid"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_homid/CtrlClick(mob/user)
	. = ..()
	var/mob/living/carbon/C = user
	if(C.stat >= SOFT_CRIT || C.IsSleeping() || C.IsUnconscious() || C.IsParalyzed() || C.IsKnockdown() || C.IsStun())
		return
	if(C.transformator)
		C.transformator.transform(C, "Homid")

/atom/movable/screen/transform_crinos
	name = "Crinos"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "crinos"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_crinos/CtrlClick(mob/user)
	. = ..()
	var/mob/living/carbon/C = user
	if(C.stat >= SOFT_CRIT || C.IsSleeping() || C.IsUnconscious() || C.IsParalyzed() || C.IsKnockdown() || C.IsStun())
		return
	if(C.transformator)
		C.transformator.transform(C, "Crinos")

/atom/movable/screen/transform_lupus
	name = "Lupus"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "lupus"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/transform_lupus/CtrlClick(mob/user)
	. = ..()
	var/mob/living/carbon/C = user
	if(C.stat >= SOFT_CRIT || C.IsSleeping() || C.IsUnconscious() || C.IsParalyzed() || C.IsKnockdown() || C.IsStun())
		return
	if(C.transformator)
		C.transformator.transform(C, "Lupus")


/atom/movable/screen/transform_corax_crinos
	name = "Corax Crinos"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "corax_crinos"
	layer = HUD_LAYER
	plane = HUD_PLANE


/atom/movable/screen/transform_corax_crinos/CtrlClick(mob/user)
	. = ..()
	var/mob/living/carbon/C = user
	if(C.stat >= SOFT_CRIT || C.IsSleeping() || C.IsUnconscious() || C.IsParalyzed() || C.IsKnockdown() || C.IsStun())
		return
	if(C.transformator)
		C.transformator.transform(C, "Corax Crinos")

/atom/movable/screen/transform_corvid
	name = "corvid"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "corvid"
	layer = HUD_LAYER
	plane = HUD_PLANE


/atom/movable/screen/transform_corvid/CtrlClick(mob/user)
	. = ..()
	var/mob/living/carbon/C = user
	if(C.stat >= SOFT_CRIT || C.IsSleeping() || C.IsUnconscious() || C.IsParalyzed() || C.IsKnockdown() || C.IsStun())
		return
	if(C.transformator)
		C.transformator.transform(C, "Corvid")



/atom/movable/screen/auspice
	name = "Auspice"
	icon = 'code/modules/wod13/werewolf_ui.dmi'
	icon_state = "auspice_bar"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/auspice/Click()
	if(!GLOB.moon_state)
		GLOB.moon_state = pick("Full", "Gibbous", "Half", "Crescent", "New")
	var/mob/living/carbon/C = usr
	if(C.stat >= SOFT_CRIT || C.IsSleeping() || C.IsUnconscious() || C.IsParalyzed() || C.IsKnockdown() || C.IsStun())
		return
	var/area/vtm/V = get_area(C)
	if(!istype(V, /area/vtm) || !V.upper)
		to_chat(C, span_warning("You need to be outside to look at the moon!"))
		return
	if(C.last_moon_look == 0 || C.last_moon_look+600 < world.time)
		var/mob/living/carbon/werewolf/lupus/lupus = C.transformator.lupus_form?.resolve()
		var/mob/living/carbon/werewolf/crinos/crinos = C.transformator.crinos_form?.resolve()
		var/mob/living/carbon/human/homid = C.transformator.human_form?.resolve()
		var/mob/living/carbon/werewolf/corax/corax_crinos = C.transformator.corax_form?.resolve()
		var/mob/living/carbon/werewolf/lupus/corvid/corvid = C.transformator.corvid_form?.resolve()

		lupus?.last_moon_look = world.time
		crinos?.last_moon_look = world.time
		homid?.last_moon_look = world.time
		corax_crinos?.last_moon_look = world.time
		corvid?.last_moon_look = world.time

		to_chat(C, span_notice("The Moon is [GLOB.moon_state]."))
		to_chat(C, span_notice("You can activate transformations using Ctrl-Click!"))
		if(HAS_TRAIT(C, TRAIT_CORAX) || iscorax(C))
			C.emote("caw")
			if(!iscoraxcrinos(C))
				playsound(get_turf(C),'code/modules/wod13/sounds/cawcorvid.ogg', 100, FALSE)
			else
				playsound(get_turf(C),'code/modules/wod13/sounds/cawcrinos.ogg', 100, FALSE)
		else
			C.emote("howl")
			playsound(get_turf(C), pick('code/modules/wod13/sounds/awo1.ogg', 'code/modules/wod13/sounds/awo2.ogg'), 100, FALSE)
		icon_state = "[GLOB.moon_state]"
		adjust_rage(1, C, TRUE)

/datum/hud
	var/atom/movable/screen/auspice_icon

/datum/hud/werewolf/New(mob/living/carbon/werewolf/owner)
	..()

	var/atom/movable/screen/using
	var/atom/movable/screen/transform_werewolf



//equippable shit

//hands
	if(iscrinos(owner) || iscoraxcrinos(owner) || iscorvid(owner)) // corvid and crinos get hands
		build_hand_slots()

//begin buttons
	if HAS_TRAIT(owner, TRAIT_CORAX) // if we picked the Corax tribe, we get the HUD that makes you transform into the various Corax forms

		transform_werewolf = new /atom/movable/screen/transform_corvid()
		transform_werewolf.screen_loc = ui_werewolf_lupus
		transform_werewolf.hud = src
		static_inventory += transform_werewolf

		transform_werewolf = new /atom/movable/screen/transform_corax_crinos()
		transform_werewolf.screen_loc = ui_werewolf_crinos
		transform_werewolf.hud = src
		static_inventory += transform_werewolf

		transform_werewolf = new /atom/movable/screen/transform_homid()
		transform_werewolf.screen_loc = ui_werewolf_homid
		transform_werewolf.hud = src
		static_inventory += transform_werewolf

	else

		transform_werewolf = new /atom/movable/screen/transform_lupus()
		transform_werewolf.screen_loc = ui_werewolf_lupus
		transform_werewolf.hud = src
		static_inventory += transform_werewolf

		transform_werewolf = new /atom/movable/screen/transform_crinos()
		transform_werewolf.screen_loc = ui_werewolf_crinos
		transform_werewolf.hud = src
		static_inventory += transform_werewolf

		transform_werewolf = new /atom/movable/screen/transform_homid()
		transform_werewolf.screen_loc = ui_werewolf_homid
		transform_werewolf.hud = src
		static_inventory += transform_werewolf

	auspice_icon = new /atom/movable/screen/auspice() // auspice, rage and the fullscreen HUD icons are shared between the two sub-species
	auspice_icon.screen_loc = ui_werewolf_auspice
	auspice_icon.hud = src
	static_inventory += auspice_icon

	rage_icon = new /atom/movable/screen/rage()
	rage_icon.screen_loc = ui_werewolf_rage
	rage_icon.hud = src
	infodisplay += rage_icon

	using = new /atom/movable/screen/fullscreen_hud()
	using.screen_loc = ui_full_inventory
	using.hud = src
	static_inventory += using


	if(iscrinos(owner))
		using = new /atom/movable/screen/swap_hand()
		using.icon = 'code/modules/wod13/UI/buttons32.dmi'
		using.icon_state = "swap_1"
		using.screen_loc = ui_swaphand_position(owner,1)
		using.hud = src
		static_inventory += using

		using = new /atom/movable/screen/swap_hand()
		using.icon = 'code/modules/wod13/UI/buttons32.dmi'
		using.icon_state = "swap_2"
		using.screen_loc = ui_swaphand_position(owner,2)
		using.hud = src
		static_inventory += using
	if(iscoraxcrinos(owner))
		using = new /atom/movable/screen/swap_hand()
		using.icon = 'code/modules/wod13/UI/buttons32.dmi'
		using.icon_state = "swap_1"
		using.screen_loc = ui_swaphand_position(owner,1)
		using.hud = src
		static_inventory += using

		using = new /atom/movable/screen/swap_hand()
		using.icon = 'code/modules/wod13/UI/buttons32.dmi'
		using.icon_state = "swap_2"
		using.screen_loc = ui_swaphand_position(owner,2)
		using.hud = src
		static_inventory += using

	using = new /atom/movable/screen/act_intent()
	using.icon_state = mymob.a_intent
	using.icon = 'code/modules/wod13/UI/buttons32.dmi'
	using.hud = src
	static_inventory += using
	action_intent = using

	using = new/atom/movable/screen/language_menu
	using.screen_loc = ui_language_menu
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/drop()
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.screen_loc = ui_drop
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/resist()
	using.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	using.screen_loc = ui_resist
	using.hud = src
	hotkeybuttons += using

	throw_icon = new /atom/movable/screen/throw_catch()
	throw_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	throw_icon.screen_loc = ui_throw
	throw_icon.hud = src
	hotkeybuttons += throw_icon

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	pull_icon.update_appearance()
	pull_icon.screen_loc = ui_pull
	pull_icon.hud = src
	static_inventory += pull_icon

//begin indicators

	healths = new /atom/movable/screen/healths()
	healths.icon = 'code/modules/wod13/UI/buttons32.dmi'
	healths.hud = src
	infodisplay += healths
	blood_icon = new /atom/movable/screen/blood()
	blood_icon.screen_loc = ui_bloodpool
	blood_icon.hud = src
	infodisplay += blood_icon

	zone_select = new /atom/movable/screen/zone_sel()
	zone_select.icon = 'code/modules/wod13/UI/buttons64.dmi'
	zone_select.hud = src
	zone_select.update_appearance()
	static_inventory += zone_select

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_appearance()

/datum/hud/werewolf/persistent_inventory_update()
	if(!mymob)
		return
	if(!iscrinos(mymob) && !iscoraxcrinos(mymob) && !iscorvid(mymob))
		return
	var/mob/living/carbon/werewolf/H = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I))
			H.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			H.client.screen -= I
