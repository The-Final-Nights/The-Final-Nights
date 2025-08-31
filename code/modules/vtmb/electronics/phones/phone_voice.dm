/obj/phonevoice
	name = "unknown voice"
	speech_span = SPAN_ROBOT
	anchored = FALSE
	density = FALSE
	opacity = FALSE
	var/phone = null

/obj/phonevoice/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_selected_language()
	var/rendered = compose_message(src, language, message, , spans)
	SSmasquerade.log_phone_message(rendered, phone)
	send_speech(message, 2, src, , spans, message_language=language)

/obj/phonevoice/Destroy(force)
	phone = null
	..()

/proc/scramble_lasombra_message(message, mob/living/carbon/human/lasombra)
	var/static/list/zalgo_letters = list(
    "̨a", "̡b", "̢c", "̷d", "̶e", "̸f", "̹g", "̺h", "̻i",
    "̼j", "̽k", "̾l", "̿m", "͈n", "͍o", "͎p", "q", "͕r",
    "͓s", "͒t", "̱u", "̲v", "̳w", "͡x", "̨y", "̨z", "̨A",
    "̨B", "̨C", "̨D", "̨E", "̨F", "̨G", "̨H", "̨I", "̨J",
    "̨K", "̨L", "̨M", "̨N", "̨O", "̨P", "̨Q", "̨R", "̨S",
    "̨T", "̨U", "̨V", "̨W", "̨X", "̨Y", "̨Z"
	)
	var/gibberish_message = ""
	var/totalsocial = 0
	if(lasombra)
		totalsocial = (lasombra.social+lasombra.additional_social) * 3 // +3% chance per social. 15 max, 18 avg, 24 beauty.9
	for(var/i = 1 to length(message))
		var/char = message[i]
		// Randomize or replace characters with gibberish
		var/chance = 70 + totalsocial // 70% + totalsocial chance per point of social to keep intact.
		if(prob(chance))
			gibberish_message += char
		else
			gibberish_message += pick(zalgo_letters) // Replace with random gibberish letters
	return gibberish_message
