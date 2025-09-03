/datum/species/garou
	name = "Werewolf"
	id = "garou"
	default_color = "FFFFFF"
	toxic_food = PINEAPPLE
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_VIRUSIMMUNE, TRAIT_PERFECT_ATTACKER)
	use_skintones = TRUE
	limbs_id = "human"
	wings_icon = "Dragon"
	brutemod = 0.75
	heatmod = 1
	burnmod = 1
	dust_anim = "dust-h"
	punchdamagelow = 10
	punchdamagehigh = 20
	whitelisted = TRUE
	selectable = TRUE
	species_language_holder = /datum/language_holder/werewolf
	var/glabro = FALSE

#define RAGE_LIFE_COOLDOWN 30 SECONDS

/datum/species/garou/spec_life(mob/living/carbon/human/H)
	if(H.stat == DEAD)
		return

	var/gaining_rage = TRUE
	for(var/obj/structure/werewolf_totem/W in GLOB.totems)
		if(W.totem_health)
			if(W.tribe == H.auspice.tribe.name)
				if(get_area(W) == get_area(H) && H.client)
					gaining_rage = FALSE
					if(H.last_gnosis_buff+300 < world.time)
						H.last_gnosis_buff = world.time
						adjust_gnosis(1, H, TRUE)
	if(iscrinos(H))
		if(H.auspice.breed_form == FORM_CRINOS)
			gaining_rage = FALSE
	if(islupus(H))
		if(H.auspice.breed_form == FORM_LUPUS)
			gaining_rage = FALSE
	if(ishuman(H))
		if(H.auspice.breed_form == FORM_HOMID || HAS_TRAIT(H, TRAIT_CORAX)) // Corvid-born Corax don't generate rage when in homid passively, the hope is to make talking more relaxed and the Corax weaker in combat.
			gaining_rage = FALSE
	if (iscorvid(H))
		gaining_rage = FALSE // Corax will ideally be talking a lot, not having passive rage generation should also make them weaker in combat.
	if (iscoraxcrinos(H))
		gaining_rage = TRUE // Corax have no Metis, Crinos is uneasy no matter your breed, no "buts" about it.

	if(gaining_rage && H.client)
		if(((H.last_rage_gain + RAGE_LIFE_COOLDOWN) < world.time) && (H.auspice.rage <= 6))
			H.last_rage_gain = world.time
			adjust_rage(1, H, TRUE)

	if(H.masquerade_score == 0)
		if(!is_special_character(H))
			if(H.auspice.gnosis)
				to_chat(H, "<span class='warning'>My Veil is too low to connect with the spirits of the Umbra!</span>")
				adjust_gnosis(-1, H, FALSE)

	if(H.auspice.rage >= 9)
		if(!H.in_frenzy)
			if((H.last_frenzy_check + 40 SECONDS) <= world.time)
				H.last_frenzy_check = world.time
				H.rollfrenzy()

	if(H.masquerade_score < 5)
		if(COOLDOWN_FINISHED(H, veil_restore))
			COOLDOWN_START(H, veil_restore, UMBRA_VEIL_COOLDOWN)
			H.check_veil_adjust()
// currently being in your caern restores veil to max because theres no other way of doing. remember to cap it to THREE once shame rituals are back

#undef RAGE_LIFE_COOLDOWN

/datum/action/garouinfo
	name = "About Me"
	desc = "Check assigned role, auspice, generation, humanity, masquerade, known disciplines, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/host

