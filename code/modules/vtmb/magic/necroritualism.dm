/obj/item/necromancy_tome
	name = "necromancy tome"
	desc = "An old tome bound in peculiar leather."
	icon_state = "necronomicon"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	is_magic = TRUE
	var/list/rituals = list()

/obj/item/necromancy_tome/Initialize()
	. = ..()
	for(var/i in subtypesof(/obj/necrorune))
		if(i)
			var/obj/necrorune/R = new i(src)
			rituals |= R

/obj/item/necromancy_tome/attack_self(mob/user)
	. = ..()
	for(var/obj/necrorune/R in rituals)
		if(R)
			if(R.sacrifices.len > 0)
				var/list/required_items = list()
				for(var/item_type in R.sacrifices)
					var/obj/item/I = new item_type(src)
					required_items += I.name
					qdel(I)
				var/required_list
				if(required_items.len == 1)
					required_list = required_items[1]
				else
					for(var/item_name in required_items)
						required_list += (required_list == "" ? item_name : ", [item_name]")
				to_chat(user, "[R.necrolevel] [R.name] - [R.desc] Requirements: [required_list].")
			else
				to_chat(user, "[R.necrolevel] [R.name] - [R.desc]")

/obj/necrorune
	name = "Necromancy Rune"
	desc = "Death is only the beginning."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rune1"
	color = rgb(10,128,20)
	anchored = TRUE
	var/word = "THURI'LLAH 'NHT"
	var/activator_bonus = 0
	var/activated = FALSE
	var/mob/living/last_activator
	var/necrolevel = 1
	var/list/sacrifices = list()

/obj/necrorune/proc/complete()
	return

/obj/necrorune/attack_hand(mob/user)
	if(!activated)
		var/mob/living/L = user
		if(L.necromancy_knowledge)
			L.say(word)
			L.Immobilize(30)
			last_activator = user
	//		activator_bonus = L.thaum_damage_plus

			animate(src, color = rgb(72, 230, 106), time = 10)


			if(sacrifices.len > 0)
				var/list/found_items = list()
				for(var/obj/item/I in get_turf(src))
					for(var/item_type in sacrifices)
						if(istype(I, item_type))
							if(istype(I, /obj/item/drinkable_bloodpack))
								var/obj/item/drinkable_bloodpack/bloodpack = I
								if(!bloodpack.empty)
									found_items += I
									break
							else
								found_items += I
								break
				if(found_items.len == sacrifices.len)
					for(var/obj/item/I in found_items)
						if(I)
							qdel(I)
					complete()
				else
					to_chat(user, "You lack the necessary sacrifices to complete the ritual. Found [found_items.len], required [sacrifices.len].")
			else
				complete()

/obj/necrorune/AltClick(mob/user)
	..()
	qdel(src)

// **************************************************************** DEATH *************************************************************

/obj/necrorune/death
	name = "Death"
	desc = "Instantly transport yourself to the Shadowlands."
	icon_state = "rune2"
	word = "Y'HO 'LLOH"

/obj/necrorune/death/complete()
	last_activator.dust()
	qdel(src)

// **************************************************************** ARTIFACT IDENTIFICATION *************************************************************

/obj/necrorune/identification
	name = "Identification Rune"
	desc = "Identifies a single occult item."
	icon_state = "rune3"
	word = "WOHT'DIHSS"

/obj/necrorune/identification/complete()
	for(var/obj/item/vtm_artifact/VA in loc)
		if(VA)
			VA.identificate()
			playsound(loc, 'code/modules/wod13/sounds/necromancy4.ogg', 50, FALSE)
			qdel(src)
			return


// **************************************************************** CALL THE HUNGRY DEAD *************************************************************

/obj/necrorune/callthehungrydead //No bloodpack requirement, but the wraiths aren't implied to owe answers.
	name = "Call the Hungry Dead"
	desc = "Summon a wraith from the Shadowlands to converse."
	icon_state = "rune4"
	word = "METEH' GHM'IEN"
	necrolevel = 2

/mob/living/simple_animal/hostile/ghost/giovanni
	maxHealth = 100 //Can be annoying right back if they're pestered for nothing.
	health = 100
	melee_damage_lower = 30
	melee_damage_upper = 30
	faction = list("Giovanni")

