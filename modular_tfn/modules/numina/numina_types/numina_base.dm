// I was asked not to make Numinas piggyback off of vampire clans. Which, okay, fair enough.
// However, most Numina functions basically the same as clans and disciplines.
// So if all of this seems familiar to you, thats why. Its basically just clan code.

/datum/numina_pattern
	/// Name of the Numina
	var/name
	/// Description of the Numina
	var/desc
	/// Description of the Numina's supernatural curse
	var/curse

	/// List of Disciplines that are innate to this Numina
	var/list/numina_disciplines = list()
	/// List of Disciplines that are rejected by this Numina
	var/list/restricted_disciplines = list()
	//Discs that you don't start with but are easier to purchase
	var/list/common_disciplines = list()
	/// List of traits that are applied to members of this Numina
	var/list/numina_traits = list()

	/// Default clothing for male members of this Numina
	var/male_clothes
	/// Default clothing for female members of this Numina
	var/female_clothes
	/// Keys for this Numina's exclusive hideout. Most will never have one, but the function is preserved for future usecases.
	var/faction_keys

	/// If this Numina needs a whitelist to select and play. Most of them will be.
	var/whitelisted

/datum/numina_pattern/proc/on_gain(mob/living/carbon/human/numinauser, joining_round)
	SHOULD_CALL_PARENT(TRUE)

	for (var/trait in numina_traits)
		ADD_TRAIT(numinauser, trait, NUMINA_TRAIT)

	if (joining_round)
		RegisterSignal(numinauser, COMSIG_MOB_LOGIN, PROC_REF(on_join_round), override = TRUE)

	numinauser.update_body_parts()
	numinauser.update_body()
	numinauser.update_icon()

/datum/numina_pattern/proc/on_lose(mob/living/carbon/human/numinauser)
	SHOULD_CALL_PARENT(TRUE)

	for (var/trait in numina_traits)
		REMOVE_TRAIT(numinauser, trait, NUMINA_TRAIT)

	numinauser.update_body()

/datum/numina_pattern/proc/on_join_round(mob/living/carbon/human/numinauser)
	SIGNAL_HANDLER

	SHOULD_CALL_PARENT(TRUE)

	if (faction_keys)
		numinauser.put_in_r_hand(new faction_keys(numinauser))

	UnregisterSignal(numinauser, COMSIG_MOB_LOGIN)


/mob/living/carbon/human/proc/set_numina(setting_numina, joining_round)
	var/datum/numina_pattern/previous_numina = numina

	var/datum/numina_pattern/new_numina = ispath(setting_numina) ? GLOB.numina_clans[setting_numina] : setting_numina

	previous_numina?.on_lose(src)

	numina = new_numina

	if (!new_numina)
		return

	numina.on_gain(src, joining_round)