/datum/action/garouinfo/Trigger(trigger_flags)
	if(host)
		var/dat = {"
			<style type="text/css">

			body {
				background-color: #090909; color: white;
			}

			</style>
			"}
		dat += "<center><h2>Memories</h2><BR></center>"
		dat += "[icon2html(getFlatIcon(host), host)]I am "
		if(host.real_name)
			dat += "[host.real_name],"
		if(!host.real_name)
			dat += "Unknown,"
		dat += " [host.auspice.tribe.name] [host.auspice.breed_form]"
		if(host.mind)

			if(host.mind.assigned_role)
				if(host.mind.special_role)
					dat += ", carrying the [host.mind.assigned_role] (<font color=red>[host.mind.special_role]</font>) role."
				else
					dat += ", carrying the [host.mind.assigned_role] role."
			if(!host.mind.assigned_role)
				dat += "."
			dat += "<BR>"
		if(host.mind.special_role)
			for(var/datum/antagonist/A in host.mind.antag_datums)
				if(A.objectives)
					dat += "[printobjectives(A.objectives)]<BR>"
		var/masquerade_level = " have followed the rules tonight."
		switch(host.masquerade_score)
			if(4)
				masquerade_level = " have made a faux pas tonight."
			if(3)
				masquerade_level = " have made a few issues tonight."
			if(2)
				masquerade_level = " have erred tonight."
			if(1)
				masquerade_level = " have acted foolishly and caused an uproar."
			if(0)
				masquerade_level = " should beg our totem for forgiveness."
		dat += "My sect thinks I[masquerade_level]<BR>"

		dat += "<b>Physique</b>: [host.physique] + [host.additional_physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity] + [host.additional_dexterity]<BR>"
		dat += "<b>Social</b>: [host.social] + [host.additional_social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality] + [host.additional_mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood] + [host.additional_blood]<BR>"
		dat += "<b>Lockpicking</b>: [host.lockpicking] + [host.additional_lockpicking]<BR>"
		dat += "<b>Athletics</b>: [host.athletics] + [host.additional_athletics]<BR><BR>"
		dat += "<b>Gnosis</b>: [host.auspice.gnosis]<BR>"
		dat += "<b>Rank</b>: [RankName(host.renownrank)]<BR>"
		if(host.auspice.tribe.name == "Black Spiral Dancers")
			dat += "<b>Power</b>: [host.honor]<BR>"
			dat += "<b>Infamy</b>: [host.glory]<BR>"
			dat += "<b>Cunning</b>: [host.wisdom]<BR>"
		else
			dat += "<b>Honor</b>: [host.honor]<BR>"
			dat += "<b>Glory</b>: [host.glory]<BR>"
			dat += "<b>Wisdom</b>: [host.wisdom]<BR>"
		if(host.Myself)
			if(host.Myself.Friend)
				if(host.Myself.Friend.owner)
					dat += "<b>My friend's name is [host.Myself.Friend.owner.true_real_name].</b><BR>"
					if(host.Myself.Friend.phone_number)
						dat += "Their number is [host.Myself.Friend.phone_number].<BR>"
					if(host.Myself.Friend.friend_text)
						dat += "[host.Myself.Friend.friend_text]<BR>"
			if(host.Myself.Enemy)
				if(host.Myself.Enemy.owner)
					dat += "<b>My nemesis is [host.Myself.Enemy.owner.true_real_name]!</b><BR>"
					if(host.Myself.Enemy.enemy_text)
						dat += "[host.Myself.Enemy.enemy_text]<BR>"
			if(host.Myself.Lover)
				if(host.Myself.Lover.owner)
					dat += "<b>I'm in love with [host.Myself.Lover.owner.true_real_name].</b><BR>"
					if(host.Myself.Lover.phone_number)
						dat += "Their number is [host.Myself.Lover.phone_number].<BR>"
					if(host.Myself.Lover.lover_text)
						dat += "[host.Myself.Lover.lover_text]<BR>"
		if(LAZYLEN(host.knowscontacts) > 0)
			dat += "<b>I know some other of my kind in this city. Need to check my phone, there definetely should be:</b><BR>"
			for(var/i in host.knowscontacts)
				dat += "-[i] contact<BR>"
		if(istype(host, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = host
			for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
				if(H.bank_id == account.bank_id)
					dat += "<b>My bank account code is: [account.code]</b><BR>"
		host << browse(dat, "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)

/datum/species/garou/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	C.update_body(0)
	C.last_experience = world.time+3000
	var/datum/action/garouinfo/infor = new()
	infor.host = C
	infor.Grant(C)
	var/datum/action/gift/glabro/glabro = new()
	glabro.Grant(C)
	var/datum/action/gift/rage_heal/GH = new()
	GH.Grant(C)
	var/datum/action/gift/howling/howl = new()
	howl.Grant(C)
	C.transformator = new(C)
	C.transformator.human_form = WEAKREF(C)

	var/mob/living/carbon/werewolf/lupus/lupus = C.transformator.lupus_form?.resolve()
	var/mob/living/carbon/werewolf/crinos/crinos = C.transformator.crinos_form?.resolve()
	var/mob/living/carbon/werewolf/lupus/corvid/corvid = C.transformator.corvid_form?.resolve()
	var/mob/living/carbon/werewolf/corax/corax_crinos/corax_crinos = C.transformator.corax_form?.resolve()

	//garou resist vampire bites better than mortals
	RegisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))
	RegisterSignal(lupus, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))
	RegisterSignal(crinos, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))
	RegisterSignal(corvid, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))
	RegisterSignal(corax_crinos, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_garou_bitten))

