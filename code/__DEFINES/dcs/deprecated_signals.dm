/*
** WARNING: These are deprecated signals that are to be removed in future PRs.
** At no  point should you be adding signals to this file.
** If you are adding a TFN related signal, put it in the signals/tfn_signals/ directory.
*/


///from proc/get_rad_contents(): ()
#define COMSIG_ATOM_RAD_PROBE "atom_rad_probe"
	#define COMPONENT_BLOCK_RADIATION (1<<0)
///from base of datum/radiation_wave/radiate(): (strength)
#define COMSIG_ATOM_RAD_CONTAMINATING "atom_rad_contam"
	#define COMPONENT_BLOCK_CONTAMINATION (1<<0)


///from base of /mob/proc/melee_swing()
#define COMSIG_MOB_MELEE_SWING "mob_melee_swing"

//Allows the user to examinate regardless of client.eye.
#define COMPONENT_ALLOW_EXAMINATE (1<<0)

///called when you send a mood event from anywhere in the code.
#define COMSIG_ADD_MOOD_EVENT "add_mood"
///Mood event that only RnD members listen for
#define COMSIG_ADD_MOOD_EVENT_RND "RND_add_mood"
///called when you clear a mood event from anywhere in the code.
#define COMSIG_CLEAR_MOOD_EVENT "clear_mood"

///() - returns bool.
#define COMSIG_CONTAINS_STORAGE "is_storage"
///(obj/item/inserting, mob/user, silent, force) - returns bool
#define COMSIG_TRY_STORAGE_INSERT "storage_try_insert"
///(mob/show_to, force) - returns bool.
#define COMSIG_TRY_STORAGE_SHOW "storage_show_to"
///(mob/hide_from) - returns bool
#define COMSIG_TRY_STORAGE_HIDE_FROM "storage_hide_from"
///returns bool
#define COMSIG_TRY_STORAGE_HIDE_ALL "storage_hide_all"
///(newstate)
#define COMSIG_TRY_STORAGE_SET_LOCKSTATE "storage_lock_set_state"
///() - returns bool. MUST CHECK IF STORAGE IS THERE FIRST!
#define COMSIG_IS_STORAGE_LOCKED "storage_get_lockstate"
///(type, atom/destination, amount = INFINITY, check_adjacent, force, mob/user, list/inserted) - returns bool - type can be a list of types.
#define COMSIG_TRY_STORAGE_TAKE_TYPE "storage_take_type"
///(type, amount = INFINITY, force = FALSE). Force will ignore max_items, and amount is normally clamped to max_items.
#define COMSIG_TRY_STORAGE_FILL_TYPE "storage_fill_type"
///(obj, new_loc, force = FALSE) - returns bool
#define COMSIG_TRY_STORAGE_TAKE "storage_take_obj"
///(loc) - returns bool - if loc is null it will dump at parent location.
#define COMSIG_TRY_STORAGE_QUICK_EMPTY "storage_quick_empty"
///(list/list_to_inject_results_into, recursively_search_inside_storages = TRUE)
#define COMSIG_TRY_STORAGE_RETURN_INVENTORY "storage_return_inventory"
///(obj/item/insertion_candidate, mob/user, silent) - returns bool
#define COMSIG_TRY_STORAGE_CAN_INSERT "storage_can_equip"


///from base of atom/proc/Initialize(): sent any time a new atom is created
#define COMSIG_ATOM_CREATED "atom_created"
///from base of atom/attackby(): (/obj/item, /mob/living, params)
#define COMSIG_PARENT_ATTACKBY "atom_attackby"

///called when a wrapped up structure is opened by hand
#define COMSIG_STRUCTURE_UNWRAPPED "structure_unwrapped"

// Aquarium related signals
#define COMSIG_AQUARIUM_BEFORE_INSERT_CHECK "aquarium_about_to_be_inserted"
#define COMSIG_AQUARIUM_SURFACE_CHANGED "aquarium_surface_changed"


