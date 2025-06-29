//this file holds text and character replacement stuff, like the malk madness speech
/proc/spooky_font_replace(input) //mostly used for malkavians
	if(!input)
		return

	var/list/replacements = list(
			"a"    = "𝙖",            "A" = "𝘼",
			"d"    = pick("𝓭","𝓓"), "D" = "𝓓",
			"e"    = "𝙚",            "E" = "𝙀",
			"i"    = "𝙞",            "I" = pick("ﾉ", "𝐼"),
			"l"    = pick("𝙇","l"),  "L" = pick("𝙇","𝓛"),
			"n"    = "𝙣",            "N" = pick("𝓝","𝙉"),
			"o"    = "𝙤",            "O" = "𝙊",
			"s"    = "𝘴",            "S" = "𝙎",
			"u"    = "𝙪",            "U" = "𝙐",
			"v"	   = "𝐯",            "V" = "𝓥",
		)
	for(var/letter in replacements)
		input = replacetextEx(input, letter, replacements[letter])
	return input