/datum/species/garou/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	var/mob/living/carbon/werewolf/lupus/lupus = C.transformator.lupus_form?.resolve()
	var/mob/living/carbon/werewolf/crinos/crinos = C.transformator.crinos_form?.resolve()
	var/mob/living/carbon/werewolf/lupus/corvid/corvid = C.transformator.corvid_form?.resolve()
	var/mob/living/carbon/werewolf/corax/corax_crinos/corax_crinos = C.transformator.corax_form?.resolve()

	UnregisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED)
	UnregisterSignal(lupus, COMSIG_MOB_VAMPIRE_SUCKED)
	UnregisterSignal(crinos, COMSIG_MOB_VAMPIRE_SUCKED)
	UnregisterSignal(corvid, COMSIG_MOB_VAMPIRE_SUCKED)
	UnregisterSignal(corax_crinos, COMSIG_MOB_VAMPIRE_SUCKED)

	for(var/datum/action/garouinfo/VI in C.actions)
		VI.Remove(C)
	for(var/datum/action/gift/G in C.actions)
		G.Remove(C)

/datum/species/garou/check_roundstart_eligible()
	return FALSE

/proc/adjust_rage(amount, mob/living/carbon/C, sound = TRUE)
	if(amount > 0)
		if(C.auspice.rage < 10)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_increase.ogg', 0, 0, 50))
			to_chat(C, "<span class='userdanger'><b>RAGE INCREASES</b></span>")
			C.auspice.rage = min(10, C.auspice.rage+amount)
	if(amount < 0)
		if(C.auspice.rage > 0)
			C.auspice.rage = max(0, C.auspice.rage+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 50))
			to_chat(C, "<span class='userdanger'><b>RAGE DECREASES</b></span>")
	C.update_rage_hud()

/proc/adjust_gnosis(amount, mob/living/carbon/C, sound = TRUE)
	if(amount > 0)
		if(C.auspice.gnosis < C.auspice.start_gnosis)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 50))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS INCREASES</b></span>")
			C.auspice.gnosis = min(C.auspice.start_gnosis, C.auspice.gnosis+amount)
	if(amount < 0)
		if(C.auspice.gnosis > 0)
			C.auspice.gnosis = max(0, C.auspice.gnosis+amount)
			if(sound)
				SEND_SOUND(C, sound('code/modules/wod13/sounds/rage_decrease.ogg', 0, 0, 50))
			to_chat(C, "<span class='boldnotice'><b>GNOSIS DECREASES</b></span>")
	C.update_rage_hud()

/**
 * On being bit by a vampire
 *
 * This handles vampire bite sleep immunity and any future special interactions.
 */
/datum/species/garou/proc/on_garou_bitten(datum/source, mob/living/carbon/being_bitten)
	SIGNAL_HANDLER

	if(isgarou(being_bitten) || iswerewolf(being_bitten))
		return COMPONENT_RESIST_VAMPIRE_KISS
