// **************************************************************** CALL THE HUNGRY DEAD *************************************************************

/obj/necrorune/question //No bloodpack requirement, but the wraiths aren't implied to owe answers.
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
	var/text_question = tgui_input_text(last_activator, "Enter your summons to the wraiths:", "Call the Hungry Dead", encode = FALSE)
	visible_message(span_notice("A call rings out to the dead from the rune..."))
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you wish to speak with a necromancer? (You are allowed to spread meta information) Their summons is : [text_question]", null, null, null, 20 SECONDS, src)
	for(var/mob/dead/observer/G in GLOB.player_list)
		notify_ghosts("Question rune has been triggered.", source = src, action = NOTIFY_ORBIT, flashwindow = FALSE, header = "Question Rune Triggered")
	if(!length(candidates))
		visible_message(span_notice("No one answers the [src.name] rune's call."))
		return
	var/mob/dead/observer/C = pick(candidates)
	var/mob/living/simple_animal/hostile/ghost/giovanni/TR = new(loc)
	TR.key = C.key
	TR.name = C.name
	playsound(loc, 'code/modules/wod13/sounds/necromancy2.ogg', 50, FALSE)
	visible_message(span_notice("[TR.name] slowly fades into view over the rune..."))
	qdel(src)
