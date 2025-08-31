// These signals are related to NPC masquerade violation and handling code.

// /datum/proximity_monitor/advanced/violation_check_aoe
#define COMSIG_MASQUERADE_VIOLATION "masquerade_violation"
// /datum/component/violation_observer
#define COMSIG_SEEN_MASQUERADE_VIOLATION "seen_masquerade_violation"
// /datum/component/masquerade_hud
#define COMSIG_MASQUERADE_HUD_DELETE "masquerade_hud_delete"
// mostly from phones
#define COMSIG_ALL_MASQUERADE_REINFORCE "masquerade_all_reinforce"

// Use this to fix all masquerade breaches on a player.
#define COMSIG_PLAYER_MASQUERADE_REINFORCE "player_masquerade_reinforce"

// The signal that is sent for when a player deals with a masquerade breach.
#define COMSIG_MASQUERADE_REINFORCE "masquerade_reinforce"