/obj/necrorune/question/complete()
	var/text_question = tgui_input_text(usr, "Enter your summons to the wraiths:", "Call the Hungry Dead")
	visible_message(span_notice("A call rings out to the dead from the [src.name] rune..."))
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to speak with a necromancer? (You are allowed to spread meta information) Their summons is : [text_question]", null, null, null, 20 SECONDS, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.key)
			to_chat(G, span_ghostalert("Question rune has been triggered."))
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		var/mob/living/simple_animal/hostile/ghost/giovanni/TR = new(loc)
		TR.key = C.key
		TR.name = C.name
		playsound(loc, 'code/modules/wod13/sounds/necromancy2.ogg', 50, FALSE)
		visible_message(span_notice("[TR.name] slowly fades into view over the rune..."))
		qdel(src)
	else
		visible_message(span_notice("No one answers the [src.name] rune's call."))

// **************************************************************** MINESTRA DI MORTE *************************************************************

/obj/necrorune/locate
	name = "Minestra di Morte"
	desc = "Verify a soul's status and try to divine its location."
	icon_state = "rune5"
	word = "UAH'V OUH'RAN"
	necrolevel = 3
	sacrifices = list(/obj/item/shard)

/obj/necrorune/locate/complete()

	var/chosen_name = tgui_input_text(usr, "Invoke the true name of the soul you seek:", "Minestra di Morte")

	for(var/mob/target in GLOB.player_list) //there's probably a better way to do all of this

		if(target.real_name == chosen_name && isavatar(target))
			var/area/targetarea = get_area(target)
			to_chat(usr, span_ghostalert("This soul has bridged the two realities - their astral projection wanders [targetarea.name]."))
			playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)
			qdel(src)
			return

		if(target.real_name == chosen_name && isobserver(target))
			to_chat(usr, span_ghostalert("This soul has departed the realm of the living."))
			playsound(loc, 'code/modules/wod13/sounds/necromancy1off.ogg', 50, FALSE)
			qdel(src)
			return

		var/mob/living/livetarget = target

		if(livetarget.true_real_name == chosen_name)
			var/area/targetarea = get_area(livetarget)
			var/area/userarea = get_area(usr)

			if (isliving(livetarget) && livetarget.stat != DEAD)
				to_chat(usr, span_ghostalert("This soul yet persists in the Skinlands at [targetarea.name]."))
				playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)
		
				if(livetarget.stat > SOFT_CRIT)
					to_chat(usr, span_ghostalert("Their connection to this is realm weak, and fading. Death waits for them."))

				if(iskindred(livetarget))
					var/bloodpoolstatus = (livetarget.bloodpool / livetarget.maxbloodpool) * 100
					switch(bloodpoolstatus)
						if(70 to INFINITY)
							to_chat(usr, span_ghostalert("The Beast inside them is content, the soul harmonious with the vessel."))
						if(40 to 70)
							to_chat(usr, span_ghostalert("There is a dark Hunger scratching at the back of their soul."))
						if(10 to 40)
							to_chat(usr, span_danger("The cage of their body shakes and rattles with Hunger unsated."))
						if (-INFINITY to 10)
							to_chat(usr, span_danger("What poses for their soul is darkness, and Hunger. Terrible Hunger."))

				var/healthstatus = (livetarget.health / livetarget.maxHealth) * 100
				switch(healthstatus)
					if(90 to INFINITY)
						to_chat(usr, span_ghostalert("They are in good health, death has no claim to their vessel."))
					if(50 to 90)
						to_chat(usr, span_ghostalert("Their lifeforce flickers occasionally, wounds straining the connection."))
					if(10 to 50)
						to_chat(usr, span_danger("Grave wounds ravage their vessel, the soul eager to escape."))
					if (-INFINITY to 10)
						to_chat(usr, span_danger("The Shadowlands inexorably pull this one towards them. This is their final hour."))

				if(livetarget.necromancy_knowledge) //other necromancers catch onto it if targeted
					to_chat(target, span_notice("A chill and a whisper. A fellow necromancer has sought out your soul - their own calling out from <b>[userarea.name]</b>."))
				qdel(src)

			if (isliving(livetarget) && livetarget.stat == DEAD) //for when they haven't ghosted yet
				to_chat(usr, span_ghostalert("This soul remains caged to its perished vessel at [targetarea.name]."))
				qdel(src)

		else
			to_chat(usr, span_warning("No such soul is present beyond the Shroud, nor here in the Skinlands!"))

