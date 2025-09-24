/datum/action/gift/stoic_pose
	name = "Stoic Pose"
	desc = "With this gift garou sends theirself into cryo-state, ignoring all incoming damage but also covering themself in a block of ice."
	button_icon_state = "stoic_pose"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/stoic_pose/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/ice_blocking.ogg', 100, FALSE)
		var/mob/living/C = owner
		if(isgarou(C))
			var/obj/were_ice/W = new (get_turf(owner))
			C.Stun(12 SECONDS)
			C.forceMove(W)
			spawn(12 SECONDS)
				C.forceMove(get_turf(W))
				qdel(W)
		if(iscrinos(C))
			var/obj/were_ice/crinos/W = new (get_turf(owner))
			C.Stun(12 SECONDS)
			C.forceMove(W)
			spawn(12 SECONDS)
				C.forceMove(get_turf(W))
				qdel(W)
		if(islupus(C))
			var/obj/were_ice/lupus/W = new (get_turf(owner))
			C.Stun(12 SECONDS)
			C.forceMove(W)
			spawn(12 SECONDS)
				C.forceMove(get_turf(W))
				qdel(W)

/datum/action/gift/freezing_wind
	name = "Freezing Wind"
	desc = "Garou of Galestalkers Tribe can create a stream of cold, freezing wind, and strike her foes with it."
	button_icon_state = "freezing_wind"
	rage_req = 1

/datum/action/gift/freezing_wind/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/wind_cast.ogg', 100, FALSE)
		for(var/turf/T in range(3, get_step(get_step(owner, owner.dir), owner.dir)))
			if(owner.loc != T)
				var/obj/effect/wind/W = new(T)
				W.dir = owner.dir
				W.strength = 100
				spawn(200)
					qdel(W)

/datum/action/gift/bloody_feast
	name = "Bloody Feast"
	desc = "By eating a grabbed corpse, garou can redeem their lost health and heal the injuries."
	button_icon_state = "bloody_feast"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/bloody_feast/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/C = owner
		if(C.pulling)
			if(isliving(C.pulling))
				var/mob/living/L = C.pulling
				if(L.stat == DEAD)
					playsound(get_turf(owner), 'code/modules/wod13/sounds/bloody_feast.ogg', 50, FALSE)
					qdel(L)
					C.revive(full_heal = TRUE, admin_revive = TRUE)

/datum/action/gift/stinky_fur
	name = "Stinky Fur"
	desc = "Garou creates an aura of very toxic smell, which disorientates everyone around."
	button_icon_state = "stinky_fur"

/datum/action/gift/stinky_fur/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		playsound(get_turf(owner), 'code/modules/wod13/sounds/necromancy.ogg', 75, FALSE)
		for(var/mob/living/carbon/C in orange(5, owner))
			if(C)
				if(prob(25))
					C.vomit()
				C.dizziness += 10
				C.add_confusion(10)

/datum/action/gift/venom_claws
	name = "Venom Claws"
	desc = "While this ability is active, strikes with claws poison foes of garou."
	button_icon_state = "venom_claws"
	rage_req = 1

/datum/action/gift/venom_claws/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/venom_claws.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.melee_damage_lower = initial(H.melee_damage_lower)+15
			H.melee_damage_upper = initial(H.melee_damage_upper)+15
			H.tox_damage_plus = 15
			to_chat(owner, span_notice("You feel your claws filling with pure venom..."))
			spawn(12 SECONDS)
				H.tox_damage_plus = 0
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				to_chat(owner, span_warning("Your claws are not poison anymore..."))
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/venom_claws.ogg', 75, FALSE)
			var/mob/living/carbon/H = owner
			H.melee_damage_lower = initial(H.melee_damage_lower)+10
			H.melee_damage_upper = initial(H.melee_damage_upper)+10
			H.tox_damage_plus = 10
			to_chat(owner, span_notice("You feel your claws filling with pure venom..."))
			spawn(12 SECONDS)
				H.tox_damage_plus = 0
				H.melee_damage_lower = initial(H.melee_damage_lower)
				H.melee_damage_upper = initial(H.melee_damage_upper)
				to_chat(owner, span_warning("Your claws are not poison anymore..."))

/datum/action/gift/burning_scars
	name = "Burning Scars"
	desc = "Garou creates an aura of very hot air, which burns everyone around."
	button_icon_state = "burning_scars"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/burning_scars/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		owner.visible_message(span_warning("[owner.name] crackles with heat!</span>"), span_danger("You crackle with heat, charging up your Gift!"))
		if(do_after(owner, 3 SECONDS))
			for(var/mob/living/L in orange(5, owner))
				if(L)
					L.adjustFireLoss(40)
			for(var/turf/T in orange(4, get_turf(owner)))
				var/obj/effect/fire/F = new(T)
				spawn(5)
					qdel(F)