///from base of atom/movable/Crossed(): (/atom/movable)
#define COMSIG_MOVABLE_CROSSED "movable_crossed"
///from base of atom/movable/Uncross(): (/atom/movable)
#define COMSIG_MOVABLE_UNCROSS "movable_uncross"
	#define COMPONENT_MOVABLE_BLOCK_UNCROSS (1<<0)


///When a carbon gets a vending machine tilted on them
#define COMSIG_ON_VENDOR_CRUSH "carbon_vendor_crush"


///from base of [/datum/reagents/proc/add_reagent]: (/datum/reagent, amount, reagtemp, data, no_react)
#define COMSIG_REAGENTS_NEW_REAGENT		"reagents_new_reagent"
///from base of [/datum/reagents/proc/add_reagent]: (/datum/reagent, amount, reagtemp, data, no_react)
#define COMSIG_REAGENTS_ADD_REAGENT		"reagents_add_reagent"
///from base of [/datum/reagents/proc/del_reagent]: (/datum/reagent)
#define COMSIG_REAGENTS_DEL_REAGENT		"reagents_del_reagent"
///from base of [/datum/reagents/proc/clear_reagents]: ()
#define COMSIG_REAGENTS_REM_REAGENT		"reagents_rem_reagent"
///from base of [/datum/reagents/proc/set_temperature]: (new_temp, old_temp)
#define COMSIG_REAGENTS_CLEAR_REAGENTS	"reagents_clear_reagents"
///from base of [/datum/reagents/proc/handle_reactions]: (num_reactions)
#define COMSIG_REAGENTS_REACTED			"reagents_reacted"
///from base of [/datum/component/personal_crafting/proc/del_reqs]: ()
#define COMSIG_REAGENTS_CRAFTING_PING	"reagents_crafting_ping"


///() returns TRUE if nanites are found
#define COMSIG_HAS_NANITES "has_nanites"
///() returns TRUE if nanites have stealth
#define COMSIG_NANITE_IS_STEALTHY "nanite_is_stealthy"
///() deletes the nanite component
#define COMSIG_NANITE_DELETE "nanite_delete"
///(list/nanite_programs) - makes the input list a copy the nanites' program list
#define COMSIG_NANITE_GET_PROGRAMS	"nanite_get_programs"
///(amount) Returns nanite amount
#define COMSIG_NANITE_GET_VOLUME "nanite_get_volume"
///(amount) Sets current nanite volume to the given amount
#define COMSIG_NANITE_SET_VOLUME "nanite_set_volume"
///(amount) Adjusts nanite volume by the given amount
#define COMSIG_NANITE_ADJUST_VOLUME "nanite_adjust"
///(amount) Sets maximum nanite volume to the given amount
#define COMSIG_NANITE_SET_MAX_VOLUME "nanite_set_max_volume"
///(amount(0-100)) Sets cloud ID to the given amount
#define COMSIG_NANITE_SET_CLOUD "nanite_set_cloud"
///(method) Modify cloud sync status. Method can be toggle, enable or disable
#define COMSIG_NANITE_SET_CLOUD_SYNC "nanite_set_cloud_sync"
///(amount) Sets safety threshold to the given amount
#define COMSIG_NANITE_SET_SAFETY "nanite_set_safety"
///(amount) Sets regeneration rate to the given amount
#define COMSIG_NANITE_SET_REGEN "nanite_set_regen"
///(code(1-9999)) Called when sending a nanite signal to a mob.
#define COMSIG_NANITE_SIGNAL "nanite_signal"
///(comm_code(1-9999), comm_message) Called when sending a nanite comm signal to a mob.
#define COMSIG_NANITE_COMM_SIGNAL "nanite_comm_signal"
///(mob/user, full_scan) - sends to chat a scan of the nanites to the user, returns TRUE if nanites are detected
#define COMSIG_NANITE_SCAN "nanite_scan"
///(list/data, scan_level) - adds nanite data to the given data list - made for ui_data procs
#define COMSIG_NANITE_UI_DATA "nanite_ui_data"
///(datum/nanite_program/new_program, datum/nanite_program/source_program) Called when adding a program to a nanite component
#define COMSIG_NANITE_ADD_PROGRAM "nanite_add_program"
	///Installation successful
	#define COMPONENT_PROGRAM_INSTALLED		(1<<0)
	///Installation failed, but there are still nanites
	#define COMPONENT_PROGRAM_NOT_INSTALLED	(1<<1)
