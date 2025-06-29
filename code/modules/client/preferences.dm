GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	var/client/parent
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/max_save_slots = 20

	//non-preference stuff
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#c43b23"
	var/asaycolor = "#ff4500"			//This won't change the color for current admins, only incoming ones.
	var/enable_tips = TRUE
	var/tip_delay = 500 //tip delay in milliseconds

	//Antag preferences
	var/list/be_special = list()		//Special role selection
	var/tmp/old_be_special = 0			//Bitflag version of be_special, used to update old savefiles and nothing more
										//If it's 0, that's good, if it's anything but 0, the owner of this prefs file's antag choices were,
										//autocorrected this round, not that you'd need to check that.

	var/UI_style = null
	var/buttons_locked = FALSE
	var/hotkeys = TRUE

	///Runechat preference. If true, certain messages will be displayed on the map, not ust on the chat area. Boolean.
	var/chat_on_map = TRUE
	///Limit preference on the size of the message. Requires chat_on_map to have effect.
	var/max_chat_length = CHAT_MESSAGE_MAX_LENGTH
	///Whether non-mob messages will be displayed, such as machine vendor announcements. Requires chat_on_map to have effect. Boolean.
	var/see_chat_non_mob = TRUE
	///Whether emotes will be displayed on runechat. Requires chat_on_map to have effect. Boolean.
	var/see_rc_emotes = TRUE
	//Клан вампиров
	var/datum/vampire_clan/clan
	var/datum/morality/morality_path = new /datum/morality/humanity()
	// Custom Keybindings
	var/list/key_bindings = list()

	var/tgui_fancy = TRUE
	var/tgui_input_mode = TRUE // All the Input Boxes (Text,Number,List,Alert)
	var/tgui_large_buttons = TRUE
	var/tgui_swapped_buttons = FALSE
	var/tgui_lock = FALSE
	var/windowflashing = TRUE
	var/toggles = TOGGLES_DEFAULT
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"
	var/ghost_orbit = GHOST_ORBIT_CIRCLE
	var/ghost_accs = GHOST_ACCS_DEFAULT_OPTION
	var/ghost_others = GHOST_OTHERS_DEFAULT_OPTION
	var/ghost_hud = 1
	var/inquisitive_ghost = 1
	var/allow_midround_antag = 1
	var/preferred_map = null
	var/pda_style = MONO
	var/pda_color = "#808000"

	var/uses_glasses_colour = 0

	//character preferences
	var/slot_randomized					//keeps track of round-to-round randomization of the character slot, prevents overwriting
	var/slotlocked = 0
	var/real_name						//our character's name
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/total_age = 30
	var/underwear = "Nude"				//underwear type
	var/underwear_color = "000"			//underwear color
	var/undershirt = "Nude"				//undershirt type
	var/socks = "Nude"					//socks type
	var/backpack = DBACKPACK				//backpack type
	var/jumpsuit_style = PREF_SUIT		//suit/skirt
	var/hairstyle = "Bald"				//Hair type
	var/hair_color = "#000000"				//Hair color
	var/facial_hairstyle = "Shaved"	//Face hair type
	var/facial_hair_color = "#000000"		//Facial hair color
	var/skin_tone = "caucasian1"		//Skin color
	var/eye_color = "#000000"				//Eye color
	var/datum/species/pref_species = new /datum/species/human()	//Mutant race
	var/list/features = list("mcolor" = "#FFFFFF", "ethcolor" = "#9c3030", "tail_lizard" = "Smooth", "tail_human" = "None", "snout" = "Round", "horns" = "None", "ears" = "None", "wings" = "None", "frills" = "None", "spines" = "None", "body_markings" = "None", "legs" = "Normal Legs", "moth_wings" = "Plain", "moth_antennae" = "Plain", "moth_markings" = "None")
	var/list/randomise = list(RANDOM_UNDERWEAR = TRUE, RANDOM_UNDERWEAR_COLOR = TRUE, RANDOM_UNDERSHIRT = TRUE, RANDOM_SOCKS = TRUE, RANDOM_BACKPACK = TRUE, RANDOM_JUMPSUIT_STYLE = TRUE, RANDOM_HAIRSTYLE = TRUE, RANDOM_HAIR_COLOR = TRUE, RANDOM_FACIAL_HAIRSTYLE = TRUE, RANDOM_FACIAL_HAIR_COLOR = TRUE, RANDOM_SKIN_TONE = TRUE, RANDOM_EYE_COLOR = TRUE)
	var/phobia = "spiders"
	var/list/genders = list(MALE, FEMALE, PLURAL)
	var/list/custom_names = list()
	var/preferred_ai_core_display = "Blue"
	var/prefered_security_department = SEC_DEPT_RANDOM

	var/list/alt_titles_preferences = list() // TFN EDIT: alt job titles

	//Quirk list
	var/list/all_quirks = list()

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

		// Want randomjob if preferences already filled - Donkie
	var/joblessrole = BERANDOMJOB  //defaults to 1 for fewer assistants

	// 0 = character settings, 1 = game preferences
	var/current_tab = 0

	var/unlock_content = 0

	var/list/ignoring = list()

	var/clientfps = -1

	var/parallax

	var/ambientocclusion = TRUE
	///Should we automatically fit the viewport?
	var/auto_fit_viewport = FALSE
	///Should we be in the widescreen mode set by the config?
	var/widescreenpref = TRUE
	///Old discipline icons
	var/old_discipline = FALSE
	///What size should pixels be displayed as? 0 is strech to fit
	var/pixel_size = 0
	///What scaling method should we use? Distort means nearest neighbor
	var/scaling_method = SCALING_METHOD_DISTORT
	var/uplink_spawn_loc = UPLINK_PDA
	///The playtime_reward_cloak variable can be set to TRUE from the prefs menu only once the user has gained over 5K playtime hours. If true, it allows the user to get a cool looking roundstart cloak.
	var/playtime_reward_cloak = FALSE

	var/list/exp = list()
	var/list/menuoptions

	var/action_buttons_screen_locs = list()

	///This var stores the amount of points the owner will get for making it out alive.
	var/hardcore_survival_score = 0

	///Someone thought we were nice! We get a little heart in OOC until we join the server past the below time (we can keep it until the end of the round otherwise)
	var/hearted
	///If we have a hearted commendations, we honor it every time the player loads preferences until this time has been passed
	var/hearted_until
	/// Agendered spessmen can choose whether to have a male or female bodytype
	var/body_type
	var/body_model = NORMAL_BODY_MODEL_NUMBER
	/// If we have persistent scars enabled
	var/persistent_scars = TRUE
	///If we want to broadcast deadchat connect/disconnect messages
	var/broadcast_login_logout = TRUE

	//Generation
	var/generation = DEFAULT_GENERATION
	var/generation_bonus = 0

	//Renown
	var/renownrank = 0
	var/honor = 0
	var/glory = 0
	var/wisdom = 0

	//Masquerade
	var/masquerade = 5

	var/path_score = 7
	var/is_enlightened = FALSE

	//Legacy

	var/discipline1level = 1
	var/discipline2level = 1
	var/discipline3level = 1
	var/discipline4level = 1

	var/discipline1type
	var/discipline2type
	var/discipline3type
	var/discipline4type

	//New experience counter, global for all characters per client.
	var/player_experience = 50
	//Amount of EXP used on the current character, this is returned when a character is reset.
	var/experience_used_on_character = 0

	//Character sheet stats
	var/true_experience = 0
	var/torpor_count = 0

	//linked lists determining known Disciplines and their known ranks
	///Datum types of the Disciplines this character knows.
	var/list/discipline_types = list()
	///Ranks of the Disciplines this character knows, corresponding to discipline_types.
	var/list/discipline_levels = list()

	var/physique = 1
	var/dexterity = 1
	var/social = 1
	var/mentality = 1
	var/blood = 1

	//Skills
	var/lockpicking = 0
	var/athletics = 0

	var/info_known = INFO_KNOWN_UNKNOWN

	var/friend = FALSE
	var/enemy = FALSE
	var/lover = FALSE

	var/show_flavor_text_when_masked = FALSE
	var/flavor_text
	var/flavor_text_nsfw
	var/ooc_notes
	var/character_notes

	var/friend_text
	var/enemy_text
	var/lover_text

	var/diablerist = 0

	var/reason_of_death = "None"

	var/archetype = /datum/archetype/average

	var/breed = "Homid"
	var/datum/garou_tribe/tribe = new /datum/garou_tribe/galestalkers()
	var/datum/auspice/auspice = new /datum/auspice/ahroun()
	var/werewolf_color = "black"
	var/werewolf_scar = 0
	var/werewolf_hair = 0
	var/werewolf_hair_color = "#000000"
	var/werewolf_eye_color = "#FFFFFF"
	var/werewolf_apparel

	var/werewolf_name
	var/auspice_level = 1

	var/clan_accessory

	var/dharma_type = /datum/dharma
	var/dharma_level = 1
	var/po_type = "Rebel"
	var/po = 5
	var/hun = 5
	var/yang = 5
	var/yin = 5
	var/list/chi_types = list()
	var/list/chi_levels = list()

	// Off by default. Opt-in.
	var/nsfw_content_pref = FALSE

	var/derangement = TRUE

/datum/preferences/proc/add_experience(amount)
	player_experience = clamp(player_experience + amount, 0, 100000)

/datum/preferences/proc/reset_character()
	slotlocked = 0
	diablerist = 0
	torpor_count = 0
	generation_bonus = 0
	physique = 1
	dexterity = 1
	mentality = 1
	social = 1
	blood = 1
	lockpicking = 0
	athletics = 0
	info_known = INFO_KNOWN_UNKNOWN
	masquerade = initial(masquerade)
	generation = initial(generation)
	dharma_level = initial(dharma_level)
	hun = initial(hun)
	po = initial(po)
	yin = initial(yin)
	yang = initial(yang)
	chi_types = list()
	chi_levels = list()
	renownrank = 0
	honor = 0
	glory = 0
	wisdom = 0
	archetype = pick(subtypesof(/datum/archetype))
	var/datum/archetype/A = new archetype()
	physique = A.start_physique
	dexterity = A.start_dexterity
	social = A.start_social
	mentality = A.start_mentality
	blood = A.start_blood
	lockpicking = A.start_lockpicking
	athletics = A.start_athletics
	clan = GLOB.vampire_clans[/datum/vampire_clan/brujah]
	qdel(morality_path)
	morality_path = new /datum/morality/humanity()
	discipline_types = list()
	discipline_levels = list()
	for (var/i in 1 to clan.clan_disciplines.len)
		discipline_types += clan.clan_disciplines[i]
		discipline_levels += 1
	path_score = morality_path.score
	is_enlightened = FALSE
	random_species()
	random_character()
	body_model = rand(SLIM_BODY_MODEL_NUMBER, FAT_BODY_MODEL_NUMBER)
	experience_used_on_character = 0
	real_name = random_unique_name(gender)
	equipped_gear = list() // TFN ADDITION
	headshot_link = null // TFN ADDITION
	save_character()

