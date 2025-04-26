#define FLOOR_DISAPPEAR 3 SECONDS

/datum/quirk/derangement/proc/handle_malk_floors()
	var/mob/living/target = quirk_holder
	if(!target.client)
		return
	//Floors go crazy go stupid
	for(var/turf/open/floor in view(target))
		if(!prob(7))
			continue
		if(isgroundlessturf(floor))
			continue
		handle_malk_floor(floor)

/datum/quirk/derangement/proc/handle_malk_floor(turf/open/floor)
	var/mob/living/target = quirk_holder
	var/mutable_appearance/fake_floor = image(floor.icon, floor, floor.icon_state, floor.layer + 0.01)
	target.client.images += fake_floor
	var/offset = pick(-3,-2, -1, 1, 2, 3)
	var/disappearfirst = rand(1 SECONDS, 3 SECONDS) * abs(offset)
	animate(fake_floor, pixel_y = offset, time = disappearfirst, flags = ANIMATION_RELATIVE)
	addtimer(CALLBACK(src, PROC_REF(malk_floor_stage1), quirk_holder, offset, fake_floor), disappearfirst, TIMER_CLIENT_TIME)

/datum/quirk/derangement/proc/malk_floor_stage1(mob/living/malk, offset, mutable_appearance/fake_floor)
	animate(fake_floor, pixel_y = -offset, time = FLOOR_DISAPPEAR, flags = ANIMATION_RELATIVE)
	addtimer(CALLBACK(src, PROC_REF(malk_floor_stage2), malk, fake_floor), FLOOR_DISAPPEAR, TIMER_CLIENT_TIME)

/datum/quirk/derangement/proc/malk_floor_stage2(mob/living/malk, mutable_appearance/fake_floor)
	malk.client?.images -= fake_floor

/datum/hallucination/malk
	var/static/list/malklines = world.file2list("strings/malk.txt")

/datum/hallucination/malk/laugh

/datum/hallucination/malk/laugh/New(mob/living/carbon/malk, forced = TRUE)
	var/static/list/funnies = list(
		'sound/hallucinations/malk/comic1.ogg',
		'sound/hallucinations/malk/comic2.ogg',
		'sound/hallucinations/malk/comic3.ogg',
		'sound/hallucinations/malk/comic4.ogg',
	)
	malk.playsound_local(malk, pick(funnies), vol = 40, vary = FALSE)

/datum/hallucination/malk/object

/datum/hallucination/malk/object/New(mob/living/carbon/target, forced = TRUE)
	var/list/objects = list()

	for(var/obj/object in view(target))
		if((object.invisibility > target.see_invisible) || !object.loc || !object.name)
			continue
		var/weight = 1
		if(isitem(object))
			weight = 3
		else if(isstructure(object))
			weight = 2
		else if(ismachinery(object))
			weight = 2
		objects[object] = weight
	if(!objects.len)
		return
	objects -= target.contents

	var/static/list/speech_sounds = list(
		'sound/hallucinations/malk/female_talk1.ogg',
		'sound/hallucinations/malk/female_talk2.ogg',
		'sound/hallucinations/malk/female_talk3.ogg',
		'sound/hallucinations/malk/female_talk4.ogg',
		'sound/hallucinations/malk/female_talk5.ogg',
		'sound/hallucinations/malk/male_talk1.ogg',
		'sound/hallucinations/malk/male_talk2.ogg',
		'sound/hallucinations/malk/male_talk3.ogg',
		'sound/hallucinations/malk/male_talk4.ogg',
		'sound/hallucinations/malk/male_talk5.ogg',
		'sound/hallucinations/malk/male_talk6.ogg',
	)
	var/obj/speaker = pickweight(objects)
	var/speech
	if(prob(1))
		speech = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
	else
		speech = pick(malklines)
	var/language = target.get_random_understood_language()
	var/message = target.compose_message(speaker, language, speech)
	target.playsound_local(target, pick(speech_sounds), vol = 30, vary = FALSE)
	if(target.client?.prefs?.chat_on_map)
		target.create_chat_message(speaker, language, speech, spans = list(target.speech_span))
	to_chat(target, message)

#undef FLOOR_DISAPPEAR