// **************************************************************** INSIGHT *************************************************************

/obj/necrorune/insight
	name = "Insight"
	desc = "Determine a cadaver's passing by questioning its soul."
	icon_state = "rune6"
	word = "IH'DET ULYSS RES'SAR"
	necrolevel = 2

/obj/necrorune/insight/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("You cannot invoke this ritual upon yourself."))
			return
		else if(targetbody.stat == DEAD)
			valid_bodies += targetbody
		else
			to_chat(usr, span_warning("The target lives still! Ask them yourself!"))
			return

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("There is no body that can undergo this Ritual."))
		return

	playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)
	var/mob/living/carbon/victim = pick(valid_bodies)

	var/isNPC = TRUE
	var/permission = tgui_input_list(victim, "[usr.real_name] wishes to know of your passing. Will you give answers?", "Select", list("Yes","No","I don't recall") ,"No", 1 MINUTES)
	var/victim_two = victim

	if (!permission) //returns null if no soul in body
		for (var/mob/dead/observer/ghost in GLOB.player_list)
			if (ghost.mind == victim.last_mind)
				//ask again if null
				permission = tgui_input_list(ghost, "[usr.real_name] wishes to know of your passing. Will you give answers?", "Select", list("Yes","No","I don't recall") ,"No", 1 MINUTES)
				victim_two = ghost
				break //no need to do further iterations if you found the right person

	if(permission == "Yes")
		to_chat(usr, span_ghostalert("[victim.name]'s haunting whispers flood your mind..."))
		var/deathdesc = tgui_input_text(victim_two, "", "How did you die?", "", 300, TRUE, TRUE, 5 MINUTES)
		if (deathdesc == "")
			to_chat(usr, span_warning("The Shroud is too thick, their whispers too raving to gleam anything useful."))
		else
			to_chat(usr, span_ghostalert("<i>[deathdesc]</i>"))
		//discount scanner
		to_chat(usr, span_notice("<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]"))
		to_chat(usr, span_notice("Last melee attacker: [victim.lastattacker]")) //guns behave weirdly
		isNPC = FALSE
		qdel(src)

	else if(permission == "No")
		to_chat(usr, span_danger("The wraith turns from you. It will not surrender its secrets."))
		isNPC = FALSE

	if(isNPC)
		to_chat(usr, span_notice("[victim.name] is a waning, base Drone. There is no greater knowledge to gleam from this one."))
		to_chat(usr, span_notice("<b>Damage taken:<b><br>BRUTE: [victim.getBruteLoss()]<br>OXY: [victim.getOxyLoss()]<br>TOXIN: [victim.getToxLoss()]<br>BURN: [victim.getFireLoss()]<br>CLONE: [victim.getCloneLoss()]"))
		to_chat(usr, span_notice("Last melee attacker: [victim.lastattacker]"))
		qdel(src)

// **************************************************************** DAEMONIC POSSESSION *************************************************************

/obj/necrorune/zombie
	name = "Daemonic Possession"
	desc = "Place a wraith inside of a dead body and raise it as a sentient zombie."
	icon_state = "rune7"
	word = "GI'TI FOA'HP"
	necrolevel = 5

/obj/necrorune/zombie/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("You cannot invoke this ritual upon yourself."))
			return
		else if(targetbody.stat == DEAD)
			valid_bodies += targetbody
		else
			to_chat(usr, span_warning("The target lives still!"))
			return

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("There is no body that can undergo this Ritual."))
		return

	var/mob/living/target_body = pick(valid_bodies)

	var/old_name = target_body.real_name

	// Transform the body into a zombie
	if(!target_body || QDELETED(target_body) || target_body.stat > DEAD)
		return

	// Remove any vampiric actions
	for(var/datum/action/A in target_body.actions)
		if(A && A.vampiric)
			A.Remove(target_body)

	var/original_location = get_turf(target_body)

	// Revive the specimen and turn them into a zombie
	target_body.revive(TRUE)
	target_body.set_species(/datum/species/zombie)
	target_body.real_name = old_name // the ritual for some reason is deleting their old name and replacing it with a random name.
	target_body.name = old_name
	target_body.update_name()

	if(target_body.loc != original_location)
		target_body.forceMove(original_location)

	playsound(loc, 'code/modules/wod13/sounds/necromancy.ogg', 50, FALSE)

	// Handle key assignment
	if(!target_body.key)
		var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to play as Sentient Zombie?", null, null, null, 20 SECONDS, src)
		for(var/mob/dead/observer/G in GLOB.player_list)
			if(G.key)
				to_chat(G, span_ghostalert("Zombie rune has been triggered."))
		if(LAZYLEN(candidates))
			var/mob/dead/observer/C = pick(candidates)
			target_body.key = C.key

		var/choice = tgui_alert(target_body, "Do you want to pick a new name as a Zombie?", "Zombie Choose Name", list("Yes", "No"), 10 SECONDS)
		if(choice == "Yes")
			var/chosen_zombie_name = tgui_input_text(target_body, "What is your new name as a Zombie?", "Zombie Name Input")
			target_body.real_name = chosen_zombie_name
			target_body.name = chosen_zombie_name
			target_body.update_name()
		else
			target_body.visible_message(span_ghostalert("[target_body.name] twitches to unlife!"))
			qdel(src)
			return

	target_body.visible_message(span_ghostalert("[target_body.name] twitches to unlife!"))
	qdel(src)