///(datum/component/nanites, full_overwrite, copy_activation) Called to sync the target's nanites to a given nanite component
#define COMSIG_NANITE_SYNC "nanite_sync"



///from base of /obj/item/clothing/suit/space/proc/toggle_spacesuit(): (obj/item/clothing/suit/space/suit)
#define COMSIG_SUIT_SPACE_TOGGLE "suit_space_toggle"

///from base of obj/item/attack_qdeleted(): (atom/target, mob/user, params)
#define COMSIG_ITEM_ATTACK_QDELETED "item_attack_qdeleted"
///from base of /mob/living/attackby(obj/item/I, mob/living/user, params)
///	SEND_SIGNAL(src, COMSIG_MOB_ATTACKED_BY_MELEE, /*attacker =*/user, /*item =*/I, /*params =*/params)
#define COMSIG_MOB_ATTACKED_BY_MELEE "mob_attacked_by_melee"
///	SEND_SIGNAL(user, COMSIG_MOB_ATTACKING_MELEE, /*target =*/src, /*item =*/I, params)
#define COMSIG_MOB_ATTACKING_MELEE "mob_attacking_melee"
///from base of /mob/living/attack_hand(mob/living/carbon/human/user)
///SEND_SIGNAL(user, COMSIG_MOB_LIVING_ATTACK_HAND, /*target =*/src)
#define COMSIG_MOB_LIVING_ATTACK_HAND "mob_living_attack_hand"
///SEND_SIGNAL(src, COMSIG_MOB_ATTACKED_HAND, /*attacker =*/user)
#define COMSIG_MOB_ATTACKED_HAND "mob_attacked_hand"
///from base of obj/item/afterattack(): (atom/target, mob/user, proximity_flag, click_parameters)
#define COMSIG_MOB_ITEM_AFTERATTACK "mob_item_afterattack"
///from base of obj/item/attack_qdeleted(): (atom/target, mob/user, proxiumity_flag, click_parameters)
#define COMSIG_MOB_ITEM_ATTACK_QDELETED "mob_item_attack_qdeleted"

///From post-can inject check of syringe after attack (mob/user)
#define COMSIG_LIVING_TRY_SYRINGE "living_try_syringe"

///called on an object by its NTNET connection component on receive. (data(datum/netdata))
#define COMSIG_COMPONENT_NTNET_RECEIVE "ntnet_receive"
///called on an object by its NTNET connection component on a port update (hardware_id, port))
#define COMSIG_COMPONENT_NTNET_PORT_UPDATE "ntnet_port_update"
/// called when packet was accepted by the target (datum/netdata, error_code)
#define COMSIG_COMPONENT_NTNET_ACK "ntnet_ack"
/// called when packet was not acknoledged by the target (datum/netdata, error_code)
#define COMSIG_COMPONENT_NTNET_NAK "ntnet_nack"

// Some internal NTnet signals used on ports
///called on an object by its NTNET connection component on a port distruction (port, list/data))
#define COMSIG_COMPONENT_NTNET_PORT_DESTROYED "ntnet_port_destroyed"
///called on an object by its NTNET connection component on a port distruction (port, list/data))
#define COMSIG_COMPONENT_NTNET_PORT_UPDATED "ntnet_port_updated"

///called on item when crossed by something (): (/atom/movable, mob/living/crossed)
#define COMSIG_ITEM_WEARERCROSSED "wearer_crossed"
#define COMPONENT_SUCCESFUL_MICROWAVE (1<<0)
///Called when an object is turned into another item through grilling ontop of a griddle
#define COMSIG_GRILL_COMPLETED "item_grill_completed"