/datum/action/gift/smooth_move
	name = "Smooth Move"
	desc = "Garou jumps forward, avoiding every damage for a moment."
	button_icon_state = "smooth_move"

/datum/action/gift/smooth_move/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/turf/T = get_turf(get_step(get_step(get_step(owner, owner.dir), owner.dir), owner.dir))
		if(!T || T == owner.loc)
			return
		owner.visible_message(span_danger("[owner] charges!"))
		owner.setDir(get_dir(owner, T))
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(owner.loc,owner)
		animate(D, alpha = 0, color = "#FF0000", transform = matrix()*2, time = 1)
		spawn(3)
			owner.throw_at(T, get_dist(owner, T), 1, owner, 0)

/datum/action/gift/digital_feelings
	name = "Digital Feelings"
	desc = "Every technology creates an electrical strike, which hits garou's enemies."
	button_icon_state = "digital_feelings"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/digital_feelings/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		owner.visible_message(span_danger("[owner.name] crackles with static electricity!"), span_danger("You crackle with static electricity, charging up your Gift!"))
		if(do_after(owner, 3 SECONDS))
			playsound(owner, 'sound/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
			SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
			for(var/mob/living/L in orange(6, owner))
				if(L)
					L.electrocute_act(30, owner, siemens_coeff = 1, flags = NONE)

/datum/action/gift/hands_full_of_thunder
	name = "Hands Full of Thunder"
	desc = "Invoke the machine spirits to support you in these trying times. Abstain from needing bullets when you fire a gun."
	button_icon_state = "hands_full_of_thunder"
	gnosis_req = 1

/datum/action/gift/hands_full_of_thunder/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		ADD_TRAIT(owner, TRAIT_THUNDERSHOT, "thunder")
		to_chat(owner, span_notice("You feel your fingers tingling with electricity...!"))
		spawn(100)
			REMOVE_TRAIT(owner, TRAIT_THUNDERSHOT, "thunder")
			to_chat(owner, span_notice("The buzz in your fingertips ebbs..."))

/datum/action/gift/elemental_improvement
	name = "Elemental Improvement"
	desc = "Garou flesh replaces itself with prothesis, making it less vulnerable to brute damage, but more for burn damage."
	button_icon_state = "elemental_improvement"
	rage_req = 2
	gnosis_req = 1

/datum/action/gift/elemental_improvement/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		animate(owner, color = "#6a839a", time = 10)
		if(ishuman(owner))
			playsound(get_turf(owner), 'code/modules/wod13/sounds/electro_cast.ogg', 75, FALSE)
			var/mob/living/carbon/human/H = owner
			H.physiology.armor.melee = 25
			H.physiology.armor.bullet = 45
			to_chat(owner, span_notice("You feel your skin replaced with the machine..."))
			spawn(20 SECONDS)
				H.physiology.armor.melee = initial(H.physiology.armor.melee)
				H.physiology.armor.bullet = initial(H.physiology.armor.bullet)
				to_chat(owner, span_warning("Your skin is natural again..."))
				owner.color = "#FFFFFF"
		else
			playsound(get_turf(owner), 'code/modules/wod13/sounds/electro_cast.ogg', 75, FALSE)
			var/mob/living/carbon/werewolf/H = owner
			H.werewolf_armor = 45
			to_chat(owner, span_notice("You feel your skin replaced with the machine..."))
			spawn(20 SECONDS)
				H.werewolf_armor = initial(H.werewolf_armor)
				to_chat(owner, span_warning("Your skin is natural again..."))
				owner.color = "#FFFFFF"


/datum/action/gift/guise_of_the_hound
	name = "Guise of the Hound"
	desc = "Wear the skin of the fleabitten dog to pass without concern."
	button_icon_state = "guise_of_the_hound"
	rage_req = 1

/datum/action/gift/guise_of_the_hound/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		if(!HAS_TRAIT(owner,TRAIT_DOGWOLF))
			ADD_TRAIT(owner, TRAIT_DOGWOLF, src)
			to_chat(owner, span_notice("You feel your canid nature softening!"))
		else
			REMOVE_TRAIT(owner, TRAIT_DOGWOLF, src)
			to_chat(owner, span_notice("You feel your lupine nature intensifying!"))

		if(istype(owner, /mob/living/carbon/werewolf/lupus))
			var/mob/living/carbon/werewolf/lupus/lopor = owner

			if(lopor && !lopor.hispo)
				playsound(get_turf(owner), 'code/modules/wod13/sounds/transform.ogg', 50, FALSE)
				var/matrix/ntransform = matrix(owner.transform)
				ntransform.Scale(0.95, 0.95)
				animate(owner, transform = ntransform, color = "#000000", time = 3 SECONDS)
				addtimer(CALLBACK(src, PROC_REF(transform_lupus), lopor), 3 SECONDS)

/datum/action/gift/guise_of_the_hound/proc/transform_lupus(mob/living/carbon/werewolf/lupus/H)
	if(HAS_TRAIT(H, TRAIT_DOGWOLF))
		H.icon = 'code/modules/wod13/werewolf_lupus.dmi'
	else
		H.icon = 'code/modules/wod13/tfn_lupus.dmi'
	H.regenerate_icons()
	H.update_transform()
	animate(H, transform = null, color = "#FFFFFF", time = 1)



/datum/action/gift/infest
	name = "Infest"
	desc = "Call forth the vermin in the area to serve you against your enemies."
	button_icon_state = "infest"
	rage_req = 4

/datum/action/gift/infest/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/limit
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			limit = H.social + H.additional_social + H.more_companions
			if(HAS_TRAIT(owner, TRAIT_ANIMAL_REPULSION))
				limit = max(1,limit-2)
			if(length(H.beastmaster) >= limit)
				var/mob/living/simple_animal/hostile/beastmaster/beast = pick(H.beastmaster)
				beast.death()
			if(!length(H.beastmaster))
				var/datum/action/beastmaster_stay/stay = new()
				stay.Grant(H)
				var/datum/action/beastmaster_deaggro/deaggro = new()
				deaggro.Grant(H)

			if(prob(50))
				var/mob/living/simple_animal/hostile/beastmaster/rat/ratto = new(get_turf(H))
				ratto.my_creator = H
				H.beastmaster |= ratto
				ratto.beastmaster_owner = H
			else
				var/mob/living/simple_animal/hostile/beastmaster/cockroach/roach = new(get_turf(H))
				roach.my_creator = H
				H.beastmaster |= roach
				roach.beastmaster_owner = H

/datum/action/gift/gift_of_the_termite
	name = "Gift of the Termite"
	desc = "Eat through structures. Obey no laws but the litany."
	button_icon_state = "gift_of_the_termite"
	rage_req = 3
	gnosis_req = 2

/datum/action/gift/gift_of_the_termite/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/H = owner
		H.put_in_active_hand(new /obj/item/melee/touch_attack/werewolf/gift_of_the_termite(H))


/datum/action/gift/shroud
	name = "Shroud"
	desc = "Call together the shadows, blocking line of sight."
	button_icon_state = "shroud"
	rage_req = 1

/datum/action/gift/shroud/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/atom/movable/shadow
		shadow = new(owner)
		shadow.set_light(5, -10)
		spawn(20 SECONDS)
			if (shadow)
				QDEL_NULL(shadow)

/datum/action/gift/coils_of_the_serpent
	name = "Coils of the Serpent"
	desc = "Summon forth tendrils of shadow to assault an opponent."
	button_icon_state = "coils_of_the_serpent"
	rage_req = 1

/datum/action/gift/coils_of_the_serpent/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			SEND_SIGNAL(H, COMSIG_MASQUERADE_VIOLATION)
			H.drop_all_held_items()
			H.put_in_r_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))
			H.put_in_l_hand(new /obj/item/melee/vampirearms/knife/gangrel/lasombra(owner))
			for(var/obj/item/melee/vampirearms/knife/gangrel/lasombra/arm in H.contents)
				arm.name = "\improper shadow coil"
				arm.desc = "Squeeze tight."
				spawn(20 SECONDS)
					qdel(arm)