/datum/preferences/New(client/C)
	parent = C

	for(var/custom_name_id in GLOB.preferences_custom_names)
		custom_names[custom_name_id] = get_default_name(custom_name_id)

	UI_style = GLOB.available_ui_styles[1]
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
//			unlock_content = C.IsByondMember()
//			if(unlock_content)
//				max_save_slots = 8
	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return
	//we couldn't load character data so just randomize the character appearance + name
	random_species()
	random_character()		//let's create a random character then - rather than a fat, bald and naked man.
	key_bindings = deepCopyList(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	C?.set_macros()
//	pref_species = new /datum/species/kindred()
	real_name = pref_species.random_name(gender,1)
	if(!loaded_preferences_successfully)
		save_preferences()
	save_character()		//let's save this new random character so it doesn't keep generating new ones.
	menuoptions = list()
	return

#define APPEARANCE_CATEGORY_COLUMN "<td valign='top' width='14%'>"
#define MAX_MUTANT_ROWS 4
#define ATTRIBUTE_BASE_LIMIT 5 //Highest level that a base attribute can be upgraded to. Bonus attributes can increase the actual amount past the limit.

/proc/make_font_cool(text)
	if(text)
		var/coolfont = "<font face='Percolator'>[text]</font>"
		return coolfont

/proc/RankName(rank, tribe)
	if(tribe != "Corax")
		switch(rank)
			if(0)
				return "cub" // in lowercase so that \a might function during the character examine
			if(1)
				return "cliath"
			if(2)
				return "fostern"
			if(3)
				return "adren"
			if(4)
				return "athro"
			if(5)
				return "elder"
			if(6)
				return "legend"
	else
		switch(rank)
			if(0)
				return "fledgling"
			if(1)
				return "oviculum"
			if(2)
				return "neocornix"
			if(3)
				return "ales"
			if(4)
				return "volucris"
			if(5)
				return "corvus"
			if(6)
				return "grey eminence"

/proc/RankDesc(rank, tribe)
	if(tribe != "Corax")
		switch(rank)
			if(0)
				return "You are not known to other Garou. Why?"
			if(1)
				return "You have completed your rite of passage as a Cliath."
			if(2)
				return "Fosterns have challenged for their rank and become proven members of Garou society."
			if(3)
				return "With proven work, wit, and function, Adren are higher echelons of Garou society, better known for control."
			if(4)
				return "A disciplined lieutenant and trusted Garou to your peers, you have respect and renown within the city as an Athro."
			if(5)
				return "One of the renowned names of the region, you are known as outstanding in California to some degree, worthy of the title of Elder."
			if(6)
				return "You're a Legendary NPC."
	else
		switch(rank)
			if(0)
				return "You are barely known to other Corax, and sit on the lower branches during Parliament"
			if(1)
				return "Other Corax have indulged in your secrets, and consider you Oviculum."
			if(2)
				return "You usually get to speak before the afternoon, and have shared remarkable intel several times, making you Neocornix ."
			if(3)
				return "You are witty, knowledgeable and have started making your mark accross the state, earning you the title of Ales"
			if(4)
				return "Not only do you posess juicy info over the state's big players, but you've gotten into dangerous scraps and came out in (mostly) one piece. \nOther Corax respectfully refer to you as Volucris"
			if(5)
				return "You sit on the highest branches of the tree whenever a Parliament's ongoing. You have shared devastating secrets with the rest of the Corax, and have shaped the fate of this region. \n You have the influence and prestige that makes the rest of your kind quiet down and listen, earning you the illustrious title of Corvus."
			if(6)
				return "Though you are officially still Corvus, your name is known worldwide, and your words can make or break nations, you should ideally be an NPC"

/datum/preferences/proc/ShowChoices(mob/user)
	show_loadout = (current_tab != 1) ? show_loadout : FALSE // TFN EDIT: loadout
	if(!SSatoms.initialized)
		to_chat(user, span_warning("Please wait for the game to do a little more setup first...!"))
		return
	if(!user?.client) // Without a client in control, you can't do anything.
		return
	if(slot_randomized)
		load_character(default_slot) // Reloads the character slot. Prevents random features from overwriting the slot if saved.
		slot_randomized = FALSE
	update_preview_icon(show_loadout) // TFN EDIT: original: update_preview_icon()
	var/list/dat = list("<center>")

	if(istype(user, /mob/dead/new_player))
		dat += "<a href='byond://?_src_=prefs;preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>[make_font_cool("CHARACTER SETTINGS")]</a>"
	dat += "<a href='byond://?_src_=prefs;preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>[make_font_cool("GAME PREFERENCES")]</a>"
	dat += "<a href='byond://?_src_=prefs;preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>[make_font_cool("LOADOUT")]</a>" // TFN ADDITION - loadout
	dat += "<a href='byond://?_src_=prefs;preference=tab;tab=3' [current_tab == 3 ? "class='linkOn'" : ""]>[make_font_cool("OOC PREFERENCES")]</a>"
	dat += "<a href='byond://?_src_=prefs;preference=tab;tab=4' [current_tab == 4 ? "class='linkOn'" : ""]>[make_font_cool("CUSTOM KEYBINDINGS")]</a>"

	if(!path)
		dat += "<div class='notice'>Please create an account to save your preferences</div>"

	dat += "</center>"

	dat += "<HR>"

	switch(current_tab)
		if (0) // Character Settings#
			if(path)
				var/savefile/S = new /savefile(path)
				if(S)
					dat += "<center>"
					var/name
					var/unspaced_slots = 0
					for(var/i=1, i<=max_save_slots, i++)
						unspaced_slots++
						if(unspaced_slots > 4)
							dat += "<br>"
							unspaced_slots = 0
						S.cd = "/character[i]"
						S["real_name"] >> name
						if(!name)
							name = "Character[i]"
						if(istype(user, /mob/dead/new_player))
							dat += "<a style='white-space:nowrap;' href='byond://?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a> "
					dat += "</center>"

			if(reason_of_death != "None")
				dat += "<center><b>Last death</b>: [reason_of_death]</center>"

			dat += "<center><h2>[make_font_cool("OCCUPATION CHOICES")]</h2>"
			dat += "<a href='byond://?_src_=prefs;preference=job;task=menu'>Set Occupation Preferences</a><br></center>"
			if(CONFIG_GET(flag/roundstart_traits))
				dat += "<center><h2>[make_font_cool("QUIRK SETUP")]</h2>"
				dat += "<a href='byond://?_src_=prefs;preference=trait;task=menu'>Configure Quirks</a><br></center>"
				dat += "<center><b>Current Quirks:</b> [all_quirks.len ? all_quirks.Join(", ") : "None"]</center>"
			dat += "<h2>[make_font_cool("IDENTITY")]</h2>"
			dat += "<table width='100%'><tr><td width='75%' valign='top'>"
			if(is_banned_from(user.ckey, "Appearance"))
				dat += "<b>You are banned from using custom names and appearances. You can continue to adjust your characters, but you will be randomised once you join the game.</b><br>"
			dat += "<a href='byond://?_src_=prefs;preference=name;task=random'>Random Name</A> "
			dat += "<br><b>Name:</b> "
			dat += "<a href='byond://?_src_=prefs;preference=name;task=input'>[real_name]</a><BR>"

			if(!(AGENDER in pref_species.species_traits))
				var/dispGender
				if(gender == MALE)
					dispGender = "Male"
				else if(gender == FEMALE)
					dispGender = "Female"
				else
					dispGender = "Other"
				dat += "<b>Gender:</b> <a href='byond://?_src_=prefs;preference=gender'>[dispGender]</a>"
				if(gender == PLURAL || gender == NEUTER)
					dat += "<BR><b>Body Type:</b> <a href='byond://?_src_=prefs;preference=body_type'>[body_type == MALE ? "Male" : "Female"]</a>"

			var/body_m = "Normal"
			switch(body_model)
				if(1)
					body_m = "Slim"
				if(2)
					body_m = "Normal"
				if(3)
					body_m = "Fat"

			dat += "<BR><b>Shape:</b> <a href='byond://?_src_=prefs;preference=body_model'>[body_m]</a>"

			dat += "<br><b>Biological Age:</b> <a href='byond://?_src_=prefs;preference=age;task=input'>[age]</a>"
			dat += "<br><b>Actual Age:</b> <a href='byond://?_src_=prefs;preference=total_age;task=input'>[max(age, total_age)]</a>"

			dat += "</tr></table>"

			dat += "<h2>[make_font_cool("BODY")]</h2>"
			dat += "<a href='byond://?_src_=prefs;preference=all;task=random'>Random Body</A> "

			dat += "<table width='100%'><tr><td width='24%' valign='top'>"

			dat += "<b>Species:</b><BR><a href='byond://?_src_=prefs;preference=species;task=input'>[pref_species.name]</a><BR>"
			switch(pref_species.name)
				if("Vampire")
					dat += "<b>Masquerade:</b> [masquerade]/5<BR>"
					dat += "<b>Generation:</b> [generation]"
					var/generation_allowed = TRUE
					if(clan?.name == CLAN_NONE)
						generation_allowed = FALSE
					if(generation_allowed)
						if(SSwhitelists.is_whitelisted(user.ckey, TRUSTED_PLAYER))
							if(generation_bonus)
								dat += " (+[generation_bonus]/[min(MAX_TRUSTED_GENERATION-1, generation-MAX_TRUSTED_GENERATION)])"
							if(player_experience >= 20 && generation_bonus < max(0, generation-MAX_TRUSTED_GENERATION))
								dat += " <a href='byond://?_src_=prefs;preference=generation;task=input'>Claim generation bonus (20)</a><BR>"
							else
								dat += "<BR>"
						else
							if(generation_bonus)
								dat += " (+[generation_bonus]/[min(MAX_PUBLIC_GENERATION-1, generation-MAX_PUBLIC_GENERATION)])"
							if(player_experience >= 20 && generation_bonus < max(0, generation-MAX_PUBLIC_GENERATION))
								dat += " <a href='byond://?_src_=prefs;preference=generation;task=input'>Claim generation bonus (20)</a><BR>"
							else
								dat += "<BR>"
					else
						dat += "<BR>"
				if("Kuei-Jin")
					var/datum/dharma/D = new dharma_type()
					dat += "<b>Dharma:</b> [D.name] [dharma_level]/6 <a href='byond://?_src_=prefs;preference=dharmatype;task=input'>Switch</a><BR>"
					dat += "[D.desc]<BR>"
					if(player_experience >= min((dharma_level * 5), 20) && (dharma_level < 6))
						var/dharma_cost = min((dharma_level * 5), 20)
						dat += " <a href='byond://?_src_=prefs;preference=dharmarise;task=input'>Raise Dharmic Enlightenment ([dharma_cost])</a><BR>"
					dat += "<b>P'o Personality</b>: [po_type] <a href='byond://?_src_=prefs;preference=potype;task=input'>Switch</a><BR>"
					dat += "<b>Awareness:</b> [masquerade]/5<BR>"
					dat += "<b>Yin/Yang</b>: [yin]/[yang] <a href='byond://?_src_=prefs;preference=chibalance;task=input'>Adjust</a><BR>"
					dat += "<b>Hun/P'o</b>: [hun]/[po] <a href='byond://?_src_=prefs;preference=demonbalance;task=input'>Adjust</a><BR>"
				if("Werewolf")
					if(!glory)
						glory = 0
					if(!honor)
						honor = 0
					if(!wisdom)
						wisdom = 0
					if(!renownrank)
						renownrank = 0
					var/gloryXP = 25
					var/honorXP = 25
					var/wisdomXP = 25
					dat += "<b>Veil:</b> [masquerade]/5<BR>"
					switch(tribe.name)
						if("Ronin")
							dat += "Renown matters little to you, now."
						if("Black Spiral Dancers")
							dat += "<b>Infamy:</b> [glory]/10<BR>"
							if(gloryXP <= player_experience && glory < 10)
								dat +=" <a href='byond://?_src_=prefs;preference=renownglory;task=input'>Raise Infamy ([gloryXP])</a><BR>"
							dat += "<b>Power:</b> [honor]/10<BR>"
							if(honorXP <= player_experience && honor < 10)
								dat +=" <a href='byond://?_src_=prefs;preference=renownhonor;task=input'>Raise Power ([honorXP])</a><BR>"
							dat += "<b>Cunning:</b> [wisdom]/10<BR>"
							if(wisdomXP <= player_experience && wisdom < 10)
								dat +=" <a href='byond://?_src_=prefs;preference=renownwisdom;task=input'>Raise Cunning ([wisdomXP])</a><BR>"
						else
							dat += "<b>Glory:</b> [glory]/10<BR>"
							if(gloryXP <= player_experience && glory < 10)
								dat +=" <a href='byond://?_src_=prefs;preference=renownglory;task=input'>Raise Glory ([gloryXP])</a><BR>"
							dat += "<b>Honor:</b> [honor]/10<BR>"
							if(honorXP <= player_experience && honor < 10)
								dat +=" <a href='byond://?_src_=prefs;preference=renownhonor;task=input'>Raise Honor ([honorXP])</a><BR>"
							dat += "<b>Wisdom:</b> [wisdom]/10<BR>"
							if(wisdomXP <= player_experience && wisdom < 10)
								dat +=" <a href='byond://?_src_=prefs;preference=renownwisdom;task=input'>Raise Wisdom ([wisdomXP])</a><BR>"
					dat += "<b>Renown Rank:</b> [RankName(renownrank,src.tribe.name)]<br>"
					dat += "[RankDesc(renownrank, src.tribe.name)]<BR>"
					var/canraise = 0
					if(SSwhitelists.is_whitelisted(user.ckey, TRUSTED_PLAYER))
						if(renownrank < MAX_TRUSTED_RANK)
							canraise = 1
					else
						if(renownrank < MAX_PUBLIC_RANK)
							canraise = 1
					if(canraise)
						canraise = AuspiceRankUp()
					if(canraise)
						dat += " <a href='byond://?_src_=prefs;preference=renownrank;task=input'>Raise Renown Rank</a><BR>"
					else if(renownrank < MAX_PUBLIC_RANK)
						var/renownrequirement = RenownRequirements()
						dat += "<b>Needed To Raise Renown:</b> [renownrequirement]<BR>"
					else
						dat += "<BR>"
				if("Ghoul")
					dat += "<b>Masquerade:</b> [masquerade]/5<BR>"

			dat += "<h2>[make_font_cool("ATTRIBUTES")]</h2>"

			dat += "<b>Archetype</b><BR>"
			var/datum/archetype/A = new archetype()
			dat += "<a href='byond://?_src_=prefs;preference=archetype;task=input'>[A.name]</a> [A.specialization]<BR>"

			//Prices for each ability, can be adjusted, multiplied by current attribute level
			var/physique_price = 4
			var/dexterity_price = 4
			var/social_price = 4
			var/mentality_price = 4
			var/blood_price = 6
			//Lockpicking and Athletics have an initial price of 3
			var/lockpicking_price = !lockpicking ? 3 : 2
			var/athletics_price = !athletics ? 3 : 2

			dat += "<b>Physique:</b> [build_attribute_score(physique, A.archetype_additional_physique, physique_price, "physique")]"
			dat += "<b>Dexterity:</b> [build_attribute_score(dexterity, A.archetype_additional_dexterity, dexterity_price, "dexterity")]"
			dat += "<b>Social:</b> [build_attribute_score(social, A.archetype_additional_social, social_price, "social")]"
			dat += "<b>Mentality:</b> [build_attribute_score(mentality, A.archetype_additional_mentality, mentality_price, "mentality")]"
			dat += "<b>Cruelty:</b> [build_attribute_score(blood, A.archetype_additional_blood, blood_price, "blood")]"
			dat += "<b>Lockpicking:</b> [build_attribute_score(lockpicking, A.archetype_additional_lockpicking, lockpicking_price, "lockpicking")]"
			dat += "<b>Athletics:</b> [build_attribute_score(athletics, A.archetype_additional_athletics, athletics_price, "athletics")]"
			dat += "Experience rewarded: [player_experience]<BR>"
			if(pref_species.name == "Werewolf")
				dat += "<h2>[make_font_cool("TRIBE")]</h2>"
				dat += "<br><b>Werewolf Name:</b> "
				dat += "<a href='byond://?_src_=prefs;preference=werewolf_name;task=input'>[werewolf_name]</a><BR>"
				dat += "<b>Auspice:</b> <a href='byond://?_src_=prefs;preference=auspice;task=input'>[auspice.name]</a><BR>"
				dat += "Description: [auspice.desc]<BR>"
				dat += "<b>Power:</b> •[auspice_level > 1 ? "•" : "o"][auspice_level > 2 ? "•" : "o"]([auspice_level])"
				if(player_experience >= 10*auspice_level && auspice_level != 3)
					dat += "<a href='byond://?_src_=prefs;preference=auspice_level;task=input'>Increase ([10*auspice_level])</a>"
				dat += "<b>Initial Rage:</b> •[auspice.start_rage > 1 ? "•" : "o"][auspice.start_rage > 2 ? "•" : "o"][auspice.start_rage > 3 ? "•" : "o"][auspice.start_rage > 4 ? "•" : "o"]([auspice.start_rage])<BR>"
				var/gifts_text = ""
				var/num_of_gifts = 0
				for(var/i in 1 to auspice_level)
					var/zalupa = tribe.tribal_gifts[i]
					var/datum/action/T = new zalupa()
					gifts_text += "[T.name], "
				for(var/i in auspice.gifts)
					var/datum/action/ACT = new i()
					num_of_gifts = min(num_of_gifts+1, length(auspice.gifts))
					if(num_of_gifts != length(auspice.gifts))
						gifts_text += "[ACT.name], "
					else
						gifts_text += "[ACT.name].<BR>"
					qdel(ACT)
				dat += "<b>Initial Gifts:</b> [gifts_text]"
				// These mobs should be made in nullspace to avoid dumping them onto the map somewhere.
				var/mob/living/simple_animal/werewolf/crinos/DAWOF = new
				var/mob/living/simple_animal/werewolf/lupus/DAWOF2 = new

				DAWOF.sprite_color = werewolf_color
				DAWOF2.sprite_color = werewolf_color

				var/obj/effect/overlay/eyes_crinos = new(DAWOF)
				eyes_crinos.icon = 'code/modules/wod13/werewolf.dmi'
				eyes_crinos.icon_state = "eyes"
				eyes_crinos.layer = ABOVE_HUD_LAYER
				eyes_crinos.color = werewolf_eye_color
				DAWOF.overlays |= eyes_crinos

				var/obj/effect/overlay/scar_crinos = new(DAWOF)
				scar_crinos.icon = 'code/modules/wod13/werewolf.dmi'
				scar_crinos.icon_state = "scar[werewolf_scar]"
				scar_crinos.layer = ABOVE_HUD_LAYER
				DAWOF.overlays |= scar_crinos

				var/obj/effect/overlay/hair_crinos = new(DAWOF)
				hair_crinos.icon = 'code/modules/wod13/werewolf.dmi'
				hair_crinos.icon_state = "hair[werewolf_hair]"
				hair_crinos.layer = ABOVE_HUD_LAYER
				hair_crinos.color = werewolf_hair_color
				DAWOF.overlays |= hair_crinos

				var/obj/effect/overlay/eyes_lupus = new(DAWOF2)
				eyes_lupus.icon = 'code/modules/wod13/tfn_lupus.dmi'
				eyes_lupus.icon_state = "eyes"
				eyes_lupus.layer = ABOVE_HUD_LAYER
				eyes_lupus.color = werewolf_eye_color
				DAWOF2.overlays |= eyes_lupus

				DAWOF.update_icons()
				DAWOF2.update_icons()
				dat += "[icon2html(getFlatIcon(DAWOF), user)][icon2html(getFlatIcon(DAWOF2), user)]<BR>"
				qdel(DAWOF)
				qdel(DAWOF2)
				dat += "<b>Breed:</b> <a href='byond://?_src_=prefs;preference=breed;task=input'>[breed]</a><BR>"
				dat += "<b>Tribe:</b> <a href='byond://?_src_=prefs;preference=tribe;task=input'>[tribe.name]</a><BR>"
				dat += "<b>Description:</b> [tribe.desc]<BR>"
				dat += "Color: <a href='byond://?_src_=prefs;preference=werewolf_color;task=input'>[werewolf_color]</a><BR>"
				dat += "Scars: <a href='byond://?_src_=prefs;preference=werewolf_scar;task=input'>[werewolf_scar]</a><BR>"
				dat += "Hair: <a href='byond://?_src_=prefs;preference=werewolf_hair;task=input'>[werewolf_hair]</a><BR>"
				dat += "Hair Color: <a href='byond://?_src_=prefs;preference=werewolf_hair_color;task=input'>[werewolf_hair_color]</a><BR>"
				dat += "Eyes: <a href='byond://?_src_=prefs;preference=werewolf_eye_color;task=input'>[werewolf_eye_color]</a><BR>"
			if(pref_species.name == "Vampire")
				dat += "<h2>[make_font_cool("CLAN")]</h2>"
				dat += "<b>Clan/Bloodline:</b> <a href='byond://?_src_=prefs;preference=clan;task=input'>[clan.name]</a><BR>"
				if(clan.name == CLAN_MALKAVIAN)
					dat+="<b>Degree of Derangement:</b> <a href ='byond://?_src_=prefs;preference=derangement;task=input'>[derangement == TRUE ? "Insanity" : "Madness"]</a><BR>"
				dat += "<b>Description:</b> [clan.desc]<BR>"
				dat += "<b>Curse:</b> [clan.curse]<BR>"
				if (length(clan.accessories))
					// No clan accessory, or unsupported one
					if (!clan.accessories.Find(clan_accessory))
						// Set to Clan's default accessory
						if (clan.default_accessory)
							clan_accessory = clan.default_accessory
						// Can be null, so null it
						else if (clan.accessories.Find("none"))
							clan_accessory = null
						// Must have an accessory, set to a random one
						else
							clan_accessory = pick(clan.accessories)

					// Display clan accessory and allow selection
					dat += "<b>Marks:</b> <a href='byond://?_src_=prefs;preference=clan_acc;task=input'>[clan_accessory ? clan_accessory : "none"]</a><BR>"
				else
					clan_accessory = null
				dat += "<h2>[make_font_cool("DISCIPLINES")]</h2>"

				for (var/i in 1 to discipline_types.len)
					var/discipline_type = discipline_types[i]
					var/datum/discipline/discipline = new discipline_type
					var/discipline_level = discipline_levels[i]

					var/cost
					if (discipline_level <= 0)
						cost = 10
					else if (clan.name == CLAN_NONE)
						cost = discipline_level * 6
					else if (clan.clan_disciplines.Find(discipline_type))
						cost = discipline_level * 5
					else
						cost = discipline_level * 7

					dat += "<b>[discipline.name]</b>: [discipline_level > 0 ? "•" : "o"][discipline_level > 1 ? "•" : "o"][discipline_level > 2 ? "•" : "o"][discipline_level > 3 ? "•" : "o"][discipline_level > 4 ? "•" : "o"]([discipline_level])"
					if((player_experience >= cost) && (discipline_level != 5))
						dat += "<a href='byond://?_src_=prefs;preference=discipline;task=input;upgradediscipline=[i]'>Learn ([cost])</a><BR>"
					else
						dat += "<BR>"
					dat += "-[discipline.desc]<BR>"
					qdel(discipline)

				if (clan.name == CLAN_NONE)
					var/list/possible_new_disciplines = subtypesof(/datum/discipline) - discipline_types - /datum/discipline/bloodheal
					for (var/discipline_type in possible_new_disciplines)
						var/datum/discipline/discipline = new discipline_type
						if (discipline.clan_restricted)
							possible_new_disciplines -= discipline_type
						qdel(discipline)
					if (possible_new_disciplines.len && (player_experience >= 10))
						dat += "<a href='byond://?_src_=prefs;preference=newdiscipline;task=input'>Learn a new Discipline (10)</a><BR>"

				switch(clan.name)

					if(CLAN_SALUBRI)

						var/list/possible_new_valerens = list(/datum/discipline/valeren, /datum/discipline/valeren_warrior)
						possible_new_valerens -= discipline_types

						if (possible_new_valerens.len && (player_experience >= 10))
							dat += "<a href='byond://?_src_=prefs;preference=newvaleren;task=input'>Learn a new Valeren Path (10)</a><BR>"

					if(CLAN_SALUBRI_WARRIOR)

						var/list/possible_new_valerens = list(/datum/discipline/valeren, /datum/discipline/valeren_warrior)
						possible_new_valerens -= discipline_types

						if (possible_new_valerens.len && (player_experience >= 10))
							dat += "<a href='byond://?_src_=prefs;preference=newvaleren;task=input'>Learn a new Valeren Path (10)</a><BR>"


			if(pref_species.name == "Ghoul")
				for (var/i in 1 to discipline_types.len)
					var/discipline_type = discipline_types[i]
					var/datum/discipline/discipline = new discipline_type
					dat += "<b>[discipline.name]</b>: •(1)<BR>"
					dat += "-[discipline.desc]<BR>"
					qdel(discipline)

				var/list/possible_new_disciplines = subtypesof(/datum/discipline) - discipline_types - /datum/discipline/bloodheal
				if (possible_new_disciplines.len && (player_experience >= 10))
					dat += "<a href='byond://?_src_=prefs;preference=newghouldiscipline;task=input'>Learn a new Discipline (10)</a><BR>"

			if (pref_species.name == "Kuei-Jin")
				dat += "<h2>[make_font_cool("DISCIPLINES")]</h2><BR>"
				for (var/i in 1 to discipline_types.len)
					var/discipline_type = discipline_types[i]
					var/datum/chi_discipline/discipline = new discipline_type
					var/discipline_level = discipline_levels[i]

					var/cost
					if (discipline_level <= 0)
						cost = 10
					else
						cost = discipline_level * 6

					dat += "<b>[discipline.name]</b> ([discipline.discipline_type]): [discipline_level > 0 ? "•" : "o"][discipline_level > 1 ? "•" : "o"][discipline_level > 2 ? "•" : "o"][discipline_level > 3 ? "•" : "o"][discipline_level > 4 ? "•" : "o"]([discipline_level])"
					if((player_experience >= cost) && (discipline_level != 5))
						dat += "<a href='byond://?_src_=prefs;preference=discipline;task=input;upgradechidiscipline=[i]'>Learn ([cost])</a><BR>"
					else
						dat += "<BR>"
					dat += "-[discipline.desc]. Yin:[discipline.cost_yin], Yang:[discipline.cost_yang], Demon:[discipline.cost_demon]<BR>"
					qdel(discipline)
				var/list/possible_new_disciplines = subtypesof(/datum/chi_discipline) - discipline_types
				var/has_chi_one = FALSE
				var/has_demon_one = FALSE
				var/how_much_usual = 0
				for(var/i in discipline_types)
					if(i)
						var/datum/chi_discipline/C = i
						if(initial(C.discipline_type) == "Shintai")
							how_much_usual += 1
						if(initial(C.discipline_type) == "Demon")
							has_demon_one = TRUE
						if(initial(C.discipline_type) == "Chi")
							has_chi_one = TRUE
				for(var/i in possible_new_disciplines)
					if(i)
						var/datum/chi_discipline/C = i
						if(initial(C.discipline_type) == "Shintai")
							if(how_much_usual >= 3)
								possible_new_disciplines -= i
						if(initial(C.discipline_type) == "Demon")
							if(has_demon_one)
								possible_new_disciplines -= i
						if(initial(C.discipline_type) == "Chi")
							if(has_chi_one)
								possible_new_disciplines -= i
				if (possible_new_disciplines.len && (player_experience >= 10))
					dat += "<a href='byond://?_src_=prefs;preference=newchidiscipline;task=input'>Learn a new Discipline (10)</a><BR>"

			if(slotlocked)
				dat += "<a href='byond://?_src_=prefs;preference=change_appearance;task=input'>Change Appearance (Free)</a><BR>"
			if(generation_bonus)
				dat += "<a href='byond://?_src_=prefs;preference=reset_with_bonus;task=input'>Create new character with generation bonus ([generation]-[generation_bonus])</a><BR>"
			// TFN EDIT ADDITION START: headshots, flavortext, morality system, and most other TFN specific prefs
			if(pref_species.name == "Vampire")
				dat += "<h2>[make_font_cool("PATH")]</h2>"
				dat += "<b>[morality_path.name]:</b> [path_score]/10"
				if ((player_experience >= (path_score * 2)) && (path_score < 10))
					dat += " <a href='byond://?_src_=prefs;preference=path;task=input'>Increase Path ([path_score * 2])</a>"
				if(!slotlocked)
					dat += "<a href='byond://?_src_=prefs;preference=pathof;task=input'>Switch Path</a>"
				dat += "<BR><b>Description:</b> [morality_path.desc]<BR>"

			var/preview_text = copytext_char(flavor_text, 1, 110)
			var/preview_text_nsfw = copytext_char(flavor_text_nsfw, 1, 110)

			dat += "<BR><a href='byond://?_src_=prefs;preference=view_flavortext;task=input'>Show Examine Panel</a>"

			if(length(flavor_text) <= 110)
				dat += "<BR><b>Flavor Text:</b> [flavor_text] <a href='byond://?_src_=prefs;preference=flavor_text;task=input'>Change</a>"
			else
				dat += "<BR><b>Flavor Text:</b> [preview_text]... <a href='byond://?_src_=prefs;preference=flavor_text;task=input'>Change</a>"

			dat += "<BR><b>Character Notes:</b> [character_notes] <a href='byond://?_src_=prefs;preference=character_notes;task=input'>Change</a>"

			dat += "<BR><b>Headshot(1:1):</b> <a href='byond://?_src_=prefs;preference=headshot;task=input'>Change</a>"

			dat += "<BR><b>NSFW Content:</b> <a href='byond://?_src_=prefs;preference=nsfw_content_preference'>[(nsfw_content_pref) ? "Enabled" : "Disabled"]</A>"
			if(nsfw_content_pref)
				if(length(flavor_text_nsfw) <= 110)
					dat += "<BR><b>Flavor Text (NSFW):</b> [flavor_text_nsfw] <a href='byond://?_src_=prefs;preference=flavor_text_nsfw;task=input'>Change</a>"
				else
					dat += "<BR><b>Flavor Text (NSFW):</b> [preview_text_nsfw]... <a href='byond://?_src_=prefs;preference=flavor_text_nsfw;task=input'>Change</a>"
				dat += "<BR><b>OOC Notes:</b> [ooc_notes] <a href='byond://?_src_=prefs;preference=ooc_notes;task=input'>Change</a>"

			dat += "<BR><b>Show flavor text while identity hidden:</b> <a href='byond://?_src_=prefs;preference=show_flavor_text_when_masked'>[(show_flavor_text_when_masked) ? "Enabled" : "Disabled"]</A>"

			// TFN EDIT ADDITION END
			dat += "<h2>[make_font_cool("EQUIP")]</h2>"

			dat += "<b>Underwear:</b><BR><a href ='byond://?_src_=prefs;preference=underwear;task=input'>[underwear]</a>"
//			dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_UNDERWEAR]'>[(randomise[RANDOM_UNDERWEAR]) ? "Lock" : "Unlock"]</A>"

			dat += "<br><b>Underwear Color:</b><BR><span style='border: 1px solid #161616; background-color: [underwear_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=underwear_color;task=input'>Change</a>"
//			dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_UNDERWEAR_COLOR]'>[(randomise[RANDOM_UNDERWEAR_COLOR]) ? "Lock" : "Unlock"]</A>"

			dat += "<BR><b>Undershirt:</b><BR><a href ='byond://?_src_=prefs;preference=undershirt;task=input'>[undershirt]</a>"
//			dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_UNDERSHIRT]'>[(randomise[RANDOM_UNDERSHIRT]) ? "Lock" : "Unlock"]</A>"


			dat += "<br><b>Socks:</b><BR><a href ='byond://?_src_=prefs;preference=socks;task=input'>[socks]</a>"
//			dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_SOCKS]'>[(randomise[RANDOM_SOCKS]) ? "Lock" : "Unlock"]</A>"


//			dat += "<br><b>Jumpsuit Style:</b><BR><a href ='byond://?_src_=prefs;preference=suit;task=input'>[jumpsuit_style]</a>"
//			dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_JUMPSUIT_STYLE]'>[(randomise[RANDOM_JUMPSUIT_STYLE]) ? "Lock" : "Unlock"]</A>"

			dat += "<br><b>Backpack:</b><BR><a href ='byond://?_src_=prefs;preference=bag;task=input'>[backpack]</a>"
//			dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_BACKPACK]'>[(randomise[RANDOM_BACKPACK]) ? "Lock" : "Unlock"]</A>"

			if(pref_species.name == "Vampire")
				dat += "<BR><b>Fame:</b><BR><a href ='byond://?_src_=prefs;preference=info_choose;task=input'>[info_known]</a>"

			dat += "<BR><BR><b>Relationships:</b><BR>"
			dat += "Have a Friend: <a href='byond://?_src_=prefs;preference=friend'>[friend == TRUE ? "Enabled" : "Disabled"]</A><BR>"
			dat += "What a Friend knows about me: [friend_text] <a href='byond://?_src_=prefs;preference=friend_text;task=input'>Change</a><BR>"
			dat += "<BR>"
			dat += "Have an Enemy: <a href='byond://?_src_=prefs;preference=enemy'>[enemy == TRUE ? "Enabled" : "Disabled"]</A><BR>"
			dat += "What an Enemy knows about me: [enemy_text] <a href='byond://?_src_=prefs;preference=enemy_text;task=input'>Change</a><BR>"
			dat += "<BR>"
			dat += "Have a Lover: <a href='byond://?_src_=prefs;preference=lover'>[lover == TRUE ? "Enabled" : "Disabled"]</A><BR>"
			dat += "What a Lover knows about me: [lover_text] <a href='byond://?_src_=prefs;preference=lover_text;task=input'>Change</a><BR>"

			if((HAS_FLESH in pref_species.species_traits) || (HAS_BONE in pref_species.species_traits))
				dat += "<BR><b>Temporal Scarring:</b><BR><a href='byond://?_src_=prefs;preference=persistent_scars'>[(persistent_scars) ? "Enabled" : "Disabled"]</A>"
				dat += "<a href='byond://?_src_=prefs;preference=clear_scars'>Clear scar slots</A>"

//			dat += "<br><b>Antagonist Items Spawn Location:</b><BR><a href ='byond://?_src_=prefs;preference=uplink_loc;task=input'>[uplink_spawn_loc]</a><BR></td>"
//			if (user.client.get_exp_living(TRUE) >= PLAYTIME_VETERAN)
//				dat += "<br><b>Don The Ultimate Gamer Cloak?:</b><BR><a href ='byond://?_src_=prefs;preference=playtime_reward_cloak'>[(playtime_reward_cloak) ? "Enabled" : "Disabled"]</a><BR></td>"
			var/use_skintones = pref_species.use_skintones
			if(use_skintones)

				dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>[make_font_cool("SKIN")]</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=s_tone;task=input'>[skin_tone]</a>"
//				dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_SKIN_TONE]'>[(randomise[RANDOM_SKIN_TONE]) ? "Lock" : "Unlock"]</A>"
				dat += "<br>"

			var/mutant_colors
			if((MUTCOLORS in pref_species.species_traits) || (MUTCOLORS_PARTSONLY in pref_species.species_traits))

				if(!use_skintones)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Mutant Color</h3>"

				dat += "<span style='border: 1px solid #161616; background-color: [features["mcolor"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=mutant_color;task=input'>Change</a><BR>"

				mutant_colors = TRUE

			if(istype(pref_species, /datum/species/ethereal)) //not the best thing to do tbf but I dont know whats better.

				if(!use_skintones)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Ethereal Color</h3>"

				dat += "<span style='border: 1px solid #161616; background-color: [features["ethcolor"]];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=color_ethereal;task=input'>Change</a><BR>"


			if((EYECOLOR in pref_species.species_traits) && !(NOEYESPRITES in pref_species.species_traits))

				if(!use_skintones && !mutant_colors)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>[make_font_cool("EYES")]</h3>"
				dat += "<span style='border: 1px solid #161616; background-color: [eye_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=eyes;task=input'>Change</a>"
//				dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_EYE_COLOR]'>[(randomise[RANDOM_EYE_COLOR]) ? "Lock" : "Unlock"]</A>"

				dat += "<br></td>"
			else if(use_skintones || mutant_colors)
				dat += "</td>"

			if(HAIR in pref_species.species_traits)

				dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>[make_font_cool("HAIR")]</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=hairstyle;task=input'>[hairstyle]</a>"
				dat += "<a href='byond://?_src_=prefs;preference=previous_hairstyle;task=input'>&lt;</a> <a href='byond://?_src_=prefs;preference=next_hairstyle;task=input'>&gt;</a>"
//				dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_HAIRSTYLE]'>[(randomise[RANDOM_HAIRSTYLE]) ? "Lock" : "Unlock"]</A>"

				dat += "<br><span style='border:1px solid #161616; background-color: [hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=hair;task=input'>Change</a>"
//				dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_HAIR_COLOR]'>[(randomise[RANDOM_HAIR_COLOR]) ? "Lock" : "Unlock"]</A>"

				dat += "<BR><h3>[make_font_cool("FACIAL")]</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=facial_hairstyle;task=input'>[facial_hairstyle]</a>"
				dat += "<a href='byond://?_src_=prefs;preference=previous_facehairstyle;task=input'>&lt;</a> <a href='byond://?_src_=prefs;preference=next_facehairstyle;task=input'>&gt;</a>"
//				dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_FACIAL_HAIRSTYLE]'>[(randomise[RANDOM_FACIAL_HAIRSTYLE]) ? "Lock" : "Unlock"]</A>"

				dat += "<br><span style='border: 1px solid #161616; background-color: [facial_hair_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=facial;task=input'>Change</a>"
//				dat += "<a href='byond://?_src_=prefs;preference=toggle_random;random_type=[RANDOM_FACIAL_HAIR_COLOR]'>[(randomise[RANDOM_FACIAL_HAIR_COLOR]) ? "Lock" : "Unlock"]</A>"
				dat += "<br></td>"

			//Mutant stuff
			var/mutant_category = 0

			if(pref_species.mutant_bodyparts["tail_lizard"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Tail</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=tail_lizard;task=input'>[features["tail_lizard"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["snout"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Snout</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=snout;task=input'>[features["snout"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["horns"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Horns</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=horns;task=input'>[features["horns"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["frills"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Frills</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=frills;task=input'>[features["frills"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["spines"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Spines</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=spines;task=input'>[features["spines"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["body_markings"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Body Markings</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=body_markings;task=input'>[features["body_markings"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["legs"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Legs</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=legs;task=input'>[features["legs"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["moth_wings"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Moth wings</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=moth_wings;task=input'>[features["moth_wings"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["moth_antennae"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Moth antennae</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=moth_antennae;task=input'>[features["moth_antennae"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["moth_markings"])
				if(!mutant_category)
					dat += APPEARANCE_CATEGORY_COLUMN

				dat += "<h3>Moth markings</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=moth_markings;task=input'>[features["moth_markings"]]</a><BR>"

				mutant_category++
				if(mutant_category >= MAX_MUTANT_ROWS)
					dat += "</td>"
					mutant_category = 0

			if(pref_species.mutant_bodyparts["tail_human"])
				if(pref_species.id != "kindred" && pref_species.id != "ghoul")
					if(!mutant_category)
						dat += APPEARANCE_CATEGORY_COLUMN

					dat += "<h3>Tail</h3>"

					dat += "<a href='byond://?_src_=prefs;preference=tail_human;task=input'>[features["tail_human"]]</a><BR>"

					mutant_category++
					if(mutant_category >= MAX_MUTANT_ROWS)
						dat += "</td>"
						mutant_category = 0

			if(pref_species.mutant_bodyparts["ears"])
				if(pref_species.id != "kindred" && pref_species.id != "ghoul")
					if(!mutant_category)
						dat += APPEARANCE_CATEGORY_COLUMN

					dat += "<h3>Ears</h3>"

					dat += "<a href='byond://?_src_=prefs;preference=ears;task=input'>[features["ears"]]</a><BR>"

					mutant_category++
					if(mutant_category >= MAX_MUTANT_ROWS)
						dat += "</td>"
						mutant_category = 0

			//Adds a thing to select which phobia because I can't be assed to put that in the quirks window
			if("Phobia" in all_quirks)
				dat += "<h3>Phobia</h3>"

				dat += "<a href='byond://?_src_=prefs;preference=phobia;task=input'>[phobia]</a><BR>"

			if(CONFIG_GET(flag/join_with_mutant_humans))

				if(pref_species.mutant_bodyparts["wings"] && GLOB.r_wings_list.len >1)
					if(!mutant_category)
						dat += APPEARANCE_CATEGORY_COLUMN

					dat += "<h3>Wings</h3>"

					dat += "<a href='byond://?_src_=prefs;preference=wings;task=input'>[features["wings"]]</a><BR>"

					mutant_category++
					if(mutant_category >= MAX_MUTANT_ROWS)
						dat += "</td>"
						mutant_category = 0

			if(mutant_category)
				dat += "</td>"
				mutant_category = 0
			dat += "</tr></table>"


		if (1) // Game Preferences
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>[make_font_cool("GENERAL")]</h2>"
			dat += "<b>UI Style:</b> <a href='byond://?_src_=prefs;task=input;preference=ui'>[UI_style]</a><br>"
			dat += "<b>tgui Window Mode:</b> <a href='byond://?_src_=prefs;preference=tgui_fancy'>[(tgui_fancy) ? "Fancy (default)" : "Compatible (slower)"]</a><br>"
			dat += "<b>Input Framework:</b> <a href='byond://?_src_=prefs;preference=tgui_input_mode'>[(tgui_input_mode) ? "tgui" : "BYOND"]</a><br>"
			dat += "<b>tgui Button Size:</b> <a href='byond://?_src_=prefs;preference=tgui_large_buttons'>[(tgui_large_buttons) ? "Large" : "Small"]</a><br>"
			dat += "<b>tgui Buttons Swapped:</b> <a href='byond://?_src_=prefs;preference=tgui_swapped_buttons'>[(tgui_swapped_buttons) ? "Yes" : "No"]</a><br>"
			dat += "<b>tgui Window Placement:</b> <a href='byond://?_src_=prefs;preference=tgui_lock'>[(tgui_lock) ? "Primary monitor" : "Free (default)"]</a><br>"
			dat += "<b>Show Runechat Chat Bubbles:</b> <a href='byond://?_src_=prefs;preference=chat_on_map'>[chat_on_map ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Runechat message char limit:</b> <a href='byond://?_src_=prefs;preference=max_chat_length;task=input'>[max_chat_length]</a><br>"
			dat += "<b>See Runechat for non-mobs:</b> <a href='byond://?_src_=prefs;preference=see_chat_non_mob'>[see_chat_non_mob ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>See Runechat emotes:</b> <a href='byond://?_src_=prefs;preference=see_rc_emotes'>[see_rc_emotes ? "Enabled" : "Disabled"]</a><br>"
			dat += "<br>"
			dat += "<b>Show Roll Results:</b> <a href='byond://?_src_=prefs;preference=roll_mode'>[(chat_toggles & CHAT_ROLL_INFO) ? "All Rolls" : "Frenzy Only"]</a><br>"
			dat += "<br>"
			dat += "<b>Action Buttons:</b> <a href='byond://?_src_=prefs;preference=action_buttons'>[(buttons_locked) ? "Locked In Place" : "Unlocked"]</a><br>"
			dat += "<b>Hotkey mode:</b> <a href='byond://?_src_=prefs;preference=hotkeys'>[(hotkeys) ? "Hotkeys" : "Default"]</a><br>"
			dat += "<br>"
			dat += "<b>PDA Color:</b> <span style='border:1px solid #161616; background-color: [pda_color];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=pda_color;task=input'>Change</a><BR>"
			dat += "<b>PDA Style:</b> <a href='byond://?_src_=prefs;task=input;preference=pda_style'>[pda_style]</a><br>"
			dat += "<br>"
			dat += "<b>Ghost Ears:</b> <a href='byond://?_src_=prefs;preference=ghost_ears'>[(chat_toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost Radio:</b> <a href='byond://?_src_=prefs;preference=ghost_radio'>[(chat_toggles & CHAT_GHOSTRADIO) ? "All Messages":"No Messages"]</a><br>"
			dat += "<b>Ghost Sight:</b> <a href='byond://?_src_=prefs;preference=ghost_sight'>[(chat_toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost Whispers:</b> <a href='byond://?_src_=prefs;preference=ghost_whispers'>[(chat_toggles & CHAT_GHOSTWHISPER) ? "All Speech" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost PDA:</b> <a href='byond://?_src_=prefs;preference=ghost_pda'>[(chat_toggles & CHAT_GHOSTPDA) ? "All Messages" : "Nearest Creatures"]</a><br>"
			dat += "<b>Ghost Law Changes:</b> <a href='byond://?_src_=prefs;preference=ghost_laws'>[(chat_toggles & CHAT_GHOSTLAWS) ? "All Law Changes" : "No Law Changes"]</a><br>"

			if(unlock_content)
				dat += "<b>Ghost Form:</b> <a href='byond://?_src_=prefs;task=input;preference=ghostform'>[ghost_form]</a><br>"
				dat += "<B>Ghost Orbit: </B> <a href='byond://?_src_=prefs;task=input;preference=ghostorbit'>[ghost_orbit]</a><br>"

			var/button_name = "If you see this something went wrong."
			switch(ghost_accs)
				if(GHOST_ACCS_FULL)
					button_name = GHOST_ACCS_FULL_NAME
				if(GHOST_ACCS_DIR)
					button_name = GHOST_ACCS_DIR_NAME
				if(GHOST_ACCS_NONE)
					button_name = GHOST_ACCS_NONE_NAME

			dat += "<b>Ghost Accessories:</b> <a href='byond://?_src_=prefs;task=input;preference=ghostaccs'>[button_name]</a><br>"

			switch(ghost_others)
				if(GHOST_OTHERS_THEIR_SETTING)
					button_name = GHOST_OTHERS_THEIR_SETTING_NAME
				if(GHOST_OTHERS_DEFAULT_SPRITE)
					button_name = GHOST_OTHERS_DEFAULT_SPRITE_NAME
				if(GHOST_OTHERS_SIMPLE)
					button_name = GHOST_OTHERS_SIMPLE_NAME

			dat += "<b>Ghosts of Others:</b> <a href='byond://?_src_=prefs;task=input;preference=ghostothers'>[button_name]</a><br>"
			dat += "<br>"

			dat += "<b>Broadcast Login/Logout:</b> <a href='byond://?_src_=prefs;preference=broadcast_login_logout'>[broadcast_login_logout ? "Broadcast" : "Silent"]</a><br>"
			dat += "<b>See Login/Logout Messages:</b> <a href='byond://?_src_=prefs;preference=hear_login_logout'>[(chat_toggles & CHAT_LOGIN_LOGOUT) ? "Allowed" : "Muted"]</a><br>"
			dat += "<br>"

			dat += "<b>Income Updates:</b> <a href='byond://?_src_=prefs;preference=income_pings'>[(chat_toggles & CHAT_BANKCARD) ? "Allowed" : "Muted"]</a><br>"
			dat += "<br>"

			dat += "<b>FPS:</b> <a href='byond://?_src_=prefs;preference=clientfps;task=input'>[clientfps]</a><br>"

			dat += "<b>Parallax (Fancy Space):</b> <a href='byond://?_src_=prefs;preference=parallaxdown' oncontextmenu='window.location.href=byond://?_src_=prefs;preference=parallaxup;return false;'>"
			switch (parallax)
				if (PARALLAX_LOW)
					dat += "Low"
				if (PARALLAX_MED)
					dat += "Medium"
				if (PARALLAX_INSANE)
					dat += "Insane"
				if (PARALLAX_DISABLE)
					dat += "Disabled"
				else
					dat += "High"
			dat += "</a><br>"
			dat += "<b>Use old discipline icons:</b> <a href='byond://?_src_=prefs;preference=old_discipline'>[old_discipline ? "Yes" : "No"]</a><br>"
			dat += "<b>Ambient Occlusion:</b> <a href='byond://?_src_=prefs;preference=ambientocclusion'>[ambientocclusion ? "Enabled" : "Disabled"]</a><br>"
			dat += "<b>Fit Viewport:</b> <a href='byond://?_src_=prefs;preference=auto_fit_viewport'>[auto_fit_viewport ? "Auto" : "Manual"]</a><br>"
			if (CONFIG_GET(string/default_view) != CONFIG_GET(string/default_view_square))
				dat += "<b>Widescreen:</b> <a href='byond://?_src_=prefs;preference=widescreenpref'>[widescreenpref ? "Enabled ([CONFIG_GET(string/default_view)])" : "Disabled ([CONFIG_GET(string/default_view_square)])"]</a><br>"

			button_name = pixel_size
			dat += "<b>Pixel Scaling:</b> <a href='byond://?_src_=prefs;preference=pixel_size'>[(button_name) ? "Pixel Perfect [button_name]x" : "Stretch to fit"]</a><br>"

			switch(scaling_method)
				if(SCALING_METHOD_DISTORT)
					button_name = "Nearest Neighbor"
				if(SCALING_METHOD_NORMAL)
					button_name = "Point Sampling"
				if(SCALING_METHOD_BLUR)
					button_name = "Bilinear"
			dat += "<b>Scaling Method:</b> <a href='byond://?_src_=prefs;preference=scaling_method'>[button_name]</a><br>"

			if (CONFIG_GET(flag/maprotation))
				var/p_map = preferred_map
				if (!p_map)
					p_map = "Default"
					if (config.defaultmap)
						p_map += " ([config.defaultmap.map_name])"
				else
					if (p_map in config.maplist)
						var/datum/map_config/VM = config.maplist[p_map]
						if (!VM)
							p_map += " (No longer exists)"
						else
							p_map = VM.map_name
					else
						p_map += " (No longer exists)"
				if(CONFIG_GET(flag/preference_map_voting))
					dat += "<b>Preferred Map:</b> <a href='byond://?_src_=prefs;preference=preferred_map;task=input'>[p_map]</a><br>"

		// TFN ADDITION START: loadout
		if(2) //Loadout
			if(path)
				var/savefile/S = new /savefile(path)
				if(S)
					dat += "<center>"
					var/name
					var/unspaced_slots = 0
					for(var/i=1, i<=max_save_slots, i++)
						unspaced_slots++
						if(unspaced_slots > 4)
							dat += "<br>"
							unspaced_slots = 0
						S.cd = "/character[i]"
						S["real_name"] >> name
						if(!name)
							name = "Character[i]"
						dat += "<a style='white-space:nowrap;' href='?_src_=prefs;preference=changeslot;num=[i];' [i == default_slot ? "class='linkOn'" : ""]>[name]</a> "
					dat += "</center>"
					dat += "<HR>"
			var/list/type_blacklist = list()
			var/list/slot_blacklist = list()
			if(equipped_gear && length(equipped_gear))
				for(var/i = 1, i <= length(equipped_gear), i++)
					var/datum/gear/G = GLOB.gear_datums[equipped_gear[i]]
					if(G)
						if((G.subtype_path in type_blacklist) || (G.slot in slot_blacklist))
							continue
						type_blacklist += G.subtype_path
						slot_blacklist += G.slot
					else
						equipped_gear.Cut(i,i+1)

			dat += "<table align='center' width='100%'>"
			dat += "<tr><td colspan=4><center><b>Experience: [player_experience]. Current loadout usage: [length(equipped_gear)]/[CONFIG_GET(number/max_loadout_items)].</b><br>\[<a href='?_src_=prefs;preference=gear;clear_loadout=1'>Clear Loadout</a>\] | \[<a href='?_src_=prefs;preference=gear;toggle_loadout=1'>Toggle Loadout</a>\]</center></td></tr>"
			dat += "<tr><td colspan=4><center><b>"

			var/firstcat = 1
			for(var/category in GLOB.loadout_categories)
				if(firstcat)
					firstcat = 0
				else
					dat += " |"
				if(category == gear_tab)
					dat += " <span class='linkOff'>[category]</span> "
				else
					dat += " <a href='?_src_=prefs;preference=gear;select_category=[category]'>[category]</a> "
			dat += "</b></center></td></tr>"

			var/datum/loadout_category/LC = GLOB.loadout_categories[gear_tab]
			dat += "<tr><td colspan=4><hr></td></tr>"
			dat += "<tr><td colspan=4><b><center>[LC.category]</center></b></td></tr>"
			dat += "<tr><td colspan=4><hr></td></tr>"

			dat += "<tr><td colspan=4><hr></td></tr>"
			dat += "<tr><td><b>Name</b></td>"
			dat += "<td><b>Cost</b></td>"
			dat += "<td><b>Restricted Jobs</b></td>"
			dat += "<td><b>Description</b></td>"
			dat += "<tr><td colspan=4><hr></td></tr>"
			for(var/gear_name in LC.gear)
				var/datum/gear/G = LC.gear[gear_name]
				var/ticked = (G.display_name in equipped_gear)

				dat += "<tr style='vertical-align:top;'><td width=35%>[G.display_name] "
				if(G.display_name in purchased_gear)
					dat += "<a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?_src_=prefs;preference=gear;toggle_gear=[G.display_name]'>" + (ticked ? "Unequip" : "Equip") + "</a></td>"
				else
					dat += "<a style='white-space:normal;' href='?_src_=prefs;preference=gear;purchase_gear=[G.display_name]'>Purchase</a>"
					if(G.sort_category != "General")
						dat += "<a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?_src_=prefs;preference=gear;toggle_gear=[G.display_name]'>" + (ticked ? "Stop Preview" : "Preview") + "</a></td>"
				dat += "<td width = 5% style='vertical-align:top;'>[G.cost]</td><td>"

				if(G.allowed_roles)
					dat += "<font size=2>"
					var/list/allowedroles = list()
					for(var/role in G.allowed_roles)
						allowedroles += role
					dat += english_list(allowedroles, null, ", ")
					dat += "</font>"
				dat += "</td><td><font size=2><i>[G.description]</i></font></td></tr>"
			dat += "</table>"
		// TFN ADDITION END: loadout

		if(3) //OOC Preferences
			dat += "<table><tr><td width='340px' height='300px' valign='top'>"
			dat += "<h2>[make_font_cool("OOC")]</h2>"
			dat += "<b>Window Flashing:</b> <a href='byond://?_src_=prefs;preference=winflash'>[(windowflashing) ? "Enabled":"Disabled"]</a><br>"
			dat += "<br>"
			dat += "<b>Play Admin MIDIs:</b> <a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "Enabled":"Disabled"]</a><br>"
			dat += "<b>Play Lobby Music:</b> <a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "Enabled":"Disabled"]</a><br>"
			dat += "<b>Play End of Round Sounds:</b> <a href='?_src_=prefs;preference=endofround_sounds'>[(toggles & SOUND_ENDOFROUND) ? "Enabled":"Disabled"]</a><br>"
			dat += "<b>Play Combat Mode Sounds:</b> <a href='?_src_=prefs;preference=combat_mode_sound'>[(toggles & SOUND_COMBATMODE) ? "Enabled":"Disabled"]</a><br>"
			dat += "<b>See Pull Requests:</b> <a href='?_src_=prefs;preference=pull_requests'>[(chat_toggles & CHAT_PULLR) ? "Enabled":"Disabled"]</a><br>"
			dat += "<br>"


			if(user.client)
				if(unlock_content)
					dat += "<b>BYOND Membership Publicity:</b> <a href='byond://?_src_=prefs;preference=publicity'>[(toggles & MEMBER_PUBLIC) ? "Public" : "Hidden"]</a><br>"

				if(unlock_content || check_rights_for(user.client, R_ADMIN))
					dat += "<b>OOC Color:</b> <span style='border: 1px solid #161616; background-color: [ooccolor ? ooccolor : GLOB.normal_ooc_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=ooccolor;task=input'>Change</a><br>"
				if(hearted_until)
					dat += "<a href='byond://?_src_=prefs;preference=clear_heart'>Clear OOC Commend Heart</a><br>"

			dat += "</td>"

			if(user.client.holder)
				dat +="<td width='300px' height='300px' valign='top'>"

				dat += "<h2>[make_font_cool("ADMIN")]</h2>"

				dat += "<b>Adminhelp Sounds:</b> <a href='byond://?_src_=prefs;preference=hear_adminhelps'>[(toggles & SOUND_ADMINHELP)?"Enabled":"Disabled"]</a><br>"
				dat += "<b>Prayer Sounds:</b> <a href = 'byond://?_src_=prefs;preference=hear_prayers'>[(toggles & SOUND_PRAYERS)?"Enabled":"Disabled"]</a><br>"
				dat += "<b>Announce Login:</b> <a href='byond://?_src_=prefs;preference=announce_login'>[(toggles & ANNOUNCE_LOGIN)?"Enabled":"Disabled"]</a><br>"
				dat += "<br>"
				dat += "<b>Combo HUD Lighting:</b> <a href = 'byond://?_src_=prefs;preference=combohud_lighting'>[(toggles & COMBOHUD_LIGHTING)?"Full-bright":"No Change"]</a><br>"
				dat += "<br>"
				dat += "<b>Hide Dead Chat:</b> <a href = 'byond://?_src_=prefs;preference=toggle_dead_chat'>[(chat_toggles & CHAT_DEAD)?"Shown":"Hidden"]</a><br>"
				dat += "<b>Hide Radio Messages:</b> <a href = 'byond://?_src_=prefs;preference=toggle_radio_chatter'>[(chat_toggles & CHAT_RADIO)?"Shown":"Hidden"]</a><br>"
				dat += "<b>Hide Prayers:</b> <a href = 'byond://?_src_=prefs;preference=toggle_prayers'>[(chat_toggles & CHAT_PRAYER)?"Shown":"Hidden"]</a><br>"
				dat += "<b>Ignore Being Summoned as Cult Ghost:</b> <a href = 'byond://?_src_=prefs;preference=toggle_ignore_cult_ghost'>[(toggles & ADMIN_IGNORE_CULT_GHOST)?"Don't Allow Being Summoned":"Allow Being Summoned"]</a><br>"
				if(CONFIG_GET(flag/allow_admin_asaycolor))
					dat += "<br>"
					dat += "<b>ASAY Color:</b> <span style='border: 1px solid #161616; background-color: [asaycolor ? asaycolor : "#FF4500"];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=asaycolor;task=input'>Change</a><br>"

				//deadmin
				dat += "<h2>[make_font_cool("DEADMIN")]</h2>"
				var/timegate = CONFIG_GET(number/auto_deadmin_timegate)
				if(timegate)
					dat += "<b>Noted roles will automatically deadmin during the first [FLOOR(timegate / 600, 1)] minutes of the round, and will defer to individual preferences after.</b><br>"

				if(CONFIG_GET(flag/auto_deadmin_players) && !timegate)
					dat += "<b>Always Deadmin:</b> FORCED</a><br>"
				else
					dat += "<b>Always Deadmin:</b> [timegate ? "(Time Locked) " : ""]<a href = 'byond://?_src_=prefs;preference=toggle_deadmin_always'>[(toggles & DEADMIN_ALWAYS)?"Enabled":"Disabled"]</a><br>"
					if(!(toggles & DEADMIN_ALWAYS))
						dat += "<br>"
						if(!CONFIG_GET(flag/auto_deadmin_antagonists) || (CONFIG_GET(flag/auto_deadmin_antagonists) && !timegate))
							dat += "<b>As Antag:</b> [timegate ? "(Time Locked) " : ""]<a href = 'byond://?_src_=prefs;preference=toggle_deadmin_antag'>[(toggles & DEADMIN_ANTAGONIST)?"Deadmin":"Keep Admin"]</a><br>"
						else
							dat += "<b>As Antag:</b> FORCED<br>"

						if(!CONFIG_GET(flag/auto_deadmin_heads) || (CONFIG_GET(flag/auto_deadmin_heads) && !timegate))
							dat += "<b>As Command:</b> [timegate ? "(Time Locked) " : ""]<a href = 'byond://?_src_=prefs;preference=toggle_deadmin_head'>[(toggles & DEADMIN_POSITION_HEAD)?"Deadmin":"Keep Admin"]</a><br>"
						else
							dat += "<b>As Command:</b> FORCED<br>"

						if(!CONFIG_GET(flag/auto_deadmin_security) || (CONFIG_GET(flag/auto_deadmin_security) && !timegate))
							dat += "<b>As Security:</b> [timegate ? "(Time Locked) " : ""]<a href = 'byond://?_src_=prefs;preference=toggle_deadmin_security'>[(toggles & DEADMIN_POSITION_SECURITY)?"Deadmin":"Keep Admin"]</a><br>"
						else
							dat += "<b>As Security:</b> FORCED<br>"

						if(!CONFIG_GET(flag/auto_deadmin_silicons) || (CONFIG_GET(flag/auto_deadmin_silicons) && !timegate))
							dat += "<b>As Silicon:</b> [timegate ? "(Time Locked) " : ""]<a href = 'byond://?_src_=prefs;preference=toggle_deadmin_silicon'>[(toggles & DEADMIN_POSITION_SILICON)?"Deadmin":"Keep Admin"]</a><br>"
						else
							dat += "<b>As Silicon:</b> FORCED<br>"

				dat += "</td>"
			dat += "</tr></table>"
		if(4) // Custom keybindings
			// Create an inverted list of keybindings -> key
			var/list/user_binds = list()
			for (var/key in key_bindings)
				for(var/kb_name in key_bindings[key])
					user_binds[kb_name] += list(key)

			var/list/kb_categories = list()
			// Group keybinds by category
			for (var/name in GLOB.keybindings_by_name)
				var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
				kb_categories[kb.category] += list(kb)

			dat += "<style>label { display: inline-block; width: 200px; }</style><body>"

			for (var/category in kb_categories)
				dat += "<h3>[category]</h3>"
				for (var/i in kb_categories[category])
					var/datum/keybinding/kb = i
					if(!length(user_binds[kb.name]) || user_binds[kb.name][1] == "Unbound")
						dat += "<label>[kb.full_name]</label> <a href ='byond://?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=["Unbound"]'>Unbound</a>"
						var/list/default_keys = hotkeys ? kb.hotkey_keys : kb.classic_keys
						if(LAZYLEN(default_keys))
							dat += "| Default: [default_keys.Join(", ")]"
						dat += "<br>"
					else
						var/bound_key = user_binds[kb.name][1]
						dat += "<label>[kb.full_name]</label> <a href ='byond://?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						for(var/bound_key_index in 2 to length(user_binds[kb.name]))
							bound_key = user_binds[kb.name][bound_key_index]
							dat += " | <a href ='byond://?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name];old_key=[bound_key]'>[bound_key]</a>"
						if(length(user_binds[kb.name]) < MAX_KEYS_PER_KEYBIND)
							dat += "| <a href ='byond://?_src_=prefs;preference=keybindings_capture;keybinding=[kb.name]'>Add Secondary</a>"
						var/list/default_keys = hotkeys ? kb.classic_keys : kb.hotkey_keys
						if(LAZYLEN(default_keys))
							dat += "| Default: [default_keys.Join(", ")]"
						dat += "<br>"

			dat += "<br><br>"
			dat += "<a href ='byond://?_src_=prefs;preference=keybindings_reset'>\[Reset to default\]</a>"
			dat += "</body>"
	dat += "<hr><center>"

	if(slotlocked)
		dat += "Your character is saved. You can't change name and appearance, but your progress will be saved.<br>"
	if(!IsGuestKey(user.key) && !slotlocked)
		dat += "<a href='byond://?_src_=prefs;preference=load'>Undo</a> "
		dat += "<a href='byond://?_src_=prefs;preference=save'>Save Character</a> "
//	dat += "<a href='byond://?_src_=prefs;preference=save_pref'>Save Preferences</a> "

	if(istype(user, /mob/dead/new_player))
		dat += "<a href='byond://?_src_=prefs;preference=reset_all'>Reset Setup</a>"
	dat += "</center>"

	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "<div align='center'>[make_font_cool("CHARACTER")]</div>", 640, 770)
	popup.set_content(dat.Join())
	popup.open(FALSE)
	onclose(user, "preferences_window", src)

//A proc that creates the score circles based on attribute and the additional bonus for the attribute
//
/datum/preferences/proc/build_attribute_score(attribute, bonus_number, price, variable_name)
	var/dat
	for(var/a in 1 to attribute)
		dat += "•"
	for(var/b in 1 to bonus_number)
		dat += "•"
	var/leftover_circles = 5 - attribute //5 is the default number of blank circles
	for(var/c in 1 to leftover_circles)
		dat += "o"
	var/real_price = attribute ? (attribute*price) : price //In case we have an attribute of 0, we don't multiply by 0
	if((player_experience >= real_price) && (attribute < ATTRIBUTE_BASE_LIMIT))
		dat += "<a href='byond://?_src_=prefs;preference=[variable_name];task=input'>Increase ([real_price])</a>"
	dat += "<br>"
	return dat

#undef APPEARANCE_CATEGORY_COLUMN
#undef MAX_MUTANT_ROWS

/datum/preferences/proc/CaptureKeybinding(mob/user, datum/keybinding/kb, old_key)
	var/HTML = {"
	<div id='focus' style="outline: 0;" tabindex=0>Keybinding: [kb.full_name]<br>[kb.description]<br><br><b>Press any key to change<br>Press ESC to clear</b></div>
	<script>
	var deedDone = false;
	document.onkeyup = function(e) {
		if(deedDone){ return; }
		var alt = e.altKey ? 1 : 0;
		var ctrl = e.ctrlKey ? 1 : 0;
		var shift = e.shiftKey ? 1 : 0;
		var numpad = (95 < e.keyCode && e.keyCode < 112) ? 1 : 0;
		var escPressed = e.keyCode == 27 ? 1 : 0;
		var url = 'byond://?_src_=prefs;preference=keybindings_set;keybinding=[kb.name];old_key=[old_key];clear_key='+escPressed+';key='+e.key+';alt='+alt+';ctrl='+ctrl+';shift='+shift+';numpad='+numpad+';key_code='+e.keyCode;
		window.location=url;
		deedDone = true;
	}
	document.getElementById('focus').focus();
	</script>
	"}
	winshow(user, "capturekeypress", TRUE)
	var/datum/browser/popup = new(user, "capturekeypress", "<div align='center'>Keybindings</div>", 350, 300)
	popup.set_content(HTML)
	popup.open(FALSE)
	onclose(user, "capturekeypress", src)

/datum/preferences/proc/return_job_color(mob/user, datum/job/job, rank)
	var/bypass = FALSE
	if (check_rights_for(user.client, R_ADMIN))
		bypass = TRUE
	if(is_banned_from(user.ckey, rank))
		return "<font color=red>[rank]</font></td><td><a href='byond://?_src_=prefs;bancheck=[rank]'> BANNED</a></td></tr>"
	var/required_playtime_remaining = job.required_playtime_remaining(user.client)
	if(required_playtime_remaining && !bypass)
		return "<font color=#290204>[rank]</font></td><td><font color=#290204> \[ [get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()] \]</font></td></tr>"
	if(!job.player_old_enough(user.client) && !bypass)
		var/available_in_days = job.available_in_days(user.client)
		return "<font color=#290204>[rank]</font></td><td><font color=#290204> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
	if((generation > job.minimal_generation) && !bypass)
		return "<font color=#290204>[rank]</font></td><td><font color=#290204> \[FROM [job.minimal_generation] GENERATION AND OLDER\]</font></td></tr>"
	if((masquerade < job.minimal_masquerade) && !bypass)
		return "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[job.minimal_masquerade] MASQUERADE POINTS REQUIRED\]</font></td></tr>"
	if(!job.allowed_species.Find(pref_species.name) && !bypass)
		return "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[pref_species.name] RESTRICTED\]</font></td></tr>"
	if(pref_species.name == "Vampire")
		var/alloww = FALSE
		for(var/i in job.allowed_bloodlines)
			if(i == clan.name)
				alloww = TRUE
		if(!alloww && !bypass)
			return "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[clan.name] RESTRICTED\]</font></td></tr>"
	if((job_preferences[SSjob.overflow_role] == JP_LOW) && (rank != SSjob.overflow_role) && !is_banned_from(user.ckey, SSjob.overflow_role))
		return "<font color=orange>[rank]</font></td>"

	return "<font color=black>[rank]</font></td>"

/datum/preferences/proc/SetChoices(mob/user, limit = 17, list/splitJobs = list("Chief Engineer"), widthPerColumn = 295, height = 620)
	if(!SSjob)
		return

	//limit - The amount of jobs allowed per column. Defaults to 17 to make it look nice.
	//splitJobs - Allows you split the table by job. You can make different tables for each department by including their heads. Defaults to CE to make it look nice.
	//widthPerColumn - Screen's width for every column.
	//height - Screen's height.

	var/width = widthPerColumn

	var/HTML = "<center>"
	if(SSjob.occupations.len <= 0)
		HTML += "The job SSticker is not yet finished creating jobs, please try again later"
		HTML += "<center><a href='byond://?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.

	else
		HTML += "<b>Choose occupation chances</b><br>"
		HTML += "<div align='center'>Left-click to raise an occupation preference, right-click to lower it.<br></div>"
		HTML += "<center><a href='byond://?_src_=prefs;preference=job;task=close'>Done</a></center><br>" // Easier to press up here.
		HTML += "<script type='text/javascript'>function setJobPrefRedirect(level, rank) { window.location.href='byond://?_src_=prefs;preference=job;task=setJobLevel;level=' + level + ';text=' + encodeURIComponent(rank); return false; }</script>"
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more colomns.
		HTML += "<table width='100%' cellpadding='1' cellspacing='0'>"
		var/index = -1

		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
		var/datum/job/lastJob

		var/bypass = FALSE
		if (check_rights_for(user.client, R_ADMIN))
			bypass = TRUE

		for(var/datum/job/job in sort_list(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc)))

			index += 1
			if((index >= limit) || (job.title in splitJobs))
				width += widthPerColumn
				if((index < limit) && (lastJob != null))
					//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
					//the last job's selection color. Creating a rather nice effect.
					for(var/i = 0, i < (limit - index), i += 1)
						HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"
				HTML += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
				index = 0

			HTML += "<tr bgcolor='[job.selection_color]'><td width='60%' align='right'>"
			var/rank = job.title
			// TFN EDIT START: alt job titles
			var/displayed_rank = rank
			if(length(job.alt_titles) && (rank in alt_titles_preferences))
				displayed_rank = alt_titles_preferences[rank]
			// TFN EDIT END
			lastJob = job
			if(is_banned_from(user.ckey, rank))
				HTML += "<font color=red>[rank]</font></td><td><a href='byond://?_src_=prefs;bancheck=[rank]'> BANNED</a></td></tr>"
				continue
			// Jobs can only be whitelisted under Trusted Player, so that's all it checks for.
			if(job.whitelisted)
				if(!SSwhitelists.is_whitelisted(user.ckey, TRUSTED_PLAYER))
					HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> WHITELISTED</font></td></tr>"
					continue
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			//<font color=red>text</font> (Zamenil potomu chto slishkom rezhet glaza
			if(required_playtime_remaining && !bypass)
				HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[ [get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()] \]</font></td></tr>"
				continue
			if(!job.player_old_enough(user.client) && !bypass)
				var/available_in_days = job.available_in_days(user.client)
				HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[IN [(available_in_days)] DAYS\]</font></td></tr>"
				continue
			if(!bypass && !job.is_character_old_enough(user.client.prefs.total_age))
				HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[AT LEAST [job.minimum_character_age] YEARS OLD\]</font></td></tr>"
				continue
			if(!bypass && !job.is_vampire_old_enough(user.client.prefs.age, user.client.prefs.total_age))
				HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[AT LEAST [job.minimum_vampire_age] VAMPIRE YEARS OLD\]</font></td></tr>"
				continue
			if((generation > job.minimal_generation) && !bypass)
				HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[FROM [job.minimal_generation] GENERATION AND OLDER\]</font></td></tr>"
				continue
			if((masquerade < job.minimal_masquerade) && !bypass)
				HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[job.minimal_masquerade] MASQUERADE POINTS REQUIRED\]</font></td></tr>"
				continue
			if(!job.allowed_species.Find(pref_species.name) && !bypass)
				HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[pref_species.name] RESTRICTED\]</font></td></tr>"
				continue
			if(pref_species.name == "Vampire")
				if(clan)
					var/alloww = FALSE
					for(var/i in job.allowed_bloodlines)
						if(i == clan.name)
							alloww = TRUE
					if(!alloww && !bypass)
						HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[clan.name] RESTRICTED\]</font></td></tr>"
						continue
			if(pref_species.name == "Werewolf")
				if(tribe)
					var/alloww = FALSE
					if(job.allowed_tribes.len)
						for(var/i in job.allowed_tribes)
							if(i == tribe.name)
								alloww = TRUE
					else
						alloww = TRUE

					if(!alloww && !bypass)
						HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[tribe.name] RESTRICTED\]</font></td></tr>"
						continue
				if(auspice)
					var/alloww = FALSE
					for(var/i in job.allowed_auspice)
						if(i == auspice.name)
							alloww = TRUE
					if(!alloww && !bypass)
						HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[auspice.name] RESTRICTED\]</font></td></tr>"
						continue
				var/renownlowed = TRUE
				if(job.minimal_renownrank)
					if((renownrank < job.minimal_renownrank) && !bypass)
						renownlowed = FALSE
				if(!renownlowed && !bypass)
					HTML += "<font color=#290204>[rank]</font></td><td><font color=#290204> \[[job.minimal_renownrank] RENOWN RANK REQUIRED\]</font></td></tr>"
					continue
			if((job_preferences[SSjob.overflow_role] == JP_LOW) && (rank != SSjob.overflow_role) && !is_banned_from(user.ckey, SSjob.overflow_role))
				HTML += "<font color=orange>[rank]</font></td><td></td></tr>"
				continue
			// TFN EDIT START: alt job titles
			var/rank_title_line = "[displayed_rank]"
			if(length(job.alt_titles) && (rank in GLOB.leader_positions))//Bold head jobs
				rank_title_line = "<b><a href='byond://?_src_=prefs;preference=job;task=alt_title;job_title=[job.title]'>[rank_title_line]</a></b>"
			else if(length(job.alt_titles))
				rank_title_line = "<a href='byond://?_src_=prefs;preference=job;task=alt_title;job_title=[job.title]'>[rank_title_line]</a>"
			else
				rank_title_line = "<span class='dark'>[rank]</span>"
			HTML += rank_title_line
			// TFN EDIT END

			HTML += "</td><td width='40%'>"

			var/prefLevelLabel = "ERROR"
			var/prefLevelColor = "pink"
			var/prefUpperLevel = -1 // level to assign on left click
			var/prefLowerLevel = -1 // level to assign on right click

			switch(job_preferences[job.title])
				if(JP_HIGH)
					prefLevelLabel = "High"
					prefLevelColor = "slateblue"
					prefUpperLevel = 4
					prefLowerLevel = 2
				if(JP_MEDIUM)
					prefLevelLabel = "Medium"
					prefLevelColor = "green"
					prefUpperLevel = 1
					prefLowerLevel = 3
				if(JP_LOW)
					prefLevelLabel = "Low"
					prefLevelColor = "orange"
					prefUpperLevel = 2
					prefLowerLevel = 4
				else
					prefLevelLabel = "NEVER"
					prefLevelColor = "red"
					prefUpperLevel = 3
					prefLowerLevel = 1

			HTML += "<a class='white' href='byond://?_src_=prefs;preference=job;task=setJobLevel;level=[prefUpperLevel];text=[rank]' oncontextmenu='javascript:return setJobPrefRedirect([prefLowerLevel], \"[rank]\");'>"

			if(rank == SSjob.overflow_role)//Overflow is special
				if(job_preferences[SSjob.overflow_role] == JP_LOW)
					HTML += "<font color=green>Yes</font>"
				else
					HTML += "<font color=red>No</font>"
				HTML += "</a></td></tr>"
				continue

			HTML += "<font color=[prefLevelColor]>[prefLevelLabel]</font>"
			HTML += "</a></td></tr>"

		for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
			HTML += "<tr bgcolor='[lastJob.selection_color]'><td width='60%' align='right'>&nbsp</td><td>&nbsp</td></tr>"

		HTML += "</td'></tr></table>"
		HTML += "</center></table>"

		var/message = "Be an [SSjob.overflow_role] if preferences unavailable"
		if(joblessrole == BERANDOMJOB)
			message = "Get random job if preferences unavailable"
		else if(joblessrole == RETURNTOLOBBY)
			message = "Return to lobby if preferences unavailable"
		HTML += "<center><br><a href='byond://?_src_=prefs;preference=job;task=random'>[message]</a></center>"
		HTML += "<center><a href='byond://?_src_=prefs;preference=job;task=reset'>Reset Preferences</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Occupation Preferences</div>", width, height)
	popup.set_window_options("can_close=0")
	popup.set_content(HTML)
	popup.open(FALSE)

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return FALSE

	if (level == JP_HIGH) // to high
		//Set all other high to medium
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM
				//technically break here

	job_preferences[job.title] = level
	return TRUE

/datum/preferences/proc/UpdateJobPreference(mob/user, role, desiredLvl)
	if(!SSjob || SSjob.occupations.len <= 0)
		return
	var/datum/job/job = SSjob.GetJob(role)

	if(!job)
		user << browse(null, "window=mob_occupation")
		ShowChoices(user)
		return

	if (!isnum(desiredLvl))
		to_chat(user, "<span class='danger'>UpdateJobPreference - desired level was not a number. Please notify coders!</span>")
		ShowChoices(user)
		return

	var/jpval = null
	switch(desiredLvl)
		if(3)
			jpval = JP_LOW
		if(2)
			jpval = JP_MEDIUM
		if(1)
			jpval = JP_HIGH

	if(role == SSjob.overflow_role)
		if(job_preferences[job.title] == JP_LOW)
			jpval = null
		else
			jpval = JP_LOW

	SetJobPreferenceLevel(job, jpval)
	SetChoices(user)

	return 1


/datum/preferences/proc/ResetJobs()
	job_preferences = list()

/datum/preferences/proc/SetQuirks(mob/user)
	if(!SSquirks)
		to_chat(user, "<span class='danger'>The quirk subsystem is still initializing! Try again in a minute.</span>")
		return

	if(slotlocked)
		return

	var/list/dat = list()
	if(!SSquirks.quirks.len)
		dat += "The quirk subsystem hasn't finished initializing, please hold..."
		dat += "<center><a href='byond://?_src_=prefs;preference=trait;task=close'>Done</a></center><br>"
	else
		dat += "<center><b>Choose quirk setup</b></center><br>"
		dat += "<div align='center'>Left-click to add or remove quirks. You need negative quirks to have positive ones.<br>\
		Quirks are applied at roundstart and cannot normally be removed.</div>"
		dat += "<center><a href='byond://?_src_=prefs;preference=trait;task=close'>Done</a></center>"
		dat += "<hr>"
		dat += "<center><b>Current quirks:</b> [all_quirks.len ? all_quirks.Join(", ") : "None"]</center>"
		dat += "<center>[GetPositiveQuirkCount()] / [MAX_QUIRKS] max positive quirks<br>\
		<b>Quirk balance remaining:</b> [GetQuirkBalance()]</center><br>"
		for(var/V in SSquirks.quirks)
			var/datum/quirk/T = SSquirks.quirks[V]
			var/quirk_name = initial(T.name)
			var/has_quirk
			var/quirk_cost = initial(T.value) * -1
			var/lock_reason = "This trait is unavailable."
			var/quirk_conflict = FALSE
			for(var/_V in all_quirks)
				if(_V == quirk_name)
					has_quirk = TRUE
			if(initial(T.mood_quirk) && CONFIG_GET(flag/disable_human_mood))
				lock_reason = "Mood is disabled."
				quirk_conflict = TRUE
			if(has_quirk)
				if(quirk_conflict)
					all_quirks -= quirk_name
					has_quirk = FALSE
				else
					quirk_cost *= -1 //invert it back, since we'd be regaining this amount
			if(quirk_cost > 0)
				quirk_cost = "+[quirk_cost]"
			var/font_color = "#AAAAFF"
			if(initial(T.value) != 0)
				font_color = initial(T.value) > 0 ? "#AAFFAA" : "#FFAAAA"

			if(!initial(T.mood_quirk))
				var/datum/quirk/Q = new T()

				if(length(Q.allowed_species))
					var/species_restricted = TRUE
					for(var/i in Q.allowed_species)
						if(i == pref_species.name)
							species_restricted = FALSE
					if(species_restricted)
						lock_reason = "[pref_species.name] restricted."
						quirk_conflict = TRUE
				if(Q.excluded_clans.len && "Vampire" == pref_species.name)
					var/clan_restricted = FALSE
					for(var/i in Q.excluded_clans)
						if(i == clan.name)
							clan_restricted = TRUE
					if(clan_restricted)
						lock_reason = "[clan.name] restricted."
						quirk_conflict = TRUE
				if(Q.allowed_tribes.len && "Werewolf" == pref_species.name)
					var/tribe_restricted = TRUE
					for(var/i in Q.allowed_tribes)
						if(i == tribe.name)
							tribe_restricted = FALSE
					if(tribe_restricted)
						lock_reason = "[tribe.name] restricted."
						quirk_conflict = TRUE
				qdel(Q)

			if(quirk_conflict && lock_reason != "Mood is disabled.")
				dat += "<font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)] \
				<font color='red'><b>LOCKED: [lock_reason]</b></font><br>"
			else if(lock_reason != "Mood is disabled.")
				if(has_quirk)
					dat += "<a href='byond://?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'>[has_quirk ? "Remove" : "Take"] ([quirk_cost] pts.)</a> \
					<b><font color='[font_color]'>[quirk_name]</font></b> - [initial(T.desc)]<br>"
				else
					dat += "<a href='byond://?_src_=prefs;preference=trait;task=update;trait=[quirk_name]'>[has_quirk ? "Remove" : "Take"] ([quirk_cost] pts.)</a> \
					<font color='[font_color]'>[quirk_name]</font> - [initial(T.desc)]<br>"
		dat += "<br><center><a href='byond://?_src_=prefs;preference=trait;task=reset'>Reset Quirks</a></center>"

	var/datum/browser/popup = new(user, "mob_occupation", "<div align='center'>Quirk Preferences</div>", 900, 600) //no reason not to reuse the occupation window, as it's cleaner that way
	popup.set_window_options("can_close=0")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/GetQuirkBalance()
	var/bal = 0
	bal = 3
	for(var/V in all_quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		bal -= initial(T.value)
	return bal

/datum/preferences/proc/GetPositiveQuirkCount()
	. = 0
	for(var/q in all_quirks)
		if(SSquirks.quirk_points[q] > 0)
			.++

/datum/preferences/proc/validate_quirks()
	if(GetQuirkBalance() < 0)
		all_quirks = list()

/datum/preferences/Topic(href, href_list, hsrc)			//yeah, gotta do this I guess..
	. = ..()
	if(href_list["close"])
		var/client/C = usr.client
		if(C)
			C.clear_character_previews()

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(href_list["bancheck"])
		var/list/ban_details = is_banned_from_with_details(user.ckey, user.client.address, user.client.computer_id, href_list["bancheck"])
		var/admin = FALSE
		if(GLOB.admin_datums[user.ckey] || GLOB.deadmins[user.ckey])
			admin = TRUE
		for(var/i in ban_details)
			if(admin && !text2num(i["applies_to_admins"]))
				continue
			ban_details = i
			break //we only want to get the most recent ban's details
		if(ban_details?.len)
			var/expires = "This is a permanent ban."
			if(ban_details["expiration_time"])
				expires = " The ban is for [DisplayTimeText(text2num(ban_details["duration"]) MINUTES)] and expires on [ban_details["expiration_time"]] (server time)."
			to_chat(user, "<span class='danger'>You, or another user of this computer or connection ([ban_details["key"]]) is banned from playing [href_list["bancheck"]].<br>The ban reason is: [ban_details["reason"]]<br>This ban (BanID #[ban_details["id"]]) was applied by [ban_details["admin_key"]] on [ban_details["bantime"]] during round ID [ban_details["round_id"]].<br>[expires]</span>")
			return
	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				switch(joblessrole)
					if(RETURNTOLOBBY)
						if(is_banned_from(user.ckey, SSjob.overflow_role))
							joblessrole = BERANDOMJOB
						else
							joblessrole = BEOVERFLOW
					if(BEOVERFLOW)
						joblessrole = BERANDOMJOB
					if(BERANDOMJOB)
						joblessrole = RETURNTOLOBBY
				SetChoices(user)
			// TFN EDIT START: alt job titles
			if("alt_title")
				var/job_title = href_list["job_title"]
				var/titles_list = list(job_title)
				var/datum/job/J = SSjob.GetJob(job_title)
				for(var/alternative_titles in J.alt_titles)
					titles_list += alternative_titles
				var/chosen_title
				chosen_title = tgui_input_list(user, "Choose your job's title:", "Job Preference", sort_list(titles_list))
				if(chosen_title)
					if(chosen_title == job_title)
						if(alt_titles_preferences[job_title])
							alt_titles_preferences.Remove(job_title)
					else
						alt_titles_preferences[job_title] = chosen_title
				SetChoices(user)
			// TFN EDIT END
			if("setJobLevel")
				UpdateJobPreference(user, href_list["text"], text2num(href_list["level"]))
			else
				SetChoices(user)
		return 1

	else if(href_list["preference"] == "trait")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				ShowChoices(user)
			if("update")
				var/quirk = href_list["trait"]
				if(!SSquirks.quirks[quirk])
					return
				for(var/V in SSquirks.quirk_blacklist) //V is a list
					var/list/L = V
					if(!(quirk in L))
						continue
					for(var/Q in all_quirks)
						if((Q in L) && !(Q == quirk)) //two quirks have lined up in the list of the list of quirks that conflict with each other, so return (see quirks.dm for more details)
							to_chat(user, "<span class='danger'>[quirk] is incompatible with [Q].</span>")
							return
				var/value = SSquirks.quirk_points[quirk]
				var/balance = GetQuirkBalance()
				if(quirk in all_quirks)
					if(balance + value < 0)
						to_chat(user, "<span class='warning'>Refunding this would cause you to go below your balance!</span>")
						return
					all_quirks -= quirk
				else
					var/is_positive_quirk = SSquirks.quirk_points[quirk] > 0
					if(is_positive_quirk && GetPositiveQuirkCount() >= MAX_QUIRKS)
						to_chat(user, "<span class='warning'>You can't have more than [MAX_QUIRKS] positive quirks!</span>")
						return
					if(balance - value < 0)
						to_chat(user, "<span class='warning'>You don't have enough balance to gain this quirk!</span>")
						return
					all_quirks += quirk
				SetQuirks(user)
			if("reset")
				all_quirks = list()
				SetQuirks(user)
			else
				SetQuirks(user)
		return TRUE

	// TFN ADDITION START: loadout
	if(href_list["preference"] == "gear")
		if(href_list["purchase_gear"])
			var/datum/gear/TG = GLOB.gear_datums[href_list["purchase_gear"]]
			if(TG.cost <= player_experience)
				if(tgui_alert(user, "Are you sure you want to spend [TG.cost] experience for \the [TG.display_name]?", "Confirmation", list("Yes", "No")) == "Yes")
					purchased_gear += TG.display_name
					TG.purchase(user.client)
					player_experience -= TG.cost
					to_chat(user, span_info("Purchased [TG.display_name]!"))
					save_preferences()
			else
				to_chat(user, span_warning("You don't have enough experience to purchase \the [TG.display_name]!"))

		if(href_list["toggle_gear"])
			var/datum/gear/TG = GLOB.gear_datums[href_list["toggle_gear"]]
			if(TG.display_name in equipped_gear)
				equipped_gear -= TG.display_name
			else
				if(length(equipped_gear) >= CONFIG_GET(number/max_loadout_items))
					tgui_alert(user, "You can't have more than [CONFIG_GET(number/max_loadout_items)] items in your loadout!")
					return
				var/list/type_blacklist = list()
				var/list/slot_blacklist = list()
				for(var/gear_name in equipped_gear)
					var/datum/gear/G = GLOB.gear_datums[gear_name]
					if(istype(G))
						if(G.subtype_path in type_blacklist)
							continue
						type_blacklist += G.subtype_path
				if(!(TG.subtype_path in type_blacklist) && !(TG.slot in slot_blacklist) || TG.sort_category == "General")
					equipped_gear += TG.display_name
				else
					tgui_alert(user, "Can't equip [TG.display_name]. It conflicts with an already-equipped item.")

		else if(href_list["select_category"])
			gear_tab = href_list["select_category"]
		else if(href_list["clear_loadout"])
			equipped_gear.Cut()
		else if(href_list["toggle_loadout"])
			show_loadout = !show_loadout

		ShowChoices(user)
		return
	// TFN ADDITION END: loadout

	switch(href_list["task"])
		if("random")
			if(slotlocked)
				return
			switch(href_list["preference"])
				if("name")
					real_name = pref_species.random_name(gender,1)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("total_age")
					var/max_age = 0
					if(pref_species.name == "Vampire")
						max_age = 1000
					if(pref_species.name == "Ghoul")
						max_age = 500
					total_age = rand(age, age+max_age)
				if("hair")
					hair_color = random_color()
				if("hairstyle")
					if(clan.no_hair)
						hairstyle = "Bald"
					else
						hairstyle = random_hairstyle(gender)
				if("facial")
					facial_hair_color = random_color()
				if("facial_hairstyle")
					if(clan.no_hair)
						facial_hairstyle = "Shaved"
					if(clan.no_facial)
						facial_hairstyle = "Shaved"
					else
						facial_hairstyle = random_facial_hairstyle(gender)
				if("underwear")
					underwear = random_underwear(gender)
				if("underwear_color")
					underwear_color = random_color()
				if("undershirt")
					undershirt = random_undershirt(gender)
				if("socks")
					socks = random_socks()
				if(BODY_ZONE_PRECISE_EYES)
					eye_color = random_eye_color()
				if("s_tone")
					skin_tone = random_skin_tone()
//				if("species")
//					random_species()
				if("bag")
					backpack = pick(GLOB.backpacklist)
				if("suit")
					jumpsuit_style = pick(GLOB.jumpsuitlist)
				if("all")
					random_character(gender)

		if("input")
			if(href_list["preference"] in GLOB.preferences_custom_names)
				ask_for_custom_name(user,href_list["preference"])


			switch(href_list["preference"])
				if("ghostform")
					if(unlock_content)
						var/new_form = tgui_input_list(user, "Thanks for supporting BYOND - Choose your ghostly form:","Thanks for supporting BYOND",GLOB.ghost_forms)
						if(new_form)
							ghost_form = new_form
				if("ghostorbit")
					if(unlock_content)
						var/new_orbit = tgui_input_list(user, "Thanks for supporting BYOND - Choose your ghostly orbit:","Thanks for supporting BYOND",GLOB.ghost_orbits)
						if(new_orbit)
							ghost_orbit = new_orbit

				if("ghostaccs")
					var/new_ghost_accs = alert("Do you want your ghost to show full accessories where possible, hide accessories but still use the directional sprites where possible, or also ignore the directions and stick to the default sprites?",,GHOST_ACCS_FULL_NAME, GHOST_ACCS_DIR_NAME, GHOST_ACCS_NONE_NAME)
					switch(new_ghost_accs)
						if(GHOST_ACCS_FULL_NAME)
							ghost_accs = GHOST_ACCS_FULL
						if(GHOST_ACCS_DIR_NAME)
							ghost_accs = GHOST_ACCS_DIR
						if(GHOST_ACCS_NONE_NAME)
							ghost_accs = GHOST_ACCS_NONE

				if("ghostothers")
					var/new_ghost_others = alert("Do you want the ghosts of others to show up as their own setting, as their default sprites or always as the default white ghost?",,GHOST_OTHERS_THEIR_SETTING_NAME, GHOST_OTHERS_DEFAULT_SPRITE_NAME, GHOST_OTHERS_SIMPLE_NAME)
					switch(new_ghost_others)
						if(GHOST_OTHERS_THEIR_SETTING_NAME)
							ghost_others = GHOST_OTHERS_THEIR_SETTING
						if(GHOST_OTHERS_DEFAULT_SPRITE_NAME)
							ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
						if(GHOST_OTHERS_SIMPLE_NAME)
							ghost_others = GHOST_OTHERS_SIMPLE

				if("werewolf_name")
					if(slotlocked || (!pref_species.id == "garou"))
						return

					var/new_name = tgui_input_text(user, "Choose your character's werewolf name:", "Character Preference", max_length = MAX_NAME_LEN)
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							werewolf_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and . It must not contain any words restricted by IC chat and name filters.</font>")
				if("name")
					if(slotlocked)
						return

					var/new_name = tgui_input_text(user, "Choose your character's name:", "Character Preference", max_length = MAX_NAME_LEN)
					if(new_name)
						new_name = reject_bad_name(new_name)
						if(new_name)
							real_name = new_name
						else
							to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and . It must not contain any words restricted by IC chat and name filters.</font>")

				if("age")
					if(slotlocked)
						return

					var/new_age = tgui_input_number(user, "Choose your character's biological age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference", age, AGE_MAX, AGE_MIN, round_value = TRUE)
					if(new_age)
						age = clamp(new_age, AGE_MIN, AGE_MAX)
						if (age > total_age)
							total_age = age
						update_preview_icon()

				if("total_age")
					if(slotlocked)
						return

					var/new_age = tgui_input_number(user, "Choose your character's actual age:\n([age]-[age+1000])", "Character Preference", total_age, age+1000, age, round_value = TRUE)
					if(new_age)
						total_age = clamp(new_age, age, age+1000)
						if (total_age < age)
							age = total_age
						update_preview_icon()

				if("info_choose")
					var/new_info_known = tgui_input_list(user, "Choose who knows your character:", "Fame", list(INFO_KNOWN_UNKNOWN, INFO_KNOWN_CLAN_ONLY, INFO_KNOWN_FACTION, INFO_KNOWN_PUBLIC))
					if(new_info_known)
						info_known = new_info_known

				if("hair")
					if(slotlocked)
						return

					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", hair_color) as color|null
					if(new_hair)
						hair_color = sanitize_hexcolor(new_hair)

				if("hairstyle")
					if(slotlocked)
						return

					if(clan.no_hair)
						hairstyle = "Bald"
					else
						var/new_hairstyle
						if(gender == MALE)
							new_hairstyle = tgui_input_list(user, "Choose your character's hairstyle:", "Character Preference", GLOB.hairstyles_male_list)
						else if(gender == FEMALE)
							new_hairstyle = tgui_input_list(user, "Choose your character's hairstyle:", "Character Preference", GLOB.hairstyles_female_list)
						else
							new_hairstyle = tgui_input_list(user, "Choose your character's hairstyle:", "Character Preference", GLOB.hairstyles_list)
						if(new_hairstyle)
							hairstyle = new_hairstyle

				if("next_hairstyle")
					if(slotlocked)
						return

					if(clan.no_hair)
						hairstyle = "Bald"
					else
						if (gender == MALE)
							hairstyle = next_list_item(hairstyle, GLOB.hairstyles_male_list)
						else if(gender == FEMALE)
							hairstyle = next_list_item(hairstyle, GLOB.hairstyles_female_list)
						else
							hairstyle = next_list_item(hairstyle, GLOB.hairstyles_list)

				if("previous_hairstyle")
					if(slotlocked)
						return

					if(clan.no_hair)
						hairstyle = "Bald"
					else
						if (gender == MALE)
							hairstyle = previous_list_item(hairstyle, GLOB.hairstyles_male_list)
						else if(gender == FEMALE)
							hairstyle = previous_list_item(hairstyle, GLOB.hairstyles_female_list)
						else
							hairstyle = previous_list_item(hairstyle, GLOB.hairstyles_list)

				if("facial")
					if(slotlocked)
						return

					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", facial_hair_color) as color|null
					if(new_facial)
						facial_hair_color = sanitize_hexcolor(new_facial)

				if("facial_hairstyle")
					if(slotlocked)
						return

					if(clan.no_facial)
						facial_hairstyle = "Shaved"
					else
						var/new_facial_hairstyle
						if(gender == MALE)
							new_facial_hairstyle = tgui_input_list(user, "Choose your character's facial-hairstyle:", "Character Preference", GLOB.facial_hairstyles_male_list)
						else if(gender == FEMALE)
							new_facial_hairstyle = tgui_input_list(user, "Choose your character's facial-hairstyle:", "Character Preference", GLOB.facial_hairstyles_female_list)
						else
							new_facial_hairstyle = tgui_input_list(user, "Choose your character's facial-hairstyle:", "Character Preference", GLOB.facial_hairstyles_list)
						if(new_facial_hairstyle)
							facial_hairstyle = new_facial_hairstyle

				if("next_facehairstyle")
					if(slotlocked)
						return

					if(clan.no_facial)
						facial_hairstyle = "Shaved"
					else
						if (gender == MALE)
							facial_hairstyle = next_list_item(facial_hairstyle, GLOB.facial_hairstyles_male_list)
						else if(gender == FEMALE)
							facial_hairstyle = next_list_item(facial_hairstyle, GLOB.facial_hairstyles_female_list)
						else
							facial_hairstyle = next_list_item(facial_hairstyle, GLOB.facial_hairstyles_list)

				if("previous_facehairstyle")
					if(slotlocked)
						return

					if(clan.no_facial)
						facial_hairstyle = "Shaved"
					else
						if (gender == MALE)
							facial_hairstyle = previous_list_item(facial_hairstyle, GLOB.facial_hairstyles_male_list)
						else if (gender == FEMALE)
							facial_hairstyle = previous_list_item(facial_hairstyle, GLOB.facial_hairstyles_female_list)
						else
							facial_hairstyle = previous_list_item(facial_hairstyle, GLOB.facial_hairstyles_list)

				if("underwear")
					var/new_underwear
					if(gender == MALE)
						new_underwear = tgui_input_list(user, "Choose your character's underwear:", "Character Preference", GLOB.underwear_m)
					else if(gender == FEMALE)
						new_underwear = tgui_input_list(user, "Choose your character's underwear:", "Character Preference", GLOB.underwear_f)
					else
						new_underwear = tgui_input_list(user, "Choose your character's underwear:", "Character Preference", GLOB.underwear_list)
					if(new_underwear)
						underwear = new_underwear

				if("underwear_color")
					var/new_underwear_color = input(user, "Choose your character's underwear color:", "Character Preference", underwear_color) as color|null
					if(new_underwear_color)
						underwear_color = sanitize_hexcolor(new_underwear_color)

				if("undershirt")
					var/new_undershirt
					if(gender == MALE)
						new_undershirt = tgui_input_list(user, "Choose your character's undershirt:", "Character Preference", GLOB.undershirt_m)
					else if(gender == FEMALE)
						new_undershirt = tgui_input_list(user, "Choose your character's undershirt:", "Character Preference", GLOB.undershirt_f)
					else
						new_undershirt = tgui_input_list(user, "Choose your character's undershirt:", "Character Preference", GLOB.undershirt_list)

					if(new_undershirt)
						undershirt = new_undershirt

				if("socks")
					var/new_socks
					new_socks = tgui_input_list(user, "Choose your character's socks:", "Character Preference", GLOB.socks_list)
					if(new_socks)
						socks = new_socks

				if("eyes")
					if(slotlocked)
						return

					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", eye_color) as color|null
					if(new_eyes)
						eye_color = sanitize_hexcolor(new_eyes)

				if("newdiscipline")
					if((player_experience < 10) || !(pref_species.id == "kindred") || !(clan.name == CLAN_NONE))
						return

					var/list/possible_new_disciplines = subtypesof(/datum/discipline) - discipline_types - /datum/discipline/bloodheal
					for (var/discipline_type in possible_new_disciplines)
						var/datum/discipline/discipline = new discipline_type
						if (discipline.clan_restricted)
							possible_new_disciplines -= discipline_type
						qdel(discipline)
					if(length(discipline_types) >= 3)
						to_chat(user, span_notice("You cannot select more than three disciplines! Acquire more through roleplay!"))
						return
					var/new_discipline = tgui_input_list(user, "Select your new Discipline", "Discipline Selection", sort_list(possible_new_disciplines))
					if(new_discipline)
						discipline_types += new_discipline
						discipline_levels += 1
						player_experience -= 10
						experience_used_on_character += 10

				if("newvaleren")
					if((player_experience < 10) || !(pref_species.id == "kindred") || !((clan.name == CLAN_SALUBRI) || (clan.name == CLAN_SALUBRI_WARRIOR)))
						return

					var/list/possible_new_valerens = list(/datum/discipline/valeren, /datum/discipline/valeren_warrior)
					possible_new_valerens -= discipline_types

					var/new_discipline = tgui_input_list(user, "Select your new Valeren Path", "Discipline Selection", sort_list(possible_new_valerens))
					if(new_discipline)
						discipline_types += new_discipline
						discipline_levels += 1
						player_experience -= 10
						experience_used_on_character += 10

				if("newghouldiscipline")
					if((player_experience < 10) || !(pref_species.id == "ghoul"))
						return

					var/list/possible_new_disciplines = subtypesof(/datum/discipline) - discipline_types - /datum/discipline/bloodheal
					var/new_discipline = tgui_input_list(user, "Select your new Discipline", "Discipline Selection", sort_list(possible_new_disciplines))
					if(new_discipline)
						discipline_types += new_discipline
						discipline_levels += 1
						player_experience -= 10
						experience_used_on_character += 10

				if("newchidiscipline")
					if((player_experience < 10) || !(pref_species.id == "kuei-jin"))
						return

					var/list/possible_new_disciplines = subtypesof(/datum/chi_discipline) - discipline_types
					var/has_chi_one = FALSE
					var/has_demon_one = FALSE
					var/how_much_usual = 0
					for(var/i in discipline_types)
						if(i)
							var/datum/chi_discipline/C = i
							if(initial(C.discipline_type) == "Shintai")
								how_much_usual += 1
							if(initial(C.discipline_type) == "Demon")
								has_demon_one = TRUE
							if(initial(C.discipline_type) == "Chi")
								has_chi_one = TRUE
					for(var/i in possible_new_disciplines)
						if(i)
							var/datum/chi_discipline/C = i
							if(initial(C.discipline_type) == "Shintai")
								if(how_much_usual >= 3)
									possible_new_disciplines -= i
							if(initial(C.discipline_type) == "Demon")
								if(has_demon_one)
									possible_new_disciplines -= i
							if(initial(C.discipline_type) == "Chi")
								if(has_chi_one)
									possible_new_disciplines -= i
					var/new_discipline = tgui_input_list(user, "Select your new Discipline", "Discipline Selection", sort_list(possible_new_disciplines))
					if(new_discipline)
						discipline_types += new_discipline
						discipline_levels += 1
						player_experience -= 10
						experience_used_on_character += 10

				if("werewolf_color")
					if(slotlocked || !(pref_species.id == "garou"))
						return

					var/list/colors = list("black", "gray", "red", "white", "ginger", "brown")
					var/result = tgui_input_list(user, "Select fur color:", "Appearance Selection", sort_list(colors))
					if(result)
						werewolf_color = result

				if("werewolf_scar")
					if(slotlocked || !(pref_species.id == "garou"))
						return

					if(tribe.name == "Glass Walkers")
						if(werewolf_scar == 9)
							werewolf_scar = 0
						else
							werewolf_scar = min(9, werewolf_scar+1)
					else
						if(werewolf_scar == 7)
							werewolf_scar = 0
						else
							werewolf_scar = min(7, werewolf_scar+1)

				if("werewolf_hair")
					if(slotlocked || !(pref_species.id == "garou"))
						return

					if(werewolf_hair == 4)
						werewolf_hair = 0
					else
						werewolf_hair = min(4, werewolf_hair+1)

				if("werewolf_hair_color")
					if(slotlocked || !(pref_species.id == "garou"))
						return

					var/new_hair = input(user, "Select hair color:", "Appearance Selection",werewolf_hair_color) as color|null
					if(new_hair)
						werewolf_hair_color = sanitize_ooccolor(new_hair)

				if("werewolf_eye_color")
					if(slotlocked || !(pref_species.id == "garou"))
						return

					var/new_eye = input(user, "Select eye color:", "Appearance Selection",werewolf_eye_color) as color|null
					if(new_eye)
						werewolf_eye_color = sanitize_ooccolor(new_eye)

				if("auspice")
					if(slotlocked || !(pref_species.id == "garou"))
						return
					if(src.tribe.name == "Corax")
						auspice=/datum/auspice/theurge
						return
					else
						var/list/auspice_choices = list()
						for(var/i in GLOB.auspices_list)
							var/a = GLOB.auspices_list[i]
							var/datum/auspice/V = new a
							auspice_choices[V.name] += GLOB.auspices_list[i]
							qdel(V)
						var/result = tgui_input_list(user, "Select an Auspice", "Auspice Selection", auspice_choices)
						if(result)
							var/newtype = GLOB.auspices_list[result]
							var/datum/auspice/Auspic = new newtype()
							auspice = Auspic

				if("clan_acc")
					if(pref_species.id != "kindred")	//Due to a lot of people being locked to furries
						return

					if(!length(clan.accessories))
						clan_accessory = null
						return
					var/result = tgui_input_list(user, "Select a mark", "Marks", clan.accessories)
					if(result)
						clan_accessory = result

				if("clan")
					if(slotlocked || !(pref_species.id == "kindred"))
						return

					if(tgui_alert(user, "Are you sure you want to change your Clan? This will reset your Disciplines.", "Confirmation", list("Yes", "No")) != "Yes")
						return

					// Create a list of Clans that can be played by anyone or this user has a whitelist for
					var/list/available_clans = list()
					for(var/adding_clan in GLOB.vampire_clans)
						var/datum/vampire_clan/checking_clan = GLOB.vampire_clans[adding_clan]
						if(checking_clan.whitelisted && !SSwhitelists.is_whitelisted(user.ckey, checking_clan.name))
							continue
						available_clans += checking_clan
					var/result = tgui_input_list(user, "Select a Clan", "Clan Selection", sort_list(available_clans))
					if(!result)
						return
					clan = result

					discipline_types = list()
					discipline_levels = list()

					if(result == GLOB.vampire_clans[/datum/vampire_clan/caitiff])
						generation = 13
						for(var/i in 1 to 3)
							if (slotlocked)
								break

							var/list/possible_new_disciplines = subtypesof(/datum/discipline) - discipline_types - /datum/discipline/bloodheal
							for(var/discipline_type in possible_new_disciplines)
								var/datum/discipline/discipline = new discipline_type
								if (discipline.clan_restricted)
									possible_new_disciplines -= discipline_type
								qdel(discipline)
							var/new_discipline = tgui_input_list(user, "Select a Discipline", "Discipline Selection", sort_list(possible_new_disciplines))
							if(new_discipline)
								discipline_types += new_discipline
								discipline_levels += 1

					for(var/i in 1 to length(clan.clan_disciplines))
						discipline_types += clan.clan_disciplines[i]
						discipline_levels += 1

					is_enlightened = clan.is_enlightened
					if(is_enlightened)
						qdel(morality_path)
						switch(clan.name)
							if(CLAN_LASOMBRA)
								morality_path = new /datum/morality/power()
							if(CLAN_OLD_TZIMISCE)
								morality_path = new /datum/morality/kings()
							if(CLAN_TZIMISCE)
								morality_path = new /datum/morality/metamorphosis()
							if(CLAN_TRUE_BRUJAH)
								morality_path = new /datum/morality/heart()
							if(CLAN_BAALI)
								morality_path = new /datum/morality/hive()
							if(CLAN_SALUBRI_WARRIOR)
								morality_path = new /datum/morality/samiel()
					path_score = morality_path.score

					if(clan.no_hair)
						hairstyle = "Bald"
					if(clan.no_facial)
						facial_hairstyle = "Shaved"
					if(length(clan.accessories))
						if("none" in clan.accessories)
							clan_accessory = null
						else
							clan_accessory = pick(clan.accessories)

				if("derangement")

					if(!(pref_species.id == "kindred" ) || clan.name != CLAN_MALKAVIAN)
						return

					if(!(clan.name == CLAN_MALKAVIAN))
						return

					if (tgui_alert(user, "Are you sure you want to change your derangement? Madness is more mundane than insanity.", "Confirmation", list("Yes", "No")) != "Yes")
						return

					derangement = !derangement

				if("auspice_level")
					var/cost = max(10, auspice_level * 10)
					if ((player_experience < cost) || (auspice_level >= 3))
						return

					player_experience -= cost
					experience_used_on_character += cost
					auspice_level = max(1, auspice_level + 1)

				if("physique")
					if(handle_upgrade(physique, physique * 4))
						physique++

				if("dexterity")
					if(handle_upgrade(dexterity, dexterity * 4))
						dexterity++

				if("social")
					if(handle_upgrade(social, social * 4))
						social++

				if("mentality")
					if(handle_upgrade(mentality, mentality * 4))
						mentality++

				if("blood")
					if(handle_upgrade(blood, blood * 6))
						blood++

				if("lockpicking")
					if(handle_upgrade(lockpicking, lockpicking ? lockpicking*2 : 3))
						lockpicking++

				if("athletics")
					if(handle_upgrade(athletics, athletics ? athletics*2 : 3))
						athletics++

				if("tribe")
					if(slotlocked || !(pref_species.id == "garou"))
						return

					var/list/available_tribes = list()
					for(var/i in GLOB.tribes_list)
						var/a = GLOB.tribes_list[i]
						var/datum/garou_tribe/G = new a
						available_tribes[G.name] += GLOB.tribes_list[i]
						qdel(G)
					var/new_tribe = tgui_input_list(user, "Choose your Tribe:", "Tribe", sort_list(available_tribes))
					if(new_tribe)
						var/newtype = GLOB.tribes_list[new_tribe]
						new_tribe = new newtype()
						tribe = new_tribe
						if (tribe.name == "Corax")
							ADD_TRAIT(user,TRAIT_CORAX,tribe) //This might be redundant considering we also add this trait in auspice.dm

							auspice=/datum/auspice/theurge // we do not want player to have a choice in the auspice, Corax being theurges is already silly enough
						else
							if HAS_TRAIT(user,TRAIT_CORAX)
								REMOVE_TRAIT(user, TRAIT_CORAX,tribe)


				if("breed")
					if(slotlocked || !(pref_species.id == "garou"))
						return

					var/new_breed = tgui_input_list(user, "Choose your Breed:", "Breed", sort_list(list("Homid", "Metis", "Lupus")))
					if (new_breed)
						breed = new_breed

				if("archetype")
					if(slotlocked)
						return

					if (tgui_alert(user, "Are you sure you want to change Archetype? This will reset your attributes.", "Confirmation", list("Yes", "No")) != "Yes")
						return

					var/list/archetypes = list()
					for(var/i in subtypesof(/datum/archetype))
						var/datum/archetype/the_archetype = i
						archetypes[initial(the_archetype.name)] = i
					var/result = tgui_input_list(user, "Select an archetype", "Attributes Selection", sort_list(archetypes))
					if(result)
						archetype = archetypes[result]
						var/datum/archetype/archetip = new archetype()
						physique = archetip.start_physique
						dexterity = archetip.start_dexterity
						mentality = archetip.start_mentality
						social = archetip.start_social
						blood = archetip.start_blood
						lockpicking = archetip.start_lockpicking
						athletics = archetip.start_athletics

				if("discipline")
					if(pref_species.id == "kindred")
						var/i = text2num(href_list["upgradediscipline"])

						var/discipline_level = discipline_levels[i]
						var/cost = discipline_level * 7
						if (discipline_level <= 0)
							cost = 10
						else if (clan.name == CLAN_NONE)
							cost = discipline_level * 6
						else if (clan.common_disciplines.Find(discipline_types[i]))
							cost = discipline_level * 6
						else if (clan.clan_disciplines.Find(discipline_types[i]))
							cost = discipline_level * 5

						if ((player_experience < cost) || (discipline_level >= 5))
							return

						player_experience -= cost
						experience_used_on_character += cost
						discipline_levels[i] = min(5, max(1, discipline_levels[i] + 1))

					if(pref_species.id == "kuei-jin")
						var/a = text2num(href_list["upgradechidiscipline"])

						var/discipline_level = discipline_levels[a]
						var/cost = discipline_level * 6
						if (discipline_level <= 0)
							cost = 10

						if ((player_experience < cost) || (discipline_level >= 5))
							return

						player_experience -= cost
						experience_used_on_character += cost
						discipline_levels[a] = min(5, max(1, discipline_levels[a] + 1))

				if("path")
					var/cost = max(2, path_score * 2)
					if ((player_experience < cost) || (path_score >= 10) || !(pref_species.id == "kindred"))
						return

					player_experience -= cost
					experience_used_on_character += cost
					path_score = clamp(path_score + 1, MIN_PATH_SCORE, MAX_PATH_SCORE)

				if("pathof")
					if(slotlocked || !(pref_species.id == "kindred"))
						return

					if(tgui_alert(user, "Are you sure you want to change Path? This will reset Path-specific stats.", "Confirmation", list("Yes", "No")) != "Yes")
						return

					var/list/available_paths = list()

					for(var/i in GLOB.morality_list)
						var/a = GLOB.morality_list[i]
						var/datum/morality/M = new a
						available_paths[M.name] += GLOB.morality_list
						qdel(M)

					var/result = tgui_input_list(user, "Select a Path", "Path Selection", sort_list(available_paths))
					if(result)
						var/newtype = GLOB.morality_list[result]
						morality_path = new newtype()
						path_score = morality_path.score
						switch(morality_path.alignment)
							if(MORALITY_HUMANITY)
								is_enlightened = FALSE
							if(MORALITY_ENLIGHTENMENT)
								is_enlightened = TRUE

				if("renownrank")
					renownrank = renownrank+1

				if("renownglory")
					var/cost = 25
					if ((player_experience < cost) || (glory >= 10) || !(pref_species.id == "garou"))
						return
					player_experience -= cost
					experience_used_on_character += cost
					glory = glory+1
				if("renownhonor")
					var/cost = 25
					if ((player_experience < cost) || (honor >= 10) || !(pref_species.id == "garou"))
						return
					player_experience -= cost
					experience_used_on_character += cost
					honor = honor+1
				if("renownwisdom")
					var/cost = 25
					if ((player_experience < cost) || (wisdom >= 10) || !(pref_species.id == "garou"))
						return
					player_experience -= cost
					experience_used_on_character += cost
					wisdom = wisdom+1

				if("dharmarise")
					if ((player_experience < min((dharma_level * 5), 20)) || (dharma_level >= 6) || !(pref_species.id == "kuei-jin"))
						return

					player_experience -= min((dharma_level * 5), 20)
					experience_used_on_character += min((dharma_level * 5), 20)
					dharma_level = clamp(dharma_level + 1, 1, 6)

					if (dharma_level >= 6)
						hun += 1
						po += 1
						yin += 1
						yang += 1

				if("dharmatype")
					if(slotlocked)
						return
					if (tgui_alert(user, "Are you sure you want to change Dharma? This will reset path-specific stats.", "Confirmation", list("Yes", "No")) != "Yes")
						return
					var/list/dharmas = list()
					for(var/i in subtypesof(/datum/dharma))
						var/datum/dharma/dharma = i
						dharmas += initial(dharma.name)
					var/result = tgui_input_list(user, "Select Dharma", "Dharma", sort_list(dharmas))
					if(result)
						for(var/i in subtypesof(/datum/dharma))
							var/datum/dharma/dharma = i
							if(initial(dharma.name) == result)
								dharma_type = i
								dharma_level = initial(dharma_level)
								hun = initial(hun)
								po = initial(po)
								yin = initial(yin)
								yang = initial(yang)

				if("potype")
					if(slotlocked)
						return
					var/list/pos = list("Rebel", "Legalist", "Demon", "Monkey", "Fool")
					var/result = tgui_input_list(user, "Select P'o", "P'o", sort_list(pos))
					if(result)
						po_type = result

				if("chibalance")
					var/max_limit = max(10, dharma_level * 2)
					var/sett = tgui_input_number(user, "Enter the maximum of Yin your character has:", "Yin/Yang")
					if(sett)
						sett = max(1, min(sett, max_limit-1))
						yin = sett
						yang = max_limit-sett

				if("demonbalance")
					var/max_limit = max(10, dharma_level * 2)
					var/sett = tgui_input_number(user, "Enter the maximum of Hun your character has:", "Hun/P'o")
					if(sett)
						sett = max(1, min(sett, max_limit-1))
						hun = sett
						po = max_limit-sett

				if("generation")
					if((clan?.name == CLAN_NONE) || (player_experience < 20))
						return

					player_experience -= 20
					experience_used_on_character += 20
					if(SSwhitelists.is_whitelisted(user.ckey, TRUSTED_PLAYER))
						generation_bonus = min(generation_bonus + 1, max(0, generation-MAX_TRUSTED_GENERATION))
					else
						generation_bonus = min(generation_bonus + 1, max(0, generation-MAX_PUBLIC_GENERATION))

				if("friend_text")
					var/new_text = tgui_input_text(user, "What a Friend knows about me:", "Character Preference", max_length = 512)
					if(new_text)
						friend_text = new_text
				if("enemy_text")
					var/new_text = tgui_input_text(user, "What an Enemy knows about me:", "Character Preference", max_length = 512)
					if(new_text)
						enemy_text = new_text
				if("lover_text")
					var/new_text = tgui_input_text(user, "What a Lover knows about me:", "Character Preference", max_length = 512)
					if(new_text)
						lover_text = new_text
				// TODO: Completely revamp flavor text into a more expansive system - TFN
				// TFN EDIT ADDITION START: character headshots & flavortext
				if("ooc_notes")
					var/new_ooc_notes = tgui_input_text(user, "Choose your OOC notes:", "Character Preference", ooc_notes, MAX_FLAVOR_LEN, multiline = TRUE, encode = FALSE)
					if(!length(new_ooc_notes))
						return
					ooc_notes = STRIP_HTML_SIMPLE(new_ooc_notes, MAX_FLAVOR_LEN)

				if("character_notes")
					var/new_character_notes = tgui_input_text(user, "Choose your character notes:", "Character Preference", character_notes, MAX_FLAVOR_LEN, multiline = TRUE, encode = FALSE)
					if(!length(new_character_notes))
						return
					character_notes = STRIP_HTML_SIMPLE(new_character_notes, MAX_FLAVOR_LEN)
					SSoverwatch.record_action(user, "**CHARACTER NOTES**: [character_notes]")

				if("flavor_text")
					var/new_flavor = tgui_input_text(user, "Choose your character's flavor text:", "Character Preference", flavor_text, MAX_FLAVOR_LEN, multiline = TRUE, encode = FALSE)
					if(!length(new_flavor))
						return
					flavor_text = STRIP_HTML_SIMPLE(new_flavor, MAX_FLAVOR_LEN)
					SSoverwatch.record_action(user, "**FLAVORTEXT**: [flavor_text]")

				if("flavor_text_nsfw")
					var/new_flavor_nsfw = tgui_input_text(user, "Choose your character's NSFW flavor text:", "Character Preference", flavor_text_nsfw, MAX_FLAVOR_LEN, multiline = TRUE, encode = FALSE)
					if(!length(new_flavor_nsfw))
						return
					flavor_text_nsfw = STRIP_HTML_SIMPLE(new_flavor_nsfw, MAX_FLAVOR_LEN)

				if("view_flavortext")
					// The examine preview dummy will be cleaned up once the user closes the TGUI window.
					var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy()
					mannequin.setup_examine_preview(user.client)
					mannequin.tgui?.ui_interact(usr)

				if("headshot")
					to_chat(user, span_notice("Please use a relatively SFW image of the head and shoulder area to maintain immersion level. Lastly, ["<b>do not use a real life photo or use any image that is less than serious.</b>"]"))
					to_chat(user, span_notice("If the photo doesn't show up properly in-game, ensure that it's a direct image link that opens properly in a browser."))
					to_chat(user, span_notice("Resolution: 250x250 pixels."))
					var/new_headshot_link = tgui_input_text(user, "Input the headshot link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Headshot", headshot_link, encode = FALSE)
					if(isnull(new_headshot_link))
						return
					if(!length(new_headshot_link))
						headshot_link = null
						ShowChoices(user)
						return
					if(!valid_headshot_link(user, new_headshot_link))
						headshot_link = null
						ShowChoices(user)
						return
					headshot_link = new_headshot_link
					to_chat(user, span_notice("Successfully updated headshot picture!"))
					log_game("[key_name(user)] has set their Headshot image to '[headshot_link]'.")
					SSoverwatch.record_action(user, "[key_name(user)] has set their Headshot image to [headshot_link]")
				// TFN EDIT ADDITION END
				if("change_appearance")
					if(!slotlocked)
						return

					slotlocked = FALSE

				if("reset_with_bonus")
					if((clan?.name == CLAN_NONE) || !generation_bonus)
						return

					var/bonus = generation-generation_bonus
					slotlocked = 0
					torpor_count = 0
					masquerade = initial(masquerade)
					generation = clamp(bonus, LOWEST_GENERATION_LIMIT, HIGHEST_GENERATION_LIMIT)
					generation_bonus = 0
					save_character()

				if("species")
					if(slotlocked)
						return

					if (tgui_alert(user, "Are you sure you want to change species? This will reset species-specific stats.", "Confirmation", list("Yes", "No")) != "Yes")
						return

					var/list/choose_species = list()
					for (var/key in get_selectable_species())
						var/newtype = GLOB.species_list[key]
						var/datum/species/selecting_species = new newtype
						if (!selecting_species.selectable)
							qdel(selecting_species)
							continue
						if (selecting_species.whitelisted)
							if (parent && !SSwhitelists.is_whitelisted(parent.ckey, key))
								qdel(selecting_species)
								continue
						choose_species += key
						qdel(selecting_species)

					var/result = tgui_input_list(user, "Select a species", "Species Selection", sort_list(choose_species))
					if(result)
						all_quirks.Cut()
						SetQuirks(user)
						var/newtype = GLOB.species_list[result]
						pref_species = new newtype()
						switch(pref_species.id)
							if("ghoul","human","kuei-jin")
								discipline_types.Cut()
								discipline_levels.Cut()
							if("kindred")
								clan = GLOB.vampire_clans[/datum/vampire_clan/brujah]
								discipline_types.Cut()
								discipline_levels.Cut()
								for (var/i in 1 to length(clan.clan_disciplines))
									discipline_types += clan.clan_disciplines[i]
									discipline_levels += 1
						//Now that we changed our species, we must verify that the mutant colour is still allowed.
						var/temp_hsv = RGBtoHSV(features["mcolor"])
						if(features["mcolor"] == "#000" || (!(MUTCOLORS_PARTSONLY in pref_species.species_traits) && ReadHSV(temp_hsv)[3] < ReadHSV("#7F7F7F")[3]))
							features["mcolor"] = pref_species.default_color
						if(randomise[RANDOM_NAME])
							real_name = pref_species.random_name(gender)

				if("mutant_color")
					if(slotlocked)
						return

					var/new_mutantcolor = input(user, "Choose your character's alien/mutant color:", "Character Preference", features["mcolor"]) as color|null
					if(new_mutantcolor)
						var/temp_hsv = RGBtoHSV(new_mutantcolor)
						if(new_mutantcolor == "#000000")
							features["mcolor"] = pref_species.default_color
						else if((MUTCOLORS_PARTSONLY in pref_species.species_traits) || ReadHSV(temp_hsv)[3] >= ReadHSV("#7F7F7F")[3]) // mutantcolors must be bright, but only if they affect the skin
							features["mcolor"] = sanitize_hexcolor(new_mutantcolor)
						else
							to_chat(user, "<span class='danger'>Invalid color. Your color is not bright enough.</span>")

				if("color_ethereal")
					var/new_etherealcolor = input(user, "Choose your ethereal color", "Character Preference") as null|anything in GLOB.color_list_ethereal
					if(new_etherealcolor)
						features["ethcolor"] = GLOB.color_list_ethereal[new_etherealcolor]


				if("tail_lizard")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.tails_list_lizard
					if(new_tail)
						features["tail_lizard"] = new_tail

				if("tail_human")
					var/new_tail
					new_tail = input(user, "Choose your character's tail:", "Character Preference") as null|anything in GLOB.tails_list_human
					if(new_tail)
						features["tail_human"] = new_tail

				if("snout")
					var/new_snout
					new_snout = input(user, "Choose your character's snout:", "Character Preference") as null|anything in GLOB.snouts_list
					if(new_snout)
						features["snout"] = new_snout

				if("horns")
					var/new_horns
					new_horns = input(user, "Choose your character's horns:", "Character Preference") as null|anything in GLOB.horns_list
					if(new_horns)
						features["horns"] = new_horns

				if("ears")
					var/new_ears
					new_ears = input(user, "Choose your character's ears:", "Character Preference") as null|anything in GLOB.ears_list
					if(new_ears)
						features["ears"] = new_ears

				if("wings")
					var/new_wings
					new_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.r_wings_list
					if(new_wings)
						features["wings"] = new_wings

				if("frills")
					var/new_frills
					new_frills = input(user, "Choose your character's frills:", "Character Preference") as null|anything in GLOB.frills_list
					if(new_frills)
						features["frills"] = new_frills

				if("spines")
					var/new_spines
					new_spines = input(user, "Choose your character's spines:", "Character Preference") as null|anything in GLOB.spines_list
					if(new_spines)
						features["spines"] = new_spines

				if("body_markings")
					var/new_body_markings
					new_body_markings = input(user, "Choose your character's body markings:", "Character Preference") as null|anything in GLOB.body_markings_list
					if(new_body_markings)
						features["body_markings"] = new_body_markings

				if("legs")
					var/new_legs
					new_legs = input(user, "Choose your character's legs:", "Character Preference") as null|anything in GLOB.legs_list
					if(new_legs)
						features["legs"] = new_legs

				if("moth_wings")
					var/new_moth_wings
					new_moth_wings = input(user, "Choose your character's wings:", "Character Preference") as null|anything in GLOB.moth_wings_list
					if(new_moth_wings)
						features["moth_wings"] = new_moth_wings

				if("moth_antennae")
					var/new_moth_antennae
					new_moth_antennae = input(user, "Choose your character's antennae:", "Character Preference") as null|anything in GLOB.moth_antennae_list
					if(new_moth_antennae)
						features["moth_antennae"] = new_moth_antennae

				if("moth_markings")
					var/new_moth_markings
					new_moth_markings = input(user, "Choose your character's markings:", "Character Preference") as null|anything in GLOB.moth_markings_list
					if(new_moth_markings)
						features["moth_markings"] = new_moth_markings

				if("s_tone")
					if(slotlocked)
						return

					var/new_s_tone = tgui_input_list(user, "Choose your character's skin-tone:", "Character Preference", GLOB.skin_tones)
					if(new_s_tone)
						skin_tone = new_s_tone

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference",ooccolor) as color|null
					if(new_ooccolor)
						ooccolor = sanitize_ooccolor(new_ooccolor)

				if("asaycolor")
					var/new_asaycolor = input(user, "Choose your ASAY color:", "Game Preference",asaycolor) as color|null
					if(new_asaycolor)
						asaycolor = sanitize_ooccolor(new_asaycolor)

				if("bag")
					var/new_backpack = tgui_input_list(user, "Choose your character's style of bag:", "Character Preference", GLOB.backpacklist)
					if(new_backpack)
						backpack = new_backpack

				if("suit")
					if(jumpsuit_style == PREF_SUIT)
						jumpsuit_style = PREF_SKIRT
					else
						jumpsuit_style = PREF_SUIT

				if("uplink_loc")
					var/new_loc = input(user, "Choose your character's traitor uplink spawn location:", "Character Preference") as null|anything in GLOB.uplink_spawn_loc_list
					if(new_loc)
						uplink_spawn_loc = new_loc

				if("playtime_reward_cloak")
					if (user.client.get_exp_living(TRUE) >= PLAYTIME_VETERAN)
						playtime_reward_cloak = !playtime_reward_cloak

				if("ai_core_icon")
					var/ai_core_icon = input(user, "Choose your preferred AI core display screen:", "AI Core Display Screen Selection") as null|anything in GLOB.ai_core_display_screens - "Portrait"
					if(ai_core_icon)
						preferred_ai_core_display = ai_core_icon

				if("sec_dept")
					var/department = input(user, "Choose your preferred security department:", "Security Departments") as null|anything in GLOB.security_depts_prefs
					if(department)
						prefered_security_department = department

				if ("preferred_map")
					var/maplist = list()
					var/default = "Default"
					if (config.defaultmap)
						default += " ([config.defaultmap.map_name])"
					for (var/M in config.maplist)
						var/datum/map_config/VM = config.maplist[M]
						if(!VM.votable)
							continue
						var/friendlyname = "[VM.map_name] "
						if (VM.voteweight <= 0)
							friendlyname += " (disabled)"
						maplist[friendlyname] = VM.map_name
					maplist[default] = null
					var/pickedmap = input(user, "Choose your preferred map. This will be used to help weight random map selection.", "Character Preference")  as null|anything in sort_list(maplist)
					if (pickedmap)
						preferred_map = maplist[pickedmap]

				if ("clientfps")
					var/desiredfps = input(user, "Choose your desired fps.\n-1 means recommended value (currently:[RECOMMENDED_FPS])\n0 means world fps (currently:[world.fps])", "Character Preference", clientfps)  as null|num
					if (!isnull(desiredfps))
						clientfps = sanitize_integer(desiredfps, -1, 1000, clientfps)
						if(parent)
							parent.fps = (clientfps < 0) ? RECOMMENDED_FPS : clientfps
				if("ui")
					var/pickedui = input(user, "Choose your UI style.", "Character Preference", UI_style)  as null|anything in sort_list(GLOB.available_ui_styles)
					if(pickedui)
						UI_style = pickedui
						if (parent?.mob.hud_used)
							parent.mob.hud_used.update_ui_style(ui_style2icon(UI_style))
				if("pda_style")
					var/pickedPDAStyle = input(user, "Choose your PDA style.", "Character Preference", pda_style)  as null|anything in GLOB.pda_styles
					if(pickedPDAStyle)
						pda_style = pickedPDAStyle
				if("pda_color")
					var/pickedPDAColor = input(user, "Choose your PDA Interface color.", "Character Preference", pda_color) as color|null
					if(pickedPDAColor)
						pda_color = pickedPDAColor

				if("phobia")
					var/phobiaType = input(user, "What are you scared of?", "Character Preference", phobia) as null|anything in SStraumas.phobia_types
					if(phobiaType)
						phobia = phobiaType

				if ("max_chat_length")
					var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [initial(max_chat_length)]))", "Character Preference", max_chat_length)  as null|num
					if (!isnull(desiredlength))
						max_chat_length = clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH)

		else
			switch(href_list["preference"])
				if("publicity")
					if(unlock_content)
						toggles ^= MEMBER_PUBLIC
				if("gender")
					if(slotlocked)
						return

					var/list/friendlyGenders = list("Masculine (He/Him)" = "male", "Feminine (She/Her)" = "female", "Other (They/Them)" = "plural")
					var/pickedGender = tgui_input_list(user, "Choose your gender.", "Character Preference", friendlyGenders, gender)
					if(pickedGender && friendlyGenders[pickedGender] != gender)
						gender = friendlyGenders[pickedGender]
						underwear = random_underwear(gender)
						undershirt = random_undershirt(gender)
						socks = random_socks()
						facial_hairstyle = random_facial_hairstyle(gender)
						hairstyle = random_hairstyle(gender)
				if("body_type")
					if(slotlocked)
						return

					if(body_type == MALE)
						body_type = FEMALE
					else
						body_type = MALE
				if("body_model")
					if(slotlocked)
						return

					if(body_model == SLIM_BODY_MODEL_NUMBER)
						body_model = NORMAL_BODY_MODEL_NUMBER
					else if(body_model == NORMAL_BODY_MODEL_NUMBER)
						body_model = FAT_BODY_MODEL_NUMBER
					else if(body_model == FAT_BODY_MODEL_NUMBER)
						body_model = SLIM_BODY_MODEL_NUMBER
				if("hotkeys")
					hotkeys = !hotkeys
					if(hotkeys)
						winset(user, null, "input.focus=true input.background-color=[COLOR_INPUT_ENABLED]")
					else
						winset(user, null, "input.focus=true input.background-color=[COLOR_INPUT_DISABLED]")

				if("keybindings_capture")
					var/datum/keybinding/kb = GLOB.keybindings_by_name[href_list["keybinding"]]
					var/old_key = href_list["old_key"]
					CaptureKeybinding(user, kb, old_key)
					return

				if("keybindings_set")
					var/kb_name = href_list["keybinding"]
					if(!kb_name)
						user << browse(null, "window=capturekeypress")
						ShowChoices(user)
						return

					var/clear_key = text2num(href_list["clear_key"])
					var/old_key = href_list["old_key"]
					if(clear_key)
						if(key_bindings[old_key])
							key_bindings[old_key] -= kb_name
							LAZYADD(key_bindings["Unbound"], kb_name)
							if(!length(key_bindings[old_key]))
								key_bindings -= old_key
						user << browse(null, "window=capturekeypress")
						user.client.set_macros()
						user.client.update_special_keybinds()
						save_preferences()
						ShowChoices(user)
						return

					var/new_key = uppertext(href_list["key"])
					var/AltMod = text2num(href_list["alt"]) ? "Alt" : ""
					var/CtrlMod = text2num(href_list["ctrl"]) ? "Ctrl" : ""
					var/ShiftMod = text2num(href_list["shift"]) ? "Shift" : ""
					var/numpad = text2num(href_list["numpad"]) ? "Numpad" : ""
					// var/key_code = text2num(href_list["key_code"])

					if(GLOB._kbMap[new_key])
						new_key = GLOB._kbMap[new_key]

					var/full_key
					switch(new_key)
						if("Alt")
							full_key = "[new_key][CtrlMod][ShiftMod]"
						if("Ctrl")
							full_key = "[AltMod][new_key][ShiftMod]"
						if("Shift")
							full_key = "[AltMod][CtrlMod][new_key]"
						else
							full_key = "[AltMod][CtrlMod][ShiftMod][numpad][new_key]"
					if(kb_name in key_bindings[full_key]) //We pressed the same key combination that was already bound here, so let's remove to re-add and re-sort.
						key_bindings[full_key] -= kb_name
					if(key_bindings[old_key])
						key_bindings[old_key] -= kb_name
						if(!length(key_bindings[old_key]))
							key_bindings -= old_key
					key_bindings[full_key] += list(kb_name)
					key_bindings[full_key] = sort_list(key_bindings[full_key])

					user << browse(null, "window=capturekeypress")
					user.client.set_macros()
					user.client.update_special_keybinds()
					save_preferences()

				if("keybindings_reset")
					var/choice = tgui_alert(user, "Would you prefer 'hotkey' or 'classic' defaults?", "Setup keybindings", list("Hotkey", "Classic", "Cancel"))
					if(choice == "Cancel")
						ShowChoices(user)
						return
					hotkeys = (choice == "Hotkey")
					key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
					user.client.set_macros()
					user.client.update_special_keybinds()

				if("chat_on_map")
					chat_on_map = !chat_on_map
				if("see_chat_non_mob")
					see_chat_non_mob = !see_chat_non_mob
				if("see_rc_emotes")
					see_rc_emotes = !see_rc_emotes

				if("action_buttons")
					buttons_locked = !buttons_locked
				if("tgui_fancy")
					tgui_fancy = !tgui_fancy
				if("tgui_input_mode")
					tgui_input_mode = !tgui_input_mode
				if("tgui_large_buttons")
					tgui_large_buttons = !tgui_large_buttons
				if("tgui_swapped_buttons")
					tgui_swapped_buttons = !tgui_swapped_buttons
				if("tgui_lock")
					tgui_lock = !tgui_lock
				if("winflash")
					windowflashing = !windowflashing

				//here lies the badmins
				if("hear_adminhelps")
					user.client.toggleadminhelpsound()
				if("hear_prayers")
					user.client.toggle_prayer_sound()
				if("announce_login")
					user.client.toggleannouncelogin()
				if("combohud_lighting")
					toggles ^= COMBOHUD_LIGHTING
				if("toggle_dead_chat")
					user.client.deadchat()
				if("toggle_radio_chatter")
					user.client.toggle_hear_radio()
				if("toggle_prayers")
					user.client.toggleprayers()
				if("toggle_deadmin_always")
					toggles ^= DEADMIN_ALWAYS
				if("toggle_deadmin_antag")
					toggles ^= DEADMIN_ANTAGONIST
				if("toggle_deadmin_head")
					toggles ^= DEADMIN_POSITION_HEAD
				if("toggle_deadmin_security")
					toggles ^= DEADMIN_POSITION_SECURITY
				if("toggle_deadmin_silicon")
					toggles ^= DEADMIN_POSITION_SILICON
				if("toggle_ignore_cult_ghost")
					toggles ^= ADMIN_IGNORE_CULT_GHOST


				if("be_special")
					var/be_special_type = href_list["be_special_type"]
					if(be_special_type in be_special)
						be_special -= be_special_type
					else
						be_special += be_special_type

				if("toggle_random")
					if(slotlocked)
						return
					var/random_type = href_list["random_type"]
					if(randomise[random_type])
						randomise -= random_type
					else
						randomise[random_type] = TRUE

				if("friend")
					friend = !friend

				if("enemy")
					enemy = !enemy

				if("lover")
					lover = !lover

				if("nsfw_content_preference")
					nsfw_content_pref = !nsfw_content_pref

				if("show_flavor_text_when_masked")
					show_flavor_text_when_masked = !show_flavor_text_when_masked

				if("persistent_scars")
					persistent_scars = !persistent_scars

				if("clear_scars")
					var/path = "data/player_saves/[user.ckey[1]]/[user.ckey]/scars.sav"
					fdel(path)
					to_chat(user, "<span class='notice'>All scar slots cleared.</span>")

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if((toggles & SOUND_LOBBY) && user.client && isnewplayer(user))
						user.client.playtitlemusic()
					else
						user.stop_sound_channel(CHANNEL_LOBBYMUSIC)

				if("endofround_sounds")
					toggles ^= SOUND_ENDOFROUND

				if("combat_mode_sound")
					toggles ^= SOUND_COMBATMODE

				if("ghost_ears")
					if(isobserver(user.client.mob))
						if(isavatar(user.client.mob))
							return
						else
							chat_toggles ^= CHAT_GHOSTEARS
					else
						chat_toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					chat_toggles ^= CHAT_GHOSTSIGHT

				if("ghost_whispers")
					if(isobserver(user.client.mob))
						if(isavatar(user.client.mob))
							return
						else
							chat_toggles ^= CHAT_GHOSTWHISPER
					else
						chat_toggles ^= CHAT_GHOSTWHISPER

				if("ghost_radio")

					chat_toggles ^= CHAT_GHOSTRADIO

				if("ghost_pda")
					chat_toggles ^= CHAT_GHOSTPDA

				if("ghost_laws")
					chat_toggles ^= CHAT_GHOSTLAWS

				if("roll_mode")
					chat_toggles ^= CHAT_ROLL_INFO

				if("hear_login_logout")
					chat_toggles ^= CHAT_LOGIN_LOGOUT

				if("broadcast_login_logout")
					broadcast_login_logout = !broadcast_login_logout

				if("income_pings")
					chat_toggles ^= CHAT_BANKCARD

				if("pull_requests")
					chat_toggles ^= CHAT_PULLR

				if("allow_midround_antag")
					toggles ^= MIDROUND_ANTAG

				if("parallaxup")
					parallax = WRAP(parallax + 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent?.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("parallaxdown")
					parallax = WRAP(parallax - 1, PARALLAX_INSANE, PARALLAX_DISABLE + 1)
					if (parent?.mob.hud_used)
						parent.mob.hud_used.update_parallax_pref(parent.mob)

				if("ambientocclusion")
					ambientocclusion = !ambientocclusion
					if(length(parent?.screen))
						var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in parent.screen
						PM.backdrop(parent.mob)

				if("auto_fit_viewport")
					auto_fit_viewport = !auto_fit_viewport
					if(auto_fit_viewport && parent)
						parent.fit_viewport()

				if("old_discipline")
					old_discipline = !old_discipline

				if("widescreenpref")
					widescreenpref = !widescreenpref
					user.client.view_size.setDefault(getScreenSize(widescreenpref))

				if("pixel_size")
					switch(pixel_size)
						if(PIXEL_SCALING_AUTO)
							pixel_size = PIXEL_SCALING_1X
						if(PIXEL_SCALING_1X)
							pixel_size = PIXEL_SCALING_1_2X
						if(PIXEL_SCALING_1_2X)
							pixel_size = PIXEL_SCALING_2X
						if(PIXEL_SCALING_2X)
							pixel_size = PIXEL_SCALING_3X
						if(PIXEL_SCALING_3X)
							pixel_size = PIXEL_SCALING_AUTO
					user.client.view_size.apply() //Let's winset() it so it actually works

				if("scaling_method")
					switch(scaling_method)
						if(SCALING_METHOD_NORMAL)
							scaling_method = SCALING_METHOD_DISTORT
						if(SCALING_METHOD_DISTORT)
							scaling_method = SCALING_METHOD_BLUR
						if(SCALING_METHOD_BLUR)
							scaling_method = SCALING_METHOD_NORMAL
					user.client.view_size.setZoomMode()

				if("save")
					if(tgui_alert(user, "Are you finished with your setup?", "Confirmation", list("Yes", "No")) == "Yes")
						slotlocked = 1
						save_preferences()
						save_character()

				if("load")
					load_preferences()
					load_character()

				if("reset_all")
					if (tgui_alert(user, "Are you sure you want to reset your character?", "Confirmation", list("Yes", "No")) != "Yes")
						return
					player_experience += experience_used_on_character
					reset_character()

				if("changeslot")
					if(!load_character(text2num(href_list["num"])))
						reset_character()

				if("tab")
					if (href_list["tab"])
						current_tab = text2num(href_list["tab"])
						if(current_tab == 2) // TFN ADDITION: loadout
							show_loadout = TRUE // TFN ADDITION: loadout

				if("clear_heart")
					hearted = FALSE
					hearted_until = null
					to_chat(user, "<span class='notice'>OOC Commendation Heart disabled</span>")
					save_preferences()

	save_preferences()
	save_character()
	ShowChoices(user)
	return TRUE

/datum/preferences/proc/handle_upgrade(number, cost)
	if ((player_experience < cost) || (number >= ATTRIBUTE_BASE_LIMIT))
		return FALSE
	player_experience -= cost
	experience_used_on_character += cost
	return TRUE

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1, roundstart_checks = TRUE, character_setup = FALSE, antagonist = FALSE, is_latejoiner = TRUE, loadout = FALSE) // TFN EDIT: original: remove "loadout = FALSE"

	hardcore_survival_score = 0 //Set to 0 to prevent you getting points from last another time.

	if((randomise[RANDOM_SPECIES] || randomise[RANDOM_HARDCORE]) && !character_setup)
		random_species()

	if((randomise[RANDOM_BODY] || (randomise[RANDOM_BODY_ANTAG] && antagonist) || randomise[RANDOM_HARDCORE]) && !character_setup)
		slot_randomized = TRUE
		random_character(gender, antagonist)

	if((randomise[RANDOM_NAME] || (randomise[RANDOM_NAME_ANTAG] && antagonist) || randomise[RANDOM_HARDCORE]) && !character_setup)
		slot_randomized = TRUE
		real_name = pref_species.random_name(gender)

	if(randomise[RANDOM_HARDCORE] && parent?.mob.mind && !character_setup)
		if(can_be_random_hardcore())
			hardcore_random_setup(character, antagonist, is_latejoiner)

	if(roundstart_checks)
		if(CONFIG_GET(flag/humans_need_surnames) && (pref_species.id == "human"))
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(GLOB.last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(GLOB.last_names)]"

	character.real_name = real_name
	character.true_real_name = real_name
	character.name = character.real_name

	character.flavor_text = sanitize_text(flavor_text)
	character.flavor_text_nsfw = sanitize_text(flavor_text_nsfw)
	character.ooc_notes = sanitize_text(ooc_notes)
	character.character_notes = sanitize_text(character_notes)
	character.show_flavor_text_when_masked = show_flavor_text_when_masked
	character.headshot_link = headshot_link

	character.age = age
	character.chronological_age = total_age

	character.gender = gender
	if(gender == MALE || gender == FEMALE)
		character.body_type = gender
	else
		character.body_type = body_type

	character.eye_color = eye_color
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		if(!initial(organ_eyes.eye_color))
			organ_eyes.eye_color = eye_color
		organ_eyes.old_eye_color = eye_color

	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color
	character.hairstyle = hairstyle
	character.facial_hairstyle = facial_hairstyle
	character.underwear = underwear
	character.underwear_color = underwear_color
	character.undershirt = undershirt
	character.socks = socks
	character.backpack = backpack
	character.jumpsuit_style = jumpsuit_style
	character.skin_tone = skin_tone

	var/datum/species/chosen_species
	chosen_species = pref_species.type
	character.dna.features = features.Copy()
	character.set_species(chosen_species, icon_update = FALSE, pref_load = TRUE)
	character.dna.real_name = character.real_name

	character.diablerist = diablerist

	character.physique = physique
	character.dexterity = dexterity
	character.social = social
	character.mentality = mentality
	character.blood = blood
	character.lockpicking = lockpicking
	character.athletics = athletics

	var/datum/archetype/A = new archetype()
	character.additional_physique = A.archetype_additional_physique
	character.additional_dexterity = A.archetype_additional_dexterity
	character.additional_social = A.archetype_additional_social
	character.additional_mentality = A.archetype_additional_mentality
	character.additional_blood = A.archetype_additional_blood
	character.additional_lockpicking = A.archetype_additional_lockpicking
	character.additional_athletics = A.archetype_additional_athletics
	A.special_skill(character)

	character.masquerade = masquerade
	if(!character_setup)
		if(character in GLOB.masquerade_breakers_list)
			if(character.masquerade > 2)
				GLOB.masquerade_breakers_list -= character
		else if(character.masquerade < 3)
			GLOB.masquerade_breakers_list += character

	switch (body_model)
		if (SLIM_BODY_MODEL_NUMBER)
			character.set_body_model(SLIM_BODY_MODEL)
		if (NORMAL_BODY_MODEL_NUMBER)
			character.set_body_model(NORMAL_BODY_MODEL)
		if (FAT_BODY_MODEL_NUMBER)
			character.set_body_model(FAT_BODY_MODEL)

	character.maxHealth = round((initial(character.maxHealth)+(initial(character.maxHealth)/4)*(character.physique + character.additional_physique)))
	character.health = character.maxHealth

	if (pref_species.name == "Kuei-Jin")
		character.yang_chi = yang
		character.max_yang_chi = yang
		character.yin_chi = yin
		character.max_yin_chi = yin
		character.max_demon_chi = po
	else
		character.yang_chi = 3
		character.max_yang_chi = 3
		character.yin_chi = 2
		character.max_yin_chi = 2

	if(pref_species.name == "Vampire")
		character.skin_tone = get_vamp_skin_color(skin_tone)

		var/datum/morality/MOR = new morality_path.type()
		character.morality_path = MOR

		character.generation = generation
		character.maxbloodpool = 10 + ((13 - generation) * 3)
		character.bloodpool = rand(2, character.maxbloodpool)

		character.set_clan(clan, TRUE)

		character.max_yin_chi = character.maxbloodpool
		character.yin_chi = character.max_yin_chi

		// TODO: detach is_enlightened from the clan datum
		// Apply Clan accessory
		if (character.clan?.accessories?.Find(clan_accessory))
			var/accessory_layer = character.clan.accessories_layers[clan_accessory]
			character.remove_overlay(accessory_layer)
			var/mutable_appearance/acc_overlay = mutable_appearance('code/modules/wod13/icons.dmi', clan_accessory, -accessory_layer)
			character.overlays_standing[accessory_layer] = acc_overlay
			character.apply_overlay(accessory_layer)

		character.morality_path.score = path_score
	else
		character.set_clan(null)
		character.morality_path = null
		character.generation = 13
		character.bloodpool = character.maxbloodpool

	if(pref_species.name == "Werewolf")
		switch(tribe.name)
			if("Galestalkers","Children of Gaia","Ghost Council","Hart Wardens", "Corax")
				character.yin_chi = 1
				character.max_yin_chi = 1
				character.yang_chi = 5 + (auspice_level * 2)
				character.max_yang_chi = 5 + (auspice_level * 2)
			if("Glass Walkers","Bone Gnawers")
				character.yin_chi = 1 + auspice_level
				character.max_yin_chi = 1 + auspice_level
				character.yang_chi = 5 + auspice_level
				character.max_yang_chi = 5 + auspice_level
			if("Black Spiral Dancers","Ghost Council")
				character.yin_chi = 1 + auspice_level * 2
				character.max_yin_chi = 1 + auspice_level * 2
				character.yang_chi = 5
				character.max_yang_chi = 5
		character.honor = honor
		character.wisdom = wisdom
		character.glory = glory
		character.renownrank = renownrank

		var/datum/auspice/CLN = new auspice.type()
		character.auspice = CLN
		character.auspice.level = auspice_level
		character.auspice.tribe = tribe
		character.auspice.on_gain(character)

		switch(breed)
			if("Homid")
				character.auspice.gnosis = 1
				character.auspice.start_gnosis = 1
				character.auspice.base_breed = "Homid"
			if("Lupus")
				character.auspice.gnosis = 5
				character.auspice.start_gnosis = 5
				character.auspice.base_breed = "Lupus"
			if("Metis")
				character.auspice.gnosis = 3
				character.auspice.start_gnosis = 3
				character.auspice.base_breed = "Crinos"
		if(character.transformator?.crinos_form && character.transformator?.lupus_form && !HAS_TRAIT(character,TRAIT_CORAX))
			var/mob/living/simple_animal/werewolf/crinos/crinos = character.transformator.crinos_form?.resolve()
			var/mob/living/simple_animal/werewolf/lupus/lupus = character.transformator.lupus_form?.resolve()

			if(!crinos)
				character.transformator.crinos_form = null
				CRASH("[key_name(character)]'s crinos_form weakref contained no crinos mob!")
			if(!lupus)
				character.transformator.lupus_form = null
				CRASH("[key_name(character)]'s lupus_form weakref contained no lupus mob!")

			crinos.sprite_color = werewolf_color
			crinos.sprite_scar = werewolf_scar
			crinos.sprite_hair = werewolf_hair
			crinos.sprite_hair_color = werewolf_hair_color
			crinos.sprite_eye_color = werewolf_eye_color
			lupus.sprite_color = werewolf_color
			lupus.sprite_eye_color = werewolf_eye_color

			if(werewolf_name)
				crinos.real_name = werewolf_name
				crinos.true_real_name = werewolf_name
				crinos.name = werewolf_name
				lupus.real_name = werewolf_name
				lupus.true_real_name = werewolf_name
				lupus.name = werewolf_name
			else
				crinos.real_name = real_name
				crinos.true_real_name = real_name
				crinos.name = real_name
				lupus.real_name = real_name
				lupus.true_real_name = real_name
				lupus.name = real_name
			crinos.physique = physique
			crinos.dexterity = dexterity
			crinos.mentality = mentality
			crinos.social = social
			crinos.blood = blood

			lupus.physique = physique
			lupus.dexterity = dexterity
			lupus.mentality = mentality
			lupus.social = social
			lupus.blood = blood

			lupus.maxHealth = round((lupus::maxHealth + (character::maxHealth / 4) * (character.physique + character.additional_physique))) + (character.auspice.level - 1) * 50
			lupus.health = lupus.maxHealth
			crinos.maxHealth = round((crinos::maxHealth + (character::maxHealth / 4) * (character.physique + character.additional_physique))) + (character.auspice.level - 1) * 50
			crinos.health = crinos.maxHealth
		else if(HAS_TRAIT(character,TRAIT_CORAX)/*character.transformator?.corax_form && character.transformator?.corvid_form*/) // if we have the Corax tribe, use the Corax forms instead..
			var/mob/living/simple_animal/werewolf/corax/corax_crinos/cor_crinos = character.transformator.corax_form?.resolve()
			var/mob/living/simple_animal/werewolf/lupus/corvid/corvid = character.transformator.corvid_form?.resolve()

			if(!cor_crinos)
				character.transformator.corax_form = null
				CRASH("[key_name(character)]'s corax_form weakref contained no corax crinos mob!")
			if(!corvid)
				character.transformator.corvid_form = null
				CRASH("[key_name(character)]'s corvid_form weakref contained no corvid mob!")

			cor_crinos.sprite_color = werewolf_color
			//cor_crinos.icon_state = werewolf_color // gotta use Icon state for this one apparently
			cor_crinos.sprite_scar = werewolf_scar
			cor_crinos.sprite_hair = werewolf_hair
			cor_crinos.sprite_hair_color = werewolf_hair_color
			cor_crinos.sprite_eye_color = werewolf_eye_color
			corvid.sprite_color = werewolf_color
			corvid.sprite_eye_color = werewolf_eye_color

			if(werewolf_name)
				cor_crinos.name = werewolf_name
				corvid.name = werewolf_name
			else
				cor_crinos.name = real_name
				corvid.name = real_name

			cor_crinos.physique = physique
			cor_crinos.dexterity = dexterity
			cor_crinos.mentality = mentality
			cor_crinos.social = social
			cor_crinos.blood = blood

			corvid.physique = physique
			corvid.dexterity = dexterity
			corvid.mentality = mentality
			corvid.social = social
			corvid.athletics = athletics // corvid also get athletics so that they can jump further, might be absolutely batshit though
			corvid.blood = blood

			corvid.maxHealth = round((corvid::maxHealth + (character::maxHealth / 4) * (character.physique + character.additional_physique))) + (character.auspice.level - 1) * 50
			corvid.health = corvid.maxHealth
			cor_crinos.maxHealth = round((cor_crinos::maxHealth + (character::maxHealth / 4) * (character.physique + character.additional_physique))) + (character.auspice.level - 1) * 50
			cor_crinos.health = cor_crinos.maxHealth

	// TFN ADDITION START: loadout
	if(loadout)
		for(var/gear in equipped_gear)
			var/datum/gear/G = GLOB.gear_datums[gear]
			if(G?.slot)
				if(!character.equip_to_slot_or_del(G.spawn_item(character, character), G.slot))
					continue
	// TFN ADDITION END: loadout

	if(pref_species.mutant_bodyparts["tail_lizard"])
		character.dna.species.mutant_bodyparts["tail_lizard"] = pref_species.mutant_bodyparts["tail_lizard"]
	if(pref_species.mutant_bodyparts["spines"])
		character.dna.species.mutant_bodyparts["spines"] = pref_species.mutant_bodyparts["spines"]

	if(icon_updates)
		character.update_body()
		character.update_hair()
		character.update_body_parts()
	if(!character_setup)
		parent << browse(null, "window=preferences_window")
		parent << browse(null, "window=preferences_browser")

/datum/preferences/proc/can_be_random_hardcore()
	if(parent && (parent.mob.mind?.assigned_role in GLOB.command_positions)) //No command staff
		return FALSE
	for(var/A in parent?.mob.mind?.antag_datums)
		var/datum/antagonist/antag
		if(antag.get_team()) //No team antags
			return FALSE
	return TRUE

/datum/preferences/proc/get_default_name(name_id)
	switch(name_id)
		if("human")
			return random_unique_name()
		if("ai")
			return pick(GLOB.ai_names)
		if("cyborg")
			return DEFAULT_CYBORG_NAME
		if("clown")
			return pick(GLOB.clown_names)
		if("mime")
			return pick(GLOB.mime_names)
		if("religion")
			return DEFAULT_RELIGION
		if("deity")
			return DEFAULT_DEITY
	return random_unique_name()

/datum/preferences/proc/ask_for_custom_name(mob/user,name_id)
	var/namedata = GLOB.preferences_custom_names[name_id]
	if(!namedata)
		return

	var/raw_name = tgui_input_text(user, "Choose your character's [namedata["qdesc"]]:","Character Preference", max_length = MAX_NAME_LEN)
	if(!raw_name)
		if(namedata["allow_null"])
			custom_names[name_id] = get_default_name(name_id)
		else
			return
	else
		var/sanitized_name = reject_bad_name(raw_name,namedata["allow_numbers"])
		if(!sanitized_name)
			to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, [namedata["allow_numbers"] ? "0-9, " : ""]-, ' and . It must not contain any words restricted by IC chat and name filters.</font>")
			return
		else
			custom_names[name_id] = sanitized_name

/datum/preferences/proc/RenownRequirements()
	var/gloryy = "Glory"
	var/honorr = "Honor"
	var/wisdomm = "Wisdom"
	var/stringtoreturn
	if(tribe.name == "Black Spiral Dancers")
		gloryy = "Infamy"
		honorr = "Power"
		wisdomm = "Cunning"
	switch(auspice.name)
		if("Ahroun")
			switch(renownrank)
				if(0)
					stringtoreturn = "2 [gloryy], 1 [honorr]"
					return stringtoreturn

				if(1)
					stringtoreturn = "4 [gloryy], 1 [honorr], 1 [wisdomm]"
					return stringtoreturn

				if(2)
					stringtoreturn = "6 [gloryy], 3 [honorr], 1 [wisdomm]"
					return stringtoreturn

				if(3)
					stringtoreturn = "9 [gloryy], 4 [honorr], 2 [wisdomm]"
					return stringtoreturn

				if(4)
					stringtoreturn = "10 [gloryy], 9 [honorr], 4 [wisdomm]"
					return stringtoreturn


		if("Galliard")
			switch(renownrank)
				if(0)
					stringtoreturn = "2 [gloryy], 1 [wisdomm]"
					return stringtoreturn

				if(1)
					stringtoreturn = "4 [gloryy], 2 [wisdomm]"
					return stringtoreturn

				if(2)
					stringtoreturn = "4 [gloryy], 2[honorr], 4 [wisdomm]"
					return stringtoreturn

				if(3)
					stringtoreturn = "7 [gloryy], 2 [honorr], 6 [wisdomm]"
					return stringtoreturn

				if(4)
					stringtoreturn = "9 [gloryy], 5 [honorr], 9 [wisdomm]"
					return stringtoreturn


		if("Philodox")
			switch(renownrank)
				if(0)
					stringtoreturn = "3 [honorr]"
					return stringtoreturn

				if(1)
					stringtoreturn = "1 [gloryy], 4 [honorr], 1 [wisdomm]"
					return stringtoreturn

				if(2)
					stringtoreturn = "2 [gloryy], 6 [honorr], 2 [wisdomm]"
					return stringtoreturn

				if(3)
					stringtoreturn = "3 [gloryy], 8 [honorr], 4 [wisdomm]"
					return stringtoreturn

				if(4)
					stringtoreturn = "4 [gloryy], 10 [honorr], 9 [wisdomm]"
					return stringtoreturn


		if("Theurge")
			switch(renownrank)
				if(0)
					stringtoreturn = "3 [wisdomm]"
					return stringtoreturn

				if(1)
					stringtoreturn = "1 [gloryy], 5 [wisdomm]"
					return stringtoreturn

				if(2)
					stringtoreturn = "2 [gloryy], 1 [honorr], 7 [wisdomm]"
					return stringtoreturn

				if(3)
					stringtoreturn = "4 [gloryy], 2 [honorr], 9 [wisdomm]"
					return stringtoreturn

				if(4)
					stringtoreturn = "4 [gloryy], 9 [honorr], 10 [wisdomm]"
					return stringtoreturn


		if("Ragabash")
			switch(renownrank)
				if(0)
					stringtoreturn = "3 Total"
					return stringtoreturn

				if(1)
					stringtoreturn = "7 Total"
					return stringtoreturn

				if(2)
					stringtoreturn = "13 Total"
					return stringtoreturn

				if(3)
					stringtoreturn = "19 Total"
					return stringtoreturn

				if(4)
					stringtoreturn = "25 Total"
					return stringtoreturn

/datum/preferences/proc/AuspiceRankUp()
	switch(auspice.name)
		if("Ahroun")
			switch(renownrank)
				if(0)
					if(glory >= 2 && honor >= 1) return TRUE
				if(1)
					if(glory >= 4 && honor >= 1 && wisdom >= 1) return TRUE
				if(2)
					if(glory >= 6 && honor >= 3 && wisdom >= 1) return TRUE
				if(3)
					if(glory >= 9 && honor >= 4 && wisdom >= 2) return TRUE
				if(4)
					if(glory >= 10 && honor >= 9 && wisdom >= 4) return TRUE

		if("Galliard")
			switch(renownrank)
				if(0)
					if(glory >= 2 && wisdom >= 1) return TRUE
				if(1)
					if(glory >= 4 && wisdom >= 2) return TRUE
				if(2)
					if(glory >= 4 && honor >= 2 && wisdom >= 4) return TRUE
				if(3)
					if(glory >= 7 && honor >= 2 && wisdom >= 6) return TRUE
				if(4)
					if(glory >= 9 && honor >= 5 && wisdom >= 9) return TRUE

		if("Philodox")
			switch(renownrank)
				if(0)
					if(honor >= 3) return TRUE
				if(1)
					if(glory >= 1 && honor >= 4 && wisdom >= 1) return TRUE
				if(2)
					if(glory >= 2 && honor >= 6 && wisdom >= 2) return TRUE
				if(3)
					if(glory >= 3 && honor >= 8 && wisdom >= 4) return TRUE
				if(4)
					if(glory >= 4 && honor >= 10 && wisdom >= 9) return TRUE

		if("Theurge")
			switch(renownrank)
				if(0)
					if(wisdom >= 3) return TRUE
				if(1)
					if(glory >= 1 && wisdom >= 5) return TRUE
				if(2)
					if(glory >= 2 && honor >= 1 && wisdom >= 7) return TRUE
				if(3)
					if(glory >= 4 && honor >= 2 && wisdom >= 9) return TRUE
				if(4)
					if(glory >= 4 && honor >= 9 && wisdom >= 10) return TRUE

		if("Ragabash")
			switch(renownrank)
				if(0)
					if((glory+honor+wisdom) >= 3) return TRUE
				if(1)
					if((glory+honor+wisdom) >= 7) return TRUE
				if(2)
					if((glory+honor+wisdom) >= 13) return TRUE
				if(3)
					if((glory+honor+wisdom) >= 19) return TRUE
				if(4)
					if((glory+honor+wisdom) >= 25) return TRUE

	return FALSE
