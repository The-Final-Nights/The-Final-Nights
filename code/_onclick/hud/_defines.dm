/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	In addition, the keywords NORTH, SOUTH, EAST, WEST and CENTER can be used to represent their respective
	screen borders. NORTH-1, for example, is the row just below the upper edge. Useful if you want your
	UI to scale with screen size.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

/proc/ui_hand_position(i) //values based on old hand ui positions (CENTER:-/+16,SOUTH:5)
	var/x_off = -(!(i % 2))
	var/y_off = round((i-1) / 2)
	return "WEST-[3+x_off],SOUTH+[y_off+6]:16"

/proc/ui_equip_position(mob/M)
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,SOUTH+1:5)
	return "WEST-3:16,SOUTH+[y_off+7]:16"

/proc/ui_swaphand_position(mob/M, which = 1) //values based on old swaphand ui positions (CENTER: +/-16,SOUTH+1:5)
	var/x_off = which == 1 ? -1 : 0
	var/y_off = round((M.held_items.len-1) / 2)
	return "WEST-[2-x_off],SOUTH+[y_off+7]:16"

//Lower left, persistent menu
#define ui_inventory "WEST:6,SOUTH:5"

#define ui_full_inventory "WEST-4,SOUTH"

//Middle left indicators
#define ui_lingchemdisplay "WEST,CENTER-1:15"
#define ui_lingstingdisplay "WEST:6,CENTER-3:11"

//Lower center, persistent menu
#define ui_sstore1 "WEST-2:16,SOUTH+8:22"
#define ui_id "WEST-4:16,SOUTH+8:22"
#define ui_belt "WEST-3:16,SOUTH+10:7"
#define ui_back "WEST-3:16,SOUTH+8:6"
#define ui_storage1 "WEST-4:16,SOUTH+7:22"
#define ui_storage2 "WEST-2:16,SOUTH+7:22"
#define ui_combo "CENTER+4:24,SOUTH+1:7" //combo meter for martial arts

#define ui_drinkblood "WEST-2:11,SOUTH+3:24"
#define ui_bloodheal "CENTER+2,SOUTH+1:8"
#define ui_bloodpower "CENTER+2:16,SOUTH+1:8"
#define ui_vtm_zone "CENTER-1:24,NORTH-2:24"

//Lower right, persistent menu
#define ui_throw "WEST-4:15,SOUTH+4:12"
#define ui_drop "WEST-4:15,SOUTH+4:2"
#define ui_jump "WEST-2:11,SOUTH+2:26"
#define ui_pull "WEST-2:11,SOUTH+2:16"
#define ui_resist "WEST-2:11,SOUTH+4:12"
#define ui_rest "WEST-4:15,SOUTH+3:24"
#define ui_block "WEST-2:11,SOUTH+4:2"
#define ui_movi "WEST-3:15,SOUTH+2:26"
#define ui_acti "WEST-3:16,SOUTH+1:16"
#define ui_combat_toggle "WEST-3:16,SOUTH+1:16"
#define ui_zonesel "WEST-4:16,SOUTH+1:16"
#define ui_acti_alt "WEST-3:16,SOUTH+1:16"	//alternative intent switcher for when the interface is hidden (F12)
#define ui_crafting	"WEST-2:11,SOUTH+3:4"
#define ui_building "EAST-4:22,SOUTH:21"
#define ui_language_menu "WEST-2:11,SOUTH+3:14"
#define ui_skill_menu "EAST-4:22,SOUTH:5"

//Upper-middle right (alerts)
#define ui_alert1 "EAST-1:28,CENTER+5:27"
#define ui_alert2 "EAST-1:28,CENTER+4:25"
#define ui_alert3 "EAST-1:28,CENTER+3:23"
#define ui_alert4 "EAST-1:28,CENTER+2:21"
#define ui_alert5 "EAST-1:28,CENTER+1:19"

//Middle right (status indicators)

#define ui_werewolf_lupus "EAST,CENTER+1:16"
#define ui_werewolf_crinos "EAST-1,CENTER+1:16"
#define ui_werewolf_homid "EAST-2,CENTER+1:16"
#define ui_werewolf_auspice "EAST-2:16,CENTER:16"
#define ui_werewolf_rage "EAST-2:20,CENTER-1:16"

#define ui_chi_pool "WEST-1,NORTH-4"
#define ui_chi_demon "WEST-1,NORTH-5"

#define ui_healthdoll "EAST-1:28,CENTER-3:13"
#define ui_health "WEST-2:16,SOUTH+1:16"
#define ui_bloodpool "WEST-4:16,SOUTH+5:1"
#define ui_internal "EAST-1:28,CENTER-4:10"
#define ui_mood "EAST-1:28,CENTER-1:17"
#define ui_spacesuit "EAST-1:28,CENTER-5:10"

//Pop-up inventory
#define ui_shoes "WEST-4:16,SOUTH+10:7"
#define ui_iclothing "WEST-4:16,SOUTH+11:7"
#define ui_oclothing "WEST-2:16,SOUTH+11:7"
#define ui_gloves "WEST-2:16,SOUTH+10:7"
#define ui_glasses "WEST-3:16,SOUTH+12:7"
#define ui_mask "WEST-3:16,SOUTH+11:7"
#define ui_ears "WEST-2:12,SOUTH+12:19"
#define ui_neck "WEST-4:20,SOUTH+12:19"
#define ui_head "WEST-3:16,SOUTH+13:7"