/datum/action/gift/banish_totem
	name = "Banish Totem"
	desc = "Choose a target. Dissolve the gnosis and connection they hold temporarily to their totem."
	button_icon_state = "banish_totem"
	rage_req = 3
	gnosis_req = 2

/datum/action/gift/banish_totem/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/valid_tribe = FALSE
		var/list/targets = list()
		for(var/mob/living/carbon/werewolf/wtarget in orange(7,owner))
			targets += wtarget
		for(var/mob/living/carbon/human/htarget in orange(7,owner))
			targets += htarget
		var/mob/living/carbon/target = tgui_input_list(owner, "Select a target", "Banish Totem", sort_list(targets))
		if(target && (iswerewolf(target) || isgarou(target)))
			valid_tribe = target.auspice.tribe
		for(var/mob/living/carbon/targetted in targets)
			if(targetted && targetted.auspice.tribe.name == valid_tribe)
				targetted.auspice.gnosis = 0
				to_chat(targetted, span_userdanger("You feel your tie to your totem snap, gnosis leaving you...!"))
				to_chat(owner, span_danger("You feel [target.name]'s gnostic ties fray...!"))


/datum/action/gift/suns_guard // MASSIVE thanks to MachinePixie for coding this and the eye-drinking gifts, as well as making the relevant sprites
	name = "Sun's Guard"
	desc = "Gain the blessing of Helios, and become immune to spark and inferno both"
	button_icon_state = "sunblock"
	rage_req = 2
	cool_down = 21 SECONDS




