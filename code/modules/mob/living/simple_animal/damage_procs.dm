
/mob/living/simple_animal/proc/adjustHealth(brute_amount, updating_health = TRUE, forced = FALSE, fire_amount, toxin_amount, oxy_amount, clone_amount)
	if(!forced && (status_flags & GODMODE))
		return FALSE
	bruteloss = round(clamp(bruteloss + brute_amount, 0, maxHealth * 2), DAMAGE_PRECISION)
	fireloss = round(clamp(fireloss + fire_amount, 0, maxHealth * 2), DAMAGE_PRECISION)
	toxloss = round(clamp(toxloss + toxin_amount, 0, maxHealth * 2), DAMAGE_PRECISION)
	oxyloss = round(clamp(oxyloss + oxy_amount, 0, maxHealth * 2), DAMAGE_PRECISION)
	cloneloss = round(clamp(cloneloss + clone_amount, 0, maxHealth * 2), DAMAGE_PRECISION)
	if(updating_health)
		updatehealth()
	return health

/mob/living/simple_animal/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_coeff[BRUTE])
		. = adjustHealth(amount * damage_coeff[BRUTE] * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/simple_animal/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(fire_amount = (amount * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)
	else if(damage_coeff[BURN])
		. = adjustHealth(fire_amount = (amount * damage_coeff[BURN] * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)

/mob/living/simple_animal/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(oxy_amount = (amount * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)
	else if(damage_coeff[OXY])
		. = adjustHealth(oxy_amount = (amount * damage_coeff[OXY] * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)

/mob/living/simple_animal/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(toxin_amount = (amount * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)
	else if(damage_coeff[TOX])
		. = adjustHealth(toxin_amount = (amount * damage_coeff[TOX] * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)

/mob/living/simple_animal/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	if(forced)
		. = adjustHealth(clone_amount = (amount * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)
	else if(damage_coeff[CLONE])
		. = adjustHealth(clone_amount = (amount * damage_coeff[CLONE] * CONFIG_GET(number/damage_multiplier)), updating_health = updating_health, forced = forced)

/mob/living/simple_animal/adjustStaminaLoss(amount, updating_health = FALSE, forced = FALSE)
	if(forced)
		staminaloss = max(0, min(max_staminaloss, staminaloss + amount))
	else
		staminaloss = max(0, min(max_staminaloss, staminaloss + (amount * damage_coeff[STAMINA])))
	update_stamina()