#define ui_gorg "WEST+2:6,SOUTH+3:5"
#define ui_cross1 "WEST+1:6,SOUTH+4:5"
#define ui_cross2 "WEST:6,SOUTH+4:5"

//Generic living
#define ui_living_pull "WEST-2:24,SOUTH+1:5"
#define ui_living_healthdoll "EAST-1:28,CENTER-1:15"

//Monkeys
#define ui_monkey_head "CENTER-5:13,SOUTH:5"
#define ui_monkey_mask "CENTER-4:14,SOUTH:5"
#define ui_monkey_neck "CENTER-3:15,SOUTH:5"
#define ui_monkey_back "CENTER-2:16,SOUTH:5"

//Drones
#define ui_drone_drop "CENTER+1:18,SOUTH:5"
#define ui_drone_pull "CENTER+2:2,SOUTH:5"
#define ui_drone_storage "CENTER-2:14,SOUTH:5"
#define ui_drone_head "CENTER-3:14,SOUTH:5"

//Cyborgs
#define ui_borg_health "EAST-1:28,CENTER-1:15"
#define ui_borg_pull "EAST-2:26,SOUTH+1:7"
#define ui_borg_radio "EAST-1:28,SOUTH+1:7"
#define ui_borg_intents "EAST-2:26,SOUTH:5"
#define ui_borg_lamp "CENTER-3:16, SOUTH:5"
#define ui_borg_tablet "CENTER-4:16, SOUTH:5"
#define ui_inv1 "CENTER-2:16,SOUTH:5"
#define ui_inv2 "CENTER-1  :16,SOUTH:5"
#define ui_inv3 "CENTER  :16,SOUTH:5"
#define ui_borg_module "CENTER+1:16,SOUTH:5"
#define ui_borg_store "CENTER+2:16,SOUTH:5"
#define ui_borg_camera "CENTER+3:21,SOUTH:5"
#define ui_borg_alerts "CENTER+4:21,SOUTH:5"
#define ui_borg_language_menu "CENTER+4:21,SOUTH+1:5"

//Aliens
#define ui_alien_health "EAST,CENTER-1:15"
#define ui_alienplasmadisplay "EAST,CENTER-2:15"
#define ui_alien_queen_finder "EAST,CENTER-3:15"
#define ui_alien_storage_r "CENTER+1:18,SOUTH:5"
#define ui_alien_language_menu "EAST-3:26,SOUTH:5"

//Constructs
#define ui_construct_pull "EAST,CENTER-2:15"
#define ui_construct_health "EAST,CENTER:15"

// AI
#define ui_ai_core "SOUTH:6,WEST"
#define ui_ai_camera_list "SOUTH:6,WEST+1"
#define ui_ai_track_with_camera "SOUTH:6,WEST+2"
#define ui_ai_camera_light "SOUTH:6,WEST+3"
#define ui_ai_crew_monitor "SOUTH:6,WEST+4"
#define ui_ai_crew_manifest "SOUTH:6,WEST+5"
#define ui_ai_alerts "SOUTH:6,WEST+6"
#define ui_ai_announcement "SOUTH:6,WEST+7"
#define ui_ai_shuttle "SOUTH:6,WEST+8"
#define ui_ai_state_laws "SOUTH:6,WEST+9"
#define ui_ai_pda_send "SOUTH:6,WEST+10"
#define ui_ai_pda_log "SOUTH:6,WEST+11"
#define ui_ai_take_picture "SOUTH:6,WEST+12"
#define ui_ai_view_images "SOUTH:6,WEST+13"
#define ui_ai_sensor "SOUTH:6,WEST+14"
#define ui_ai_multicam "SOUTH+1:6,WEST+13"
#define ui_ai_add_multicam "SOUTH+1:6,WEST+14"

// pAI
#define ui_pai_software "SOUTH:6,WEST"
#define ui_pai_shell "SOUTH:6,WEST+1"
#define ui_pai_chassis "SOUTH:6,WEST+2"
#define ui_pai_rest "SOUTH:6,WEST+3"
#define ui_pai_light "SOUTH:6,WEST+4"
#define ui_pai_newscaster "SOUTH:6,WEST+5"
#define ui_pai_host_monitor "SOUTH:6,WEST+6"
#define ui_pai_crew_manifest "SOUTH:6,WEST+7"
#define ui_pai_state_laws "SOUTH:6,WEST+8"
#define ui_pai_pda_send "SOUTH:6,WEST+9"
#define ui_pai_pda_log "SOUTH:6,WEST+10"
#define ui_pai_take_picture "SOUTH:6,WEST+12"
#define ui_pai_view_images "SOUTH:6,WEST+13"

//Ghosts
#define ui_ghost_jumptomob "SOUTH:6,CENTER-3:24"
#define ui_ghost_orbit "SOUTH:6,CENTER-2:24"
#define ui_ghost_reenter_corpse "SOUTH:6,CENTER-1:24"
#define ui_ghost_teleport "SOUTH:6,CENTER:24"
#define ui_ghost_pai "SOUTH: 6, CENTER+1:24"
#define ui_ghost_mafia "SOUTH: 6, CENTER+2:24"

#define ui_wanted_lvl "NORTH,11"
