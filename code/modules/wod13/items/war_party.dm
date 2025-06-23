/obj/item/sabbat_war_party
	name = "Sabbat War Party Totem"
	desc = "A totem made from a Vampire's skull, made to summon all Sabbat packs to the Ductus' lair."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "sabbat_warparty"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/activations = 0

/obj/item/sabbat_war_party/attack_self(mob/user)
	. = ..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	// Check if the user is a Sabbat Ductus or Priest
	if(!is_sabbat_ductus(user) && !is_sabbat_priest(user))
		to_chat(H, span_cult("Only the Ductus or the Priest may call a War Party from the Totem!"))
		return

	var/choice = tgui_alert(H, "Do you wish to send a message to all Sabbat in the city instructing them to return to the Sabbat lair?", "Return", list("Yes", "No"), 10 SECONDS)
	if(choice == "Yes")
		activations++
		var/success_chance = max(0, 100 - (activations - 1) * 33) // Reduce by 33% for each activation after the first

		// Inform the user about the current status of the totem
		to_chat(H, span_notice("The skull's eyes flare with crimson light as you invoke its power. [activations > 1 ? "The light seems dimmer than before." : ""]"))
		if(activations > 1)
			to_chat(H, span_cult("The War Party Totem has been used [activations] times. Its power to compel Sabbat is weakening."))

		for(var/mob/living/carbon/human/sabbat_member in GLOB.player_list)
			if(sabbat_member.mind && is_sabbatist(sabbat_member))
				// Roll for each Sabbat member to see if they receive the call
				if(activations == 1 || prob(success_chance))
					to_chat(sabbat_member, span_cult("The Ductus calls all pack members back to the lair, return at once!"))
					SEND_SOUND(sabbat_member, sound('code/modules/wod13/sounds/announce.ogg'))
					sabbat_member.emote("twitch")

		// Tell the Sabbat Priest how successful (authoritative) the Ductus' call was.
		if(activations > 1)
			var/remaining_power = max(0, round(success_chance))
			var/power_message = "The totem's power has waned to [remaining_power]% of its original strength.\n"

			// Send the power message to the Sabbat Priest
			for(var/mob/living/carbon/human/priest in GLOB.player_list)
				if(priest.mind && is_sabbat_priest(priest))
					to_chat(priest, span_cult("[power_message] Only you, as the Priest, can sense this weakening. As the totem's power fades, so too does the Ductus' authority. Perhaps it is time for a new Ductus..."))
					break // Only send to one priest, assuming there's only one, which there should be
	else
		to_chat(user, span_warning("You decide not to call a war party."))