///called when teleporting into a protected turf: (channel, turf/origin)
#define COMSIG_ATOM_INTERCEPT_TELEPORT "intercept_teleport"
	#define COMPONENT_BLOCK_TELEPORT (1<<0)

///from slime CtrlClickOn(): (/mob)
#define COMSIG_XENO_SLIME_CLICK_CTRL "xeno_slime_click_ctrl"
///from slime AltClickOn(): (/mob)
#define COMSIG_XENO_SLIME_CLICK_ALT "xeno_slime_click_alt"
///from turf AltClickOn(): (/mob)
#define COMSIG_XENO_TURF_CLICK_CTRL "xeno_turf_click_alt"
///from monkey CtrlClickOn(): (/mob)
#define COMSIG_XENO_MONKEY_CLICK_CTRL "xeno_monkey_click_ctrl"

///from base of atom/movable/Uncrossed(): (/atom/movable)
#define COMSIG_MOVABLE_UNCROSSED "movable_uncrossed"

#define COMSIG_BODYPART_GAUZE_DESTROYED	"bodypart_degauzed" // from [/obj/item/bodypart/proc/seep_gauze] when it runs out of absorption

///from base of /mob/living/regenerate_limbs(): (noheal, excluded_limbs)
#define COMSIG_LIVING_REGENERATE_LIMBS "living_regen_limbs"


///sent to the instrument when a song starts playing
#define COMSIG_SONG_START 	"song_start"
///sent to the instrument when a song stops playing
#define COMSIG_SONG_END		"song_end"



///called on pda when the user changes the ringtone: (mob/living/user, new_ringtone)
#define COMSIG_PDA_CHANGE_RINGTONE "pda_change_ringtone"
#define COMSIG_PDA_CHECK_DETONATE "pda_check_detonate"
	#define COMPONENT_PDA_NO_DETONATE (1<<0)


///from base of atom/rad_act(intensity)
#define COMSIG_ATOM_RAD_ACT "atom_rad_act"

///called when the movable is placed in an unaccessible area, used for stationloving: ()
#define COMSIG_MOVABLE_SECLUDED_LOCATION "movable_secluded"


///from base of /obj/item/toy/crayon/spraycan/afterattack() (mob/user, atom/target)
#define COMSIG_MOB_USING_SPAYPRAINT "mob_using_spraypaint"

///sent to targets during the process_hit proc of projectiles
#define COMSIG_PELLET_CLOUD_INIT "pellet_cloud_init"

///from base of obj/allowed(mob/M): (/obj) returns bool, if TRUE the mob has id access to the obj
#define COMSIG_MOB_ALLOWED "mob_allowed"


///from base of obj/item/reagent_containers/food/drinks/attack(): (mob/living/M, mob/user)
#define COMSIG_DRINK_DRANK "drink_drank"


///from [/obj/item/proc/disableEmbedding]:
#define COMSIG_ITEM_DISABLE_EMBED "item_disable_embed"


///from base of obj/item/attack_atom(): (/obj, /mob)
#define COMSIG_ITEM_ATTACK_OBJ "item_attack_obj"


///sent to everyone in range of being affected by mask of madness
#define COMSIG_VOID_MASK_ACT "void_mask_act"

/// Called when a living mob has its resting updated: (resting_state)
#define COMSIG_LIVING_RESTING_UPDATED "resting_updated"

///from base of /mob/living/proc/apply_damage(): (damage, damagetype, def_zone)
#define COMSIG_MOB_APPLY_DAMGE	"mob_apply_damage"

//! signal sent out by an atom when it is being pulled by something else : (atom/puller)
#define COMSIG_MOVABLE_PULLED "movable_pulled"
#define COMSIG_MOVABLE_NO_LONGER_PULLED "movable_no_longer_pulled"	//! signal sent out by an atom when it is no longer being pulled by something else : (atom/puller)

#define COMSIG_FRYING_HANDLED (1<<0)