/datum/action/gift/suns_guard/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/caster = owner
		var/storeburnmod = caster.dna.species.burnmod
		caster.dna.species.burnmod = 0
		caster.set_fire_stacks(0)
		ADD_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
		animate(caster, color = "#ff8800", time = 10, loop = 1)
		playsound(get_turf(caster), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
		to_chat(caster, "Sun's Guard activated, you have become immune to fire.")
		addtimer(CALLBACK(src, PROC_REF(end_guard)), 140, storeburnmod)


/datum/action/gift/suns_guard/proc/end_guard(storedburnmodifier)
	var/mob/living/carbon/caster = owner
	caster.dna.species.burnmod = storedburnmodifier
	caster.set_fire_stacks(0)
	REMOVE_TRAIT(caster, TRAIT_RESISTHEAT, MAGIC_TRAIT)
	caster.color = initial(caster.color)
	playsound(get_turf(caster), 'code/modules/wod13/sounds/resist_pain.ogg', 75, FALSE)
	to_chat(caster, "Sun's Guard is no longer active, you are no longer immune to fire.")

/datum/action/gift/eye_drink
	name = "Eye-Drinking"
	desc = "Consumes the eyes of a corpse to unlock the secrets of its demise. Will risk breaching the veil if used in homid."
	button_icon_state = "eye_drink"
	rage_req = 0
	cool_down = 1 MINUTES

/datum/action/gift/eye_drink/Trigger(trigger_flags)
	. = ..()
	if(allowed_to_proceed)
		var/mob/living/carbon/caster = owner
		if(caster.pulling)
			var/mob/living/carbon/victim = caster.pulling
			var/obj/item/organ/eyes/victim_eyeballs = victim.getorganslot(ORGAN_SLOT_EYES)
			var/isNPC = TRUE
			if(!iscarbon(victim) || victim.stat != DEAD )
				to_chat(caster, "<span class='warning'>You aren't currently pulling a corpse!</span>")
				return
			else
				if(!victim_eyeballs)
					to_chat(caster, "<span class='warning'>You cannot drink the eyes of a corpse that has no eyes!</span>")
					return
				else
					if (!do_after(caster, 3 SECONDS)) //timer to cast
						return
					var/permission = tgui_input_list(victim, "Will you allow [caster.real_name] to view your death? (Note: You are expected to tell the truth in your character's eyes!)", "Select", list("Yes","No","I don't recall") ,"Yes", 1 MINUTES)
					var/victim_two = victim

					if (!permission) //returns null if no soul in body
						for (var/mob/dead/observer/ghost in GLOB.player_list)
							if (ghost.mind == victim.last_mind)
								//ask again if null
								permission = tgui_input_list(ghost, "Will you allow [caster.real_name] to view your death? (Note: You are expected to tell the truth in your character's eyes!)", "Select", list("Yes","No","I don't recall") ,"Yes", 1 MINUTES)
								victim_two = ghost
								break //no need to do further iterations if you found the right person

					if(permission == "Yes")
						if(ishuman(caster)) //listen buddy, hulking ravenmen and ravens can eat those eyes just fine, but a human? DISGUSTING.
							SEND_SIGNAL(caster, COMSIG_MASQUERADE_VIOLATION)
						playsound(get_turf(owner), 'sound/items/eatfood.ogg', 50, FALSE) //itadakimasu! :D
						qdel(victim_eyeballs)
						caster.adjust_nutrition(5) //organ nutriment value is 5
						to_chat(caster, "You drink of the eyes of [victim.name] and a vision fills your mind...")
						var/deathdesc = tgui_input_text(victim_two, "", "How did you die?", "", 300, TRUE, TRUE, 5 MINUTES)
						if (deathdesc == "")
							to_chat(caster, "The vision is hazy, you can't make out many details...")
						else
							to_chat(caster, "<i>[deathdesc]</i>")
						//discount scanner
						to_chat(caster,"<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]")
						to_chat(caster, "Last melee attacker: [victim.lastattacker]") //guns behave weirdly
						isNPC = FALSE

					else if(permission == "No")
						to_chat(caster,"<span class='warning'>The spirit seems relunctact to let you consume their eyes... so you refrain from doing so.</span>")
						isNPC = FALSE

					if(isNPC)
						playsound(get_turf(owner), 'sound/items/eatfood.ogg', 50, FALSE) //yummers
						qdel(victim_eyeballs)
						caster.adjust_nutrition(5) //organ nutriment value is 5
						to_chat(caster, "You drink of the eyes of [victim.name] but no vision springs to mind...")
						to_chat(caster,"<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]")
						to_chat(caster, "Last melee attacker: [victim.lastattacker]") //guns behave weirdly