// **************************************************************** CALL UPON THE SHADOW'S GRACE *************************************************************

/obj/necrorune/truth
	name = "Call upon the Shadow's Grace"
	desc = "Bring forth the shadows in your victim's mind and force out their darkest truths."
	icon_state = "rune8"
	word = "MIKHH' AHPP"
	necrolevel = 3

/obj/necrorune/truth/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("You cannot invoke this ritual upon yourself."))
			return
		if(targetbody.stat == DEAD)
			to_chat(usr, span_warning("The target is dead, and has taken its secrets to the grave!"))
			return
		else
			valid_bodies += targetbody

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("The ritual's victim must remain over the rune."))
		return

	var/mob/living/carbon/victim = pick(valid_bodies)
	playsound(loc, 'code/modules/wod13/sounds/necromancy1on.ogg', 50, FALSE)

	to_chat(usr, span_ghostalert("You sic [victim.name]'s shadow on [victim.p_them()]; [victim.p_they()] cannot lie to you now."))

	playsound(victim,'sound/hallucinations/veryfar_noise.ogg',50,TRUE)
	playsound(victim,'sound/spookoween/ghost_whisper.ogg',50,TRUE)

	victim.emote("scream")
	victim.AdjustKnockdown(2 SECONDS)
	victim.do_jitter_animation(3 SECONDS)

	to_chat(victim, span_revenboldnotice("Your mouth snaps open, and whatever air you take in can't seem to stay."))
	to_chat(victim, span_revenboldnotice("All the dark secrets you harbor come spilling out before you can even recall them."))
	to_chat(victim, span_hypnophrase("YOU CANNOT LIE."))

	visible_message(span_danger("[victim.name]'s shadow thrashes underneath [victim.p_them()], as if a separate being!"))
	qdel(src)

// **************************************************************** CHILL OF OBLIVION *************************************************************

/obj/necrorune/fireprotection
	name = "Chill of Oblivion"
	desc = "Invite the cold of the Shadowlands into your soul to undo the body's fire-weakness. This profane blessing <b>taints the recipient's aura</b>."
	icon_state = "rune1"
	word = "DHAI'AD BHA'II DAWH'N"
	necrolevel = 4

/obj/necrorune/fireprotection/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody.stat == DEAD)
			to_chat(usr, span_warning("The target is dead, the cold has long settled inside."))
			return

		else valid_bodies += targetbody

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("The ritual's target must remain over the rune."))
		return

	var/mob/living/carbon/victim = pick(valid_bodies)

	if(victim.fakediablerist)
		to_chat(usr, span_warning("The ritual's target has already been claimed by the cold."))
		return

	playsound(loc, 'sound/effects/ghost.ogg', 50, FALSE)
	victim.emote("shiver")
	victim.Immobilize(4 SECONDS)

	to_chat(victim, span_revendanger("Burning ice bleeds out of your soul and into everything else. Paralyzed, you stand in the cold as death lingers."))
	victim.fakediablerist = TRUE
	if(iskindred(victim) || iscathayan(victim) || iszombie(victim)) //made this a deduction rather than a flat set because of an artifact that independently changes damage mods
		victim.dna.species.burnmod = victim.dna.species.burnmod-1
	else
		victim.dna.species.burnmod = victim.dna.species.burnmod-0.5
	qdel(src)
