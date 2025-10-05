/obj/effect/vip_barrier/endron
	name = "Endron Checkpoint"
	desc = "There's an employees only sign here."
	protected_zone_id = "endron"
	social_roll_difficulty = 7

/obj/effect/vip_barrier/endron/endron_2
	protected_zone_id = "endron_2"

/obj/effect/vip_barrier/endron/endron_backdoor
	protected_zone_id = "endron_backdoor"

/obj/effect/vip_barrier/endron/endron_lab
	protected_zone_id = "endron_lab"

/obj/effect/vip_barrier/endron/endron_lab_2
	protected_zone_id = "endron_lab_2"

/obj/effect/vip_barrier/endron/check_entry_permission_custom(mob/living/carbon/human/entering_mob)
	if(entering_mob.mind && entering_mob.mind.assigned_role && GLOB.spiral_positions.Find(entering_mob.mind.assigned_role))
		return TRUE
	return FALSE
