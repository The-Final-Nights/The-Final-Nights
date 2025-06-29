
// auspex demons, or malevolent spirits as they are known IC, exist to prevent people from spending excessive amounts of time in auspex
// whether they are spying on people all round, or invading personal space, these inhabitants of the penumbra act as the bouncers
// to kick people out of auspex and force them back into their bodies. they also work great if you dont feel like finding your body
// and you dont mind the ouchies they give you for the taxi service back to it. :)

/mob/living/simple_animal/revenant/auspex_demon //subtype of revenant. aspiring event runners should note that auspex avatars cannot hear dead chat, and revenants speak via dead chat
	name = "auspex demon"
	desc = "A malevolent spirit."
	var/mob/dead/observer/avatar/haunt_target
	COOLDOWN_DECLARE(revenant_auspex_demon_move)
	COOLDOWN_DECLARE(revenant_auspex_demon_attack)
	var/stalk_distance = 20 //the spirits distance from its target. gets lower overtime before it eventually reaches 0

	//todo: add more phrases
	var/list/spooky_phrases = list("You don't belong here...",
	"Living one...",
	"She watches you...",
	"We watch you...",
	"Time to go...",
	"Why do you anger her...?",
	"She is coming...",
	"They make more... In the shadows, in the dirt...",
	"Gehenna...",
	"Find her...",
	"So cold...",
	"You are not welcome here..."
	)

/mob/living/simple_animal/revenant/Initialize()
	. = ..()
	AddElement(/datum/element/point_of_interest) // let observers know something entertaining is happening

/mob/living/simple_animal/revenant/auspex_demon/Life()
	. = ..()
	if(QDELETED(haunt_target) || !haunt_target) //if they exit auspex by any means, unalive the demon
		qdel(src)

	if(COOLDOWN_FINISHED(src, revenant_auspex_demon_attack))
		COOLDOWN_START(src, revenant_auspex_demon_attack, rand(1 SECONDS, 3 SECONDS))
		if(get_dist(src, haunt_target) < 2) //caught ya
			haunt_target?.reenter_corpse(TRUE)

	if(!COOLDOWN_FINISHED(src, revenant_auspex_demon_move))
		return

	COOLDOWN_START(src, revenant_auspex_demon_move, rand(6 SECONDS, 12 SECONDS))
	if(prob(10)) //10% chance to say a spooky phrase every 6 to 12 seconds
		var/spooky_phrase = pick(spooky_phrases)
		spooky_phrase = spooky_font_replace(spooky_phrase)
		to_chat(haunt_target, span_cult(spooky_phrase)) //push the spooky phrase directly to our haunting targets chat, since auspex avatars cant hear dead chat

	stalk_distance = max(0, stalk_distance - rand(1,3)) //decrease this every cooldown_finished by somewhere between 1 to 3. this stalk_distance in walk_to is how close the mob will get before stopping
	z = haunt_target.z //just incase the target changes z levels
	walk_to(src, haunt_target, stalk_distance) //auspex demons stop at obstacles like regular mobs rather than phasing through. this makes them spookier and allows players to 'outrun' them
	if(get_dist(src, haunt_target) > 20) //they outran the spirit, delete it and get ready to re-haunt them at a later location
		haunt_target.haunted = FALSE
		qdel(src)
