/datum/language/garou_tongue
	name = "Garou Tongue"
	desc = "A guttural and pitchy language also known as 'High Tongue', the language of the Garou capable of being learned and spoken by Garou. It is hard to speak in human form."
	key = "w"
	flags = TONGUELESS_SPEECH
	space_chance = 40
	syllables = list(
		"to", "lo", "of", "li", "ka", "ha", "he", "ah", "ny", "ro",
		"li", "me", "ad", "he", "ah", "um", "co", "ga", "gar", "fa",
		"el", "ra", "ia", "of", "os", "ra", "ta", "na", "ga", "ho",
		"lu", "lu", "fe", "zi", "mo", "sha", "ru", "te", "vo", "ni",
		"xa", "jo", "da", "ku", "pe", "su", "yo", "ve", "mi", "ba"
	)
	icon_state = "garou"
	default_priority = 90

/datum/language/primal_tongue
	name = "Primal Tongue"
	desc =  "A language inherently known to all Garou breeds at birth, able to be spoken only in Lupus, Crinos and Hispo forms."
	key = "p"
	flags = TONGUELESS_SPEECH
	space_chance = 40
	syllables = list (
		"gra", "grr", "gru", "gha", "sha", "zho", "yip", "whu", "zar", "ruk",
		"kra", "hya", "tza", "ska", "yrr", "fru", "thra", "hwo", "vra", "snar",
		"kru", "pha", "gha", "hro", "tzo", "wha", "brak", "thru", "chur", "dra",
		"vru", "sna", "yru", "hru", "yla", "fro", "rik", "zru", "skra", "zhu",
		"kro", "thro", "zyi", "sha", "hza", "mru", "wru", "bruk", "hka", "tza"
	)
	icon_state = "garou"
	default_priority = 90
