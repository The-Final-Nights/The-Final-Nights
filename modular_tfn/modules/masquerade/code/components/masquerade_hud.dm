#define HUD_LIST_MASQUERADE "masquerade"

//Component that adds an exclamation mark to things that have caused you to breach the masquerade.
/datum/component/masquerade_hud
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/client/masquerade_breacher
	var/image/new_masquerade_image

/datum/component/masquerade_hud/Initialize(mob/_masquerade_breacher)
	if(!_masquerade_breacher.client)
		return COMPONENT_INCOMPATIBLE

	masquerade_breacher = _masquerade_breacher.client

	RegisterSignal(parent, COMSIG_MASQUERADE_HUD_DELETE, PROC_REF(delete_myself))

	create_masquerade_overlay()

/datum/component/masquerade_hud/proc/delete_myself(atom/source, mob/player_breacher)
	SIGNAL_HANDLER

	if((masquerade_breacher == player_breacher.client) || !masquerade_breacher)
		qdel(src)

/datum/component/masquerade_hud/Destroy(force)
	UnregisterSignal(parent, COMSIG_MASQUERADE_HUD_DELETE)
	masquerade_breacher?.images -= new_masquerade_image
	masquerade_breacher = null
	new_masquerade_image = null
	..()

/datum/component/masquerade_hud/proc/create_masquerade_overlay()
	SIGNAL_HANDLER

	var/atom/atom_parent = parent
	if(!atom_parent.hud_list)
		atom_parent.hud_list = list()

	if(!atom_parent.hud_list[HUD_LIST_MASQUERADE])
		atom_parent.hud_list[HUD_LIST_MASQUERADE] = image(icon = 'icons/obj/closet.dmi', loc = atom_parent, icon_state = "cardboard_special", layer = ABOVE_ALL_MOB_LAYER, pixel_z = 32)
		atom_parent.hud_list[HUD_LIST_MASQUERADE].appearance_flags |= TILE_BOUND
	new_masquerade_image = atom_parent.hud_list[HUD_LIST_MASQUERADE]
	masquerade_breacher?.images |= new_masquerade_image

#undef HUD_LIST_MASQUERADE
