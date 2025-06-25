#define REGENERATION_DELAY 60  // After taking damage, how long it takes for automatic regeneration to begin

/datum/species/zombie
	name = "Zombie"
	id = "zombie"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LIMBATTACHMENT, TRAIT_VIRUSIMMUNE, TRAIT_NOBLEED, TRAIT_NOHUNGER, TRAIT_NOBREATH, TRAIT_NOMETABOLISM, TRAIT_TOXIMMUNE, TRAIT_NOCRITDAMAGE, TRAIT_FAKEDEATH)
	use_skintones = TRUE
	limbs_id = "rotten2"
	mutantbrain = /obj/item/organ/brain/vampire //to prevent brain transplant surgery
	mutanteyes = /obj/item/organ/eyes/night_vision/zombie
	brutemod = 0.5
	heatmod = 1	
	burnmod = 2
	punchdamagelow = 10
	punchdamagehigh = 20
	bodytemp_normal = T0C // They have no natural body heat, the environment regulates body temp
	dust_anim = "dust-h"

/datum/species/zombie/infectious
	name = "Infectious Zombie"
	id = "memezombies"
	limbs_id = "zombie"
	mutanthands = /obj/item/zombie_hand
	armor = 20 // 120 damage to KO a zombie, which kills it
	speedmod = 1.6
	mutanteyes = /obj/item/organ/eyes/night_vision/zombie
	var/heal_rate = 1
	var/regen_cooldown = 0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN

/// Zombies do not stabilize body temperature they are the walking dead and are cold blooded
/datum/species/zombie/body_temperature_core(mob/living/carbon/human/humi)
	return

/datum/species/zombie/infectious/check_roundstart_eligible()
	return FALSE

/datum/species/zombie/infectious/spec_stun(mob/living/carbon/human/H,amount)
	. = min(20, amount)

/datum/species/zombie/infectious/spec_life(mob/living/carbon/C)
	. = ..()
	C.set_combat_mode(TRUE) // THE SUFFERING MUST FLOW

	//Zombies never actually die, they just fall down until they regenerate enough to rise back up.
	//They must be restrained, beheaded or gibbed to stop being a threat.
	if(regen_cooldown < world.time)
		var/heal_amt = heal_rate
		if(HAS_TRAIT(C, TRAIT_CRITICAL_CONDITION))
			heal_amt *= 2
		C.heal_overall_damage(heal_amt,heal_amt)
		C.adjustToxLoss(-heal_amt)
		for(var/i in C.all_wounds)
			var/datum/wound/iter_wound = i
			if(prob(4-iter_wound.severity))
				iter_wound.remove_wound()

//Congrats you somehow died so hard you stopped being a zombie
/datum/species/zombie/infectious/spec_death(gibbed, mob/living/carbon/C)
	. = ..()
	var/obj/item/organ/zombie_infection/infection
	infection = C.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(infection)
		qdel(infection)

/datum/species/zombie/infectious/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()

	// Deal with the source of this zombie corruption
	//  Infection organ needs to be handled separately from mutant_organs
	//  because it persists through species transitions
	var/obj/item/organ/zombie_infection/infection
	infection = C.getorganslot(ORGAN_SLOT_ZOMBIE)
	if(!infection)
		infection = new()
		infection.Insert(C)

// Your skin falls off
/datum/species/krokodil_addict
	name = "Human"
	id = "goofzombies"
	limbs_id = "zombie" //They look like zombies
	sexes = 0
	meat = /obj/item/food/meat/slab/human/mutant/zombie
	mutanttongue = /obj/item/organ/tongue/zombie
	changesource_flags = MIRROR_BADMIN | WABBAJACK | ERT_SPAWN
	species_traits = list(HAS_FLESH, HAS_BONE)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_EASILY_WOUNDED)


/datum/species/zombie/check_roundstart_eligible()
	return FALSE

/datum/action/zombieinfo
	name = "About Me"
	desc = "Check assigned role, master, masquerade, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/zombieinfo/Trigger()
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
		if(host.dna.species.name == "Zombie")
			dat += " the zombie"

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
		var/masquerade_level = " have been a perfect tool for my Necromancer."
		switch(host.masquerade)
			if(4)
				masquerade_level = " have let my true nature slip once."
			if(3)
				masquerade_level = " made errors in maintaining my Necromancer's image."
			if(2)
				masquerade_level = " cause great trouble to my masters."
			if(1)
				masquerade_level = " am close to outliving my usefulness."
			if(0)
				masquerade_level = " have become a danger to my Necromancer and their society."
		dat += "In the world of the mundane, I[masquerade_level]<BR>"
		dat += "<b>Physique</b>: [host.physique] + [host.additional_physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity] + [host.additional_dexterity]<BR>"
		dat += "<b>Social</b>: [host.social] + [host.additional_social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality] + [host.additional_mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood] + [host.additional_blood]<BR>"
		dat += "<b>Lockpicking</b>: [host.lockpicking] + [host.additional_lockpicking]<BR>"
		dat += "<b>Athletics</b>: [host.athletics] + [host.additional_athletics]<BR>"
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
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
			if(host.bank_id == account.bank_id)
				dat += "<b>My bank account code is: [account.code]</b><BR>"
		host << browse(HTML_SKELETON(dat), "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "zombie", src)

/datum/species/zombie/on_species_gain(mob/living/carbon/human/C)
	..()
	C.skin_tone = "albino"
	C.hairstyle = "Bald"
	C.unique_body_sprite = "rotten2"
	C.base_body_mod = ""
	C.update_body_parts()
	C.update_body(0)
	C.last_experience = world.time+3000
	var/datum/action/zombieinfo/infor = new()
	infor.host = C
	infor.Grant(C)

	C.maxHealth = 300 //tanky
	C.health = 300

	C.yang_chi = 0
	C.max_yang_chi = 0
	C.yin_chi = 6
	C.max_yin_chi = 6

	//zombies resist vampire bites better than mortals
	RegisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED, PROC_REF(on_zombie_bitten))

/datum/species/ghoul/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_VAMPIRE_SUCKED)
	for(var/datum/action/zombieinfo/infor in C.actions)
		if(infor)
			infor.Remove(C)

/datum/species/zombie/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(HAS_TRAIT(H, TRAIT_UNMASQUERADE))
		if(H.CheckEyewitness(H, H, 7, FALSE))
			H.AdjustMasquerade(-1)
	
	if(H.is_face_visible())
		if (H.CheckEyewitness(H, H, 5, FALSE)) //it's san fran, there are crackheads everywhere
			H.AdjustMasquerade(-1)

/datum/species/zombie/proc/on_zombie_bitten(datum/source, mob/living/carbon/being_bitten)
	SIGNAL_HANDLER

	if(iszombie(being_bitten))
		return COMPONENT_RESIST_VAMPIRE_KISS

#undef REGENERATION_DELAY
