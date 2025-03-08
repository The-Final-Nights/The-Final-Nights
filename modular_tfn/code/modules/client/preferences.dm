/datum/preferences
	var/headshot_link

/proc/valid_headshot_link(mob/user, value, silent = FALSE)
	var/static/link_regex = regex("i.gyazo.com|a.l3n.co|b.l3n.co|c.l3n.co|images2.imgbox.com|thumbs2.imgbox.com|files.catbox.moe") //gyazo, discord, lensdump, imgbox, catbox
	var/static/list/valid_extensions = list("jpg", "png", "jpeg") // Regex works fine, if you know how it works

	if(!length(value))
		return FALSE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		if(!silent)
			to_chat(user, span_warning("Your link must be https!"))
		return FALSE

	if(!findtext(value, "."))
		if(!silent)
			to_chat(user, span_warning("Invalid link!"))
		return FALSE
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(extension in valid_extensions))
		if(!silent)
			to_chat(usr, span_warning("The image must be one of the following extensions: '[english_list(valid_extensions)]'"))
		return FALSE

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		if(!silent)
			to_chat(usr, span_warning("The image must be hosted on one of the following sites: 'Gyazo, Lensdump, Imgbox, Catbox'"))
		return FALSE
	return TRUE