///from [/obj/item/proc/tryEmbed] sent when trying to force an embed (mainly for projectiles and eating glass)
#define COMSIG_EMBED_TRY_FORCE "item_try_embed"
	#define COMPONENT_EMBED_SUCCESS (1<<1)

///Sent when bloodcrawl ends in mob/living/phasein(): (phasein_decal)
#define COMSIG_LIVING_AFTERPHASEIN "living_phasein"

///Hit by successful disarm attack (mob/living/carbon/human/attacker,zone_targeted)
#define COMSIG_HUMAN_DISARM_HIT	"human_disarm_hit"

///from /mob/living/carbon/doUnEquip(obj/item/I, force, newloc, no_move, invdrop, silent)
#define COMSIG_CARBON_EQUIP_HAT "carbon_equip_hat"
///from /mob/living/carbon/doUnEquip(obj/item/I, force, newloc, no_move, invdrop, silent)
#define COMSIG_CARBON_UNEQUIP_HAT "carbon_unequip_hat"

/// Called when the floating anim has to be temporarily stopped and restarted later: (timer)
#define COMSIG_PAUSE_FLOATING_ANIM "pause_floating_anim"

///defined twice, in carbon and human's topics, fired when interacting with a valid embedded_object to pull it out (mob/living/carbon/target, /obj/item, /obj/item/bodypart/L)
#define COMSIG_CARBON_EMBED_RIP "item_embed_start_rip"


///When a carbon mob hugs someone, this is called on the carbon that is hugging. (mob/living/hugger, mob/living/hugged)
#define COMSIG_CARBON_HUG "carbon_hug"
///When a carbon mob is hugged, this is called on the carbon that is hugged. (mob/living/hugger)
#define COMSIG_CARBON_HUGGED "carbon_hugged"
///When a carbon mob is headpatted, this is called on the carbon that is headpatted. (mob/living/headpatter)
#define COMSIG_CARBON_HEADPAT "carbon_headpatted"

///from /mob/living/carbon/doUnEquip(obj/item/I, force, newloc, no_move, invdrop, silent)
#define COMSIG_CARBON_UNEQUIP_SHOECOVER "carbon_unequip_shoecover"

///called when removing a given item from a mob, from mob/living/carbon/remove_embedded_object(mob/living/carbon/target, /obj/item)
#define COMSIG_CARBON_EMBED_REMOVAL "item_embed_remove_safe"

//from base of atom/movable/on_enter_storage(): (datum/component/storage/concrete/master_storage)
#define COMSIG_STORAGE_ENTERED "storage_entered"
//from base of atom/movable/on_exit_storage(): (datum/component/storage/concrete/master_storage)
#define COMSIG_STORAGE_EXITED "storage_exited"

///from base of /atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE, quickstart = TRUE)
#define COMSIG_MOB_THREW_MOVABLE "mob_threw_movable"

#define COMPONENT_BLOCK_TOOL_ATTACK (1<<0)

///from base of atom/handle_atom_del(): (atom/deleted)
#define COMSIG_ATOM_CONTENTS_DEL "atom_contents_del"

#define COMPONENT_EXNAME_CHANGED (1<<0)

///from base of atom/CheckParts(): (list/parts_list, datum/crafting_recipe/R)
#define COMSIG_ATOM_CHECKPARTS "atom_checkparts"

#define COMSIG_ITEM_SPLIT_VALUE  (1<<0)

///called when an edible ingredient is added: (datum/component/edible/ingredient)
#define COMSIG_EDIBLE_INGREDIENT_ADDED "edible_ingredient_added"

#define COMPONENT_BLOCK_MAGIC (1<<0)

///from base of atom/setDir(): (old_dir, new_dir). Called before the direction changes.
#define COMSIG_KB_HUMAN_BLOCK "keybinding_human_block_down"

///called when an item is sold by the exports subsystem
#define COMSIG_ITEM_SOLD "item_sold"

#define COMSIG_CARBON_EQUIP_SHOECOVER "carbon_equip_shoecover"

///From /datum/component/creamed/Initialize()
#define COMSIG_MOB_CREAMED "mob_creamed"
